package view.shared.io;
import react.ReactType;

typedef DataFormProps =
{
	>FormProps,
    ?componentContainer:ReactType,
	?fullWidth:Bool,
	?setStateFromChild:FormState->Void,
	model:String
}