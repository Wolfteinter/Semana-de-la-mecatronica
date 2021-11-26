import 'package:flutter/material.dart';
import 'package:semana_de_la_mecatronica/article.dart';
import 'package:semana_de_la_mecatronica/articleCard.dart';
import 'utils.dart';
import 'articleCard.dart';
import 'dart:developer';
import 'cardList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Articles from API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Articles from API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> _articles = [];
  List<Article> _articlesSaved = [];
  List<Article> _readAricles = [];
  int _selectedIndex = 0;
  final controller = TextEditingController();

  @override
  void initState() {
    Utils.getArticlesBySearch("machine lerning").then((List<Article> value) {
      setState(() {
        _articles = value;
      });
    });
    Utils.getListOfWords().then((Map value) {
      _articlesSaved = value["saved_articles"];
      _readAricles = value["read_articles"];
    });
  }

  void _addToSaved(Article item) {
    setState(() {
      Iterable<Article> element = _articlesSaved.where((element) {
        return element.title == item.title;
      });
      if (element.isEmpty) {
        _articlesSaved.add(item);
      }
      Utils.updateFileFromList(_articlesSaved, _readAricles);
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Done'),
            content: Text('Se añadio a por leer'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _addToRead(Article item) {
    setState(() {
      Iterable<Article> element = _readAricles.where((element) {
        return element.title == item.title;
      });
      if (element.isEmpty) {
        _readAricles.add(item);
        _articlesSaved.remove(item);
      }
      Utils.updateFileFromList(_articlesSaved, _readAricles);
      Navigator.pop(context);
    });
  }

  void _removeToRead(Article item) {
    setState(() {
      _readAricles.remove(item);

      Utils.updateFileFromList(_articlesSaved, _readAricles);
      Navigator.pop(context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CardList("Articulos por leer",
                    _articlesSaved, "Añadir a leidos", _addToRead)));
        /*showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ArticlesSaved(_articlesSaved));*/
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CardList("Articulos leidos", _readAricles,
                    "Eliminar de leidos", _removeToRead)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          Container(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Utils.getArticlesBySearch(controller.text)
                        .then((List<Article> value) {
                      setState(() {
                        _articles = value;
                      });
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  child: Text(
                    "Buscar",
                    style: TextStyle(color: Colors.white),
                  ))),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  var item = _articles[index];
                  return Card(
                      child: ArticleCard(item, "Añadir por leer", _addToSaved));
                }),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'Articulos por leer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Articulos leidos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
