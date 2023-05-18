import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crud/sign_up_screen.dart';
import 'package:crud/todo_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 02',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MyHomePage(title: 'My TO - DO List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          ),
        );
      } else {
        print('User is signed in!');
        print("User ${user.toString()}");
      }
    });
  }

  //create list to store todo list
  //List<TODOModel> todoList = [];
  int todolength = 0;
  final db = FirebaseFirestore.instance;

  // create controllers to handle inputs
  TextEditingController taskController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // create a boolean variable to handle input fields
  bool viewInputfields = false;

  // create a function to add new todo
  void _addnewToDo(String task, String name) async {
    final docRef = db.collection('todoList').doc();
    docRef.set(TODOModel(todolength, task, name, 3).toJson()).then(
        (value) => Fluttertoast.showToast(msg: "TO - DO added successfully!"),
        onError: (e) => print("Error adding TODO: $e"));

    //todoList.add(TODOModel(todolength,task, name, 3));
    todolength++;
    setState(() {});
  }

  // create a function to remove todo
  void _removeToDo(dynamic docID, TODOModel todo) {
    print(todo.id);
    db.collection('todoList').doc(docID.toString()).delete().then(
        (value) => Fluttertoast.showToast(msg: "TO - DO deleted Successfully!"),
        onError: (e) => print("Error deleting TODO: $e"));
    setState(() {
      //print("todo list before delete ${todoList.toList()}");
      //todoList.removeAt(index);
      todolength--;
      //print("todo list after delete ${todoList.toList()}");
    });
  }

  void _changeStatusToDo(dynamic docID, TODOModel todo) {
    todo.status = 1;
    db.collection('todoList').doc(docID.toString()).set(todo.toJson()).then(
        (value) => Fluttertoast.showToast(msg: "TO - DO updated Successfully!"),
        onError: (e) => print("Error updating TODO: $e"));
    setState(() {
      //print("todo list before delete ${todoList.toString()}");
      //todoList[index].status = 1;
      //print("todo list after delete ${todoList.toString()}");
    });
  }

  Future getTODOLists() async {
    return db.collection("todoList").get();
  }

  Future<String?> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: "Sign Out Successfull");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        ),
      );
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  signOut();
                },
                tooltip: 'Sign Out',
                icon: const Icon(Icons.logout_outlined)),
          ],
        ),
        body: Center(
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //show and hide input fields according to the variable value
              if (viewInputfields)
                Container(
                  padding: const EdgeInsets.all(20),
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromARGB(255, 168, 38, 38)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          'Add New TO - DO',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextField(
                        controller: taskController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Task',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Name',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              _addnewToDo(
                                  taskController.text, nameController.text);
                              taskController.clear();
                              nameController.clear();
                              setState(() {
                                viewInputfields = false;
                              });
                            },
                            child: const Text('Add')),
                      )
                    ],
                  ),
                ),
              if (!viewInputfields)
                FutureBuilder(
                  future: getTODOLists(),
                  builder: ((context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data == null) {
                      return const SizedBox();
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return const SizedBox(
                        child: Center(child: Text("No TO - DOs")),
                      );
                    }

                    if (snapshot.hasData) {
                      List<Map<dynamic, dynamic>> todoList = [];

                      for (var doc in snapshot.data!.docs) {
                        final todo = TODOModel.fromJson(
                            doc.data() as Map<String, dynamic>);
                        Map<dynamic, dynamic> map = {
                          "docId": doc.id,
                          "todo": todo
                        };
                        todoList.add(map);
                      }

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                                title: Text(todoList[index]["todo"].task!),
                                subtitle: Text(todoList[index]["todo"].name!),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        tooltip: "Press to mark complete",
                                        onPressed: () {
                                          _changeStatusToDo(
                                              todoList[index]["docId"],
                                              todoList[index]["todo"]);
                                        },
                                        icon: Icon(
                                          todoList[index]["todo"].status! == 1
                                              ? Icons.check_circle_rounded
                                              : Icons.check_circle_outline,
                                          color:
                                              todoList[index]["todo"].status! ==
                                                      1
                                                  ? Colors.green
                                                  : Color.fromARGB(
                                                      255, 24, 252, 240),
                                        )),
                                    IconButton(
                                        tooltip: "Press to delete Task",
                                        onPressed: () {
                                          _removeToDo(todoList[index]["docId"],
                                              todoList[index]["todo"]);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(255, 14, 0, 0),
                                        )),
                                  ],
                                )),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  }),
                )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              viewInputfields = true;
            });
          },
          tooltip: 'Add TO - DO',
          child: const Icon(Icons.add),
        ));
  }
}
