package view;

import bulma_components.*;
import react.Partial;
import react.ReactComponent.ReactComponentOfProps;
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

@:connect
class StatusBar extends ReactComponentOfProps<Dynamic>
	
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic)
	{
		//state = App.store.getState().statusBar;
		//trace(props);
		trace('ok');
		super(props);
		//trace(this);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		trace(props.dispatch);
	}
	
	static function mapStateToProps() {

		return function(state:model.AppState) {
			//trace(state.appWare.history);
			return {
				date:state.statusBar.date,
				userList:state.appWare.userList,
				user:state.appWare.user,
				pathname: state.appWare.history.location.pathname
			};
		};
	}

	static function mapDispatchToProps(dispatch:Dispatch, ownProps:Dynamic) {
		trace(ownProps.date);
		return {};
	}	
	
	override public function render()
	{
		var userName:String = [props.user.firstName , props.user.lastName].join(' ');
		var userIcon:String = 'fa fa-user';
		if (userName.length == 1){
		 userName = 'Gast';
		 userIcon = 'fa fa-user-o';
		}
		 trace(userName +':' + cast userName.length);
		return jsx('
		<Footer>
			<div className="statusbar">
				<span className="column is-one-fifth" > Pfad: ${props.pathname}</span>				
				<span className="column is-one-fifth">
				<i className={userIcon}></i> ${userName}
				</span>
				<ReactDateTimeClock value={props.date}  className="flex-end" />
			</div>
		</Footer>
		');
	}
	
	
}