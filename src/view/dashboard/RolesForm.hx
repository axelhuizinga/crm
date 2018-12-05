package view.dashboard;

import gigatables_react.Reactables.ReactableSettings;
import haxe.Serializer;
import haxe.ds.StringMap;
import haxe.Json;
import haxe.http.HttpJs;
import haxe.io.Bytes;
import model.AjaxLoader;
import model.AppState;
import react.ReactComponent.ReactFragment;
import react.ReactComponent;
import shared.DbData;
import view.shared.BaseForm;
import view.shared.io.BinaryLoader;
import view.table.Table;
//import view.grid.Grid.DataCell;
//import view.grid.Grid.SortDirection;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import redux.Redux.Dispatch;
import view.dashboard.model.RolesFormModel;
import view.shared.BaseForm.FormProps;
import view.shared.SMenu;
using Lambda;
/**
 * ...
 * @author axel@cunity.me
 */

@:connect
class RolesForm extends BaseForm
{		
	
	public function new(?props:FormProps) 
	{
		super(props);
		dataDisplay = RolesFormModel.dataDisplay;
		
		state = {
			clean:true,
			dataClassPath:"userList",
			hasError:false,
			loading:true,
			sideMenu:{
				menuBlocks:[
					'users'=>{
						isActive:true,
						label:'Benutzer',
						onActivate:switchContent,
						items:function() return [
							{handler:createUsers, label:'Neu'},
							{handler:editUsers,label:'Bearbeiten'},
							{handler:deleteUsers,label:'Löschen'}
						]
					},
					'userGroups'=>{
						label:'Benutzergruppen',
						onActivate:switchContent,
						items:function() return [
							{handler:createUserGroups,label:'Neu'},
							{handler:editUserGroups,label:'Bearbeiten'},
							{handler:deleteUserGroups,label:'Löschen'}
						]				
					},
					'permissions'=>{
						label:'Rechte',
						onActivate:switchContent,
						items:function() return [
							{handler:createRoles,label:'Neu'},
							{handler:editRoles,label:'Bearbeiten'},
							{handler:deleteRoles,label:'Löschen'}
						]				
					}
					
				]
			}
		};
		requests = [];
		trace(Reflect.fields(props));
	}
	
	public function createUsers(ev:ReactEvent):Void
	{
		
	}
	public function editUsers(ev:ReactEvent):Void
	{
		
	}
	public function deleteUsers(ev:ReactEvent):Void
	{
		
	}
	
	public function createUserGroups(ev:ReactEvent):Void
	{
		
	}
	public function editUserGroups(ev:ReactEvent):Void
	{
		
	}
	public function deleteUserGroups(ev:ReactEvent):Void
	{
		
	}	
	public function createRoles(ev:ReactEvent):Void
	{
		
	}
	public function editRoles(ev:ReactEvent):Void
	{
		
	}
	public function deleteRoles(ev:ReactEvent):Void
	{
		
	}	
	
	
	public function importExternalUsers(ev:ReactEvent):Void
	{
		trace(ev.currentTarget);
		requests.push(AjaxLoader.load(
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				first_name:props.first_name,
				className:'admin.CreateUsers',
				action:'importExternal'
			},
			function(data){
				trace(data);				
			}
		));
	}
	
	static function mapStateToProps(aState:AppState) {
		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			trace(uState);		
			return {
				user_name:uState.user_name,
				jwt:uState.jwt,
				first_name:uState.first_name
			};
		};
	}	
	
	override public function componentDidMount():Void 
	{
		super.componentDidMount();
		trace(state.loading);
		//trace(App.config);
		/*requests.push(AjaxLoader.load(
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				first_name:props.first_name,
				className:'admin.CreateUsers',
				action:'getViciDialUsers'
			},
			function(data){
				trace('loaded:${!state.loading}'); 
				if (data.length > 0)
				{
					var dataRows:Array<Dynamic> = Json.parse(data).rows;
					//trace(displayRows[0]);
					
					setState({data:['userList'=>dataRows], loading:false});				
					//setState(ReactUtil.copy(state, {data:sData}));				
				}
			}
		));
		requests.push(AjaxLoader.load(
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				first_name:props.first_name,
				className:'admin.CreateUsers',
				action:'getViciDialUsers'
			},
			function(data){
				trace('loaded:${!state.loading}'); 
				if (data.length > 0)
				{
					var dataRows:Array<Dynamic> = Json.parse(data).rows;
					//trace(displayRows[0]);
					
					setState({data:['userList'=>dataRows], loading:false});				
					//setState(ReactUtil.copy(state, {data:sData}));				
				}
			}
		));*/
		requests.push(BinaryLoader.create(
			'${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				className:'roles.Users',
				action:'list',
				filter:'active|TRUE',
				dataSource:Serializer.run([
					"users" => ["alias" => 'us',
						"fields" => 'user_name,last_login'],
					"user_groups" => [
						"alias" => 'ug', 
						"fields" => 'name', 
						"jCond"=>'ug.id=us.user_group'],
					"contacts" => [
						"alias" => 'co', 
						"fields" => 'first_name,last_name,email', 
						"jCond"=>'contact=co.id']
				])
			},
			function(dBytes:Bytes)
			{
				//trace(dBytes.toString());
				var u:hxbit.Serializer = new hxbit.Serializer();
				var data:DbData = u.unserialize(dBytes, DbData);
				trace(Reflect.fields(data));
				trace(data);
				trace(Reflect.fields(data.dataRows[0]));
				setState({dataTable:data.dataRows, loading:false});					
				//setState({data:['userList'=>data.dataRows], loading:false});					
			}
		));
	}
	
	/*override public function componentWillUnmount()
	{
		for (r in requests)
			r.cancel();
	}*/	
	//columnSizerProps = {{}}defaultSort = ${{column:"full_name", direction: SortDirection.ASC}}
    override function render() {
		trace(Reflect.fields(props));
		//trace(state);
		//trace(props);
        return jsx('		
				<div className="columns">
					<div className="tabComponentForm" children={renderContent()} />
					<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks}/>					
				</div>		
        ');
    }	
	
	function renderContent():ReactFragment
	{
		return switch(state.dataClassPath)
		{
			case "userList":
				jsx('
					<Table id="userList" data=${state.dataTable == null? null:state.dataTable}
					${...props} dataState = ${dataDisplay["userList"]} 
					className = "is-striped is-hoverable" fullWidth={true}/>				
				');				
			default:
				null;
		}
	}
	
}

/**
 * 							autoSize = {true} 
							headerClassName = "table tablesorter is-striped is-fullwidth is-hoverable"
							headerColumns=${displayUsers}
							oddClassName="trOdd"
							evenClassName = "trEven"
							sortColumn = "full_name"
							sortDirection = {SortDirection.ASC}
*/