package action.async;

//import buddy.internal.sys.Js;

import haxe.Json;
import js.Cookie;
import model.AppState;

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
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->model.AppState){
			trace(props);
			//trace(getState());
			if (props.pass == '' || props.userName == '') 
				return dispatch(AppAction.LoginError({userName:props.userName, loginError:'Passwort und UserName eintragen!'}));
			
			var req:XMLHttpRequest = new XMLHttpRequest();
			req.open('GET', '${props.api}?' + App.queryString2({action:'login', className:'auth.User', userName:props.userName, pass: props.pass}));
			req.setRequestHeader('Access-Control-Allow-Methods', "PUT, GET, POST, DELETE, OPTIONS");
			req.setRequestHeader('Access-Control-Allow-Origin','*');
			req.onload = function()
			{
				 if (req.status == 200) {
					 // OK
					var jRes:LoginState = Json.parse( req.response);
					trace(jRes);
					if (jRes.error != null)
					{
						return dispatch(AppAction.LoginError({userName:props.userName, loginError:jRes.error}));
					}
					Cookie.set('user.userName', props.userName, null, '/');
					Cookie.set('user.jwt', jRes.jwt, null, '/');
					trace(Cookie.get('user.jwt'));
					return dispatch(AppAction.LoginComplete({userName:props.userName, jwt:jRes.jwt, waiting:false}));
				} else {
					  // Otherwise reject with the status text
					  // which will hopefully be a meaningful error
					return dispatch(AppAction.LoginError({userName:props.userName, loginError:'?'}));
				}
			};
			var spin:Dynamic = dispatch(AppAction.LoginWait);
			req.send();
			trace(spin);
			return spin;			
		});
	}

	public static function logOff(props:LoginState) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->model.AppState){
			trace(getState());
			if (props.userName == '') 
				return dispatch(AppAction.LoginError({userName:props.userName, loginError:'UserId fehlt!'}));
			
			var req:XMLHttpRequest = new XMLHttpRequest();
			req.open('GET', '${props.api}?' + App.queryString2({action:'logout', className:'auth.User', userName:props.userName, pass: props.pass}));
			req.onload = function()
			{
				 if (req.status == 200) {
					 // OK
					var jRes:LoginState = Json.parse( req.response);
					trace(jRes.jwt);
					Cookie.set('user.userName', props.userName);
					Cookie.set('user.jwt', jRes.jwt);
					return dispatch(AppAction.LoginComplete({userName:props.userName, jwt:jRes.jwt, waiting:false}));
				} else {
					  // Otherwise reject with the status text
					  // which will hopefully be a meaningful error
					return dispatch(AppAction.LoginError({userName:props.userName, loginError:req.statusText}));
				}
			};
			var spin:Dynamic = dispatch(AppAction.LoginWait);
			req.send();
			trace(spin);
			return spin;			
		});
	}	
}