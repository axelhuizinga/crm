package model;
import action.AppAction;
import haxe.Http;
import haxe.Json;
import js.Browser;
import js.Cookie;
import js.Promise;
import view.User;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import react.router.ReactRouter;
import history.History;
import model.GlobalAppState;
import Webpack.*;

/**
 * ...
 * @author axel@cunity.me
 */

class AppService 
	implements IReducer<AppAction, GlobalAppState>
	implements IMiddleware<AppAction, AppState>
{

	public var initState:GlobalAppState = {
		config:null,
		route: Browser.location.pathname,// '',
		themeColor: 'green',
		locale: 'de',
		redirectAfterLogin: Browser.location.pathname, 
		userList:[],
		user:{
			id:App.id,
			firstName:'',
			lastName:'',
			pass:'',
			waiting:false,
			jwt:App.jwt
		}
	};
		public var store:StoreMethods<AppState>;

	var ID = 0;
	var loadPending:Promise<Bool>;
	
	public function new() 
	{
		var appCconf:Dynamic = Webpack.require('../../bin/app.config.js');
		trace('OK');
		initState.config = Reflect.field(appCconf, 'default');
		
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
			
			case LoginChange(uState):
				copy(state, {
					user:{id:uState.id, pass:uState.pass}
				});
				
			case LoginError(err):
				if(err.id==state.user.id)
					copy(state, err);
				else
					state;
					
			case LoginWait:
				copy(state, {waiting:true});
				
			case LoginComplete(uState):
				copy(state, {user:uState});
				
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
		trace(action);
		return switch(action)
		{
			case LoginReq(uState):
				//store.getState().userService.
				var n:Dynamic = next();
				trace(n);
				n;
			
			default: next();
		}
	}
	
}