package view;

import haxe.Timer;
import me.cunity.debug.Out;
import react.Fragment;
import react.ReactComponent.ReactFragment;
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
//import react.addon.router.Route;
import react.router.Switch;
import react.router.BrowserRouter;
//import react.addon.router.BrowserRouter;
//import react.router.Route.RouteComponentProps;
//import react.router.Route.RouteRenderProps;
import react.router.bundle.Bundle;
import bulma_components.Tabs;

import action.AppAction;
import view.ContactsBox;
import view.DashBoardBox;
import view.AccountingBox;
import view.ReportsBox;

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

@:connect
//@:wrap(react.router.ReactRouter.withRouter)
class UiView extends ReactComponentOf<Dynamic, UiState>
{
	//public static var store:Store<GlobalAppState>;
	
	var browserHistory:Dynamic;
	var dispatchInitial:Dispatch;
	
	public function new(props:Dynamic) {
		trace(Reflect.fields(props));	
		//trace(state);	
        super(props);
		//trace(this.props.appWare.user.state.lastName);	
		dispatchInitial = props.dispatch;
		//trace(this.props);	
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
	
	override function render() 
	{
		/*if (props.appWare.user == null || props.appWare.user.jwt == '')
		{
			return jsx('<LoginForm />');
	
						..<$Switch></$Switch>
				<NavTabs >							</NavTabs>		<$Route path="/login"  {...props} component=${LoginForm}/>
				<section>
				<$Route path="/dashboard" {...props} component=${NavTabs}/>		
				<$Route path="/qc" {...props} component=${NavTabs}/>		
				<$Route path="/contacts" {...props} component=${NavTabs}/>		
				<$Route path="/accounting" {...props} component=${NavTabs}/>		
				<$Route path="/reports" {...props} component=${NavTabs}/>		
			</section>
			<Switch></Switch>
				<$Route path="/" {...props} component=${AuthRoute}/>					
				<$Route path="/qc" component=${QC}/>
				<$Route path="/contacts" component=${Contacts} exact={true}/>
				<$Route path="/contacts/:contactid" component=${Contacts} exact={true}/>
				<$Route path="/accounting" component=${Accounting}/>
				<$Route path="/reports" component=${Reports}/>	<NavTabs />		<$BrowserRouter basename="/"><$Route path="/" component=${Bundle.load(LoginForm)}/>	</$BrowserRouter>
		}*/
		trace(props.dispatch == dispatchInitial);
		return jsx('		
			<$BrowserRouter basename="/">
			<>
				<$Route path="/" component=${DashBoard} exact={true}/>
				<$Route path="/dashboard" component=${DashBoard} exact={true}/>
				<$Route path="/contacts/:contactid" component=${ContactsBox} exact={true}/>
				<$Route path="/contacts" component=${view.ContactsBox} exact={true}/>
				<$Route path="/accounting" component=${AccountingBox}/>
				<$Route path="/reports" component=${Reports}/>				
			</>
			</$BrowserRouter>
		');
	}
	
	function routeBox(p):ReactFragment
	{
		trace(p);
		return jsx('
				<LoginForm/>		
		');
	}
	
	function render0() 
	{
		/*if (props.appWare.user == null || props.appWare.user.jwt == '')<LoginForm />		
		{
			return jsx('<LoginForm />');
	
						..<$Switch></$Switch>
				<NavTabs >							</NavTabs>		<$Route path="/login"  {...props} component=${LoginForm}/>
				<section>
				<$Route path="/dashboard" {...props} component=${NavTabs}/>		
				<$Route path="/qc" {...props} component=${NavTabs}/>		
				<$Route path="/contacts" {...props} component=${NavTabs}/>		
				<$Route path="/accounting" {...props} component=${NavTabs}/>		
				<$Route path="/reports" {...props} component=${NavTabs}/>		
			</section>
			<Switch></Switch>
				<$Route path="/" {...props} component=${AuthRoute}/>	
		}*/
		trace(props.dispatch == dispatchInitial);
		return jsx('		
			<$BrowserRouter basename="/">
			<>		
				<NavTabs />
				
				<$Route path="/dashboard" component=${DashBoard}/>
				<$Route path="/qc" component=${QC}/>
				<$Route path="/contacts" component=${Contacts} exact={true}/>
				<$Route path="/contacts/:contactid" component=${Contacts} exact={true}/>
				<$Route path="/accounting" component=${Accounting}/>
				<$Route path="/reports" component=${Reports}/>						
				
			</>
			</$BrowserRouter>
		');
	}	
	/**/
}