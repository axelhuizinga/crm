package view.dashboard;

import haxe.ds.StringMap;
import haxe.Json;
import model.AjaxLoader;
import model.AppState;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactMacro.jsx;
import react.ReactUtil;
import redux.Redux.Dispatch;
import view.shared.BaseForm;
import view.shared.BaseForm.BaseFormProps;
import view.shared.BaseTable;
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
	public function new(?props:Dynamic) 
	{
		super(props);
		trace(Reflect.fields(props));
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
				trace(data); 
				if (!mounted)
				{
					return;
				}
				if (data.length > 0)
				{
					var sData:StringMap<Dynamic> = state.data;
					var displayRows:Array<Dynamic> = Json.parse(data).data.rows;
					//trace(displayRows[0]);
					sData.set('users', displayRows.map(function(row:Dynamic){
						var retRow:Dynamic = {};
						for(fn in fieldNames) {
							Reflect.setField(retRow, fn, fn=='pass'?'xxxxx': Reflect.field(row, fn));
						}
						return retRow;
					}));
					trace(sData.get('users')[0]);
					setState(ReactUtil.copy(state, {data:sData}));				
				}
			}
		);		
	}
	
	
	//
    override function render() {
		trace(Reflect.fields(props));
		trace(props.match);
        return jsx('		
				<div className="columns  ">
					<div className="tabComponentForm columns">
							<BaseTable 
							autoSize={true} 
							headerClassName="trHeader"
							oddClassName="trOdd"
							evenClassName="trEven"
							${...props} data=${state.data.get('users')}/>
					</div>
					<div className="is-right is-hidden-mobile">
						<aside className="menu">
						  <p className="menu-label">
							Allgemein
						  </p>
						  <ul className="menu-list">
							<li><a>Benutzer</a></li>
						  </ul>
						</aside>
					</div>
				</div>		
        ');
    }	
	
}