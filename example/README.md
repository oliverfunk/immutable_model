# Examples

Examples using immutable_model with different state management systems.
The projects have the same UI and demonstrate modeling different kinds of states and the associated data.

- The **SignIn** form shows how to do 'live' user input validation as well as parameterising the authentication logic using the provided ModelEmail and ModelPassword classes as validated value types.
- The **User Choices** form shows one can update any value in the model (even nested values) using just the update() function. Also shows how these updates can only take place if the user is authenticated.
- The **Weather Getter** shows how the use of an API would work, where severalized data is inputted to the data layer and only valid models are passed back into the domain layer. It also shows the use of 'Strict Updates' where each field in the sub-model must have a value and that value must be valid.