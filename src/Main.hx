import dom.History;
import js.Browser;
import js.html.DivElement;
import react.ReactDOM;
import react.ReactMacro.jsx;
import react.addon.router.Link;
import react.addon.router.Route;
import react.addon.router.Router;

import ui.Contacts;
import ui.Statistics;
import ui.QC;

//import react.ReactComponent;
//import react.PropTypes;

class Main
{
	/**
		Entry point:
		- setup redux store
		- setup react rendering
		- send a few test messages
	**/
	public static function main()
	{
		var root = createRoot();
		render(root);

	}

	static function createRoot()
	{
		var root = Browser.document.createDivElement();
		Browser.document.body.appendChild(root);
		return root;
	}

	static function render(root:DivElement)
	{
		//var history = ReactRouter.browserHistory;
		var history = History.createBrowserHistory();

		trace(history);

		var app = ReactDOM.render(jsx('
				<Router history={history}>
		<div>
      <ul>
        <li><Link to="/contacts">Contacts</Link></li>
        <li><Link to="/qc">QC</Link></li>
        <li><Link to="/dashboard">Dashboard</Link></li>
      </ul>

      <hr />
					<Route path="/contacts" component=${Contacts} />
					<Route path="/qc" component=${QC} />
					<Route path="/dashboard" component=${Statistics}   />
					</div>
				</Router>
		'), root);
		trace(app);
		#if (debug && react_hot)
		ReactHMR.autoRefresh(app);
		#end
	}
}
