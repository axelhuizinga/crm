package view.dashboard.model;

/**
 * ...
 * @author axel@cunity.me
 */


import haxe.ds.StringMap;
import view.shared.BaseForm.FormElement;
import view.shared.io.DataAccessForm;
import view.table.Table.DataColumn;
import view.table.Table.DataState;

class DBFormsModel 
{
	public static var formatBool = function(v:Dynamic) {return (v?'Y':'N'); }
	public static var formatElementSelection = function(v:Dynamic) {return (v?'Y':'N'); }
	public static var fieldsListColumns:Map<String,DataColumn> =  [
		'table_name'=>{label:'Tabelle',editable:false},
		'field_name'=>{label:'Feldname',editable:false},
		'element'=>{label:'Formularelement'},
		'readonly'=>{label:'Readonly', cellFormat:formatBool},
		'required'=>{label:'Required', cellFormat:formatBool},
		'use_as_index'=>{label:'Index', cellFormat:formatBool},
		'any'=>{label:'Eigenschaften', flexGrow:1},
		'id'=>{label: 'ID', show:false}
	];
	
	//public static function dataDisplay(?parentForm:DataAccessForm):StringMap<DataState> 
	public static var dataDisplay:Map<String,DataState> =
		[
			'fieldsList' => {altGroupPos:0,columns:fieldsListColumns}
		];
	
}