import 'dart:io';
import 'package:flutter/material.dart';
import 'article.dart';
import 'articleCard.dart';

class CardList extends StatefulWidget {
  final List<Article> _list;
  final String name;
  final String functionName;
  final Function function;
  const CardList(this.name, this._list, this.functionName, this.function,
      {Key? key})
      : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget._list.length,
            itemBuilder: (context, index) {
              var item = widget._list[index];
              return Card(
                  child:
                      ArticleCard(item, widget.functionName, widget.function));
            }));
  }
}
