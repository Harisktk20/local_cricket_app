// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../const/app_colors.dart';
// import '../../widget/custom_text.dart';
// import '../../widget/custom_textfield.dart';
//
// class WatchScreen extends StatelessWidget {
//   const WatchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Watch',
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
//               for (int i = 0; i < 3; i++)
//                 Container(
//                   margin: EdgeInsets.only(bottom: 10),
//                   height: MediaQuery.of(context).size.height * 0.32,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       color: AppColors.kGreyColor.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
//                   child: Column(
//                     children: [
//                       ClipRRect(
//                         borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//                         child: Image.asset(
//                           'assets/images/watch_cric_image.png',
//                           height: 150,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [CustomText(text: 'Peshawar vs Kohat club '), Icon(Icons.more_vert_sharp)],
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(6.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.favorite, color: Colors.red),
//                                 SizedBox(width: 10),
//                                 Icon(Icons.comment),
//                                 SizedBox(width: 10),
//                                 Icon(Icons.send),
//                               ],
//                             ),
//                             CustomText(text: '98 Comments  4k views'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               SizedBox(
//                 height: kToolbarHeight*1.4,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:video_player/video_player.dart';
// import '../../const/app_colors.dart';
// import '../../widget/custom_text.dart';
// import '../../widget/custom_textfield.dart';
//
// class WatchScreen extends StatefulWidget {
//   const WatchScreen({super.key});
//
//   @override
//   _WatchScreenState createState() => _WatchScreenState();
// }
//
// class _WatchScreenState extends State<WatchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   late String _searchText;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchText = '';
//   }
//
//   Stream<List<DocumentSnapshot>> _fetchVideos() {
//     return FirebaseFirestore.instance
//         .collection('videos')
//         .snapshots()
//         .map((snapshot) => snapshot.docs);
//   }
//
//   Future<void> _likeVideo(String videoId) async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     DocumentReference videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);
//
//     FirebaseFirestore.instance.runTransaction((transaction) async {
//       DocumentSnapshot videoSnapshot = await transaction.get(videoRef);
//       List likes = videoSnapshot['likes'];
//       if (likes.contains(userId)) {
//         transaction.update(videoRef, {'likes': FieldValue.arrayRemove([userId])});
//       } else {
//         transaction.update(videoRef, {'likes': FieldValue.arrayUnion([userId])});
//       }
//     });
//   }
//
//   void _shareVideo(String videoUrl) {
//     Share.share('Check out this video: $videoUrl');
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
//           text: 'Watch',
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
//                 controller: _searchController,
//                 suffixIcon: Icons.search_sharp,
//                 hinText: 'Search',
//                 onValueChanged: (value) {
//                   setState(() {
//                     _searchText = value.toLowerCase();
//                   });
//                 },
//               ),
//               StreamBuilder<List<DocumentSnapshot>>(
//                 stream: _fetchVideos(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return const Center(child: Text('Error fetching videos'));
//                   }
//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No videos found'));
//                   }
//
//                   List<DocumentSnapshot> videos = snapshot.data!;
//                   List<DocumentSnapshot> filteredVideos = videos.where((video) {
//                     String title = video['title'].toLowerCase();
//                     return title.contains(_searchText);
//                   }).toList();
//
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: filteredVideos.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot video = filteredVideos[index];
//                       String videoUrl = video['videoUrl'];
//                       String title = video['title'];
//                       String description = video['description'];
//                       List likes = video['likes'];
//                       int likeCount = likes.length;
//                       int commentCount = video['comments'].length;
//
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 10),
//                         height: MediaQuery.of(context).size.height * 0.3,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: AppColors.kGreyColor.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           children: [
//                             Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//                                   child: Image.network(
//                                     videoUrl, // This should be a thumbnail image URL
//                                     height: 150,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 0,
//                                   left: 0,
//                                   right: 0,
//                                   bottom: 0,
//                                   child: Center(
//                                     child: IconButton(
//                                       icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
//                                       onPressed: () => _playVideo(videoUrl),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   CustomText(text: title),
//                                   IconButton(
//                                     icon: const Icon(Icons.more_vert_sharp),
//                                     onPressed: () {},
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.favorite,
//                                           color: likes.contains(FirebaseAuth.instance.currentUser!.uid) ? Colors.red : Colors.grey,
//                                         ),
//                                         onPressed: () => _likeVideo(video.id),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       IconButton(
//                                         icon: const Icon(Icons.comment),
//                                         onPressed: () {},
//                                       ),
//                                       const SizedBox(width: 10),
//                                       IconButton(
//                                         icon: const Icon(Icons.send),
//                                         onPressed: () => _shareVideo(videoUrl),
//                                       ),
//                                     ],
//                                   ),
//                                   CustomText(text: '$commentCount Comments  $likeCount Likes'),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: kToolbarHeight * 1.4,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _playVideo(String videoUrl) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Video Player'),
//           content: VideoPlayerWidget(videoUrl: videoUrl),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//       });
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
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _controller.value.isInitialized
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : const Center(child: CircularProgressIndicator()),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(
//                 _isPlaying ? Icons.pause : Icons.play_arrow,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 setState(() {
//                   if (_isPlaying) {
//                     _controller.pause();
//                   } else {
//                     _controller.play();
//                   }
//                   _isPlaying = !_isPlaying;
//                 });
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:share/share.dart';
// import 'package:video_player/video_player.dart';
// import '../../const/app_colors.dart';
// import '../../widget/custom_text.dart';
// import '../../widget/custom_textfield.dart';
//
// class WatchScreen extends StatefulWidget {
//   const WatchScreen({super.key});
//
//   @override
//   _WatchScreenState createState() => _WatchScreenState();
// }
//
// class _WatchScreenState extends State<WatchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   late String _searchText;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchText = '';
//   }
//
//   Stream<List<DocumentSnapshot>> _fetchVideos() {
//     return FirebaseFirestore.instance
//         .collection('videos')
//         .snapshots()
//         .map((snapshot) => snapshot.docs);
//   }
//
//   Future<void> _likeVideo(String videoId) async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     DocumentReference videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);
//
//     FirebaseFirestore.instance.runTransaction((transaction) async {
//       DocumentSnapshot videoSnapshot = await transaction.get(videoRef);
//       List likes = videoSnapshot['likes'];
//       if (likes.contains(userId)) {
//         transaction.update(videoRef, {'likes': FieldValue.arrayRemove([userId])});
//       } else {
//         transaction.update(videoRef, {'likes': FieldValue.arrayUnion([userId])});
//       }
//     });
//   }
//
//   void _shareVideo(String videoUrl) {
//     Share.share('Check out this video: $videoUrl');
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
//           text: 'Watch',
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
//                 controller: _searchController,
//                 suffixIcon: Icons.search_sharp,
//                 hinText: 'Search',
//                 onValueChanged: (value) {
//                   setState(() {
//                     _searchText = value.toLowerCase();
//                   });
//                 },
//               ),
//               StreamBuilder<List<DocumentSnapshot>>(
//                 stream: _fetchVideos(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return const Center(child: Text('Error fetching videos'));
//                   }
//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No videos found'));
//                   }
//
//                   List<DocumentSnapshot> videos = snapshot.data!;
//                   List<DocumentSnapshot> filteredVideos = videos.where((video) {
//                     String title = video['title'].toLowerCase();
//                     return title.contains(_searchText);
//                   }).toList();
//
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: filteredVideos.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot video = filteredVideos[index];
//                       String videoUrl = video['videoUrl'];
//                       String thumbnailUrl = video['thumbnailUrl']; // Use thumbnail URL
//                       String title = video['title'];
//                       //String description = video['description'];
//                       List likes = video['likes'];
//                       int likeCount = likes.length;
//                       int commentCount = video['comments'].length;
//
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 10),
//                         height: MediaQuery.of(context).size.height * 0.4,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: AppColors.kGreyColor.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           children: [
//                             Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//                                   child: Image.network(
//                                     thumbnailUrl, // Display thumbnail
//                                     height: 150,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 0,
//                                   left: 0,
//                                   right: 0,
//                                   bottom: 0,
//                                   child: Center(
//                                     child: IconButton(
//                                       icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
//                                       onPressed: () => _playVideo(videoUrl),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   CustomText(text: title),
//                                   IconButton(
//                                     icon: const Icon(Icons.more_vert_sharp),
//                                     onPressed: () {},
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.favorite,
//                                           color: likes.contains(FirebaseAuth.instance.currentUser!.uid) ? Colors.red : Colors.grey,
//                                         ),
//                                         onPressed: () => _likeVideo(video.id),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       IconButton(
//                                         icon: const Icon(Icons.comment),
//                                         onPressed: () {},
//                                       ),
//                                       const SizedBox(width: 10),
//                                       IconButton(
//                                         icon: const Icon(Icons.send),
//                                         onPressed: () => _shareVideo(videoUrl),
//                                       ),
//                                     ],
//                                   ),
//                                   CustomText(text: '$commentCount Comments  $likeCount Likes'),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: kToolbarHeight * 1.4,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _playVideo(String videoUrl) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Video Player'),
//           content: VideoPlayerWidget(videoUrl: videoUrl),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//       });
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
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _controller.value.isInitialized
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : const Center(child: CircularProgressIndicator()),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(
//                 _isPlaying ? Icons.pause : Icons.play_arrow,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 setState(() {
//                   if (_isPlaying) {
//                     _controller.pause();
//                   } else {
//                     _controller.play();
//                   }
//                   _isPlaying = !_isPlaying;
//                 });
//               },
//             ),
//           ],
//         ),
//       ],
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
//
// class WatchScreen extends StatelessWidget {
//   const WatchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Watch',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('videos').snapshots(),
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
//   bool isLiked = false;
//   final TextEditingController _commentController = TextEditingController();
//   String? _thumbnailPath;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoPlayer();
//     _generateThumbnail();
//   }
//
//   Future<void> _initializeVideoPlayer() async {
//     _controller = VideoPlayerController.network(widget.videoData['videoUrl']);
//     await _controller.initialize();
//     setState(() {});
//   }
//
//   Future<void> _generateThumbnail() async {
//     final String? path = await VideoThumbnail.thumbnailFile(
//       video: widget.videoData['videoUrl'],
//       thumbnailPath: (await getTemporaryDirectory()).path,
//       imageFormat: ImageFormat.PNG,
//       maxHeight: 150, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
//       quality: 75,
//     );
//     setState(() {
//       _thumbnailPath = path;
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _toggleLike() {
//     setState(() {
//       isLiked = !isLiked;
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
//           ),
//           if (_thumbnailPath != null)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _controller.value.isPlaying ? _controller.pause() : _controller.play();
//                 });
//               },
//               child: Stack(
//                 alignment: Alignment.centerRight,
//                 children: [
//                   Image.file(File(_thumbnailPath!),height: 130,width: double.infinity,fit: BoxFit.cover,),
//                   if (!_controller.value.isPlaying)
//                     Center(
//                       child: const Icon(
//                         Icons.play_arrow,
//                         color: Colors.white,
//                         size: 64,
//                       ),
//                     ),
//                 ],
//               ),
//             )
//           else
//             const Center(child: CircularProgressIndicator()),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(widget.videoData['description'],maxLines: 2,),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
//                 onPressed: _toggleLike,
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.comment),
//                     onPressed: () {
//                       _addComment(widget.videoData['id']);
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
//
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: TextField(
//               controller: _commentController,
//               decoration: InputDecoration(
//                 hintText: 'Add a comment...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () => _addComment(widget.videoData['id']),
//                 ),
//               ),
//             ),
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
//
// class WatchScreen extends StatelessWidget {
//   const WatchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Watch',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('videos').snapshots(),
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
//                 icon: Icon(_isLiked == true ? Icons.favorite : Icons.favorite_border),
//                 onPressed: _toggleLike,
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.comment),
//                     onPressed: () {
//                       _addComment(widget.videoData['id']);
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
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: TextField(
//               controller: _commentController,
//               decoration: InputDecoration(
//                 hintText: 'Add a comment...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () => _addComment(widget.videoData['id']),
//                 ),
//               ),
//             ),
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
//
// class WatchScreen extends StatelessWidget {
//   const WatchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Watch',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('videos').snapshots(),
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
//                 icon: Icon(_isLiked == true ? Icons.favorite : Icons.favorite_border),
//                 onPressed: _toggleLike,
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.comment),
//                     onPressed: () {
//                       _addComment(widget.videoData['id']);
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
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: TextField(
//               controller: _commentController,
//               decoration: InputDecoration(
//                 hintText: 'Add a comment...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () => _addComment(widget.videoData['id']),
//                 ),
//               ),
//             ),
//           ),
//         ],
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
//
// class WatchScreen extends StatelessWidget {
//   const WatchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Watch',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('videos').snapshots(),
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
//                 icon: Icon(_isLiked == true ? Icons.favorite : Icons.favorite_border,color: Colors.red,),
//                 onPressed: _toggleLike,
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.comment),
//                     onPressed: () {
//                       _addComment(widget.videoData['id']);
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
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: TextField(
//               controller: _commentController,
//               decoration: InputDecoration(
//                 hintText: 'Add a comment...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () => _addComment(widget.videoData['id']),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
/// proper
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
//
// class WatchScreen extends StatelessWidget {
//   const WatchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Watch',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('videos').snapshots(),
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
//           ),
//           if (_thumbnailPath != null)
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FullScreenVideoPlayer(videoUrl: widget.videoData['videoUrl']),
//                   ),
//                 );
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
//                   const Icon(
//                     Icons.play_arrow,
//                     color: Colors.white,
//                     size: 64,
//                   ),
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
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(_isLiked == true ? Icons.favorite : Icons.favorite_border, color: Colors.red),
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
//                       _addComment(widget.videoData['id']);
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
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: TextField(
//               controller: _commentController,
//               decoration: InputDecoration(
//                 hintText: 'Add a comment...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () => _addComment(widget.videoData['id']),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class FullScreenVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   const FullScreenVideoPlayer({required this.videoUrl, Key? key}) : super(key: key);
//
//   @override
//   _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
// }
//
// class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       });
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
//       backgroundColor: Colors.black,
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : const CircularProgressIndicator(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _controller.value.isPlaying ? _controller.pause() : _controller.play();
//           });
//         },
//         child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
//       ),
//     );
//   }
// }
///
// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, use_super_parameters, library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';
import 'dart:io';
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
import 'package:http/http.dart' as http;

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
        backgroundColor: AppColors.kPrimaryColor,
        centerTitle: true,
        title: const CustomText(
          text: 'Watch',
          fontSize: 16,
          color: AppColors.kWhiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('videos').snapshots(),
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

  void toggleLike() async {
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
      sendNotification('Your Video has been liked!', userId);
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
      }).then((v){
sendNotification('You got a new comment', userId);
      });

      _commentController.clear();
    }
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
                  IconButton(
                    icon: Icon(_isLiked == true ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      toggleLike();
                    },
                  ),
                  Text('$_likeCount'),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      _addComment(widget.videoData['id']);
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

Future<String?> getAdminPlayerId(String adminUid) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance.collection('tokens').doc(adminUid).get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      print('Admin player ID retrieved: ${docSnapshot.data()!['id']}');
      return docSnapshot.data()!['id'] as String?;
    } else {
      print('Admin player ID not found');
      return null;
    }
  } catch (e) {
    print('Failed to retrieve admin player ID: $e');
    return null;
  }
}

Future<void> sendNotification(String content, String adminUid) async {
  try {
    String? playerId = await getAdminPlayerId(adminUid);
    if (playerId == null) {
      print('Player ID is null, cannot send notification');
      return;
    }

    print('Sending notification to player ID: $playerId with content: $content');

    var headers = {
      'Authorization': 'Bearer MzFmZTM5NWEtM2NjYS00NzA3LTg0OTctOGJmZjg2YjdiYzRl',
      'Content-Type': 'application/json',
    };

    var request = http.Request('POST', Uri.parse('https://onesignal.com/api/v1/notifications'));
    request.body = json.encode({
      "app_id": "8585215c-b630-4d8b-b6e6-8b1669afd7a4",
      "include_player_ids": [playerId],
      "contents": {"en": content}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Notification sent successfully');
      print(await response.stream.bytesToString());
    } else {
      print('Failed to send notification: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}
///
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
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
// import 'package:http/http.dart' as http;
//
// class WatchScreen extends StatelessWidget {
//   const WatchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Watch',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('videos').snapshots(),
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
//
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
//   void toggleLike() async {
//     String userId = FirebaseAuth.instance.currentUser!.uid;
//     String videoId = widget.videoData['id'];
//     String uploaderId = widget.videoData['uploaderId']; // Ensure this field exists in the video document
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
//       sendNotification('Your video has been liked!', uploaderId); // Send notification on like
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
//       String uploaderId = widget.videoData['userId']; // Ensure this field exists in the video document
//
//       await FirebaseFirestore.instance.collection('videos').doc(videoId).collection('comments').add({
//         'userId': userId,
//         'userName': userName,
//         'userProfileImage': userProfileImage,
//         'comment': _commentController.text,
//         'createdAt': Timestamp.now(),
//       });
//
//       sendNotification('Your video has a new comment!', uploaderId); // Send notification on comment
//       _commentController.clear();
//     }
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
//           ),
//           if (_thumbnailPath != null)
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FullScreenVideoPlayer(videoUrl: widget.videoData['videoUrl']),
//                   ),
//                 );
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
//                   const Icon(
//                     Icons.play_arrow,
//                     color: Colors.white,
//                     size: 64,
//                   ),
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
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(_isLiked == true ? Icons.favorite : Icons.favorite_border, color: Colors.red),
//                     onPressed: () {
//                       toggleLike();
//                     },
//                   ),
//                   Text('$_likeCount'),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(CupertinoIcons.chat_bubble),
//                     onPressed: () {
//                       _addComment(widget.videoData['id']);
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
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: InputDecoration(
//                         contentPadding: EdgeInsets.all(10),
//                         isDense: true,
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
//                         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
//                         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
//                         hintText: 'Add a comment...',
//                         // suffixIcon: IconButton(
//                         hintStyle: TextStyle(fontSize: 14)
//                         //   icon: const Icon(Icons.send),
//                         //   onPressed: () => _addComment(widget.videoData['id']),
//                         // ),
//                         ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.send,
//                     color: AppColors.kBgColor,
//                   ),
//                   onPressed: () => _addComment(widget.videoData['id']),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class FullScreenVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//
//   const FullScreenVideoPlayer({required this.videoUrl, Key? key}) : super(key: key);
//
//   @override
//   _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
// }
//
// class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       });
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
//       backgroundColor: Colors.black,
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : const CircularProgressIndicator(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _controller.value.isPlaying ? _controller.pause() : _controller.play();
//           });
//         },
//         child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
//       ),
//     );
//   }
// }
//
// Future<String?> getAdminPlayerId(String adminUid) async {
//   try {
//     final docSnapshot = await FirebaseFirestore.instance.collection('tokens').doc(adminUid).get();
//     if (docSnapshot.exists && docSnapshot.data() != null) {
//       print('Admin player ID retrieved: ${docSnapshot.data()!['id']}');
//       return docSnapshot.data()!['id'] as String?;
//     } else {
//       print('Admin player ID not found');
//       return null;
//     }
//   } catch (e) {
//     print('Failed to retrieve admin player ID: $e');
//     return null;
//   }
// }
//
// Future<void> sendNotification(String content, String adminUid) async {
//   try {
//     String? playerId = await getAdminPlayerId(adminUid);
//     if (playerId == null) {
//       print('Player ID is null, cannot send notification');
//       return;
//     }
//
//     print('Sending notification to player ID: $playerId with content: $content');
//
//     var headers = {
//       'Authorization': 'Bearer MzFmZTM5NWEtM2NjYS00NzA3LTg0OTctOGJmZjg2YjdiYzRl',
//       'Content-Type': 'application/json',
//     };
//
//     var request = http.Request('POST', Uri.parse('https://onesignal.com/api/v1/notifications'));
//     request.body = json.encode({
//       "app_id": "1108f2cd-f8b5-4d2f-9fcf-e42b4b9c8dd0",
//       "include_player_ids": [playerId],
//       "contents": {"en": content}
//     });
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       print('Notification sent successfully');
//       print(await response.stream.bytesToString());
//     } else {
//       print('Failed to send notification: ${response.reasonPhrase}');
//     }
//   } catch (e) {
//     print('Error sending notification: $e');
//   }
// }



