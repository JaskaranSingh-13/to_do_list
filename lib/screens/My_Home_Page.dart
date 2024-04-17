// ignore_for_file: unused_import, unused_local_variable, file_names, unnecessary_string_interpolations, avoid_unnecessary_containers, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final List<String> tasks = <String>[];

  final List<bool> checkboxes = List.generate(8, (index) => false);

  bool isChecked = false;

  FocusNode _textFieldFocusNode = FocusNode();

  /*
  The TextEditingController class allows us to 
  grab the input from the TextField() widget
  This will be used later on to store the value
  in the database.
  */

  TextEditingController nameController = TextEditingController();

  void addItemToList() async {
    final String taskName = nameController.text;

    //Add to the Firestore collection
    await db.collection('tasks').add({
      'name': taskName,
      'completed': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      tasks.insert(0, taskName);
      checkboxes.insert(0, false);
    });
  }

  void removeItem(int index) async {
    //Get the task name to be removed
    String taskNameToRemove = tasks[index];

    //Remove the task form the Firestore database
    QuerySnapshot querySnapshot = await db
        .collection('tasks')
        .where('name', isEqualTo: taskNameToRemove)
        .get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

      //Update the completed field to the new completion status
      await documentSnapshot.reference.delete();
    }

    //Remove task from the task list and the checkboxes list
    setState(() {
      tasks.removeAt(index);
      checkboxes.removeAt(index);
    });
  }

  void clearTextField() {
    setState(() {
      nameController.clear();
    });
  }

  Future<void> fetchTasksFromFirestore() async {
    //Get a reference to the 'tasks' collection in Firestore

    CollectionReference tasksCollection = db.collection('tasks');

    //Fetch the documents (tasks) from the collection
    QuerySnapshot querySnapshot = await tasksCollection.get();

    //Create an empty list to store the fetched tasks names
    List<String> fetchedTasks = [];

    //Look through each doc (task) in the querySnapshot object

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      //Getting the task name from the document's data
      String taskName = docSnapshot.get('name');

      //Getting the completion status of the task
      //bool completed = docSnapshot.get('completed');

      //Add the task name to the list of fetched tasks
      fetchedTasks.add(taskName);
    }

    //Update the state to reflect the fetched tasks

    setState(() {
      tasks.clear(); // Clear the existing task list
      tasks.addAll(fetchedTasks);
    });
  }

  //Asynchronous function to update the completion status of the task in Firestore

  Future<void> updateTaskCompletionStatus(
      String taskName, bool completed) async {
    //Get a reference to the 'tasks' collection in Firestore
    CollectionReference tasksCollection = db.collection('tasks');

    //Query Firestore for documents (tasks) with the given task name
    QuerySnapshot querySnapshot =
        await tasksCollection.where('name', isEqualTo: taskName).get();

    //If a matching task document is found
    if (querySnapshot.size > 0) {
      //Get a reference to the first matching document
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

      //Update the completed field to the new completion status
      await documentSnapshot.reference.update({'completed': completed});
    }

    setState(() {
      //find the index of the task in the task list
      int taskIndex = tasks.indexWhere((task) => task == taskName);

      //Update the corresponding checkbox value in the checkboxes list
      checkboxes[taskIndex] = completed;
    });
  }

//Override the initState method of the State class
  @override
  void initState() {
    super.initState();

    //Call the function to fetched the tasks from the database
    fetchTasksFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 136, 158),
        /*
            Rows() and Columns() both have the mainAxisAlignment 
            property we can utilize to space out their child 
            widgets to our desired format.
           */
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              /*
            SizedBox allows us to control the vertical 
            and horizontal dimensions by manipulating the 
            height or width property, or both.
            */
              height: 70,
              child: Image.asset('assets/rdplogo.png'),
            ),
            const Text(
              'Daily Planner',
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 300,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      /*
          The TableCalendar() widget below is installed via 
          "flutter pub get table_calendar" or by adding the package 
          to the pubspec.yaml file.  We then import it and implement using
          configuration properties.  You can set a range and a focus day. 
          The particulars of implementation for any package can be gleaned 
          from pub.dev: https://pub.dev/packages/table_calendar.
          */
                      TableCalendar(
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2023),
                    lastDay: DateTime(2025),
                  ),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(4),
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: checkboxes[index]
                            ? Colors.green.withOpacity(0.7)
                            : Colors.blue.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            !checkboxes[index]
                                ? Icons.manage_history
                                : Icons.playlist_add_check_circle,
                            size: 32,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Text(
                              '${tasks[index]}',
                              style: checkboxes[index]
                                  ? TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.5))
                                  : const TextStyle(fontSize: 20),
                            ),
                          ),
                          Checkbox(
                            value: checkboxes[index],
                            onChanged: (newValue) {
                              setState(() {
                                checkboxes[index] = newValue!;
                              });
                              updateTaskCompletionStatus(
                                  tasks[index], newValue!);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              removeItem(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 25, right: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: nameController,
                        focusNode: _textFieldFocusNode,
                        style: const TextStyle(fontSize: 18),
                        maxLength: 20,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Add To-Do List Item',
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                          hintText: 'Enter your task here',
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      clearTextField();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  addItemToList();
                  _textFieldFocusNode.unfocus();
                  clearTextField();
                },
                child: const Text('Add To-Do Item'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
