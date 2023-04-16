## Dependency Injection

```dart
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

class Swim {
  start() {
    return "swimming";
  }
}

@Singleton()
class Walk {

  const Walk() {
    print('this class will create only once and share with other classes').
  }

  start() {
    return "walking";
  }
}

void main() {
    final injector = Injector();
    Animal animal = injector.get<Animal>();
    animal.bird.fly.start() // flying
    animal.fish.swim.start() // swimming
}

```

### Support Singleton provider 

```dart
@Singleton()
class Walk {

  const Walk() {
    print('this class will create only once and share with other classes').
  }

  start() {
    return "walking";
  }
}
```

### Support both positional and named params

```dart
class Duck {
  final Swim swim;
  final Walk walk;
  final Fly? fly;
  Duck(this.swim, {required this.walk, this.fly});
}

```

