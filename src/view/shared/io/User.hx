package view.shared.io;

import haxe.Serializer;
import haxe.ds.StringMap;
import js.html.InputEvent;
import model.AjaxLoader;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import view.shared.SMenu;
import view.shared.io.DataAccessForm;
import view.shared.io.DataAccess.DataSource;

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
	public static var dataAccess:DataAccess = [
		'edit' =>{
			data:[
				"users" => ["alias" => 'us',
					"fields" => 'user_name,last_login'],
				"user_groups" => [
					"alias" => 'ug',
					"fields" => 'name',
					"jCond"=>'ug.id=us.user_group'],
				"contacts" => [
					"alias" => 'co',
					"fields" => 'first_name,last_name,email',
					"jCond"=>'contact=co.id']
			],
			view:[
				'user_name'=>{label:'UserID',readonly:true},
				'first_name'=>{label:'Vorname'},
				'last_name'=>{label:'Name'},
				'email' => {label:'Email'},
				'last_login'=>{label:'Letze Anmeldung',readonly:true, dataFormat:DataAccessForm.localDate}
			]
		}
	];
	
	static var _instance:User;

	public static function menuItems():Array<SMItem>
	{
		return _instance == null? [] : _instance._menuItems;
	}
	
	public var _menuItems:Array<SMItem>;
	
	override 	function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
	}
	
	public function edit(ev:ReactEvent):Void
	{
		trace('hi :)');
		requests.push(AjaxLoader.load(	
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.userName}',
				dataSource:Serializer.run(dataAccess['edit'].data)
			},
			function(data:Dynamic)
			{
				trace(data);
				if (data.rows == null)
					return;
				view = dataAccess['edit'].view;
				trace(data.rows.length);
				var dataRows:Array<Dynamic> = data.rows;
				trace(Reflect.fields(dataRows[0]));
				trace(dataRows[0].active);
				setState({data:obj2map(dataRows[0]), loading:false});					
			}
		));
		//setState({viewClassPath:"shared.io.User.edit"});
		//setState({dataClassPath:"auth.User.edit"});
	}
	
	public function save()
	{
		
	}
	
	public function new(?props:DataFormProps)
	{
		super(props);
		_instance = this;		
		_menuItems = [{handler:edit, label:'Bearbeiten', segment:'edit'}];
		//this.state = state;
		//super(props, state);
		trace(_menuItems);
		//trace(this.props);
	}
	
	override function render()
	{
		trace(state.data);
		return jsx('
			<form className="form60">
				${renderElements()}
			</form>
		');		
	}
	
}