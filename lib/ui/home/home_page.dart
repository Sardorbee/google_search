import 'package:flutter/material.dart';
import 'package:google_search/data/models/main_search_model.dart';
import 'package:google_search/data/models/organic.dart';
import 'package:google_search/data/models/universaldata.dart';
import 'package:google_search/data/network/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController queryController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int pagee = 1;
  int pagecounte = 5;
  String queryText = "";
  bool isLoading = false;

  List<OrganicModel> organicModels = [];
  List<String> searchSuggestions = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory(); // Load search history when the widget is created
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _fetchResult();
      }
    });
  }

  _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      searchSuggestions = prefs.getStringList('searchHistory') ?? [];
    });
  }

  _saveSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!searchSuggestions.contains(queryText)) {
      searchSuggestions.insert(0, queryText);
      if (searchSuggestions.length > 5) {
        searchSuggestions.removeLast();
      }
      prefs.setStringList('searchHistory', searchSuggestions);
    }
  }

  _fetchResult() async {
    setState(() {
      isLoading = true;
    });

    pagee++;
    UniversalData universalData = await ApiProvider.searchFromGoogle(
      query: queryText,
      page: pagee,
      count: pagecounte,
    );

    setState(() {
      isLoading = false;
    });

    if (universalData.error.isEmpty) {
      MainSearchModdel mainnn = universalData.data as MainSearchModdel;
      organicModels.addAll(mainnn.organicModels);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/g.png', // Replace this with your Google logo image path
          height: 36,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) {
                setState(() {
                  queryText = v;
                });
              },
              onSubmitted: (v) {
                setState(() {
                  organicModels.clear();
                  pagee = 1;
                });
                _saveSearchHistory();
                _fetchResult();
              },
              controller: queryController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: "Search Google",
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.grey[200],
                suffixIcon: queryText.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            queryText = "";
                            organicModels = [];
                          });
                          queryController.clear();
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
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: organicModels.length + 1,
              itemBuilder: (context, index) {
                if (index < organicModels.length) {
                  OrganicModel organicModel = organicModels[index];
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
                } else if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (organicModels.isEmpty) {
                  return Column(
                    children: [
                      for (String suggestion in searchSuggestions)
                        ListTile(
                          onTap: () {
                            setState(() {
                              queryText = suggestion;
                            });
                            queryController.text = suggestion;
                            organicModels.clear();
                            pagee = 1;
                            _fetchResult();
                          },
                          title: Text(suggestion),
                          leading: const Icon(Icons.search),
                        ),
                      // if (searchSuggestions.isNotEmpty)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            organicModels.clear();
                            pagee = 1;
                          });
                          _saveSearchHistory();
                          _fetchResult();
                        },
                        child: const Text("Search"),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
