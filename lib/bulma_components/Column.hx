package bulma_components;

import react.ReactComponent;

/**
 * ...
 * @author axel@cunity.me
 */

@:jsRequire('bulma-components', 'Column')
@:native('Column')
@:keepSub
@:autoBuild(react.ReactMacro.buildComponent())
@:autoBuild(react.ReactTypeMacro.alterComponentSignatures())
#if (debug && react_render_warning)
@:autoBuild(react.ReactDebugMacro.buildComponent())
#end
extern class Column extends ReactComponentOfProps<ColumnProps>
{}
typedef ColumnProps = 
{
	size:Float,
	offset:Float
}