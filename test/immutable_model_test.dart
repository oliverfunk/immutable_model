// import 'package:immutable_model/immutable_model.dart';

// class TestModel extends ImmutableModel<TestModel, TestModelState> {
//   final ModelString name;
//   final ModelInt age;
//   // final ModelInner<TestModel> mi;

//   TestModel()
//       : name = ModelString('Oliver', label: 'name'),
//         age = ModelInt(2, validator: (n) => n >= 0, label: 'age'),
//         super.initial(initialState: const TestModelStateA());

//   TestModel._next(
//     this.name,
//     this.age,
//     ModelUpdate modelUpdate,
//   ) : super.constructNext(modelUpdate);

//   @override
//   TestModel build(ModelUpdate modelUpdate) => TestModel._next(
//         modelUpdate.getField(name),
//         modelUpdate.getField(age),
//         modelUpdate,
//       );

//   @override
//   List<ModelType> get fields => [name, age];

//   @override
//   ModelValidator get validator =>
//       (mu) => mu.getField(name).value!.length >= mu.getField(age).value!;

//   // @override
//   // bool get strictUpdates => true;
// }

// abstract class TestModelState {
//   const TestModelState();
// }

// class TestModelStateA extends TestModelState {
//   const TestModelStateA();
// }

// class TestModelStateB extends TestModelState {
//   final String msg;
//   const TestModelStateB(this.msg);
// }

// void main() {
//   Map<Type, int> m = {};
//   m[int] = 2;
//   print(m);
// }
