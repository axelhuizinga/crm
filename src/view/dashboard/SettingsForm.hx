package view.dashboard;

import model.AppState;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import view.shared.RouteTabProps;

/**
 * ...
 * @author axel@cunity.me
 */

@:connect
class SettingsForm extends ReactComponentOfProps<RouteTabProps> 
{

	public function new(?props:RouteTabProps, ?context:Dynamic) 
	{
		super(props);		
	}
	
	static function mapStateToProps() {

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			//trace(uState);			
			return {
				appConfig:aState.appWare.config,
				userName:uState.userName,
				firstName:uState.firstName
			};
		};
	}	
	
    override public function render() {
		trace(Reflect.fields(props));
		trace(props.history == App.store.getState().appWare.history);
        return jsx('
			<div className="tabComponentForm">
				<h3>Einstellungen</h3>
			</div>
        ');
    }	
	
}