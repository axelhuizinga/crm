package view.shared;
import view.shared.BaseForm.FormField;
import view.shared.BaseForm.FormState;

import react.PureComponent.PureComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
/**
 * ...
 * @author axel@cunity.me
 */

typedef FormUiProps =
{
	>view.shared.BaseForm.FormProps,
	?fullWidth:Bool,
}

class FormUi extends PureComponentOf<FormUiProps,FormState>
{

	public function new(?props:FormUiProps) 
	{
		super(props);
		trace(props.match);
	}
	
	override public function render()
	{
		//trace(props.match);
		trace(props.data);
		return jsx('<form/>');
	}
}