//import dom.History;
import me.cunity.debug.Out;
import react.ReactMacro.jsx;
import react.ReactComponent;
import react.ReactEvent;
import redux.StoreMethods;
//import react.ReactPropTypes;
import react.React;
//import react.addon.router.Route;
//import react.addon.router.BrowserRouter;
//import react.addon.router.Link;
//import react.addon.router.Switch;
import react.addon.ReactIntl;
//import react.
import react.addon.intl.IntlProvider;
import react.addon.intl.FormattedDate;
//import react.addon.router.Router;
import redux.react.Provider;
import bulma_components.Tabs;
//import react.tabs.RoutedTabs;
//import redux.react.IConnectedComponent;

import Webpack.*;

import view.Contacts;
import view.DashBoard;
import view.QC;
import view.Statistics;
import view.UiView;

class App  extends react.ReactComponentOfState<ApplicationState>
{
    static var STYLES = require('./App.css');
	static var bulma = require('../node_modules/bulma/css/bulma.min.css');
	static var fa = require('../node_modules/font-awesome/css/font-awesome.min.css');
	
	//public static var AppContext = React.createContext(null);
	public static var store:StoreMethods<ApplicationState>;

	var backListener:Void->Void;
	var browserHistory:Dynamic;	

    public function new() {
		store = ApplicationStore.create();
		state = untyped store.getState().appWare;
		//trace(state);
		trace(Reflect.fields(state));
        super(props, state);
		//browserHistory = ReactRouter.browserHistory;//History.createHistory();
		//trace(this.state);
        //state = { route:'', themeColor:'red', locale:'de', hasError: false, history:browserHistory};
		//browserHistory = History.createBrowserHistory();
    }

    override function componentDidMount() {
		switch (state.route) {
			default:
				/*Webpack.load(DashBoard).then(function(_) { 
					setState( { component:DashBoard, route:'/dashboard' });
				});*/
				trace(state.route);
		}
    }
	
	override function   componentDidCatch(error, info) {
		// Display fallback UI
		this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		trace(error);
	  }
	// Use trace from props
	public static function edump(el:Dynamic){Out.dumpObject(el); return 'OK'; };
	
	//store={store} data-debug={edump(props)}
    override function render() {

        return jsx('
			<Provider store={store}><UiView/></Provider>			
        ');
    }

    public static function renderContent(?state:Dynamic) {
        if (state.component == null)
            return jsx('
                <span>Loading...</span>
            ');
        else
            return jsx('
                <state.component />
        ');
    }
} 
//<UiView />
/*				<Router history={browserHistory}>history={browserHistory}
					<Route to="/"><div>hi</div></Route>
				</Router>
*/