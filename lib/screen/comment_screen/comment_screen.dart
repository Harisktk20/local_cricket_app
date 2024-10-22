// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../const/app_colors.dart';
// import '../../widget/custom_text.dart';
//
// class CommentsScreen extends StatefulWidget {
//   final String videoId;
//   const CommentsScreen({required this.videoId, super.key});
//
//   @override
//   State<CommentsScreen> createState() => _CommentsScreenState();
// }
//
// class _CommentsScreenState extends State<CommentsScreen> {
//   final TextEditingController _commentController = TextEditingController();
//
//   Future<void> _addComment() async {
//     if (_commentController.text.isNotEmpty) {
//       String userId = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//       String userName = userDoc['name'];
//       String userProfileImage = userDoc['image'];
//
//       await FirebaseFirestore.instance.collection('videos').doc(widget.videoId).collection('comments').add({
//         'userId': userId,
//         'userName': userName,
//         'userProfileImage': userProfileImage,
//         'comment': _commentController.text,
//         'createdAt': Timestamp.now(),
//       });
//
//       _commentController.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Comments',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance.collection('videos').doc(widget.videoId).collection('comments').orderBy('createdAt', descending: true).snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 return ListView(
//                   children: snapshot.data!.docs.map((doc) {
//                     final commentData = doc.data() as Map<String, dynamic>;
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(commentData['userProfileImage']),
//                       ),
//                       title: Text(commentData['userName']),
//                       subtitle: Text(commentData['comment']),
//                       trailing: Text(
//                         (commentData['createdAt'] as Timestamp).toDate().toString(),
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: const InputDecoration(
//                       hintText: 'Add a comment...',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _addComment,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../const/app_colors.dart';
import '../../widget/custom_text.dart';

class CommentsScreen extends StatelessWidget {
  final String videoId;

  const CommentsScreen({required this.videoId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
        backgroundColor: AppColors.kPrimaryColor,
        centerTitle: true,
        title: const CustomText(
          text: 'Comments',
          fontSize: 16,
          color: AppColors.kWhiteColor,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .doc(videoId)
            .collection('comments')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot commentDoc = snapshot.data!.docs[index];
              Map<String, dynamic> commentData = commentDoc.data() as Map<String, dynamic>;
              return Card(
                color: AppColors.kTextFieldColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundImage: NetworkImage(commentData['userProfileImage']),
                          ),
                        SizedBox(width: 10,),
                        Text(commentData['userName']),
                      ],
                    ),
                      SizedBox(height: 8),
                      Text('Comments',style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(commentData['comment']),
                    ],
                  ),
                ),
              );
              // return ListTile(
              //   leading: CircleAvatar(
              //     backgroundImage: NetworkImage(commentData['userProfileImage']),
              //   ),
              //   title: Text(commentData['userName']),
              //   subtitle: Text(commentData['comment']),
              //   trailing: Text(commentData['createdAt'].toDate().toString()), // Display the comment timestamp
              // );
            },
          );
        },
      ),
    );
  }
}

// Integration into VideoCard
class VideoCard extends StatefulWidget {
  final Map<String, dynamic> videoData;

  const VideoCard({required this.videoData, super.key});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  bool isLiked = false;
  final TextEditingController _commentController = TextEditingController();
  String? _thumbnailPath;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _generateThumbnail();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.network(widget.videoData['videoUrl']);
    await _controller.initialize();
    setState(() {});
  }

  Future<void> _generateThumbnail() async {
    final String? path = await VideoThumbnail.thumbnailFile(
      video: widget.videoData['videoUrl'],
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 150,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    setState(() {
      _thumbnailPath = path;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _addComment(String videoId) async {
    if (_commentController.text.isNotEmpty) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      String userName = userDoc['name'];
      String userProfileImage = userDoc['image'];

      await FirebaseFirestore.instance.collection('videos').doc(videoId).collection('comments').add({
        'userId': userId,
        'userName': userName,
        'userProfileImage': userProfileImage,
        'comment': _commentController.text,
        'createdAt': Timestamp.now(),
      });

      _commentController.clear();
    }
  }

  void _showComments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsScreen(videoId: widget.videoData['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.kTextFieldColor,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.videoData['userProfileImage']),
            ),
            title: Text(widget.videoData['userName']),
            subtitle: Text(widget.videoData['title']),
          ),
          if (_thumbnailPath != null)
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Image.file(
                    File(_thumbnailPath!),
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (!_controller.value.isPlaying)
                    Center(
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                ],
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.videoData['description'],
              maxLines: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                onPressed: _toggleLike,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: _showComments,
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      Share.share(widget.videoData['videoUrl']);
                    },
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _addComment(widget.videoData['id']),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
