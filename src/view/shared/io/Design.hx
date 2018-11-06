package view.shared.io;

import haxe.ds.StringMap;
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
				[
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
				]
			],
			view:[
			]
		}
	];
	
	public var menuItems:Array<SMItem>;// = [];
	

	/*public static var userModel:UserModel = ;

		typedef SMenuBlock =
		{
			?dataClassPath:String,
			?className:String,
			?onActivate:Function,
			?img:String,
			?info:String,
			?isActive:Bool,
			items:Array<SMItem>,
			?label:String,	
			?segment:String,
		}

		typedef SMItem =
		{
			?dataClassPath:String,
			?className:String,
			?component:ReactComponent,
			?handler:Function,
			?segment:String,
			?img:String,
			?info:String,
			?label:String,	
		}
 
				*/	
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
				dataSource:Serializer.run(view.shared.io.User.userModel)
			},
			function(data:Dynamic )
			{
				if (data.rows == null)
					return;
				trace(data.rows.length);
				var dataRows:Array<Dynamic> = data.rows;
				trace(Reflect.fields(dataRows[0]));
				trace(dataRows[0].active);
				setState({data:['accountData'=>dataRows], loading:false});					
			}
		));
		setState({dataClassPath:"auth.User.edit"});
	}
	
	public function new(props:UserProps)
	{
		super(props);
		menuItems = [{handler:edit, label:'Bearbeiten', segment:'edit'}];
		//this.state = state;
		//super(props, state);
		//trace(props);
		trace(this.props);
	}
	
	override function render()
	{
		return jsx('<div />');
	}
	
}