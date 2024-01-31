import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget{

 

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return ChangeNotifierProvider(
      create:(context) => MyAppState(),
      child:MaterialApp(
        title: 'Mi primer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)
        ),
        home:MyHomePage(),
      )
    );
  }
  
}

class MyAppState extends ChangeNotifier{
    var current = WordPair.random();

    void getNext(){
      current = WordPair.random();
      notifyListeners();
    }

    var favorites = <WordPair>[];


    void toggleFavorite(){
      if(favorites.contains(current))
      {
        favorites.remove(current);
      }else{
        favorites.add(current);
      }
      notifyListeners();
    }
  }



class MyHomePage extends StatelessWidget{

  late double _deviceWidth;
  late double _deviceHeight;

  @override
  Widget build(BuildContext context) {
        _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
   
  IconData icon;

  if(appState.favorites.contains(pair)){
    icon = Icons.favorite;
  }else{
    icon = Icons.favorite_border;
  }
    return Scaffold(
      body:Container(
        width: _deviceWidth * 0.60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Text('A Random AWESOME Idea'),
            BigCard(pair: pair),
            
            Container(
              margin:EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  // Boton Like
                  ElevatedButton(
                onPressed: () {
                  appState.toggleFavorite();
                } ,
                child:Padding(
                  padding:  EdgeInsets.fromLTRB(0,0,0,0),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                      ),
                      Text('Like')
                    ],
                  )
                  ),
                ),
              
              SizedBox(
                width: _deviceWidth * 0.02,
              ),
                // Boton Next
                ElevatedButton(
                onPressed: () {
                  appState.getNext();
                } ,
                child:Padding(
                  padding:  EdgeInsets.fromLTRB(10,0,0,0),
                  child: Text('Next')
                  ),
                )
                ],
              ),
            )
          ],
          
        ),
      )
      
    );
  }
  
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.greenAccent,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),semanticsLabel: "${pair.first} ${pair.second}",),
      ),
    );
  }
}