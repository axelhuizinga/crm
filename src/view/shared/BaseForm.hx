package view.shared;

import react.router.ReactRouter;
import react.router.Route.RouteMatchProps;
import react.router.RouterMatch;
import haxe.Constraints.Function;
import haxe.ds.Either;
import haxe.ds.Map;
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
import view.shared.io.DataAccessForm;

import view.table.Table.DataState;
import view.shared.RouteTabProps;
import view.shared.SMenu.InteractionState;
import view.shared.SMenu.SMenuBlock;
import view.shared.SMenu.SMenuProps;

@:enum
abstract FormElement(String)
{
	var Button = 'Button';
	var Hidden = 'Hidden';
	var Input = 'Input';
	var Password = 'Password';
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
	?primaryId:String,
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

typedef FormState =
{
	?dataClassPath:String,
	?viewClassPath:String,
	?data:Map<String,Dynamic>,
	?dataForm:DataAccessForm,
	?dataTable:Array<Map<String,Dynamic>>,
	?clean:Bool,
	?selectedRows:Array<TableRowElement>,
	?handleChange:InputEvent->Void,
	?handleSubmit:Dynamic->Void,	
	?hasError:Bool,
	?isConnected:Bool,
	?loading:Bool,
	?initialState:Dynamic,
	?model:String,
	?fields:Map<String,FormField>,//VIEW FORMFIELDS
	?valuesArray:Array<Map<String,Dynamic>>,//FORMATTED DISPLAY VALUES
	?values:Map<String,Dynamic>,//FORMATTED DISPLAY VALUES
	?sideMenu:SMenuProps,
	?submitted:Bool,
	?errors:Map<String,String>,
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
			data:new Map(),
			//loading:true,
			viewClassPath:'',
			//content:new Array(),
			clean:true,
			errors:new Map(),
			//values:new StringMap(),
			//fields:new StringMap(),
			sideMenu:null,
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
	
	function getRouterMatch():RouterMatch
	{
		var rmp:RouteMatchProps = cast props.match;
		return ReactRouter.matchPath(props.history.location.pathname, rmp);		
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
		//trace(props.history.location);
		//trace(props.location);
		trace(props.match.params);
		trace(getRouterMatch().params);
		//var viewClassPath:String = reactEventSource.target.getAttribute('data-classpath');
		var section:String = reactEventSource.target.getAttribute('data-section');
		//trace( 'state.viewClassPath:${state.viewClassPath} viewClassPath:$viewClassPath');
		trace( 'props.match.params.section:${props.match.params.section} section:$section');
		//if (state.viewClassPath != viewClassPath)
		if (section != props.match.params.section)
		{
			//var menuBlocks:
			var sM:SMenuProps = state.sideMenu;
			sM.section = section;
			setState({
				//viewClassPath:viewClassPath,
				sideMenu: sM
			});
			var basePath:String = props.match.path.split('/:')[0];
			trace(props.location.pathname);
			props.history.push('$basePath/$section');
			trace(props.history.location.pathname);
			//props.history.push(props.match.url + '/' + viewClassPath);
		}
	}
	
	function initSideMenu(sMa:Array<SMenuBlock>, sM:SMenuProps):SMenuProps
	{
		var sma:SMenuBlock = {};
		for (smi in 0...sMa.length)
		{
			sMa[smi].onActivate = switchContent;
			trace(sMa[smi].label);
		}

		sM.menuBlocks = [
			for (sma in sMa)
			sma.section => sma
		];
		return sM;
	}
	
}