package view.dashboard;

import react.router.RouterMatch;
import react.router.Route.RouteMatchProps;
import react.router.ReactRouter;
import comments.StringTransform;
import haxe.Serializer;
import haxe.ds.StringMap;
import haxe.Json;
import js.html.XMLHttpRequest;
import me.cunity.debug.Out;
import model.AppState;
import react.Fragment;
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.ReactUtil;
import react.ReactType;
import model.AjaxLoader;

import view.shared.io.DataFormProps;
import view.shared.io.FormContainer;
import view.shared.FormState;
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
class Setup extends ReactComponentOf<DataFormProps,FormState>
{
	public function new(?props:FormProps) 
	{
		super(props);	
		//trace('ok');
		trace(props.match.params.section);
		//trace(getRouterMatch().params);
		state = ReactUtil.copy(state, {
			sideMenu:initSideMenu(
				[
					{
						dataClassPath:'model.tools.DB',
						label:'DB Design',
						section: 'DB',
						items: DB.menuItems
					},
					{
						dataClassPath:'model.admin.SyncExternal',
						label:'DB Abgleich',
						section: 'DBSync',
						items: DBSync.menuItems
					}
				],{section: 'DBSync', sameWidth: true}					

			),
			loading:true
		});
		//trace(state);
		requests = [];			
	}
	
	static function mapStateToProps() {

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			//trace(uState);		
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
					var sData:StringMap<Dynamic> = state.data;
					sData.set('historyTrigger', Json.parse(data).data.rows);
					setState(ReactUtil.copy(state, {data:sData}));				
				}
			});			
	}
	
	override public function render() {
		return jsx('<FormContainer ${...props} sideMenu=${state.sideMenu} children=${renderContent}>');
	}

	public function renderContent(container:FormContainer):ReactFragment
	{
		//var match:RouterMatch = getRouterMatch();
		//trace(match.params);
		return switch(props.match.params.section)
		{
			case "DBSync":
				jsx('
					<$DBSync ${...props} componentContainer=${container}
					handleChange={false} handleSubmit={false} fullWidth={true}/>
				');					
			case "DB"|null:
				jsx('
					<$DB ${...props} componentContainer=${container}
					handleChange={false} handleSubmit={false} fullWidth={true}/>
				');				
			default:
				null;					
		}
	}
	
}