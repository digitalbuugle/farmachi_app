import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:farmachi/home_screen.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  AddState createState() => AddState();
}

class AddState extends State<Add> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _formeController = TextEditingController();

  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    var rng = Random();
    var k = rng.nextInt(10000);

    final refs = fb.ref().child('Medication/$k');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Medication"),
        backgroundColor: Colors.indigo[900],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _nameController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.indigo[900]),
              decoration: InputDecoration(
                hintText: 'Enter Medication Name',
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _doseController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.indigo[900]),
              decoration: InputDecoration(
                hintText: 'Enter Medication Dose',
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _formeController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.indigo[900]),
              decoration: InputDecoration(
                hintText: 'Enter Medication Forme',
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _priceController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.indigo[900]),
              decoration: InputDecoration(
                hintText: 'Enter Medication Price',
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.green,
                onPressed: () {
                  refs.set({
                    "name": _nameController.text,
                    "forme": _formeController.text,
                    "dose": _doseController.text,
                    "price": _priceController.text,
                  }).asStream();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()));
                },
                child: const Text(
                  "save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()));
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
