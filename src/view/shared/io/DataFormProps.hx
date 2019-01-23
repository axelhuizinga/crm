package view.shared.io;
import view.shared.io.FormContainer;
import react.ReactType;
import model.UserState;

typedef DataFormProps =
{
	>FormProps,
    ?formContainer:FormContainer,
	?fullWidth:Bool,
	?setStateFromChild:FormState->Void,
	?registerFormContainer:FormContainer->Void,
	user:UserState,
	model:String
}