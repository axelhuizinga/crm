package view;

import haxe.Timer;
import me.cunity.debug.Out;
import react.Fragment;
import react.React;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactMacro.jsx;
import react.React.ReactChildren;
import react.ReactPropTypes;
import redux.react.ReactRedux.connect;
import redux.Store;
import redux.Redux;
//import router.RouteComponentProps;
import react.router.NavLink;
import react.router.Redirect;
//import react.router.RouterHistory;
import react.router.Route;
import react.router.Switch;
import react.router.BrowserRouter;
import react.router.Route.RouteComponentProps;
import react.router.Route.RouteRenderProps;
import react.router.bundle.Bundle;
import bulma_components.Tabs;

import action.AppAction;
import view.LoginForm;

/**
 * ...
 * @author axel@cunity.me
 */

typedef  NavLinks = 
{
	id:Int,
	component:ReactComponent,
	label:String,
	url:String
}

typedef UiState = 
{
	> AppState,
	hasError:Bool
}

//@:connect
//@:wrap(react.router.ReactRouter.withRouter)
class UiView extends ReactComponentOf<AppState, UiState>
{
	//public static var store:Store<GlobalAppState>;
	
	var browserHistory:Dynamic;
	
	public function new(props:Dynamic) {
		//trace(props);	
		//trace(state);	
        super(props);
		//trace(this.props.appWare.user.state.lastName);	
		trace(this.props);	
    }
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyService(error, info);
		trace(error);
	}
	  
    override function componentDidMount() {

    }
	
	var tabList:Array<Dynamic> = [
		{ 'key': 1, 'component': DashBoard, 'label': 'DashBoard', 'url': '/dashboard' },
		{ 'key': 2, 'component': Contacts, 'label': 'Contacts', 'url': '/contacts' },
		{ 'key': 3, 'component': QC, 'label': 'QC', 'url': '/qc' },
		{ 'key': 4, 'component': Accounting, 'label': 'Buchhaltung', 'url': '/accounting' },
		{ 'key': 5, 'component': Reports, 'label': 'Berichte', 'url': '/reports' },
	];

	function createRoutes()
	{
		var routes:Array<Dynamic> = tabList.map(
		function(el) {
			return jsx('
			<Route path=${el.url} component=${el.component}/>
			');
		});
		return routes;
	}
	
	/*function render2() {
		return jsx('		
			<$BrowserRouter>
				<$Switch>
					<NavTabs>
						<$Route path="/dashboard" component=${Bundle.load(DashBoard)}/>
						<$Route path="/qc" component=${Bundle.load(QC)}/>
						<$Route path="/contacts" component=${Bundle.load(Contacts)} exact={true}/>
						<$Route path="/contacts/:contactid" component=${Bundle.load(Contacts)} exact={true}/>
						<$Route path="/accounting" component=${Bundle.load(Accounting)}/>
						<$Route path="/reports" component=${Bundle.load(Reports)}/>						
					</NavTabs>debug=${App.jsxDump(props)}
				</$Switch>
			</$BrowserRouter>
		');
	}*/
	
	override function render() {
		if (props.appWare.user == null || props.appWare.user.jwt == '')
		{
			//trace(props);
			// WE NEED TO LOGIN FIRST
			return jsx('<LoginForm />');
		}
		return jsx('		
			<$BrowserRouter basename="/">
				<$Switch>
					<NavTabs >
						<$Route path="/dashboard" component=${DashBoard}/>
						<$Route path="/qc" component=${QC}/>
						<$Route path="/contacts" component=${Contacts} exact={true}/>
						<$Route path="/contacts/:contactid" component=${Contacts} exact={true}/>
						<$Route path="/accounting" component=${Accounting}/>
						<$Route path="/reports" component=${Reports}/>						
					</NavTabs>
				</$Switch>
			</$BrowserRouter>
		');
	}
}