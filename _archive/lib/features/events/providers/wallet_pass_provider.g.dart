// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_pass_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletPassServiceHash() => r'aeb26757749f022d8d93939eb8477a3643e25964';

/// Provider for wallet pass service
///
/// Copied from [walletPassService].
@ProviderFor(walletPassService)
final walletPassServiceProvider =
    AutoDisposeProvider<WalletPassService>.internal(
  walletPassService,
  name: r'walletPassServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletPassServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WalletPassServiceRef = AutoDisposeProviderRef<WalletPassService>;
String _$isAppleWalletSupportedHash() =>
    r'ff2c1c155c3ccb66e4dc29b24dac4ca147993b40';

/// Provider to check if Apple Wallet is supported
///
/// Copied from [isAppleWalletSupported].
@ProviderFor(isAppleWalletSupported)
final isAppleWalletSupportedProvider = AutoDisposeProvider<bool>.internal(
  isAppleWalletSupported,
  name: r'isAppleWalletSupportedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAppleWalletSupportedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAppleWalletSupportedRef = AutoDisposeProviderRef<bool>;
String _$walletPassForBookingHash() =>
    r'3f88906881eb2e3568010104b00b68ef90a3ca6b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider to get wallet pass for a booking
///
/// Copied from [walletPassForBooking].
@ProviderFor(walletPassForBooking)
const walletPassForBookingProvider = WalletPassForBookingFamily();

/// Provider to get wallet pass for a booking
///
/// Copied from [walletPassForBooking].
class WalletPassForBookingFamily extends Family<AsyncValue<WalletPass?>> {
  /// Provider to get wallet pass for a booking
  ///
  /// Copied from [walletPassForBooking].
  const WalletPassForBookingFamily();

  /// Provider to get wallet pass for a booking
  ///
  /// Copied from [walletPassForBooking].
  WalletPassForBookingProvider call({
    required String bookingId,
    required String passType,
  }) {
    return WalletPassForBookingProvider(
      bookingId: bookingId,
      passType: passType,
    );
  }

  @override
  WalletPassForBookingProvider getProviderOverride(
    covariant WalletPassForBookingProvider provider,
  ) {
    return call(
      bookingId: provider.bookingId,
      passType: provider.passType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'walletPassForBookingProvider';
}

/// Provider to get wallet pass for a booking
///
/// Copied from [walletPassForBooking].
class WalletPassForBookingProvider
    extends AutoDisposeFutureProvider<WalletPass?> {
  /// Provider to get wallet pass for a booking
  ///
  /// Copied from [walletPassForBooking].
  WalletPassForBookingProvider({
    required String bookingId,
    required String passType,
  }) : this._internal(
          (ref) => walletPassForBooking(
            ref as WalletPassForBookingRef,
            bookingId: bookingId,
            passType: passType,
          ),
          from: walletPassForBookingProvider,
          name: r'walletPassForBookingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$walletPassForBookingHash,
          dependencies: WalletPassForBookingFamily._dependencies,
          allTransitiveDependencies:
              WalletPassForBookingFamily._allTransitiveDependencies,
          bookingId: bookingId,
          passType: passType,
        );

  WalletPassForBookingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
    required this.passType,
  }) : super.internal();

  final String bookingId;
  final String passType;

  @override
  Override overrideWith(
    FutureOr<WalletPass?> Function(WalletPassForBookingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WalletPassForBookingProvider._internal(
        (ref) => create(ref as WalletPassForBookingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
        passType: passType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WalletPass?> createElement() {
    return _WalletPassForBookingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WalletPassForBookingProvider &&
        other.bookingId == bookingId &&
        other.passType == passType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);
    hash = _SystemHash.combine(hash, passType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WalletPassForBookingRef on AutoDisposeFutureProviderRef<WalletPass?> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;

  /// The parameter `passType` of this provider.
  String get passType;
}

class _WalletPassForBookingProviderElement
    extends AutoDisposeFutureProviderElement<WalletPass?>
    with WalletPassForBookingRef {
  _WalletPassForBookingProviderElement(super.provider);

  @override
  String get bookingId => (origin as WalletPassForBookingProvider).bookingId;
  @override
  String get passType => (origin as WalletPassForBookingProvider).passType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
