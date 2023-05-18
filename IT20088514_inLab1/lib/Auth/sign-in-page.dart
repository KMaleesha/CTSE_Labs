import 'package:labtest/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:labtest/Auth/sign-up-page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({ Key? key }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

 Future<String?> emailAuthentication(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    Fluttertoast.showToast(msg: "Successfully Sign In");
    Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) =>  MyHomePage(title: 'MY-RECIPIE-APP'),
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
                height: 400,
                width: MediaQuery.of(context).size.width * 0.9 ,              
                decoration: BoxDecoration(                
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'SIGN IN',
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
                              emailAuthentication(emailController.text, passwordController.text);
                              emailController.clear();
                              passwordController.clear();
                            });
                          }, 
                          child: const Text('SIGN IN')                  
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
                                  builder: (context) => const SignUppage(),
                                ),
                              );                      
                          }, 
                          child: const Text('Register to the system....')                  
                      ),
                    )
                  ],
                ),
              ),
        ),
    );
  }

}