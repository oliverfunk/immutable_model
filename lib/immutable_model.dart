library immutable_model;

export 'src/exceptions.dart';
export 'src/immutable_model.dart';
export 'src/model_list.dart';
export 'src/model_primitive.dart';

// giving you the power to express complex valid models quckly.

// uses equalitiy of hisotries

// TODO: write tests for seriliaszation, value getting and updateing etc.
// TODO: documentation
// TODO: exceptions
// todo: add combine methods for Imm models and lists/sets (est. espose those metthods)
// todo: supprt iterations
// todo: support bool (from Json)
//  , set, DateTime (bigInt?)
// todo: build generator
// todo: could maybe implement something model_inner which is the same as imm model but doesn't have the buffer
// todo: enums
// todo: could do an update from a model_type if the validaor is the same (equalit of histoy)
// updateFromModels
// would imply that the type is the same and that the value has to be valid.class
// maybe useufl when doing something for sub-typing model_prim as a value type and then using that to update the model instead of getting its value


// this is a bit shit but it might be possible to rewrite imm mod to use model values that are 'dumb' that only hold
// their own validotors and every update imm mod does all the work of checking etc.
// not sure what the reprecussions would be if you did this on extensions to model values
// all the behaviour (update, updateFrom etc.) is only defined in imm_mod
// all the values do is store their own validort, they dont need to have any kind of behaviour

// you cant construct generically, won't work. (i.e. you have to have a build method in model_value)

// you could get rid of updates * from modelvalue if you made build implaclly call validate
// but that would be kak for 2 reaosn: 1 you can force impleators to do that and 2 it breaks sol responbility
// but those 2 things arent that bad
// it would reduce haivng unecssary methods on model value objects (also good things lke value types)
// it
// i think leave it for now. Once everythign is built you can try it see if it impore perforamce.

// you could call build something like next

// it just feel wrong to not do it. Like

// todo: create a value type i.e. Email, ja it probs is better to create mdoel_inner and have ImmModel wrap it (makes me think about how you would update with a model as an input, use teh validator to cehck it (if it comes from teh saem class are teh vaildiots equal)