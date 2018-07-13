package react.redux.form;

import haxe.Constraints.Function;
import haxe.extern.EitherType;
import js.html.Event;
import js.html.HtmlElement;
import react.React.CreateElementType;
import react.ReactComponent;

@:enum abstract FormValidationEvent(String) to String {
	var Change = "change";
	var Submit = "submit";
}

typedef FormProps = {
	var model:EitherType<String, Function>;
	@:optional var validators:Dynamic;
	@:optional var errors:Dynamic;
	@:optional var validateOn:FormValidationEvent;
	@:optional var onSubmit:Dynamic->Event->Void;
	@:optional var onSubmitFailed:Dynamic; // formState for the form's model
	@:optional var component:CreateElementType;
	@:optional var onUpdate:Dynamic->Void; // formState for the form's model
	@:optional var onChange:Dynamic->Void; // value of the form's model
	@:optional var getRef:HtmlElement->Void;
	@:optional var onBeforeSubmit:Event->Void;
	@:optional var hideNativeErrors:Bool;
}

/**
	The `<Form>` component is a decorated `<form>` component with a few helpful
	props. It is useful for blocking `onSubmit` handlers when the form is
	invalid. Validation is specified by the `validators` and/or `errors` prop.

	See https://davidkpiano.github.io/react-redux-form/docs/api/Form.html
**/
@:jsRequire('react-redux-form', 'Form')
extern class Form extends ReactComponentOfProps<FormProps> {}

