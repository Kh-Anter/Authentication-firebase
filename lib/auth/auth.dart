import 'package:authentication/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Auth with ChangeNotifier {
  bool isCodeSend = false;
  bool isSignUpLoading = false;
  bool verificationDone = false;
  bool verifyLoading = false;
  var verificationId;

  TextEditingController phone_ctr = TextEditingController();
  TextEditingController pass_ctr = TextEditingController();
  TextEditingController otp_ctr = TextEditingController();

  void signUpLoading(bool x) {
    isSignUpLoading = x;
    notifyListeners();
  }

  Future signUp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2${phone_ctr.value.text}',
      verificationCompleted: (PhoneAuthCredential credential) {
        otp_ctr.text = credential.smsCode.toString();
        verifyLoading = true;
        print("verification done");
        notifyListeners();
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verification Faild -------- ${e.code}");
      },
      codeSent: (String verificationId, int? resendToken) {
        print("-------------code sent");
        this.verificationId = verificationId;
        isCodeSend = true;
        isSignUpLoading = false;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void signInWithPhoneAuthCred(context) async {
    verifyLoading = true;
    notifyListeners();
    try {
      var auth = FirebaseAuth.instance;
      AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp_ctr.text);
      var userCred = await auth.createUserWithEmailAndPassword(
          email: "2${phone_ctr.text}@reshop.com", password: pass_ctr.text);
      await auth.currentUser?.linkWithCredential(phoneAuthCredential);

      if (userCred.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      print("-------------------------------- ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some Error Occured. Try Again Later')));
    }
    verifyLoading = false;
    notifyListeners();
  }

  void linkWithEmail() {
    var auth = FirebaseAuth.instance;
    AuthCredential credential = EmailAuthProvider.credential(
        email: "2${phone_ctr.text}@reshop.com", password: pass_ctr.text);
    auth.currentUser?.linkWithCredential(credential);
  }
}
