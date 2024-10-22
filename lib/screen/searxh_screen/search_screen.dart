// import 'package:flutter/material.dart';
//
//
// class SearchScreen extends StatefulWidget {
//   final String searchField;
//   const SearchScreen({super.key, required this.searchField});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
// ignore_for_file: unused_import, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/app_colors.dart';
import '../home_screen/home_screen_widget/team_match_card.dart';

class SearchScreen extends StatelessWidget {
  final String searchField;

  const SearchScreen({super.key, required this.searchField});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Search Events',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              StreamBuilder(
                stream: searchEvent(searchField),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: kToolbarHeight),
                          Text(
                            'No Search Found For $searchField',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: kToolbarHeight / 2),
                          const SizedBox(height: kToolbarHeight),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    Text(
                      'some Thing Went Wrong',
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var data = snapshot.data!.docs;
                  var filteredData = data
                      .where((element) =>
                          element['tournament'].toString().toLowerCase().contains(searchField.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var fixture = filteredData[index];
                      return TeamMatchCards(
                        teamA: fixture['teamAName'],
                        teamB: fixture['teamBName'],
                        date: fixture['date'],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  searchEvent(title) {
    return FirebaseFirestore.instance.collection('fixtures').snapshots();
  }
}
