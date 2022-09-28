import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_tree/models/multiselect_tree_controller.dart';
import 'package:multiselect_tree/models/multiselect_tree_item.dart';

import 'package:multiselect_tree/multiselect_tree.dart';

import 'multiselect_tree_test_component.dart';

void main() {
  testWidgets('MultiSelectTree with no Items selected', (tester) async {
    await tester.pumpWidget(MultiSelectTreeTestComponent(
      child: MultiSelectTree(
        controller: MultiSelectTreeController(),
        options: const <MultiSelectTreeItem>[],
        selectedValues: const <MultiSelectTreeItem>[],
      ),
    ));

    expect(find.text('No Items Selected...'), findsOneWidget);
  });

  testWidgets('MultiSelectTree with custom string for no Items selected',
      (tester) async {
    await tester.pumpWidget(MultiSelectTreeTestComponent(
      child: MultiSelectTree(
        controller: MultiSelectTreeController(),
        options: const <MultiSelectTreeItem>[],
        selectedValues: const <MultiSelectTreeItem>[],
        noItemsText: 'Still no values.',
      ),
    ));
    expect(find.text('No Items Selected...'), findsNothing);
    expect(find.text('Still no values.'), findsOneWidget);
  });

  testWidgets('MultiSelectTree with 2 Items selected', (tester) async {
    const String selectedValue1 = 'Selected Value 1';
    const String selectedValue2 = 'Selected Value 2';

    List<MultiSelectTreeItem> selectedValues = [
      MultiSelectTreeItem(
        id: 1,
        name: selectedValue1,
        children: [],
      ),
      MultiSelectTreeItem(
        id: 2,
        name: selectedValue2,
        children: [],
      ),
    ];

    await tester.pumpWidget(MultiSelectTreeTestComponent(
      child: MultiSelectTree(
        controller: MultiSelectTreeController(),
        options: const <MultiSelectTreeItem>[],
        selectedValues: selectedValues,
      ),
    ));

    expect(find.text(selectedValue1), findsOneWidget);
    expect(find.text(selectedValue2), findsOneWidget);
  });

  testWidgets('MultiSelectTree controller getSelectedItems', (tester) async {
    const String selectedValue1 = 'Selected Value 1';
    const String selectedValue2 = 'Selected Value 2';
    MultiSelectTreeController multiSelectController =
        MultiSelectTreeController();

    List<MultiSelectTreeItem> selectedValues = [
      MultiSelectTreeItem(
        id: 1,
        name: selectedValue1,
        children: [],
      ),
      MultiSelectTreeItem(
        id: 2,
        name: selectedValue2,
        children: [],
      ),
    ];

    await tester.pumpWidget(MultiSelectTreeTestComponent(
      child: MultiSelectTree(
        controller: multiSelectController,
        options: const <MultiSelectTreeItem>[],
        selectedValues: selectedValues,
      ),
    ));

    List<MultiSelectTreeItem> getSelectedItems =
        multiSelectController.getSelectedItems();
    expect(getSelectedItems.length, 2);
  });

  testWidgets('MultiSelectTree controller clearValues', (tester) async {
    const String selectedValue1 = 'Selected Value 1';
    const String selectedValue2 = 'Selected Value 2';
    MultiSelectTreeController multiSelectController =
        MultiSelectTreeController();
    List<MultiSelectTreeItem> selectedValues = [
      MultiSelectTreeItem(
        id: 1,
        name: selectedValue1,
        children: [],
      ),
      MultiSelectTreeItem(
        id: 2,
        name: selectedValue2,
        children: [],
      ),
    ];

    await tester.pumpWidget(MultiSelectTreeTestComponent(
      child: MultiSelectTree(
        controller: multiSelectController,
        options: const <MultiSelectTreeItem>[],
        selectedValues: selectedValues,
      ),
    ));

    List<MultiSelectTreeItem> getSelectedItems =
        multiSelectController.getSelectedItems();

    expect(getSelectedItems.length, 2);
    multiSelectController.clearValues();
    expect(getSelectedItems.length, 0);
  });
}
