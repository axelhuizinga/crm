package model;
import action.AppAction;
import haxe.Http;
import haxe.Json;
import js.Browser;
import js.Promise;
import view.User;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import GlobalAppState;

/**
 * ...
 * @author axel@cunity.me
 */

class StatusBarService implements IReducer<StatusAction, StatusBarState>
	implements IMiddleware<StatusAction, AppState>
{
	public var initState:StatusBarState = {
		route: Browser.location.pathname,// '',
		date:Date.now(),
		userList:[],
		user:null
	};
	public var store:StoreMethods<AppState>;

	var ID = 0;
	var loadPending:Promise<Bool>;
	
	public function new() 
	{ 
		trace('ok');
	}
	
	public function reduce(state:StatusBarState, action:StatusAction):StatusBarState
	{
		trace(action);
		return switch(action)
		{
			case Tick(date):
				copy(state, {
					date:date
				});
			default:
				state;
		}
	}
	
	public function middleware(action:StatusAction, next:Void -> Dynamic)
	{
		//trace(action);
		return switch(action)
		{
			default: next();
		}
	}	
}