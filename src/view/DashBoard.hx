package view;

import action.AppAction;
import bulma_components.*;
import model.LocationState;
import model.UserService.UserState;
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

@:expose('default')
@:connect
class DashBoard extends ReactComponentOf<DashBoardProps,DashBoardState>
{
	static var user = {firstName:'dummy'};
	var mounted:Bool = false;
	var rendered:Bool = false;
	var renderCount:Int = 0;
	public function new(?props:Dynamic)
	{
		state = {hasError:false};
		trace('location.pathname:${props.history.location.pathname} match.url: ${props.match.url}');
		super(props);
		if (props.match.url == '/dashboard')
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
		this.setState({ hasError: true });
		trace(error);
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
			var uState:UserState = aState.appWare.user;
			trace(aState.appWare.compState);
			trace(' ${aState.appWare.history.location.pathname + (aState.appWare.compState.exists('dashboard') && aState.appWare.compState.get('dashboard').isMounted ? "Y":"N")}');
			
			return {
				appConfig:aState.appWare.config,
				userName:uState.userName,
				pass:uState.pass,
				jwt:uState.jwt,
				isMounted:(aState.appWare.compState.exists('dashboard') && aState.appWare.compState.get('dashboard').isMounted),
				loggedIn:uState.loggedIn,
				loginError:uState.loginError,
				lastLoggedIn:uState.lastLoggedIn,
				firstName:uState.firstName,
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
						<TabLink to="/dashboard/roles" ${...props}>Berechtigungen</TabLink>
						<TabLink to="/dashboard/settings" ${...props}>Einstellungen</TabLink>
						<TabLink to="/dashboard/setup" ${...props}>Setup</TabLink>
					</ul>
				</Tabs>		
			</div>
            <div className="tabContent2" >
				<Route path="/dashboard/roles"  {...props} component={RolesForm}/>
				<Route path="/dashboard/settings"  {...props} component={SettingsForm}/>
				<Route path="/dashboard/setup"  {...props} component={SetUpForm}/>
											
            </div>
			<StatusBar {...props}/>
		</>
			');
			
		/**					<Switch></Switch>{...props} 	<section className="tabContent2path="/dashboard"> </section>	<Route path="/dashboard"  {...props} ><Route path="/dashboard/roles" ><RolesForm  {...props}/></Route>
			<Switch>
				<Route path="/dashboard/settings"  {...props} component={RolesForm}/>
			</Switch>				
		 * <Route path="/dashboard/settings"  {...props} ><SettingsForm/></Route>
		 * </Route>
		 * <Route path="/dashboard/roles"  {...props} >RolesForm</Route>
				<Route path="/dashboard/settings"  {...props} component={SettingsForm} exact={true}/>
				<Route path="/dashboard/settings"  {...props} component={SettingsForm} exact={true}/>

		   			
					<Route path="/dashboard/settings"  {...props} >Settings</Route>
		**/
    }
	
	function internalRedirect()
	{
		props.history.push('/dashboard/settings');
		return null;
	}
	
	function connectChild(name:String):Void
	{
		this.addComponent();
		//props.isMounted = true;
		trace(props.isMounted);
	}
	
	function routeConnect(p:Dynamic)
	{
		//p.component = match.url.split('/')[1]
		p.connectChild = connectChild;
		trace(Reflect.fields(p));
		if (renderCount<0)
		{
			renderCount++;
			trace('renderCount:$renderCount');
			return null;
		}
		//return null;
		p.component = 'RolesForm';
		return jsx('<RouteBox {...p}/>');
	}
	
	function TabLink(rprops)
	{
		//trace(rprops);<Route path="/dashboard/roles"  {...props} component=${RolesForm} />
		//trace(Reflect.fields(rprops));
		trace(rprops.children);
		return jsx('
		<li className=${rprops.location.pathname.indexOf(rprops.to) == 0 ?"is-active":""}><NavLink to=${rprops.to}>${rprops.children}</NavLink></li>
		');
	}
}
