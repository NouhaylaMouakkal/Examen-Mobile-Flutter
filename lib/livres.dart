import 'package:flutter/material.dart';
import 'models/book.dart';

class LivresPage extends StatefulWidget {
  const LivresPage({super.key});

  @override
  _LivresPageState createState() => _LivresPageState();
}

class _LivresPageState extends State<LivresPage> {
  List<Book> books = [
    Book(
      title: "Poor dad rich dad",
      author: " Robert Kiyosaki",
      description: " Rich Dad Poor Dad is a 1997 book written by Robert Kiyosaki and Sharon Lechter. It advocates the importance of financial literacy, financial independence and building wealth through investing in assets, real estate investing, starting and owning businesses, as well as increasing one's financial intelligence to improve one's business and financial aptitude. Rich Dad Poor Dad is written in the style of a set of parables, ostensibly based on Kiyosaki's life.",
      imageUrl: "https://miro.medium.com/v2/resize:fit:650/1*haaHd7BspoRrLIwFGCbgMQ.jpeg",
    ),
    Book(
      title: "Au-delà du bien et du mal",
      author: "Friedrich Nietzsche",
      description: " Au-delà du bien et du mal est un ouvrage de philosophie de Friedrich Nietzsche, publié en 1886. Il s'agit de la première œuvre du philosophe allemand à être publiée après Ainsi parlait Zarathoustra. L'ouvrage est divisé en neuf parties, chacune d'entre elles étant composée de courtes sections numérotées. Nietzsche y développe sa philosophie de la volonté de puissance, de la morale, de la religion, de la culture, de la politique et de l'art. Il y critique notamment la philosophie de Platon, de Kant et de Schopenhauer, ainsi que les religions chrétienne et bouddhiste.",
      imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1658403205i/61639209.jpg",
    ),
    Book(
      title: "Le Meilleur des mondes",
      author: "Aldous Huxley",
      description: " Le Meilleur des mondes (Brave New World) est un roman d'anticipation dystopique écrit en 1931 par Aldous Huxley. Il paraît en 1932. Le Meilleur des mondes décrit une société future, technologiquement avancée, dans laquelle les êtres humains sont conditionnés et manipulés dès leur naissance pour se conformer à des normes sociales bien précises. Le roman est souvent comparé à 1984 de George Orwell, un autre grand classique de la littérature dystopique.",
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnUro5VHs0Od3K3pVpliSkcZF4-q0Jmmt-k6sC1yppjA&s",
    ),
    Book(
      title: " Le Monde comme volonté et comme représentation",
      author: "Shopenhauer",
      description: "  Le Monde comme volonté et comme représentation est un ouvrage de philosophie écrit par Arthur Schopenhauer et publié pour la première fois en 1818. Il s'agit de l'œuvre majeure du philosophe allemand. Schopenhauer y développe sa philosophie, qui s'inscrit dans la tradition de l'idéalisme allemand, tout en s'en distinguant par son rejet de l'idéalisme transcendantal de Kant. Le Monde comme volonté et comme représentation est divisé en quatre livres, chacun d'entre eux étant composé de chapitres numérotés. Schopenhauer y expose sa conception du monde comme volonté, qu'il oppose à la représentation, et développe sa théorie de l'art, de la morale et de la métaphysique.",
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNOo--2ZwCNhY5B2D38ieZ7OYs634qphYNLkPTBtmKPg&s",
    ),
  ];
  List<Book> filteredBooks = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredBooks = books;
  }

  void _addBook(Book book) {
    setState(() {
      books.add(book);
      _filterBooks(searchQuery);
    });
  }

  void _deleteBook(int index) {
    setState(() {
      books.removeAt(index);
      _filterBooks(searchQuery);
    });
  }

  void _filterBooks(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredBooks = books;
      } else {
        filteredBooks = books
            .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livres'),
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: BookSearchDelegate(books, _filterBooks));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBookPage(onAdd: _addBook)),
                );
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredBooks.length,
        itemBuilder: (context, index) {
          final book = filteredBooks[index];
          return ListTile(
            leading: Image.network(book.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteBook(index),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookDetailPage(book: book)),
              );
            },
          );
        },
      ),
    );
  }
}

class AddBookPage extends StatelessWidget {
  final Function(Book) onAdd;

  AddBookPage({required this.onAdd, Key? key}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Livre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Auteur'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL de l\'image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final book = Book(
                  title: _titleController.text,
                  author: _authorController.text,
                  description: _descriptionController.text,
                  imageUrl: _imageUrlController.text,
                );
                onAdd(book);
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({required this.book, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(book.imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              book.author,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(book.description),
          ],
        ),
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  final List<Book> books;
  final Function(String) onQueryChanged;

  BookSearchDelegate(this.books, this.onQueryChanged);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onQueryChanged(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onQueryChanged(query);
    final results = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          leading: Image.network(book.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookDetailPage(book: book)),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books
        .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final book = suggestions[index];
        return ListTile(
          leading: Image.network(book.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            query = book.title;
            showResults(context);
          },
        );
      },
    );
  }
}
