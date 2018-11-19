package view.shared.io;

import haxe.Json;
import haxe.Unserializer;
import haxe.io.Bytes;
import hxbit.Serializer;
import js.html.FormData;
import js.html.HTMLCollection;
import org.msgpack.Decoder;
import org.msgpack.MsgPack;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import redux.IReducer;
import shared.DbData;
import view.dashboard.model.DBFormsModel;
import view.shared.BaseForm.FormElement.*;
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
			{handler:save, label:'Speichern', disabled:state.clean},
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
				userName:props.userName,
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
		trace(data);
		setState({
			dataTable:data,
			viewClassPath:'shared.io.DB.editTableFields',			
			fields:dataAccess['editTableFields'].view,
			valuesArray:createStateValuesArray(data, dataAccess['editTableFields'].view), 
			loading:false			
		});	
	}
	
	public function showFieldList(ev:ReactEvent):Void
	{
		//requests.push(Loader.load(	
		//
		requests.push( BinaryLoader.create(
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				className:'tools.DB',
				action:'createFieldList'
			},
			function(dBytes:Bytes)
			{
				var u:hxbit.Serializer = new hxbit.Serializer();
				var data:DbData = u.unserialize(dBytes, DbData);
				//var data:Array<Map<String,Dynamic>> = u.unserialize(dBytes, DbData).dataRows;
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
				setState({dataTable:data.dataRows, viewClassPath:'shared.io.DB.showFieldList'});
			}
		));
		setState({viewClassPath:'shared.io.DB.showFieldList'});
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
					'any'=>{label:'Eigenschaften',readonly:true, type:Hidden}
				]
			},
			'saveTableFields' => {
				source:null,
				view:null
			}
		];			
	}
	
	function renderResults()
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
				renderModalForm();
			default:
				null;
		}
		return null;
	}
	
	override function render()
	{
		if(state.values != null)
			trace(state.values);
		trace(props.match.params.segment);
		//return null;
		return jsx('
		<div className="columns">
			<div className="tabComponentForm"  >
				<form className="form60">
					${renderResults()}
				</form>					
			</div>
			<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks} />					
		</div>	
		');		
	}
	
	override function updateMenu():SMenuProps
	{
		trace('${Type.getClassName(Type.getClass(this))} task');
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['DbTools'].items = function() return [
			{handler:createFieldList, label:'Create Fields Table', segment:'createFieldList'},
			{handler:showFieldList, label:'Table Fields', segment:'showFieldList'},
			{handler:editTableFields, label:'Bearbeiten', disabled:state.selectedRows.length==0},
			{handler:save, label:'Speichern', disabled:state.clean},
		];
		return sideMenu;
	}
}