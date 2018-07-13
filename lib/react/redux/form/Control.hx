package react.redux.form;

import js.html.HtmlElement;
import haxe.Constraints.Function;
import haxe.extern.EitherType;
import react.React.CreateElementType;
import react.ReactComponent;

@:enum abstract ValidationEvent(String) to String {
	var Change = "change";
	var Blur = "blur";
	var Focus = "focus";
}

typedef ControlProps = {
	var model:EitherType<String, Function>;
	@:optional var mapProps:EitherType<{}, Function>;
	@:optional var updateOn:EitherType<String, Array<String>>;
	@:optional var defaultValue:Any;
	@:optional var debounce:Int;
	@:optional var validators:Dynamic<Function>;
	@:optional var validateOn:EitherType<ValidationEvent, Array<ValidationEvent>>;
	@:optional var asyncValidators:Dynamic<Function>;
	@:optional var asyncValidateOn:EitherType<ValidationEvent, Array<ValidationEvent>>;
	@:optional var errors:Dynamic<Function>;
	@:optional var parser:Any->Any;
	@:optional var changeAction:Function;
	@:optional var controlProps:{};
	@:optional var component:CreateElementType;
	@:optional var ignore:EitherType<String, Array<String>>;
	@:optional var disabled:Any;
	@:optional var getRef:HtmlElement->Void;
	@:optional var persist:Bool;
	@:optional var getValue:Function;
	@:optional var isToggle:Bool;
	@:optional var withFieldValue:Bool;
}

/**
	The `<Control>` component represents a form control, such as an
	`<input />`, `<select>`, `<textarea />`, etc.

	It is a connected component, and will use the `model` prop to connect
	itself to the Redux store and dispatch the appropriate actions for each
	event handler.

	The following pre-defined `<Control>`s are available:

	* `<Control>` or `<Control.input>` for standard `<input />` controls
	* `<Control.custom>` for controls without any default prop mapping
	* `<Control.text>` for `<input type="text" />`
	* `<Control.textarea>` for `<textarea></textarea>`
	* `<Control.radio>` for `<input type="radio" />`
	* `<Control.checkbox>` for `<input type="checkbox" />`
	* `<Control.file>` for `<input type="file" />`
	* `<Control.select>` for `<select></select>`
	* `<Control.button>` for `<button></button>`
	* `<Control.reset>` for `<button type="reset"></button>`

	They are also available as separate components: `<ControlText>`,
	`<ControlTextarea>`, etc. It is recommended to use the separate components
	since future versions of `haxe-react` will check props at compile time,
	and passing additional props to `<Control.x>` components might not be
	possible.

	You can add other input types to the basic `<Control>` component as an
	attribute: `<Control type="password">`

	For making custom controls that work with React Redux Form, see the custom
	controls documentation [1].

	Note:
	Any standard valid control props, such as `name`, `disabled`, `onChange`,
	`onBlur`, `onFocus`, `onKeyPress`, etc. will be passed directly to the
	control, so feel free to use them.

	See https://davidkpiano.github.io/react-redux-form/docs/api/Control.html

	[1]: https://davidkpiano.github.io/react-redux-form/docs/guides/custom-controls.html
**/
@:jsRequire('react-redux-form', 'Control')
extern class Control<TProps:ControlProps> extends ReactComponentOfProps<TProps> {
	static var input:ReactComponentOfProps<ControlProps>;
	static var custom:ReactComponentOfProps<ControlProps>;
	static var text:ReactComponentOfProps<ControlProps>;
	static var textarea:ReactComponentOfProps<ControlProps>;
	static var radio:ReactComponentOfProps<ControlProps>;
	static var checkbox:ReactComponentOfProps<ControlProps>;
	static var file:ReactComponentOfProps<ControlProps>;
	static var select:ReactComponentOfProps<ControlProps>;
	static var button:ReactComponentOfProps<ControlProps>;
	static var reset:ReactComponentOfProps<ControlProps>;
}

@:jsRequire('react-redux-form', 'Control.input')
extern class ControlInput<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

@:jsRequire('react-redux-form', 'Control.custom')
extern class ControlCustom<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

@:jsRequire('react-redux-form', 'Control.text')
extern class ControlText<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

@:jsRequire('react-redux-form', 'Control.textarea')
extern class ControlTextarea<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

@:jsRequire('react-redux-form', 'Control.radio')
extern class ControlRadio<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

@:jsRequire('react-redux-form', 'Control.checkbox')
extern class ControlCheckbox<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

@:jsRequire('react-redux-form', 'Control.file')
extern class ControlFile<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

@:jsRequire('react-redux-form', 'Control.select')
extern class ControlSelect<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

@:jsRequire('react-redux-form', 'Control.button')
extern class ControlButton<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

@:jsRequire('react-redux-form', 'Control.reset')
extern class ControlReset<TProps:ControlProps> extends ReactComponentOfProps<TProps> {}

