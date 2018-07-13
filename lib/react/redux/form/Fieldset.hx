package react.redux.form;

import haxe.Constraints.Function;
import haxe.extern.EitherType;
import react.React.CreateElementType;
import react.ReactComponent;

typedef FieldsetProps = {
	var model:EitherType<String, Function>;
	@:optional var component:CreateElementType;
}

/**
	The `<Fieldset>` component is a way to contain related fields. This might
	not sound like much, but it's incredibly useful when creating **reusable
	groups of controls**.

	See https://davidkpiano.github.io/react-redux-form/docs/api/Fieldset.html
**/
@:jsRequire('react-redux-form', 'Fieldset')
extern class Fieldset extends ReactComponentOfProps<FieldsetProps> {}
