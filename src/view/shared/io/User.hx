package view.shared.io;

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

/**
 * ...
 * @author axel@cunity.me
 */

typedef UserProps =
{
	?contact:Int,
	?firstName:String,
	?lastName:String,
	?active:Bool,
	?loggedIn:Bool,
	?lastLoggedIn:Date,
	?loginError:Dynamic,
	?jwt:String,
	?pass:String,
	userName:String,
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
							"fields" => 'user_name,change_pass_required,pass']
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
							"fields" => 'user_name,last_login,change_pass_required,pass'],
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
				userName:props.userName,
				jwt:props.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.userName}',
				dataSource:Serializer.run(dataAccess['edit'].source)				
			},
			function(dBytes:Bytes)
			{
				//trace(dBytes.toString());
				var u:hxbit.Serializer = new hxbit.Serializer();
				var data:DbData = u.unserialize(dBytes, DbData);
				trace(Reflect.fields(data));
				trace(data);
				trace(Reflect.fields(data.dataRows[0]));
				//setState({dataTable:data.dataRows, loading:false});			
				if (data.dataRows[0]['change_pass_required'] == '1')
				{
					setState({data:data.dataRows[0], dataClassPath:'changePassword',
					fields:dataAccess['changePassword'].view,
					values:createStateValues(data.dataRows[0], 
					dataAccess['changePassword'].view), loading:false});					
				}
				else setState({data:data.dataRows[0], dataClassPath:'edit',
					fields:dataAccess['edit'].view,
					values:createStateValues(data.dataRows[0], 
					dataAccess['edit'].view), loading:false});					
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
		trace(dataAccess['changePassword'].source);
		trace(state.values);
		if (state.values['new_pass'] != state.values['new_pass_confirm'])
		return setState({errors:['new_pass'=>'Passwörter stimmen nicht überein!']});
		requests.push(BinaryLoader.create(
			'${App.config.api}', 
			{				
				userName:props.userName,
				jwt:props.jwt,
				className:'auth.User',
				action:'changePassword',
				filter:'user_name|${props.userName}',
				values:['pass'=>state.values['pass'],'new_pass'=>state.values['new_pass']],
				dataSource:Serializer.run(dataAccess['changePassword'].source)				
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
				if (data.dataInfo['result'] == 'OK')
				{
					setState({data:data.dataRows[0], dataClassPath:'edit',
					fields:dataAccess['edit'].view,
					values:createStateValues(data.dataRows[0], 
					dataAccess['edit'].view), loading:false});
				}
				else trace(data.dataInfo);				
			}
		));
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace('hi :)');
		requests.push(Loader.loadData(	
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.userName}',
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
		//setState({dataClassPath:"auth.User.edit"});
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
				userName:props.userName,
				jwt:props.jwt,
				className:'auth.User',
				action:'save',
				filter:'user_name|${props.userName}',
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
			{handler:changePassword, label:'Passwort ändern', disabled:state.clean},
		];
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['user'].items = function() return _menuItems;
		ReactUtil.copy(state,{sideMenu:sideMenu,dataClassPath:"edit",});
		trace(_menuItems);
	}
	
	override function updateMenu():SMenuProps
	{
		//trace('${Type.getClassName(Type.getClass(this))} task');
		//dataClassPath:'changePassword'
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['user'].items = function() return [
			//{handler:edit, label:'Bearbeiten', segment:'edit'},
			{handler:save, label:'Speichern', disabled:state.clean},
			{handler:changePassword, label:'Passwort ändern', disabled:state.clean},
		];
		return sideMenu;
	}
	
	function renderContent():ReactFragment
	{
		return switch(state.dataClassPath)
		{
			case "edit":		
				renderElements();
			case "changePassword":
				jsx('
				<>
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
