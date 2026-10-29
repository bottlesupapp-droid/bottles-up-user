import 'package:bottles_up_user/features/profile/logic/profile_completion.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

/// Opens the calendar and returns the day chosen (null when cancelled). Replaced in tests.
typedef DatePicker = Future<DateTime?> Function(BuildContext context, DateTime initial, DateTime first, DateTime last);

Future<DateTime?> _showCalendar(BuildContext context, DateTime initial, DateTime first, DateTime last) => showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      // A birthday is found by year first: the list of years comes up, then the month and day.
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Date of birth',
    );

/// A date-of-birth field for a form. It shows the day chosen and the age that makes (the age is worked out, never typed, so the two cannot disagree), and refuses anyone under
/// [minimumAge] or a day that has not happened yet.
class DateOfBirthField extends FormField<DateTime> {
  DateOfBirthField({super.key, super.initialValue, super.enabled = true, DatePicker? picker, ValueChanged<DateTime>? onChanged})
      : super(
          validator: (value) => dateOfBirthProblem(value, clock.now()),
          // Checked as soon as a day is chosen, and again when another is: a "must be 18" message does not stay on screen after a good date is picked.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) {
            final today = clock.now();
            final value = field.value;
            Future<void> choose() async {
              final last = dateOnly(today);
              var initial = value ?? DateTime(today.year - 25, today.month, today.day);
              if (initial.isAfter(last)) initial = last;
              final picked = await (picker ?? _showCalendar)(field.context, initial, DateTime(1900), last);
              if (picked == null) return;
              final day = dateOnly(picked);
              field.didChange(day);
              onChanged?.call(day);
            }

            final theme = Theme.of(field.context);
            return Semantics(
              button: true,
              label: 'Date of birth',
              child: InkWell(
                key: const Key('dob-field'),
                borderRadius: BorderRadius.circular(12),
                onTap: field.widget.enabled ? choose : null,
                child: InputDecorator(
                  isEmpty: value == null,
                  decoration: InputDecoration(
                    labelText: 'Date of birth',
                    prefixIcon: const Icon(Iconsax.calendar),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorText: field.errorText,
                    helper: value == null ? null : Text('Age: ${ageOn(value, today)}', key: const Key('dob-age'), style: theme.textTheme.bodySmall),
                  ),
                  child: Text(value == null ? '' : formatDate(value), key: const Key('dob-value')),
                ),
              ),
            );
          },
        );
}
