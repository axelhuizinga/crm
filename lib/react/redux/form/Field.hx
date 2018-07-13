package react.redux.form;

import haxe.Constraints.Function;
import react.ReactComponent;
import react.redux.form.Control.ControlProps;

typedef FieldProps = {
	> ControlProps,
	@:optional @:native("dynamic") var isDynamic:Bool; //!\ doesn't work...
}

/**
	The `<Field>` component recursively checks its children to see if they can
	be made into a `<Control>`. It then maps all of its props over to each
	created child `<Control>`.

	If it reaches an unknown component, such as a `<SpecialComponent>`, it will
	stop recursing and leave the component as-is. In such cases, it is highly
	recommended to use `<Control>` over `<Field>` whenever possible.

	See https://davidkpiano.github.io/react-redux-form/docs/api/Field.html
**/
@:jsRequire('react-redux-form', 'Field')
extern class Field extends ReactComponentOfProps<FieldProps> {}

