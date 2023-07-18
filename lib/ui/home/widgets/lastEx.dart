import 'package:flutter/material.dart';
import 'package:google_search/data/models/organic.dart';

// ignore: must_be_immutable
class LastEx extends StatefulWidget {
  var scrollController;

  var organicModels;

  bool isLoading;
  final VoidCallback fetchresult;
  final VoidCallback saveSearchHistory;

  var searchSuggestions;
  TextEditingController queryController;
  String queryText;

  int pagee;

  LastEx(
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
  State<LastEx> createState() => _LastExState();
}

class _LastExState extends State<LastEx> {
  @override
  Expanded build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: widget.organicModels.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.organicModels.length) {
            OrganicModel organicModel = widget.organicModels[index];
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    organicModel.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    organicModel.snippet,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    organicModel.link,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    organicModel.date,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          } else if (widget.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (widget.organicModels.isEmpty) {
            return Column(
              children: [
                for (String suggestion in widget.searchSuggestions)
                  ListTile(
                    onTap: () {
                      setState(() {
                        widget.queryText = suggestion;
                      });

                      widget.queryController.text = suggestion;
                      widget.organicModels.clear();
                      widget.pagee = 1;
                      widget.fetchresult();
                    },
                    title: Text(suggestion),
                    leading: const Icon(Icons.search),
                  ),
                // if (searchSuggestions.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.organicModels.clear();
                      widget.pagee = 1;
                    });
                    widget.saveSearchHistory();
                    widget.fetchresult();
                  },
                  child: const Text("Search"),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
