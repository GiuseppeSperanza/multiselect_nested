import 'dart:convert';

class MultiSelectNestedItem {
  dynamic id;
  String name;
  List<MultiSelectNestedItem> children;
  bool isSelected;

  MultiSelectNestedItem({
    required this.id,
    required this.name,
    required this.children,
    this.isSelected = false,
  });

  void setSelected(bool value) {
    isSelected = value;
  }

  factory MultiSelectNestedItem.fromJson(Map<String, dynamic> json) {
    return MultiSelectNestedItem(
      id: json['id'],
      name: json['name'],
      children: json["children"] == null
          ? []
          : List<MultiSelectNestedItem>.from(json["children"]
              .map((item) => MultiSelectNestedItem.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "children": children,
      };
}

List<MultiSelectNestedItem> multiSelectNestedFromJson(String str) =>
    List<MultiSelectNestedItem>.from(
        json.decode(str).map((x) => MultiSelectNestedItem.fromJson(x)));

String multiSelectNestedToJson(List<MultiSelectNestedItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
