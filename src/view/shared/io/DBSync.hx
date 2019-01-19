package view.shared.io;

import js.html.AreaElement;
import haxe.Json;
import haxe.Unserializer;
import haxe.ds.Map;
import haxe.io.Bytes;
import hxbit.Serializer;
import js.html.Event;
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

	public static var menuItems:Array<SMItem> = [
		{label:'Create Fields Table',action:'createFieldList'},
		{label:'BenutzerDaten Abgleich',action:'showUserList'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'}
	];
	
	public function new(?props) 
	{
		super(props);

		dataDisplay = DBSyncModel.dataDisplay;
		_instance = this;		
		/*_menuItems = [];menuItems.map(function (mI:SMItem){
			var h:Event->Void = Reflect.field(this, mI.action);
			trace(h);
			mI.handler = h;
			switch(mI.action)
			{
				case 'editTableFields':
					mI.disabled = state.selectedRows.length==0;
				case 'save':
					mI.disabled = state.clean;
				default:

			}
			return mI;

		});*/

		var sideMenu =  updateMenu('DBSync');//state.sideMenu;
		//trace(sideMenu);
		//sideMenu.menuBlocks['DBSync'].items = _menuItems;
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
				setState({data:data});
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
			function(data:DbData)
			{				
				trace(data);
			}
		));
	}
	
	public function showUserList(_):Void
	{
		requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				fields:'id,table_name,field_name,readonly,element,required,use_as_index',
				className:'admin.SyncExternal',
				action:'syncUserDetails'
			},
			function(data:DbData)
			{
				trace(data.dataRows[data.dataRows.length-2]['phone_data']);
				setState({dataTable:data.dataRows});
			}
		));
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
		trace(props.match.params.section + ':' + Std.string(state.dataTable != null));
		//trace(dataDisplay["userList"]);
		if (state.dataTable != null)
		return switch(props.match.params.action)
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
		trace(props.match.params.section);		
		//return null;<form className="form60"></form>	
		return jsx('
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
		');		
	}
	
	override function updateMenu(?viewClassPath:String):SMenuProps
	{
		var sideMenu = state.sideMenu;
		//sideMenu.menuBlocks['DBSync'].handlerInstance = this;
		for(mI in sideMenu.menuBlocks['DBSync'].items)
		{
			switch(mI.action)
			{
				case 'editTableFields':
					mI.disabled = state.selectedRows.length==0;
				case 'save':
					mI.disabled = state.clean;
				default:

			}			
		}
		return sideMenu;
	}
}