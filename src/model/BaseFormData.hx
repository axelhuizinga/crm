package model;
//import react.addon.ReactReduxForm.;

/**
 * @author axel@cunity.me
 */

typedef FormElement = 
{
	name:String,
	type:String,
	value:String
}
 
typedef BaseFormData =
{
	name:String,//FORM NAME
	fields:Array<FormElement>
}