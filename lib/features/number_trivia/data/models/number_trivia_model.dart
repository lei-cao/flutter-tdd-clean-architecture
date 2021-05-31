import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    required String text,
    required int number,
  }) : super(
          text: text,
          number: number,
        );

  @override
  List<Object> get props => [text, number];

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
        text: json['text'], number: (json['number'] as num).toInt());
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'number': number};
  }
}
