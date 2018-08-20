package model;

import react.ReactUtil.copy;
import redux.IReducer;
import redux.IMiddleware;
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
	?redirectAfterLogin:String,
	?waiting:Bool
}

enum UserAction
{
	LoginWait;

	LoginError(state:UserState);
	LogOut(state:UserState);	
}

class UserService implements IReducer<UserAction, UserState>
	implements IMiddleware<UserAction, model.AppState>
{
	public var initState:UserState = {
		id:'',
		pass:'',
		waiting:false,
		jwt:''			
	};
	
	public var store:StoreMethods<model.AppState>;
	
	public function new() {}
	
	public function reduce(state:UserState, action:UserAction):UserState
	{
		trace(state);
		return switch(action)
		{
			case LoginError(err):
				if(err.id==state.id)
					copy(state, err);
				else
					state;
					
			case LoginWait:
				copy(state, {waiting:true});
				
			default:
				state;
		}
	}

	public function middleware(action:UserAction, next:Void -> Dynamic)
	{
		trace(action);
		return switch(action)
		{
			/*case LoginReq(state):
				var n:Dynamic = next();
				trace(n);
				n;	*/			
			default: next();
		}
	}		
}