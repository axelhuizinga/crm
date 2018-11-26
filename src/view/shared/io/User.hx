package view.shared.io;

import haxe.Serializer;
import haxe.ds.StringMap;
import js.html.Event;
import js.html.InputEvent;
import model.AjaxLoader;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
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
		/*var vKeys:Iterator<String> = dataAccess['edit'].view.keys();
		while (vKeys.hasNext() )
		{
			skeys.push(vKeys.next());
		}
		trace(skeys.toString());*/
		//trace();
		//return;,
		requests.push(Loader.load(	
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				className:'auth.User',
				action:'save',
				filter:'user_name|${props.userName}',
				dataSource:Serializer.run(filterMap(state.values, skeys))
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
			{handler:edit, label:'Bearbeiten', segment:'edit'},
			{handler:save, label:'Speichern', disabled:state.clean},
		];
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['user'].items = function() return _menuItems;
		setState({sideMenu:sideMenu});
		trace(_menuItems);
	}
	
	override function updateMenu():SMenuProps
	{
		trace('${Type.getClassName(Type.getClass(this))} task');
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['user'].items = function() return [
			{handler:edit, label:'Bearbeiten', segment:'edit'},
			{handler:save, label:'Speichern', disabled:state.clean},
		];
		return sideMenu;
	}
	
	function renderContent():ReactFragment
	{
		return switch(state.dataClassPath)
		{
			case "userList":
				jsx('
					<Table id="userList" data=${state.data == null? null:state.dataTable}
					${...props} dataState = ${dataDisplay["userList"]} 
					className = "is-striped is-hoverable" fullWidth={true}/>				
				');				
			default:
				null;
		}
	}
	
	override function render()
	{
		if (dataAccess == null)
		{
			dataAccess = [
				'edit' =>{
					source:[
						"users" => ["alias" => 'us',
							"fields" => 'user_name,last_login'],
						"contacts" => [
							"alias" => 'co',
							"fields" => 'first_name,last_name,email',
							"jCond"=>'contact=co.id']
					],
					view:[
						'user_name'=>{label:'UserID',readonly:true, type:Hidden},
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
		}
		if(state.values != null)
		trace(state.values);
		return jsx('
		<div className="columns">
			<div className="tabComponentForm"  >
				<form className="form60">
					${renderElements()}
				</form>					
			</div>
			<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks} />					
		</div>	
		');		
	}
	
}