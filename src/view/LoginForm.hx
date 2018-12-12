package view;

import js.html.InputElement;
import js.html.InputEvent;
import js.html.XMLHttpRequest;
import model.AppState;
import react.ReactComponent.ReactComponentOf;
import react.ReactMacro.jsx;
import redux.Redux;
import action.async.AsyncUserAction;
import view.shared.RouteTabProps;

typedef LoginState = 
{
	?api:Dynamic,
	?waiting:Bool,
	?error:Dynamic,
	?user_name:String,
	?pass:String,
	?jwt:String
}

typedef LoginProps =
{
	>RouteTabProps,
	submitLogin:LoginState-> Dispatch,
	api:String
}

/**
 * ...
 * @author axel@cunity.me
 */

//@:expose('default')
@:connect
class LoginForm extends ReactComponentOf<LoginProps, LoginState>
{
	
	public function new(?props:LoginProps)
	{
		trace(Reflect.fields(props));
		if (props.match != null)
		{
			trace(props.match.path + ':' + props.match.url);	
		}
		trace(props);
		state = {api:props.api,user_name:'',pass:''};
		super(props);
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
		trace(dispatch);
		return {
			submitLogin: function(lState:LoginState) return dispatch(AsyncUserAction.loginReq(lState))
		};
	}
	
	static function mapStateToProps() {

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;

			trace(uState);
			//trace(aState.appWare.config);
			
			return {
				api:aState.appWare.config.api,
				pass:uState.pass,
				jwt:uState.jwt,
				loggedIn:uState.loggedIn,
				loginError:uState.loginError,
				last_login:uState.last_login,
				first_name:uState.first_name,
				user_name:uState.user_name,
				redirectAfterLogin:aState.appWare.redirectAfterLogin,
				waiting:uState.waiting
			};
		};
	}	
	
	function handleChange(e:InputEvent)
	{
		var s:Dynamic = {};
		var t:InputElement = cast e.target;
		trace(t.name);
		trace(t.value);
		//t.className = 'input';
		Reflect.setField(s, t.name, t.value);
		trace(props.dispatch == App.store.dispatch);
		//App.store.dispatch(AppAction.LoginChange(s));
		this.setState(s);
		//trace(this.state);
	}
	
	dynamic function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
		trace(props.dispatch); //return;
		//this.setState({waiting:true});
		//props.dispatch(AppAction.Login("{user_name:state.user_name,pass:state.pass}"));
		//trace(props.dispatch);
		props.submitLogin({user_name:state.user_name, pass:state.pass,api:props.api, jwt:''});
		//trace(_dispatch == App.store.dispatch);
		//trace(App.store.dispatch(AsyncUserAction.loginReq(state)));
		//trace(props.dispatch(AppAction.LoginReq(state)));
	}	

	override public function render()
	{
		trace(Reflect.fields(props));
		var style = 
		{
			maxWidth:'32rem'
		};
		
		if (props.waiting)
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
		<section className="hero is-alt is-fullheight">
		  <div className="formContainer">
			<div className="formBox is-rounded" style=${style}>
				<div className="logo">
				<img src="img/schutzengelwerk-logo.png" style=${{width:'100%'}}/>
				  <h2 className="overlaySubTitle">				  
				  crm 2.0
				  </h2>
				</div>
				<div className="form2">
				  <form name="form" onSubmit={handleSubmit}  >
					<div className="formField">
						<label className="userIcon" forhtml="login-user_name">
							<span className="hidden">User ID</span></label>
						<input id = "login-user_name"  name = "user_name" 
							className=${errorStyle("user_name") + "form-input"}  
							placeholder="User ID" value={state.user_name} onChange={handleChange} />
					</div>
					<div className="formField">
						<label className="lockIcon" forhtml="login-pass">
							<span className="hidden">Password</span></label>
						<input id="login-pass" className=${errorStyle("pass") + "form-input"}  
							name="pass" type="password" placeholder="Password"  value={state.pass} onChange={handleChange} />					
					</div>
					<div className="formField">
						<input type="submit" value="Login"/>
					</div>
				  </form>
				</div>
			</div>
		  </div>
		</section>		
		');
	}//autoComplete="new-pass"
	
	function errorStyle(name:String):String
	{
		var eStyle = "form-input " + switch(name)
		{
			case "pass":
				var res = props.loginError == "pass"?"input error":"input";
				trace(res);
				res;
				
			case "user_name":
				props.loginError == "user_name"?"input error":"input";
			
			default:
				'';
		}
		trace(eStyle);
		return eStyle;
	}
	
}