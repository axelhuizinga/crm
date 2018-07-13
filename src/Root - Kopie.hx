import react.ReactMacro.jsx;
import react.ReactComponent;
import react.ReactEvent;
import react.addon.router.Route;
import react.addon.router.BrowserRouter as Router;
import react.addon.router.Redirect;
import react.addon.router.Switch;
import react.addon.ReactIntl;
import react.addon.intl.IntlProvider;
import react.addon.intl.FormattedDate;
import react.addon.ReactRedux.Provider;
import react.tabs.NavTab;
import react.tabs.RoutedTabs;
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

	public function new(props:Dynamic, ?context:Dynamic)
	{		
		super(props, {store: App.store});
		trace(props);
		trace(this.state);
		trace(this.context);
	}

    /*override function componentDidMount() {
		switch (state.route) {
			default:
				Webpack.load(DashBoard).then(function(_) {
					setState(cast { component:DashBoard });
				});
		}
    }*/

    function renderRedirect(_) {
        return jsx('
            <Redirect to="dashboard" />
        ');
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
		return jsx('
			<Provider store=${App.store}>
				<IntlProvider locale="de">
					<Router>
						<RoutedTabs>
							<NavTab to="/dashboard">DashBoard</NavTab>
							<NavTab to="/contacts">Contacts</NavTab>
							<NavTab to="/qc">QC</NavTab>
							<Switch>
								
								<Route path="/dashboard" component=${DashBoard} />
								<Route path="/contacts" component=${Contacts} />
								<Route path = "/qc" component=${renderChildren} />
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