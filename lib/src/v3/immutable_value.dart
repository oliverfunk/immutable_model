typedef E CopyConstructor<E>(E entity);
typedef E Updater<E>(E entity);
typedef void Validator<E>(E entity);

class ImmutableEntity<E> {
  final Validator<E> validator;
  final CopyConstructor<E> _copy;
  final E defaultValue;
  E _entity;

  E get value => _copy(_safeInstance()); // could even maybe use call()

  void set(Updater<E> updater) => _safeValidate(updater(_safeInstance()));

  void reset() => _entity = null;

  E _safeInstance() => _entity ?? defaultValue;

  E _safeValidate(E entityToValidate) {
    if (validator != null) validator(entityToValidate);
    return entityToValidate;
  }

  ImmutableEntity(this._copy, [this.defaultValue, this.validator]) {
    _safeValidate(defaultValue);
  }

  @override
  String toString() => _safeInstance().toString();
}
