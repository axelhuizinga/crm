package view.shared.io;

import react.React;
import js.html.Plugin;
import griddle.components.Components.GriddleComponent;
import griddle.components.Components.SettingsWrapper;
import griddle.components.Components.Filter;
//import griddle.components.Components.NewLayoutProps;
import view.griddle.LayoutContainer;
import js.Syntax;
import haxe.Serializer;
import haxe.ds.StringMap;
import model.AjaxLoader;
import react.ReactComponent;
import react.ReactComponent.ReactFragment;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import shared.DbData;
import view.shared.SMenu;
import view.shared.io.DataAccessForm;
import view.shared.io.DataAccessForm.DataFormProps;
import view.shared.io.DataAccess.DataSource;
import griddle.components.Components.GriddleStyleConfig;
import griddle.Griddle;
import griddle.plugins.Plugins;

/**
 * ...
 * @author axel@cunity.me
 */

typedef BookmarksModel = DataSource;

//typedef UserFilter = Dynamic;

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
		_menuItems = [{handler:edit, label:'Bearbeiten', segment:'edit'}];
		var sideMenu = state.sideMenu;
		sideMenu.menuBlocks['bookmarks'].items = function() return _menuItems;
		trace(_menuItems);
		state = ReactUtil.copy(state,{sideMenu:sideMenu,viewClassPath:"edit",});
		trace(this.props);
	}
	
	override function render()
	{
		var data = [
			{ one: 'one', two: 'two', three: 'three' },
			{ one: 'uno', two: 'dos', three: 'tres' },
			{ one: 'ichi', two: 'ni', three: 'san' }
		];
		var styleConfig:GriddleStyleConfig = {
			classNames: {
				Row: 'row-class',
			},
			styles: {
				Filter: { fontSize: 18 },
				Table: { border: "2px solid #555 "},
			}
		};

		var sortProperties = [
		{ id: 'one', sortAscending: true }
		];
var plugins=${[Plugins.LocalPlugin]}
trace(plugins);
//var NewLayoutInstance = React.createElement(NewLayout);
//trace(griddle.components.NewLayout);
trace(Reflect.fields(Griddle));
trace(Reflect.fields(GriddleComponent));

		return jsx('
			<$LayoutContainer data=${data} plugins=${plugins} sortProperties=${sortProperties} styleConfig=${styleConfig}/>
		');
	}
	//
	
}