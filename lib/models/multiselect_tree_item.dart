import 'dart:convert';

class MultiSelectTreeItem {
  dynamic id;
  String name;
  List<MultiSelectTreeItem> children;
  bool isSelected;

  MultiSelectTreeItem({
    required this.id,
    required this.name,
    required this.children,
    this.isSelected = false,
  });

  void setSelected(bool value) {
    isSelected = value;
  }

  factory MultiSelectTreeItem.fromJson(Map<String, dynamic> json) {
    return MultiSelectTreeItem(
      id: json['id'],
      name: json['name'],
      children: json["children"] == null
          ? []
          : List<MultiSelectTreeItem>.from(json["children"]
              .map((item) => MultiSelectTreeItem.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "children": children,
      };
}

List<MultiSelectTreeItem> multiSelectItemsFromJson(String str) =>
    List<MultiSelectTreeItem>.from(
        json.decode(str).map((x) => MultiSelectTreeItem.fromJson(x)));

String multiSelectItemsToJson(List<MultiSelectTreeItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
