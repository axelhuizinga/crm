package view;

import react.ReactComponent;

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
	?lastLoggedIn:Date
}

class User extends ReactComponentOfState<UserState> 
{

	public function new(props:Dynamic, state:UserState, ?context:Dynamic)
	{
		super(null, state);
		trace(props);
		trace(state);
	}
	
}