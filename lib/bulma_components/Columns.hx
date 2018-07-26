package bulma_components;

import react.ReactComponent;

/**
 * ...
 * @author axel@cunity.me
 */

@:jsRequire('reactbulma', 'Columns')
@:native('Columns')
@:keepSub
@:autoBuild(react.ReactMacro.buildComponent())
@:autoBuild(react.ReactTypeMacro.alterComponentSignatures())
#if (debug && react_render_warning)
@:autoBuild(react.ReactDebugMacro.buildComponent())
#end
extern class Columns extends ReactComponentOfProps<ColumnsProps>
{
	
}
typedef ColumnsProps = {
	multiline:Bool,
	gapless:Bool,
	device:Device
}
@:enum
abstract Device(String){
	var mobile = 'mobile';
	var tablet = 'tablet';
	var desktop = 'desktop';
	var _ = '';
}