package view;

import haxe.Timer;
import history.History;
import history.BrowserHistory;
import me.cunity.debug.Out;
import model.AppState;
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
import react.router.Route;
//import react.addon.router.Route;
import react.router.Switch;
import react.router.Router;
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
class UiView extends ReactComponentOf<Dynamic, Dynamic>
{
	//public static var store:Store<GlobalAppState>;

	var browserHistory:History;
	var dispatchInitial:Dispatch;

	public function new(props:Dynamic) {
		trace(Reflect.fields(props));
		//trace(state);
        super(props);
		state = {hasError:false};
		browserHistory = App.store.getState().appWare.history;// BrowserHistory.create({basename:"/"});
		//ApplicationStore.startHistoryListener(App.store, browserHistory);
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

	var tabList:Array<Dynamic> = [];
	/*	{ 'key': 1, 'component': DashBoard, 'label': 'DashBoard', 'url': '/dashboard' },
		{ 'key': 2, 'component': Contacts, 'label': 'Contacts', 'url': '/contacts' },
		{ 'key': 3, 'component': QC, 'label': 'QC', 'url': '/qc' },
		{ 'key': 4, 'component': Accounting, 'label': 'Buchhaltung', 'url': '/accounting' },
		{ 'key': 5, 'component': Reports, 'label': 'Berichte', 'url': '/reports' },
	];*/

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

	override function render()
	{
		trace(props.dispatch == dispatchInitial);
		if (state.hasError) {
		  return jsx('<h1>Something went wrong.</h1>');
		}
		return jsx('
			<$Router history={browserHistory} >
			<>
				<section className="topNav">
					<$Route path="/dashboard" {...props} component=${NavTabs}/>
					<$Route path="/accounting" {...props} component=${NavTabs}/>
					<$Route path="/contacts" {...props} component=${NavTabs}/>
					<$Route path="/qc" {...props} component=${NavTabs}/>
					<$Route path="/reports" {...props} component=${NavTabs}/>
				</section>
				<Switch>
				<Route path="/" component=${RedirectBox} exact={true}/>
				<Route path="/dashboard" component=${Bundle.load(DashBoardBox)}/>
				<Route path="/accounting" component=${Bundle.load(AccountingBox)}/>
				<Route path="/contacts/:id" component=${Bundle.load(ContactsBox)}/>
				<Route path="/contacts" component=${Bundle.load(ContactsBox)}/>
				<Route path="/qc" component=${Bundle.load(QCBox)}/>
				<Route path="/reports" component=${Bundle.load(ReportsBox)}/>
				</Switch>
			</>
			</$Router>
		');
	}
	/*<Route exact={true} path="/" render=${routeBox(props)} />
	 * 
	 *<Redirect from="/" to="/dashboard" exact={true}/><Route path="/dasboard" component=${Bundle.load(DashBoard)} exact={true}/>
				<Route path="/" component=${DashBoardBox} exact={true}/>
				<$Route path="/dashboard" component=${Bundle.load(DashBoard)} exact={true}/>
	 * <section>
					<$Route path="/dashboard" {...props} component=${NavTabs}/>
					<$Route path="/qc" {...props} component=${NavTabs}/>
					<$Route path="/contacts" {...props} component=${NavTabs}/>
					<$Route path="/accounting" {...props} component=${NavTabs}/>
					<$Route path="/reports" {...props} component=${NavTabs}/>
				</section>
	 * 				<$Route path="/contacts/:contactid" component=${ContactsBox} exact={true}/>
				<$Route path="/contacts" component=${ContactsBox} exact={true}/>
				<$Route path="/accounting" component=${AccountingBox}/>
				<$Route path="/reports" component=${Reports}/><Route path="/" component=${Bundle.load(DashBoardBox)} exact={true}/>
	 * */
}