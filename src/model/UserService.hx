package model;

import react.ReactUtil.copy;
import redux.IReducer;
import redux.StoreMethods;

/**
 * ...
 * @author axel@cunity.me
 */

typedef UserState =
{
	id:Dynamic,
	?contact:Int,
	?firstName:String,
	?lastName:String,
	?active:Bool,
	?loggedIn:Bool,
	?lastLoggedIn:Date,
	?loginError:Dynamic,
	?jwt:String,
	?pass:String,
	?submitted:Bool
}

enum UserAction
{
	LoginReq(state:UserState);
	LoginComplete(state:UserState);
	LoginError(state:UserState);
	LogOut(state:UserState);	
}

class UserService implements IReducer<UserAction, UserState>
{
	public var initState:UserState = {
		id:'',
		pass:'',
		submitted:false,
		jwt:''			
	};
	
	public function new() {}
	
	public function reduce(state:UserState, action:UserAction):UserState
	{
		trace(action);
		return switch(action)
		{
			case LoginError(err):
				if(err.id==state.id)
					copy(state, err);
				else
					state;
			case LoginComplete(lco):
				copy(state, lco);
			default:
				state;
		}
	}
}