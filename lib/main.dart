import 'package:authentication/firebase_options.dart';
import 'package:authentication/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Auth()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);

    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: !provider.isCodeSend
            ? Center(
                child: Container(
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Phone",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        controller: provider.phone_ctr,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        controller: provider.pass_ctr,
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          width: double.infinity,
                          height: 50,
                          child: provider.isSignUpLoading
                              ? SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: () {
                                    provider.signUpLoading(true);
                                    provider.signUp();
                                  },
                                  child: Text("SignUp"))),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {}, child: Text("SignIn")))
                    ],
                  ),
                ),
              )
            : Center(
                child: Column(children: [
                  TextField(
                    controller: provider.otp_ctr,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        provider.signInWithPhoneAuthCred(context);
                      },
                      child: provider.verifyLoading
                          ? Container(
                              width: 35,
                              height: 35,
                              child: CircularProgressIndicator())
                          : Text("Next"))
                ]),
              ));
  }
}
