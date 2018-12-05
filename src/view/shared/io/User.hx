package view.shared.io;

import action.AppAction;
import tink.core.Error.Stack;
import haxe.Serializer;
import haxe.ds.StringMap;
import haxe.io.Bytes;
import js.html.Event;
import js.html.InputEvent;
import model.AjaxLoader;
import react.ReactComponent;
import react.ReactComponent.ReactFragment;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import shared.DbData;
import view.shared.BaseForm.*;
import view.shared.BaseForm.FormState;
import view.shared.SMenu;
import view.shared.io.DataAccessForm;
import view.shared.io.DataAccess.DataSource;
import view.table.Table;

using Lambda;
using shared.Utils;

/**
 * ...
 * @author axel@cunity.me
 */

typedef UserProps =
{
	?contact:Int,
	?first_name:String,
	?last_name:String,
	?email:String,
	?active:Bool,
	?loggedIn:Bool,
	?last_login:Date,
	?loginError:Dynamic,
	?jwt:String,
	?pass:String,
	user_name:String,
	?redirectAfterLogin:String,
	?waiting:Bool
}

typedef UserModel = DataSource;

typedef UserFilter = Dynamic;

class User extends DataAccessForm
{
	static var _instance:User;

	public static function menuItems():Array<SMItem>
	{
		return _instance == null? [] : _instance._menuItems;
	}
		
	override function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
	}
	
	override public function componentDidMount():Void 
	{
		dataAccess = [
			'changePassword' =>
			{
				source:[
					"users" => [
						"fields" => 'user_name,change_pass_required,password']
				],
				view:[
					'user_name' => {type:Hidden},
					'pass' => {type:Password},
					'new_pass' => {type:Password}
				]
			},
			'edit' =>{
				source:[
					"users" => ["alias" => 'us',
						"fields" => 'user_name,last_login,change_pass_required,password'],
					"contacts" => [
						"alias" => 'co',
						"fields" => 'first_name,last_name,email',
						"jCond"=>'contact=co.id']
				],
				view:[
					'user_name'=>{label:'UserID',readonly:true, type:Hidden},
					'pass'=>{label:'Passwort', type:Hidden},
					'first_name'=>{label:'Vorname'},
					'last_name'=>{label:'Name'},
					'email' => {label:'Email'},
					'last_login'=>{label:'Letze Anmeldung',readonly:true, displayFormat:DataAccessForm.localDate}
				]
			},
			'save' => {
				source:null,
				view:null
			}
		];	

		super.componentDidMount();
			
		requests.push(BinaryLoader.create(
			'${App.config.api}', 
			{				
				user_name:props.user_name,
				jwt:props.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.user_name}',
				dataSource:Serializer.run(dataAccess['edit'].source)			
			},
			function(dBytes:Bytes)
			{
				trace(dBytes.toString());
				var u:hxbit.Serializer = new hxbit.Serializer();
				var data:DbData = u.unserialize(dBytes, DbData);
				trace(Reflect.fields(data));
				trace(data);
				trace(Reflect.fields(data.dataRows[0]));
				if (data.dataRows[0]['change_pass_required'] == '1')
				{
					setState({data:data.dataRows[0], viewClassPath:'changePassword',
					fields:dataAccess['changePassword'].view,
					values:createStateValues(data.dataRows[0], 
					dataAccess['changePassword'].view), loading:false});					
				}
				else{
					setState({data:data.dataRows[0], viewClassPath:'edit',
					fields:dataAccess['edit'].view,
					values:createStateValues(data.dataRows[0], 
					dataAccess['edit'].view), loading:false});	
					var user:Dynamic = App.store.getState().appWare.user;
					App.store.dispatch(AppAction.User({
							first_name:data.dataRows[0]['first_name'],
							last_name:data.dataRows[0]['last_name'],
							user_name:App.user_name,
							email:data.dataRows[0]['email'],
							pass:'',
							waiting:false,
							last_login:Date.fromString(data.dataRows[0]['last_login']),
						}));
				} 				
			}
		));
	}
	
	override public function componentDidUpdate(prevProps:DataFormProps, prevState:FormState):Void 
	{
		//trace(prevProps);
		//trace(prevState);
		if(autoFocus!=null)
		autoFocus.current.focus();
	}
	
	public function changePassword(ev:ReactEvent):Void
	{
		trace(state.values);
		if(state.viewClassPath!='changePassword')
			return setState({viewClassPath:'changePassword'});
		if (state.values['new_pass'] != state.values['new_pass_confirm'])
			return setState({errors:['changePassword'=>'Die Passwörter stimmen nicht überein!']});
		if (state.values['new_pass'] == state.values['pass'])
			return setState({errors:['changePassword'=>'Das Passwort muss geändert werden!']});
		trace(App.store.getState().appWare.user.dynaMap());
		requests.push(BinaryLoader.create(
			'${App.config.api}', 
			{				
				user_name:props.user_name,
				jwt:props.jwt,
				className:'auth.User',
				action:'changePassword',
				new_pass:state.values['new_pass'],
				pass:state.values['pass']
			},
			function(dBytes:Bytes)
			{
				trace(dBytes.toString());
				var u:hxbit.Serializer = new hxbit.Serializer();
				var data:DbData = u.unserialize(dBytes, DbData);
				trace(Reflect.fields(data));
				trace(data);
				if (data.dataErrors.keys().hasNext())
				{
					trace(data.dataErrors.toString());
				}
				if (data.dataInfo['changePassword'] == 'OK')
				{
					trace(App.store.getState().appWare.user.dynaMap());
					setState({
						viewClassPath:'edit',
						fields:dataAccess['edit'].view,
						values:createStateValues(App.store.getState().appWare.user.dynaMap(), dataAccess['changePassword'].view),
					 	loading:false});
				}
				else trace(data.dataErrors);				
			}
		));
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace('hi :)');
		requests.push(Loader.loadData(	
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.user_name}',
				dataSource:Serializer.run(dataAccess['edit'].source)
			},
			function(data:Array<Map<String,String>>)
			{
				trace(data);
				if (data == null)
					return;
				if (data[0].exists('ERROR'))
				{
					trace(data[0]['ERROR']);
					return;
				}
				//trace(Reflect.fields(dataRows[0]));
				//trace(dataRows[0].active);
				setState({
					//data:data[0],
					fields:dataAccess['edit'].view,
					values:createStateValues(data[0], 
					dataAccess['edit'].view), loading:false});					
			}
		));
		//setState({viewClassPath:"shared.io.User.edit"});
		//setState({viewClassPath:"auth.User.edit"});
	}
	
	override public function save(evt:Event)
	{
		evt.preventDefault();
		trace(state.data);
		trace(state.values);
		var skeys:Array<String> = untyped dataAccess['edit'].view.keys().arr;
		skeys = skeys.filter(function(k) return !dataAccess['edit'].view[k].readonly);
		trace(filterMap(state.values, skeys));
		/*var vKeys:Iterator<String> = dataAccess['edit'].view.keys();
		while (vKeys.hasNext() )
		{
			skeys.push(vKeys.next());
		}*/
		trace(skeys.toString());
		trace(dataAccess['edit'].source);
		//return;,
		requests.push(Loader.load(	
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				className:'auth.User',
				action:'save',
				filter:'user_name|${props.user_name}',
				dataSource:Serializer.run(dataAccess['edit'].source)
				//dataSource:Serializer.run(filterMap(state.values, skeys))
			},
			function(data:Array<Map<String,String>>)
			{
				trace(data);
				//props.parentForm.setStateFromChild({dataTable:data, loading:false});
				//setState({dataTable:[data], loading:false});					
			}
		));
	}
	
	public function new(?props:DataFormProps)
	{
		super(props);
		_instance = this;		
		_menuItems = [
			//{handler:edit, label:'Bearbeiten', segment:'edit'},
			{handler:save, label:'Speichern', disabled:state.clean},
			{handler:changePassword, label:'Passwort ändern'},
		];
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['user'].items = function() return _menuItems;
		ReactUtil.copy(state,{sideMenu:sideMenu,viewClassPath:"edit",});
		trace(_menuItems);
	}

	/*override function handleChange(e:InputEvent)
	{
		var t:InputElement = cast e.target;
		var vs = state.values;
		vs[t.name] = t.value;
		trace(vs.toString());

		setState({clean:false, sideMenu:updateMenu(),values:vs});
		//props.setStateFromChild({clean:false});
		//trace(this.state);
	}*/
	
	override function updateMenu():SMenuProps
	{
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['user'].items = function() {
			return switch(state.viewClassPath)
			{
				case "changePassword":		
					[
						{handler:changePassword, label:'Speichern', disabled:state.clean},
						{handler:function (_)setState({viewClassPath:'edit',clean:true}), label:'Abbrechen'},
					];
				default:
					[
						{handler:save, label:'Speichern', disabled:state.clean},
						{handler:changePassword, label:'Passwort ändern'},
					];
			}
		}				
		return sideMenu;
	}
	
	function renderContent():ReactFragment
	{
		trace(state.viewClassPath);
		return switch(state.viewClassPath)
		{
			case "edit":		
				renderElements();
			case "changePassword":
				jsx('
				<>
					${renderErrors('changePassword')}
					<div className="formField">
						<label className="required">Aktuelles Passwort</label>
						<input name="pass" type="password"  onChange=${state.handleChange} autoFocus="true" ref=${autoFocus}/>
					</div>	
					<div className="formField">
						<label className="required">Neues Passwort</label>
						<input name="new_pass" type="password" onChange=${state.handleChange}/>
					</div>				
					<div className="formField">
						<label className="required">Neues Passwort bestätigen</label>
						<input name="new_pass_confirm" type="password" onChange=${state.handleChange}/>
					</div>
				</>				
				');
			default:
				null;
		}
	}

	function renderErrors(name:String):ReactFragment
	{
		trace(name+':'+state.errors.exists(name));
		if(state.errors.exists(name))
		return jsx('
		<div  className="formField">
			${state.errors.get(name)}
		</div>
		');
		return null;
	}
	
	override function render()
	{		
		if(state.values != null)
		trace(state.values);
		return jsx('
			<div className="columns">
				<div className="tabComponentForm"  >
					<form className="form60">
						${renderContent()}
					</form>					
				</div>
				<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks} />					
			</div>	
		');
	}
	
}
