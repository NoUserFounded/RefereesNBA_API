import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'referee_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'NBA Referees API',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _items = [];

  // Fetch content from the external API
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.sportsdata.io/v3/nba/scores/json/Referees?key=f36e18d63a44411981e54cd8a9ab8e56'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _items = data;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'NBA Referees',
        ),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: const Color.fromARGB(255, 224, 240, 248),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchData,
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                  foregroundColor: Colors.white, // Text color
                  backgroundColor: Colors.blue, // Button background color
                ),
              child: const Text('Show Referees'),
            ),
            // Display the data loaded from the external API
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          key: ValueKey(_items[index]["RefereeID"]),
                          margin: const EdgeInsets.all(10),
                          color: Colors.orange.shade50, // Pastel blue background color
                          child: ListTile(
                            leading: Text(_items[index]["Number"].toString()),
                            title: Text(_items[index]["Name"]),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RefereePage(referee: _items[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}