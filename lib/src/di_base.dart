part of ezy_di;

class Injector {
  Map<String, dynamic> instances = {};

  get<T>() {
    return _getClass(T);
  }

  _isSingleton(ClassMirror mirror) {
    List<InstanceMirror> metadata =
        mirror.metadata.where((InstanceMirror metadata) {
      return metadata.type.reflectedType == Singleton;
    }).toList();
    return metadata.isNotEmpty;
  }

  _getName(instance) {
    return instance.toString();
  }

  _getClass(instance) {
    ClassMirror classMirror = reflectClass(instance);
    String name = _getName(instance);

    // if instance already created and instance is a singleton provider,
    // return existing instance
    if (instances[name] != null && _isSingleton(classMirror) == true) {
      return instances[name];
    }

    // create new class and store in instances for singleton used.
    var i = _createNewClass(instance);
    if (instances[name] == null) {
      instances[name] = i;
    }
    return i;
  }

  _createNewClass(instance) {
    ClassMirror classMirror = reflectClass(instance);
    var d = _getDependencies(instance);
    return classMirror
        .newInstance(Symbol.empty, d['positional'], d['named'])
        .reflectee;
  }

  _getDependencies(instance) {
    List<dynamic> positionalParams = [];
    Map<Symbol, dynamic> namedParams = {};

    ClassMirror classMirror = reflectClass(instance);
    // get main class
    MethodMirror constructorMirror = classMirror.declarations.values
        .whereType<MethodMirror>()
        .firstWhere((m) => m.isConstructor);

    // get dependency class list
    List<ParameterMirror> parameters = constructorMirror.parameters.toList();

    for (ParameterMirror param in parameters) {
      if (param.isNamed) {
        // if param is with name
        namedParams[param.simpleName] = _getClass(param.type.reflectedType);
      } else {
        // if param is positional
        positionalParams.add(_getClass(param.type.reflectedType));
      }
    }
    return {
      "positional": positionalParams,
      "named": namedParams,
    };
  }
}
