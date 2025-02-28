import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_load_json/utils/fetchFirstImage.dart';

class RefereePage extends StatefulWidget {
  final Map<String, dynamic> referee;

  const RefereePage({super.key, required this.referee});

  @override
  _RefereePageState createState() => _RefereePageState();
}

class _RefereePageState extends State<RefereePage> {
  String? imageUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchImage(widget.referee["Name"]);
  }

  void fetchImage(String query) async {
    setState(() => isLoading = true);
    try {
      String? url = await fetchFirstImage(query);
      setState(() {
        imageUrl = url;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        imageUrl = null;
        isLoading = false;
      });
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.referee["Name"];
    String formattedName = name.toLowerCase().replaceAll(' ', '-');
    String bioUrl = 'https://www.nbra.net/nba-officials/referee-biographies/$formattedName/';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.referee["Name"]),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white), // Change back button color to white
      ),
      backgroundColor: const Color.fromARGB(255, 224, 240, 248),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Referee Info:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth * 0.6, // 60% of screen width
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                            Container(
                            color: Colors.orange.shade100,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            height: 166, // Set the height to match the image container
                            child: const Text('Image:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          ),
                          Container(
                            color: Colors.orange.shade50,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: imageUrl != null
                                ? Image.network(imageUrl!, width: 200, height: 150, fit: BoxFit.contain)
                                : const Text('No image available', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            color: Colors.orange.shade100,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Text('Name:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          ),
                          Container(
                            color: Colors.orange.shade50,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(widget.referee["Name"], style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            color: Colors.orange.shade100,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Text('Number:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          ),
                          Container(
                            color: Colors.orange.shade50,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(widget.referee["Number"].toString(), style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            color: Colors.orange.shade100,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Text('College:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          ),
                          Container(
                            color: Colors.orange.shade50,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(widget.referee["College"], style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            color: Colors.orange.shade100,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Text('Experience:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          ),
                          Container(
                            color: Colors.orange.shade50,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('${widget.referee["Experience"]} years', style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _launchURL(bioUrl),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                  foregroundColor: Colors.black, // Text color
                  backgroundColor: Colors.orange.shade100, // Button background color
                ),
                child: const Text('Show more info'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
