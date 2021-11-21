import 'package:flutter/material.dart';
import 'package:semana_de_la_mecatronica/article.dart';
import 'package:semana_de_la_mecatronica/articleCard.dart';
import 'utils.dart';
import 'articleCard.dart';

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

  @override
  void initState() {
    Utils.getArticlesBySearch("machine lerning").then((List<Article> value) {
      setState(() {
        _articles = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _articles.length,
          itemBuilder: (context, index) {
            var item = _articles[index];
            return Card(child: ArticleCard(item));
          }),
    );
  }
}
