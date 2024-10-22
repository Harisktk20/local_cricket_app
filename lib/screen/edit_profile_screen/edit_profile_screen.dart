// import 'package:cric_trax/const/app_colors.dart';
// import 'package:cric_trax/widget/custom_button.dart';
// import 'package:flutter/material.dart';
//
// import '../../widget/custom_textfield.dart';
//
// class EditProfileScreen extends StatelessWidget {
//   const EditProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//               child: Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: AssetImage('assets/images/afridi.png'),
//               ),
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 35,
//                     backgroundImage: AssetImage('assets/images/profile_pic.png'),
//                   ),
//                   TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         'Change Profile Photo',
//                         style: TextStyle(color: AppColors.kWhiteColor, fontWeight: FontWeight.bold),
//                       ))
//                 ],
//               ),
//             ),
//           )),
//           Expanded(
//               child: Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   SizedBox(height: 20),
//                   CustomTextField(
//                     hinText: 'First Name',
//                   ),
//                   CustomTextField(
//                     hinText: 'Last Name',
//                   ),
//                   CustomTextField(
//                     hinText: 'Bio',
//                   ),
//                   SizedBox(height: 20),
//                   CustomButton(onTapp: () {}, text: 'Update'),
//                 ],
//               ),
//             ),
//           )),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors_in_immutables, sized_box_for_whitespace, prefer_final_fields

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../const/app_colors.dart';
import '../../../const/firebase_const.dart';
import '../../../services/image_upload.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_loaders.dart';
import '../../widget/custom_text.dart';
import '../../widget/pick_images_box.dart';

class EditProfileScreen extends StatefulWidget {
  final String? image;
  final String name;

  EditProfileScreen({super.key, required this.image, required this.name});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // nameController.text = widget.name;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: AppColors.kPrimaryColor,
          title: const CustomText(
            text: 'Edit Profile',
            fontSize: 16,
            color: AppColors.kWhiteColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/afridi.png'),
                        ),
                      ),
                    ),
                    // widget.image == ''
                    //     ? const Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child: CircleAvatar(
                    //           radius: 40,
                    //           backgroundImage: AssetImage('asset/images/p2.jpeg'),
                    //         ),
                    //       )
                    //     : Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(100),
                    //           child: CachedNetworkImage(
                    //             fit: BoxFit.cover,
                    //             width: 45,
                    //             height: 45,
                    //             imageUrl: widget.image.toString(),
                    //             placeholder: (context, url) => Container(
                    //               width: 10,
                    //               height: 10,
                    //
                    //               color: AppColors.kPrimary.withOpacity(0.2), // Placeholder background color
                    //               child: Center(
                    //                 child: CircularProgressIndicator(
                    //                   color: AppColors.kSecondary,
                    //                   // Loader color
                    //                 ),
                    //               ),
                    //             ),
                    //             errorWidget: (context, url, error) => const Icon(Icons.downloading),
                    //           ),
                    //         ),
                    //       ),

                    if (file == null)
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: widget.image == ''
                              ? Container(
                                  //alignment: Alignment.bottomCenter,
                                  height: 80,
                                  width: 80,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('asset/images/p2.jpeg'),
                                      ),
                                      shape: BoxShape.circle,
                                      color: AppColors.kPrimaryColor),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            enableDrag: true,
                                            context: context,
                                            builder: (context) {
                                              return PickImagesBox(
                                                onCamera: () {
                                                  pickImage(ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                                onGallery: () {
                                                  pickImage(ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                              );
                                            });
                                      },
                                      child: Container(
                                        decoration:
                                            const BoxDecoration(color: AppColors.kPrimaryColor, shape: BoxShape.circle),
                                        child: const Icon(
                                          CupertinoIcons.add_circled_solid,
                                          size: 30,
                                          color: AppColors.kBgColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  //alignment: Alignment.bottomCenter,
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(widget.image.toString()),
                                      ),
                                      shape: BoxShape.circle,
                                      color: AppColors.kGreyColor),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            enableDrag: true,
                                            context: context,
                                            builder: (context) {
                                              return PickImagesBox(
                                                onCamera: () {
                                                  pickImage(ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                                onGallery: () {
                                                  pickImage(ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                              );
                                            });
                                      },
                                      child: Container(
                                        decoration:
                                            const BoxDecoration(color: AppColors.kPrimaryColor, shape: BoxShape.circle),
                                        child: const Icon(
                                          CupertinoIcons.add_circled_solid,
                                          size: 30,
                                          color: AppColors.kBgColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                    else
                      Center(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                enableDrag: true,
                                context: context,
                                builder: (context) {
                                  return PickImagesBox(
                                    onCamera: () {
                                      pickImage(ImageSource.camera);
                                      Get.back();
                                    },
                                    onGallery: () {
                                      pickImage(ImageSource.gallery);
                                      Get.back();
                                    },
                                  );
                                });
                          },
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.file(
                                file!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: AppColors.kBlackColor),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.kGreyColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.kGreyColor),
                    ),
                    hintText: 'Name',
                    hintStyle: const TextStyle(
                      color: AppColors.kPrimaryColor,
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomButton(
                  text: 'Save',
                  onTapp: () {
                    updateUser(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
  }

  ImagePicker _picker = ImagePicker();

  File? file;
  bool isLoading = false;

  makeLoadingTrue() {
    setState(() {
      isLoading = true;
    });
  }

  makeLoadingFalse() {
    setState(() {
      isLoading = false;
    });
  }

  pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile!.path != "") {
      file = File(pickedFile.path);
      print(file);
      setState(() {});

      ///upload
    } else {
      ///error
    }
  }

  updateUser(BuildContext context) async {
    makeLoadingTrue();
    String imageURL = '';
    if (file != null) {
      imageURL = await ImageUpload().uploadImage(context, file: file!, folderName: 'user');
    }
    FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).set({
      "name": nameController.text.toString(),
      "image": imageURL != "" ? imageURL : widget.image.toString(),
    }, SetOptions(merge: true)).then((value) {
      makeLoadingFalse();
      Navigator.pop(context);
      Get.snackbar('Success', 'Profile Updated');
    }).onError((error, stackTrace) {
      makeLoadingFalse();
    });
  }
}
