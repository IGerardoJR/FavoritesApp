import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Mi primer App',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme:
                  ColorScheme.fromSeed(seedColor: Colors.orangeAccent)),
          home: MyHomePage(),
        ));
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favoritesCount = 0;

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
      favoritesCount--;
    } else {
      favorites.add(current);
      favoritesCount++;
    }

    print(favorites);
    notifyListeners();
  }

  void eliminarTodo() {
    while (favorites.isNotEmpty) {
      favorites.removeRange(0, favorites.length);
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favoriteCount = appState.favoritesCount;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = favoriteCount > 0 ? FavoritePage() : NoFavoritePage();
        break;

      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: false,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    print("la palabra actual es ${appState.current}");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                  // Actualizamos el contador
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
              ElevatedButton(
                  onPressed: () => {
                        print('Contador reseteado'),
                        // Eliminamos el contador.
                        appState.favoritesCount = 0,
                        // Eliminamos todo el contenido del arreglo.
                        appState.eliminarTodo(),
                        print('${appState.favoritesCount}'),
                      },
                  child: Text('Reset')),
              SizedBox(width: 15),
            ],
          ),
        ],
      ),
    );
  }
}

class NoFavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Center(
          child: Text(
        'Aun no tienes favoritos',
        style: TextStyle(
            fontSize: 35, color: Colors.black54, fontWeight: FontWeight.bold),
      )),
    );
  }
}

class FavoritePage extends StatelessWidget {
  // Aqui vamos a mapear los datos del arreglo
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var count = appState.favoritesCount;
    var elementos = appState.favorites;
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Favorites count is $count ',
          style: TextStyle(fontSize: 30),
        ),

        Expanded(
            child: SizedBox(
                height: 200,
                child: ListView.builder(
                    itemCount: elementos.length,
                    itemBuilder: (context, index) {
                      return _formatoTexto(elementos[index].toString());
                    })))
        // Ejemplo de como deberian de aparecer las palabras favoritas.
      ]),
    );
  }

  Widget _formatoTexto(String texto) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.favorite, color: Colors.red, size: 30),
            SizedBox(width: 20),
            Column(
              children: [
                Text(texto,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ],
            )
          ],
        ),
      ],
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
      color: Colors.deepOrange,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
