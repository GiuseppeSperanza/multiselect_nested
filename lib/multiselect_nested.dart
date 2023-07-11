library multiselect_nested_options;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_nested/components/selected_value_item.dart';
import 'package:multiselect_nested/constants/colors.dart';
import 'package:multiselect_nested/models/multiselect_nested_controller.dart';
import 'package:multiselect_nested/models/multiselect_nested_item.dart';

class MultiSelectNested extends StatefulWidget {
  ///
  /// The options which a user can see and select
  ///
  final List<MultiSelectNestedItem> options;

  ///
  /// Preselected options
  ///
  final List<MultiSelectNestedItem> selectedValues;

  ///
  /// Callback to pass the selectedValues to the parent
  /// It's triggered when you add or remove elements from the selected items
  /// Only works with the liveUpdateValues set to true
  ///
  final Function(List<MultiSelectNestedItem>)? setSelectedValues;

  ///
  /// Set to true if you want a live update of the values
  /// Be careful because it will trigger e rebuild on every
  /// added or removed element from the selectedValues
  /// which remove the smooth effect from the dropdown container.
  ///
  final bool liveUpdateValues;

  ///
  /// Add a partial check to the parent when one of his child is selected
  /// Be careful this works only with not multi hierarchical child
  ///
  final bool checkParentWhenChildIsSelected;

  ///
  /// Use this controller to get access to internal state of the Multiselect
  ///
  final MultiSelectNestedController? controller;

  ///
  /// Padding Dropdown content
  ///
  final EdgeInsets paddingDropdown;

  ///
  /// Padding Row Selected Items
  ///
  final EdgeInsets paddingSelectedItems;

  ///
  /// Set to true to use an Animated container which can accept Curve's effects
  ///
  final bool isAnimatedContainer;

  ///
  /// Customize the effect of the animated container
  ///
  final Curve effectAnimatedContainer;

  ///
  /// Duration of the Effect of the Animated Container
  ///
  final Duration durationEffect;

  ///
  /// Height of the Animated Container
  /// This value is only read with the Animated Container set to true because it requires a specific height to work.
  /// If it is not set, will be used the default height as value.
  ///
  final double heightDropdownContainer;

  ///
  /// Overwrite the default height of the animated container
  ///
  final double heightDropdownContainerDefault;

  ///
  /// Background Color of the Collapsible Dropdown
  ///
  final Color dropdownContainerColor;

  ///
  /// Background Color of the Selected Items
  ///
  final Color selectedItemColor;

  ///
  /// Color of the divider between the selected items
  ///
  final Color selectedItemDividerColor;

  ///
  /// Color of icon when items are collapsed
  ///
  final Color collapsedIconColor;

  ///
  /// Color of the row of the selected items
  ///
  final Color selectedItemsRowColor;

  ///
  /// Text to display in case of no items are provided
  ///
  final String noItemsText;

  ///
  /// Text Style of noItemsText
  ///
  final TextStyle noItemsTextStyle;

  ///
  /// Text Style of the labels inside the dropdown
  ///
  final TextStyle styleDropdownItemName;

  const MultiSelectNested({
    super.key,
    required this.options,
    this.controller,
    this.setSelectedValues,
    this.selectedValues = const <MultiSelectNestedItem>[],
    this.isAnimatedContainer = false,
    this.liveUpdateValues = false,
    this.checkParentWhenChildIsSelected = false,
    this.paddingDropdown = const EdgeInsets.all(8),
    this.paddingSelectedItems = const EdgeInsets.all(8),
    this.effectAnimatedContainer = Curves.fastOutSlowIn,
    this.durationEffect = const Duration(seconds: 1),
    this.heightDropdownContainer = 0,
    this.heightDropdownContainerDefault = 200,
    this.dropdownContainerColor = MultiSelectNestedColors.SECONDARY_LIGHT_COLOR,
    this.collapsedIconColor = MultiSelectNestedColors.PRIMARY,
    this.selectedItemColor = MultiSelectNestedColors.TERTIARY_COLOR,
    this.selectedItemDividerColor = MultiSelectNestedColors.SECONDARY_COLOR,
    this.noItemsText = 'No Items Selected...',
    this.selectedItemsRowColor = MultiSelectNestedColors.SECONDARY_LIGHT_COLOR,
    this.noItemsTextStyle = const TextStyle(
      fontSize: 12,
      color: MultiSelectNestedColors.PRIMARY_LIGHT_COLOR_01,
    ),
    this.styleDropdownItemName = const TextStyle(
      fontSize: 15,
      color: MultiSelectNestedColors.PRIMARY,
    ),
  });

  @override
  State<MultiSelectNested> createState() => _MultiSelectNestedState();
}

class _MultiSelectNestedState extends State<MultiSelectNested> {
  bool isExpanded = false;
  late double _height;
  final List<MultiSelectNestedItem> _localSelectedOptions = [];
  final Set<MultiSelectNestedItem> _checkedParent = <MultiSelectNestedItem>{};

  @override
  void initState() {
    super.initState();
    _height = widget.heightDropdownContainer;

    _localSelectedOptions.addAll(widget.selectedValues);
    if (widget.controller != null) {
      widget.controller!.getSelectedItems = getSelectedItems;
      widget.controller!.expandContainer = expandContainer;
      widget.controller!.clearValues = clearValues;
    }
  }

  List<MultiSelectNestedItem> getSelectedItems() {
    return _localSelectedOptions;
  }

  void clearValues() {
    setState(() {
      assert(_localSelectedOptions.isNotEmpty);
      for (MultiSelectNestedItem element in _localSelectedOptions) {
        element.setSelected(!element.isSelected);
      }
      _localSelectedOptions.clear();
      _checkedParent.clear();
      updateValues();
    });
  }

  void removeSelectedItem(label) {
    setState(() {
      _localSelectedOptions
          .removeWhere((MultiSelectNestedItem value) => value.name == label);
      updateValues();
    });
  }

  void updateValues() {
    if (widget.liveUpdateValues) {
      widget.setSelectedValues!(_localSelectedOptions);
    }
  }

  void expandContainer() {
    setState(() {
      isExpanded = !isExpanded;

      if (isExpanded) {
        _height = widget.heightDropdownContainer > 0
            ? widget.heightDropdownContainer
            : widget.heightDropdownContainerDefault;
      } else {
        _height = 0;
      }
    });
  }

  List<Widget> _buildChildren(List<MultiSelectNestedItem> children, level) {
    if (children.isEmpty) {
      return _buildContentDropdown(children, 0);
    } else {
      return _buildContentDropdown(children, ++level);
    }
  }

  void _addSelectedValue(MultiSelectNestedItem item) {
    if (!_checkIsSelected(item)) {
      _localSelectedOptions.add(item);
    } else {
      _localSelectedOptions.removeWhere(
          (MultiSelectNestedItem option) => option.name == item.name);
    }
  }

  bool _checkIsSelected(MultiSelectNestedItem item) {
    return _localSelectedOptions
                .indexWhere((option) => option.name == item.name) ==
            -1
        ? false
        : true;
  }

  void onChangeMultiChildrenElement(options, item) {
    setState(() {
      MultiSelectNestedItem selectedValue = options.firstWhere(
          (MultiSelectNestedItem element) => element.name == item.name);
      selectedValue.setSelected(!item.isSelected);
      _addSelectedValue(item);
      recursiveCheckSelected(item);
    });
    updateValues();
  }

  void recursiveCheckSelected(MultiSelectNestedItem item) {
    if (item.children.isNotEmpty) {
      for (MultiSelectNestedItem element in item.children) {
        if (!element.isSelected) {
          element.setSelected(!element.isSelected);
          _addSelectedValue(element);
          recursiveCheckSelected(element);
        }
        if (!item.isSelected) {
          element.setSelected(false);
          _addSelectedValue(element);
          recursiveCheckSelected(element);
        }
      }
    }
  }

  Future<void> _onChangeElement(List<MultiSelectNestedItem> options,
      MultiSelectNestedItem item, int level) async {
    setState(() {
      MultiSelectNestedItem selectedItem = options.firstWhere(
          (MultiSelectNestedItem element) => element.name == item.name);

      selectedItem.setSelected(!item.isSelected);
      _addSelectedValue(selectedItem);

      if (widget.checkParentWhenChildIsSelected) {
        _checkParentSelected(item, level);
      }
    });
    updateValues();
  }

  _checkParentSelected(MultiSelectNestedItem item, int level) {
    if (level > 0) {
      MultiSelectNestedItem? selectedParent;
      for (MultiSelectNestedItem parent in widget.options) {
        for (MultiSelectNestedItem children in parent.children) {
          if (item.id == children.id) {
            selectedParent = parent;
          }
        }
      }

      MultiSelectNestedItem? isParentSelected = _localSelectedOptions
          .firstWhereOrNull((MultiSelectNestedItem element) =>
              element.id == selectedParent!.id);

      if (isParentSelected == null &&
          !_checkedParent.contains(selectedParent)) {
        _checkedParent.add(selectedParent!);
      } else {
        List<MultiSelectNestedItem> parentChild = selectedParent!.children;
        bool isPresent = false;
        int childPresent = 0;
        for (MultiSelectNestedItem child in parentChild) {
          if (_localSelectedOptions.contains(child)) {
            isPresent = true;
            childPresent += 1;
          }
        }
        if (!isPresent) {
          _checkedParent.remove(selectedParent);
        }
        if (childPresent == parentChild.length) {
          _checkedParent.remove(selectedParent);
          _localSelectedOptions.add(selectedParent);
        }
        if (childPresent > 0 && childPresent < parentChild.length) {
          _checkedParent.add(selectedParent);
          _localSelectedOptions.remove(selectedParent);
        }

        childPresent = 0;
      }
    }
  }

  List<Widget> _buildContentDropdown(
      List<MultiSelectNestedItem> options, int level) {
    return options.map((MultiSelectNestedItem item) {
      if (item.children.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(left: level * 10),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            iconColor: widget.collapsedIconColor,
            leading: Stack(
              children: [
                Checkbox(
                  value: _checkIsSelected(item),
                  onChanged: (bool? value) =>
                      onChangeMultiChildrenElement(options, item),
                ),
                _checkedParent.contains(item)
                    ? Positioned(
                        top: 15,
                        left: 15,
                        child: Container(
                          height: 18,
                          width: 18,
                          color: Colors.blue,
                          child: const Center(
                            child: Icon(
                              Icons.horizontal_rule,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            title: Text(
              item.name,
              style: widget.styleDropdownItemName,
            ),
            children: _buildChildren(item.children, level),
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.only(left: level * 10),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              item.name,
              style: widget.styleDropdownItemName,
            ),
            leading: Checkbox(
              value: _checkIsSelected(item),
              onChanged: (bool? value) => _onChangeElement(
                options,
                item,
                level,
              ),
            ),
          ),
        ); //
      }
    }).toList();
  }

  Widget _getDropdownContainer() {
    if (widget.isAnimatedContainer) {
      return Flexible(
        child: AnimatedContainer(
          padding: widget.paddingDropdown,
          width: double.infinity,
          height: _height,
          decoration: BoxDecoration(
            color: widget.dropdownContainerColor,
            border: const Border(
              bottom: BorderSide(
                color: MultiSelectNestedColors.PRIMARY_LIGHT_COLOR,
              ),
              left: BorderSide(
                color: MultiSelectNestedColors.PRIMARY_LIGHT_COLOR,
              ),
              right: BorderSide(
                color: MultiSelectNestedColors.PRIMARY_LIGHT_COLOR,
              ),
            ),
          ),
          duration: widget.durationEffect,
          curve: widget.effectAnimatedContainer,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildContentDropdown(widget.options, 0),
            ),
          ),
        ),
      );
    } else {
      if (isExpanded) {
        return Container(
          padding: widget.paddingDropdown,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.dropdownContainerColor,
            border: const Border(
              bottom: BorderSide(
                color: MultiSelectNestedColors.PRIMARY_LIGHT_COLOR,
              ),
              left: BorderSide(
                color: MultiSelectNestedColors.PRIMARY_LIGHT_COLOR,
              ),
              right: BorderSide(
                color: MultiSelectNestedColors.PRIMARY_LIGHT_COLOR,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Theme(
              data: ThemeData()
                  .copyWith(dividerColor: MultiSelectNestedColors.TRANSPARENT),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildContentDropdown(widget.options, 0),
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: MultiSelectNestedColors.PRIMARY_LIGHT_COLOR,
          )),
          child: Stack(
            children: [
              Container(
                color: widget.selectedItemsRowColor,
                child: Padding(
                  padding: widget.paddingSelectedItems,
                  child: Row(
                    children: [
                      Expanded(
                        child: _localSelectedOptions.isNotEmpty
                            ? Wrap(
                                spacing: 10.0,
                                runSpacing: 8.0,
                                children: _localSelectedOptions
                                    .map(
                                      (item) => SelectedValueItem(
                                        label: item.name,
                                        gestureTapCallback: () =>
                                            removeSelectedItem(item.name),
                                        backgroundColor:
                                            widget.selectedItemColor,
                                        dividerColor:
                                            widget.selectedItemDividerColor,
                                      ),
                                    )
                                    .toList(),
                              )
                            : Text(
                                widget.noItemsText,
                                style: widget.noItemsTextStyle,
                              ),
                      ),
                      InkWell(
                        onTap: () {
                          expandContainer();
                        },
                        child: isExpanded
                            ? const Icon(Icons.arrow_drop_up)
                            : const Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _getDropdownContainer(),
      ],
    );
  }
}
