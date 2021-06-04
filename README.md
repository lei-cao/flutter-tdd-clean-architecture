# flutter_tdd_clean_architecture

Homework of Flutter TDD Clean Architecture Course


## Notes

1. [Part 1](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

- [dependency inversion](https://en.wikipedia.org/wiki/Dependency_inversion_principle): That's just a fancy way of saying that we create an abstract Repository class defining a contract of what the Repository must do - this goes into the domain layer. We then depend on the Repository "contract" defined in domain, knowing that the actual implementation of the Repository in the data layer will fullfill this contract.
Dependency inversion principle is the last of the SOLID principles. It basically states that the boundaries between layers should be handled with interfaces (abstract classes in Dart).


2. [Part 3](https://resocoder.com/2019/09/02/flutter-tdd-clean-architecture-course-3-domain-layer-refactoring/)

- **call()** a method named call can be run both by calling object.call() but also by object()? That's the perfect method to use in the Use Cases! After all, their class names are already verbs like GetConcreteNumberTrivia, so using them as "fake methods" fits perfectly.

3. [Part 6](https://resocoder.com/2019/09/19/flutter-tdd-clean-architecture-course-6-repository-implementation/)

- [**Future**](https://stackoverflow.com/questions/18423691/dart-how-to-create-a-future-to-return-in-your-own-functions)
```
@override
Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    networkInfo.isConnected;
    var completer = new Completer<Either<Failure, NumberTrivia>>();

    ServerFailure serverFailure = ServerFailure();
    completer.complete(Left(serverFailure));

    return completer.future;
}
```

```
@override
Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    networkInfo.isConnected;
    return Left(ServerFailure());
}
```

4. [Part 7](https://resocoder.com/2019/09/23/flutter-tdd-clean-architecture-course-7-network-info/)

- testing passing result: using same reference `expect(result, tHasConnectionFuture);`
 
5. [Part 8](https://resocoder.com/2019/09/26/flutter-tdd-clean-architecture-course-8-local-data-source/)

- use `any()` in mocktail instead of `any`

6. [Part 9](https://resocoder.com/2019/10/03/flutter-tdd-clean-architecture-course-9-remote-data-source/)

- Mocking http/Uri [registerFallbackValue](https://github.com/felangel/mocktail/issues/44
)