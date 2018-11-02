package view.dashboard.model;
import haxe.ds.StringMap;
import view.shared.BaseForm.FormProps;
import view.shared.BaseForm.FormElement;
import view.shared.BaseForm.FormField;

/**
 * @author axel@cunity.me
 */

import view.shared.BaseForm.FormState;

typedef FormRelation =
{
	?props:FormProps,
	?state:FormState
}

class SettingsFormModel
{
	public static var accountDataElements:StringMap<FormField> =  [
		'user_name'=>{label:'Benutzer'},
		'first_name'=>{label:'Vorname'},
		'last_name'=>{label:'Name'},
		'name'=>{label:'UserGroup'},		
		'active' => {label:'Aktiv', className:'', 'type':FormElement.Checkbox},
		'user_id' => {'type':FormElement.Hidden}
	];
	
	public static var relations:StringMap<FormRelation> = [
		'accountData' => {
			props:{elements:accountDataElements},
			state:null
		},
		'userBookmarks' => {}
	];	
}