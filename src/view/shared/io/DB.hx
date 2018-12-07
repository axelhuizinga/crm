package view.shared.io;

import haxe.Json;
import haxe.Unserializer;
import haxe.ds.StringMap;
import haxe.io.Bytes;
import hxbit.Serializer;
import js.html.FormData;
import js.html.FormDataIterator;
import js.html.HTMLCollection;
import me.cunity.debug.Out;
import org.msgpack.Decoder;
import org.msgpack.MsgPack;
import react.ReactComponent;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import redux.IReducer;
import shared.DbData;
import view.dashboard.model.DBFormsModel;
import view.shared.BaseForm.FormField;
import view.shared.SMenu;
import view.shared.SMenu.SMItem;
import view.shared.io.DataAccessForm;
import view.shared.io.DataAccess.DataSource;
import view.shared.io.Loader;
import view.table.Table;


/**
 * ...
 * @author axel@cunity.me
 */
class DB extends DataAccessForm 
{

	static var _instance:DB;

	public static function menuItems():Array<SMItem>
	{
		return _instance == null? [] : _instance._menuItems;
	}
	
	
	public function new(?props) 
	{
		super(props);

		dataDisplay = DBFormsModel.dataDisplay;
		_instance = this;		
		_menuItems = [
			{handler:createFieldList, label:'Create Fields Table', segment:'createFieldList'},
			{handler:showFieldList, label:'Table Fields', segment:'showFieldList'},
			{handler:editTableFields, label:'Bearbeiten', disabled:state.selectedRows.length==0},
			//{handler:save, label:'Speichern', disabled:state.clean},
		];
		var sideMenu = state.sideMenu;
		//trace(sideMenu);
		sideMenu.menuBlocks['DbTools'].items = function() return _menuItems;
		state = ReactUtil.copy(state, {sideMenu:sideMenu});		
	}
	
	//override public function save(ev:ReactEvent):Void{}
	
	public function createFieldList(ev:ReactEvent):Void
	{
		trace('hi :)');
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
				setState({data:data, viewClassPath:'shared.io.DB.showFieldList'});
		}));
		trace(props.history);
		trace(props.match);
		//setState({viewClassPath:viewClassPath});
	}
	
	public function editTableFields(ev:ReactEvent):Void
	{
		trace(state.selectedRows.length);
		var data = selectedRowsMap();
		var view:Map<String,FormField> = dataAccess['editTableFields'].view.copy();
		trace(dataAccess['editTableFields'].view['table_name']);
		trace(data[0]['id']+'<');
		renderModalForm({
			data:new Map(),
			dataTable:data,
			handleSubmit: saveTableFields,
			model:'tableFields',
			viewClassPath:'shared.io.DB.editTableFields',			
			fields:view,
			valuesArray:createStateValuesArray(data, dataAccess['editTableFields'].view), 
			loading:false,
			title:'Tabellenfelder Eigenschaften'
		});	
		
	}
	
	/*public function saveTableFields(elements:HTMLCollection):Void
	{
		trace(elements.length);
		for (el in elements)
		{
			trace(el);
		}
	}*/
	
	public function saveTableFields(vA:Dynamic):Void
	{
		trace(vA);
		//Out.dumpObject(vA);
		return;
		trace(vA.entries());
		trace(vA.entries().next());
		var keys:FormDataIterator = vA.keys();
		var k:Dynamic = keys.next();
		trace(k);
		trace(keys.next());
		/*var max:Int = 5;
		while (k = keys.next() != null)
		{
			trace(k);
			//trace(k.value + '=>');
			if (max-- == 0)
				break;
			//trace(k.value + '=>' + vA.getAll(k.value));
		}*/
		var keys:Iterator<String> = dataAccess['editTableFields'].view.keys();
		for (k in keys)
		{
			trace(k);
			trace(vA.getAll(k));
		}
		/*vA.forEach(function(el:Dynamic){
				trace(el);
				trace(vA.getAll(el));
			});
		}*/
	}
	
	public function showFieldList(ev:ReactEvent):Void
	{
		selectAllRows(true);
		requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				fields:'id,table_name,field_name,readonly,element,"any",use_as_index',
				className:'tools.DB',
				action:'createFieldList'
			},
			function(dBytes:Bytes)
			{
				var u:hxbit.Serializer = new hxbit.Serializer();
				var data:DbData = u.unserialize(dBytes, DbData);
				if (data.dataRows.length==0)
				{
					var error:Map<String,Dynamic> = data.dataErrors;
					var eK:Iterator<String> = error.keys();
					var hasError:Bool = false;
					while (eK.hasNext())
					{
						hasError = true;
						trace(Std.string(error.get(eK.next())));
					}
					if(!hasError){
						trace('Keine Daten!');
					}
					return;
				}		
				trace(data.dataRows);
				setState({dataTable:data.dataRows, viewClassPath:'shared.io.DB.showFieldList'});
			}
		));
		//setState({viewClassPath:'shared.io.DB.showFieldList'});
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
		if (state.data != null)
		return switch(state.viewClassPath)
		{
			case 'shared.io.DB.showFieldList':
				jsx('
					<Table id="fieldsList" data=${state.dataTable == null? null:state.dataTable}
					${...props} dataState = ${dataDisplay["fieldsList"]} parentForm=${this} 
					className = "is-striped is-hoverable" fullWidth={true}/>				
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
		if(state.values != null)
			trace(state.values);
		trace(props.match.params.segment);
		//return null;<form className="form60"></form>	
		return jsx('
		<div className="columns">
			<form className="tabComponentForm"  >
				${renderResults()}
			</form>
			<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks} />					
		</div>	
		');		
	}
	
	override function updateMenu(?viewClassPath:String):SMenuProps
	{
		trace('${Type.getClassName(Type.getClass(this))} task');
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['DbTools'].items = function() return [
			{handler:createFieldList, label:'Create Fields Table', segment:'createFieldList'},
			{handler:showFieldList, label:'Table Fields', segment:'showFieldList'},
			{handler:editTableFields, label:'Bearbeiten', disabled:state.selectedRows.length==0},
			//{handler:saveTableFields, label:'Speichern', disabled:state.clean},
		];
		return sideMenu;
	}
}