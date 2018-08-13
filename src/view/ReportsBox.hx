package view;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import view.Reports;

/**
 * ...
 * @author axel@cunity.me
 */

class ReportsBox extends ReactComponentOfProps<Dynamic>
{

	public function new(?props:Dynamic, ?context:Dynamic) 
	{
		super(props, context);
		
	}
	
	override public function render()
	{
		//trace(props);
		//return jsx('<Reports {...props}/>');
		return jsx('<Reports {...props}/>');
	}
	
}