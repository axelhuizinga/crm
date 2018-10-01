package view;


import haxe.Timer;
import bulma_components.*;
import react.Partial;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponentMacro;
import react.ReactDateTimeClock;

import react.ReactMacro.jsx;
import redux.react.IConnectedComponent;
import redux.Redux;
import react.router.Route.RouteComponentProps;
import redux.StoreMethods;
import action.AppAction;
import model.AppState;

/**
 * ...
 * @author axel@cunity.me
 */

typedef StatusBarProps =
{
	> RouteComponentProps,
	date:Date,
	pathname:String,
	user:User,
	userList:Array<User>
}

//@:expose('default')
@:connect
class StatusBar extends ReactComponentOf<StatusBarProps,Dynamic>
	
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic)
	{
		state = {date:Date.now()};
		//trace(props);
		trace('ok');
		super(props);
		//trace(this);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		var d:Date = Date.now();
		var s:Int = d.getSeconds();
		trace('start delay at $s set timer start in ${(60 - s ) } seconds');
		//return;
		Timer.delay(function(){
			trace('timer start at ${Date.now().getSeconds()}');
			//store.dispatch(Tick(Date.now()));
			var t:Timer = new Timer(60000);
			t.run = function() this.setState({ date: Date.now() });
		}, (60 - d.getSeconds()) * 1000);
		
		//trace(props.dispatch);
	}
	
	static function mapStateToProps(state:AppState) {

		//return function(state:model.AppState) {
			//trace(state.appWare.history);
			return {
				date:state.statusBar.date,
				userList:state.appWare.userList,
				user:state.appWare.user,
				pathname: state.appWare.history.location.pathname
			};
		//};
	}

	static function mapDispatchToProps(dispatch:Dispatch, ownProps:Dynamic) {
		trace(ownProps.date);
		return {};
	}	
	
	override public function render()
	{
		var userName:String = (
		(props.user!=null && props.user.state!=null && props.user.state.firstName !=null)?
		[props.user.state.firstName , props.user.state.lastName].join(' '):'');
		var userIcon:String = 'fa fa-user';
		if (userName.length == 1){
		 userName = 'Gast';
		 userIcon = 'fa fa-user-o';
		}
		 trace(userName +':' + cast userName.length);
		return jsx('
		<Footer>
			<div className="statusbar">
				<span className="column is-one-third" > Pfad: ${props.pathname}</span>				
				<span className="column icon is-one-third">
				<i className={userIcon}></i> ${userName}
				</span>
				<ReactDateTimeClock value={state.date}  className="flex-end" />
			</div>
		</Footer>
		');
	}
	
	
}