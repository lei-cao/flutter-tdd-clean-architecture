import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failures.dart';
import 'package:flutter_tdd_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usercases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usercases/get_random_number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class FakeParams extends Fake implements Params {}
class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

  setUpAll(() {
    registerFallbackValue(FakeParams());
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group(
    'GetTriviaForConcreteNumber',
    () {
      // The event takes in a String
      final tNumberString = '1';
      // This is the successful output of the InputConverter
      final tNumberParsed = int.parse(tNumberString);
      // NumberTrivia instance is needed too, of course

      void setUpMockInputConverterSuccess() =>
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(() => mockGetConcreteNumberTrivia(any()))
              .thenAnswer((_) async => Right(tNumberTrivia));
          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(
              () => mockInputConverter.stringToUnsignedInteger(any()));
          // assert
          verify(
              () => mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );

      test(
        // https://stackoverflow.com/questions/63562053/testing-my-bloc-fails-when-using-yield-and-either-in-the-mapeventtostate
        // https://github.com/felangel/bloc/issues/636
        'should emit [Error] when the input is invalid',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Left(InvalidInputFailure()));
          // assert later
          final expected = [
            // The initial state is always emitted first
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );

      test(
        'should get data from the concrete use case',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(() => mockGetConcreteNumberTrivia(any()))
              .thenAnswer((_) async => Right(tNumberTrivia));
          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(() => mockGetConcreteNumberTrivia(any()));
          // assert
          verify(
              () => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfully',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(() => mockGetConcreteNumberTrivia(any()))
              .thenAnswer((_) async => Right(tNumberTrivia));
          // assert later
          final expected = [
            Loading(),
            Loaded(trivia: tNumberTrivia),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );

      test(
        'should emit [Loading, Error] when getting data fails',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(() => mockGetConcreteNumberTrivia(any()))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );

      test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(() => mockGetConcreteNumberTrivia(any()))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
      );
    },
  );

  group(
    'GetTriviaRandomNumber',
    () {
      test(
        'should get data from the random use case',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(any()))
              .thenAnswer((_) async => Right(tNumberTrivia));
          // act
          bloc.add(GetTriviaForRandomNumber());
          await untilCalled(() => mockGetRandomNumberTrivia(any()));
          // assert
          verify(() => mockGetRandomNumberTrivia(NoParams()));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfully',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(any()))
              .thenAnswer((_) async => Right(tNumberTrivia));
          // assert later
          final expected = [
            Loading(),
            Loaded(trivia: tNumberTrivia),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForRandomNumber());
        },
      );

      test(
        'should emit [Loading, Error] when getting data fails',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(any()))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForRandomNumber());
        },
      );

      test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia(any()))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForRandomNumber());
        },
      );
    },
  );
}
