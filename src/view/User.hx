package view;

import react.ReactComponent;

/**
 * ...
 * @author axel@cunity.me
 */

typedef UserState =
{
	id:Int,
	?name:String,
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