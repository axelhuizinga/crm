package view;

import action.async.AsyncUserAction;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.XMLHttpRequest;
import react.ReactComponent;
import react.ReactComponent.ReactComponentOf;
import react.ReactMacro.jsx;
import redux.Redux;
import action.AppAction;
import model.UserService.UserAction;
import model.UserService.UserState;

typedef LoginProps = 
{
	> UserState,
	?appConfig:Dynamic,
	?dispatch: Dispatch
}

/**
 * ...
 * @author axel@cunity.me
 */

@:connect
//class LoginForm extends ReactComponentOfProps<RouteRenderProps>
class LoginForm extends ReactComponentOf<LoginProps,UserState>
{
	
	public function new(?props:LoginProps)
	{
		trace(props);
		super(props);
		trace(this.props);
		this.state = {
			id:props.id,
			pass:props.pass
		}

		//trace(this.state);
	}

	/*static function mapDispatchToProps(dispatch:Dispatch) {
		return {
			submitLogin: function(userState:UserState) return dispatch(AsyncUserAction.login(userState))
		};
	}*/
	
	static function mapStateToProps() {

		return function(aState:AppState) 
		{
			var uState = aState.userService;

			trace(aState.userService);
			
			return {
				appConfig:aState.appWare.config,
				id:uState.id,
				pass:uState.pass,
				jwt:uState.jwt,
				loggedIn:uState.loggedIn,
				loginError:uState.loginError,
				lastLoggedIn:uState.lastLoggedIn,
				firstName:uState.firstName
			};
		};
	}	
	
	function handleChange(e:InputEvent)
	{
		var s:Dynamic = {};
		var t:InputElement = cast e.target;
		trace(t.name);
		Reflect.setField(s, t.name, t.value);
		this.setState(s);
		trace(this.state);
	}
	
	dynamic function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
		
		//this.setState({submitted:true});
		//props.dispatch(AppAction.Login("{id:state.id,pass:state.pass}"));
		//trace(props.dispatch);
		//trace(props.dispatch == App.store.dispatch);
		var req:XMLHttpRequest = new XMLHttpRequest();
		var url:String = '${props.appConfig.api}?' + App.queryString({id:state.id, pass: state.pass});
		//var url:String = props.appConfig.api;
		//url += '?' + App.queryString({props.id, props.pass});
		req.open('GET', url);
		req.onload = function()
		{
			 if (req.status == 200) {
				 // OK
				trace(req.response);
				props.dispatch(UserAction.LoginComplete({id:state.id, jwt:req.response.jwt}));
			} else {
				  // Otherwise reject with the status text
				  // which will hopefully be a meaningful error
				props.dispatch(UserAction.LoginError({id:state.id, loginError:{requestError:req.statusText}}));
			}
		}	
		
		// Handle network errors
		req.onerror = function() {
			props.dispatch(UserAction.LoginError({id:state.id, loginError:{requestError:"Network Error"}}));
		};

		// Make the request
		req.send();		
		//props.submitLogin(state);
		//props.dispatch(AppAction.Login(state));
		//trace(props.dispatch);
		//new User(null, {id:1000000666, contact:1000000666, firstName:'test', lastName:'admin', jwt:''})
		//var me = this;
		
	}	

	override public function render()
	{
		//trace(Reflect.fields(props));
		var style = 
		{
			maxWidth:'22rem'
		};
		
		return jsx('
		<section className="hero is-alt is-fullheight">
		  <div className="hero-body">
			<div className="container" style=${style}>
			  <article className="card is-rounded" >
				<div className="card-content">
				  <h2 className="title">
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