package view.shared;
import view.shared.FormField;

 typedef FormProps =
 {
	>RouteTabProps,
	//?dataClassPath:String,
	?elements:Map<String,FormField>,
	//?data:Dynamic,
	//?store:Store<AppState>,
	?isConnected:Bool,
	?handleChange:Bool,
	?handleSubmit:Bool,
	?handleChangeByParent:InputEvent->Void,
	?handleSubmitByParent:InputEvent->Void,
	?name:String,
	?sideMenu:SMenuProps,
	?submit:FormState->Dispatch
 }
