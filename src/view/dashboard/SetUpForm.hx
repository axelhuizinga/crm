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
						isActive:true,
						label:'DB Design',
						onActivate:switchContent,
						items:function() return []
					}				
				]
			},
			viewClassPath:"shared.io.DB",
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
				userName:uState.userName,
				jwt:uState.jwt,
				firstName:uState.firstName
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
				userName:props.userName,
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
		/*
		AjaxLoader.loadData(
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				className:'admin.CreateUsers',
				action:'fromViciDial'
			},
			function(data){
				//trace(data); 
				var rows:Array<Dynamic> = [].concat(data.rows);
				if (rows.length > 0)
				{
					var sData:StringMap<Dynamic> = state.data;
					
					var i:Int = 1;
					sData.set('userGroups', rows.map(function(row:Dynamic){
						var retRow:Dynamic = {key:i++};
						for(fn in dataDisplay["userGroups"].columns.keys()) {
							Reflect.setField(retRow, fn, Reflect.field(row, fn));
						}
						return retRow;
					}));
					setState(ReactUtil.copy(state, {data:sData}));				
				}
			}
		);	*/	
			
	}
	
	public function importExternalUsers(ev:ReactEvent):Void
	{
		Out.dumpObjectTree(ev);
		trace(untyped ev.currentTarget._targetInst);
		/*requests.push(AjaxLoader.loadData(
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
		));*/
		
		requests.push(AjaxLoader.loadData(
			'${App.config.api}', 
			{
				userName:props.userName,
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
			function(data){
				trace(data);
			}
		));
	}
	
    override public function render() 
	{
		trace(state.sideMenu);
		return switch(state.viewClassPath)
		{
			case "shared.io.DB":
				jsx('
					<DB ${...props} sideMenu=${state.sideMenu}
					handleChange={false} handleSubmit={false} fullWidth={true}/>
				');				
			default:
				null;					
		}
	}
	
    public function render2() {
		trace(Reflect.fields(props));
		trace(state.data == null);
		if (state.data == null)
			return null;
		if (state.hasError)
			return jsx('<h1>Fehler in ${Type.getClassName(Type.getClass(this))}.</h1>');		
        return jsx('
				<div className="columns  ">
					<div className="tabComponentForm columns">
							<div className="pBlock" >
								${renderContent(state.data.get('historyTrigger'))}
							</div>						
					</div>
					<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks}/>
				</div>
        ');
    }	
	//${displayDebug('userGroups')}<div className="pBlock" ></div>
	/**
							<div className="pBlock" >
								Dummy
							</div>
							
								<Table id="userGroups" ${...props} data = ${state.data.get('userGroups')}
								dataState = ${dataDisplay["userGroups"]}
								className = "is-striped is-fullwidth is-hoverable"/>	   
	
	**/
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