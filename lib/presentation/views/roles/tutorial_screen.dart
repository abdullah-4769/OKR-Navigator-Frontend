// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:get/get.dart';
//
// class TutorialVideoScreen extends StatefulWidget {
//   const TutorialVideoScreen({super.key});
//
//   @override
//   State<TutorialVideoScreen> createState() => _TutorialVideoScreenState();
// }
//
// class _TutorialVideoScreenState extends State<TutorialVideoScreen> {
//   late YoutubePlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = YoutubePlayerController(
//       initialVideoId: 'f4WnbX1okts',
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//         enableCaption: true,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('Tutorial'),
//         // backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Center(
//         child: YoutubePlayer(
//           controller: _controller,
//           showVideoProgressIndicator: true,
//           progressIndicatorColor: Colors.red,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widgets/screens_unique_parts/custom_header.dart';

class TutorialVideoScreen extends StatefulWidget {
  const TutorialVideoScreen({super.key});

  @override
  State<TutorialVideoScreen> createState() => _TutorialVideoScreenState();
}

class _TutorialVideoScreenState extends State<TutorialVideoScreen> {
  late final WebViewController _webController;

  @override
  void initState() {
    super.initState();

    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          'https://vimeo.com/1151172999?share=copy&fl=sv&fe=ci',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'tutorial'.tr,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: WebViewWidget(
                controller: _webController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


