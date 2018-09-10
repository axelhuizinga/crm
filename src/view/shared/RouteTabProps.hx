package view.shared;
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
	?userName:String,
	?contact:Int,
	?firstName:String,
	?lastName:String,
	?active:Bool,
	?loggedIn:Bool,
	?lastLoggedIn:Date,
	?loginError:Dynamic,
	?jwt:String,
	?pass:String,
	?route:String,
	?redirectAfterLogin:String,
	?waiting:Bool
}