package view.dashboard;

import react.router.RouterMatch;
//import react.router.Route.RouteMatchProps;
//import react.router.RouteRenderProps;
import react.router.ReactRouter;
import comments.StringTransform;
import haxe.Serializer;
import haxe.ds.StringMap;
import haxe.Json;
import js.html.XMLHttpRequest;
import haxe.http.HttpJs;
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
import view.shared.OneOf;
import view.shared.SMenu;
import view.shared.SMenuProps;
import view.shared.io.DB;
import view.shared.io.DBSync;
import view.table.Table;

/**
 * ...
 * @author axel@cunity.me
 */


class Setup extends ReactComponentOf<DataFormProps,FormState>
{
	//var requests:Array<OneOf<HttpJs, XMLHttpRequest>>;
	public function new(?props:DataFormProps) 
	{
		super(props);	
		//trace('ok');
		trace(props.match.params.section);
		//trace(getRouterMatch().params);
		state = {
			clean:true,
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:{}/*initSideMenu(
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
				]
				,{section: 'DBSync', sameWidth: true}					

			)*/
		};		
	}
	
	/*static function mapStateToProps() {

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
	}	*/
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		if(state.mounted)
		this.setState({ hasError: true });
		trace(info);
	}	
	
	override public function componentDidMount():Void 
	{
		//
		setState({mounted:true});
		trace('${}');
		//TODO: AUTOMATE CREATE HISTORY TRIGGER
		/*AjaxLoader.loadData('${App.config.api}', 
			{
				user_name:props.user.user_name,
				jwt:props.user.jwt,
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
			*/		
	}

	function registerFormContainer(fc:FormContainer)//
	{
		setState({formContainer:fc});
		trace(fc.props.match.params.section);
	}
	
	override public function render() {
		return jsx('<FormContainer ${...props} sideMenu=${state.sideMenu} registerFormContainer=${registerFormContainer} 
		render=${renderContent}/>');
	}

	public function renderContent(cState:FormState):ReactFragment
	{
		//var match:RouterMatch = getRouterMatch();
		//trace(match.params);
		if(state.formContainer!=null)
		trace(state.formContainer.props.match.params.section);
		return switch(props.match.params.section)
		{
			case "DBSync":
				jsx('
					<$DBSync ${...props} formContainer=${cState.formContainer}
					 fullWidth={true}/>
				');					
			case "DB"|null:
				jsx('
					<$DB ${...props} formContainer=${state.formContainer}
					 fullWidth={true}/>
				');				
			default:
				null;					
		}
	}
	
}