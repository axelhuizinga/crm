package view.shared;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;
import view.shared.RouteTabProps;

/**
 * ...
 * @author axel@cunity.me
 */

@:expose('default')
@:connect
class BaseForm extends ReactComponentOfProps<RouteTabProps> 
{

	public function new(?props:RouteTabProps, ?context:Dynamic) 
	{
		super(props);
		
	}
	
	static function mapStateToProps() {

		return function(aState:AppState) 
		{
			var uState = aState.appWare.user;
			//trace(uState);			
			return {
				appConfig:aState.appWare.config,
				id:uState.id,
				firstName:uState.firstName
			};
		};
	}	
	
    override function render() {
		trace(Reflect.fields(props));
        return jsx('
		<>
            <div className="tabComponentForm">
				...
            </div>
        </>
        ');
    }	
	
}