import 'package:ezy_di/ezy_di.dart';
import 'package:test/test.dart';

void main() {
  final injector = Injector();
  group('Injector Test', () {
    test('Bird', () {
      Bird bird = injector.get<Bird>();
      expect(bird.fly.start(), 'flying');
    });

    test('Dog', () {
      Dog dog = injector.get<Dog>();
      expect(dog.walk.start(), 'walking');
    });

    test('Fish', () {
      Fish fish = injector.get<Fish>();
      expect(fish.swim.start(), 'swimming');
    });
    test('Duck', () {
      Duck duck = injector.get<Duck>();
      expect(duck.swim.start(), 'swimming');
      expect(duck.fly?.start(), 'flying');
      expect(duck.walk.start(), 'walking');
    });

    test('Animal', () {
      Animal animal = injector.get<Animal>();
      expect(animal.fish.swim.start(), 'swimming');
      expect(animal.bird.fly.start(), 'flying');
      expect(animal.dog.walk.start(), 'walking');
      expect(animal.duck.walk.start(), 'walking');
      expect(animal.duck.fly?.start(), 'flying');
      expect(animal.duck.swim.start(), 'swimming');

      // checking singleton work
      expect(animal.dog.walk, animal.duck.walk);
      expect(animal.fish.swim, animal.duck.swim);
      expect(animal.bird.fly != animal.duck.fly, true);
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
