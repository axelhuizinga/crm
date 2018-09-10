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

//@:expose('default')
//@:connect
class RolesForm extends ReactComponentOfProps<Dynamic> 
{

	public function new(?props:Dynamic) 
	{
		super(props);
		trace(Reflect.fields(props));
	}
	
	static function mapStateToProps(aState:AppState) {
		trace('?');
	
			var uState = aState.appWare.user;
			trace(uState);			
			return {
				appConfig:aState.appWare.config,
				userName:uState.userName,
				firstName:uState.firstName
			
		};
	}	
	
    override function render() {
		trace(Reflect.fields(props));
		trace(props.match);
        return jsx('
		<div className="tabComponentForm2">
			<h3>Berechtigungen</h3>
		</div>
        ');
    }	
	
}