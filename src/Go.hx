import haxe.Log;
import js.Browser;
import js.Cookie;
import js.html.DivElement;
import me.cunity.debug.Out;
import react.ReactDOM;
import react.ReactMacro.jsx;

class Go
{

	public static function main()
	{
		Log.trace = Out._trace;
		trace('hi :)');
		App.config = Webpack.require('../bin/config.js').config;
		App.userName = Cookie.get('user.userName');
		App.jwt = Cookie.get('user.jwt');


		if (App.userName == null || App.userName == 'undefined' ) App.userName = '';
		if (App.jwt == null || App.jwt == 'undefined') App.jwt = '';
		
		//store = model.ApplicationStore.create();
		//state = store.getState();
		//CState.init(store);
		trace(App.config);
		
		render(createRoot());
	}

	static function createRoot():DivElement
	{
		var root:DivElement = Browser.document.createDivElement();
		root.className = 'rootBox';
		Browser.document.body.appendChild(root);
		return root;
	}

	static function render(root:DivElement)
	{

		var app = ReactDOM.render(jsx('
					<App/>
		'), root);
		
		//trace(app);
		
		#if (debug && react_hot)
		trace('calling ReactHMR.autoRefresh');
		ReactHMR.autoRefresh(app);
		#end
	}
}
