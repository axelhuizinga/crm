import dom.History;
import react.ReactMacro.jsx;
import react.ReactComponent;
import react.ReactEvent;
import react.addon.ReactRouter;
import react.addon.router.Route;
import react.addon.router.Router;
import react.addon.router.BrowserRouter;
//import react.addon.router.Redirect;
import react.addon.router.Switch;
import react.addon.ReactIntl;
import react.addon.intl.IntlProvider;
import react.addon.intl.FormattedDate;
import react.addon.ReactRedux.Provider;
import react.tabs.NavTab;
import react.tabs.RoutedTabs;
//import redux.Redux.;
import redux.react.IConnectedComponent;

import ui.Contacts;
import ui.DashBoard;
import ui.QC;
import ui.Statistics;


typedef RootState = {
    route: String,
    ?component: react.React.CreateElementType
}

class Root extends react.ReactComponentOfState<RootState> implements IConnectedComponent{

	var backListener:Void->Void;
	var browserHistory:Dynamic;
	
	public function new(props:Dynamic, state:RootState, ?context:Dynamic)
	{		
		super(props, state);
		trace(props);
		trace(this.state);
		trace(this.context);
		//trace(History);
		browserHistory = History.createBrowserHistory();
		browserHistory.action = "POP";
		trace(browserHistory);
	}

    override function componentDidMount() {
		//trace(this);
		backListener = browserHistory.listen(function(location)
		{
			trace(location);
			if (location.action == "POP") {
				
				return false;
			}
			return true;
		});
		trace(backListener);
	}

	 override function componentWillUnmount() {
			super.componentWillUnmount();
			// Unbind listener
			this.backListener();
	}

	function setLocale(e:ReactEvent)
	{
		//Out.dumpObject(e);
		trace(untyped e._targetInst._node);
		e.preventDefault();
		//e.stopPropagation();
		//Out.dumpObject(e);
		return 'OK';
	}
	
	function changeLocale(e:Dynamic)
	{
		trace(e);
	}
	
	override function render() {
		var edump = function(el:Dynamic){trace(el); return 'OK'; };
		var eArray = function(el:Dynamic){trace(el.toString()); return 'OK'; };		
		return jsx('
			<Provider store=${App.store}>
				<IntlProvider locale="de">
					<Router history={browserHistory}>
						<RoutedTabs>
							<NavTab to="/dashboard">DashBoard</NavTab>
							<NavTab to="/contacts" data-debug=${edump(this.context)}>Contacts</NavTab>
							<NavTab to="/qc">QC</NavTab>
							<Switch>								
								<Route path="/dashboard" component=${DashBoard} />
								<Route path="/contacts" component=${Contacts} data-debug=${edump(this.context)} />
								<Route path = "/qc" component=${QC} />
							</Switch>
						</RoutedTabs>
					</Router>
				</IntlProvider>
			</Provider>	
        ');
    }
	
	function renderChildren(p:Dynamic)
	{
		trace(p);
		return jsx('
			<Switch>							
				<Route path = "/qc" component=${QC} />
				<Route path="/qc/something" component=${QC}/>
				<Route path="/qc/*" component=${QC}/>
			</Switch>		
		');
	}
}
/*
 * 						<Route path="/" render=${renderRedirect} />


 *<NavTab to="/statistic">Statistic</NavTab>	
 * <Route path="/" render=${renderRedirect} />
							<Route path="/dashboard" component={DashBoard} /> 
 *							<Route path="/statistic" component=${Statistics} />
 
 * ${store.getState().locale} 
 
 <NavTab to="/dashboard" > ${dashboard}</NavTab>
						<NavTab to="/dashboard" > ${dashboard}</NavTab>
						<NavTab to="/dashboard" > ${dashboard}</NavTab>
						<NavTab to="/dashboard" > ${dashboard}</NavTab><Provider store=${store}>
			<IntlProvider locale=${store.getState().locale} >
				<BrowserRouter history={browserHistory}>
					<App />
				</BrowserRouter>
			</IntlProvider>
		</Provider>*/