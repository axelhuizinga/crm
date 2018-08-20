package view;
import bulma_components.*;
import me.cunity.debug.Out;
import model.AppState;
import react.ReactComponent;
import react.ReactDateTimeClock;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import react.Partial;
import react.router.Route.RouteRenderProps;
import redux.react.IConnectedComponent;
import redux.StoreMethods;
import view.shared.RouteTabProps;
//import react.form.Form;
//import react.form.Text;


import Webpack.*;

@:expose('default')
@:connect
class Contacts extends ReactComponentOfProps<RouteTabProps>
	
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
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyService(error, info);
		trace(error);
	}	
	
	static function mapStateToProps() {

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;

			//trace(aState.userService);
			
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
		trace(props.match);
		trace(props.history.location.pathname);
		//Out.dumpObjectTree(props);
		trace(Reflect.fields(props));
		trace('${props.id} => ${props.jwt}' + (( props.jwt == null )?' should Login' : ' Login OK' ));
		if (props.id == null || props.id == '' || props.jwt == null || props.jwt == '')
		{
			// WE NEED TO LOGIN FIRST
			return jsx('<LoginForm  {...props}/>');
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
