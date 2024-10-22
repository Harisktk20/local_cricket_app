// import 'package:flutter/material.dart';
//
// import '../../const/app_colors.dart';
// import '../../widget/custom_button.dart';
// import '../../widget/custom_text.dart';
// import '../../widget/custom_textfield.dart';
//
// class CreateFixtureScreen extends StatelessWidget {
//   const CreateFixtureScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppColors.kWhiteColor),
//         backgroundColor: AppColors.kPrimaryColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Create Fixture',
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
//               const Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height: 120,
//                       width: double.infinity,
//                       child: Card(
//                         color: AppColors.kTextFieldColor,
//                         child: Center(child: Text('Team A')),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: SizedBox(
//                       height: 120,
//                       width: double.infinity,
//                       child: Card(
//                         color: AppColors.kTextFieldColor,
//                         child: Center(child: Text('Team B')),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               CustomTextField(hinText: 'Date'),
//               CustomTextField(hinText: 'Time'),
//               CustomTextField(hinText: 'Tournament'),
//               const SizedBox(
//                 height: 20,
//               ),
//               CustomButton(onTapp: () {}, text: 'Create'),
//               const SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:cric_trax/widget/custom_loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../const/app_colors.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_textfield.dart';

class CreateFixtureScreen extends StatefulWidget {
  const CreateFixtureScreen({super.key});

  @override
  _CreateFixtureScreenState createState() => _CreateFixtureScreenState();
}

class _CreateFixtureScreenState extends State<CreateFixtureScreen> {
  final TextEditingController _teamANameController = TextEditingController();
  final TextEditingController _teamBNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _tournamentController = TextEditingController();
  File? _teamAImage;
  File? _teamBImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

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
            text: 'Create Fixture',
            fontSize: 16,
            color: AppColors.kWhiteColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showImagePicker('teamA'),
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            color: AppColors.kTextFieldColor,
                            child: Center(
                              child: _teamAImage == null
                                  ? const Text('Team A Image')
                                  : Image.file(_teamAImage!, fit: BoxFit.cover,height: 120,width: double.infinity,),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showImagePicker('teamB'),
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            color: AppColors.kTextFieldColor,
                            child: Center(
                              child: _teamBImage == null
                                  ? const Text('Team B Image')
                                  : Image.file(_teamBImage!, fit: BoxFit.cover,height: 120,width: double.infinity,),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextField(controller: _teamANameController, hinText: 'Team A Name'),
                CustomTextField(controller: _teamBNameController, hinText: 'Team B Name'),
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: CustomTextField(controller: _dateController, hinText: 'Date'),
                  ),
                ),
                GestureDetector(
                  onTap: _pickTime,
                  child: AbsorbPointer(
                    child: CustomTextField(controller: _timeController, hinText: 'Time'),
                  ),
                ),
                CustomTextField(controller: _tournamentController, hinText: 'Tournament'),
                const SizedBox(height: 20),
                CustomButton(onTapp: _createFixture, text: 'Create'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePicker(String team) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Choose Image Source'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Take Photo'),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(team, ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Choose from Gallery'),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(team, ImageSource.gallery);
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

  void _pickImage(String team, ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        if (team == 'teamA') {
          _teamAImage = File(image.path);
        } else {
          _teamBImage = File(image.path);
        }
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _createFixture() async {
    if (_validateFields()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String teamAImageUrl = await _uploadImage(_teamAImage);
        String teamBImageUrl = await _uploadImage(_teamBImage);
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Retrieve user details
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        String userName = userDoc['name'];
        String userProfileImage = userDoc['image'];

        // Generate a fixture ID
        String fixtureId = FirebaseFirestore.instance.collection('fixtures').doc().id;

        await FirebaseFirestore.instance.collection('fixtures').doc(fixtureId).set({
          'fixtureId': fixtureId,
          'teamAName': _teamANameController.text,
          'teamBName': _teamBNameController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'tournament': _tournamentController.text,
          'teamAImage': teamAImageUrl,
          'teamBImage': teamBImageUrl,
          'userId': userId,
          'userName': userName,
          'userProfileImage': userProfileImage,
          'createdAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fixture created successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating fixture: $e')),
        );
      }
    }
  }

  Future<String> _uploadImage(File? image) async {
    if (image == null) return '';
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('fixtures').child(fileName);
    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  bool _validateFields() {
    if (_teamANameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Team A name')));
      return false;
    }
    if (_teamBNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Team B name')));
      return false;
    }
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter date')));
      return false;
    }
    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter time')));
      return false;
    }
    if (_tournamentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter tournament')));
      return false;
    }
    if (_teamAImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add image for Team A')));
      return false;
    }
    if (_teamBImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add image for Team B')));
      return false;
    }
    return true;
  }
}
