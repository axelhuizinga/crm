package view;

import action.AppAction;
import bulma_components.*;
import react.Partial;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactPropTypes;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import react.router.Route;
import react.router.Route.RouteRenderProps;
import react.router.NavLink;
import view.shared.BaseForm;
import view.shared.RouteTabProps;
import view.LoginForm;
import react.redux.form.Control.ControlProps;
import react.redux.form.Control;
import redux.Redux;

import Webpack.*;
import AppState;

typedef DashBoardProps = 
{
	>RouteTabProps,
	?setThemeColor:Void->Dispatch
}

@:expose('default')
@:connect
class DashBoard extends ReactComponentOfProps<DashBoardProps>
{
	static var user = {firstName:'dummy'};
	var mounted:Bool = false;
	
	public function new(?props:Dynamic)
	{
		//state = App.store.getState().appWare;
		//trace(props);
		super(props);
		//trace(untyped this.state.history);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		trace(mounted);
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState({ hasError: true });
		trace(error);
	}		
	
	static function mapDispatchToProps(dispatch:Dispatch):Dynamic
    {
		trace(dispatch + ':' + (dispatch == App.store.dispatch? 'Y':'N'));
        return {
			setThemeColor: function() dispatch(AppAction.SetTheme('violet'))
		};
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
	
    override function render() 
	{	
		//var s:ApplicationState = untyped App.store.getState().appWare;
		//trace(this.state);
		trace(props);
		if (props.id == null || props.id == '' || props.jwt == null || props.jwt == '')
		{
			// WE NEED TO LOGIN FIRST
			return jsx('<LoginForm {...props}/>');
		}
		else		
        return jsx('
		<>
			<section className="tabNav2" >
			<Route path="/dashboard/roles"  {...props} >
				<Tabs  boxed={true} >
					<ul>
						<TabLink to="/dashboard/roles" ${...props}>Berechtigungen</TabLink>
					</ul>
				</Tabs>		
			</Route>
			</section>
            <div className="tabComponent" >		
			<section className="tabContent2" >
				
			</section>
            </div>
			<StatusBar {...props}/>
		</>
        ');
    }
	
	function TabLink(rprops)
	{
		//trace(rprops);<Route path="/dashboard/roles"  {...props} component=${RolesForm} />
		//trace(Reflect.fields(rprops));
		return jsx('
		<li className=${rprops.location.pathname.indexOf(rprops.to) == 0 ?"is-active":""}><NavLink to=${rprops.to}>${rprops.children}</NavLink></li>
		');
	}
}
