import 'package:bottles_up_user/features/auth/screens/forgot_password_screen.dart';
import 'package:bottles_up_user/features/auth/screens/login_screen.dart';
import 'package:bottles_up_user/features/auth/screens/phone_login_screen.dart';
import 'package:bottles_up_user/features/auth/screens/reset_password_screen.dart';
import 'package:bottles_up_user/features/auth/screens/signup_screen.dart';
import 'package:bottles_up_user/features/events/screens/event_booking_screen.dart';
import 'package:bottles_up_user/features/events/screens/event_detail_screen.dart';
import 'package:bottles_up_user/features/location/screens/location_permission_screen.dart';
import 'package:bottles_up_user/features/location/screens/manual_location_entry_screen.dart';
import 'package:bottles_up_user/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:bottles_up_user/features/messaging/screens/chat_screen.dart';
import 'package:bottles_up_user/features/messaging/screens/new_direct_message_screen.dart';
import 'package:bottles_up_user/features/messaging/screens/new_group_screen.dart';
import 'package:bottles_up_user/features/notifications/screens/notification_screen.dart';
import 'package:bottles_up_user/features/profile/screens/edit_profile_screen.dart';
import 'package:bottles_up_user/features/profile/screens/orders_screen.dart';
import 'package:bottles_up_user/features/profile/screens/privacy_policy_screen.dart';
import 'package:bottles_up_user/features/profile/screens/settings_screen.dart';
import 'package:bottles_up_user/features/profile/screens/terms_conditions_screen.dart';
import 'package:bottles_up_user/features/splash/screens/splash_screen.dart';
import 'package:bottles_up_user/features/table_selection/screens/table_selection_screen.dart';
import 'package:bottles_up_user/features/venues/screens/venue_discovery_screen.dart';
import 'package:bottles_up_user/features/venues/screens/venue_detail_screen.dart';
import 'package:bottles_up_user/features/venues/screens/venue_inquiry_screen.dart';
import 'package:bottles_up_user/features/venues/screens/venue_comparison_screen.dart';
import 'package:bottles_up_user/features/events/screens/event_chat_screen.dart';
import 'package:bottles_up_user/features/events/screens/event_polls_screen.dart';
import 'package:bottles_up_user/features/events/screens/announcements_screen.dart';
import 'package:bottles_up_user/features/events/screens/ticket_transfer_screen.dart';
import 'package:bottles_up_user/features/tickets/screens/ticket_detail_screen.dart';
import 'package:bottles_up_user/features/payment/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
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
          print('DEBUG: Processing fragment in router: ${state.uri.fragment}');
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

        print(
            'DEBUG: Router extracted - access_token: ${accessToken != null ? "present" : "missing"}');

        return ResetPasswordScreen(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      },
    ),
    GoRoute(
      path: '/location-permission',
      builder: (context, state) => const LocationPermissionScreen(),
    ),
    GoRoute(
      path: '/location/manual-entry',
      builder: (context, state) => const ManualLocationEntryScreen(),
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
      path: '/profile/orders',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OrdersScreen(),
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
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/events/:id',
      builder: (context, state) {
        final eventId = state.pathParameters['id']!;
        return EventDetailScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: '/event-detail/:eventId',
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']!;
        return EventBookingScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: '/table-selection/:clubId',
      builder: (context, state) {
        final clubId = state.pathParameters['clubId']!;
        final date = state.uri.queryParameters['date'];
        final timeSlot = state.uri.queryParameters['timeSlot'];
        final guestCount = int.tryParse(state.uri.queryParameters['guestCount'] ?? '4') ?? 4;

        return TableSelectionScreen(
          clubId: clubId,
          date: date,
          timeSlot: timeSlot,
          guestCount: guestCount,
          clubName: state.uri.queryParameters['clubName'],
        );
      },
    ),
    GoRoute(
      path: '/messaging/chat/:conversationId',
      builder: (context, state) {
        final conversationId = state.pathParameters['conversationId']!;
        return ChatScreen(conversationId: conversationId);
      },
    ),
    GoRoute(
      path: '/messaging/new-direct',
      builder: (context, state) => const NewDirectMessageScreen(),
    ),
    GoRoute(
      path: '/messaging/new-group',
      builder: (context, state) => const NewGroupScreen(),
    ),
    // Venue routes
    GoRoute(
      path: '/venues',
      builder: (context, state) => const VenueDiscoveryScreen(),
    ),
    GoRoute(
      path: '/venues/:id',
      builder: (context, state) {
        final venueId = state.pathParameters['id']!;
        return VenueDetailScreen(venueId: venueId);
      },
    ),
    GoRoute(
      path: '/venues/:id/inquiry',
      builder: (context, state) {
        final venueId = state.pathParameters['id']!;
        final venueName = state.uri.queryParameters['venueName'] ?? 'Venue';
        return VenueInquiryScreen(
          venueId: venueId,
          venueName: venueName,
        );
      },
    ),
    GoRoute(
      path: '/venues/compare',
      builder: (context, state) {
        final venueIdsParam = state.uri.queryParameters['venueIds'] ?? '';
        final venueIds = venueIdsParam.split(',').where((id) => id.isNotEmpty).toList();
        return VenueComparisonScreen(venueIds: venueIds);
      },
    ),
    // Event feature routes
    GoRoute(
      path: '/events/:id/chat',
      builder: (context, state) {
        final eventId = state.pathParameters['id']!;
        final eventName = state.uri.queryParameters['eventName'] ?? 'Event Chat';
        return EventChatScreen(
          eventId: eventId,
          eventName: eventName,
        );
      },
    ),
    GoRoute(
      path: '/events/:id/polls',
      builder: (context, state) {
        final eventId = state.pathParameters['id']!;
        final eventName = state.uri.queryParameters['eventName'] ?? 'Event Polls';
        return EventPollsScreen(
          eventId: eventId,
          eventName: eventName,
        );
      },
    ),
    GoRoute(
      path: '/events/:id/announcements',
      builder: (context, state) {
        final eventId = state.pathParameters['id']!;
        final eventName = state.uri.queryParameters['eventName'] ?? 'Event';
        final isHost = state.uri.queryParameters['isHost'] == 'true';
        return AnnouncementsScreen(
          eventId: eventId,
          eventName: eventName,
          isHost: isHost,
        );
      },
    ),
    // Ticket transfer route
    GoRoute(
      path: '/ticket-transfers',
      builder: (context, state) => const TicketTransferScreen(),
    ),
    // Ticket detail route
    GoRoute(
      path: '/tickets/:id',
      builder: (context, state) {
        final ticketId = state.pathParameters['id']!;
        final eventName = state.uri.queryParameters['eventName'] ?? 'Event';
        final venueName = state.uri.queryParameters['venueName'] ?? 'Venue';
        final eventDate = state.uri.queryParameters['eventDate'] ?? '';
        final eventTime = state.uri.queryParameters['eventTime'] ?? '';
        final ticketQuantity = int.tryParse(state.uri.queryParameters['ticketQuantity'] ?? '1') ?? 1;
        final ticketPrice = state.uri.queryParameters['ticketPrice'] ?? '0';
        final totalAmount = state.uri.queryParameters['totalAmount'] ?? '0';
        final status = state.uri.queryParameters['status'] ?? 'pending';
        final confirmationCode = state.uri.queryParameters['confirmationCode'];

        return TicketDetailScreen(
          ticketId: ticketId,
          eventName: eventName,
          venueName: venueName,
          eventDate: eventDate,
          eventTime: eventTime,
          ticketQuantity: ticketQuantity,
          ticketPrice: ticketPrice,
          totalAmount: totalAmount,
          status: status,
          confirmationCode: confirmationCode,
        );
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null) {
          // Fallback if no data provided
          return const CheckoutScreen(
            paymentType: 'general',
            amount: 0.0,
            description: 'Payment',
          );
        }

        return CheckoutScreen(
          paymentType: extra['paymentType'] as String? ?? 'general',
          amount: (extra['amount'] as num?)?.toDouble() ?? 0.0,
          bookingId: extra['bookingId'] as String?,
          eventId: extra['eventId'] as String?,
          description: extra['description'] as String?,
          metadata: extra['metadata'] as Map<String, dynamic>?,
        );
      },
    ),
  ],
);
