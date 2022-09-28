import 'package:flutter_test/flutter_test.dart';
import 'package:multiselect_nested/models/multiselect_nested_controller.dart';
import 'package:multiselect_nested/models/multiselect_nested_item.dart';
import 'package:multiselect_nested/multiselect_nested.dart';

import 'multiselect_nested_test_component.dart';

void main() {
  testWidgets('MultiSelectNested with no Items selected', (tester) async {
    await tester.pumpWidget(MultiSelectNestedTestComponent(
      child: MultiSelectNested(
        controller: MultiSelectNestedController(),
        options: const <MultiSelectNestedItem>[],
        selectedValues: const <MultiSelectNestedItem>[],
      ),
    ));

    expect(find.text('No Items Selected...'), findsOneWidget);
  });

  testWidgets('MultiSelectNested with custom string for no Items selected',
      (tester) async {
    await tester.pumpWidget(MultiSelectNestedTestComponent(
      child: MultiSelectNested(
        controller: MultiSelectNestedController(),
        options: const <MultiSelectNestedItem>[],
        selectedValues: const <MultiSelectNestedItem>[],
        noItemsText: 'Still no values.',
      ),
    ));
    expect(find.text('No Items Selected...'), findsNothing);
    expect(find.text('Still no values.'), findsOneWidget);
  });

  testWidgets('MultiSelectNested with 2 Items selected', (tester) async {
    const String selectedValue1 = 'Selected Value 1';
    const String selectedValue2 = 'Selected Value 2';

    List<MultiSelectNestedItem> selectedValues = [
      MultiSelectNestedItem(
        id: 1,
        name: selectedValue1,
        children: [],
      ),
      MultiSelectNestedItem(
        id: 2,
        name: selectedValue2,
        children: [],
      ),
    ];

    await tester.pumpWidget(MultiSelectNestedTestComponent(
      child: MultiSelectNested(
        controller: MultiSelectNestedController(),
        options: const <MultiSelectNestedItem>[],
        selectedValues: selectedValues,
      ),
    ));

    expect(find.text(selectedValue1), findsOneWidget);
    expect(find.text(selectedValue2), findsOneWidget);
  });

  testWidgets('MultiSelectNested controller getSelectedItems', (tester) async {
    const String selectedValue1 = 'Selected Value 1';
    const String selectedValue2 = 'Selected Value 2';
    MultiSelectNestedController multiSelectController =
        MultiSelectNestedController();

    List<MultiSelectNestedItem> selectedValues = [
      MultiSelectNestedItem(
        id: 1,
        name: selectedValue1,
        children: [],
      ),
      MultiSelectNestedItem(
        id: 2,
        name: selectedValue2,
        children: [],
      ),
    ];

    await tester.pumpWidget(MultiSelectNestedTestComponent(
      child: MultiSelectNested(
        controller: multiSelectController,
        options: const <MultiSelectNestedItem>[],
        selectedValues: selectedValues,
      ),
    ));

    List<MultiSelectNestedItem> getSelectedItems =
        multiSelectController.getSelectedItems();
    expect(getSelectedItems.length, 2);
  });

  testWidgets('MultiSelectNested controller clearValues', (tester) async {
    const String selectedValue1 = 'Selected Value 1';
    const String selectedValue2 = 'Selected Value 2';
    MultiSelectNestedController multiSelectController =
        MultiSelectNestedController();
    List<MultiSelectNestedItem> selectedValues = [
      MultiSelectNestedItem(
        id: 1,
        name: selectedValue1,
        children: [],
      ),
      MultiSelectNestedItem(
        id: 2,
        name: selectedValue2,
        children: [],
      ),
    ];

    await tester.pumpWidget(MultiSelectNestedTestComponent(
      child: MultiSelectNested(
        controller: multiSelectController,
        options: const <MultiSelectNestedItem>[],
        selectedValues: selectedValues,
      ),
    ));

    List<MultiSelectNestedItem> getSelectedItems =
        multiSelectController.getSelectedItems();

    expect(getSelectedItems.length, 2);
    multiSelectController.clearValues();
    expect(getSelectedItems.length, 0);
  });
}
