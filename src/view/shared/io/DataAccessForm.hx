package view.shared.io;

import haxe.Constraints.Function;
import haxe.ds.Either;
import haxe.ds.Map;
import haxe.ds.StringMap;
import haxe.http.HttpJs;
import js.html.DOMStringMap;
import js.html.Event;
import js.html.HTMLCollection;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.TableRowElement;
import js.html.XMLHttpRequest;
import react.addon.intl.IntlMixin;
import view.shared.BaseForm.FormElement;
import view.shared.BaseForm.FormField;
import view.shared.BaseForm.FormState;
import view.shared.BaseForm.FormProps;
import view.shared.BaseForm.OneOf;
import view.shared.SMenu.SMenuProps;
import view.shared.SMenu.SMItem;
import view.shared.io.DataAccess.DataView;
import view.table.Table.DataState;
import react.PureComponent.PureComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.ReactUtil;
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
	?setStateFromChild:FormState->Void,
}

class DataAccessForm extends PureComponentOf<DataFormProps,FormState>
{
	var mounted:Bool;
	var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;	
	var dataAccess:DataAccess;
	var dataDisplay:Map<String,DataState>;
	var _menuItems:Array<SMItem>;
	
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
			handleChange:setChangeHandler(),
			handleSubmit:setSubmitHandler(),
			sideMenu: props.sideMenu,
			selectedRows:new Array()
		};
	}

	function createStateValuesArray(data:Array<Map<String,String>>, view:DataView):Array<Map<String,String>>
	{
		return [ for (r in data) createStateValues(r, view) ];
	}
	
	function createStateValues(data:Map<String,String>, view:DataView):Map<String,String>
	{
		var vState:Map<String,String> = new Map();
		//trace(data.keys());
		//trace(view.keys());
		for (k in data.keys())
		{
			if(view.exists(k))
			{
				vState[k] = (view[k].displayFormat == null?data[k]:view[k].displayFormat(data[k]));
			}
		}
		//trace(vState);
		return vState;
	}
		
	function selectedRowsMap():Array<Map<String,String>>
	{
		return [for (r in state.selectedRows) selectedRowMap(r)];
	}
	
	function selectedRowMap(row:TableRowElement):Map<String,String>
	{
		var rM:Map<String,String> = [
			for (c in row.cells)
				c.dataset.name => c.innerHTML
		];
		return rM;
	}
	
	function setChangeHandler():InputEvent->Void
	{
		if (props.handleChange)
		{
			if (props.handleChangeByParent != null)
				return props.handleChangeByParent;
			return handleChange;
		}
		return null;
	}

	function setSubmitHandler():InputEvent->Void
	{
		if (props.handleSubmit)
		{
			if (props.handleSubmitByParent != null)
				return props.handleSubmitByParent;
			return handleSubmit;
		}
		return null;
	}
	
	public function setStateFromChild(newState:FormState)
	{
		newState = ReactUtil.copy(newState, {sideMenu:updateMenu()});
		setState(newState);
		trace(newState);
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
	
	function handleChange(e:InputEvent)
	{
		var t:InputElement = cast e.target;
		trace('${t.name} ${t.value}');
		var vs = state.values;
		trace(vs.toString());
		vs[t.name] = t.value;
		//t.className = 'input';
		//Reflect.setField(s, t.name, t.value);
		//trace(props.dispatch == App.store.dispatch);
		//App.store.dispatch(AppAction.LoginChange(s));validate
		setState({clean:false, sideMenu:updateMenu(),values:vs});
		//props.setStateFromChild({clean:false});
		//trace(this.state);
	}
	
	function updateMenu():SMenuProps
	{
		trace('subclass task');
		return null;
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
	
	function renderField(name:String, k:Int):ReactFragment
	{
		var formField:FormField = state.fields[name];
		if(k==0)
			trace(state.handleChange);

		var field = switch(formField.type)
		{
			case Hidden:
				jsx('<input key={k++} name=${name} type="hidden" defaultValue=${state.values[name]} readOnly=${formField.readonly}/>');
			default:
				jsx('<input key={k++} name=${name} defaultValue=${state.values[name]} onChange=${formField.readonly?null:state.handleChange} readOnly=${formField.readonly}/>');
			
		};
		return formField.type == Hidden? field:[jsx('<label key={k++}>${formField.label}</label>'), field];
	}
	
	function renderField4Array(name:String, k:Int, r:Int):ReactFragment
	{
		var formField:FormField = state.fields[name];
		if(k==0)
			trace(state.handleChange);
		trace(state.valuesArray[r]);
		trace(formField);
		var field = switch(formField.type)
		{
			case Hidden:
				jsx('<input key={k++} name=${name} type="hidden" defaultValue=${state.valuesArray[r][name]} readOnly=${formField.readonly}/>');
			default:
				jsx('<input key={k++} name=${name} defaultValue=${state.valuesArray[r][name]} onChange=${formField.readonly?null:state.handleChange} readOnly=${formField.readonly}/>');
			
		};
		return formField.type == Hidden? field:[jsx('<label key={k++}>${formField.label}</label>'), field];
	}
	
	function renderElements():ReactFragment
	{
		if(state.data.empty())
			return null;
		var fields:Iterator<String> = state.fields.keys();
		var elements:Array<ReactFragment> = [];
		var k:Int = 0;
		for (field in fields)
		{
			elements.push(jsx('<div key=${k} className=${state.fields[field].type==Hidden?null:"formField"} >${renderField(field, k++)}</div>'));
		}
		if (k > 0)
		{
			/*add footer comps*/
		}
		return elements;
	}
	
	function renderElementsArray():ReactFragment
	{
		if(state.dataTable.empty())
			return null;
		var formRows: Array<ReactFragment> = [];
		var r:Int = 0;
		for (dR in state.dataTable)
		{
			formRows.push(jsx('
			<div className="formDataInRow" key=${r} >${renderElements4Array(r++)}</div>
			'));
		}
		return formRows;
	}
	
	function renderElements4Array(r:Int):ReactFragment
	{
		var fields:Iterator<String> = state.fields.keys();
		var elements:Array<ReactFragment> = [];
		var k:Int = 0;
		for(field in fields)
		{
			elements.push(jsx('<div key=${k} className=${state.fields[field].type==Hidden?null:"formFieldInline"} >${renderField4Array(field, k++, r)}</div>'));
		}
		if (k > 0)
		{
			/*add footer comps*/
		}
		return elements;
	}
	
	function renderModalForm():ReactFragment
	{
		return jsx('
		<div className="modal is-active">
		  <div className="modal-background"></div>
		  <div className="modal-content">
			${state.data.empty()? renderElementsArray():renderElements()}
		  </div>
		  <button className="modal-close is-large" aria-label="close"></button>
		</div>
		');
	}
	
	static function localDate(d:String):String
	{
		trace(d);
		return DateTools.format(Date.fromString(d), "%d.%m.%Y %H:%M");
	}
	
	function obj2map(obj:Dynamic, ?fields:Array<String>):Map<String,String>
	{
		var m:Map<String,String> = new Map();
		if (fields == null)
			fields = Reflect.fields(obj);
		for (field in fields)
		{
			m.set(field, Reflect.field(obj, field));
		}
		return m;
	}
	
	function filterMap(m:Map<String,String>, keys:Array<String>):Map<String,String>
	{
		var r:Map<String,String> = new Map();
		for (k in keys)
		{
			r.set(k, m.get(k));
		}
		return r;
	}
	
	public function save(evt:Event)
	{
		evt.preventDefault();
		trace('your subclass has to override me to save anything!');
	}
}