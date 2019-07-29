import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(new TwPage());

class TwPage extends StatefulWidget {
  static String tag = 'tw-page';
  @override
  _TwPageState createState() => new _TwPageState();
}

class _TwPageState extends State<TwPage> {
  //login twitter
  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: '#################',
    consumerSecret: '###################################',
  );

  String _mensaje = 'Estado: Desconectado';

  void _login() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    String newMessage;

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        newMessage = 'Estado: Conectado -> Usuario: ${result.session.username}';
        break;
      case TwitterLoginStatus.cancelledByUser:
        newMessage = 'Login Cancelado por Usuario';
        break;
      case TwitterLoginStatus.error:
        newMessage = 'Error de Login: ${result.errorMessage}';
        break;
    }

    setState(() {
      _mensaje = newMessage;
    });
  }

  void _logout() async {
    await twitterLogin.logOut();

    setState(() {
      _mensaje = 'Desconectado';
    });
  }
  //Fin Login Twitter

  //login Facebook
  //variable booleana para conexión Facebook
  bool islogged = false;
  FirebaseUser myUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

    Future<FirebaseUser> _loginWithFacebook() async {
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logInWithReadPermissions(['email']);
      AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);

      debugPrint(result.status.toString());

      if(result.status == FacebookLoginStatus.loggedIn){
        FirebaseUser user = await _auth.signInWithCredential(credential).then((onValue){
          islogged = true;
        });
        return user;
    }
    return null;
    }

    void _loginFB(){
      _loginWithFacebook().then((response){
        if(response != null){
          myUser = response;
          islogged = true;
          setState(() {
            
          });
        }
      });
    }
    
    void _logoutFB() async {
      await _auth.signOut().then((response){
        islogged = false;
      });
    }//Fin Login Facebook

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.redAccent,
          title: new Text('Kimelu App - Log in'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(_mensaje),
              SizedBox(height:10.0),      
                Container(
                  width: 250.0,
                    child: Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Color(0xffffffff),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      Icon(FontAwesomeIcons.twitter,color: Color(0xff2195f3),),
                      SizedBox(width:10.0),
                      new Text('Log In Con Twitter', style: TextStyle(color: Colors.black,fontSize: 18.0, fontFamily: 'Nunito'),
                      ),
                    ],),
                   onPressed: _login,
                  ),
                )
                ),
                
                Container(
                  width: 250.0,
                    child: Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Color(0xffffffff),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      Icon(FontAwesomeIcons.twitter,color: Color(0xff2195f3),),
                      SizedBox(width:10.0),
                      Text(
                      'Cerrar Sesión',
                      style: TextStyle(color: Colors.black,fontSize: 18.0,fontFamily: 'Nunito'),
                    ),
                    ],),
                   onPressed: _logout,
                  ),
                )
                ),
                SizedBox(height:60.0),
                Container(
                  width: 250.0,
                    child: Align(
                  alignment: Alignment.center,
                  child: islogged ? Column(children: <Widget>[
                    Text("Nombre: " + myUser.displayName),
                    Image.network(myUser.photoUrl),
                  ],) : RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Color(0xffffffff),
                    child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      Icon(FontAwesomeIcons.facebook,color: Color(0xFF4A148C),),
                      SizedBox(width:10.0),
                      new Text('Log In Con Facebook', style: TextStyle(color: Colors.black,fontSize: 18.0, fontFamily: 'Nunito'),
                      ),
                    ],),
                   onPressed: _loginFB,
                  ),
                )
                ),

                Container(
                  width: 250.0,
                    child: Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Color(0xffffffff),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      Icon(FontAwesomeIcons.facebook,color: Color(0xFF4A148C),),
                      SizedBox(width:10.0),
                      new Text('Cerrar Sesion', style: TextStyle(color: Colors.black,fontSize: 18.0, fontFamily: 'Nunito'),
                      ),
                    ],),
                   onPressed: _logoutFB,
                  ),
                )
                ),

            ],

          ),
        ),
      ),
    );
  }
}
