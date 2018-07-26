package bulma_components;

import react.ReactComponent;
import react.ReactMacro.jsx;

/**
 * ...
 * @author axel@cunity.me
 */
@:keep
@:autoBuild(react.ReactMacro.buildComponent())
@:autoBuild(react.ReactTypeMacro.alterComponentSignatures())
@:jsRequire('reactbulma', 'Button')
extern class Button extends ReactComponent
{}
