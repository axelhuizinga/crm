package model;
//import react.addon.ReactReduxForm.;

/**
 * @author axel@cunity.me
 */

typedef FormElement = 
{
	name:String,
	type:String,
	value:Dynamic
}
 
typedef BaseFormData =
{
	name:String,
	fields:Array<FormElement>
}