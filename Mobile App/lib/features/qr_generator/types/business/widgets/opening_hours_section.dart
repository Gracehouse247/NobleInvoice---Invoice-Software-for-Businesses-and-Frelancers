import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart';


class OpeningHoursSection extends StatelessWidget {
  const OpeningHoursSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opening Hours',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        Consumer<BusinessQRController>(
          builder: (context, controller, child) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.openingHours.length,
              itemBuilder: (context, index) {
                final day = controller.openingHours[index];
                return _DayRow(
                  day: day,
                  onToggle: (isOpen) => controller.toggleDay(index, isOpen),
                  onFromChanged: (time) => controller.setFromTime(index, time),
                  onToChanged: (time) => controller.setToTime(index, time),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
            );
          },
        ),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  final DayOpeningHours day;
  final ValueChanged<bool> onToggle;
  final ValueChanged<TimeOfDay> onFromChanged;
  final ValueChanged<TimeOfDay> onToChanged;

  const _DayRow({
    required this.day,
    required this.onToggle,
    required this.onFromChanged,
    required this.onToChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(day.day, style: AppTextStyles.bodyLarge),
        ),
        Switch(
          value: day.isOpen,
          onChanged: onToggle,
          activeThumbColor: AppColors.primary,
        ),
        const Spacer(),
        if (day.isOpen) ...[
          _TimePickerField(
            time: day.from,
            onChanged: onFromChanged,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('-', style: AppTextStyles.bodyLarge),
          ),
          _TimePickerField(
            time: day.to,
            onChanged: onToChanged,
          ),
        ] else
          const Text('Closed', style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;

  const _TimePickerField({required this.time, required this.onChanged});

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null && picked != time) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(224, 224, 224, 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time.format(context),
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textBlack),
        ),
      ),
    );
  }
}

