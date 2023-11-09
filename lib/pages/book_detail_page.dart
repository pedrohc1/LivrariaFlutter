import 'package:flutter/material.dart';
import 'home.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Livro'),
        backgroundColor: Colors.black,
        centerTitle: true,

      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            height: 200, // Defina a altura máxima desejada para a imagem
            child: book.imageUrl != null && book.imageUrl.isNotEmpty
                ? Image.network(
              book.imageUrl,
              fit: BoxFit.cover, // Evita a esticagem da imagem
            )
                : Icon(Icons.image_not_supported, size: 100),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      book.title,
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  if (book.author != null)
                    Text.rich(
                      TextSpan(
                        text: 'Autor:',
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ${book.author}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  if (book.publishedDate != null)
                    Text.rich(
                      TextSpan(
                        text: 'Data de Lançamento:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ${book.publishedDate}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  if (book.description != null)
                    Text(book.description!, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
