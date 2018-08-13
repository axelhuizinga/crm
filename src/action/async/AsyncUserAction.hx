package action.async;

//import buddy.internal.sys.Js;

import js.Promise;
import js.html.XMLHttpRequest;
import model.UserService;
import model.UserService.UserAction.*;
import model.UserService.UserState;
import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import view.LoginForm.LoginProps;
/**
 * ...
 * @author axel@cunity.me
 */

class AsyncUserAction 
{

	public static function loginReq(state:UserState, props:LoginProps) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(getState());
			if (state.pass == '' || state.id == null) 
				return dispatch(UserAction.LoginError({id:state.id, loginError:{requestError:'Passwort und UserId eintragen!'}}));
			
			var req:XMLHttpRequest = new XMLHttpRequest();
			req.open('GET', '${props.appConfig.api}?' + App.queryString({action:'login', className:'auth.User', id:state.id, pass: state.pass}));
			req.onload = function()
			{
				 if (req.status == 200) {
					 // OK
					trace(req.response);
					return dispatch(AppAction.LoginComplete({id:state.id, jwt:req.response.jwt, waiting:false}));
				} else {
					  // Otherwise reject with the status text
					  // which will hopefully be a meaningful error
					return dispatch(UserAction.LoginError({id:state.id, loginError:{requestError:req.statusText}}));
				}
			};
			var spin:Dynamic = dispatch(UserAction.LoginWait);
			req.send();
			return spin;			
		});
	}
	
}