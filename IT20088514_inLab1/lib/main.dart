import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:labtest/Auth/sign-up-page.dart';
import 'package:labtest/recipieModel.dart';
import 'firebase_options.dart';

void main() async{
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
      title: 'Lab Test session02',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Recipie List'),
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
  void initState(){
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
         Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const SignUppage(),
            ),
          );
      } else {
        print('User successfully signed in!');
        print("User ${user.toString()}");
      }
  });
  }
  
  //create list to store recipie list
  //List<RecipieModel> recipieList = [];
  int recepieListlength = 0;
  final db = FirebaseFirestore.instance;

  // create controllers to handle inputs
  TextEditingController taskController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // create a boolean variable to handle input fields
  bool viewInputfields = false;

  // create a function to add new todo
  void _addnewRecipie(String title , String description ) async {

    final docRef = db.collection('recipieList').doc();
    docRef.set(RecipieModel(recepieListlength,title, description , ["sault","pepper"]).toJson()).then(
      (value) => Fluttertoast.showToast(msg:"Recipie added successfully!"),
      onError: (e) => print("Error in adding Recipie: $e"));

    recepieListlength++;
    setState(() {});
  }

  // create a function to remove todo
  void _removeRecipie(dynamic docID,RecipieModel todo) {
        print(todo.id);
        db.collection('recipieList').doc(docID.toString()).delete().then(
            (value) => Fluttertoast.showToast(msg:"Recipie deleted Successfully!"),
            onError: (e) => print("Error deleting Recipie: $e"));
    setState(() {
      recepieListlength--;
    });
  }

  void _updateRecipe(dynamic docID,RecipieModel recipie) {
        recipie.description = "Updated";
        db.collection('recipieList').doc(docID.toString()).set(recipie.toJson()).then(
            (value) => Fluttertoast.showToast(msg:"Recipie updated Successfully!"),
            onError: (e) => print("Error updating Recipie: $e"));
    setState(() {
    });
  }

  Future getRecepieLists() async {
        return db.collection("recipieList").get();
    }

    Future<String?> signOut() async {
        try {
          await FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(msg:"Sign Out Successfull");
           Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const SignUppage(),
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
      backgroundColor: Color.fromARGB(255, 229, 149, 202),
      appBar: AppBar(
        title: Text(widget.title,
        style:const TextStyle(
          backgroundColor:Colors.purple,
          fontSize:15
          ),
        ),
        actions: [
              IconButton(
                onPressed: (){
                  signOut();
                },
                tooltip: 'SIGN OUT',
                icon: const Icon(Icons.logout_sharp)
              ), 
        ],
      ),
      body: Center(
        child: Stack(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //show and hide input fields according to the variable value
            if(viewInputfields)
            Container(
              padding: const EdgeInsets.all(20),
              height: 250,
              width: MediaQuery.of(context).size.width * 0.9 ,              
              decoration: BoxDecoration(                
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Add New Recipie',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,                      
                      ),
                    ),                  
                  ),
                  TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 15,),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          _addnewRecipie(taskController.text, nameController.text);
                          taskController.clear();
                          nameController.clear();
                          setState(() {
                            viewInputfields = false;
                          });
                        }, 
                        child: const Text('Add')                  
                    ),
                  )
                ],
              ),
            ),
            if(!viewInputfields) 
           FutureBuilder(
              future: getRecepieLists(),
              builder: ((context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data == null) {
                  return const SizedBox();
                }

                if (snapshot.data!.docs.isEmpty) {
                  print("List ${snapshot.data.docs}");
                  return const SizedBox(
                    child: Center(
                        child:
                            Text("No Recipies")),
                  );
                }

                if (snapshot.hasData) {
                  List<Map<dynamic,dynamic>> recipieList = [];

                  for (var doc in snapshot.data!.docs) {
                    final todo = RecipieModel.fromJson(doc.data() as Map<String, dynamic>);
                    Map<dynamic,dynamic> map = {
                      "docId":doc.id,
                      "todo":todo
                      };
                    recipieList.add(map);
                  }

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: recipieList.length,
                    itemBuilder: (context, index) {
                      return  Card(
                          child: ListTile(
                            title: Text(recipieList[index]["todo"].title!),
                            subtitle: Text(recipieList[index]["todo"].description!),                      
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip : "Press to mark complete",
                                  onPressed: () {
                                    _updateRecipe(recipieList[index]["docId"],recipieList[index]["todo"]);
                                  }, 
                                  icon: const Icon(
                                    Icons.edit_note_outlined,
                                    color: Colors.blue,
                                  ),
                                ),
                                IconButton(
                                  tooltip : "Press to delete Task",
                                  onPressed: () {
                                    _removeRecipie(recipieList[index]["docId"],recipieList[index]["todo"]);
                                  }, 
                                  icon: const Icon(
                                    Icons.delete_forever_rounded,
                                    color: Color.fromARGB(255, 218, 79, 69),)
                                ),
                              ],
                              )
                          ),
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
        onPressed: (){
          setState(() {
            viewInputfields = true;
          });
        },
        backgroundColor: Colors.purple ,
        tooltip: 'Add Recipie',
        child: const Icon(Icons.add_box),
      )
    );
  }
}
