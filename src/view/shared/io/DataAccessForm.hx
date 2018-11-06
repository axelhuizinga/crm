package view.shared.io;

import haxe.ds.Map;
import haxe.ds.StringMap;
import haxe.http.HttpJs;
import js.html.InputElement;
import js.html.InputEvent;
import react.addon.intl.IntlMixin;
import view.shared.BaseForm.FormElement;
import view.shared.BaseForm.FormField;
import view.shared.BaseForm.FormState;
import view.shared.BaseForm.FormProps;
import view.shared.io.DataAccess.DataView;

import react.PureComponent.PureComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import redux.Redux;

using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DataFormProps =
{
	>FormProps,
	?fullWidth:Bool,
}

class DataAccessForm extends PureComponentOf<DataFormProps,FormState>
{
	var mounted:Bool;
	var requests:Array<HttpJs>;	
	var view:DataView;
	
	public function new(?props:DataFormProps) 
	{
		super(props);
		mounted = false;
		requests = [];
		if(props != null)
		trace(props.match);
		state = {
			data:new StringMap(),
			clean:true,
			hasError:false,
			handleChange:props.handleChange?handleChange:null,
			handleSubmit:props.handleSubmit?handleSubmit:null,
		};
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
	
	//componentWillReceiveProps 
	/*
	static function mapDispatchToProps(dispatch:Dispatch) {
		trace(dispatch);
		return {
			submit: function(fState:FormState) return dispatch(AsyncUserAction.loginReq(fState))
		};
	}*/
	
	function handleChange(e:InputEvent)
	{
		var s:Dynamic = {};
		var t:InputElement = cast e.target;
		trace('${t.name} ${t.value}');
		//t.className = 'input';
		Reflect.setField(s, t.name, t.value);
		//trace(props.dispatch == App.store.dispatch);
		//App.store.dispatch(AppAction.LoginChange(s));
		this.setState(s);
		//trace(this.state);
	}
	
	function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
		//trace(props.dispatch); //return;
		this.setState({submitted:true});
		//props.dispatch(AppAction.Login("{userName:state.userName,pass:state.pass}"));
		//trace(props.dispatch);
		//props.submit({userName:state.userName, pass:state.pass,api:props.api});
		//trace(_dispatch == App.store.dispatch);
		//trace(App.store.dispatch(AsyncUserAction.loginReq(state)));
		//trace(props.dispatch(AppAction.LoginReq(state)));
	}	

	
	override function render()
	{
		return null;		
	}
	
	function renderField(field:String, k:Int):ReactFragment
	{
		var formField:FormField = view[field];
		trace(formField);
		var value:String = (formField.dataFormat == null?state.data[field]:formField.dataFormat(state.data[field]));
		trace('$field:$value');
		return [
		jsx('<label key={k}>${formField.label}</label>'),switch(formField.type)
		{
			case Hidden:
				jsx('<input type="hidden" defaultValue=${value} readOnly=${formField.readonly}/>');
			default:
				jsx('<input defaultValue=${value} readOnly=${formField.readonly}/>');
			
		}];
	}
	
	function renderElements():ReactFragment
	{
		if(state.data.empty())
			return null;
		var fields:Iterator<String> = view.keys();
		var elements:Array<ReactFragment> = [];
		var k:Int = 0;
		for (field in fields)
		{
			elements.push(jsx('<div key=${k} className="formField" >${renderField(field, k++)}</div>'));
		}
		if (k > 0)
		{
			elements.push(jsx('
			<div key=${k++} className="formField" >
				<button className="submit" disabled=${state.clean} style=${{minWidth:"40%"}} >Speichern</button>
			</div>
			'));
		}
		return elements;
	}
	
	static function localDate(d:String):String
	{
		return DateTools.format(Date.fromString(d), "%d.%m.%Y %H:%M");
	}
	
	function obj2map(obj:Dynamic):Map<String,String>
	{
		var m:Map<String,String> = new Map();
		for (field in Reflect.fields(obj))
		{
			m.set(field, Reflect.field(obj, field));
		}
		return m;
	}
}