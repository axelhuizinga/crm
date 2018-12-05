package view;
import view.shared.io.User;

import comments.StringTransform;
import haxe.Timer;
import history.History;
import history.BrowserHistory;
import me.cunity.debug.Out;
import model.AppState;
import model.GlobalAppState;
import view.shared.io.User.UserProps;
import react.Fragment;
import react.ReactComponent.ReactFragment;
import react.React;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactMacro.jsx;
import react.React.ReactChildren;
import react.ReactPropTypes;
import react.ReactRef;
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
import react.router.Route.RouteRenderProps;
import react.router.bundle.Bundle;
import bulma_components.Tabs;

import action.AppAction;
//import view.ContactsBox;
//import view.DashBoardBox;
//import view.AccountingBox;
//import view.ReportsBox;

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

typedef UIProps =
{
	?store:Store<AppState>,
	?user:UserProps
}


@:connect
class UiView extends ReactComponentOf<UIProps, Dynamic>
{
	var browserHistory:History;
	var dispatchInitial:Dispatch;
	var mounted:Bool;
	//static var _me:UiView;

	static function mapStateToProps(aState:AppState) {
			trace(aState.appWare.user);
			var p:Dynamic = {
				user:aState.appWare.user
			};
			trace(p);
			return {
				user:aState.appWare.user
			};
	}
	
	public function new(props:Dynamic) {
		trace(Reflect.fields(props));
		trace(props.store == App.store);
        super(props);
		state = {hasError:false};
		browserHistory = App.store.getState().appWare.history;// BrowserHistory.create({basename:"/"});
		//ApplicationStore.startHistoryListener(App.store, browserHistory);
		//trace(this.props.appWare.user.state.last_name);
		mounted = false;
		//_me = this;
		App.modalBox = React.createRef();
    }

	override function componentDidCatch(error, info) {
		// Display fallback UI
		if(mounted)
		this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyService(error, info);
		trace(error);
	}

    override function componentDidMount() {
		mounted = true;
    }
	override function componentDidUpdate(prevProps:Dynamic, prevState:Dynamic)//,snapshot:Dynamic
	{
		trace(prevState);
		trace(prevProps);
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
		trace(props.user);
		if (state.hasError) {
		  return jsx('<h1>Something went wrong.</h1>');
		}
		if (false && props.user.waiting)
		{
			return jsx('
			<section className="hero is-alt is-fullheight">
			  <div className="hero-body">
			  <div className="loader"  style=${{width:'7rem', height:'7rem', margin:'auto', borderWidth:'0.58rem'}}/>
			  </div>
			</section>
			');		
		}
		
		//if(props.user.user_name == null || props.user.user_name == '' || props.user.jwt == null || props.user.jwt == '')
		if(props.user.jwt == null || props.user.jwt == '')
		{
			// WE NEED TO LOGIN FIRST
			return jsx('<LoginForm {...props.user}/>');
		}
		else
		{			
			trace('render Router :)');
			return jsx('
			<$Router history={browserHistory} >
			<>
			<div class="modal" ref=${App.modalBox}/>
				<div className="topNav">
					<$Route path="/dashboard" {...props} component=${NavTabs}/>
					<$Route path="/accounting" {...props} component=${NavTabs}/>
					<$Route path="/contacts" {...props} component=${NavTabs}/>
					<$Route path="/qc" {...props} component=${NavTabs}/>
					<$Route path="/reports" {...props} component=${NavTabs}/>
				</div>
				<div className="tabComponent">
					<Route path="/"  component={RedirectBox} exact={true}/>				
					<Route path="/dashboard" exact={true} component=${DashBoard}/>
					<Route path="/dashboard/*" component=${DashBoard}/>
					<Route path="/accounting" component=${Bundle.load(Accounting)}/>
					<Route path="/contacts/edit/:id" component=${Bundle.load(Contacts)}/>
					<Route path="/contacts" component=${Bundle.load(Contacts)}/>
					<Route path="/qc" component=${Bundle.load(QC)}/>
					<Route path="/reports" component=${Bundle.load(Reports)}/>
				</div>
			</>
			</$Router>
			');
		}
		
	}
	
	function renderRedirect(p:Dynamic)
	{
		return jsx('<RedirectBox {...p}/>');
	}
	/*<Route exact={true} path="/" render=${routeBox(props)} />a="1"
	 * <Redirect path="/dashboard" to="/dashboard/roles" exact={true}/>
	 * 				<div className="tabComponent">
				<Route path="/"  component={RedirectBox} exact={true}/>
				<Route path="/dashboard" component=${Bundle.load(DashBoardBox)}/>
				<Route path="/accounting" component=${Bundle.load(AccountingBox)}/>
				<Route path="/contacts/edit/:id" component=${Bundle.load(ContactsBox)}/>
				<Route path="/contacts" component=${Bundle.load(ContactsBox)}/>
				<Route path="/qc" component=${Bundle.load(QCBox)}/>
				<Route path="/reports" component=${Bundle.load(ReportsBox)}/>
				</div>
								<div className="tabComponent">
				<Route path="/"  component={RedirectBox} exact={true}/>
				<Route path="/dashboard" component=${DashBoardBox}/>
				<Route path="/accounting" component=${AccountingBox}/>
				<Route path="/contacts/edit/:id" component=${ContactsBox}/>
				<Route path="/contacts" component=${ContactsBox}/>
				<Route path="/qc" component=${QCBox}/>
				<Route path="/reports" component=${ReportsBox}/>
				</div>
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