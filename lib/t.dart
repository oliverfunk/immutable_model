import 'package:immutable_model/immutable_model.dart';

class TestModel extends ImmutableModel<TestModel, TestModelState> {
  final ModelString name;
  final ModelInt age;
  // final ModelInner<TestModel> mi;

  TestModel()
      : name = ModelString('name', 'Oliver'),
        age = ModelInt('age', 25, (n) => n >= 0),
        super.initial(initialState: const TestModelStateA());

  TestModel._next(
    this.name,
    this.age,
    ModelUpdate modelUpdate,
  ) : super.constructNext(modelUpdate);

  @override
  TestModel build(ModelUpdate modelUpdate) => TestModel._next(
        modelUpdate.getField(name),
        modelUpdate.getField(age),
        modelUpdate,
      );

  @override
  List<SerializableValidType> get fields => [name, age];

  @override
  ModelValidator get validator =>
      (mu) => mu.getField(name).value.length >= mu.getField(age).value;

  @override
  bool get strictUpdates => true;
}

abstract class TestModelState {
  const TestModelState();
}

class TestModelStateA extends TestModelState {
  const TestModelStateA();
}

class TestModelStateB extends TestModelState {
  const TestModelStateB();
}

void main(List<String> args) {
  final tm = TestModel();
  print(tm);
  print(tm.updateFields([
    FieldUpdate(tm.name, 'Funk'),
    FieldUpdate(tm.age, 1),
  ]));
  print(tm.transitionTo(const TestModelStateB()));

  final tinner = ModelInner('tesinner', tm);
  print(tinner);
  print(tinner.next(tm.updateFields([
    FieldUpdate(tm.name, 'Funk'),
    FieldUpdate(tm.age, 1),
  ])));
  print(tinner.nextWithSerialized(tinner.asSerializable()));
}
