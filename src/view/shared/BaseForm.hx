package view.shared;

import haxe.ds.StringMap;
import js.html.Event;
import model.AppState;
import react.ReactComponent.ReactComponentOf;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
import redux.Redux.Dispatch;
import redux.Store;
import view.shared.RouteTabProps;

enum FormElement
{
	Input;
	Checkbox;
	Radio;
	Select;
	TextArea;
}

/**
 * ...
 * @author axel@cunity.me
 */

typedef FormField =
{
	name:String,
	?value:Any,
	type:FormElement,
	?required:Bool,
	?onChange:Event->Void,
	?placeholder:String,
	?validate:Any->Bool
}
 
 typedef BaseFormProps =
 {
	 > RouteTabProps,
	 formData:Dynamic,
	 store:Store<AppState>,
	 handleChange:Event->Void,
	 handleSubmit:Event->Void
 }

typedef FormState =
{
	?content:Array<String>,
	dirty:Bool,
	fields:StringMap<FormField>,
	submitted:Bool,
	errors:StringMap<String>,
	hasError:Bool
}

class BaseForm extends ReactComponentOf<BaseFormProps, FormState> 
{

	public function new(?props:BaseFormProps) 
	{
		super(props);	
		state = {
			content:new Array(),
			dirty:false,
			errors:new StringMap(),
			fields:new StringMap(),
			submitted:false,
			hasError:false			
		};
	}
	
    override function render() {
		trace(Reflect.fields(props));
        return jsx('
            <form className="tabComponentForm">
				...
            </form>
        ');
    }	
	
}