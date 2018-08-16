package view;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import view.DashBoard;

/**
 * ...
 * @author axel@cunity.me
 */

class DashBoardBox extends ReactComponentOfProps<Dynamic>
{

	public function new(?props:Dynamic, ?context:Dynamic) 
	{
		super(props, context);
		
	}
	
	override public function render()
	{
		return jsx('<DashBoard {...props}/>');
	}
	
}