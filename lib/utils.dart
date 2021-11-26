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

  static void updateFileFromList(List<Article> list) async {
    File file = await _localFile;
    var body = {};
    body["articles"] = [];
    list.forEach((element) {
      var authors = [];
      element.author.forEach((a) {
        authors.add(a);
      });
      body["articles"].add({
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

  static Future<List<Article>> getListOfWords() async {
    File file = await _localFile;
    if (file.existsSync() == false) {
      //If aren't exist the file, create a new one and append a default word
      new File(file.path).create(recursive: true);
      var body = {};
      body["articles"] = [];
      //it is necessary to add try catches
      String encoded = json.encode(body);
      file.writeAsString(encoded);
      return [];
    }
    String rawData = await file.readAsString();
    var data = json.decode(rawData);
    List articles = data["articles"];
    if (articles.isEmpty) return [];
    log(articles[0]["title"]);
    List<Article> result = [];
    articles.forEach((element) {
      List author = element["author"];
      result.add(Article(
          element["title"],
          element["summary"],
          element["published"],
          author.map((e) => e.toString()).toList(),
          element["href"]));
    });
    inspect(result);
    return result;
  }
}
