package view.shared;
import model.UserState;
import react.router.Route.RouteComponentProps;
import redux.Redux.Dispatch;

/**
 * ...
 * @author axel@cunity.me
 */
typedef RouteTabProps =
{
	>RouteComponentProps,
	?appConfig:Dynamic,
	?dispatch:Dispatch,
	user: UserState,
	?user_name:String,
	?contact:Int,
	?first_name:String,
	?last_name:String,
	?active:Bool,
	?loggedIn:Bool,
	?last_login:Date,
	?loginError:String,
	?jwt:String,
	?pass:String,
	?route:String,
	?redirectAfterLogin:String,
	?waiting:Bool
}