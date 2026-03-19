// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_transfer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingTransfersHash() => r'822edb4b055ee9a0d5e042e52f642d4be649c02e';

/// See also [PendingTransfers].
@ProviderFor(PendingTransfers)
final pendingTransfersProvider = AutoDisposeAsyncNotifierProvider<
    PendingTransfers, List<TicketTransfer>>.internal(
  PendingTransfers.new,
  name: r'pendingTransfersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingTransfersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PendingTransfers = AutoDisposeAsyncNotifier<List<TicketTransfer>>;
String _$sentTransfersHash() => r'21b8fe1da0dfcaca170d59d6c48e952792708dbb';

/// See also [SentTransfers].
@ProviderFor(SentTransfers)
final sentTransfersProvider = AutoDisposeAsyncNotifierProvider<SentTransfers,
    List<TicketTransfer>>.internal(
  SentTransfers.new,
  name: r'sentTransfersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sentTransfersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SentTransfers = AutoDisposeAsyncNotifier<List<TicketTransfer>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
