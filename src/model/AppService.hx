package model;
import App;
import action.AppAction;
import haxe.Http;
import haxe.Json;
import haxe.ds.StringMap;
import js.Browser;
import js.Cookie;
import js.Promise;
import view.User;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
import react.router.ReactRouter;
import history.BrowserHistory;
import history.History;
import model.CState;
import model.GlobalAppState;
import Webpack.*;

/**
 * ...
 * @author axel@cunity.me
 */

class AppService 
	implements IReducer<AppAction, GlobalAppState>
	implements IMiddleware<AppAction, model.AppState>
{

	public var initState:GlobalAppState = {
		compState: new StringMap(),
		config:App.config,
		history:BrowserHistory.create({basename:"/", getUserConfirmation:CState.confirmTransition}),
		themeColor: 'green',
		locale: 'de',
		redirectAfterLogin: Browser.location.pathname, 
		routeHistory: new Array(),
		userList:[],
		user:{
			//id:App.id,
			firstName:'',
			lastName:'',
			userName:App.userName,
			pass:'',
			waiting:true,
			jwt:App.jwt
		}
	};
		
	public var store:StoreMethods<model.AppState>;

	var ID = 0;
	var loadPending:Promise<Bool>;
	
	public function new() 
	{
		//var appCconf:Dynamic = App.config;//Webpack.require('../../bin/config.js');
		trace('OK');
		//initState.config = Reflect.field(appCconf, 'default');		
		//initState.config = appCconf;		
		trace(initState.config);
	}
	
	public function reduce(state:GlobalAppState, action:AppAction):GlobalAppState
	{
		trace(action);
		trace(state.compState.get('dashboard'));
		return switch(action)
		{
			/*case AddComponent(path, cState):
				if (state.compState.exists(path))
				{
					var sComp:CompState = state.compState.get(path);
					sComp.lastMounted = cState.lastMounted;
				}*/
			case Load:
				copy(state, {
					loading:true
				});
			
			case LoginChange(uState):
				copy(state, {
					user:{userName:uState.userName, pass:uState.pass}
				});
			case LoginRequired(uState):
				trace(uState);
				copy(state, {
					user:uState
				});
				
			case LoginError(err):
				trace(err);
				//if(err.userName==state.user.userName)
				copy(state, {user:{loginError:err.loginError}});
				//else
					///state;
					
			case LoginWait:
				copy(state, {waiting:true});
				
			case LoginComplete(uState):
				trace(uState);
				copy(state, {user:uState});			
				
			case LogOut(uState):
				trace(uState);
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
			case AddComponent(path, cState):
				//function(){
					trace('?');
					var state:GlobalAppState = store.getState().appWare;
					if (!state.compState.exists(path))
					{
						state.compState.set(path, cState);
					}
					trace('$path isMounted:${state.compState.get(path).isMounted}');
					next();
				
				
			/*case LoginReq(uState):
				//store.getState().userService.
				var n:Dynamic = next();
				trace(n);
				n;*/
			
			default: next();
		}
	}
	
}