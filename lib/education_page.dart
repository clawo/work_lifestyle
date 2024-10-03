import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'theme.dart'; // Importiert die theme.dart Datei

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Videos'),
        backgroundColor: AppColors.appBarColor, // Verwendet die AppBar-Farbe aus AppColors
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Protracted shoulders?',
                  style: AppTextStyles.heading, // Verwendet den Stil aus AppTextStyles
                ),
                SizedBox(
                  height: 200,
                  child: YoutubePlayerWidget(
                    videoUrl: 'https://www.youtube.com/watch?v=nlP15RGUp9Q',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'How to sit straight?',
                  style: AppTextStyles.heading, // Verwendet den Stil aus AppTextStyles
                ),
                SizedBox(
                  height: 200,
                  child: YoutubePlayerWidget(
                    videoUrl: 'https://www.youtube.com/watch?v=pzZPaY6F41Y',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Why sitting is bad for you?',
                  style: AppTextStyles.heading, // Verwendet den Stil aus AppTextStyles
                ),
                SizedBox(
                  height: 200,
                  child: YoutubePlayerWidget(
                    videoUrl: 'https://www.youtube.com/watch?v=f-w4FDIeHSo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YoutubePlayerWidget extends StatelessWidget {
  final String videoUrl;

  const YoutubePlayerWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId == null) {
      return const Center(child: Text('Invalid Video URL'));
    }
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      ),
      showVideoProgressIndicator: true,
    );
  }
}
