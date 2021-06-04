import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/core/error/exception.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockUri extends Mock implements Uri {}

void main() {
  MockHttpClient mockHttpClient = MockHttpClient();
  NumberTriviaRemoteDataSourceImpl datasource =
      NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

  setUpAll(() {
    // https://github.com/felangel/mocktail/issues/44
    registerFallbackValue(Uri());
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
          (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        datasource.getConcreteNumberTrivia(tNumber);
        // assert
        String url = 'http://numbersapi.com/$tNumber';
        Uri _uri = Uri.parse(url);

        verify(
          () => mockHttpClient.get(
            _uri,
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await datasource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = datasource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should preform a GET request on a URL with *random* endpoint with application/json header',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        datasource.getRandomNumberTrivia();
        // assert
        String url = 'http://numbersapi.com/random';
        Uri _uri = Uri.parse(url);

        verify(
              () => mockHttpClient.get(
            _uri,
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await datasource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = datasource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
