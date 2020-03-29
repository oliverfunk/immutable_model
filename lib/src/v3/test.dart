import './immutable_value.dart';

class Heapy {
  String f;
  String s;

  Heapy(this.f, this.s);
  static Heapy copy(Heapy next) => Heapy(next.f, next.s);

  @override
  String toString() => "$f $s";
}

void main(){
  final e = ImmutableEntity<Heapy>(Heapy.copy, Heapy("Oliver", "Funk"));
  final ev1 = e.value;
  e.set((entity) => entity..f = "new");
  final ev2 = e.value;
  print(ev1);
  print(ev2);
}