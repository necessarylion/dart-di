import 'package:ezy_di/ezy_di.dart';
import 'package:test/test.dart';

void main() {
  group('Injector Test', () {
    test('Bird', () {
      final injector = Injector();
      Bird bird = injector.get<Bird>();
      expect(bird.fly.start(), 'flying');
    });

    test('Dog', () {
      final injector = Injector();
      Dog dog = injector.get<Dog>();
      expect(dog.walk.start(), 'walking');
    });

    test('Fish', () {
      final injector = Injector();
      Fish fish = injector.get<Fish>();
      expect(fish.swim.start(), 'swimming');
    });
    test('Duck', () {
      final injector = Injector();
      Duck duck = injector.get<Duck>();
      expect(duck.swim.start(), 'swimming');
      expect(duck.fly?.start(), 'flying');
      expect(duck.walk.start(), 'walking');
    });

    test('Animal', () {
      final injector = Injector();
      Animal animal = injector.get<Animal>();
      expect(animal.fish.swim.start(), 'swimming');
      expect(animal.bird.fly.start(), 'flying');
      expect(animal.dog.walk.start(), 'walking');
      expect(animal.duck.walk.start(), 'walking');
      expect(animal.duck.fly?.start(), 'flying');
      expect(animal.duck.swim.start(), 'swimming');

      Animal animal2 = Animal(
        Dog(Walk()),
        Fish(Swim()),
        Bird(Fly()),
        Duck(Swim(), walk: Walk(), fly: Fly()),
      );

      expect(animal.toString(), animal2.toString());
    });
  });
}

class Animal {
  final Dog dog;
  final Fish fish;
  final Bird bird;
  final Duck duck;

  const Animal(this.dog, this.fish, this.bird, this.duck);
}

class Bird {
  final Fly fly;
  Bird(this.fly);
}

class Dog {
  final Walk walk;
  Dog(this.walk);
}

class Duck {
  final Swim swim;
  final Walk walk;
  final Fly? fly;
  Duck(this.swim, {required this.walk, this.fly});
}

class Fish {
  final Swim swim;
  Fish(this.swim);
}

@Singleton()
class Fly {
  start() {
    return "flying";
  }
}

@Singleton()
class Swim {
  start() {
    return "swimming";
  }
}

@Singleton()
class Walk {
  start() {
    return "walking";
  }
}
