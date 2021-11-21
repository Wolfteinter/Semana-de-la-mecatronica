import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'article.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  const ArticleCard(this.article, {Key? key}) : super(key: key);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
    var authors = "";
    widget.article.author.forEach((element) {
      authors += element + "\n";
    });
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Text(widget.article.title),
              subtitle: Text(authors)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(onPressed: () => {}, child: Text('Ver')),
              TextButton(onPressed: () => {}, child: Text('Añadir'))
            ],
          )
        ],
      ),
    );
  }
}
