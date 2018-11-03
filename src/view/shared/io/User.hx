package view.shared.io;

import haxe.ds.StringMap;
import react.ReactComponent;
import react.ReactMacro.jsx;

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

typedef UserModel = StringMap<Map<String,Dynamic>>;

typedef UserFilter = Dynamic;

class User extends ReactComponentOfProps<UserProps> 
{

	public static var userModel:UserModel = [
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
				];
				
	public function new(props:UserProps)
	{
		super(props);
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