import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:troca_papel/key/api_key.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _imageUrls = [];
  bool _isLoading = false;
  int _page = 1;
  final int _perPage = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchMoreImages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreImages();
    }
  }

  Future<void> _fetchMoreImages() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      final String url =
          'https://api.pexels.com/v1/search?query=anime cosplay&page=$_page&per_page=$_perPage';

      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': key,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> photos = data['photos'];

        List<String> imageUrls = [];
        for (var photo in photos) {
          final String imageUrl = photo['src']['portrait'];
          imageUrls.add(imageUrl);
        }

        setState(() {
          _imageUrls.addAll(imageUrls);
          _isLoading = false;
          _page++;
        });
      } else {
        throw Exception('Failed to fetch images');
      }
    }
  }

  Widget _buildImageItem(int index) {
    if (index >= _imageUrls.length) {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return const SizedBox.shrink();
      }
    }

    return Image.network(_imageUrls[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: const Color(0xFF0D6847),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification &&
              _scrollController.position.extentAfter == 0) {
            _fetchMoreImages();
          }
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 180,
              crossAxisSpacing: 0,
              mainAxisSpacing: 7,
            ),
            itemCount: _imageUrls.length + 1,
            itemBuilder: (context, index) {
              return _buildImageItem(index);
            },
          ),
        ),
      ),
    );
  }
}
