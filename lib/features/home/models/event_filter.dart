import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_filter.freezed.dart';
part 'event_filter.g.dart';

@freezed
class EventFilter with _$EventFilter {
  const factory EventFilter({
    @Default(null) String? genre,
    @Default(null) DateTime? date,
    @Default(null) String? location,
  }) = _EventFilter;

  factory EventFilter.fromJson(Map<String, dynamic> json) => _$EventFilterFromJson(json);
}
