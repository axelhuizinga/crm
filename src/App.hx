import haxe.http.HttpJs;
import js.html.ButtonElement;
import js.html.DivElement;
import view.shared.io.User;

/**
 * ...
 * @author axel@cunity.me
 */

//import haxe.http.HttpJs;
import haxe.Json;
import history.BrowserHistory;
import history.History;
import history.Location;
import js.Browser;
import js.Cookie;
import js.Error;
import js.Promise;
//import js.html.XMLHttpRequest;
import me.cunity.debug.Out;
import model.ApplicationStore;
import model.CState;
import view.shared.io.User.UserProps;
import react.ReactMacro.jsx;
import react.ReactComponent;
import react.ReactEvent;
import redux.Store;
import redux.StoreMethods;
import react.React;
import react.ReactRef;
import redux.react.Provider;
import Webpack.*;
import model.AjaxLoader;
import model.AppState;
import action.AppAction;

import view.UiView;
using StringTools;

typedef AppProps =
{
	?waiting:Bool
}

class App  extends react.ReactComponentOf<AppProps, AppState>
{
	static var _app:App;
	//public static var bulmaAccordion = require('../node_modules/bulma-extensions/bulma-accordion/dist/js/bulma-accordion.min.js');
	static var fa = require('../node_modules/font-awesome/css/font-awesome.min.css');
	//
    static var STYLES = require('App.scss');

	public static var store:Store<AppState>;

	public static var config:Dynamic = null;// Webpack.require('../bin/config.js').config;
	public static var user_name:String = Cookie.get('user.user_name');
	public static var jwt:String = Cookie.get('user.jwt');
	public static var modalBox:ReactRef<DivElement> = React.createRef();
    public function new(?props:AppProps) 
	{
		super(props);
		_app = this;
		//props = { waiting:true};
		//<div className="modal is-active"><div className="modal-background"></div><button className="modal-close is-large" aria-label="close"></button></div>
		
		/*modalBox = React.createRef();
		Browser.document.createDivElement();
		modalBox.className = 'modal';
		var bg:DivElement = Browser.document.createDivElement();
		bg.className = "modal-background";
		modalBox.appendChild(bg);
		var close:ButtonElement = Browser.document.createButtonElement();
		close.className = "modal-close is-large";
		close.setAttribute('aria-label', 'close');
		modalBox.appendChild(close);
		Browser.document.body.appendChild(modalBox);*/
		trace(modalBox);
		trace('user_name:$user_name jwt:$jwt ' + (!(App.user_name == '' || App.jwt == '')?'Y':'N' ));
		store = model.ApplicationStore.create();
		state = store.getState();
		//CState.init(store);		
		if (!(App.user_name == '' || App.jwt == ''))
		{			
			trace('clientVerify');
			var aj:HttpJs = AjaxLoader.loadData(App.config.api,
			{jwt:App.jwt, user_name:App.user_name, className:'auth.User', action:'clientVerify'}, 
			function(verifyData:Dynamic){
				trace(verifyData);
				if (verifyData.error != null && verifyData.error !='')
				{
					App.jwt = null;
					store.dispatch(AppAction.LoginRequired({jwt:'',loginError:verifyData.error,user_name:App.user_name,waiting:false}));
				}
				else if (verifyData.content != null && verifyData.content == 'OK')
				{
					trace('verifyData:{verifyData.content}');
					var uState:UserProps = {loggedIn: true, jwt:App.jwt, user_name:App.user_name};
					uState.waiting = false;
					store.dispatch(AppAction.LoginComplete(uState));
					//setState({appware:{user:uState}});
					//_app.props = { waiting:false}; 
				}		
			});
		}
		else
		{// WE HAVE EITHER NO JWT OR user_name
			store.dispatch(AppAction.LoginRequired({jwt:App.jwt,user_name:App.user_name,waiting:false}));
			//props = { waiting:false};
		}
		//trace(App.config);
		//trace(props);
		trace(state.appWare.user);
		
		//state.appWare.history.listen(CState.historyChange);
		trace(Reflect.fields(state));
    }

    override function componentDidMount()
	{
		//trace(state.appWare.history);
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
		//trace(state.appWare.history.location.pathname);	store={store}		
        return jsx('
			<Provider store={store}><UiView /></Provider>
        ');		
    }

	public static function jsxDump(el:Dynamic):String
	{
		Out.dumpObject(el);
		return 'OK';
	}
	
	public static function logOut()
	{
		Cookie.set('user.jwt', '', -10, '/');
		trace(Cookie.get('user.jwt')); 
		trace(Cookie.all());
		store.dispatch(AppAction.LogOut({user_name:user_name, jwt:''}));
		//_app.forceUpdate();
	}
	
	public static function logIn()
	{
		trace(user_name);
		//_app.forceUpdate();
		//return user_name;
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
