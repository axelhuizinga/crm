package view;

//import action.async.AsyncUserAction;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.XMLHttpRequest;
import react.ReactComponent;
import react.ReactComponent.ReactComponentOf;
import react.ReactMacro.jsx;
import redux.Redux;
import react.router.Route.RouteRenderProps;
import action.async.AsyncUserAction;
import view.shared.RouteTabProps;

typedef LoginState = 
{
	//> RouteRenderProps,
	?api:Dynamic,
	//?dispatch: Dispatch,
	?waiting:Bool,
	?id:String,
	?pass:String,
	?jwt:String
}

typedef LoginProps =
{
	>RouteTabProps,
	submitLogin:LoginState->Dispatch
}

/**
 * ...
 * @author axel@cunity.me
 */

@:expose('default')
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
		state = {api:props.appConfig.api, pass:'', id:''};
		trace(props.dispatch);
		super(props);
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
		trace(dispatch);
		return {
			submitLogin: function(lState:LoginState) return dispatch(AsyncUserAction.loginReq(lState))
			//dispatch:dispatch
		};
	}
	
	static function mapStateToProps() {

		return function(aState:AppState) 
		{
			var uState = aState.appWare.user;

			trace(uState);
			
			return {
				appConfig:aState.appWare.config,
				id:uState.id,
				pass:uState.pass,
				jwt:uState.jwt,
				loggedIn:uState.loggedIn,
				loginError:uState.loginError,
				lastLoggedIn:uState.lastLoggedIn,
				firstName:uState.firstName,
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
		//props.dispatch(AppAction.Login("{id:state.id,pass:state.pass}"));
		//trace(props.dispatch);
		props.submitLogin(state);
		//trace(_dispatch == App.store.dispatch);
		//trace(App.store.dispatch(AsyncUserAction.loginReq(state)));
		//trace(props.dispatch(AppAction.LoginReq(state)));
	}	

	override public function render()
	{
		trace(Reflect.fields(props));
		var style = 
		{
			maxWidth:'22rem'
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
		  <div className="hero-body">
			<div className="container" style=${style}>
			  <article className="card is-rounded" >
				<div className="card-content">
				  <h2 className="title is-5">
				  <img src="img/schutzengelwerk-logo.png" style=${{width:'100%'}}/>
				  crm 2.0
				  </h2>
				  <form name="form" onSubmit={handleSubmit} autoComplete="new-password" >
					  <p className="control has-icon">
						<input name="id" className="input" type="text" placeholder="ViciDial User ID"  value={state.id} onChange={handleChange} />
						<i className="fa fa-user"></i>
					  </p>
					  <p className="control has-icon">
						<input name="pass" className="input" type="password" placeholder="Password"  value={state.pass} onChange={handleChange} />
						<i className="fa fa-lock"></i>
					  </p>
					  <p className="control">
						<button className="button is-medium is-fullwidth is-warning">
						  Login
						</button>
					  </p>
				  </form>
				</div>
			  </article>
			</div>
		  </div>
		</section>		
		');
	}
	
}