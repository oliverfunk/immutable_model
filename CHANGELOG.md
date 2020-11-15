## [0.9.0] - [0.9.2]

- Out of Alpha! All core features have been added and the fat trimmed.
- Added ModelValue and ModelEnum lists
- Changed the library structure and some of the interfaces
- Fixed a bug ModelEnum
- All values returned from the asSerializable method are now read-only with the correct types
- Fixed bug with ModelDateTime fromSerialized
- Unified the interfaces
- Removed the fieldLabel property from ModelTypes

## [0.8.0] - [0.8.1]

- Made the initialization of models more uniform
- Removed equality check when updating with a model
- Improved IM update speed slightly
- Added ModelInnerList and tests
- Added list sorting methods

## [0.7.0] - [0.7.1]

- Reparameterized ModelInner and ModelEnum

## [0.6.0] - [0.6.2]

- Refactored ModelLists into their own model types
- Refactored parameter fields into a more uniform style across the library
- Expanded ModelSelector to include selecting from different source
- Added the shouldBuild function to ModelType
- Updated the examples
- Added more tests

## [0.5.0] - [0.5.3]

- Entered Beta phase. Many, many things were added, changed or improved upon.
- Selectors were added
- ImmutableModel now wraps a state
- The library was almost entirely refactored to add value type support. See the example projects for more.
- Fixed many bugs
- Adn much more...

## [0.2.0] - [0.2.4]

- Added ModelEnum
- Added DateTime support
- Added utility class `M`
- Made unsupported types unrepresentable
- Validation support on whole model each update
- Added ModelMerge methods

## [0.1.0]

- Initial release.
