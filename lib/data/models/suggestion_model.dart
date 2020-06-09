import 'package:meta/meta.dart';

enum SuggestionType {
  museum,
  store,
}

SuggestionType _convertStringToType(String s) {
  switch (s) {
    case 'museum':
      return SuggestionType.museum;
      break;
    case 'store':
      return SuggestionType.store;
      break;
    default:
      return null;
  }
}

enum SuggestionCapacity {
  low,
  medium,
  high,
  full,
}

SuggestionCapacity _convertStringToCapacity(String s) {
  switch (s) {
    case 'low':
      return SuggestionCapacity.low;
      break;
    case 'medium':
      return SuggestionCapacity.medium;
      break;
    case 'high':
      return SuggestionCapacity.high;
      break;
    case 'full':
      return SuggestionCapacity.full;
      break;
    default:
      return null;
  }
}

class SuggestionModel {
  final String title;
  final SuggestionType type;
  final SuggestionCapacity capacity;

  const SuggestionModel(
      {@required this.title, @required this.type, @required this.capacity});

  factory SuggestionModel.fromJSON(Map<String, dynamic> json) {
    return SuggestionModel(
      title: json['title'],
      type: _convertStringToType(json['type']),
      capacity: _convertStringToCapacity(json['capacity']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'type': type,
      'capacity': capacity,
    };
  }
}
