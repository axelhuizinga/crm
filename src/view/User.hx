package view;

import react.ReactComponent;
import react.ReactMacro.jsx;

/**
 * ...
 * @author axel@cunity.me
 */

typedef UserState =
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

typedef UserFilter = Dynamic;

class User extends ReactComponentOfState<UserState> 
{

	public function new(?props:Dynamic,state:UserState)
	{
		super();
		this.state = state;
		//super(props, state);
		//trace(props);
		trace(this.state);
	}
	
	override function render()
	{
		return jsx('<div />');
	}
	
}