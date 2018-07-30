package view;

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
import view.User;

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

typedef UiProps = 
{
	onClick: Dynamic, //ReactPropTypes.func.isRequired,
	locale: Dynamic,
	?themeColor: ReactPropTypes
}

//@:connect
//@:wrap(react.router.ReactRouter.withRouter)
class UiView extends ReactComponentOfPropsAndState<Dynamic,ApplicationState>
{
	public static var store:Store<ApplicationState>;
	
	var browserHistory:Dynamic;
	
	public function new(props:Dynamic, state:ApplicationState) {
		//this.state = {history: ReactRouter.browserHistory, route:''};?props:RouteComponentProps, 
		trace(props);	
		trace(state);	
		//this.state = {locale:props.locale, history: null, route:'', hasError:false};
        super(props,state);
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
	//return ReactChildren.only(
	//<Route path="/" component={DashBoard}/><Tabs className="is-centered" ></Tabs>
	//var e = React.createElement;
	
	var tabList:Array<Dynamic> = [
		{ 'key': 1, 'component': DashBoard, 'label': 'DashBoard', 'url': '/dashboard' },
		{ 'key': 2, 'component': Contacts, 'label': 'Contacts', 'url': '/contacts' },
		{ 'key': 3, 'component': QC, 'label': 'QC', 'url': '/qc' },
		{ 'key': 4, 'component': Accounting, 'label': 'Buchhaltung', 'url': '/accounting' },
		{ 'key': 5, 'component': Reports, 'label': 'Berichte', 'url': '/reports' },
	];
	//component=${pageWrapper}
	/*
	override function render() {
		return jsx('		
			<Router history={ReactRouter.browserHistory}>
				<Route path="/" component=$pageWrapper2>
					<Route path="/dashboard" component=${DashBoard}/>
					<Route path="/qc" component=${QC}/>
					<Route path="/contacts" component=${Contacts}/>
				</Route>  
			</Router>${pageWrapper2}
		');
	}
		override function render() {
		return jsx('		
			<$BrowserRouter>
				<$Switch>
					<$Route path="/dashboard" component=${Bundle.load(DashBoard)}/>
					<$Route path="/qc" component=${Bundle.load(QC)}/>
					<$Route path="/contacts" component=${Bundle.load(Contacts)}/>
				</$Switch>
			</$BrowserRouter><$Route path="/" component=/>
		');
	}
						<$Route path="/dashboard" component=${DashBoard}/>
					<$Route exact={true} path="/qc" component=${QC}/>
					<$Route path="/contacts" component=${Contacts}/>
			override function render() {
		return jsx('		
			<$BrowserRouter>
			 <Fragment>
				<$Switch>				
			 <NavTabs/>
					<$Route path="/dashboard" component=${DashBoard}/>
					<$Route exact={true} path="/qc" component=${QC}/>
					<$Route path="/contacts" component=${Contacts}/>
				</$Switch>
			 </Fragment>
			</$BrowserRouter>
		');
	}	
	function render2() {
		return jsx('		
			<$BrowserRouter>
			 <NavTabs/>
				<$Switch>				
					<$Route path="/dashboard" component=${Bundle.load(DashBoard)}/>
					<$Route path="/qc" component=${Bundle.load(QC)}/>
					<$Route path="/contacts" component=${Bundle.load(Contacts)}/>
				</$Switch>
			</$BrowserRouter>
		');
	}
					<$Route path="/dashboard" component=${Bundle.load(DashBoard)}/>
					<$Route path="/qc" component=${Bundle.load(QC)}/>
					<$Route path="/contacts" component=${Bundle.load(Contacts)}/>
					<$Route path="/accounting" component=${Bundle.load(Accounting)}/>
					<$Route path="/reports" component=${Bundle.load(Reports)}/>	
	*/ 
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

	override function render() {
		return jsx('		
			<$BrowserRouter>
				<$Switch>
					<NavTabs>
						<$Route path="/dashboard" component=${Bundle.load(DashBoard)}/>
						<$Route path="/qc" component=${Bundle.load(QC)}/>
						<$Route path="/contacts" component=${Bundle.load(Contacts)}/>
						<$Route path="/accounting" component=${Bundle.load(Accounting)}/>
						<$Route path="/reports" component=${Bundle.load(Reports)}/>						
					</NavTabs>
				</$Switch>
			</$BrowserRouter>
		');
	}
	
	//${props.route.path}this.props.appWare.themeColor${props.children}
	
	function renderContent() {
        if (state.component == null)
            return jsx('
                <span>Loading...</span>
            ');
        else
            return jsx('
                <state.component />
        ');
    }
	
	function navLinks(tabs:Array<Dynamic>)
	{
		//var navLinks =  tabs.map( function(tab){${navLinks(tabList)} 
		var nav =  tabs.map( function(tab){
			return jsx(
			'<ul>
				<li><a href={tab.url} key={tab.id}>{tab.label}</a></li>
			</ul>'
			);
		});
		trace(nav);
		return nav;
	}
	
	function navWrapper(tabList:Array<Dynamic>):ReactElement
	{
		//var navWrap:ReactElement = React.createElement('div', null, 'Hello World');
		//var navWrap:ReactElement = React.createElement('ul', null, navLinks(tabList));
		var navWrap:ReactElement = cast jsx('
			<ul>
					
			</ul>
		');
		trace(navWrap = React.Children.only(navWrap));
		trace(navWrap);
		trace('OK');
		return navWrap;
	}	//${props.children}
	
	/*function pageWrapper(props:RouteComponentProps)
	{
		trace(props);
		return jsx('
				<div><nav>
						<Link to="/dashboard">DashBoard</Link> 
						<Link to="/qc" >QC</Link>
						<Link to="/contacts">Contacts</Link>
					</nav>
				${props.children}
				</div>
		');
	}*/
}