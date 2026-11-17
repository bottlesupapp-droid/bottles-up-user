import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/password_reset_service.dart';

/// One place the screens get the reset flow from, so a test can hand them a fake.
final passwordResetServiceProvider = Provider<PasswordResetService>((ref) => PasswordResetService());
