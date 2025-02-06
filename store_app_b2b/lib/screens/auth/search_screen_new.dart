import 'dart:convert';

import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_b2b/new_module/utils/widget/app_search_box_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.searchText,
  });

  final String searchText;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<String> predictions = [];

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _searchController.text = widget.searchText;
    if (widget.searchText.isNotEmpty) {
      _fetchPlaces(widget.searchText);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    super.initState();
  }

  void _fetchPlaces(String input) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyA9hGUqzqQpDf2bTFZEaVTb24JPW3xhz6w';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      logs("printing fetchplace data -> $data");
      setState(() {
        predictions = List<String>.from(
            data['predictions'].map((prediction) => prediction['description']));
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  void dispose() {
    // Dispose the FocusNode when it's no longer needed
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          content: 'Choose address on map',
          boldNess: FontWeight.w600,
          textSize: 16,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff2F394B),
                Color(0xff090F1A),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AppSearchBox(
              textEditingController: _searchController,
              hintText: 'Search for location',
              focusNode: _focusNode,
              showSuffixIcon: _searchController.text.isNotEmpty ? true : false,
              onSuffixIconTap: () {
                _searchController.clear();
                predictions.clear();
                setState(() {});
              },
              onChange: (value) {
                _fetchPlaces(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    title: AppText(
                      predictions[index],
                      color: Colors.black,
                    ),
                    onTap: () {
                      Get.back(result: predictions[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
