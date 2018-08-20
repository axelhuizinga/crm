package view.shared;
import react.router.Route.RouteRenderProps;
import redux.Redux.Dispatch;

/**
 * ...
 * @author axel@cunity.me
 */
typedef RouteTabProps =
{
	>RouteRenderProps,
	?appConfig:Dynamic,
	?dispatch:Dispatch,
	?id:Dynamic,
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