import 'package:clock_app/settings/data/localized_names.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';



abstract class SettingItem {
  String name;
  String description;
  String id;
  SettingGroup? _parent;
  final List<void Function(dynamic)> _settingListeners;
  List<void Function(dynamic)> get settingListeners => _settingListeners;
  List<String> searchTags = [];
  List<EnableConditionParameter> enableConditions;
  // List<SettingCompoundEnableConditionParameter> compoundEnableConditions;
  // Settings which influence whether this setting is enabled
  List<EnableConditionEvaluator> enableSettings;
  // List<SettingCompoundEnableCondition> compoundEnableSettings;

  String displayName(BuildContext context) => getLocalizedSettingName(name, context);
  String displayDescription(BuildContext context) => getLocalizedSettingDescription(description, context);

  bool get isEnabled {
    for (var enableSetting in enableSettings) {
            if(!enableSetting.evaluate()){
              return false;
            }
    }

    return true;
  }

  SettingGroup? get parent => _parent;
  set parent(SettingGroup? parent) {
    _parent = parent;
    id = "${_parent?.id}/$name";
  }

  List<SettingGroup> get path {
    List<SettingGroup> path = [];
    SettingGroup? currentParent = parent;
    while (currentParent != null) {
      path.add(currentParent);
      currentParent = currentParent.parent;
    }
    return path.reversed.toList();
  }

  SettingItem(this.name, this.description, this.searchTags,
      this.enableConditions)
      : id = name,
        _settingListeners = [],
        enableSettings = [];

  SettingItem copy();

  dynamic valueToJson();

  void loadValueFromJson(dynamic value);

  void addListener(void Function(dynamic) listener) {
    _settingListeners.add(listener);
  }

  void removeListener(void Function(dynamic) listener) {
    _settingListeners.remove(listener);
  }

  void callListeners(Setting setting) {
    for (var listener in _settingListeners) {
      listener(setting.value);
    }
    parent?.callListeners(setting);
  }
}
