package action.async;

//import buddy.internal.sys.Js;

import js.html.XMLHttpRequest;
import model.UserService;
import model.UserService.UserAction.*;
import model.UserService.UserState;
import redux.Redux.Dispatch;
import redux.thunk.Thunk;

/**
 * ...
 * @author axel@cunity.me
 */

class AsyncUserAction 
{

	public static function login(userState:UserState) 
	{
		//if (userState.pass == '' || userState.id == null) return null;
		

		return Thunk.Action(function(dispatch:Dispatch, getState:Void->AppState){
			trace(getState());
			/*var req:XMLHttpRequest = new XMLHttpRequest();
			req.open('GET', '');
			req.onload = function()
			{
				 if (req.status == 200) {
					 // OK
					trace(req.response);
					return dispatch(UserAction.LoginComplete({id:userState.id, jwt:req.response.jwt}));
				} else {
					  // Otherwise reject with the status text
					  // which will hopefully be a meaningful error
					return dispatch(UserAction.LoginError({id:userState.id, loginError:{requestError:req.statusText}}));
				}
			}*/
			return null;
		});
	}
	
}