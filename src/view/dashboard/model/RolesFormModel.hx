package view.dashboard.model;
import haxe.ds.StringMap;
import view.table.Table.DataColumn;
import view.table.Table.DataState;

/**
 * @author axel@cunity.me
 */

import view.table.Table.*;

class RolesFormModel
{
	public static var userListColumns:StringMap<DataColumn> =  [
		'user'=>{label:'Benutzer'},
		'full_name'=>{label:'Name', flexGrow:1},
		'user_level'=>{label:'UserLevel', className:'cRight'},		
		'user_group'=>{label:'UserGroup', flexGrow:1},		
		'active'=>{label:'Aktiv', className:'cRight'},
		'user_id' => {show:false}
	];
	
	public static var dataDisplay:StringMap<DataState> = [
		'userList' => {columns:userListColumns},
		'userGroups' => {columns: [
			'user_group' => {label:'UserGroup', flexGrow:0},
			'group_name'=>{label:'Beschreibung', flexGrow:1},
			'allowed_campaigns'=>{label:'Kampagnen',flexGrow:1}
		]}
	];	
}