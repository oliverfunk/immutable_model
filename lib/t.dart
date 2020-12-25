import 'package:immutable_model/immutable_model.dart';
import 'package:immutable_model/src/model_types/lists/immutable_model_list.dart';

class TestModel extends ImmutableModel<TestModel, TestModelState> {
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
  ModelValidator get validator =>
      (mu) => mu.getField(name).value!.length >= mu.getField(age).value!;

  // @override
  // bool get strictUpdates => true;
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
  print(
    tm.updateFields(
      fieldUpdates: [
        FieldUpdate(field: tm.name, update: 'Oliver'),
        FieldUpdate(field: tm.age, update: 1),
      ],
    ),
  );
  print(tm.transitionTo(const TestModelStateB()));

  final tinner = ModelInner(tm, label: 'testmod');
  print(tinner);
  print(
    tinner.next(
      tm.updateFields(
        fieldUpdates: [
          FieldUpdate(field: tm.name, update: 'Funk'),
          FieldUpdate(field: tm.age, update: 1),
        ],
      ),
    ),
  );
  print(tinner.nextWithSerialized(tinner.asSerializable()));

  final a = ImmutableModelList([
    tm,
    tm,
    tm,
  ], validator: tinner, label: 'field');
  print(a.nextWithSerialized(a.asSerializable()));
}
