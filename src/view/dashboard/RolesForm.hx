package view.dashboard;

import haxe.ds.StringMap;
import haxe.Json;
import model.AjaxLoader;
import model.AppState;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import redux.Redux.Dispatch;
import view.shared.BaseForm;
import view.shared.BaseForm.BaseFormProps;
import view.shared.BaseTable;
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
	var fieldNames:Array<String>;
	var sideMenu:Array<SMItem>;
	//user,pass,full_name,user_level,user_group,active
	static var displayUsers:StringMap<BaseCellProps> = [
					'user'=>{},
					'full_name'=>{flexGrow:1},
					'user_level'=>{className:'cRight'},		
					'user_group'=>{flexGrow:1},		
					'active'=>{className:'cRight'},		
				];	
	public function new(?props:Dynamic) 
	{
		super(props);
		sideMenu = [
			{handler:this.importExternalUsers,label:'Importiere Externe Benutzer'}
		];
		trace(Reflect.fields(props));
	}
	
	public function importExternalUsers(ev:ReactEvent):Void
	{
		trace(ev.currentTarget);
		AjaxLoader.load(
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
		);
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
		super.componentDidMount();
		trace(mounted);
		fieldNames = "user,pass,full_name,user_level,user_group,active".split(',');		
		AjaxLoader.load(
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				firstName:props.firstName,
				className:'admin.CreateUsers',
				action:'getViciDialUsers'
			},
			function(data){
				trace('loaded'); 
				if (!mounted)
				{
					return;
				}
				if (data.length > 0)
				{
					var sData:StringMap<Dynamic> = state.data;
					var displayRows:Array<Dynamic> = Json.parse(data).rows;
					//trace(displayRows[0]);
					sData.set('users', displayRows.map(function(row:Dynamic){
						var retRow:Dynamic = {};
						for(fn in fieldNames) {
							Reflect.setField(retRow, fn, fn=='pass'?'xxxxx': Reflect.field(row, fn));
						}
						return retRow;
					}));
					trace(sData.get('users')[0]);
					setState({data:sData});				
					//setState(ReactUtil.copy(state, {data:sData}));				
				}
			}
		);		
	}
	
	
	//columnSizerProps = {{}}
    override function render() {
		trace(Reflect.fields(props));
		trace(props.match);
        return jsx('		
				<div className="columns  ">
					<div className="tabComponentForm columns">
							<BaseTable 
							autoSize = {true} 
							height = {100}
							headerClassName = "trHeader"
							headerColumns=${displayUsers}
							oddClassName="trOdd"
							evenClassName = "trEven"
							sortBy = "full_name"
							${...props} data=${state.data.get('users')}/>
					</div>
					<SMenu className="menu" itemsData={sideMenu}/>					
				</div>		
        ');
    }	
	
}