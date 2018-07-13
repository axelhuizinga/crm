package react.redux.form;

import react.ReactComponent;
import react.redux.form.Form.FormProps;
import redux.Redux.Dispatch;

typedef LocalFormProps = {
	> FormProps,
	@:optional var getDispatch:Dispatch->Void;
}

/**
	The `<LocalForm>` component takes all the props from the `<Form>`
	component, with four important props:

	* `model="..."` (String): the name of the model in the internal state. This
	  is completely optional, as the model is not related to any external Redux
	  store (default: `"local"`)
	* `onUpdate={(formValue) => ...}` (Function): a handler that is called
	  whenever the form value is updated
	* `onChange={(modelValue) => ...}` (Function): a handler that is called
	  whenever the form's model value is changed
	* `initialState={...}` (Any): the initial state of the model (default: `{}`)

	It also accepts props exclusive to `<LocalForm>`:

	* `getDispatch={(dispatch) => ...}` (Function): provides the Local Form
	  store's `dispatch` to the callback once - when the component is initially
	  mounted.

	Notes:
	* `redux` and `react-redux` are still required as peer dependencies. This
	  just allows you to not have to set up the boilerplate; e.g., the store
	  and reducers.
	* As with any React component, whenever the `<LocalForm>` is unmounted, the
	  component's internal state is gone. This can be desirable (or
	  undesirable) depending on your use case, so take this into consideration.

	See https://davidkpiano.github.io/react-redux-form/docs/guides/local.html
**/
@:jsRequire('react-redux-form', 'LocalForm')
extern class LocalForm extends ReactComponentOfProps<LocalFormProps> {}

