package view.dashboard;

import comments.StringTransform;
import haxe.Serializer;
import haxe.ds.StringMap;
import haxe.Json;
import js.html.XMLHttpRequest;
import me.cunity.debug.Out;
import model.AppState;
import react.Fragment;
import react.React;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import redux.Redux.Dispatch;
import model.AjaxLoader;
import view.shared.BaseForm;
import view.shared.BaseForm.FormProps;
import view.shared.SMenu;
import view.shared.io.DB;
import view.shared.io.DBSync;
import view.table.Table;

/**
 * ...
 * @author axel@cunity.me
 */

//@:expose('default')
@:connect
class SetUpForm extends BaseForm //<FormProps, FormState>
{
	
	public function new(?props:FormProps) 
	{
		super(props);	
		trace('ok');
		//trace(state);
		state = ReactUtil.copy(state, {
			sideMenu:{
				menuBlocks:[
					'DbTools'=>{
						dataClassPath:'model.tools.DB',
						viewClassPath:'shared.io.DB',
						isActive:false,
						label:'DB Design',
						onActivate:switchContent,
						items:function() return []
					},
					'SyncTools'=>{
						dataClassPath:'model.admin.SyncExternal',
						viewClassPath:'shared.io.DBSync',
						isActive:true,
						label:'DB Sync',
						onActivate:switchContent,
						items:function() return []
					}
				]
			},
			viewClassPath:"shared.io.DBSync",
			loading:true
		});
		//trace(state);
		requests = [];			
		/*sideMenu = 	null; {
			menuBlocks:[
			//{handler:null, label:'Create History Trigger'},//TODO: ADD HANDLER - REMOVE AUTORUN ON MOUNT
			//	{handler:this.importExternalUsers,label:'Importiere Externe Benutzer'}
			]
		};*/
	}
	
	static function mapStateToProps() {

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			trace(uState);		
			return {
				//appConfig:aState.appWare.config,
				user_name:uState.user_name,
				jwt:uState.jwt,
				first_name:uState.first_name
			};
		};
	}	
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		if(mounted)
		this.setState({ hasError: true });
		trace(info);
	}	
	
	override public function componentDidMount():Void 
	{
		super.componentDidMount();
		trace('ok');
		return;
		AjaxLoader.loadData('${App.config.api}', 
			{
				user_name:props.user_name,
				jwt:props.jwt,
				className:'admin.CreateHistoryTrigger',
				action:'run'				
			}, 
			function(data:String){
				trace(data); 
				if (data != null && data.length > 0)
				{
					//trace(Json.parse(data)); 
					var sData:StringMap<Dynamic> = state.data;
					sData.set('historyTrigger', Json.parse(data).data.rows);
					setState(ReactUtil.copy(state, {data:sData}));				
				}
			});			
	}
	
    override public function render() 
	{
		//trace(state.sideMenu);
		return switch(state.viewClassPath)
		{
			case "shared.io.DBSync":
				jsx('
					<$DBSync ${...props} sideMenu=${state.sideMenu}
					handleChange={false} handleSubmit={false} fullWidth={true}/>
				');					
			case "shared.io.DB":
				jsx('
					<DB ${...props} sideMenu=${state.sideMenu}
					handleChange={false} handleSubmit={false} fullWidth={true}/>
				');				
			default:
				null;					
		}
	}

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