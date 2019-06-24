import 'package:flutter/material.dart';
import 'home_page.dart';
import 'tw_page.dart';
import 'ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
  
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googlSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {

    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  
  FirebaseUser userDetails = await _firebaseAuth.signInWithCredential(credential);
  ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);

  List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(providerInfo);

    UserDetails details = new UserDetails(
        userDetails.providerId,
        userDetails.displayName,
        userDetails.photoUrl,
        userDetails.email,
        providerData,
);

 Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ProfileScreen(detailsUser: details),
      ),
    );
    return userDetails;

  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final correo = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      onSaved: (value) =>
                      _email = value,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        
      ),
      
    );

    final contrasena = TextFormField(
      autofocus: false,
      initialValue: '',
      obscureText: true,
      onSaved: (value) =>
                      _password = value,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: (){
                      /*FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      ).then((FirebaseUser user){
                        */  Navigator.of(context).pushReplacementNamed(HomePage.tag);/*
                      }).catchError((e){
                        print(e);
                      });*/
                  },
        padding: EdgeInsets.all(12),
        color: Colors.redAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final loginGoogle = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () => _signIn(context)
                              .then((FirebaseUser user) => print(user))
                              .catchError((e) => print(e)),
        padding: EdgeInsets.all(12),
        color: Colors.redAccent,
        child: Text('Log In Google', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Tienes Redes Sociales? Conectate',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(TwPage.tag);
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            correo,
            SizedBox(height: 8.0),
            contrasena,
            SizedBox(height: 24.0),
            loginButton,
            SizedBox(height: 15.0),
            loginGoogle,
            forgotLabel
          ],
        ),
      ),
    );
  }
}

  class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails,this.userName, this.photoUrl,this.userEmail, this.providerData);
}

  class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
