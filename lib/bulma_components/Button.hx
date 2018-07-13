package bulma_components;

import react.ReactComponent;

/**
 * ...
 * @author axel@cunity.me
 */

@:jsRequire('bulma-components', 'Button')
@:native('Button')
@:keepSub
@:autoBuild(react.ReactMacro.buildComponent())
@:autoBuild(react.ReactTypeMacro.alterComponentSignatures())
#if (debug && react_render_warning)
@:autoBuild(react.ReactDebugMacro.buildComponent())
#end
extern class Button extends ReactComponentOfProps<ButtonProps>
{
}
typedef ButtonProps = {
	type:String,
	?icon:String,
	?iconRight:Bool
}