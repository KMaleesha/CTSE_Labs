import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:labtest/Auth/sign-in-page.dart';

class SignUppage extends StatefulWidget {
  const SignUppage({ Key? key }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUppage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String?> registration(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    Fluttertoast.showToast(msg: "Successfully signUp.");
     Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const SignInPage(),
        ),
      );
    return null;
  } on FirebaseAuthException catch (ex) {
    print("Error ${ex.code} ${ex.message}");
    return "${ex.code}: ${ex.message}";
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
                padding: const EdgeInsets.all(20),
                height: 350,
                width: MediaQuery.of(context).size.width * 0.9 ,              
                decoration: BoxDecoration(                
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,                      
                        ),
                      ),                  
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              registration(emailController.text, passwordController.text);
                              emailController.clear();
                              passwordController.clear();
                            });
                          }, 
                          child: const Text('SIGN UP')                  
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => const SignInPage(),
                                ),
                              );                      
                          }, 
                          child: const Text('SIGN IN')                  
                      ),
                    )
                  ],
                ),
              ),
        ),
    );
  }

}