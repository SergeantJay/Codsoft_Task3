import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/toggle_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class ToggleSettingCard<T> extends StatefulWidget {
  const ToggleSettingCard(
      {Key? key,
      required this.setting,
      this.showSummaryView = false,
      this.onChanged})
      : super(key: key);

  final ToggleSetting setting;
  final bool showSummaryView;
  final void Function(T)? onChanged;

  @override
  State<ToggleSettingCard<T>> createState() => _ToggleSettingCardState<T>();
}

class _ToggleSettingCardState<T> extends State<ToggleSettingCard<T>> {
  @override
  Widget build(BuildContext context) {
    ToggleCard<T> toggleCard = ToggleCard<T>(
      name: widget.setting.name,
      description: widget.setting.description,
      selectedItems: widget.setting.value,
      options: widget.setting.options
          .map((option) => ToggleOption<T>(option.name, option.value))
          .toList(),
      onChange: (value) {
        setState(() {
          widget.setting.toggle(context, value);
        });

        widget.onChanged?.call(widget.setting.value);
      },
    );

    return widget.showSummaryView
        ? toggleCard
        : CardContainer(child: toggleCard);
  }
}
