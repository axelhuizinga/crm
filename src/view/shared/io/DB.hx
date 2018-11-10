package view.shared.io;

import haxe.Unserializer;
import model.AjaxLoader;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import view.shared.SMenu;
import view.shared.SMenu.SMItem;
import view.shared.io.DataAccessForm;
import view.shared.io.DataAccess.DataSource;


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
		_instance = this;		
		_menuItems = [
			{handler:createFieldList, label:'Table Fields', segment:'createFieldList'},
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
		requests.push(AjaxLoader.load(	
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				className:'tools.DB',
				action:'createFieldList',
				//filter:'user_name|${props.userName}',
				//dataSource:null//Serializer.run(dataAccess['edit'].data)
			},
			function(data:Dynamic)
			{
				trace(data);
				if (data.error != null)
					return;
				var fieldNames:Map<String,String> = null;
				try{
					fieldNames = Unserializer.run(data);
				}
				catch (ex:Dynamic)
				{
					trace(ex);
					return;
				}
				 
				setState({data:fieldNames});
		}));
		trace(props.history);
		trace(props.match);
		//setState({viewClassPath:viewClassPath});
	}
	
	function renderResults()
	{
		if (state.data != null)
		return switch(state.viewClassPath)
		{
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
}