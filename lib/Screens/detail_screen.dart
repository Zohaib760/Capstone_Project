import 'package:flutter/material.dart';
import '../Models/item_model.dart';
import '../Services/db_helper.dart';
import '../services/api_service.dart';

import '../services/storage_service.dart';


class DetailScreen extends StatefulWidget {
  final int itemId;

  const DetailScreen({super.key, required this.itemId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final StorageService _storageService = StorageService();

  Item? _item;
  bool _isLoading = true;
  bool _isFavorite = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadItemDetails();
  }

  Future<void> _loadItemDetails() async {
    await _storageService.initialize();
    _userId = _storageService.getInt('userId');

    try {
      // Try to get item from API first
      final post = await _apiService.getPostDetail(widget.itemId);
      final photo = await _apiService.getPhotoDetail(widget.itemId);

      setState(() {
        _item = Item(
          id: post['id'],
          title: post['title'],
          description: post['body'],
          imageUrl: photo['url'],
        );
        _isLoading = false;
      });

      // Save to local database
      await _dbHelper.insertItem(_item!.toMap());
    } catch (e) {
      // If API fails, get from local database
      final itemMap = await _dbHelper.getItemById(widget.itemId);
      if (itemMap != null) {
        setState(() {
          _item = Item.fromMap(itemMap);
          _isLoading = false;
        });
      }
    }

    // Check if item is favorite
    if (_userId != null) {
      final isFavorite = await _dbHelper.isFavorite(_userId!, widget.itemId);
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_userId == null) return;

    if (_isFavorite) {
      await _dbHelper.removeFavorite(_userId!, widget.itemId);
    } else {
      await _dbHelper.addFavorite(_userId!, widget.itemId);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _item == null
          ? const Center(child: Text('Item not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_item!.imageUrl != null)
              Image.network(
                _item!.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              _item!.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _item!.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Item ID: ${_item!.id}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}