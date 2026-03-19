import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  
  bool _isLoading = false;
  bool _isUploadingImage = false;
  File? _selectedImage;
  String? _currentAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final authState = ref.read(authStateProvider);
    await authState.maybeMap(
      authenticated: (state) async {
        final user = state.user;
        
        // Load data from auth metadata first
        _nameController.text = user.userMetadata?['name'] ?? '';
        _emailController.text = user.email ?? '';
        _currentAvatarUrl = user.userMetadata?['avatar_url'];
        
        // Then load additional data from profiles table
        try {
          final profileData = await Supabase.instance.client
              .from('profiles')
              .select('name, phone_number, age, avatar_url')
              .eq('id', user.id)
              .maybeSingle();
              
          if (profileData != null && mounted) {
            setState(() {
              _nameController.text = profileData['name'] ?? _nameController.text;
              _phoneController.text = profileData['phone_number'] ?? '';
              _ageController.text = profileData['age']?.toString() ?? '';
              _currentAvatarUrl = profileData['avatar_url'] ?? _currentAvatarUrl;
            });
          }
        } catch (e) {
          debugPrint('Error loading profile: $e');
        }
      },
      orElse: () {},
    );
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final authState = ref.read(authStateProvider);
    return await authState.maybeMap(
      authenticated: (state) async {
        try {
          setState(() {
            _isUploadingImage = true;
          });

          final userId = state.user.id;
          final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final filePath = '$userId/$fileName';

          debugPrint('Starting image upload...');
          debugPrint('User ID: $userId');
          debugPrint('File path: $filePath');
          debugPrint('File size: ${await imageFile.length()} bytes');

          // Check if file exists and is readable
          if (!await imageFile.exists()) {
            throw Exception('Image file does not exist');
          }

          // Delete old avatar if exists
          if (_currentAvatarUrl != null) {
            try {
              final oldPath = _currentAvatarUrl!.split('/').last;
              debugPrint('Deleting old avatar: $userId/$oldPath');
              await Supabase.instance.client.storage
                  .from('profile-pictures')
                  .remove(['$userId/$oldPath']);
            } catch (e) {
              debugPrint('Error deleting old avatar: $e');
            }
          }

          // Upload new image
          debugPrint('Uploading new image...');
          final uploadResult = await Supabase.instance.client.storage
              .from('profile-pictures')
              .upload(
                filePath,
                imageFile,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: true,
                ),
              );

          debugPrint('Upload successful: $uploadResult');

          // Get public URL
          final publicUrl = Supabase.instance.client.storage
              .from('profile-pictures')
              .getPublicUrl(filePath);

          debugPrint('Public URL: $publicUrl');
          return publicUrl;
        } catch (e) {
          debugPrint('Upload error: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error uploading image: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
          return null;
        } finally {
          setState(() {
            _isUploadingImage = false;
          });
        }
      },
      orElse: () {
        debugPrint('User not authenticated for image upload');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please log in to upload images'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return null;
      },
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authState = ref.read(authStateProvider);
      await authState.maybeMap(
        authenticated: (state) async {
          final userId = state.user.id;
          String? avatarUrl = _currentAvatarUrl;

          // Upload image if selected
          if (_selectedImage != null) {
            avatarUrl = await _uploadImage(_selectedImage!);
            if (avatarUrl == null) return; // Upload failed
          }

          // Update profiles table
          await Supabase.instance.client
              .from('profiles')
              .upsert({
                'id': userId,
                'name': _nameController.text.trim(),
                'email': _emailController.text.trim(),
                'phone_number': _phoneController.text.trim().isEmpty 
                    ? null 
                    : _phoneController.text.trim(),
                'age': _ageController.text.trim().isEmpty 
                    ? null 
                    : int.tryParse(_ageController.text.trim()),
                'avatar_url': avatarUrl,
                'updated_at': DateTime.now().toIso8601String(),
              });

          // Update auth metadata
          await Supabase.instance.client.auth.updateUser(
            UserAttributes(
              data: {
                'name': _nameController.text.trim(),
                'avatar_url': avatarUrl,
              },
            ),
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          }
        },
        orElse: () {},
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : _currentAvatarUrl != null
                              ? Image.network(
                                  _currentAvatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Iconsax.user, size: 60),
                                )
                              : Container(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: const Icon(Iconsax.user, size: 60),
                                ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _isUploadingImage ? null : _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: _isUploadingImage
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Iconsax.camera,
                                color: Colors.white,
                                size: 16,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(32),

            // Form Fields
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Iconsax.user),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const Gap(16),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Iconsax.sms),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              enabled: false, // Email cannot be changed
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const Gap(16),

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number (Optional)',
                prefixIcon: Icon(Iconsax.call),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  if (!RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                }
                return null;
              },
            ),
            const Gap(16),

            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age (Optional)',
                prefixIcon: Icon(Iconsax.calendar),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final age = int.tryParse(value);
                  if (age == null || age < 18 || age > 100) {
                    return 'Please enter a valid age (18-100)';
                  }
                }
                return null;
              },
            ),
            const Gap(32),

            // Additional Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Gap(8),
                    const Text(
                      '• Your email cannot be changed here. Contact support if needed.\n'
                      '• Profile picture is stored securely and only you can modify it.\n'
                      '• All information is optional except your name.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 