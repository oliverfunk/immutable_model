import 'package:immutable_model/immutable_model.dart';

class TestModel extends ImmutableModel<TestModel> {
  final ModelString name;
  final ModelInt age;
  // final ModelInner<TestModel> mi;

  TestModel()
      : name = ModelString('Oliver', label: 'name'),
        age = ModelInt(2, validator: (n) => n >= 0, label: 'age'),
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
  List<ModelType> get fields => [name, age];

  @override
  ModelValidator get validator {
    return (mu) => mu.getField(name).value!.length >= mu.getField(age).value!;
  }

  // @override
  // bool get strictUpdates => true;
}

abstract class TestModelState extends ModelState<TestModelState> {
  const TestModelState();
}

class TestModelStateA extends TestModelState {
  const TestModelStateA();
}

class TestModelStateB extends TestModelState {
  final String msg;
  const TestModelStateB(this.msg);

  @override
  List<Type> get transitionableStates => [TestModelStateC];
}

class TestModelStateC extends TestModelState {
  const TestModelStateC();

  @override
  List<Type> get transitionableStates => [];
}

void main(List<String> args) {
  final m = TestModel();
  print(m
      .transitionTo(const TestModelStateB('FUCKING LIT'))
      .transitionTo(const TestModelStateA()));
}
