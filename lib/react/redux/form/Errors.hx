package react.redux.form;

import haxe.Constraints.Function;
import haxe.extern.EitherType;
import react.React.CreateElementType;
import react.ReactComponent;

typedef ErrorsProps = {
	var model:EitherType<String, Function>;
	@:optional var messages:Dynamic;
	@:optional var show:Any;
	@:optional var wrapper:CreateElementType;
	@:optional var component:CreateElementType;
}

/**
	The `<Errors />` component provides a handy way of displaying form errors
	for a given `model`.

	By default, `<Errors />` will display a `<div>` with each error message
	wrapped in a `<span>` as children.

	There are many configurable props that will let you control:
	* when error messages should be shown
	* custom error messages based on the model value
	* the wrapper component (default: `<div>`)
	* the message component (default: `<span>`)

	See https://davidkpiano.github.io/react-redux-form/docs/api/Errors.html
**/
@:jsRequire('react-redux-form', 'Errors')
extern class Errors extends ReactComponentOfProps<ErrorsProps> {}

