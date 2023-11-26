import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Item {
  final String id;
  final String name;
  String quantity;

  Item({required this.id, required this.name, required this.quantity});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
    );
  }
}

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        return jsonResponse.map((item) => Item.fromJson(item)).toList();
      } else if (jsonResponse is Map<String, dynamic>) {
        return [Item.fromJson(jsonResponse)];
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> updateItemQuantity(int itemId, int newQuantity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$itemId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': itemId, 'quantity': newQuantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update item quantity');
    }
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService apiService =
      ApiService(baseUrl: 'http://192.168.0.127/api/transaksi.php');
  List<Item> items = [];
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final loadedItems = await apiService.getItems();
      setState(() {
        items = loadedItems;
      });
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  Future<void> _refresh() async {
    await _loadItems();
  }

  _showQuantityDialog(Item item) {
    int newQuantity = int.tryParse(item.quantity) ?? 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Edit Quantity',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Item: ${item.name}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              newQuantity--;
                            });
                          },
                          child: Icon(Icons.remove),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red[600],
                          ),
                        ),
                        Text(
                          newQuantity.toString(),
                          style: TextStyle(fontSize: 18.0),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              newQuantity++;
                            });
                          },
                          child: Icon(Icons.add),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[400],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        await apiService.updateItemQuantity(
                            int.parse(item.id), newQuantity);
                        await _refresh(); // Refresh after updating quantity
                        Navigator.of(context).pop();
                      },
                      child: Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventory System',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 1,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Daftar Barang Inventaris',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<List<Item>>(
                    future: apiService.getItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        items = snapshot.data!;
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              color: Colors.indigoAccent[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  items[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  'Quantity: ${items[index].quantity}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  _showQuantityDialog(items[index]);
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.qr_code_scanner_rounded, size: 50),
          Icon(Icons.account_circle_outlined, size: 30),
        ],
        color: Color.fromARGB(255, 167, 201, 252),
        buttonBackgroundColor: Colors.blue[50],
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
            if (index == 0) {
              // Navigate to dashboard
              Get.toNamed('/dashboard');
            } else if (index == 1) {
              // Navigate to transaksi
              Get.toNamed('/transaksi');
            } else if (index == 2) {
              // Navigate to profil
              Get.toNamed('/profil');
            }
          });
        },
      ),
    );
  }
}
