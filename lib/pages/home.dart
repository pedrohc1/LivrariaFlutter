import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'book_detail_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: BookSearch(),
    );
  }

  Text appBar() {
    return const Text(
      'Livraria',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class BookSearch extends StatefulWidget {
  @override
  _BookSearchState createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  TextEditingController _searchController = TextEditingController();
  List<Book> _books = [];

  Future<void> searchBooks(String query) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;

      setState(() {
        _books = items.map((item) {
          final title = item['volumeInfo']['title'];
          final imageLinks = item['volumeInfo']['imageLinks'];
          final author = item['volumeInfo']['authors']?.join(', ');
          final publishedDate = item['volumeInfo']['publishedDate'];
          final description = item['volumeInfo']['description'];
          var imageUrl = imageLinks?['thumbnail'];

          if (imageUrl == null || imageUrl.isEmpty) {
            imageUrl = 'assets/icons/x.svg';
          }

          return Book(
            title: title,
            imageUrl: imageUrl,
            author: author,
            publishedDate: publishedDate,
            description: description,
          );
        }).toList();
      });
    } else {
      print('Erro na requisição: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _searchField,
    );
  }

  List<Widget> get _searchField {
    return <Widget>[
      search(),
      Expanded(
        child: ListView.builder(
          itemCount: _books.length,
          itemBuilder: (context, index) {
            final book = _books[index];

            Image bookImage;

            if (book.imageUrl != null && book.imageUrl.isNotEmpty) {
              bookImage = Image.network(book.imageUrl);
            } else {
              bookImage = Image.asset('assets/icons/x.svg');
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailPage(book: book),
                  ),
                );
              },
              child: ListTile(
                leading: bookImage,
                title: Text(book.title),
              ),
            );
          },
        ),
      ),
    ];
  }

  Container search() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xff1D1617).withOpacity(0.11),
          blurRadius: 40,
          spreadRadius: 0.0,
        ),
      ]),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                searchBooks(_searchController.text);
              },
              child: SvgPicture.asset('assets/icons/Search.svg'),
            ),
          ),
          labelText: 'Pesquisar livros',
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class Book {
  final String title;
  final String imageUrl;
  final String? author;
  final String? publishedDate;
  final String? description;

  Book({
    required this.title,
    required this.imageUrl,
    this.author,
    this.publishedDate,
    this.description,
  });
}
