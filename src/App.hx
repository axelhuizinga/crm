
/**
 * ...
 * @author axel@cunity.me
 */

import haxe.http.HttpJs;
import haxe.Json;
import history.BrowserHistory;
import history.History;
import history.Location;
import js.Cookie;
import js.Error;
import js.Promise;
import js.html.XMLHttpRequest;
import me.cunity.debug.Out;
import model.ApplicationStore;
import model.CState;
import view.User.UserProps;
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

typedef AppProps =
{
	?waiting:Bool
}

class App  extends react.ReactComponentOf<AppProps, AppState>
{
	static var _app:App;
	//static var bulma = require('../node_modules/bulma/css/bulma.min.css');
	static var fa = require('../node_modules/font-awesome/css/font-awesome.min.css');
	//static var data_table = require('../node_modules/gigatables-react/src/css/styles.css');
    static var STYLES = require('App.scss');

	public static var store:Store<AppState>;

	public static var config:Dynamic = Webpack.require('../bin/config.js').config;
	public static var userName:String = Cookie.get('user.userName');
	public static var jwt:String = Cookie.get('user.jwt');

    public function new() 
	{
		_app = this;
		//props = { waiting:true};
		trace('userName:$userName jwt:$jwt ' + (!(App.userName == '' || App.jwt == '')?'Y':'N' ));
		store = model.ApplicationStore.create();
		state = store.getState();
		CState.init(store);		
		if (!(App.userName == '' || App.jwt == ''))
		{			
			trace(props);
			var verifyRequest = new HttpJs('${App.config.api}?jwt=${App.jwt}&userName=${App.userName}&className=auth.User&action=clientVerify');
			verifyRequest.addHeader('Access-Control-Allow-Methods', "PUT, GET, POST, DELETE, OPTIONS");
			verifyRequest.addHeader('Access-Control-Allow-Origin', 'pitverwaltung.de');
			verifyRequest.withCredentials = false;
			verifyRequest.onData = function(data:String)
			{
				trace(data);
				var verifyData = Json.parse(data);
				trace(verifyData);
				if (verifyData.error != null && verifyData.error !='')
				{
					App.jwt = null;
					store.dispatch(AppAction.LoginRequired({jwt:'',loginError:verifyData.error,userName:App.userName,waiting:false}));
					//_app.props = { waiting:false};
					trace(verifyData);
				}
				else if (verifyData.data != null && verifyData.data.content == 'OK')
				{
					trace('verifyData:{verifyData.content}');
					var uState:UserProps = state.appWare.user;
					uState.waiting = false;
					store.dispatch(AppAction.LoginComplete(uState));
					//setState({appware:{user:uState}});
					//_app.props = { waiting:false}; 
				}			
			}
			verifyRequest.onError = function(msg:String)
			{
				trace(msg);
			}
			verifyRequest.request();
		}
		else
		{// WE HAVE EITHER NO JWT OR USERNAME
			store.dispatch(AppAction.LoginRequired({jwt:App.jwt,userName:App.userName,waiting:false}));
			//props = { waiting:false};
		}
		trace(config);
		trace(props);
		trace(state.appWare.user);
		
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
		//trace(state.appWare.history.location.pathname);
		trace(props);
		//trace(props.waiting);
		trace(false && state.appWare.user.waiting);
		if (false && state.appWare.user.waiting)
		{
			return jsx('
			<section className="hero is-alt is-fullheight">
			  <div className="hero-body">
			  <div className="loader"  style=${{width:'7rem', height:'7rem', margin:'auto', borderWidth:'0.58rem'}}/>
			  </div>
			</section>
			');		
		}			
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
		store.dispatch(AppAction.LogOut({userName:userName, jwt:null}));
		//_app.forceUpdate();
	}
	
	public static function logIn()
	{
		trace(userName);
		//_app.forceUpdate();
		//return userName;
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
