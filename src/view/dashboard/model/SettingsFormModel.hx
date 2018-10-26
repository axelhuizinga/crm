package view.dashboard.model;
import haxe.ds.StringMap;
import view.shared.BaseForm.FormProps;
import view.shared.BaseForm.FormElement;
import view.shared.BaseForm.FormField;

/**
 * @author axel@cunity.me
 */

  /**
    typedef FormField =
{
	?label:String,
	?className:String,
	?name:String,
	?value:Any,
	?dataBase:String, 
	?dataTable:String,
	?dataField:String,
	?dataFormat:Function,
	?type:FormElement,
	?required:Bool,
	?onChange:Event->Void,
	?placeholder:String,
	?validate:Any->Bool
}
 typedef FormProps =
 {
	>RouteTabProps,
	?contentId:String,
	?elements:StringMap<FormField>,
	?formData:Dynamic,
	?store:Store<AppState>,
	?handleChange:Event->Void,
	?handleSubmit:Event->Void
 }
typedef FormState =
{
	var contentId:String;
	//@:optional var content:Array<String>;
	@:arrayAccess
	@:optional var data:Map<String,Dynamic>;
	var clean:Bool;
	var hasError:Bool;
	@:optional var loading:Bool;
	@:optional var fields:StringMap<FormField>;
	@:optional var values:StringMap<Dynamic>;
	@:optional var submitted:Bool;
	@:optional var errors:StringMap<String>;
 **/

import view.shared.BaseForm.FormState;

typedef FormRelation =
{
	props:FormProps,
	state:FormState
}

class SettingsFormModel
{
	public static var accountDataElements:StringMap<FormField> =  [
		'user_name'=>{label:'Benutzer'},
		'first_name'=>{label:'Vorname'},
		'last_name'=>{label:'Name'},
		'name'=>{label:'UserGroup'},		
		'active' => {label:'Aktiv', className:'cRight', 'type':FormElement.Checkbox},
		'user_id' => {'type':FormElement.Hidden}
	];
	
	public static var relations:StringMap<FormRelation> = [
		'accountData' => {
			props:{elements:accountDataElements},
			state:null,
		}
		'userGroups' => {fields: [
		
			'user_group' => {label:'UserGroup'},
			'group_name'=>{label:'Beschreibung'},
			'allowed_campaigns'=>{label:'Kampagnen'}
		]}
	];	
}