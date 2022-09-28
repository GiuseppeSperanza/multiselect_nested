import 'package:multiselect_tree/models/multiselect_tree_item.dart';

class MultiSelectTreeController {
  late List<MultiSelectTreeItem> Function() getSelectedItems;
  late void Function() expandContainer;
  late void Function() clearValues;
}
