import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:farmachi/Add.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

final fb = FirebaseDatabase.instance;

class HomeScreenState extends State<HomeScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var medication;
  // ignore: prefer_typing_uninitialized_variables
  var g;
  // ignore: prefer_typing_uninitialized_variables
  var k;

  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _formeController = TextEditingController();

  Future<void> _update() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              // prevent the soft keyboard from covering text fields
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: "Enter Name"),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Enter Medication Name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(hintText: "Enter dose"),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Enter Medication dose";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _formeController,
                decoration: const InputDecoration(hintText: "Enter Forme"),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Enter Medication Forme";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(hintText: "Enter price"),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Enter Medication price";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref("Medication/$k");
                    // Update
                    await ref.update({
                      "name": _nameController.text,
                      "forme": _formeController.text,
                      "dose": _doseController.text,
                      "price": _priceController.text,
                    });
                    _nameController.clear();
                    _formeController.clear();
                    _doseController.clear();
                    _priceController.clear();

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  })
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('Medication');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Farmachi")),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Add()))
            },
          ),
        ],
      ),
      body: FirebaseAnimatedList(
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          var v = snapshot.value.toString(); // {Name: whatever, Dose: Whatever}

          g = v.replaceAll(RegExp("{|}|Dose: |Name: |Forme: |Price: "), "");
          g.trim();

          medication = g.split(',');

          return GestureDetector(
            onTap: () {
              var c = snapshot.value.toString();
              if (kDebugMode) {
                print(c);
              }
            },
            child: InkWell(
              onTap: () {
                setState(() {
                  k = snapshot.key;
                });
              },
              child: Container(
                height: 135,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: Theme.of(context).backgroundColor,
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    "${medication[2]}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(32.0),
                                    // Update the medication
                                    onTap: () {
                                      setState(() {
                                        k = snapshot.key;
                                      });

                                      _update();
                                    },
                                    child: const SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  medication[1],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  medication[0],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  medication[3],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(4.0),
                                    onTap: () {
                                      ref.child(snapshot.key!).remove();
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
