typedef E CopyConstructor<E>(E entity);
typedef E Updater<E>(E entity);
typedef void Validator<E>(E entity);

class ImmutableValuee<E> {
  final Validator<E> validator;
  final CopyConstructor<E> _copy;
  final E defaultValue;
  E _entity;

  E get value => _copy(_safeInstance()); // could even maybe use call()

  void set(Updater<E> updater) => _safeValidate(updater(_safeInstance()));

  void reset() => _entity = null;

  E _safeInstance() => _entity ?? defaultValue;

  E _safeValidate(E entityToValidate) {
    if (validator != null && entityToValidate != null) validator(entityToValidate);
    return entityToValidate;
  }

  ImmutableValuee(this._copy, [this.defaultValue, this.validator]) {
    _safeValidate(defaultValue);
  }

  @override
  String toString() => _safeInstance().toString();
}

abstract class ImmutableEntity<E extends ImmutableEntity<E,V>, V> {
  final V defaultValue;
  final V _value;

  V get value => copy(_safeInstance()); // could even maybe use call()

  E set(V nextValue) =>  build(validate(nextValue));

  E reset() => build(null);

  V _safeInstance() => _value ?? defaultValue;


  ImmutableEntity(this._value, [this.defaultValue]) {
    validate(defaultValue);
  }
  
  V copy(V current);
  V validate(V toValidate) => toValidate;
  E build(V value);

  @override
  String toString() => _safeInstance().toString();  
}