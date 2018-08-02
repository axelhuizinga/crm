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
import react.router.ReactRouter;
import history.History;
import GlobalAppState;

/**
 * ...
 * @author axel@cunity.me
 */

class AppService 
	implements IReducer<AppAction, GlobalAppState>
	implements IMiddleware<AppAction, AppState>
{
	public var initState:GlobalAppState = {
		route: Browser.location.pathname,// '',
		themeColor: 'green',
		locale: 'de',
		//history:null,
		userList:[],
		user:new User(null, {id:1000000666, contact:1000000666, first_name:'test', last_name:'agent'})
	};
	public var store:StoreMethods<AppState>;

	var ID = 0;
	var loadPending:Promise<Bool>;
	
	public function new() 
	{ 
		
	}
	
	public function reduce(state:GlobalAppState, action:AppAction):GlobalAppState
	{
		trace(action);
		return switch(action)
		{
			case Load:
				copy(state, {
					loading:true
				});
			case SetLocale(locale):
				if (locale != state.locale)
				{
					copy(state, {
						locale:locale
					});
				}
				else state;
			case SetTheme(color):
				if (color != state.themeColor)
				{
					copy(state, {
						themeColor:color
					});
				}
				else state;

			default:
				state;
		}
	}
	
	public function middleware(action:AppAction, next:Void -> Dynamic)
	{
		trace(next);
		return switch(action)
		{
			default: next();
		}
	}
	
}