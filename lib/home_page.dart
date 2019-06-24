import 'package:flutter/material.dart';


void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  static String tag = 'home-page';
  static const String _title = 'Inicio';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontFamily: 'Nunito', fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Inicio',
      style: optionStyle,

    ),
    Text(
      'Index 1: Tickets',
      style: optionStyle,
    ),
    Text(
      'Index 2: Ajustes',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.turned_in_not),
            title: Text('Tickets'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            title: Text('Ajustes'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[400],
        onTap: _onItemTapped,
      ),
    );
  }
}