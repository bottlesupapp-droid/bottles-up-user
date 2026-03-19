import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              'Privacy Policy',
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
              'Welcome to Bottles Up. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we look after your personal data when you visit our app and tell you about your privacy rights and how the law protects you.',
            ),

            // Data We Collect
            _buildSection(
              context,
              'Data We Collect',
              'We may collect, use, store and transfer different kinds of personal data about you:\n\n'
              '• Identity Data: name, username, date of birth\n'
              '• Contact Data: email address, telephone number\n'
              '• Profile Data: your interests, preferences, feedback and survey responses\n'
              '• Usage Data: information about how you use our app and services\n'
              '• Location Data: your location when using our app (with your consent)\n'
              '• Technical Data: internet protocol (IP) address, browser type, device information',
            ),

            // How We Use Your Data
            _buildSection(
              context,
              'How We Use Your Data',
              'We will only use your personal data when the law allows us to. Most commonly, we will use your personal data in the following circumstances:\n\n'
              '• To provide and maintain our service\n'
              '• To notify you about changes to our service\n'
              '• To allow you to participate in interactive features\n'
              '• To provide customer care and support\n'
              '• To provide analysis or valuable information to improve our service\n'
              '• To monitor the usage of our service',
            ),

            // Legal Basis (GDPR)
            _buildSection(
              context,
              'Legal Basis for Processing (GDPR)',
              'Under the General Data Protection Regulation (GDPR), we process your personal data based on:\n\n'
              '• Consent: You have given clear consent for us to process your personal data\n'
              '• Contract: Processing is necessary for a contract we have with you\n'
              '• Legal obligation: Processing is necessary to comply with the law\n'
              '• Legitimate interests: Processing is necessary for our legitimate interests',
            ),

            // Your Rights
            _buildSection(
              context,
              'Your Rights Under GDPR',
              'If you are in the European Economic Area (EEA), you have certain data protection rights:\n\n'
              '• Right to access your personal data\n'
              '• Right to rectification of inaccurate data\n'
              '• Right to erasure ("right to be forgotten")\n'
              '• Right to restrict processing\n'
              '• Right to data portability\n'
              '• Right to object to processing\n'
              '• Right to withdraw consent\n\n'
              'To exercise these rights, please contact us at privacy@bottlesup.com',
            ),

            // Data Retention
            _buildSection(
              context,
              'Data Retention',
              'We will only retain your personal data for as long as necessary to fulfil the purposes we collected it for, including for the purposes of satisfying any legal, accounting, or reporting requirements. When we no longer need your data, we will securely delete it.',
            ),

            // Data Security
            _buildSection(
              context,
              'Data Security',
              'We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used or accessed in an unauthorised way, altered or disclosed. We limit access to your personal data to those employees, agents, contractors and other third parties who have a business need to know.',
            ),

            // International Transfers
            _buildSection(
              context,
              'International Transfers',
              'Your personal data may be transferred to and stored on servers located outside your country. We ensure that such transfers comply with applicable data protection laws and provide adequate protection for your personal data.',
            ),

            // Cookies
            _buildSection(
              context,
              'Cookies and Similar Technologies',
              'We use cookies and similar tracking technologies to track activity on our app and store certain information. You can instruct your device to refuse all cookies or to indicate when a cookie is being sent.',
            ),

            // Third-Party Services
            _buildSection(
              context,
              'Third-Party Services',
              'Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to read their privacy policies.',
            ),

            // Children's Privacy
            _buildSection(
              context,
              "Children's Privacy",
              'Our service is not intended for children under 18. We do not knowingly collect personally identifiable information from children under 18. If you become aware that a child has provided us with personal data, please contact us.',
            ),

            // Changes to Policy
            _buildSection(
              context,
              'Changes to This Privacy Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "last updated" date.',
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
                Iconsax.message,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const Gap(12),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            'If you have any questions about this Privacy Policy or our data practices, please contact us:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(12),
          Text(
            'Email: privacy@bottlesup.com\n'
            'Data Protection Officer: dpo@bottlesup.com\n'
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