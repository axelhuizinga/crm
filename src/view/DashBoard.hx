package view;
import view.shared.io.User;

import action.AppAction;
import bulma_components.*;
import model.LocationState;
import view.shared.io.User.UserProps;
import react.Partial;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactPropTypes;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import react.router.Route;
import react.router.Redirect;
import react.router.Route.RouteRenderProps;
import react.router.Switch;
import react.router.NavLink;
import view.shared.BaseForm;
import view.shared.RouteTabProps;
import view.shared.RouteBox;
import view.LoginForm;
import react.redux.form.Control.ControlProps;
import react.redux.form.Control;
import redux.Redux;

import Webpack.*;
import model.AppState;
import view.dashboard.RolesForm;
import view.dashboard.SettingsForm;
import view.dashboard.SetUpForm;

using model.CState;

typedef DashBoardProps = 
{
	>RouteTabProps,
	?setThemeColor:Void->Dispatch,
	?isMounted:Bool,
	?connectChild:String->Void
}

typedef DashBoardState =
{
	hasError:Bool
}

//@:expose('default')
@:connect
class DashBoard extends ReactComponentOf<DashBoardProps,DashBoardState>
{
	static var user = {first_name:'dummy'};
	var mounted:Bool = false;
	var rendered:Bool = false;
	var renderCount:Int = 0;
	public function new(?props:Dynamic)
	{
		state = {hasError:false};
		trace('location.pathname:${props.history.location.pathname} match.url: ${props.match.url}');
		super(props);
		if (App.firstLoad && props.match.url == '/dashboard')
		{
			props.history.push('/dashboard/settings');
			trace('pushed2/dashboard/settings');
		}
		//trace(untyped this.state.history);
		//trace(props);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		trace(mounted);
		trace(props.history.listen);
		//this.addComponent();
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		if(mounted)
		this.setState({ hasError: true });
		trace(error);
		trace(info);
	}		
	
	override public function componentWillUnmount():Void 
	{
		trace('leaving...');
		return;
		super.componentWillUnmount();
	}
	
	static function mapDispatchToProps(dispatch:Dispatch):Dynamic
    {
		trace(dispatch + ':' + (dispatch == App.store.dispatch? 'Y':'N'));
        return {
			setThemeColor: function() dispatch(AppAction.SetTheme('violet'))//,
			//initChildren: function() dispatch()
		};
    }

	static function mapStateToProps(aState:AppState) {
			var uState:UserProps = aState.appWare.user;
			//trace(aState.appWare.compState);
			//trace(' ${aState.appWare.history.location.pathname + (aState.appWare.compState.exists('dashboard') && aState.appWare.compState.get('dashboard').isMounted ? "Y":"N")}');
			
			return {
				appConfig:aState.appWare.config,
				user_name:uState.user_name,
				pass:uState.pass,
				jwt:uState.jwt,
			//	isMounted:mounted,
				loggedIn:uState.loggedIn,
				loginError:uState.loginError,
				last_login:uState.last_login,
				first_name:uState.first_name,
				redirectAfterLogin:aState.appWare.redirectAfterLogin,
				//locationHistory:aState.appWare.history,
				waiting:uState.waiting
			};		
	}		
	
    override function render() 
	{	
		//var s:ApplicationState = untyped App.store.getState().appWare;
		//trace(this.state);
		trace(props.history.location.pathname);
		trace(props.jwt);
		if (state.hasError)
			return jsx('<h1>Fehler in ${Type.getClassName(Type.getClass(this))}.</h1>');

		return jsx('
		<>
			<div className="tabNav2" >
				<Tabs  boxed={true} >
					<ul>
						<TabLink to="/dashboard/roles" ${...props}>Benutzer</TabLink>
						<TabLink to="/dashboard/settings" ${...props}>Einstellungen</TabLink>
						<TabLink to="/dashboard/setup" ${...props}>Setup</TabLink>
					</ul>
				</Tabs>
			</div>
            <div className="tabContent2" >
				<Route path="/dashboard/roles"  {...props} component={RolesForm}/>
				<Route path="/dashboard/settings/:segment?/:action?/:id?"  {...props} component={SettingsForm}/>
				<Route path="/dashboard/setup"  {...props} component={SetUpForm}/>					
            </div>
			<StatusBar {...props}/>
		</>
			');			
    }
	
	//function internalRedirect()
	function internalRedirect(path:String = '/dashboard/settings')
	{
		props.history.push(path);
		return null;
	}
	
	function TabLink(rprops)
	{
		//trace(rprops);<Route path="/dashboard/roles"  {...props} component=${RolesForm} />
		//trace(Reflect.fields(rprops));
		//trace(rprops.children);
		return jsx('
		<li className=${rprops.location.pathname.indexOf(rprops.to) == 0 ?"is-active":""}><NavLink to=${rprops.to}>${rprops.children}</NavLink></li>
		');
	}
}
