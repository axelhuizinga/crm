package view.dashboard;

import gigatables_react.Reactables.ReactableSettings;
import haxe.ds.StringMap;
import haxe.Json;
import haxe.http.HttpJs;
import model.AjaxLoader;
import model.AppState;
import view.shared.BaseForm;
import view.table.Table;
//import view.grid.Grid.DataCell;
//import view.grid.Grid.SortDirection;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import redux.Redux.Dispatch;
import view.dashboard.model.RolesFormModel;
import view.shared.BaseForm.BaseFormProps;
import view.shared.SMenu;
using Lambda;
/**
 * ...
 * @author axel@cunity.me
 */

//@:expose('default')
@:connect
class RolesForm extends BaseForm
{
	//var requests:Array<HttpJs>;
// StringMap<DataState>;
	var sideMenu:Array<SMItem>;
	//user,pass,full_name,user_level,user_group,active
		
	var settings: ReactableSettings;
	
	public function new(?props:BaseFormProps) 
	{
		super(props);
		
		sideMenu = [
			{handler:this.importExternalUsers,label:'Importiere Externe Benutzer'}
		];
		state = {
			clean:true,
			hasError:false,
			loading:true
		};
		requests = [];
		trace(Reflect.fields(props));
	}
	
	public function importExternalUsers(ev:ReactEvent):Void
	{
		trace(ev.currentTarget);
		requests.push(AjaxLoader.load(
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				firstName:props.firstName,
				className:'admin.CreateUsers',
				action:'importExternal'
			},
			function(data){
				if (data.length > 0)
				{
					trace(Json.parse(data));
				}
			}
		));
	}
	
	static function mapStateToProps(aState:AppState) {
		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			trace(uState);		
			return {
				userName:uState.userName,
				jwt:uState.jwt,
				firstName:uState.firstName
			};
		};
	}	
	
	override public function componentDidMount():Void 
	{
		//super.componentDidMount();
		trace(state.loading);
		requests.push(AjaxLoader.load(
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				firstName:props.firstName,
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
					<div className="tabComponentForm">
							<Table id="userList" data=${state.data == null? null:state.data["userList"]}
							${...props} dataState = ${dataDisplay["userList"]}
							className = "is-striped is-fullwidth is-hoverable"/>
					</div>
					<SMenu className="menu" itemsData={sideMenu}/>					
				</div>		
        ');
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