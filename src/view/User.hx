package view;

import react.ReactComponent;
import react.ReactMacro.jsx;
import model.UserService.UserState;

/**
 * ...
 * @author axel@cunity.me
 */

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