import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:multiselect_nested/models/multiselect_nested_controller.dart';
import 'package:multiselect_nested/models/multiselect_nested_item.dart';
import 'package:multiselect_nested/multiselect_nested.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<MultiSelectNestedItem> selected = [];
  MultiSelectNestedController multiSelectController =
      MultiSelectNestedController();

  Future<List<MultiSelectNestedItem>> getJson() async {
    var data = await rootBundle.loadString('assets/example_data.json');
    return multiSelectNestedFromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                FutureBuilder<List<MultiSelectNestedItem>>(
                  future: getJson(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<MultiSelectNestedItem>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('Loading....');
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Column(
                            children: [
                              MultiSelectNested(
                                controller: multiSelectController,
                                options: snapshot.data!,
                                selectedValues: selected,
                                isAnimatedContainer: false,
                                liveUpdateValues: false,
                                checkParentWhenChildIsSelected: true,
                                setSelectedValues:
                                    (List<MultiSelectNestedItem> newValues) {
                                  setState(() {
                                    selected = newValues;
                                  });
                                },
                              ),
                            ],
                          );
                        }
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    print(
                        'values ${multiSelectController.getSelectedItems()} ${multiSelectController.getSelectedItems().length}');
                    setState(() {
                      selected = multiSelectController.getSelectedItems();
                    });
                  },
                  child: const Text('Update and Get Values'),
                ),
                ElevatedButton(
                  onPressed: () {
                    multiSelectController.clearValues();
                  },
                  child: const Text('Clear Values'),
                ),
                ElevatedButton(
                  onPressed: () {
                    multiSelectController.expandContainer();
                  },
                  child: const Text('Programmatically Expand Container'),
                ),
                const SizedBox(
                  height: 20,
                ),
                selected.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: selected.map((MultiSelectNestedItem item) {
                          return Text(item.name);
                        }).toList(),
                      )
                    : const Text('Still No Selected Values..')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
