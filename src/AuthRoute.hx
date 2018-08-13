package;

import history.Location;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponentMacro;
import react.ReactMacro.jsx;
import react.router.Redirect;
import react.router.Route;
import react.router.Route.RouteRenderProps;
import redux.react.IConnectedComponent;
import redux.Redux;
import model.UserService.UserState;
import view.LoginForm;
/**
 * ...
 * @author axel@cunity.me
 */

typedef AuthRouteProps =
{
	> RouteRenderProps,
	?dispatch:Dispatch,
	id:Int,
	jwt:String,
	?location:Location,
	redirectAfterLogin:String
}
 
@:connect
class AuthRoute extends ReactComponentOf<AuthRouteProps,UserState>
{
	public function new(?props:AuthRouteProps)
	{
		trace(props.location.pathname);
		super(props);
		//trace(this.props);
		/*this.state = {
			//id:props.id,
			//jwt:props.jwt,
			redirectAfterLogin:props.match.url
		}*/

		//trace(this.state);
	}
	
	static function mapStateToProps() {

		return function(appState:AppState) 
		{
			var aState = appState.appWare;

			trace(appState.appWare);
			
			return {
				appConfig:aState.config,
				id:aState.user.id,
				pass:aState.user.pass,
				jwt:aState.user.jwt,
				loggedIn:aState.user.loggedIn,
				loginError:aState.user.loginError,
				lastLoggedIn:aState.user.lastLoggedIn,
				firstName:aState.user.firstName,
				waiting:aState.user.waiting
			};
		};
	}	
	
	static function mapDispatchToProps(dispatch:Dispatch, ownProps:Dynamic) {
		trace(ownProps);
		return {dispatch:dispatch};
		/*	onTodoClick: function(id:Int) return dispatch(AppAction.SetTheme('orange'))
		};*/
	}
	
	override public function render() 
	{
		trace(props.location.pathname + ':' + props.id);
		if (props.location.pathname == '/login')
			return null;
		if (props.id == null || props.jwt == '')
		{
			// WE NEED TO LOGIN FIRST
			return jsx('<LoginForm />');
		}
		else
			return jsx('<Redirect to=${props.match.url} />');
		
	}
	
}