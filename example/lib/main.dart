import 'package:flutter/material.dart';
import 'package:multiselect_tree/models/multiselect_tree_controller.dart';
import 'package:multiselect_tree/models/multiselect_tree_item.dart';
import 'package:multiselect_tree/multiselect_tree.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  /*List<MultiSelectTreeItem> selected = [
    MultiSelectTreeItem(
      id: 1,
      name: 'Valore Selezionato 1',
      children: [],
    ),
    MultiSelectTreeItem(
      id: 2,
      name: 'Valore Selezionato 2 ',
      children: [],
    ),
  ];*/
  List<MultiSelectTreeItem> selected = [];
  MultiSelectTreeController multiSelectController = MultiSelectTreeController();

  Future<List<MultiSelectTreeItem>> getJson() async {
    var data = await rootBundle.loadString('assets/example_data.json');
    return multiSelectItemsFromJson(data);
  }

  @override
  void initState() {
    super.initState();
    getJson();
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
                FutureBuilder<List<MultiSelectTreeItem>>(
                  future: getJson(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<MultiSelectTreeItem>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('Loading....');
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Column(
                            children: [
                              MultiSelectTree(
                                controller: multiSelectController,
                                options: snapshot.data!,
                                selectedValues: selected,
                                isAnimatedContainer: false,
                                liveUpdateValues: false,
                                setSelectedValues:
                                    (List<MultiSelectTreeItem> newValues) {
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
                        children: selected.map((MultiSelectTreeItem item) {
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
