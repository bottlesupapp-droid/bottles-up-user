import 'dart:async';
import 'package:bottles_up_user/features/auth/screens/forgot_password_screen.dart';
import 'package:bottles_up_user/features/auth/screens/login_screen.dart';
import 'package:bottles_up_user/features/auth/screens/phone_login_screen.dart';
import 'package:bottles_up_user/features/auth/screens/reset_password_screen.dart';
import 'package:bottles_up_user/features/auth/screens/signup_screen.dart';
import 'package:bottles_up_user/features/bookings_site/screens/add_bottles_screen.dart';
import 'package:bottles_up_user/features/bookings_site/screens/table_booking_detail_screen.dart';
import 'package:bottles_up_user/features/discover/screens/event_page_screen.dart';
import 'package:bottles_up_user/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:bottles_up_user/features/profile/screens/data_collected_screen.dart';
import 'package:bottles_up_user/features/profile/screens/edit_profile_screen.dart';
import 'package:bottles_up_user/features/profile/screens/privacy_policy_screen.dart';
import 'package:bottles_up_user/features/profile/screens/settings_screen.dart';
import 'package:bottles_up_user/features/profile/screens/terms_conditions_screen.dart';
import 'package:bottles_up_user/features/social/screens/blocked_screen.dart';
import 'package:bottles_up_user/features/social/screens/business_profile_screen.dart';
import 'package:bottles_up_user/features/social/screens/conversation_screen.dart';
import 'package:bottles_up_user/features/social/screens/group_info_screen.dart';
import 'package:bottles_up_user/features/bookings_site/screens/my_bookings_screen.dart';
import 'package:bottles_up_user/features/social/screens/community_rules_screen.dart';
import 'package:bottles_up_user/features/social/screens/inbox_screen.dart';
import 'package:bottles_up_user/features/social/screens/new_message_screen.dart';
import 'package:bottles_up_user/features/social/screens/notifications_screen.dart';
import 'package:bottles_up_user/features/social/screens/privacy_settings_screen.dart';
import 'package:bottles_up_user/features/social/screens/create_post_screen.dart';
import 'package:bottles_up_user/features/social/screens/explore_screen.dart';
import 'package:bottles_up_user/features/social/screens/follow_requests_screen.dart';
import 'package:bottles_up_user/features/social/screens/professionals_screen.dart';
import 'package:bottles_up_user/features/social/screens/reviews_screen.dart';
import 'package:bottles_up_user/features/social/screens/home_feed_screen.dart';
import 'package:bottles_up_user/features/social/screens/members_screen.dart';
import 'package:bottles_up_user/features/social/screens/post_screen.dart';
import 'package:bottles_up_user/features/social/screens/reels_screen.dart';
import 'package:bottles_up_user/features/social/screens/saved_posts_screen.dart';
import 'package:bottles_up_user/features/social/screens/story_viewer_screen.dart';
import 'package:bottles_up_user/features/social/screens/people_list_screen.dart';
import 'package:bottles_up_user/features/social/screens/people_search_screen.dart';
import 'package:bottles_up_user/features/social/screens/social_profile_screen.dart';
import 'package:bottles_up_user/features/social/screens/social_setup_screen.dart';
import 'package:bottles_up_user/features/hire/screens/hire_form_screen.dart';
import 'package:bottles_up_user/features/billing/screens/earnings_screen.dart';
import 'package:bottles_up_user/features/billing/screens/referrals_screen.dart';
import 'package:bottles_up_user/features/billing/screens/subscription_screen.dart';
import 'package:bottles_up_user/features/billing/screens/tip_screen.dart';
import 'package:bottles_up_user/features/hire/screens/hire_screen.dart';
import 'package:bottles_up_user/features/jobs/screens/job_applications_screen.dart';
import 'package:bottles_up_user/features/jobs/screens/job_form_screen.dart';
import 'package:bottles_up_user/features/jobs/screens/job_screen.dart';
import 'package:bottles_up_user/features/jobs/screens/my_applications_screen.dart';
import 'package:bottles_up_user/features/jobs/screens/my_jobs_screen.dart';
import 'package:bottles_up_user/features/jobs/screens/opportunities_screen.dart';
import 'package:bottles_up_user/features/recognition/screens/recognition_screen.dart';
import 'package:bottles_up_user/features/hire/screens/hires_screen.dart';
import 'package:bottles_up_user/features/hire/screens/team_screen.dart';
import 'package:bottles_up_user/features/hiring/screens/hiring_booking_screen.dart';
import 'package:bottles_up_user/features/hiring/screens/hiring_request_screen.dart';
import 'package:bottles_up_user/features/hiring/screens/hiring_requests_screen.dart';
import 'package:bottles_up_user/features/hiring/screens/pro_request_form_screen.dart';
import 'package:bottles_up_user/features/hiring/screens/pro_services_screen.dart';
import 'package:bottles_up_user/features/split/screens/pay_share_screen.dart';
import 'package:bottles_up_user/features/split/screens/shares_to_pay_screen.dart';
import 'package:bottles_up_user/features/split/screens/split_bill_screen.dart';
import 'package:bottles_up_user/features/splash/screens/splash_screen.dart';
import 'package:bottles_up_user/features/tables/screens/table_booking_screen.dart';
import 'package:bottles_up_user/features/tables/screens/venue_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/payment_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/ticket_purchase_screen.dart';
import 'package:bottles_up_user/features/tickets_site/screens/ticket_screen.dart';
import 'package:bottles_up_user/site/models/post.dart';
import 'package:bottles_up_user/site/models/review.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Routes that do not require authentication.
const _publicRoutes = {
  '/',
  '/login',
  '/signup',
  '/phone-login',
  '/forgot-password',
  '/reset-password',
};

// Refreshes the router whenever Supabase auth state changes.
class _AuthRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _sub;

  _AuthRefreshNotifier() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final _authRefreshNotifier = _AuthRefreshNotifier();

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: _authRefreshNotifier,
  redirect: (context, state) {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    final path = state.uri.path;

    // Splash manages its own flow — leave it alone.
    if (path == '/') return null;

    final isPublic = _publicRoutes.any((r) => path == r || path.startsWith('$r/'));

    if (!isLoggedIn && !isPublic) {
      // Preserve the intended destination so we can redirect back after login.
      final encoded = Uri.encodeComponent(state.uri.toString());
      return '/login?redirect=$encoded';
    }

    if (isLoggedIn && (path == '/login' || path == '/signup' || path == '/phone-login')) {
      return '/home';
    }

    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Page not found: ${state.uri}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
  routes: appRoutes,
);

/// Every screen the app can open. Apart from the router so a test can open them without a signed-in session.
final List<RouteBase> appRoutes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/signup',
    builder: (context, state) => const SignupScreen(),
  ),
  GoRoute(
    path: '/phone-login',
    builder: (context, state) => const PhoneLoginScreen(),
  ),
  GoRoute(
    path: '/forgot-password',
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: '/reset-password',
    builder: (context, state) {
      // Extract parameters from both query and fragment
      final params = <String, String>{};
      params.addAll(state.uri.queryParameters);

      // Parse fragment parameters (Supabase uses fragments)
      if (state.uri.fragment.isNotEmpty) {
        final fragmentParts = state.uri.fragment.split('&');
        for (final part in fragmentParts) {
          final keyValue = part.split('=');
          if (keyValue.length == 2) {
            params[keyValue[0]] = Uri.decodeComponent(keyValue[1]);
          }
        }
      }

      final accessToken = params['access_token'];
      final refreshToken = params['refresh_token'];

      return ResetPasswordScreen(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    },
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const MainNavigationScreen(),
  ),
  GoRoute(
    path: '/profile/edit',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const EditProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/profile/settings',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const SettingsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/profile/privacy-policy',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const PrivacyPolicyScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/profile/terms-conditions',
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const TermsConditionsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    path: '/profile/data',
    builder: (context, state) => const DataCollectedScreen(),
  ),
  GoRoute(
    path: '/events/:id',
    builder: (context, state) => EventPageScreen(eventId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/events/:id/tickets/:tierId',
    builder: (context, state) => TicketPurchaseScreen(eventId: state.pathParameters['id']!, tierId: state.pathParameters['tierId']!),
  ),
  GoRoute(
    path: '/venues/:id',
    builder: (context, state) => VenueScreen(venueId: state.pathParameters['id']!, initialNight: state.uri.queryParameters['night']),
  ),
  GoRoute(
    path: '/venues/:id/tables/:tableId/book',
    builder: (context, state) => TableBookingScreen(
      venueId: state.pathParameters['id']!,
      tableId: state.pathParameters['tableId']!,
      dateKey: state.uri.queryParameters['date'],
      slotId: state.uri.queryParameters['slot'],
    ),
  ),
  GoRoute(
    path: '/payment',
    redirect: (context, state) => state.extra is PaymentWaitArgs ? null : '/home',
    builder: (context, state) => PaymentScreen(args: state.extra as PaymentWaitArgs),
  ),
  GoRoute(
    path: '/bookings/:id',
    builder: (context, state) => TableBookingDetailScreen(bookingId: state.pathParameters['id']!),
    routes: [
      GoRoute(
        path: 'bottles',
        builder: (context, state) => AddBottlesScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: 'split',
        builder: (context, state) => SplitBillScreen(bookingId: state.pathParameters['id']!),
      ),
    ],
  ),
  GoRoute(
    path: '/tickets/:id',
    builder: (context, state) => TicketScreen(orderId: state.pathParameters['id']!),
  ),
  // Social: profiles, following, blocking. Every screen asks first whether BottlesUp has switched social on.
  GoRoute(path: '/me/setup', builder: (context, state) => const SocialSetupScreen()),
  GoRoute(path: '/me/business/new', builder: (context, state) => const BusinessProfileScreen()),
  GoRoute(path: '/me/business/:id/edit', builder: (context, state) => BusinessProfileScreen(profileId: state.pathParameters['id']!)),
  GoRoute(path: '/people', builder: (context, state) => const PeopleSearchScreen()),
  GoRoute(path: '/people/requests', builder: (context, state) => const FollowRequestsScreen()),
  GoRoute(path: '/people/blocked', builder: (context, state) => const BlockedScreen()),
  GoRoute(path: '/u/:handle', builder: (context, state) => SocialProfileScreen(handle: state.pathParameters['handle']!)),
  GoRoute(path: '/profiles/:id/followers', builder: (context, state) => PeopleListScreen(profileId: state.pathParameters['id']!, followers: true)),
  GoRoute(path: '/feed', builder: (context, state) => const HomeFeedScreen()),
  GoRoute(
    path: '/create',
    builder: (context, state) => CreatePostScreen(
      initialKind: switch (state.uri.queryParameters['kind']) {
        'reel' => PostKind.reel,
        'story' => PostKind.story,
        _ => PostKind.post,
      },
    ),
  ),
  GoRoute(path: '/post/:id', builder: (context, state) => PostScreen(postId: state.pathParameters['id']!)),
  GoRoute(path: '/stories/:handle', builder: (context, state) => StoryViewerScreen(handle: state.pathParameters['handle']!)),
  GoRoute(path: '/inbox', builder: (context, state) => const InboxScreen()),
  GoRoute(path: '/inbox/new', builder: (context, state) => const NewMessageScreen()),
  GoRoute(path: '/inbox/new-group', builder: (context, state) => const NewMessageScreen(group: true)),
  GoRoute(path: '/inbox/:id', builder: (context, state) => ConversationScreen(conversationId: state.pathParameters['id']!)),
  GoRoute(path: '/inbox/:id/info', builder: (context, state) => GroupInfoScreen(conversationId: state.pathParameters['id']!)),
  GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
  GoRoute(path: '/rules', builder: (context, state) => const CommunityRulesScreen()),
  GoRoute(path: '/me/settings', builder: (context, state) => const PrivacySettingsScreen()),
  GoRoute(path: '/me/bookings', builder: (context, state) => const MyBookingsScreen()),
  GoRoute(path: '/me/shares', builder: (context, state) => const SharesToPayScreen()),
  GoRoute(path: '/me/shares/:id', builder: (context, state) => PayShareScreen(shareId: state.pathParameters['id']!)),
  // Hiring professionals: asking for a job, the quote, the booking and its payment; and a professional's own services and requests.
  GoRoute(path: '/me/hiring', builder: (context, state) => const HiringRequestsScreen()),
  GoRoute(path: '/me/pro-requests', builder: (context, state) => const HiringRequestsScreen(asProvider: true)),
  GoRoute(path: '/me/services', builder: (context, state) => const ProServicesScreen()),
  GoRoute(path: '/pros/:id/request', builder: (context, state) => ProRequestFormScreen(providerId: state.pathParameters['id']!)),
  GoRoute(path: '/hiring/bookings/:id', builder: (context, state) => HiringBookingScreen(bookingId: state.pathParameters['id']!)),
  GoRoute(path: '/hiring/:id', builder: (context, state) => HiringRequestScreen(requestId: state.pathParameters['id']!)),
  // Teams, asking a venue to host an event, and the shared workspace of a hire. A hire is opened as the group's or the venue's profile (`as`).
  GoRoute(path: '/me/team', builder: (context, state) => const TeamScreen()),
  GoRoute(path: '/me/hires', builder: (context, state) => const HiresScreen()),
  GoRoute(path: '/me/hire-requests', builder: (context, state) => const HiresScreen(asVenue: true)),
  GoRoute(path: '/venues/:id/host', builder: (context, state) => HireFormScreen(venueId: state.pathParameters['id']!)),
  GoRoute(path: '/hires/:id', builder: (context, state) => HireScreen(hireId: state.pathParameters['id']!, actorId: state.uri.queryParameters['as'])),
  // Subscriptions, referrals, tips and earnings.
  GoRoute(path: '/me/subscription', builder: (context, state) => const SubscriptionScreen()),
  GoRoute(path: '/me/earnings', builder: (context, state) => const EarningsScreen()),
  GoRoute(path: '/me/referrals', builder: (context, state) => const ReferralsScreen()),
  GoRoute(path: '/tip/:id', builder: (context, state) => TipScreen(profileId: state.pathParameters['id']!)),
  // Verification, ranks and awards; jobs and applications. A job's business pages are opened as the business profile (`as`).
  GoRoute(path: '/me/recognition', builder: (context, state) => const RecognitionScreen()),
  GoRoute(path: '/jobs', builder: (context, state) => const OpportunitiesScreen()),
  GoRoute(path: '/jobs/:id', builder: (context, state) => JobScreen(jobId: state.pathParameters['id']!)),
  GoRoute(path: '/me/jobs', builder: (context, state) => const MyJobsScreen()),
  GoRoute(path: '/me/jobs/new', builder: (context, state) => JobFormScreen(asId: state.uri.queryParameters['as'] ?? '')),
  GoRoute(path: '/me/jobs/:id/edit', builder: (context, state) => JobFormScreen(asId: state.uri.queryParameters['as'] ?? '', jobId: state.pathParameters['id'])),
  GoRoute(path: '/me/jobs/:id/applications', builder: (context, state) => JobApplicationsScreen(jobId: state.pathParameters['id']!, asId: state.uri.queryParameters['as'] ?? '')),
  GoRoute(path: '/me/applications', builder: (context, state) => const MyApplicationsScreen()),
  GoRoute(path: '/explore', builder: (context, state) => const ExploreScreen()),
  GoRoute(path: '/explore/professionals', builder: (context, state) => const ProfessionalsScreen()),
  GoRoute(
    path: '/reviews/:kind/:id',
    builder: (context, state) {
      final kind = switch (state.pathParameters['kind']) {
        'venue' => ReviewKind.venue,
        'event' => ReviewKind.event,
        _ => null,
      };
      if (kind == null) return Scaffold(appBar: AppBar(), body: const Center(child: Text('That page does not exist.', key: Key('no-such-page'))));
      return ReviewsScreen(kind: kind, targetId: state.pathParameters['id']!);
    },
  ),
  GoRoute(path: '/reels', builder: (context, state) => const ReelsScreen()),
  GoRoute(path: '/me/members', builder: (context, state) => const MembersScreen()),
  GoRoute(path: '/me/saved', builder: (context, state) => const SavedPostsScreen()),
  GoRoute(path: '/profiles/:id/following', builder: (context, state) => PeopleListScreen(profileId: state.pathParameters['id']!, followers: false)),
];
