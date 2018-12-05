package action.async;

//import buddy.internal.sys.Js;

import haxe.Json;
import haxe.http.HttpJs;
import haxe.io.Bytes;
import js.Cookie;
import js.Syntax;
import js.html.FormData;
import me.cunity.debug.Out;
import model.AppState;

import js.html.XMLHttpRequest;

import redux.Redux.Dispatch;
import redux.thunk.Thunk;
import shared.DbData;
import view.LoginForm.LoginState;
import view.shared.BaseForm.FormState;
import view.shared.BaseForm.OneOf;
import view.shared.io.BinaryLoader;
/**
 * ...
 * @author axel@cunity.me
 */

class AsyncUserAction 
{
	public static function loginReq(props:LoginState, ?requests:Array<OneOf<HttpJs, XMLHttpRequest>>) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->model.AppState){
			trace(props);
			//trace(getState());
			if (props.pass == '' || props.user_name == '') 
				return dispatch(AppAction.LoginError({user_name:props.user_name, loginError:'Passwort und user_name eintragen!'}));
			var spin:Dynamic = dispatch(AppAction.LoginWait);
			trace(spin);
			var bL:XMLHttpRequest = BinaryLoader.create(
			'${App.config.api}', 
			{				
				user_name:props.user_name,
				jwt:props.jwt,
				className:'auth.User',
				action:'login',
				pass:props.pass
			},
			function(dBytes:Bytes)
			{
				//trace(dBytes.toString());
				var u:hxbit.Serializer = new hxbit.Serializer();
				var data:DbData = u.unserialize(dBytes, DbData);
				if (data.dataErrors.keys().hasNext())
				{
					return dispatch(AppAction.LoginError({user_name:props.user_name, loginError:data.dataErrors.iterator().next()}));
				}
				Cookie.set('user.user_name', props.user_name, null, '/');
				Cookie.set('user.jwt', data.dataInfo['jwt'], null, '/');
				trace(Cookie.get('user.jwt'));
				return dispatch(AppAction.LoginComplete(
					{user_name:props.user_name, jwt:data.dataInfo['jwt'], waiting:false}));				
			});
			if (requests != null)
			{
				requests.push(bL);
			}
			return null;
		});
	}
	
	public static function loginReq0(props:LoginState) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->model.AppState){
			//trace(props);
			//trace(getState());
			var fD:FormData = new FormData();
			fD.append('action', 'login');
			fD.append('className', 'auth.User');
			fD.append('user_name', props.user_name);
			fD.append('pass', props.pass);
			if (props.pass == '' || props.user_name == '') 
				return dispatch(AppAction.LoginError({user_name:props.user_name, loginError:'Passwort und user_name eintragen!'}));
			var req:XMLHttpRequest = new XMLHttpRequest();//,headers: {'Content-Type': 'application/json; charset=utf-8'}'Content-Type': 'application/json; charset=utf-8',
			//+ App.queryString2({action:'login', className:'auth.User', user_name:props.user_name, pass: props.pass})
			req.open('POST', '${props.api}');
			//req.setRequestHeader('Content-Type', 'application/json; charset=utf-8');
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
						return dispatch(AppAction.LoginError({user_name:props.user_name, loginError:jRes.error}));
					}
					Cookie.set('user.user_name', props.user_name, null, '/');
					Cookie.set('user.jwt', jRes.jwt, null, '/');
					trace(Cookie.get('user.jwt'));
					return dispatch(AppAction.LoginComplete({user_name:props.user_name, jwt:jRes.jwt, waiting:false}));
				} else {
					  // Otherwise reject with the status text
					  // which will hopefully be a meaningful error
					return dispatch(AppAction.LoginError({user_name:props.user_name, loginError:'?'}));
				}
			};
			var spin:Dynamic = dispatch(AppAction.LoginWait);
			req.withCredentials = true;
			//req.send(Json.stringify({action:'login', className:'auth.User', user_name:props.user_name, pass: props.pass}));
			req.send(fD);
			trace(spin);
			return spin;
		});
	}
	
	
	public static function fetched(d:Dynamic):Void
	{
		Out.dumpObject(d);
		trace(d.statusText);
	}

	public static function logOff(props:LoginState) 
	{
		return Thunk.Action(function(dispatch:Dispatch, getState:Void->model.AppState){
			trace(getState());
			if (props.user_name == '') 
				return dispatch(AppAction.LoginError({user_name:props.user_name, loginError:'UserId fehlt!'}));
			var fD:FormData = new FormData();
			fD.append('action', 'logOff');
			fD.append('className', 'auth.User');
			fD.append('user_name', props.user_name);
			var req:XMLHttpRequest = new XMLHttpRequest();
			req.open('POST', '${props.api}');
			req.onload = function()
			{
				 if (req.status == 200) {
					 // OK
					var jRes:LoginState = Json.parse( req.response);
					trace(jRes.jwt);
					Cookie.set('user.user_name', props.user_name);
					Cookie.set('user.jwt', jRes.jwt);
					trace(Cookie.get('user.jwt'));
					return dispatch(AppAction.LoginComplete({user_name:props.user_name, jwt:jRes.jwt, waiting:false}));
				} else {
					  // Otherwise reject with the status text
					  // which will hopefully be a meaningful error
					return dispatch(AppAction.LoginError({user_name:props.user_name, loginError:req.statusText}));
				}
			};
			var spin:Dynamic = dispatch(AppAction.LoginWait);
			req.send(fD);
			trace(spin);
			return spin;			
		});
	}	
}