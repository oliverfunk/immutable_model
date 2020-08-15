import 'package:bloc/bloc.dart';
import 'package:immutable_model/immutable_model.dart';
import 'package:random_words/random_words.dart';

enum _Seasons { Summer, Winter, Autum, Spring }

class 

class FormEntity extends Cubit<ImmutableModel> {
  static final _innerModel = ImmutableModel({
    "email": M.email(),
    "upper_name": 
  });

  static final _model = ImmutableModel(
    {
      "unique_id": M.str(generateNoun().take(3).join('-')),
      "inital_word": M.str("Hello M!"),
      "validated_number": M.nt(0, (n) => n >= 0),
      "a_double": M.dbl(13 / 7),
      "this_is_great": M.bl(true),
      "favourite_season": M.enm<_Seasons>(
        ModelEnum.fromEnumList(_Seasons.values),
        ModelEnum.fromEnum(_Seasons.Summer),
      ),
      "date_begin": M.dt(DateTime.now()),
      "date_end": M.dt(DateTime.now().add(Duration(seconds: 100))),
      // "validated_field": M.inner()
    },
    (stateMap) => (stateMap['date_begin'].value as DateTime)
        .isBefore(stateMap['date_end'].value as DateTime),
  );

  FormEntity() : super(_model);

  static void debugPrintModel() => print(_model.toString());
}
