package view.shared.io;

import js.html.Event;
import react.router.RouterMatch;
import react.ReactType;
import react.React;
import js.html.Plugin;
import js.Syntax;
import haxe.Serializer;
import haxe.ds.StringMap;
import model.AjaxLoader;
import react.ReactComponent;
import react.ReactComponent.ReactFragment;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
/*import react.table.ReactTable;
import react.table.ReactTable.Column;
import react.table.ReactTable.ColumnRenderProps;
import react.table.ReactTable.TableCellRenderer;
import react.table.ReactTable.CellInfo;*/
import shared.DbData;
import view.shared.SMenu;
//import view.shared.io.DataAccessForm;
import view.shared.io.DataFormProps;
import view.shared.io.DataAccess.DataSource;


/**
 * ...
 * @author axel@cunity.me
 */

typedef BookmarksModel = DataSource;

//typedef UserFilter = Dynamic;
@:connect
class Bookmarks extends ReactComponentOf<DataFormProps,FormState>
{
	
	//public var menuItems:Array<SMItem>;// = [];
	
	public function add(ev:Event):Void
	{

	}

	public function delete(ev:Event):Void
	{
		
	}

	public function edit(ev:Event):Void
	{
		trace('hi :)');
		requests.push(AjaxLoader.load(	
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.user_name}',
				dataSource:Serializer.run(null)
			},
			function(data:Dynamic )
			{
				if (data.rows == null)
					return;
				trace(data.rows.length);
				var dataRows:Array<Dynamic> = data.rows;
				trace(Reflect.fields(dataRows[0]));
				trace(dataRows[0].active);
				setState({data:['accountData'=>dataRows], loading:false});					
			}
		));
		setState({dataClassPath:"auth.User.edit"});
	}
	
	public function save(ev:Event):Void
	{

	}

	public function no(ev:Event):Void
	{

	}

	public function new(props:DataFormProps)
	{
		super(props);
		dataAccess = [
			'edit' =>{
				source:new Map(),
				view:new Map()
			}
		];		
		//_menuItems = [];//{handler:edit, label:'Bearbeiten', action:'edit'}];
		var sideMenu = updateMenu('bookmarks');
		//sideMenu.menuBlocks['bookmarks'].items = function() return _menuItems;
		//trace(sideMenu.menuBlocks['bookmarks'].items());
		state = ReactUtil.copy(state,{sideMenu:sideMenu,viewClassPath:"edit"});
		//trace(this.props);
	}
	
	override function render()
	{

		var iState:Dynamic = {istate:state, updateMenu:updateMenu};
		//trace(iState);
		//var NewLayoutInstance = React.createElement(NewLayout);
		//trace(griddle.components.NewLayout);
		//trace(Reflect.fields(untyped Griddle.childContextTypes));
		//trace(Reflect.fields(GriddleComponent));
		//trace(data);
		trace(props.match.params.section);
		var match:RouterMatch = getRouterMatch();
		trace(match.params);
		var section:String = (match.params.section == null?state.sideMenu.section:match.params.section);
		var style:Dynamic = {
            //height: "auto" // This will force the table body to overflow and scroll, since there is not enough room
    	};		  
		return jsx('
			<div className="tabComponentForm"  >
				dummy	
			</div>		
		');
	}

	public static var menuItems:Array<SMItem> = [
		{label:'Neu',action:'create'},
		{label:'Bearbeiten',action:'edit'},
		{label:'Speichern', action:'save'},
		{label:'Löschen',action:'delete'},
	];

	override function updateMenu(?viewClassPath:String):SMenuProps
	{
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['bookmarks'].isActive = true;
		sideMenu.menuBlocks['bookmarks'].label='Lesezeichen';
		for(mI in sideMenu.menuBlocks['bookmarks'].items)
		{
			switch(mI.action)
			{		
				case 'edit':
					mI.disabled = state.selectedRows.length==0;
				case 'save':
					mI.disabled = state.clean;
				default:

			}			
		}		
		//trace(sideMenu.menuBlocks['user'].items);	
		return sideMenu;
	}	

	function getRow(row:Dynamic):{one: String, two: String, three: String}
	{
		return {one: row.one, two: row.two, three: row.three};
	}
}
/*<$ReactTable
	          	data=${data}
    	      	columns=${columns}
				defaultPageSize={20}
          		style=${style}
         	 	className="-striped -highlight" />*/