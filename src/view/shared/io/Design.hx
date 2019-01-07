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
	?first_name:String,
	?last_name:String,
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
			?section:String,
		}

		typedef SMItem =
		{
			?dataClassPath:String,
			?className:String,
			?component:ReactComponent,
			?handler:Function,
			?section:String,
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
				user_name:props.user_name,
				jwt:props.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.user_name}',
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
		menuItems = [{handler:edit, label:'Bearbeiten', section:'edit'}];
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