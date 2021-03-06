package reactable;

import haxe.extern.EitherType;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;

/**
 * ...
 * @author axel@cunity.me
 */

@:jsRequire('reactable', 'Th')
extern class Th extends ReactComponentOf<Dynamic,Dynamic>
{

	public function new(?props:Dynamic);
	
	override public function render():ReactFragment;
	
}