import view.shared.FormState;
import view.shared.SMenuProps;
import react.intl.DateTimeFormatOptions.NumericFormat;
import haxe.Serializer;
import js.html.BodyElement;
//import js.html.svg.Document;
import haxe.Constraints.Function;
import js.html.TimeElement;
import haxe.Timer;
import haxe.ds.List;
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
import haxe.io.Bytes;
import history.BrowserHistory;
import history.History;
import history.Location;
import js.Browser;
import js.Cookie;
import js.Error;
import js.Promise;
import js.html.XMLHttpRequest;
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
import shared.DbData;
import shared.DBMetaData;
import Webpack.*;

import react.intl.DateTimeFormatOptions.NumericFormat.Numeric;
import react.intl.ReactIntl;
import react.intl.comp.IntlProvider;
import model.AppState;
import view.shared.io.BinaryLoader;
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
	//static var rt = require('../res/react-table.css');
	//static var rt = require('../node_modules/react-table/src/index.styl');

    static var STYLES = require('App.scss');

	public static var store:Store<AppState>;
	public static var devIP = Webpack.require('../webpack.local.js').ip;
	public static var config:Dynamic = Webpack.require('../httpdocs/config.js').config;
	public static var sprintf:Function = Webpack.require('sprintf-js').sprintf;
	//public static var user_name:String = Cookie.get('user.user_name');
	//public static var jwt:String = Cookie.get('user.jwt');
	public static var modalBox:ReactRef<DivElement> = React.createRef();
	public static var onResizeComponents:List<Dynamic> = new List();
	//public static var firstLoad:Bool;

    public function new(?props:AppProps) 
	{
		super(props);
		//trace(rt);
		ReactIntl.addLocaleData({locale:'de'});
		_app = this;
		var ti:Timer = null;
		Browser.window.onresize = function ()
		{
			if(ti!=null)
				ti.stop();
			ti = Timer.delay(function ()
			{
				if(onResizeComponents.isEmpty())
					return;
				var cpi:Iterator<Dynamic>=onResizeComponents.iterator();
				while (cpi.hasNext())
				{
					cpi.next().layOut();
				}
			},250);
		}
		trace(modalBox);
		//trace('user_name:$user_name jwt:$jwt ' + (!(App.user_name == '' || App.jwt == '')?'Y':'N' ));
		store = model.ApplicationStore.create();
		state = store.getState();
		CState.init(store);		
		if (!(state.appWare.user.user_name == '' || state.appWare.user.jwt == ''))
		{			
			trace('clientVerify');
			var bL:XMLHttpRequest = BinaryLoader.create(
			'${state.appWare.config.api}', 
			{				
				user_name:state.appWare.user.user_name,
				jwt:state.appWare.user.jwt,
				className:'auth.User',
				action:'clientVerify',
				filter:'user_name|${state.appWare.user.user_name}',//LOGIN NAME
				dataSource:Serializer.run([
					"users" => ["alias" => 'us',
						"fields" => 'user_name,last_login'],
					"contacts" => [
						"alias" => 'co',
						"fields" => 'first_name,last_name,email',
						"jCond"=>'contact=co.id']
				]),
				devIP:devIP
			},			
			function(data:DbData)
			{
				//trace(dBytes.toString());
				//trace(data.dataInfo);
				if (data.dataErrors.keys().hasNext())
				{
					trace(data.dataErrors);
					return store.dispatch(AppAction.LoginError(
						{user_name:state.appWare.user.user_name, loginError:data.dataErrors.iterator().next()}));
				}	
				var uState:UserProps = data.dataInfo['user_data'];
				uState.waiting = false;
				return store.dispatch(AppAction.LoginComplete(uState));			
			});					
		}
		else
		{// WE HAVE EITHER NO VALID JWT OR user_name
			trace('LOGIN required');
			store.dispatch(AppAction.LoginRequired(state.appWare.user));
			//props = { waiting:false};
		}
		//trace(App.config);
		//trace(props);
		trace(state.appWare.user.jwt);
		
		//state.appWare.history.listen(CState.historyChange);
		trace(Reflect.fields(state));
    }

    override function componentDidMount()
	{
		//trace(state.appWare.history);
		trace('yeah');
    }

	override function   componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState(function(_) return {appWare:{ hasError: true }});
		// You can also log the error to an error reporting service
		trace(error);
	  }
	
	override function componentDidUpdate(prevProps:Dynamic, prevState:Dynamic)
	{
		trace('...'); 
		//firstLoad = false;
	}
	// Use trace from props
	public static function edump(el:Dynamic){Out.dumpObject(el); return 'OK'; };

    override function render() {
		//trace(state.appWare.history.location.pathname);	store={store}		
		//trace('OK');
        return jsx('
		<>
			<Provider store={store}><IntlProvider locale="de"><UiView/></IntlProvider></Provider>
		</>			
        ');		//nn<div className="modal" ref=${App.modalBox}/>
    }

	public static function 	await(delay:Int, check:Function, cb:Function):Timer
	{
		var max:Int = 15;  
		var ti:Timer = Timer.delay(function ()
		{			
			trace(max);
			if(max--<0)
				return;
			if(check())
				cb();		
			else
				await(delay, check, cb);
		},delay);
		trace(max);
		return  ti;
	}

	public static function initEState(?e:Dynamic)
	{
		var fS:FormState =
		{
			clean: true,
			hasError: false,
			mounted: false,
			sideMenu: {}
		};
		if(e != null)
		{
			for(f in Reflect.fields(e))
			{
				Reflect.setField(fS, f, Reflect.field(e, f));
			}
		}
		return fS;
	}

	public static function jsxDump(el:Dynamic):String
	{
		Out.dumpObject(el);
		return 'OK';
	}
	
	public static function logOut()
	{
		Cookie.set('user.jwt', '', -10, '/');
		//trace(Cookie.get('user.jwt')); 
		trace(Cookie.all());
		store.dispatch(AppAction.LogOut({jwt:'', user_name: store.getState().appWare.user.user_name }));
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
