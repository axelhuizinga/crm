package view;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
import view.QC;

/**
 * ...
 * @author axel@cunity.me
 */

class QCBox extends ReactComponentOfProps<RouteRenderProps>
{

	public function new(?props:RouteRenderProps, ?context:Dynamic) 
	{
		super(props, context);
		
	}
	
	override public function render()
	{
		//trace(props);
		return jsx('<QC {...props}/>');
	}
	
}