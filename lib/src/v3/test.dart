import 'package:built_collection/built_collection.dart';

import './immutable_value.dart';

class Heapy {
  String f;
  String s;

  Heapy(this.f, this.s);
  static Heapy copy(Heapy next) => Heapy(next.f, next.s);

  @override
  String toString() => "$f $s";
}

class ImmMod extends ImmutableEntity<ImmMod, Map<String, dynamic>> {
  final BuiltMap<String, dynamic> _model;
  
  ImmMod._(ImmMod instance, Map<String, dynamic> value) : _model = instance._model.rebuild(() => null), super(value);
  ImmMod(Map<String, dynamic> def) : _model = BuiltMap.from(def), super(def, def);
  
  @override
  ImmMod build(Map<String, dynamic> value) 

  @override
  Map<String, dynamic> copy(Map<String, dynamic> value) {
    // TODO: implement copy
    throw UnimplementedError();
  }
  
}

void main(){

}