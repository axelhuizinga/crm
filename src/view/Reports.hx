package view;

import bulma_components.*;
import react.ReactComponent;
import react.ReactDateTimeClock;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import react.Partial;
import react.router.Route.RouteRenderProps;
import view.LoginForm;
import view.shared.RouteTabProps;


import Webpack.*;


@:expose('default')
@:connect
class Reports extends ReactComponentOfProps<RouteTabProps>
	
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic, context:Dynamic)
	{
		trace(context);
		//this.state = App.store.getState().appWare;
		super(props);
		//trace(this.state);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		//trace(this.state);
		trace('Ok');
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyService(error, info);
		trace(error);
	}	
	
	static function mapStateToProps() {

		return function(aState:AppState) 
		{
			var uState = aState.appWare.user;

			//trace(uState);
			
			return {
				appConfig:aState.appWare.config,
				id:uState.id,
				pass:uState.pass,
				jwt:uState.jwt,
				loggedIn:uState.loggedIn,
				loginError:uState.loginError,
				lastLoggedIn:uState.lastLoggedIn,
				firstName:uState.firstName,
				redirectAfterLogin:aState.appWare.redirectAfterLogin,
				waiting:uState.waiting
			};
		};
	}	
	
    override function render() {
		//trace(props);
		if (props.id == null || props.id == '' || props.jwt == null || props.jwt == '')
		{
			// WE NEED TO LOGIN FIRST
			return jsx('<LoginForm {...props}/>');
		}
		else
        return jsx('
		<>
            <div className="tabComponent">
				...
            </div>
			<StatusBar {...props}/>
        </>
        ');
    }
}
