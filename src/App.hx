import react.ReactMacro.jsx;
import react.ReactPropTypes;
//import react.addon.ReduxAuthWrapper;
import react.addon.ReactIntl;
import react.addon.intl.ReactIntlLocaleData;
import redux.Store;

import Webpack.*;

class App {
    static var STYLES = require('./App.css');
    static var TABSTYLES = require('../node_modules/react-router-tabs/styles/react-router-tabs.css');
	
	public static var store: redux.Store <ApplicationState>; 
 
    static public function main() {
		ReactIntl.addLocaleData(ReactIntlLocaleData.de);
		store = ApplicationStore.create();
		Root.contextTypes = { store: ReactPropTypes.object };
		trace(store.getState());		
        new App();
    }

    public function new() {
        var root = createRoot();
        var rootComponent = react.ReactDOM.render(jsx('
            <Root state=${{route:"/qc"}} />
        '), root);

        #if debug
        ReactHMR.autoRefresh(rootComponent);
        #end
    } 

    function createRoot() {
        var current = js.Browser.document.getElementById('root');
        if (current != null) return current;
        current = Dom.div();
        current.id = 'root';
        Dom.body().appendChild(current);
        return current;
    }
}
