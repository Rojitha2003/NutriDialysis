import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../api.dart';
import 'provider_doctor/delete_videoapi.dart'; // Ensure your FetchVideourl and UploadVideourl are defined here

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({Key? key}) : super(key: key);

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  List<Map<String, dynamic>> uploadedVideos = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVideos(); // Fetch videos when the page initializes
  }

  // Fetch videos from the server
  Future<void> fetchVideos() async {
    try {
      final response = await http.get(
        Uri.parse(FetchVideourl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            uploadedVideos = List<Map<String, dynamic>>.from(data['videos']);
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

  // Upload a new video to the server
  Future<void> uploadNewVideo() async {
    final videoTitle = titleController.text.trim();
    final videoUrl = urlController.text.trim();

    if (videoTitle.isEmpty || videoUrl.isEmpty) {
      _showErrorDialog("Video title and URL cannot be empty.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(UploadVideourl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"video_title": videoTitle, "video_url": videoUrl},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          titleController.clear();
          urlController.clear();
          fetchVideos(); // Refresh video list
        } else {
          _showErrorDialog(data['message'] ?? "Failed to upload the video.");
        }
      } else {
        _showErrorDialog("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    }
  }

  // Delete a video from the server
  Future<void> deleteVideoById(String videoId) async {
    final result = await deleteVideo(videoId: videoId, context: context);
    if (result['success'] == true) {
      fetchVideos(); // Refresh video list after deletion
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
                  'Upload Videos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Video Title',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      color: Colors.black, // Ensures entered text is black
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter YouTube URL',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      color: Colors.black, // Ensures entered text is black
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: uploadNewVideo,
                  icon: const Icon(Icons.cloud_upload, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: uploadedVideos.isEmpty
                  ? const Center(child: Text("No videos uploaded yet."))
                  : ListView.builder(
                      itemCount: uploadedVideos.length,
                      itemBuilder: (context, index) {
                        final video = uploadedVideos[index];
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
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    deleteVideoById(video[
                                        'video_id']); // Pass video ID to delete
                                  },
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
