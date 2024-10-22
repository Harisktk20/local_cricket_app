// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../const/app_colors.dart';
// import '../../widget/custom_text.dart';
// import '../../widget/custom_textfield.dart';
//
// class MyVideoScreen extends StatefulWidget {
//   const MyVideoScreen({super.key});
//
//   @override
//   State<MyVideoScreen> createState() => _MyVideoScreenState();
// }
//
// String userId = FirebaseAuth.instance.currentUser!.uid;
//
// class _MyVideoScreenState extends State<MyVideoScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Wat ch',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               CustomTextField(
//                 suffixIcon: Icons.search_sharp,
//                 hinText: 'Search',
//               ),
//
//               for (int i = 0; i < 3; i++)
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 10),
//                   height: MediaQuery
//                       .of(context)
//                       .size
//                       .height * 0.2,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       image: const DecorationImage(
//                           fit: BoxFit.cover, image: AssetImage('assets/images/watch_cric_image.png')),
//                       color: AppColors.kGreyColor.withOpacity(0.4),
//                       borderRadius: BorderRadius.circular(12)),
//                   child: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Spacer(),
//                         Icon(
//                           Icons.play_arrow,
//                           size: 50,
//                           color: AppColors.kBlackColor,
//                         ),
//                         Spacer(),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: CustomText(
//                             text: 'Kohat League',
//                             fontSize: 14,
//                             color: AppColors.kWhiteColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               StreamBuilder(
//                 stream: FirebaseFirestore.instance.collection('videos').snapshots(), builder: (context, snapshot) {
//                 return SizedBox()
//               },)
//               const SizedBox(
//                 height: kToolbarHeight * 1.4,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
///
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share/share.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import '../../const/app_colors.dart';
// import '../../widget/custom_text.dart';
// import '../../widget/custom_textfield.dart';
// import '../comment_screen/comment_screen.dart';
//
// class MyVideoScreen extends StatelessWidget {
//   const MyVideoScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'My Videos',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('videos').where('userId', isEqualTo: userId).snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             return SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     suffixIcon: Icons.search_sharp,
//                     hinText: 'Search',
//                   ),
//                   // ListView.builder(
//                   //   shrinkWrap: true,
//                   //   primary: false,
//                   //   physics: NeverScrollableScrollPhysics(),
//                   //   itemCount: snapshot.data!.docs.length,
//                   //   itemBuilder: (context, index) {
//                   //   return Card(
//                   //     child: Column(
//                   //       children: [
//                   //         Image.network(snapshot.data!.docs[index]['thumbnailUrl'],height: 120,width: 120,fit: BoxFit.cover,)
//                   //       ],
//                   //     ),
//                   //   );
//                   // },),
//                   for (DocumentSnapshot doc in snapshot.data!.docs)
//                     VideoCard(videoData: doc.data() as Map<String, dynamic>),
//                   const SizedBox(height: kToolbarHeight * 1.4),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class VideoCard extends StatefulWidget {
//   final Map<String, dynamic> videoData;
//   const VideoCard({required this.videoData, super.key});
//
//   @override
//   State<VideoCard> createState() => _VideoCardState();
// }
//
// class _VideoCardState extends State<VideoCard> {
//   late VideoPlayerController _controller;
//   bool? _isLiked;
//   final TextEditingController _commentController = TextEditingController();
//   String? _thumbnailPath;
//   final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoPlayer();
//     _generateThumbnail();
//     _fetchLikeStatus();
//   }
//
//   Future<void> _initializeVideoPlayer() async {
//     try {
//       _controller = VideoPlayerController.network(widget.videoData['videoUrl']);
//       await _controller.initialize();
//       setState(() {});
//     } catch (e) {
//       print("Error initializing video player: $e");
//     }
//   }
//
//   Future<void> _generateThumbnail() async {
//     try {
//       final String? path = await VideoThumbnail.thumbnailFile(
//         video: widget.videoData['videoUrl'],
//         thumbnailPath: (await getTemporaryDirectory()).path,
//         imageFormat: ImageFormat.PNG,
//         maxHeight: 150,
//         quality: 75,
//       );
//       setState(() {
//         _thumbnailPath = path;
//       });
//     } catch (e) {
//       print("Error generating thumbnail: $e");
//     }
//   }
//
//   Future<void> _fetchLikeStatus() async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     String videoId = widget.videoData['id'];
//
//     DocumentSnapshot videoDoc = await FirebaseFirestore.instance.collection('videos').doc(videoId).get();
//     List<String> likes = List<String>.from(videoDoc['likes'] ?? []);
//
//     setState(() {
//       _isLiked = likes.contains(userId);
//     });
//   }
//
//   void _toggleLike() async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     String videoId = widget.videoData['id'];
//
//     DocumentReference videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);
//     DocumentSnapshot videoDoc = await videoRef.get();
//     List<String> likes = List<String>.from(videoDoc['likes'] ?? []);
//
//     if (_isLiked == true) {
//       likes.remove(userId);
//     } else {
//       likes.add(userId);
//     }
//
//     await videoRef.update({
//       'likes': likes,
//     });
//
//     setState(() {
//       _isLiked = !_isLiked!;
//     });
//   }
//
//   void _addComment(String videoId) async {
//     if (_commentController.text.isNotEmpty) {
//       String userId = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//       String userName = userDoc['name'];
//       String userProfileImage = userDoc['image'];
//
//       await FirebaseFirestore.instance.collection('videos').doc(videoId).collection('comments').add({
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
//   Future<void> _deleteVideo() async {
//     String videoId = widget.videoData['id'];
//     await FirebaseFirestore.instance.collection('videos').doc(videoId).delete();
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
//     return Card(
//       color: AppColors.kTextFieldColor,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(widget.videoData['userProfileImage']),
//             ),
//             title: Text(widget.videoData['userName']),
//             subtitle: Text(widget.videoData['title']),
//             trailing: widget.videoData['userId'] == _currentUserId
//                 ? IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: _deleteVideo,
//                   )
//                 : null,
//           ),
//           if (_thumbnailPath != null)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (_controller.value.isPlaying) {
//                     _controller.pause();
//                   } else {
//                     _controller.play();
//                   }
//                 });
//               },
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Image.file(
//                     File(_thumbnailPath!),
//                     height: 130,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   if (!_controller.value.isPlaying)
//                     const Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 64,
//                     ),
//                 ],
//               ),
//             )
//           else
//             const Center(child: CircularProgressIndicator()),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(widget.videoData['description'], maxLines: 2),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   _isLiked == true ? Icons.favorite : Icons.favorite_border,
//                   color: Colors.red,
//                 ),
//                 onPressed: _toggleLike,
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.comment),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CommentsScreen(videoId: widget.videoData['id']),
//                         ),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.share),
//                     onPressed: () {
//                       Share.share(widget.videoData['videoUrl']);
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           // Padding(
//           //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           //   child: TextField(
//           //     controller: _commentController,
//           //     decoration: InputDecoration(
//           //       hintText: 'Add a comment...',
//           //       suffixIcon: IconButton(
//           //         icon: const Icon(Icons.send),
//           //         onPressed: () => _addComment(widget.videoData['id']),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share/share.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import '../../const/app_colors.dart';
// import '../../widget/custom_text.dart';
// import '../../widget/custom_textfield.dart';
// import '../comment_screen/comment_screen.dart';
//
// class MyVideoScreen extends StatelessWidget {
//   const MyVideoScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'My Videos',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('videos').where('userId', isEqualTo: userId).snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             return SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     suffixIcon: Icons.search_sharp,
//                     hinText: 'Search',
//                   ),
//                   for (DocumentSnapshot doc in snapshot.data!.docs)
//                     VideoCard(videoData: doc.data() as Map<String, dynamic>),
//                   const SizedBox(height: kToolbarHeight * 1.4),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class VideoCard extends StatefulWidget {
//   final Map<String, dynamic> videoData;
//   const VideoCard({required this.videoData, super.key});
//
//   @override
//   State<VideoCard> createState() => _VideoCardState();
// }
//
// class _VideoCardState extends State<VideoCard> {
//   late VideoPlayerController _controller;
//   bool? _isLiked;
//   final TextEditingController _commentController = TextEditingController();
//   String? _thumbnailPath;
//   final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   int _likeCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoPlayer();
//     _generateThumbnail();
//     _fetchLikeStatus();
//   }
//
//   Future<void> _initializeVideoPlayer() async {
//     try {
//       _controller = VideoPlayerController.network(widget.videoData['videoUrl']);
//       await _controller.initialize();
//       setState(() {});
//     } catch (e) {
//       print("Error initializing video player: $e");
//     }
//   }
//
//   Future<void> _generateThumbnail() async {
//     try {
//       final String? path = await VideoThumbnail.thumbnailFile(
//         video: widget.videoData['videoUrl'],
//         thumbnailPath: (await getTemporaryDirectory()).path,
//         imageFormat: ImageFormat.PNG,
//         maxHeight: 150,
//         quality: 75,
//       );
//       setState(() {
//         _thumbnailPath = path;
//       });
//     } catch (e) {
//       print("Error generating thumbnail: $e");
//     }
//   }
//
//   Future<void> _fetchLikeStatus() async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     String videoId = widget.videoData['id'];
//
//     DocumentSnapshot videoDoc = await FirebaseFirestore.instance.collection('videos').doc(videoId).get();
//     List<String> likes = List<String>.from(videoDoc['likes'] ?? []);
//     _likeCount = likes.length;
//
//     setState(() {
//       _isLiked = likes.contains(userId);
//     });
//   }
//
//   void _toggleLike() async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     String videoId = widget.videoData['id'];
//
//     DocumentReference videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);
//     DocumentSnapshot videoDoc = await videoRef.get();
//     List<String> likes = List<String>.from(videoDoc['likes'] ?? []);
//
//     if (_isLiked == true) {
//       likes.remove(userId);
//       _likeCount--;
//     } else {
//       likes.add(userId);
//       _likeCount++;
//     }
//
//     await videoRef.update({
//       'likes': likes,
//     });
//
//     setState(() {
//       _isLiked = !_isLiked!;
//     });
//   }
//
//   void _addComment(String videoId) async {
//     if (_commentController.text.isNotEmpty) {
//       String userId = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//       String userName = userDoc['name'];
//       String userProfileImage = userDoc['image'];
//
//       await FirebaseFirestore.instance.collection('videos').doc(videoId).collection('comments').add({
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
//   Future<void> _deleteVideo() async {
//     String videoId = widget.videoData['id'];
//     await FirebaseFirestore.instance.collection('videos').doc(videoId).delete();
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
//     return Card(
//       color: AppColors.kTextFieldColor,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(widget.videoData['userProfileImage']),
//             ),
//             title: Text(widget.videoData['userName']),
//             subtitle: Text(widget.videoData['title']),
//             trailing: widget.videoData['userId'] == _currentUserId
//                 ? IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: _deleteVideo,
//             )
//                 : null,
//           ),
//           if (_thumbnailPath != null)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (_controller.value.isPlaying) {
//                     _controller.pause();
//                   } else {
//                     _controller.play();
//                   }
//                 });
//               },
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Image.file(
//                     File(_thumbnailPath!),
//                     height: 130,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   if (!_controller.value.isPlaying)
//                     const Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 64,
//                     ),
//                 ],
//               ),
//             )
//           else
//             const Center(child: CircularProgressIndicator()),
//           if (_controller.value.isInitialized)
//             AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(widget.videoData['description'], maxLines: 2),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(_isLiked == true ? Icons.favorite : Icons.favorite_border),
//                     onPressed: _toggleLike,
//                   ),
//                   Text('$_likeCount'),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.comment),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CommentsScreen(videoId: widget.videoData['id']),
//                         ),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.share),
//                     onPressed: () {
//                       Share.share(widget.videoData['videoUrl']);
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share/share.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import '../../const/app_colors.dart';
// import '../../widget/custom_text.dart';
// import '../../widget/custom_textfield.dart';
// import '../comment_screen/comment_screen.dart';
//
// class MyVideoScreen extends StatelessWidget {
//   const MyVideoScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'My Videos',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('videos').where('userId', isEqualTo: userId).snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             return SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     suffixIcon: Icons.search_sharp,
//                     hinText: 'Search',
//                   ),
//                   for (DocumentSnapshot doc in snapshot.data!.docs)
//                     VideoCard(videoData: doc.data() as Map<String, dynamic>),
//                   const SizedBox(height: kToolbarHeight * 1.4),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class VideoCard extends StatefulWidget {
//   final Map<String, dynamic> videoData;
//   const VideoCard({required this.videoData, super.key});
//
//   @override
//   State<VideoCard> createState() => _VideoCardState();
// }
//
// class _VideoCardState extends State<VideoCard> {
//   late VideoPlayerController _controller;
//   bool? _isLiked;
//   final TextEditingController _commentController = TextEditingController();
//   String? _thumbnailPath;
//   final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   int _likeCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoPlayer();
//     _generateThumbnail();
//     _fetchLikeStatus();
//   }
//
//   Future<void> _initializeVideoPlayer() async {
//     try {
//       _controller = VideoPlayerController.network(widget.videoData['videoUrl']);
//       await _controller.initialize();
//       setState(() {});
//     } catch (e) {
//       print("Error initializing video player: $e");
//     }
//   }
//
//   Future<void> _generateThumbnail() async {
//     try {
//       final String? path = await VideoThumbnail.thumbnailFile(
//         video: widget.videoData['videoUrl'],
//         thumbnailPath: (await getTemporaryDirectory()).path + '/' + widget.videoData['id'] + '.png',
//         imageFormat: ImageFormat.PNG,
//         maxHeight: 150,
//         quality: 75,
//       );
//       setState(() {
//         _thumbnailPath = path;
//       });
//     } catch (e) {
//       print("Error generating thumbnail: $e");
//     }
//   }
//
//   Future<void> _fetchLikeStatus() async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     String videoId = widget.videoData['id'];
//
//     DocumentSnapshot videoDoc = await FirebaseFirestore.instance.collection('videos').doc(videoId).get();
//     List<String> likes = List<String>.from(videoDoc['likes'] ?? []);
//     _likeCount = likes.length;
//
//     setState(() {
//       _isLiked = likes.contains(userId);
//     });
//   }
//
//   void _toggleLike() async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     String videoId = widget.videoData['id'];
//
//     DocumentReference videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);
//     DocumentSnapshot videoDoc = await videoRef.get();
//     List<String> likes = List<String>.from(videoDoc['likes'] ?? []);
//
//     if (_isLiked == true) {
//       likes.remove(userId);
//       _likeCount--;
//     } else {
//       likes.add(userId);
//       _likeCount++;
//     }
//
//     await videoRef.update({
//       'likes': likes,
//     });
//
//     setState(() {
//       _isLiked = !_isLiked!;
//     });
//   }
//
//   void _addComment(String videoId) async {
//     if (_commentController.text.isNotEmpty) {
//       String userId = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//       String userName = userDoc['name'];
//       String userProfileImage = userDoc['image'];
//
//       await FirebaseFirestore.instance.collection('videos').doc(videoId).collection('comments').add({
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
//   Future<void> _deleteVideo() async {
//     String videoId = widget.videoData['id'];
//     await FirebaseFirestore.instance.collection('videos').doc(videoId).delete();
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
//     return Card(
//       color: AppColors.kTextFieldColor,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(widget.videoData['userProfileImage']),
//             ),
//             title: Text(widget.videoData['userName']),
//             subtitle: Text(widget.videoData['title']),
//             trailing: widget.videoData['userId'] == _currentUserId
//                 ? IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: _deleteVideo,
//             )
//                 : null,
//           ),
//           if (_thumbnailPath != null)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (_controller.value.isPlaying) {
//                     _controller.pause();
//                   } else {
//                     _controller.play();
//                   }
//                 });
//               },
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Image.file(
//                     File(_thumbnailPath!),
//                     height: 130,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   if (!_controller.value.isPlaying)
//                     const Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 64,
//                     ),
//                 ],
//               ),
//             )
//           else
//             const Center(child: CircularProgressIndicator()),
//           if (_controller.value.isInitialized)
//             AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(widget.videoData['description'], maxLines: 2),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   // IconButton(
//                   //   icon: Icon(_isLiked == true ? Icons.favorite : Icons.favorite_border),
//                   //   onPressed: _toggleLike,
//                   // ),
//                   SizedBox(width: 10),
//                   Text('Likes '),
//                   Text('$_likeCount',style: TextStyle(fontWeight: FontWeight.bold),),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.comment),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CommentsScreen(videoId: widget.videoData['id']),
//                         ),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.share),
//                     onPressed: () {
//                       Share.share(widget.videoData['videoUrl']);
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// ignore_for_file: deprecated_member_use, avoid_print, prefer_interpolation_to_compose_strings, unused_element, prefer_const_constructors, use_super_parameters, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../const/app_colors.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_textfield.dart';
import '../comment_screen/comment_screen.dart';

class MyVideoScreen extends StatelessWidget {
  const MyVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
        backgroundColor: AppColors.kPrimaryColor,
        centerTitle: true,
        title: const CustomText(
          text: 'My Videos',
          fontSize: 16,
          color: AppColors.kWhiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('videos').where('userId', isEqualTo: userId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CustomTextField(
                    suffixIcon: Icons.search_sharp,
                    hinText: 'Search',
                  ),
                  for (DocumentSnapshot doc in snapshot.data!.docs)
                    VideoCard(videoData: doc.data() as Map<String, dynamic>),
                  const SizedBox(height: kToolbarHeight * 1.4),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final Map<String, dynamic> videoData;
  const VideoCard({required this.videoData, super.key});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  bool? _isLiked;
  final TextEditingController _commentController = TextEditingController();
  String? _thumbnailPath;
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _generateThumbnail();
    _fetchLikeStatus();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.network(widget.videoData['videoUrl']);
      await _controller.initialize();
      setState(() {});
    } catch (e) {
      print("Error initializing video player: $e");
    }
  }

  Future<void> _generateThumbnail() async {
    try {
      final String? path = await VideoThumbnail.thumbnailFile(
        video: widget.videoData['videoUrl'],
        thumbnailPath: (await getTemporaryDirectory()).path + '/' + widget.videoData['id'] + '.png',
        imageFormat: ImageFormat.PNG,
        maxHeight: 150,
        quality: 75,
      );
      setState(() {
        _thumbnailPath = path;
      });
    } catch (e) {
      print("Error generating thumbnail: $e");
    }
  }

  Future<void> _fetchLikeStatus() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String videoId = widget.videoData['id'];

    DocumentSnapshot videoDoc = await FirebaseFirestore.instance.collection('videos').doc(videoId).get();
    List<String> likes = List<String>.from(videoDoc['likes'] ?? []);
    _likeCount = likes.length;

    setState(() {
      _isLiked = likes.contains(userId);
    });
  }

  void _toggleLike() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String videoId = widget.videoData['id'];

    DocumentReference videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);
    DocumentSnapshot videoDoc = await videoRef.get();
    List<String> likes = List<String>.from(videoDoc['likes'] ?? []);

    if (_isLiked == true) {
      likes.remove(userId);
      _likeCount--;
    } else {
      likes.add(userId);
      _likeCount++;
    }

    await videoRef.update({
      'likes': likes,
    });

    setState(() {
      _isLiked = !_isLiked!;
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

  Future<void> _deleteVideo() async {
    String videoId = widget.videoData['id'];
    await FirebaseFirestore.instance.collection('videos').doc(videoId).delete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            trailing: widget.videoData['userId'] == _currentUserId
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _deleteVideo,
                  )
                : null,
          ),
          if (_thumbnailPath != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenVideoPlayer(videoUrl: widget.videoData['videoUrl']),
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(
                    File(_thumbnailPath!),
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 64,
                  ),
                ],
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.videoData['description'], maxLines: 2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  // IconButton(
                  //icon:
                  Icon(
                    _isLiked == true ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  //onPressed: _toggleLike,
                  //),
                  SizedBox(width: 10),

                  Text('$_likeCount'),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.chat_bubble),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(videoId: widget.videoData['id']),
                        ),
                      );
                    },
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
        ],
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const FullScreenVideoPlayer({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
