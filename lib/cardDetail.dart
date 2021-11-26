import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:semana_de_la_mecatronica/article.dart';
import 'dart:developer';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CardDetail extends StatefulWidget {
  final Article article;

  const CardDetail(this.article, {Key? key}) : super(key: key);

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  @override
  Widget build(BuildContext context) {
    final PdfViewerController _pdfViewerController = PdfViewerController();
    log(widget.article.href);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.white,
            ),
            onPressed: () {
              print(_pdfViewerController.scrollOffset.dy);
              print(_pdfViewerController.scrollOffset.dx);
            },
          ),
        ],
      ),
      body: Container(
          child: SfPdfViewer.network(
        widget.article.href,
        pageLayoutMode: PdfPageLayoutMode.single,
        controller: _pdfViewerController,
      )),
    );
  }
}
