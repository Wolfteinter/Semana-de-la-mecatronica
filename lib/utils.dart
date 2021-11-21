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
}
