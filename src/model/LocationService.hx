package model;
import action.AppAction;
import action.LocationAction;
import haxe.Http;
import haxe.Json;
import history.History;
import history.Location;
import js.Browser;
import js.Promise;
import react.ReactUtil;
import redux.Redux;
import redux.Redux.Dispatch;
import view.shared.io.User;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import model.LocationState;


/**
 * ...
 * @author axel@cunity.me
 */

class LocationService implements IReducer<LocationAction, LocationState>
	implements IMiddleware<LocationAction, model.AppState>
{
	public var initState:LocationState = {
		history:null
	}
	/*public var initState:Location = {
		pathname: Browser.location.pathname,
		search: Browser.location.search,
		hash: Browser.location.hash,
		key: 'init_1',
		state: null
	};*/
	
	public var store:StoreMethods<model.AppState>;

	var ID = 0;
	var loadPending:Promise<Bool>;
	var history: History;
	
	public function new() 
	{ 
		trace('ok');
	}	
	
	public function reduce(state:LocationState, action:LocationAction):LocationState
	{
		trace(state);
		return switch(action)
		{
			case InitHistory(history):
				copy(state, history);
				
			case LocationChange(location):
				state;
				//copy(state, location);
			default:
				state;
		}
	}
	
	public function middleware(action:LocationAction, next:Void -> Dynamic):Dynamic
	{
		trace(action);
		return switch(action)
		{
			/*case Push(url, state):
				history.push(url, state);
				{};
			case Replace(url, state):
				history.replace(url, state);
				{}
			case Go(to):
				history.go(to);
				{}
			case Back:
				history.goBack();
				{};
			case Forward:
				history.goForward();
				{};*/
			default:
				next();
		}
	}	
}