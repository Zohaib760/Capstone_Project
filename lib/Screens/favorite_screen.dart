import 'package:flutter/material.dart';
import '../Models/item_model.dart';
import '../Services/db_helper.dart';

import '../services/storage_service.dart';

import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final StorageService _storageService = StorageService();

  List<Item> _favorites = [];
  bool _isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await _storageService.initialize();
    _userId = _storageService.getInt('userId');

    if (_userId != null) {
      final favorites = await _dbHelper.getFavorites(_userId!);
      setState(() {
        _favorites = favorites.map((map) => Item.fromMap(map)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(int itemId) async {
    if (_userId == null) return;

    await _dbHelper.removeFavorite(_userId!, itemId);
    setState(() {
      _favorites.removeWhere((item) => item.id == itemId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed from favorites')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Add items to your favorites to see them here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final item = _favorites[index];
          return Dismissible(
            key: Key(item.id.toString()),
            background: Container(color: Colors.red),
            onDismissed: (direction) => _removeFavorite(item.id),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: item.imageUrl != null
                    ? Image.network(item.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                    : Icon(Icons.image, size: 50),
                title: Text(
                  item.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeFavorite(item.id),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(itemId: item.id),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}