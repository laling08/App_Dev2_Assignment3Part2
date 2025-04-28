import 'dart:async';
import 'package:flutter/material.dart';
import '../models/book.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  Timer? _debounce;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _initializeBooks();
    _searchController.addListener(_filterBooks);
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _searchFocusNode.hasFocus && _searchController.text.isNotEmpty;
    });
  }

  void _initializeBooks() {
    _allBooks = [
      Book(
          id: '1',
          title: 'Flutter Development',
          author: 'Sakku',
          price: 29.99,
          imageUrl: 'https://via.placeholder.com/150'),
      Book(
          id: '2',
          title: 'Dart Programming',
          author: 'Sakku',
          price: 24.99,
          imageUrl: 'https://via.placeholder.com/150'),
      Book(
          id: '3',
          title: 'Mobile App Design',
          author: 'Sakku',
          price: 34.99,
          imageUrl: 'https://via.placeholder.com/150'),
      Book(
          id: '4',
          title: 'Firebase Essentials',
          author: 'Sakku',
          price: 19.99,
          imageUrl: 'https://via.placeholder.com/150'),
    ];
    _filteredBooks = List.from(_allBooks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _filterBooks() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 150), () {
      final query = _searchController.text.trim().toLowerCase();

      setState(() {
        _showSuggestions = query.isNotEmpty && _searchFocusNode.hasFocus;

        _filteredBooks = _allBooks.where((book) {
          if (query.isEmpty) return true;

          final title = book.title.toLowerCase();
          final author = book.author.toLowerCase();

          return title.contains(query) ||
              author.contains(query) ||
              title.split(' ').any((word) => word.startsWith(query)) ||
              author.split(' ').any((word) => word.startsWith(query));
        }).toList();

        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  List<TextSpan> _buildHighlightedText(String text, String query) {
    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();
    int start = 0;

    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.yellow,
            color: Colors.black,
          ),
        ),
      );
      start = index + query.length;
    }

    return spans;
  }

  Widget _buildBookCard(Book book, bool isMobile) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: isMobile ? 16 : 24,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            book.imageUrl,
            width: 60,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.book, size: 40),
              );
            },
          ),
        ),
        title: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: _buildHighlightedText(
              book.title,
              _searchController.text,
            ),
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            children: _buildHighlightedText(
              book.author,
              _searchController.text,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${book.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                labelText: 'Search Books',
                hintText: 'Start typing...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          if (_showSuggestions) ...[
            _buildSuggestionsList(),
            const Divider(height: 1, indent: 20, endIndent: 20),
          ],
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                return _filteredBooks.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No books found for "${_searchController.text}"',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: isMobile ? 8 : 16,
                  ),
                  itemCount: _filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = _filteredBooks[index];
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 20),
                            child: child,
                          ),
                        );
                      },
                      child: _buildBookCard(book, isMobile),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    final suggestions = _filteredBooks.take(5).toList();

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final book = suggestions[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _searchController.text = book.title;
                _searchFocusNode.unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      ..._buildHighlightedText(book.title, _searchController.text),
                      TextSpan(
                        text: ' • ${book.author}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}