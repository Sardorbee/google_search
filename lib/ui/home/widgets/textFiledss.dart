import 'package:flutter/material.dart';

class Textfields extends StatefulWidget {
  var scrollController;

  var organicModels;

  bool isLoading;
  final VoidCallback fetchresult;
  final VoidCallback saveSearchHistory;

  var searchSuggestions;
  TextEditingController queryController;
  String queryText;

  int pagee;

  Textfields(
      {super.key,
      required this.fetchresult,
      required this.saveSearchHistory,
      required this.scrollController,
      required this.organicModels,
      required this.isLoading,
      required this.pagee,
      required this.queryController,
      required this.queryText,
      required this.searchSuggestions});

  @override
  State<Textfields> createState() => _TextfieldsState();
}

class _TextfieldsState extends State<Textfields> {
  @override
  Padding build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (v) {
          setState(() {
            widget.queryText = v;
          });
        },
        onSubmitted: (v) {
          setState(() {
            widget.organicModels.clear();
            widget.pagee = 1;
          });
          widget.saveSearchHistory();
          widget.fetchresult();
        },
        controller: widget.queryController,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          hintText: "Search Google",
          prefixIcon: const Icon(Icons.search),
          fillColor: Colors.grey[200],
          suffixIcon: widget.queryText.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      widget.queryText = "";
                      widget.organicModels = [];
                    });
                    widget.queryController.clear();
                  },
                ),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
