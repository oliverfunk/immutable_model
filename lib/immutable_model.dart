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



// todo: create a value type i.e. Email, ja it probs is better to create mdoel_inner and have ImmModel wrap it (makes me think about how you would update with a model as an input, use teh validator to cehck it (if it comes from teh saem class are teh vaildiots equal)