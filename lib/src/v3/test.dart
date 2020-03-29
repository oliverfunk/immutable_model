import './immutable_value.dart';

class Heapy {
  String f;
  String s;

  Heapy(this.f, this.s);
  static Heapy copy(Heapy next) => Heapy(next.f, next.s);

  @override
  String toString() => "$f $s";
}

class ImmHeapy extends ImmutableEntity<ImmHeapy> {
  final String f;
  final String s;

  ImmHeapy._copy(ImmHeapy ih) : f = ih.f, s = ih.s;
  ImmHeapy(this.f, this.s);

  @override
  ImmHeapy copy(ImmHeapy currentValue) => ImmHeapy._copy(currentValue);

  @override
  ImmHeapy build(ImmHeapy value) => ImmHeapy._copy(value);
}

void main(){
  final e = ImmutableValuee<Heapy>(Heapy.copy, Heapy("Oliver", "Funk"));
  final ev1 = e.value;
  e.set((entity) => entity..f = "new");
  final ev2 = e.value;
  print(ev1);
  print(ev2);

  final ih = ImmHeapy("Oliver", "Funk");

  ih.set(nextValue)
}