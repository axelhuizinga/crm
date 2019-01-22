package view.shared;
import js.html.InputEvent;
import redux.Redux.Dispatch;
import react.ReactType;
import react.ReactComponent;
import view.shared.FormField;
import view.shared.SMenuProps;

 typedef FormProps =
 {
	>RouteTabProps,
	?activeComponent:ReactComponent,
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
