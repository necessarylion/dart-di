import 'dart:mirrors';

class Injector {
  static final Injector _singleton = Injector._internal();

  Map<String, dynamic> instances = {};

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  get<T>() {
    return _setNewClass(T);
  }

  _createNewClass(instance) {
    var classMirror = reflectClass(instance);
    var d = _getDependencies(instance);
    return classMirror
        .newInstance(Symbol.empty, d['position'], d['name'])
        .reflectee;
  }

  _getDependencies(instance) {
    var classMirror = reflectClass(instance);

    var constructorMirror = classMirror.declarations.values
        .whereType<MethodMirror>()
        .firstWhere((m) => m.isConstructor);

    var parameters = constructorMirror.parameters.toList();

    var positionalParams = <dynamic>[];
    var namedParams = <Symbol, dynamic>{};

    for (ParameterMirror param in parameters) {
      if (param.isNamed) {
        namedParams[param.simpleName] = _setNewClass(param.type.reflectedType);
      } else {
        positionalParams.add(_setNewClass(param.type.reflectedType));
      }
    }
    return {
      "position": positionalParams,
      "name": namedParams,
    };
  }

  _setNewClass(instance) {
    var classMirror = reflectClass(instance);

    List<InstanceMirror> metadata = classMirror.metadata
        .where((InstanceMirror metadata) =>
            metadata.type.reflectedType == Singleton)
        .toList();

    bool isSingleton = metadata.isNotEmpty;

    String name = instance.toString();
    if (instances[name] != null && isSingleton == true) {
      return instances[name];
    }

    var i = _createNewClass(instance);
    if (instances[name] == null) {
      instances[name] = i;
    }
    return i;
  }
}

class Singleton {
  const Singleton();
}

class Transient {
  const Transient();
}
