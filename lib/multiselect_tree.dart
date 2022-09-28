library multiselect_tree;

import 'package:flutter/material.dart';
import 'package:multiselect_tree/components/selected_value_item.dart';
import 'package:multiselect_tree/constants/colors.dart';
import 'package:multiselect_tree/models/multiselect_tree_controller.dart';
import 'package:multiselect_tree/models/multiselect_tree_item.dart';

class MultiSelectTree extends StatefulWidget {
  ///
  /// The options which a user can see and select
  ///
  final List<MultiSelectTreeItem> options;

  ///
  /// Preselected options
  ///
  final List<MultiSelectTreeItem> selectedValues;

  ///
  /// Callback to pass the selectedValues to the parent
  /// It's triggered when you add or remove elements from the selected items
  /// Only works with the liveUpdateValues set to true
  ///
  final Function(List<MultiSelectTreeItem>)? setSelectedValues;

  ///
  /// Set to true if you want a live update of the values
  /// Be careful because it will trigger e rebuild on every
  /// added or removed element from the selectedValues
  /// which remove the smooth effect from the dropdown container.
  ///
  final bool liveUpdateValues;

  ///
  /// Use this controller to get access to internal state of the Multiselect
  ///
  final MultiSelectTreeController? controller;

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

  const MultiSelectTree({
    super.key,
    required this.options,
    this.controller,
    this.setSelectedValues,
    this.selectedValues = const <MultiSelectTreeItem>[],
    this.isAnimatedContainer = false,
    this.liveUpdateValues = false,
    this.paddingDropdown = const EdgeInsets.all(8),
    this.paddingSelectedItems = const EdgeInsets.all(8),
    this.effectAnimatedContainer = Curves.fastOutSlowIn,
    this.durationEffect = const Duration(seconds: 1),
    this.heightDropdownContainer = 0,
    this.heightDropdownContainerDefault = 200,
    this.dropdownContainerColor = MultiSelectTreeColors.SECONDARY_LIGHT_COLOR,
    this.collapsedIconColor = MultiSelectTreeColors.PRIMARY,
    this.selectedItemColor = MultiSelectTreeColors.TERTIARY_COLOR,
    this.selectedItemDividerColor = MultiSelectTreeColors.SECONDARY_COLOR,
    this.noItemsText = 'No Items Selected...',
    this.selectedItemsRowColor = MultiSelectTreeColors.SECONDARY_LIGHT_COLOR,
    this.noItemsTextStyle = const TextStyle(
      fontSize: 12,
      color: MultiSelectTreeColors.PRIMARY_LIGHT_COLOR_01,
    ),
    this.styleDropdownItemName = const TextStyle(
      fontSize: 15,
      color: MultiSelectTreeColors.PRIMARY,
    ),
  });

  @override
  State<MultiSelectTree> createState() => _MultiSelectTreeState();
}

class _MultiSelectTreeState extends State<MultiSelectTree> {
  bool isExpanded = false;
  late double _height;
  final List<MultiSelectTreeItem> _localSelectedOptions = [];

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

  List<MultiSelectTreeItem> getSelectedItems() {
    return _localSelectedOptions;
  }

  void clearValues() {
    setState(() {
      assert(_localSelectedOptions.isNotEmpty);
      for (MultiSelectTreeItem element in _localSelectedOptions) {
        element.setSelected(!element.isSelected);
      }
      _localSelectedOptions.clear();
      updateValues();
    });
  }

  void removeSelectedItem(label) {
    setState(() {
      _localSelectedOptions
          .removeWhere((MultiSelectTreeItem value) => value.name == label);
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

  List<Widget> _buildChildren(List<MultiSelectTreeItem> children, level) {
    if (children.isEmpty) {
      return _buildContentDropdown(children, 0);
    } else {
      return _buildContentDropdown(children, ++level);
    }
  }

  void _addSelectedValue(MultiSelectTreeItem item) {
    if (!_checkIsSelected(item)) {
      _localSelectedOptions.add(item);
    } else {
      _localSelectedOptions.removeWhere(
          (MultiSelectTreeItem option) => option.name == item.name);
    }
  }

  bool _checkIsSelected(MultiSelectTreeItem item) {
    return _localSelectedOptions
                .indexWhere((option) => option.name == item.name) ==
            -1
        ? false
        : true;
  }

  void onChangeMultiChildrenElement(options, item) {
    setState(() {
      MultiSelectTreeItem selectedValue = options.firstWhere(
          (MultiSelectTreeItem element) => element.name == item.name);
      // Set parent to true

      selectedValue.setSelected(!item.isSelected);
      _addSelectedValue(item);
      recursiveCheckSelected(item);
    });
    updateValues();
  }

  void recursiveCheckSelected(MultiSelectTreeItem item) {
    if (item.children.isNotEmpty) {
      for (MultiSelectTreeItem element in item.children) {
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

  Future<void> _onChangeElement(options, item) async {
    setState(() {
      MultiSelectTreeItem selectedItem = options.firstWhere(
          (MultiSelectTreeItem element) => element.name == item.name);

      selectedItem.setSelected(!item.isSelected);

      _addSelectedValue(selectedItem);
    });
    updateValues();
  }

  List<Widget> _buildContentDropdown(
      List<MultiSelectTreeItem> options, int level) {
    return options.map((MultiSelectTreeItem item) {
      if (item.children.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(left: level * 10),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            iconColor: widget.collapsedIconColor,
            leading: Checkbox(
              value: _checkIsSelected(item),
              onChanged: (bool? value) =>
                  onChangeMultiChildrenElement(options, item),
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
              onChanged: (bool? value) => _onChangeElement(options, item),
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
                color: MultiSelectTreeColors.PRIMARY_LIGHT_COLOR,
              ),
              left: BorderSide(
                color: MultiSelectTreeColors.PRIMARY_LIGHT_COLOR,
              ),
              right: BorderSide(
                color: MultiSelectTreeColors.PRIMARY_LIGHT_COLOR,
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
                color: MultiSelectTreeColors.PRIMARY_LIGHT_COLOR,
              ),
              left: BorderSide(
                color: MultiSelectTreeColors.PRIMARY_LIGHT_COLOR,
              ),
              right: BorderSide(
                color: MultiSelectTreeColors.PRIMARY_LIGHT_COLOR,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Theme(
              data: ThemeData()
                  .copyWith(dividerColor: MultiSelectTreeColors.TRANSPARENT),
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
            color: MultiSelectTreeColors.PRIMARY_LIGHT_COLOR,
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
