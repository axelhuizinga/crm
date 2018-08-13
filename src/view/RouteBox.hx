package view;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro;
import view.LoginForm;

/**
 * ...
 * @author axel@cunity.me
 */

class RouteBox extends ReactComponentOfProps<Dynamic>
{

	public function new(?props:Dynamic, ?context:Dynamic) 
	{
		super(props, context);
		
	}
	
	override public function render()
	{
		trace(props);
		return ReactMacro.jsx('<LoginForm/>');
	}
	
}