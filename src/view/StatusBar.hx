package view;

import bulma_components.*;
import react.Partial;
import react.ReactComponent.ReactComponentOfPropsAndState;
import react.ReactComponentMacro;
import react.ReactDateTimeClock;

import react.ReactMacro.jsx;
import redux.react.IConnectedComponent;
import GlobalAppState;

/**
 * ...
 * @author axel@cunity.me
 */

typedef StatusBarProps =
{
	date:Date,
	match:Dynamic
}

class StatusBar extends ReactComponentOfPropsAndState<StatusBarProps, StatusBarState>
	implements IConnectedComponent
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic)
	{
		state = App.store.getState().statusBar;
		//trace(props);
		super(props);
		trace(this.state.user);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyService(error, info);
		trace(error);
	}	
	
	public function mapState(state:AppState, props:Dynamic):Dynamic
	{
		trace(state.statusBar.route);
		if(mounted)
			this.setState(function(_):Partial<StatusBarState>{ return {
					date:state.statusBar.date, route:state.statusBar.route				
				};				
			});		
		else
			this.state = state.statusBar;
		//trace(state);
		trace(this.state.userList.length);
		return props;
	}	
	
	override public function render()
	{
		return jsx('
		<Footer>
			<div className = "statusbar">
				<span>Pfad: ${props.match.url}</span>
				<ReactDateTimeClock value={state.date}  className="flex-end" />
			</div>
		</Footer>
		');
	}
	
	
}