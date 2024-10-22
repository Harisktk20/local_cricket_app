// import 'package:cric_trax/const/app_colors.dart';
// import 'package:cric_trax/widget/custom_button.dart';
// import 'package:cric_trax/widget/custom_text.dart';
// import 'package:cric_trax/widget/custom_textfield.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CreateTournmentScreen extends StatelessWidget {
//   const CreateTournmentScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Create Tournment',
//           fontSize: 16,
//           color: AppColors.kWhiteColor,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               CupertinoButton(
//                 onPressed: () {},
//                 padding: EdgeInsets.zero,
//                 child: Container(
//                     height: 200,
//                     decoration: BoxDecoration(
//                         color: AppColors.kTextFieldColor,
//                         border: Border.all(color: AppColors.kGreyColor),
//                         borderRadius: BorderRadius.circular(12)),
//                     width: double.infinity,
//                     child: Center(
//                       child: CustomText(
//                         text: 'Add Image',
//                       ),
//                     )),
//               ),
//               SizedBox(height: 20),
//               CustomTextField(hinText: 'Tournament Name'),
//               CustomTextField(hinText: 'City'),
//               CustomTextField(hinText: 'Country'),
//               CustomTextField(hinText: 'Starting Date'),
//               CustomTextField(hinText: 'Youtube Channle Link'),
//               SizedBox(
//                 height: 20,
//               ),
//               CustomButton(onTapp: () {}, text: 'Create'),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, duplicate_ignore, library_private_types_in_public_api

import 'dart:io';

import 'package:cric_trax/widget/custom_loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cric_trax/const/app_colors.dart';
import 'package:cric_trax/widget/custom_button.dart';
import 'package:cric_trax/widget/custom_text.dart';
import 'package:cric_trax/widget/custom_textfield.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  _CreateTournamentScreenState createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _youtubeLinkController = TextEditingController();

  File? _image;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _pickImage(ImageSource source) async {
    XFile? pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  bool _isValidYouTubeLink(String url) {
    final RegExp youtubeRegex = RegExp(
      r'^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$',
    );
    return youtubeRegex.hasMatch(url);
  }

  Future<void> _createTournament() async {
    if (_formKey.currentState!.validate() && _image != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        String imageUrl = await uploadImage(_image!);
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Retrieve user details
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        String userName = userDoc['name'];
        String userProfileImage = userDoc['image'];

        String tournamentId = FirebaseFirestore.instance.collection('tournaments').doc().id;

        await FirebaseFirestore.instance.collection('tournaments').doc(tournamentId).set({
          'tournamentId': tournamentId,
          'name': _nameController.text,
          'city': _cityController.text,
          'country': _countryController.text,
          'startDate': _startDateController.text,
          'youtubeLink': _youtubeLinkController.text,
          'imageUrl': imageUrl,
          'userId': userId,
          'userName': userName,
          'userProfileImage': userProfileImage,
          'createdAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tournament created successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating tournament: $e')),
        );
      }
    } else {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add an image')),
        );
      }
    }
  }

  Future<String> uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('tournament_images').child(fileName);
    UploadTask uploadTask = storageRef.putFile(image);
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
            text: 'Create Tournament',
            fontSize: 16,
            color: AppColors.kWhiteColor,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CupertinoButton(
                        onPressed: () => _showImageSourceDialog(),
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.kTextFieldColor,
                            border: Border.all(color: AppColors.kGreyColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: double.infinity,
                          child: _image != null
                              ? Image.file(_image!, fit: BoxFit.cover)
                              : const Center(
                                  child: CustomText(
                                    text: 'Add Image',
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hinText: 'Tournament Name',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the tournament name';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hinText: 'City',
                        controller: _cityController,
                        validator: (value) {
                          // ignore: unnecessary_null_comparison
                          if (value == null || value.isEmpty) {
                            return 'Please enter the city';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hinText: 'Country',
                        controller: _countryController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the country';
                          }
                          return null;
                        },
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            hinText: 'Starting Date',
                            controller: _startDateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select the starting date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      CustomTextField(
                        hinText: 'YouTube Channel Link',
                        controller: _youtubeLinkController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the YouTube link';
                          } else if (!_isValidYouTubeLink(value)) {
                            return 'Please enter a valid YouTube link';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(onTapp: _createTournament, text: 'Create'),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            // if (_isLoading)
            //   const Center(
            //     child: CircularProgressIndicator(),
            //   ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Image Source'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
