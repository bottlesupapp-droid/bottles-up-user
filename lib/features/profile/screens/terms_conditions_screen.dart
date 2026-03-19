import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Terms & Conditions',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              'Last updated: ${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const Gap(24),

            // Introduction
            _buildSection(
              context,
              'Introduction',
              'Welcome to Bottles Up. These terms and conditions ("Terms") govern your use of our mobile application and services. By accessing or using our app, you agree to be bound by these Terms.',
            ),

            // Acceptance of Terms
            _buildSection(
              context,
              'Acceptance of Terms',
              'By downloading, installing, or using the Bottles Up app, you acknowledge that you have read, understood, and agree to be bound by these Terms. If you do not agree to these Terms, please do not use our app.',
            ),

            // Age Requirements
            _buildSection(
              context,
              'Age Requirements',
              'You must be at least 18 years old to use this app. Some venues and services may have higher age requirements (21+). You are responsible for ensuring you meet all age requirements for the venues and services you book through our app.',
            ),

            // User Accounts
            _buildSection(
              context,
              'User Accounts',
              'To use certain features of our app, you must create an account. You are responsible for:\n\n'
              '• Maintaining the confidentiality of your account credentials\n'
              '• All activities that occur under your account\n'
              '• Providing accurate and up-to-date information\n'
              '• Notifying us immediately of any unauthorized use\n\n'
              'We reserve the right to suspend or terminate accounts that violate these Terms.',
            ),

            // Booking Terms
            _buildSection(
              context,
              'Booking Terms',
              'When you make a booking through our app:\n\n'
              '• All bookings are subject to venue availability and confirmation\n'
              '• Prices are displayed in local currency and include applicable taxes\n'
              '• Cancellation policies vary by venue and are displayed at booking\n'
              '• You must arrive on time and present valid identification\n'
              '• Venues reserve the right to refuse entry based on dress code or behavior\n'
              '• No-shows may result in charges and future booking restrictions',
            ),

            // Payment Terms
            _buildSection(
              context,
              'Payment Terms',
              'Payment processing is handled by secure third-party providers. By making a payment:\n\n'
              '• You authorize us to charge your payment method\n'
              '• You confirm that you are authorized to use the payment method\n'
              '• Refunds are processed according to venue-specific policies\n'
              '• We are not responsible for payment processing fees\n'
              '• Disputed charges must be reported within 30 days',
            ),

            // User Conduct
            _buildSection(
              context,
              'User Conduct',
              'You agree not to:\n\n'
              '• Use the app for any illegal or unauthorized purpose\n'
              '• Violate any local, state, national, or international law\n'
              '• Transmit any harmful or malicious code\n'
              '• Interfere with or disrupt the app or servers\n'
              '• Create false accounts or impersonate others\n'
              '• Post or share inappropriate content\n'
              '• Harass, abuse, or harm other users or venues',
            ),

            // Intellectual Property
            _buildSection(
              context,
              'Intellectual Property',
              'The Bottles Up app and its content are protected by copyright, trademark, and other intellectual property laws. You may not:\n\n'
              '• Copy, modify, or distribute our content without permission\n'
              '• Use our trademarks or logos without authorization\n'
              '• Reverse engineer or attempt to extract source code\n'
              '• Create derivative works based on our app',
            ),

            // Privacy and Data
            _buildSection(
              context,
              'Privacy and Data',
              'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your personal information. By using our app, you also agree to our Privacy Policy.',
            ),

            // Third-Party Services
            _buildSection(
              context,
              'Third-Party Services',
              'Our app may integrate with third-party services (payment processors, social media, etc.). These services have their own terms and privacy policies. We are not responsible for third-party content, services, or policies.',
            ),

            // Venue Relationships
            _buildSection(
              context,
              'Venue Relationships',
              'Bottles Up acts as a platform connecting users with venues. We are not responsible for:\n\n'
              '• Venue operations, service quality, or safety\n'
              '• Disputes between users and venues\n'
              '• Venue closure, cancellations, or changes\n'
              '• Food, beverage quality, or safety\n'
              '• Venue compliance with local laws and regulations',
            ),

            // Limitation of Liability
            _buildSection(
              context,
              'Limitation of Liability',
              'To the maximum extent permitted by law, Bottles Up shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, or use, arising out of your use of the app.',
            ),

            // Disclaimers
            _buildSection(
              context,
              'Disclaimers',
              'Our app is provided "as is" without warranties of any kind. We do not guarantee:\n\n'
              '• Uninterrupted or error-free operation\n'
              '• Accuracy of venue information\n'
              '• Availability of services or venues\n'
              '• Compatibility with your device\n'
              '• Security of data transmission',
            ),

            // Indemnification
            _buildSection(
              context,
              'Indemnification',
              'You agree to indemnify and hold harmless Bottles Up and its affiliates from any claims, damages, losses, or expenses arising from your use of the app, violation of these Terms, or infringement of any rights of another party.',
            ),

            // Termination
            _buildSection(
              context,
              'Termination',
              'We may terminate or suspend your account and access to the app at any time, with or without notice, for any reason, including violation of these Terms. Upon termination, your right to use the app ceases immediately.',
            ),

            // Governing Law
            _buildSection(
              context,
              'Governing Law',
              'These Terms are governed by and construed in accordance with the laws of [Your Jurisdiction]. Any disputes arising from these Terms shall be resolved in the courts of [Your Jurisdiction].',
            ),

            // Changes to Terms
            _buildSection(
              context,
              'Changes to Terms',
              'We reserve the right to modify these Terms at any time. Changes will be effective immediately upon posting. Your continued use of the app after changes constitutes acceptance of the new Terms.',
            ),

            // Contact Information
            _buildContactSection(context),

            const Gap(32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.6,
          ),
        ),
        const Gap(24),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.message_question,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const Gap(12),
              Text(
                'Questions?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            'If you have any questions about these Terms and Conditions, please contact us:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(12),
          Text(
            'Email: legal@bottlesup.com\n'
            'Support: support@bottlesup.com\n'
            'Address: [Your Company Address]',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 