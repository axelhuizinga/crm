package view.dashboard.model;

import haxe.ds.Map;
import view.shared.BaseForm.FormState;
import shared.DBMetaData;
/**
 * ...
 * @author axel@cunity.me
 */


import haxe.ds.StringMap;
import view.shared.BaseForm.FormElement;
import view.shared.io.DataAccessForm;
import view.table.Table.DataColumn;
import view.table.Table.DataState;

class DBSyncModel 
{
	public static var formatBool = function(v:Dynamic) {return (v?'Y':'N'); }
	public static var formatElementSelection = function(v:Dynamic) {return (v?'Y':'N'); }
	public static var userListColumns:Map<String,DataColumn> =  [
		'table_name'=>{label:'Tabelle',editable:false},
		'field_name'=>{label:'Feldname',editable:false, flexGrow:1},
		'format_display'=>{label:'Anzeige', title:'Anzeigeformat'},
		'format_store'=>{label:'DB', title:'Speicherformat'},
		'element'=>{label:'Form', title:'Eingabefeld'},
		'admin_only'=>{label:'AO', title:'Admin',cellFormat:formatBool},
		'readonly'=>{label:'RO', title:'Nur Lesen', cellFormat:formatBool},
		'required'=>{label:'RQ', title:'Pflichtfeld', cellFormat:formatBool},
		//'primary'=>{label:'PID', title: 'Is Primary ID',cellFormat:formatBool},
		'use_as_index'=>{label:'ID', cellFormat:formatBool},
		//'any'=>{label:'Eigenschaften', flexGrow:1},
		'id'=>{label: 'ID', show:false}
	];
	
	//public static function dataDisplay(?parentForm:DataAccessForm):StringMap<DataState> 
	public static var dataDisplay:Map<String,DataState> =
		[
			'userList' => {altGroupPos:0,columns:userListColumns}
		];
	
}
