package view.shared.io;

import js.html.AreaElement;
import haxe.Json;
import haxe.Unserializer;
import haxe.ds.Map;
import haxe.io.Bytes;
import hxbit.Serializer;
import js.html.FormData;
import js.html.FormDataIterator;
import js.html.HTMLCollection;
import me.cunity.debug.Out;
//import org.msgpack.Decoder;
//import org.msgpack.MsgPack;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import shared.DbData;
import shared.DBMetaData;
import view.dashboard.model.DBSyncModel;
import view.shared.BaseForm.FormField;
import view.shared.SMenu;
import view.shared.SMenu.SMItem;
import view.shared.io.DataAccessForm;
import view.shared.io.Loader;
import view.table.Table;


/**
 * ...
 * @author axel@cunity.me
 */
class DBSync extends DataAccessForm 
{

	static var _instance:DBSync;

	public static function menuItems():Array<SMItem>
	{
		return _instance == null? [] : _instance._menuItems;
	}
	
	
	public function new(?props) 
	{
		super(props);

		dataDisplay = DBSyncModel.dataDisplay;
		_instance = this;		
		_menuItems = [
			{handler:createFieldList, label:'Create Fields Table', action:'createFieldList'},
			{handler:showUserList, label:'BenutzerDaten Abgleich', action:'showUserList'},
			{handler:editTableFields, label:'Bearbeiten', disabled:state.selectedRows.length==0},
			//{handler:save, label:'Speichern', disabled:state.clean},
		];
		var sideMenu = state.sideMenu;
		//trace(sideMenu);
		sideMenu.menuBlocks['SyncTools'].items = function() return _menuItems;
		state = ReactUtil.copy(state, {sideMenu:sideMenu});		
	}
	
	//override public function save(ev:ReactEvent):Void{}
	
	public function createFieldList(ev:ReactEvent):Void
	{
		trace('hi :)');
		return;
		requests.push(Loader.load(	
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				className:'tools.DB',
				action:'createFieldList',
				update:'1'
			},
			function(data:Map<String,String>)
			{
				trace(data);
				if (data.exists('error'))
				{
					trace(data['error']);
					return;
				}				 
				setState({data:data, viewClassPath:'shared.io.DB.showUserList'});
		}));
		trace(props.history);
		trace(props.match);
		//setState({viewClassPath:viewClassPath});
	}
	
	public function editTableFields(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
				
	}

	function initStateFromDataTable(dt:Array<Map<String,String>>):Dynamic
	{
		var iS:Dynamic = {};
		for(dR in dt)
		{
			var rS:Dynamic = {};
			for(k in dR.keys())
			{
				trace(k);
				if(dataDisplay['fieldsList'].columns[k].cellFormat == DBSyncModel.formatBool)
				{
					Reflect.setField(rS,k, dR[k] == 'Y');
				}
				else
					Reflect.setField(rS,k, dR[k]);
			}
			Reflect.setField(iS, dR['id'], rS);			
		}
		trace(iS);
		return iS;
	}
	
	public function saveTableFields(vA:Dynamic):Void
	{
		trace(vA);
		//Out.dumpObject(vA);
		dbMetaData = new  DBMetaData();
		dbMetaData.dataFields = dbMetaData.stateToDataParams(vA);
		trace(dbMetaData.dataFields.get(111));
		var s:hxbit.Serializer = new hxbit.Serializer();
		
		return;
		requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				fields:'readonly:readonly,element=:element,required=:required,use_as_index=:use_as_index',
				className:'tools.DB',
				action:'saveTableFields',
				dbData:s.serialize(dbData)
			},
			function(dBytes:Bytes)
			{				
				var data:DbData = s.unserialize(dBytes, DbData);
				trace(data);
			}
		));
	}
	
	public function showUserList(_):Void
	{
		//selectAllRows(true);
		setState({viewClassPath:'showUserList'});
		requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				fields:'id,table_name,field_name,readonly,element,required,use_as_index',
				className:'admin.SyncExternal',
				action:'syncUserDetails'
			},
			function(dBytes:Bytes)
			{
				var u:hxbit.Serializer = new hxbit.Serializer();
				var data:DbData = u.unserialize(dBytes, DbData);
				trace(data.dataRows[data.dataRows.length-2]['phone_data']);
				setState({dataTable:data.dataRows});
				return;
				var aj:haxe.http.HttpJs = model.AjaxLoader.loadData(data.dataInfo['syncApi'],
				{user:data.dataInfo['admin'], pass:data.dataInfo['pass'], action:'clientVerify'}, 
				function(verifyData:Dynamic){
					trace(verifyData);
				});
				//setState({data:data.dataInfo, viewClassPath:'showUserList'});
			}
		));
		//setState({viewClassPath:'shared.io.DB.showUserList'});
	}
	
	override public function componentDidMount():Void 
	{
		super.componentDidMount();
	
		dataAccess = [
			'editTableFields' =>{
				source:[
					"selectedRows" => null//selectedRowsMap()
				],
				view:[
					'table_name'=>{label:'Tabelle',readonly:true},
					'field_name'=>{label:'Feldname',readonly:true},
					'field_type'=>{label:'Datentyp',type:Select},
					'element'=>{label:'Eingabefeld', type:Select},
					'readonly' => {label:'Readonly', type:Checkbox},
					'required' => {label:'Required', type:Checkbox},
					'use_as_index' => {label:'Index', type:Checkbox},
					'any' => {label:'Eigenschaften', readonly:true, type:Hidden},
					'id' =>{primary:true, type:Hidden}
				]
			},
			'saveTableFields' => {
				source:null,
				view:null
			}
		];			
	}
	
	function renderResults():ReactFragment
	{
		trace(state.viewClassPath + ':' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);
		if (state.dataTable != null)
		return switch(state.viewClassPath)
		{
			case 'showUserList':
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["userList"]} parentForm=${this} 
					className = "is-striped is-hoverable" fullWidth=${true}/>
				');
			case 'showFieldList2':
				trace(dataDisplay["fieldsList"]);
				trace(state.dataTable[29]['id']+'<<<');
				jsx('
					<Table id="fieldsList" data=${state.dataTable}
					${...props} dataState = ${dataDisplay["fieldsList"]} parentForm=${this} 
					className = "is-striped is-hoverable" fullWidth=${true}/>				
				');	
			case 'shared.io.DB.editTableFields':
				null;
			default:
				null;
		}
		return null;
	}
	
	override function render():ReactFragment
	{
		if(state.dataTable != null)
			trace(state.dataTable[0]);
		trace(props.match.params.segment);		
		//return null;<form className="form60"></form>	
		return jsx('
		<div className="columns xAuto">
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
			<SMenu className="menu" menuBlocks=${state.sideMenu.menuBlocks} />					
		</div>	
		');		
	}
	
	override function updateMenu(?viewClassPath:String):SMenuProps
	{
		trace('${Type.getClassName(Type.getClass(this))} task');
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['DbTools'].items = function() return [
			{handler:createFieldList, label:'Create Fields Table', action:'createFieldList'},
			{handler:showUserList, label:'Table Fields', action:'showUserList'},
			{handler:editTableFields, label:'Bearbeiten', disabled:state.selectedRows.length==0},
			//{handler:saveTableFields, label:'Speichern', disabled:state.clean},
		];
		return sideMenu;
	}
}