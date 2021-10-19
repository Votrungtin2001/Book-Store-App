import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
class SearchBar extends StatefulWidget {

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  static const historyLength = 5;

  List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];

  // List<String> filteredSearchHistory;
  // String selectedTerm;

  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    // filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
   // filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  @override
  void initState() {
    super.initState();
    // controller = FloatingSearchBarController();
   // filteredSearchHistory = filterSearchTerms(filter: null);

  }
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
          // child:  Card(
          //   child: ListTile(
          //     leading:  Icon(Icons.search),
              child:  TextFormField(
               // controller: controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                color: Colors.black)
                        ),
                        filled: true,
                        hintText: "Search your book..",
                        hintStyle: const TextStyle(color: Colors.black38),
                        prefixIcon: const Icon(Icons.search, color: Colors.black,)
                ),
                // onChanged: onSearchTextChanged,
              ),
             // trailing:  IconButton(icon: new Icon(Icons.cancel), onPressed: () {
             //  //  controller.clear();
             //    // onSearchTextChanged('');
             //  },
              ),
            ),
          Expanded(
            child: _searchHistory.length != 0 || controller.text.isNotEmpty
                ? ListView.builder(
              itemCount: _searchHistory.length,
              itemBuilder: (context, i) {
                return  Card(
                  child:  ListTile(
                    leading:  CircleAvatar(backgroundImage:  NetworkImage(_searchHistory[i]),),
                    title:  Text(_searchHistory[i] + ' ' + _searchHistory[i]),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            )
                : ListView.builder(
              itemCount: _searchHistory.length,
              itemBuilder: (context, index) {
                return  Card(
                  child:  ListTile(
                    leading:  CircleAvatar(backgroundImage:  NetworkImage(_searchHistory[index],),),
                    title:  Text(_searchHistory[index] + ' ' + _searchHistory[index]),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

