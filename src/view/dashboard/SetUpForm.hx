package view.dashboard;

import comments.StringTransform;
import haxe.ds.StringMap;
import haxe.Json;
import js.html.XMLHttpRequest;
import model.AppState;
import react.Fragment;
import react.React;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.ReactUtil;
import redux.Redux.Dispatch;
import model.AjaxLoader;
import view.shared.BaseForm;
import view.shared.BaseForm.BaseFormProps;
import view.shared.BaseTable;

/**
 * ...
 * @author axel@cunity.me
 */

//@:expose('default')
@:connect
class SetUpForm extends BaseForm //<BaseFormProps, FormState>
{
	
	static var displayUserGroups:StringMap<BaseCellProps> = [
					'user_group'=>{},
					'group_name'=>{flexGrow:1},
					'allowed_campaigns'=>{flexGrow:1}			
				];
	public function new(?props:BaseFormProps) 
	{
		super(props);	
	}
	
	public function loadData()
	{
		
	}
	
	static function mapStateToProps() {

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			trace(uState);		
			return {
				//appConfig:aState.appWare.config,
				userName:uState.userName,
				jwt:uState.jwt,
				firstName:uState.firstName
			};
		};
	}	
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		this.setState({ hasError: true });
		trace(error);
	}	
	
	override public function componentDidMount():Void 
	{
		//super.componentDidMount();
		var url:String = '${App.config.api}?className=admin.CreateHistoryTrigger&action=run&jwt=${props.jwt}&userName=${props.userName}';
		trace(url);
		AjaxLoader.load(url, null, function(data:String){
			trace(data); 
			if (data != null && data.length > 0)
			{
				//trace(Json.parse(data)); 
				var sData:StringMap<Dynamic> = state.data;
				sData.set('historyTrigger', Json.parse(data).data.rows);
				setState(ReactUtil.copy(state, {data:sData}));				
			}
		});
		
		AjaxLoader.load(
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				className:'admin.CreateUsers',
				action:'fromViciDial'
			},
			function(data){
				//trace(data); 
				if (data.length > 0)
				{
					var sData:StringMap<Dynamic> = state.data;
					var rows:Array<Dynamic> = Json.parse(data).rows;
					var i:Int = 1;
					sData.set('userGroups', rows.map(function(row:Dynamic){
						var retRow:Dynamic = {key:i++};
						for(fn in displayUserGroups.keys()) {
							Reflect.setField(retRow, fn, Reflect.field(row, fn));
						}
						return retRow;
					}));
					setState(ReactUtil.copy(state, {data:sData}));				
				}
			}
		);		
			
	}
	
    override public function render() {
		trace(Reflect.fields(props));
		if (state.hasError)
			return jsx('<h1>Fehler in ${Type.getClassName(Type.getClass(this))}.</h1>');		
		trace(props.history == App.store.getState().appWare.history);
        return jsx('
				<div className="columns  ">
					<div className="tabComponentForm columns level">
							<div className="pBlock" >
								${renderContent(state.data.get('historyTrigger'))}
							</div>

							<div className="pBlock" >
								Dummy
							</div>

							<div className="pBlock" >
								< BaseTable ${...props} data = ${state.data.get('userGroups')}
								headerColumns=${displayUserGroups}/>
							</div>
					</div>
					<div className="is-right is-hidden-mobile">
						<aside className="menu">
						  <p className="menu-label">
							Allgemein
						  </p>
						  <ul className="menu-list">
							<li><a>History Trigger</a></li>
						  </ul>
						</aside>
					</div>
				</div>
        ');
    }	
	//${displayDebug('userGroups')}
	function renderContent(content:Array<String>):ReactFragment
	{
		if (content == null || content.length == 0)
			return null;
		trace(content.length);
		var rC:Array<ReactFragment> = new Array();
		var k:Int = 1;
		for (c in content)
		{
			rC.push(jsx('<div key=${k++}>$c</div>'));
		}
		return rC;
	}
	
}