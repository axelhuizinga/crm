package view.shared;

import haxe.ds.StringMap;
import js.html.Event;
import model.AppState;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
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
	data:StringMap<Dynamic>,
	dirty:Bool,
	fields:StringMap<FormField>,
	values:StringMap<Dynamic>,
	submitted:Bool,
	errors:StringMap<String>,
	hasError:Bool
}


class BaseForm extends ReactComponentOf<BaseFormProps, FormState> 
{
	var mounted:Bool;
	
	public function new(?props:BaseFormProps) 
	{
		super(props);
		mounted = false;
		state = {
			data:new StringMap(),
			content:new Array(),
			dirty:false,
			errors:new StringMap(),
			values:new StringMap(),
			fields:new StringMap(),
			submitted:false,
			hasError:false		
		};
	}
	
	function cache(key:String):Dynamic
	{
		if (state.values.exists(key))
		{
			return state.values.get(key);
		}
		return null;
	}
	
	override public function componentWillUnmount():Void 
	{
		mounted=false;
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		trace(mounted);
	}
	
    override function render() {
		trace('You should override me :)');
        return null;
    }	
	
	function displayDebug(fieldName:String):ReactFragment
	{
		//trace (state.values.get(fieldName));
		if (state.values.exists(fieldName))
		{
			return jsx('
					<pre className="debug">${renderDataTable(state.values.get(fieldName))}</pre>
			');
		}
		
		return null;
	}
	
	function renderDataTable(content:Array<Dynamic>):ReactFragment
	{
		//trace(content);
		if (content == null || content.length == 0)
			return null;
		var rC:Array<ReactFragment> = new Array();
		var k:Int = 1;
		for (c in content)
		{
			rC.push(jsx('<div key=${k++}>${c.user_group}</div>'));
		}
		return rC;
	}
	
}