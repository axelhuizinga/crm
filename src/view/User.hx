package view;

import react.ReactComponent;
import react.ReactMacro.jsx;


/**
 * ...
 * @author axel@cunity.me
 */

typedef UserState =
{
	id:Int,
	contact:Int,
	?first_name:String,
	?last_name:String,
	?active:Bool,
	?loggedIn:Bool,
	?lastLoggedIn:Date,
	?jwt:String
}

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