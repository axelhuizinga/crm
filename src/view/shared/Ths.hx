package view.shared;

import react.ReactComponent;
import react.ReactMacro.jsx;
import reactable.Th;

/**
 * ...
 * @author axel@cunity.me
 */

class Th extends reactable.Th 
{

	public function new(?props:Dynamic) 
	{
		super(props);		
	}
	
	override public function render():ReactFragment
	{
		trace(props);
		return jsx('
				<div className="th-inner">
					<span>Test...</span>
					<span className="fa-sort"></span>
				</div>
		');
	}
	//${field.substr(0, 1).toUpperCase() + field.substr(1).toLowerCase()}
}