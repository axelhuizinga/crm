package view.shared.io;

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
import view.shared.io.DataAccessForm;
import view.shared.io.DataAccessForm.DataFormProps;
import view.shared.io.DataAccess.DataSource;


/**
 * ...
 * @author axel@cunity.me
 */

typedef BookmarksModel = DataSource;

//typedef UserFilter = Dynamic;
@:connect
class Bookmarks extends DataAccessForm
{
	
	public var menuItems:Array<SMItem>;// = [];
	
	public function edit(ev:ReactEvent):Void
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
	
	public function new(props:DataFormProps)
	{
		super(props);
		dataAccess = [
			'edit' =>{
				source:new Map(),
				view:new Map()
			}
		];		
		_menuItems = [{handler:edit, label:'Bearbeiten', action:'edit'}];
		var sideMenu = updateMenu('bookmarks');
		//sideMenu.menuBlocks['bookmarks'].items = function() return _menuItems;
		//trace(sideMenu.menuBlocks['bookmarks'].items());
		state = ReactUtil.copy(state,{sideMenu:sideMenu,viewClassPath:"edit"});
		//trace(this.props);
	}
	
	override function render()
	{
		var data:Array<Any> = [
			getRow({ one: 'one', two: 'two', three: 'three' }),
			getRow({ one: 'uno', two: 'dos', three: 'tres' }),
			getRow({ one: 'ichi', two: 'ni', three: 'san' })
		];
		
		data = [{
			name: 'Roy Agasthyan',
			age: 26
			},{
			name: 'Sam Thomason',
			age: 22
			},{
			name: 'Michael Jackson',
			age: 36
			},{
			name: 'Samuel Roy',
			age: 56
			},{
			name: 'Rima Soy',
			age: 28
			},{
			name: 'Suzi Eliamma',
			age: 28
			}];
//trace(plugins);
/*var tCR:TableCellRenderer = function (cI:Dynamic, column:Dynamic)
{
	trace(cI);
	trace(column);
	return jsx('<div><pre>${cI.value}</pre></div>');
};
var columns:Array<Column> = [{
      Header: 'Name',
	  //Cell:tCR,
      accessor: 'name'
    },{
      Header: 'Age',
      accessor: 'age'
    }];*/
var iState:Dynamic = {istate:state, updateMenu:updateMenu};
trace(iState);
//var NewLayoutInstance = React.createElement(NewLayout);
//trace(griddle.components.NewLayout);
//trace(Reflect.fields(untyped Griddle.childContextTypes));
//trace(Reflect.fields(GriddleComponent));
trace(data);
trace(state.sideMenu.menuBlocks['bookmarks'].items().slice(4));
var style:Dynamic = {
            //height: "auto" // This will force the table body to overflow and scroll, since there is not enough room
          };

		return jsx('
			<div className="columns">
				<div className="tabComponentForm"  >
					dummy	
				</div>
				<$SMenu className="menu" menuBlocks=${state.sideMenu.menuBlocks} />					
			</div>	
			
		');

	}
	//
	function dummyH(evt:js.html.Event)
	{
		trace('ok');
	}
	override function updateMenu(?viewClassPath:String):SMenuProps
	{
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['bookmarks'].isActive = true;
		sideMenu.menuBlocks['bookmarks'].items = function() {
			return 
				[
					{handler:dummyH, label:'Speichern', disabled:state.clean},
					{handler:dummyH, label:'Passwort ändern'},
					{handler:dummyH, label:'Something...'},
					{handler:dummyH, label:'Something...'},
					{handler:dummyH, label:'Something...'},
					{handler:dummyH, label:'Something...'},
					{handler:dummyH, label:'Something...'},
					{handler:dummyH, label:'Something...'},
					{handler:dummyH, label:'Something...'},
					{handler:dummyH, label:'Something...'},
					{handler:dummyH, label:'Something...'},
				];
			
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