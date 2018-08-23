
/**
 * ...
 * @author axel@cunity.me
 */

import haxe.Timer;
import history.BrowserHistory;
import js.Cookie;
import me.cunity.debug.Out;
import model.ApplicationStore;
import model.CState;
import react.ReactMacro.jsx;
import react.ReactComponent;
import react.ReactEvent;
import redux.Store;
import redux.StoreMethods;
import react.React;
import redux.react.Provider;
import Webpack.*;
import model.AppState;
import action.AppAction;

import view.UiView;
using StringTools;

class App  extends react.ReactComponentOfState<AppState>
{
	static var bulma = require('../node_modules/bulma/css/bulma.min.css');
	static var fa = require('../node_modules/font-awesome/css/font-awesome.min.css');
    static var STYLES = require('./App.css');

	public static var store:Store<AppState>;

	public static var id:String = Cookie.get('user.id');
	public static var jwt:String = Cookie.get('user.jwt');

    public function new() {
		if (id == null || id == 'undefined' ) id = '';
		if (jwt == null || jwt == 'undefined') jwt = '';
		store = model.ApplicationStore.create();
		state = store.getState();
		CState.init(store);
		
		//state.appWare.history.listen(CState.historyChange);
		//trace(state);
		//trace(Type.typeof(state.appWare.user.jwt));
		//trace(state.appWare.user.jwt);
		trace(Reflect.fields(state));
		super();
		//trace(this.state);
        //state = { route:'', themeColor:'red', locale:'de', hasError: false, history:browserHistory};
    }

    override function componentDidMount()
	{
		var d:Date = Date.now();
		var s:Int = d.getSeconds();
		trace('start delay at $s set timer start in ${(60 - s ) } seconds');
		//return;
		Timer.delay(function(){
			trace('timer start at ${Date.now().getSeconds()}');
			store.dispatch(Tick(Date.now()));
			var t:Timer = new Timer(60000);
			t.run = function() store.dispatch(Tick(Date.now()));//this.setState({appWare:{ date: Date.now() }});
		}, (60 - d.getSeconds()) * 1000);

		trace(state.appWare.history);
    }

	override function   componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState(function(_) return {appWare:{ hasError: true }});
		// You can also log the error to an error reporting service
		trace(error);
	  }
	// Use trace from props
	public static function edump(el:Dynamic){Out.dumpObject(el); return 'OK'; };

    override function render() {
		trace(state.appWare.history.location.pathname);
        return jsx('
			<Provider store={store}><UiView store={store}/></Provider>
        ');
    }

	public static function jsxDump(el:Dynamic):String
	{
		Out.dumpObject(el);
		return 'OK';
	}
	
	public static function logOut()
	{
		trace(id);
		//return id;
	}

	public static function queryString2(params:Dynamic)
	{
		   var query = Reflect.fields(params)
					.map(function(k){
						 if (Std.is(Reflect.field(params, k), Array))
						 {
							return Reflect.field(params, k)
							  .map(function(val){
								  k.urlEncode() + '[]=' + val.urlEncode();
							  })
							  .join('&');
					 }
					 return k.urlEncode() + '=' + StringTools.urlEncode(Reflect.field(params, k));
		})
		.join('&');
		trace(query);
		return query;
	}

}
