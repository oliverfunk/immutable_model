# immutable_model

[![Build Status](https://travis-ci.org/oliverfunk/immutable_model.svg?branch=master)](https://travis-ci.org/oliverfunk/immutable_model)
[![pub package](https://img.shields.io/pub/v/immutable_model.svg)](https://pub.dev/packages/immutable_model)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)

This package lets you define valid, immutable state models in a succinct way (with no code generation) that are interoperable between commonly used state management systems and that support serialization to and from JSON out of the box.

Fully implemented examples using this package with the **BLoC** (and Cubits) and **Redux** frameworks can found in the [example](https://github.com/oliverfunk/immutable_model/tree/master/example) folder.

This package supports int's, double's, bool's, String's, DateTime's, lists, enums and maps, each having their own `ModelType` representation (e.g. `ModelInt`, `ModelString`, `ModelList<T>`, `ModelEnum<E>` etc.).

Maps are represented with the `ModelInner` class which defines a map between field label Strings and other `ModelType` models. A `ModelInner` is generally used for hierarchical nesting in a `ImmutableModel` (hence "inner").

Every `ModelType` can be passed a `validator` which is run when it is updated. If the update is invalid, the instance is returned without the update applied.

This package provides some commonly used `ValueType` classes too (and a way to declare your own). A `ValueType` is defined as a `ModelType` that wraps it's own `validator`. Currently only `ModelEmail` and `ModelPassword` for email and password Strings are provided, but more can be added.

Under the hood, the immutable list and map data structures are built using [built_collection](https://pub.dev/packages/built_collection).

All `ModelType`'s extend [Equatable](https://pub.dev/packages/equatable) for value equality based on the model's current value.

Finally, this package provides the main `ImmutableModel<S>` class used to define state models. See the examples below.

## Overview

The main goal behind this package was to provide a way to write a _provably_ safe domain layer, which is achieved in two ways:

**First**, state models defined using `ImmutableModel` can never be in an invalid state (hold invalid data), if they are written correctly. This applies to all `ModelType`'s too.

If an attempt is made to update a state model with invalid data, the instance will be returned without the update applied. When an invalid update occurs an exception is logged instead of being throw, in keeping with the idea of never being in an invalid state. These logs can be accessed dynamically using the dart [logging](https://pub.dev/packages/logging) package.

**Second**, domain level logic or functions can use or be parameterized with the valid types from this library. The data these valid types hold _must_ be valid or the instance cannot exist.

For example, a simple authentication state model could be written as follows:

```dart
final authStateModel = ImmutableModel(
  {
    "email": M.email(defaultEmail: 'example@gmail.com'),
    "password": M.password(),
  },
);
```

(note: `M.email` and `M.password` are shorthands for the `ModelEmail` and `ModelPassword` classes)

A domain level `signIn` function could then be defined as:

```dart
signIn(ModelEmail email, ModelPassword password) {
  if(authUser(email.asSerializable(), password.asSerializable())){
    authStateModel.update({
      "email": email,
      "password": password
    });
  }
}
```

Where `authUser` is a data layer function, with the following signature:

```dart
bool authUser(String email, String password)
```

By parameterizing the `signIn` function with the `ModelEmail` and `ModelPassword` types, you can write the necessary logic without needing to worry about the validity of the data passed in. Code that calls the function (from the UI, for example) is forced to comply and instantiate the types **before** calling the function, which is only possible with valid data.

If instead the function was defined as `signIn(String email, String password)`, each string would need to be validated inside the function and then react accordingly if they weren't. Even if you trust the values that are passed in, it is still _possible_ that the values could be invalid.

This works with the data layer too. If the repository pattern is used, a `ModelType` or an `ImmutableModel` can be specified as the return type of the data functions, meaning the returned data would have to be valid.

This lets you write an **authoritative** domain layer. One that forces the correct implementation from the UI and data layers.

## Using `ImmutableModel`

Note: this is not an exhaustive overview of the API, please see the [API docs](https://pub.dev/documentation/immutable_model/latest/) for that.

After defining a state model:

```dart
final aModelWithAnInner = ImmutableModel(
  {
    "some_int": M.nt(initialValue: 0),
    "some_string": M.str(initialValue: "Hello"),
    "the_inner": M.inner({
      "another_string": M.str(initialValue: "World"),
    }),
  }
);
```

The values can be accessed as follows:

```dart
aModelWithAnInner["some_string"]; // "Hello"
aModelWithAnInner["the_inner"]["another_string"]; // "World"
```

(**Note:** normally when using the `[]` notation the model's `.value` is returned, except when a `ModelInner` is specified. Instead the `ModelInner` instance will be returned, not it's `.value`. The `.get()` method can be used to always get the model `.value`)

Updates use a map between field label Strings and values or functions:

```dart
aModelWithAnInner.update({
  "some_int": (n) => ++n,
  "the_inner": {
    "another_string": "New World".
  }
  });
aModelWithAnInner["some_int"]; // 1
aModelWithAnInner["the_inner"]["another_string"];  // New World
```

As shown in the above `signIn` function, `ModelType` models can also be used in the update map (see the [Theory](#Theory) section for an explanation).

### Using `ModelSelector`

A `ModelSelector<V>` can be defined and used with an `ImmutableModel` (or `ModelInner`) to update or access a `ModelType` or its value.

A `ModelSelector` is defined using a "selector string" which uses a '.' for accessing nested models.

The following selectors can be defined:

```dart
const someStringSel = ModelSelector<String>("some_string");
const anotherStringSel = ModelSelector<String>("the_inner.another_string");
```

And used to select values:

```dart
aModelWithAnInner.select(someStringSel); // "Hello"
aModelWithAnInner.select(anotherStringSel); // "World"
```

And to update values:

```dart
aModelWithAnInner.updateWithSelector(someStringSel, "New Hello");
aModelWithAnInner.updateWithSelector(anotherStringSel, "New World");
```

### `ImmutableModel` strict updates

A strict update property can be enabled for a `ImmutableModel` (or a `ModelInner`) which will make any update to it require all fields defined in it.

For example, if the `authStateModel` was defined as:

```dart
final authStateModel = ImmutableModel(
  {
    "email": M.email(defaultEmail: 'example@gmail.com'),
    "password": M.password(),
  },
  strictUpdates: true,
);
```

Then calling:

```dart
authStateModel.update({
  "email": email,
});
```

Would fail but calling:

```dart
authStateModel.update({
  "email": email,
  "password": password
});
```

Wouldn't.

This is useful when you need to model something more ephemeral like when you need to display information gotten from a REST API call and you require all the data specified by the model.

### `ImmutableModel`'s can be reset

The models held by `ImmutableModel` can be reset by calling:

```dart
authStateModel.resetAll()
```

Which will reset all `ModelType` instances held by it, or

```dart
authStateModel.resetFields([...]);
```

Which will reset all instances specified by the list of field labels.

In general, any `ModelType` can be reset by accessing its `initial` property.

### `ImmutableModel`'s wrap a state

An `ImmutableModel<S>` is generic over some state `S`, for example:

```dart
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}

final authStateModel = ImmutableModel<AuthState>(
  {
    "email": M.email(defaultEmail: 'example@gmail.com'),
    "password": M.password(),
  },
  initialState: const AuthInitial(),
);
```

This can be used in the UI to check what state the model is in and react to changes in it by accessing the `currentState` property, for example:

```dart
if(authStateModel.currentState is AuthSuccess){...}
```

States can be transitioned to by calling:

```dart
authStateModel.transitionTo(const AuthSuccess());
```

or

```dart
authStateModel.transitionToAndUpdate(const AuthSuccess(), {...});
```

which includes an update with a transition.

There's also:

```dart
authStateModel.updateIfIn({...}, const AuthSuccess());
```

Which will only update the state model if it's in the state specified.

### Declaring your own `ModelType` or `ValueType`

You can easily define your own `ModelType` by extending the `ModelValue` class.

The `buildNext` method must be overridden which must call an internal constructor (normally called `_next`) that takes a previous instance of the sub-class and must in turn call `super.constructNext`.

If you want to create a value type which, as stated before, is a class that wraps its own validator, you must additionally use the `ValueType` mixin.

For example:

```dart
class CityName extends ModelValue<CityName, String> with ValueType {
  // checks if every word is capitalized
  static final validator = (String str) => (str).split(" ").every((w) => w[0] == w[0].toUpperCase());
  static const label = "city_name";

  CityName([String defaultCityName]) : super.text(defaultCityName.trim(), validator, label);

  CityName._next(CityName previous, String value) : super.constructNext(previous, value.trim());

  @override
  CityName buildNext(String nextValue) => CityName._next(this, nextValue);
}
```

This type can now be used in an `ImmutableModel` and to parameterize functions.

See [Value Types](https://github.com/oliverfunk/immutable_model/tree/master/lib/src/value_types) for more examples.

## Theory

It is helpful to understand a couple of concepts before using this library.

Every instance of a an `ImmutableModel` (or any `ModelType` used inside of it or otherwise) should be considered to be a node in a [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph). Every valid update of it leads to a progression in this graph, as a new instance is always returned

The first (or `initial`) instance is important as it is used to define an **Equality Of History** between two models.

If a model "shares a history" with another, it implies that the models are equally valid, because every progression from the first instance must have been a valid one thus if they both come from the same initial instance, they must both be equally valid.

Even if two models are equal in terms of value, they may not share a history together.

If two model instances (`A` and `B`) do share a history, the one can be updated with the other, which will in effect just return the one used to update it. For example `A.update(B)` will just return `B`.

However, things are slightly different for **value type** `Models` (such a `ModelEmail` or `ModelPassword`) because value types wrap their own validation (or they're supposed to), meaning any instance of some value type will be equally valid to any other instance of it, regardless of whether they share a history or not.

If you have two instances `A` and `B` of some value type and you call `A.update(B)` a new instance `C` will be returned with `B`'s value but with `A`'s `initial` instance (in a similar vain to merging `B` into `A`).

The reason this is done is slightly esoteric but if you look at `authStateModel` from above and the `signIn` function, the `ModelEmail` and `ModelPassword` instances passed to the `signIn` function do not share a history with the instances in the `authStateModel` but, of course, are valid and thus can be used to update the values in the `authStateModel`. If the models were simply replaced, one wouldn't be able to reset values correctly. For example, the `defaultEmail` originally defined for the "email" field would be lost.

## Supported Types

These are all the `ModelTypes` defined in this package:

**Primitives:**

- `ModelBool`
- `ModelInt`
- `ModelDouble`
- `ModelString`
- `ModelText`: a non-empty String
- `ModelDateTime`

**Lists:**

- `ModelList<bool>`
- `ModelList<int>`
- `ModelList<double>`
- `ModelList<String>`
- `ModelList<DateTime>`
- `ModelList<Map<String, dynamic>`: Called a "Model Validated List" because each Map item is validated against a `ModelInner`

**Enums:**

- `ModelEnum<E>`: `E` is the enum type

**Maps:**

- `ModelInner`: Map between field label Strings and other `ModelType` models.
