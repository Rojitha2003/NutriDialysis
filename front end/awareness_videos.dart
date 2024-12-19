import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../api.dart';

class AwarenessVideosPage extends StatefulWidget {
  const AwarenessVideosPage({Key? key}) : super(key: key);

  @override
  State<AwarenessVideosPage> createState() => _AwarenessVideosPageState();
}

class _AwarenessVideosPageState extends State<AwarenessVideosPage> {
  List<Map<String, dynamic>> awarenessVideos = [];

  @override
  void initState() {
    super.initState();
    fetchVideos(); // Fetch videos when the page initializes
  }

  // Fetch videos from the server
  Future<void> fetchVideos() async {
    try {
      final response = await http.get(
        Uri.parse(FetchVideourl), // Ensure FetchVideourl is defined in api.dart
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            awarenessVideos = List<Map<String, dynamic>>.from(data['videos']);
          });
        } else {
          _showErrorDialog(data['message'] ?? "Failed to fetch videos.");
        }
      } else {
        _showErrorDialog("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    }
  }

  // Show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set background color to blue
        automaticallyImplyLeading: true,
        elevation: 0, // Remove elevation
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.pink[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Awareness Videos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: awarenessVideos.isEmpty
                  ? const Center(child: Text("No awareness videos available."))
                  : ListView.builder(
                      itemCount: awarenessVideos.length,
                      itemBuilder: (context, index) {
                        final video = awarenessVideos[index];
                        final videoId = YoutubePlayer.convertUrlToId(
                            video['youtube_url'] ?? '')!;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  video['title'] ?? 'No title',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (videoId.isNotEmpty)
                                YoutubePlayer(
                                  controller: YoutubePlayerController(
                                    initialVideoId: videoId,
                                    flags: const YoutubePlayerFlags(
                                      autoPlay: false,
                                      mute: false,
                                    ),
                                  ),
                                  showVideoProgressIndicator: true,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
