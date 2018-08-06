package view;

import js.html.Event;
import js.html.EventSource;
import js.html.InputElement;
import js.html.InputEvent;
import react.ReactComponent.ReactComponentOf;
import react.ReactEvent;
import react.ReactMacro.jsx;

/**
 * ...
 * @author axel@cunity.me
 */

typedef LoginState =
{
	user:Dynamic,
	pass:String,
	submitted:Bool,
	jwt:String
}

@:connect
class Login extends ReactComponentOf<Dynamic, LoginState>
{
	public function new(?props:Dynamic, state:LoginState)
	{
		super(props);
		trace(state);
		this.state = 
		{
			user:'',
			pass:'',
			submitted:false,
			jwt:''
		};
		trace(this.state);
	}
	
	dynamic function handleChange(e:InputEvent)
	{
		var s:Dynamic = {};
		var t:InputElement = cast e.target;
		//trace(e);
		Reflect.setField(s, t.name, t.value);
		this.setState(s);
		trace(this.state);
	}
	
	dynamic function handleSubmit(e:InputEvent)
	{
		e.preventDefault();
		
		this.setState({submitted:true});
		trace(this.props.dispatch);
	}

	override public function render()
	{
		trace(Reflect.fields(props));
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
				  <h1 className="title">
				  <img src="img/schutzengelwerk-logo.png" style=${{width:'100%'}}/>
				  crm 2.0
				  </h1>
				  <form name="form" onSubmit={handleSubmit}>
					  <p className="control has-icon">
						<input name="user" className="input" type="text" placeholder="ViciDial User ID"  value={state.user} onChange={handleChange} />
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