import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/profile/controllers/profile_controller.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _businessController;
  late TextEditingController _bankNameController;
  late TextEditingController _accountNameController;
  late TextEditingController _accountNumberController;

  File? _pickedImageFile;  // Local preview before upload
  bool _isUploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileController>().profile;
    _nameController = TextEditingController(text: profile?.displayName ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _businessController = TextEditingController(text: profile?.businessName ?? '');
    _bankNameController = TextEditingController(text: profile?.bankName ?? '');
    _accountNameController = TextEditingController(text: profile?.accountName ?? '');
    _accountNumberController = TextEditingController(text: profile?.accountNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            const Text('Change Profile Photo', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 20),
            ListTile(
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
              ),
              title: const Text('Take Photo', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Use your camera'),
            ),
            const SizedBox(height: 8),
            ListTile(
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.photo_library_rounded, color: Colors.purple),
              ),
              title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Pick an existing photo'),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (picked != null && mounted) {
      setState(() => _pickedImageFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        actions: [
          Consumer<ProfileController>(
            builder: (context, profile, _) {
              return TextButton(
                onPressed: profile.isSaving ? null : _saveProfile,
                child: Text(
                  profile.isSaving ? 'Saving...' : 'Save',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 150),
            child: Column(
              children: [
                _buildPhotoSection(),
                _buildFormSection(),
              ],
            ),
          ),
          _buildStickyFooter(),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    final profile = context.watch<ProfileController>().profile;
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Stack(
              children: [
                // Avatar circle
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 3),
                    color: AppColors.lightGrey,
                  ),
                  child: ClipOval(
                    child: _pickedImageFile != null
                        // Show local preview
                        ? Image.file(_pickedImageFile!, fit: BoxFit.cover)
                        : (profile?.avatarPath != null
                            // Show saved avatar
                            ? Image.network(
                                profile!.avatarPath!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildInitialsAvatar(profile.initials),
                              )
                            // Show initials fallback
                            : _buildInitialsAvatar(profile?.initials ?? '?')),
                  ),
                ),
                // Camera badge
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: _isUploadingPhoto
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.photo_camera_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _pickedImageFile != null ? '✓ Photo selected — save to apply' : 'Change Profile Photo',
              style: TextStyle(
                color: _pickedImageFile != null ? Colors.green.shade600 : AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      color: AppColors.primary.withOpacity(0.15),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.primary),
      ),
    );
  }

  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('FULL NAME', _nameController, Icons.person_outline_rounded),
          const SizedBox(height: 24),
          _buildTextField('EMAIL ADDRESS', _emailController, Icons.mail_outline_rounded),
          const SizedBox(height: 24),
          _buildTextField('PHONE NUMBER', _phoneController, Icons.phone_android_rounded),
          const SizedBox(height: 24),
          _buildTextField('BUSINESS NAME', _businessController, Icons.corporate_fare_rounded),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text('PAYMENT DETAILS', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          ),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 24),
          _buildTextField('BANK NAME', _bankNameController, Icons.account_balance_rounded),
          const SizedBox(height: 24),
          _buildTextField('ACCOUNT NAME', _accountNameController, Icons.badge_rounded),
          const SizedBox(height: 24),
          _buildTextField('ACCOUNT NUMBER', _accountNumberController, Icons.numbers_rounded),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Changing your bank details will affect all future invoices generated.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
              suffixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStickyFooter() {
    final profile = context.watch<ProfileController>();
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(top: BorderSide(color: AppColors.lightGrey.withOpacity(0.5))),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -10))],
        ),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: profile.isSaving ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: profile.isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Changes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Discard Changes', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final ctrl = context.read<ProfileController>();

    // 1. Upload avatar if a new image was picked
    if (_pickedImageFile != null) {
      setState(() => _isUploadingPhoto = true);
      final uploadedUrl = await ctrl.uploadAvatar(_pickedImageFile!);
      setState(() => _isUploadingPhoto = false);

      if (uploadedUrl == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ctrl.errorMessage.isNotEmpty ? ctrl.errorMessage : 'Photo upload failed.'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Stop here — don't save partial profile
      }
    }

    // 2. Save the rest of the profile fields
    final success = await ctrl.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      businessName: _businessController.text.trim(),
      bankName: _bankNameController.text.trim(),
      accountName: _accountNameController.text.trim(),
      accountNumber: _accountNumberController.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully ✓'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ctrl.errorMessage), backgroundColor: Colors.red),
      );
    }
  }
}

