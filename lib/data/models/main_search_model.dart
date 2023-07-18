
import 'package:google_search/data/models/organic.dart';
import 'package:google_search/data/models/param_model.dart';

class MainSearchModdel {
  final SearchParametersModel searchParametersModel;
  final List<OrganicModel> organicModels;

  MainSearchModdel({
    required this.searchParametersModel,
    required this.organicModels,
  });

  factory MainSearchModdel.fromJson(Map<String, dynamic> json) {
    return MainSearchModdel(
      searchParametersModel: SearchParametersModel.fromJson(json["searchParameters"]),
      organicModels: (json["organic"] as List?)
              ?.map((e) => OrganicModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}