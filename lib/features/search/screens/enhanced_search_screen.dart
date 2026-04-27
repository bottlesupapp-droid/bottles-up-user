import 'package:flutter/material.dart';
import '../models/search_filter.dart';
import '../services/search_service.dart';
import '../widgets/search_filter_sheet.dart';
import '../widgets/search_result_card.dart';

class EnhancedSearchScreen extends StatefulWidget {
  const EnhancedSearchScreen({super.key});

  @override
  State<EnhancedSearchScreen> createState() => _EnhancedSearchScreenState();
}

class _EnhancedSearchScreenState extends State<EnhancedSearchScreen> {
  final _searchService = SearchService();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  List<SearchResult> _results = [];
  List<SearchSuggestion> _suggestions = [];
  List<String> _trendingSearches = [];
  List<SearchHistory> _searchHistory = [];

  SearchFilter? _currentFilter;
  bool _isLoading = false;
  bool _showSuggestions = false;
  String _selectedTab = 'all'; // all, events, venues

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final trending = await _searchService.getTrendingSearches();
      final history = await _searchService.getSearchHistory(limit: 10);

      setState(() {
        _trendingSearches = trending;
        _searchHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() async {
    final query = _searchController.text;

    if (query.isEmpty) {
      setState(() {
        _showSuggestions = false;
        _suggestions = [];
      });
      return;
    }

    setState(() => _showSuggestions = true);

    if (query.length >= 2) {
      final suggestions = await _searchService.getSuggestions(query);
      setState(() => _suggestions = suggestions);
    }
  }

  Future<void> _performSearch([String? query]) async {
    final searchQuery = query ?? _searchController.text;
    if (searchQuery.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showSuggestions = false;
    });

    try {
      List<SearchResult> results;

      switch (_selectedTab) {
        case 'events':
          results = await _searchService.searchEvents(
            query: searchQuery,
            filters: _currentFilter,
          );
          break;
        case 'venues':
          results = await _searchService.searchVenues(
            query: searchQuery,
            filters: _currentFilter,
          );
          break;
        default:
          results = await _searchService.search(
            query: searchQuery,
            filters: _currentFilter,
          );
      }

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _onScroll() {
    // Implement pagination when scrolling to bottom
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more results
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SearchFilterSheet(
        currentFilter: _currentFilter,
        onApply: (filter) {
          setState(() => _currentFilter = filter);
          _performSearch();
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() => _currentFilter = null);
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search events, venues...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _results = []);
                    },
                  )
                : null,
          ),
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _currentFilter != null,
              child: const Icon(Icons.tune),
            ),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          _buildTabBar(),

          // Filter chips
          if (_currentFilter != null) _buildActiveFilters(),

          // Content
          Expanded(
            child: _showSuggestions
                ? _buildSuggestions()
                : _results.isEmpty
                    ? _buildEmptyState()
                    : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTabButton('All', 'all'),
          const SizedBox(width: 8),
          _buildTabButton('Events', 'events'),
          const SizedBox(width: 8),
          _buildTabButton('Venues', 'venues'),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String value) {
    final isSelected = _selectedTab == value;
    return Expanded(
      child: FilledButton(
        onPressed: () {
          setState(() => _selectedTab = value);
          if (_searchController.text.isNotEmpty) {
            _performSearch();
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: isSelected
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Chip(
            label: const Text('Clear all'),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: _clearFilters,
          ),
          const SizedBox(width: 8),
          // Add more filter chips based on active filters
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return ListTile(
          leading: Icon(_getSuggestionIcon(suggestion.type)),
          title: Text(suggestion.text),
          subtitle: suggestion.subtitle != null
              ? Text(suggestion.subtitle!)
              : null,
          onTap: () {
            _searchController.text = suggestion.text;
            _performSearch(suggestion.text);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No results found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filters',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_trendingSearches.isNotEmpty) ...[
            const Text(
              'Trending Searches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _trendingSearches
                  .map((search) => ActionChip(
                        label: Text(search),
                        avatar: const Icon(Icons.trending_up, size: 18),
                        onPressed: () {
                          _searchController.text = search;
                          _performSearch(search);
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],
          if (_searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () async {
                    await _searchService.clearSearchHistory();
                    setState(() => _searchHistory = []);
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...(_searchHistory.map((history) => ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(history.query),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      _searchController.text = history.query;
                      _performSearch(history.query);
                    },
                  ),
                ))),
          ],
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return SearchResultCard(result: result);
      },
    );
  }

  IconData _getSuggestionIcon(String type) {
    switch (type) {
      case 'event':
        return Icons.event;
      case 'venue':
        return Icons.place;
      case 'category':
        return Icons.category;
      default:
        return Icons.search;
    }
  }
}
