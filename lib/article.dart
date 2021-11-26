import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class Article {
  String published;
  String title;
  String summary;
  List<String> author;
  String href;

  Article(this.published, this.title, this.summary, this.author, this.href);
  /*
    Funcion que construye objetos de tipo Article de XML
  */
  factory Article.fromElement(XmlElement xmlElement) {
    List<String> authors = [];
    xmlElement.findAllElements("author").forEach((XmlElement element) {
      var author = element.getElement("name");
      if (author != null) {
        authors.add(author.children.first.toString());
      }
    });
    var published = xmlElement.getElement('published');
    var title = xmlElement.getElement('title');
    var summary = xmlElement.getElement('summary');
    var href = xmlElement.findAllElements('link').toList()[1];
    return Article(
        published != null ? published.children.first.toString() : "",
        title != null ? title.children.first.toString() : "",
        summary != null ? summary.children.first.toString() : "",
        authors,
        href != null ? href.getAttribute("href").toString() + ".pdf" : "");
  }
}
