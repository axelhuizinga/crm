package view.shared;

import haxe.Constraints.Function;
import haxe.ds.Either;
import haxe.ds.StringMap;
import haxe.http.HttpJs;
import js.html.Event;
import js.html.HTMLCollection;
import js.html.InputEvent;
import js.html.TableRowElement;
import js.html.XMLHttpRequest;
import me.cunity.debug.Out;
import model.AppState;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
import redux.Redux.Dispatch;
import redux.Store;
import view.dashboard.model.RolesFormModel;
import view.shared.io.DataAccess;

import view.table.Table.DataState;
import view.shared.RouteTabProps;
import view.shared.SMenu.InteractionState;
import view.shared.SMenu.SMItem;
import view.shared.SMenu.SMenuProps;

@:enum
abstract FormElement(String)
{
	var Button = 'Button';
	var Hidden = 'Hidden';
	var Input = 'Input';
	var Password = 'Input';
	var Checkbox = 'Checkbox';
	var Radio = 'Radio';
	var Select = 'Select';
	var TextArea = 'TextArea';
}

/**
 * ...
 * @author axel@cunity.me
 */

typedef FormField =
{
	?className:String,
	?name:String,
	?label:String,
	?value:Dynamic,
	?dataBase:String, 
	?dataTable:String,
	?dataField:String,
	?displayFormat:Function,
	?type:FormElement,
	?primary:Bool,
	?readonly:Bool,
	?required:Bool,
	?handleChange:InputEvent->Void,
	?placeholder:String,
	?validate:String->Bool
}
 
 typedef FormProps =
 {
	>RouteTabProps,
	//?dataClassPath:String,
	?elements:StringMap<FormField>,
	//?data:Dynamic,
	//?store:Store<AppState>,
	?handleChange:Bool,
	?handleSubmit:Bool,
	?handleChangeByParent:InputEvent->Void,
	?handleSubmitByParent:InputEvent->Void,
	?name:String,
	?sideMenu:SMenuProps,
	?submit:FormState->Dispatch
 }

typedef FormState =
{
	?dataClassPath:String,
	?viewClassPath:String,
	?data:Map<String,String>,
	?dataTable:Array<Map<String,String>>,
	?clean:Bool,
	?selectedRows:Array<TableRowElement>,
	?handleChange:InputEvent->Void,
	?handleSubmit:Dynamic->Void,	
	?hasError:Bool,
	?loading:Bool,
	?model:String,
	?fields:Map<String,FormField>,//VIEW FORMFIELDS
	?valuesArray:Array<Map<String,String>>,//FORMATTED DISPLAY VALUES
	?values:Map<String,Dynamic>,//FORMATTED DISPLAY VALUES
	?sideMenu:SMenuProps,
	?submitted:Bool,
	?errors:StringMap<String>,
	?title:String
}

abstract OneOf<A, B>(Either<A, B>) from Either<A, B> to Either<A, B> {
  @:from inline static function fromA<A, B>(a:A):OneOf<A, B> {
    return Left(a);
  }
  @:from inline static function fromB<A, B>(b:B):OneOf<A, B> {
    return Right(b);  
  } 
    
  @:to inline function toA():Null<A> return switch(this) {
    case Left(a): a; 
    default: null;
  }
  @:to inline function toB():Null<B> return switch(this) {
    case Right(b): b;
    default: null;
  }
}

class BaseForm extends ReactComponentOf<FormProps, FormState> 
{
	var mounted:Bool;
	var requests:Array<OneOf<HttpJs,XMLHttpRequest>>;	
	//var sideMenu:SMenuProps;
	var dataDisplay:Map<String,DataState>;//TODO: CHECK4INTEGRATION INTO state or props
	
	
	public function new(?props:FormProps) 
	{
		super(props);	
		mounted = false;
		requests = [];		
		state = {
			data:new StringMap(),
			viewClassPath:'',
			//content:new Array(),
			clean:true,
			errors:new StringMap(),
			//values:new StringMap(),
			//fields:new StringMap(),
			sideMenu: {menuBlocks:null},
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
		{
			switch(r)
			{
				//HttpJs
				case Left(v): v.cancel();
				//XMLHttpRequest
				case Right(v): v.abort();
			}
		}
	}	
	
    override function render() {
		trace('You should override me :)');
        return null;
    }	 
	
	public function setStateFromChild(newState:FormState)
	{
		setState(newState);
		trace(newState);
	}
	
	public function switchContent(reactEventSource:Dynamic)
	{
		//Out.dumpObject(reactEventSource);
		trace(props.history);
		trace(props.match);
		var viewClassPath:String = reactEventSource.target.getAttribute('data-classpath');
		trace(viewClassPath + ':' + state.viewClassPath);
		if (state.viewClassPath != viewClassPath)
		{
			setState({viewClassPath:viewClassPath});
			props.history.push(props.match.url + '/' + viewClassPath);
		}
	}
	
	/*public static function addInteractionState(name:String, iS:InteractionState):Void
	{
		trace(name + ':' + iS);
		interactionStates.set(name, iS);
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
	}*/
	
}