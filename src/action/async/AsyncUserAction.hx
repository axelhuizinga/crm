package action.async;

//import buddy.internal.sys.Js;

import haxe.Json;
import js.Cookie;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import view.LoginForm.LoginState;
/**
 * ...
 * @author axel@cunity.me
 */

class AsyncUserAction 
{

	public static function loginReq(props:LoginState) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(getState());
			if (props.pass == '' || props.id == '') 
				return dispatch(AppAction.LoginError({id:props.id, loginError:{requestError:'Passwort und UserId eintragen!'}}));
			
			var req:XMLHttpRequest = new XMLHttpRequest();
			req.open('GET', '${props.api}?' + App.queryString2({action:'login', className:'auth.User', id:props.id, pass: props.pass}));
			req.onload = function()
			{
				 if (req.status == 200) {
					 // OK
					var jRes:LoginState = Json.parse( req.response);
					trace(jRes.jwt);
					Cookie.set('user.id', props.id);
					Cookie.set('user.jwt', jRes.jwt);
					return dispatch(AppAction.LoginComplete({id:props.id, jwt:jRes.jwt, waiting:false}));
				} else {
					  // Otherwise reject with the status text
					  // which will hopefully be a meaningful error
					return dispatch(AppAction.LoginError({id:props.id, loginError:{requestError:req.statusText}}));
				}
			};
			var spin:Dynamic = dispatch(AppAction.LoginWait);
			req.send();
			trace(spin);
			return spin;			
		});
	}
	
}