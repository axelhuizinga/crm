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
	data:Array<Dynamic>,
	?fullWidth:Bool,
	elements:Array<FormField>,
	?name:String
}

class FormUi extends PureComponentOf<FormUiProps,FormState>
{

	public function new(?props:FormUiProps) 
	{
		super(props);
	}
	
	override public function render()
	{
		return jsx('<form/>');
	}
}