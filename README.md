# flutter_tdd_clean_architecture

Homework of Flutter TDD Clean Architecture Course


## Notes

1. [Part 1](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

- [dependency inversion](https://en.wikipedia.org/wiki/Dependency_inversion_principle): That's just a fancy way of saying that we create an abstract Repository class defining a contract of what the Repository must do - this goes into the domain layer. We then depend on the Repository "contract" defined in domain, knowing that the actual implementation of the Repository in the data layer will fullfill this contract.
Dependency inversion principle is the last of the SOLID principles. It basically states that the boundaries between layers should be handled with interfaces (abstract classes in Dart).


