// import 'package:cric_trax/widget/custom_button.dart';
// import 'package:cric_trax/widget/custom_textfield.dart';
// import 'package:flutter/material.dart';
//
// import '../../const/app_colors.dart';
// import '../../widget/custom_text.dart';
//
// class UploadVideoScreen extends StatefulWidget {
//   const UploadVideoScreen({super.key});
//
//   @override
//   State<UploadVideoScreen> createState() => _UploadVideoScreenState();
// }
//
// class _UploadVideoScreenState extends State<UploadVideoScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Upload Video',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               InkWell(
//                 onTap: () {},
//                 child: Container(
//                   height: 200,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.kGreyColor.withOpacity(0.2)),
//                       color: AppColors.kTextFieldColor,
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Center(
//                     child: Text('Upload Video'),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               CustomTextField(hinText: 'Video Title'),
//               CustomTextField(hinText: 'Video Description'),
//               SizedBox(
//                 height: 40,
//               ),
//               CustomButton(onTapp: () {}, text: 'Upload Video'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
///
// import 'dart:io';
// import 'package:cric_trax/widget/custom_loaders.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../const/app_colors.dart';
// import '../../widget/custom_button.dart';
// import '../../widget/custom_textfield.dart';
// import '../../widget/custom_text.dart';
//
// class UploadVideoScreen extends StatefulWidget {
//   const UploadVideoScreen({super.key});
//
//   @override
//   State<UploadVideoScreen> createState() => _UploadVideoScreenState();
// }
//
// class _UploadVideoScreenState extends State<UploadVideoScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   File? _videoFile;
//   bool _isLoading = false;
//   final ImagePicker _picker = ImagePicker();
//   final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
//
//   Future<void> _pickVideo() async {
//     XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
//     if (video != null) {
//       File compressedVideo = await _compressVideo(File(video.path));
//       setState(() {
//         _videoFile = compressedVideo;
//       });
//     }
//   }
//
//   Future<File> _compressVideo(File video) async {
//     final String compressedFilePath = '${video.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.mp4';
//     await _flutterFFmpeg.execute('-i ${video.path} -vcodec libx265 -crf 28 $compressedFilePath');
//     return File(compressedFilePath);
//   }
//
//   Future<void> _uploadVideo() async {
//     if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _videoFile != null) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         String videoUrl = await _uploadFile(_videoFile!);
//         String userId = FirebaseAuth.instance.currentUser!.uid;
//
//         // Retrieve user details
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//         String userName = userDoc['name'];
//         String userProfileImage = userDoc['image'];
//
//         // Create a new video record
//         String videoId = FirebaseFirestore.instance.collection('videos').doc().id;
//         await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
//           'id': videoId,
//           'title': _titleController.text,
//           'description': _descriptionController.text,
//           'videoUrl': videoUrl,
//           'userId': userId,
//           'userName': userName,
//           'userProfileImage': userProfileImage,
//           'likes': [],
//           'comments': [],
//           'createdAt': Timestamp.now(),
//         });
//
//         setState(() {
//           _isLoading = false;
//         });
//         Get.snackbar('Video Uploaded', '',snackPosition: SnackPosition.BOTTOM);
//
//         Navigator.pop(context);
//       } catch (e) {
//         setState(() {
//           _isLoading = false;
//         });
//         Get.snackbar('Error Uploading Video', '$e',snackPosition: SnackPosition.BOTTOM);
//       }
//     } else {
//       Get.snackbar('Warning', 'Please complete all fields',snackPosition: SnackPosition.BOTTOM );
//     }
//   }
//
//   Future<String> _uploadFile(File file) async {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference storageRef = FirebaseStorage.instance.ref().child('videos').child(fileName);
//     UploadTask uploadTask = storageRef.putFile(file);
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomLoader(
//       isLoading: _isLoading,
//       child: Scaffold(
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//           backgroundColor: AppColors.kPrimaryColor,
//           centerTitle: true,
//           title: const CustomText(
//             text: 'Upload Video',
//             fontSize: 16,
//             color: AppColors.kWhiteColor,
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 InkWell(
//                   onTap: _pickVideo,
//                   child: Container(
//                     height: 200,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         border: Border.all(color: AppColors.kGreyColor.withOpacity(0.2)),
//                         color: AppColors.kTextFieldColor,
//                         borderRadius: BorderRadius.circular(12)),
//                     child: Center(
//                       child: Text(_videoFile == null ? 'Upload Video' : 'Video Selected'),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 CustomTextField(controller: _titleController, hinText: 'Video Title'),
//                 CustomTextField(controller: _descriptionController, hinText: 'Video Description'),
//                 const SizedBox(
//                   height: 40,
//                 ),
//                 CustomButton(onTapp: _uploadVideo, text: 'Upload Video'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
///
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_compress/video_compress.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../const/app_colors.dart';
// import '../../widget/custom_button.dart';
// import '../../widget/custom_textfield.dart';
// import '../../widget/custom_text.dart';
//
// class UploadVideoScreen extends StatefulWidget {
//   const UploadVideoScreen({super.key});
//
//   @override
//   State<UploadVideoScreen> createState() => _UploadVideoScreenState();
// }
//
// class _UploadVideoScreenState extends State<UploadVideoScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   File? _videoFile;
//   bool _isLoading = false;
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickVideo() async {
//     XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
//     if (video != null) {
//       File compressedVideo = await _compressVideo(File(video.path));
//       setState(() {
//         _videoFile = compressedVideo;
//       });
//     }
//   }
//
//   Future<File> _compressVideo(File video) async {
//     final compressedVideo = await VideoCompress.compressVideo(
//       video.path,
//       quality: VideoQuality.MediumQuality,
//     );
//     return File(compressedVideo!.path.toString());
//   }
//
//   Future<void> _uploadVideo() async {
//     if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _videoFile != null) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         String videoUrl = await _uploadFile(_videoFile!);
//         String userId = FirebaseAuth.instance.currentUser!.uid;
//
//         // Retrieve user details
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//         String userName = userDoc['name'];
//         String userProfileImage = userDoc['image'];
//
//         // Create a new video record
//         String videoId = FirebaseFirestore.instance.collection('videos').doc().id;
//         await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
//           'id': videoId,
//           'title': _titleController.text,
//           'description': _descriptionController.text,
//           'videoUrl': videoUrl,
//           'userId': userId,
//           'userName': userName,
//           'userProfileImage': userProfileImage,
//           'likes': [],
//           'comments': [],
//           'createdAt': Timestamp.now(),
//         });
//
//         setState(() {
//           _isLoading = false;
//         });
//         Get.snackbar('Video Uploaded', '', snackPosition: SnackPosition.BOTTOM);
//         //Fluttertoast.showToast(msg: 'Video uploaded successfully');
//         Navigator.pop(context);
//       } catch (e) {
//         setState(() {
//           _isLoading = false;
//         });
//         Get.snackbar('Error Uploading Video', '$e',snackPosition: SnackPosition.BOTTOM);
//       }
//     } else {
//       Get.snackbar('Warning', 'Please complete all fields',snackPosition: SnackPosition.BOTTOM );
//     }
//   }
//
//   Future<String> _uploadFile(File file) async {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference storageRef = FirebaseStorage.instance.ref().child('videos').child(fileName);
//     UploadTask uploadTask = storageRef.putFile(file);
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
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
//           text: 'Upload Video',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               InkWell(
//                 onTap: _pickVideo,
//                 child: Container(
//                   height: 200,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.kGreyColor.withOpacity(0.2)),
//                       color: AppColors.kTextFieldColor,
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Center(
//                     child: Text(_videoFile == null ? 'Upload Video' : 'Video Selected'),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               CustomTextField(controller: _titleController, hinText: 'Video Title'),
//               CustomTextField(controller: _descriptionController, hinText: 'Video Description'),
//               const SizedBox(height: 40),
//               CustomButton(onTapp: _uploadVideo, text: 'Upload Video'),
//               if (_isLoading)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 20),
//                   child: CircularProgressIndicator(),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_const_constructors

import 'dart:io';
import 'package:cric_trax/widget/custom_loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import '../../const/app_colors.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/custom_text.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _videoFile;
  File? _thumbnailFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo() async {
    XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final videoFile = File(video.path);
      final result = await _generateThumbnailAndCompressVideo(videoFile);

      setState(() {
        _videoFile = File(result['compressedVideo']!);
        _thumbnailFile = File(result['thumbnail']!);
      });
    }
  }

  Future<Map<String, String>> _generateThumbnailAndCompressVideo(File video) async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    final String thumbnailPath = '${video.path}_thumbnail.png';
    final String compressedVideoPath = '${video.path}_compressed.mp4';

    await _flutterFFmpeg.execute(
        '-i ${video.path} -ss 00:00:01.000 -vframes 1 $thumbnailPath'
    );

    final compressedVideo = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.MediumQuality,
    );

    return {
      'compressedVideo': compressedVideo!.path.toString(),
      'thumbnail': thumbnailPath,
    };
  }

  Future<void> _uploadVideo() async {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _videoFile != null && _thumbnailFile != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        String videoUrl = await _uploadFile(_videoFile!);
        String thumbnailUrl = await _uploadFile(_thumbnailFile!);
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Retrieve user details
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        String userName = userDoc['name'];
        String userProfileImage = userDoc['image'];

        // Create a new video record
        String videoId = FirebaseFirestore.instance.collection('videos').doc().id;
        await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
          'id': videoId,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'videoUrl': videoUrl,
          'thumbnailUrl': thumbnailUrl,
          'userId': userId,
          'userName': userName,
          'userProfileImage': userProfileImage,
          'likes': [],
          'comments': [],
          'createdAt': Timestamp.now(),
        });

        setState(() {
          _isLoading = false;
        });
        Get.snackbar('Video Uploaded', '', snackPosition: SnackPosition.BOTTOM);
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar('Error Uploading Video', '$e', snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Warning', 'Please complete all fields', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<String> _uploadFile(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child(file.path.contains('_thumbnail') ? 'thumbnails' : 'videos').child(fileName);
    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
          backgroundColor: AppColors.kPrimaryColor,
          centerTitle: true,
          title: const CustomText(
            text: 'Upload Video',
            fontSize: 16,
            color: AppColors.kWhiteColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                InkWell(
                  onTap: _pickVideo,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.kGreyColor.withOpacity(0.2)),
                        color: AppColors.kTextFieldColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: _videoFile == null
                          ? Text('Upload Video')
                          : _thumbnailFile == null
                          ? Text('Video Selected')
                          : Image.file(_thumbnailFile!,fit: BoxFit.cover,height: 200,width: double.infinity,),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(controller: _titleController, hinText: 'Video Title'),
                CustomTextField(controller: _descriptionController, hinText: 'Video Description'),
                const SizedBox(height: 40),
                CustomButton(onTapp: _uploadVideo, text: 'Upload Video'),
                // if (_isLoading)
                //   const Padding(
                //     padding: EdgeInsets.only(top: 20),
                //     child: CircularProgressIndicator(),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
