import 'dart:developer';
/*
  Para poder usar el paquete de xml el comando de instalacion es el siguiente:
  flutter pub add http
*/
import 'package:http/http.dart' as http;
/*
  Para poder usar el paquete de xml el comando de instalacion es el siguiente:
  flutter pub add xml
*/
import 'package:xml/xml.dart';
import 'article.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class Utils {
  /*
    La url del endpoint que usaremos
  */
  static String ENDPOINT = "http://export.arxiv.org/api/query?search_query=";
  /*
    Funcion que construye el request al API y construye objetos 
    de tipo Article para posteriormente retornarlos 
  */
  static Future<List<Article>> getArticlesBySearch(String search) async {
    var response = await http.get(Uri.parse(ENDPOINT + search));
    //Si la API nos devuelve un estatus 200, lo cual significa que se realizo con exito
    if (response.statusCode == 200) {
      var root = XmlDocument.parse(response.body);
      /*
        Obtenemos todos los elementos de tipo entry ya que son los que contienen la
        informacion del articulo, y mapeamos cada elemento para crear un objeto de tipo Article
      */
      var articles = root
          .findAllElements('entry')
          .map<Article>((e) => Article.fromElement(e))
          .toList();
      ;
      return articles;
    } else {
      return [];
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path + "/data.json'";
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File(path);
  }

  static void updateFileFromList(
      List<Article> savedArticles, readArticles) async {
    File file = await _localFile;
    var body = {};
    body["saved_articles"] = [];
    body["read_articles"] = [];
    savedArticles.forEach((element) {
      var authors = [];
      element.author.forEach((a) {
        authors.add(a);
      });
      body["saved_articles"].add({
        "title": element.title,
        "summary": element.summary,
        "published": element.published,
        "author": authors,
        "href": element.href
      });
    });
    readArticles.forEach((element) {
      var authors = [];
      element.author.forEach((a) {
        authors.add(a);
      });
      body["read_articles"].add({
        "title": element.title,
        "summary": element.summary,
        "published": element.published,
        "author": authors,
        "href": element.href
      });
    });
    String encode = json.encode(body);
    file.writeAsString(encode);
  }

  static Future<Map> getListOfWords() async {
    File file = await _localFile;
    if (file.existsSync() == false) {
      //If aren't exist the file, create a new one and append a default word
      new File(file.path).create(recursive: true);
      var body = {};
      body["saved_articles"] = [];
      body["read_articles"] = [];
      //it is necessary to add try catches
      String encoded = json.encode(body);
      file.writeAsString(encoded);
      return {"saved_articles": [], "read_articles": []};
    }
    String rawData = await file.readAsString();
    var data = json.decode(rawData);
    List savedArticles = data["saved_articles"];
    List readArticles = data["read_articles"];
    inspect(savedArticles);
    List<Article> savedArticlesResult = [];
    List<Article> readArticlesResult = [];
    if (savedArticles.isNotEmpty) {
      savedArticles.forEach((element) {
        List author = element["author"];
        savedArticlesResult.add(Article(
            element["published"],
            element["title"],
            element["summary"],
            author.map((e) => e.toString()).toList(),
            element["href"]));
      });
    }
    if (readArticles.isNotEmpty) {
      readArticles.forEach((element) {
        List author = element["author"];
        readArticlesResult.add(Article(
            element["published"],
            element["title"],
            element["summary"],
            author.map((e) => e.toString()).toList(),
            element["href"]));
      });
    }
    return {
      "saved_articles": savedArticlesResult,
      "read_articles": readArticlesResult
    };
  }
}
