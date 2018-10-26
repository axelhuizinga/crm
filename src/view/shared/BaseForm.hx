package view.shared;

import haxe.Constraints.Function;
import haxe.ds.StringMap;
import haxe.http.HttpJs;
import js.html.Event;
import model.AppState;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
import redux.Redux.Dispatch;
import redux.Store;
import view.dashboard.model.RolesFormModel;

import view.table.Table.DataState;
import view.shared.RouteTabProps;
import view.shared.SMenu.SMItem;
import view.shared.SMenu.SMenuProps;

enum FormElement
{
	Hidden;
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
	?name:String,
	?label:String,
	?value:Any,
	?dataBase:String, 
	?dataTable:String,
	?dataField:String,
	?dataFormat:Function,
	?type:FormElement,
	?required:Bool,
	?onChange:Event->Void,
	?placeholder:String,
	?validate:Any->Bool
}
 
 typedef FormProps =
 {
	>RouteTabProps,
	?contentId:String,
	?elements:StringMap<FormField>,
	?formData:Dynamic,
	?store:Store<AppState>,
	?handleChange:Event->Void,
	?handleSubmit:Event->Void
 }

typedef FormState =
{
	var contentId:String;
	//@:optional var content:Array<String>;
	@:arrayAccess
	@:optional var data:Map<String,Dynamic>;
	var clean:Bool;
	var hasError:Bool;
	@:optional var loading:Bool;
	@:optional var fields:StringMap<FormField>;
	@:optional var values:StringMap<Dynamic>;
	@:optional var submitted:Bool;
	@:optional var errors:StringMap<String>;
}


class BaseForm extends ReactComponentOf<FormProps, FormState> 
{
	var mounted:Bool;
	var requests:Array<HttpJs>;	
	var sideMenu:SMenuProps;
	@:arrayAccess
	var dataDisplay:Map<String,DataState>;//TODO: CHECK4INTEGRATION INTO state or props
	
	public function new(?props:FormProps) 
	{
		super(props);		
		mounted = false;
		requests = [];
		sideMenu = {articles:[]};
		state = {
			data:new StringMap(),
			contentId:'',
			//content:new Array(),
			clean:true,
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
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		trace(mounted);
	}
	
	override public function componentWillUnmount()
	{
		mounted=false;
		for (r in requests)
			r.cancel();
	}		
	
    override function render() {
		trace('You should override me :)');
        return null;
    }	
	
	public function switchContent(contentId:String)
	{
		if (props.contentId != contentId)
		{
			setState({contentId:contentId});
		}
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