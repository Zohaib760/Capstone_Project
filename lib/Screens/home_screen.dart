import 'package:capstone/Screens/setting_screen.dart';
import 'package:flutter/material.dart';

import '../Models/item_model.dart';
import '../Services/db_helper.dart';
import '../services/api_service.dart';

import '../services/storage_service.dart';

import 'detail_screen.dart';


import 'favorite_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final StorageService _storageService = StorageService();

  List<Item> items = [];

  bool isLoading = true;
  String? _username;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }



  Future<void> _loadData() async {
    await _storageService.initialize();
    userId = _storageService.getInt('userId');
    _username = _storageService.getString('username');

    try {
      // Fetch data from API
      final posts = await _apiService.getPosts();
      final photos = await _apiService.getPhotos();

      // Combine posts and photos to create items
      List<Item> items = [];
      for (int i = 0; i < 10; i++) {
        items.add(Item(
          id: posts[i]['id'],
          title: posts[i]['title'],
          description: posts[i]['body'],
          imageUrl: photos[i]['thumbnailUrl'],
        ));
      }

      // Save items to local database
      for (var item in items) {
        await _dbHelper.insertItem(item.toMap());
      }

      // Load items from local database
      final dbItems = await _dbHelper.getItems();
      setState(() {
        items = dbItems.map((map) => Item.fromMap(map)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      // Load items from local database if API fails
      final dbItems = await _dbHelper.getItems();
      setState(() {
        items = dbItems.map((map) => Item.fromMap(map)).toList();
        isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(int itemId) async {
    if (userId == null) return;

    final isFavorite = await _dbHelper.isFavorite(userId!, itemId);
    if (isFavorite) {
      await _dbHelper.removeFavorite(userId!, itemId);
    } else {
      await _dbHelper.addFavorite(userId!, itemId);
    }

    setState(() {
      items = items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(isFavorite: !isFavorite);
        }
        return item;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'Assets/logo.png',
          height: 40, // Adjust size
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    // _username ??
                        'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   // MaterialPageRoute(builder: (context) => NotificationsScreen()),
                // );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () {
                _storageService.remove('userId');
                _storageService.remove('userEmail');
                _storageService.remove('username');
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
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
                icon: Icon(
                  item.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: item.isFavorite ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorite(item.id),
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
          );
        },
      ),
    );
  }
}