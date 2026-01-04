import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../models/search_result.dart';
import '../widgets/search_result_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class SearchScreenInternal extends StatefulWidget {
  final ScrollController scrollController;
  
  const SearchScreenInternal({
    super.key,
    required this.scrollController,
  });

  @override
  State<SearchScreenInternal> createState() => _SearchScreenInternalState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SearchScreenInternal(scrollController: _scrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _SearchScreenInternalState extends State<SearchScreenInternal> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _searchQuery = '';
  List<SearchResult> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch(String query) async {
    setState(() {
      _isLoading = true;
      _searchQuery = query;
    });

    // TODO: Implement actual search logic here
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // Dummy data for demonstration
      setState(() {
        _searchResults = [
          const SearchResult(
            id: '1',
            title: 'Red Wine Collection',
            description: 'Premium selection of red wines from around the world',
            type: SearchResultType.bottle,
          ),
          const SearchResult(
            id: '2',
            title: 'Wine Tasting Event',
            description: 'Join us for an evening of wine tasting and networking',
            type: SearchResultType.event,
          ),
          const SearchResult(
            id: '3',
            title: 'John Sommelier',
            description: 'Wine expert and collector',
            type: SearchResultType.user,
          ),
        ];
        _isLoading = false;
      });
    }
  }

  void _handleResultTap(SearchResult result) {
    // TODO: Implement navigation based on result type
    switch (result.type) {
      case SearchResultType.bottle:
        // Navigate to bottle detail
        break;
      case SearchResultType.event:
        // Navigate to event detail
        break;
      case SearchResultType.user:
        // Navigate to user profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search clubs, events, bottles...',
                      prefixIcon: const Icon(Iconsax.search_normal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Iconsax.close_circle),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _searchResults.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {});
                      if (value.length > 2) {
                        _handleSearch(value);
                      } else if (value.isEmpty) {
                        setState(() {
                          _searchResults.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            // Search Results
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_searchQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.search_normal,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Start typing to search',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Center(
        child: LoadingAnimationWidget.inkDrop(
          color: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.search_status,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: widget.scrollController,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom + 16,
      ),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return SearchResultTile(
          result: result,
          onTap: () => _handleResultTap(result),
        );
      },
    );
  }
} 