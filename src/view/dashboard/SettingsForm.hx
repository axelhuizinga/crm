package view.dashboard;

import haxe.Json;
import haxe.Serializer;
import me.cunity.debug.Out;
import model.AppState;
import model.AjaxLoader;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactComponent.ReactFragment;
import view.dashboard.model.SettingsFormModel;
import view.shared.FormUi;
import view.shared.RouteTabProps;
import view.shared.BaseForm;
import view.shared.SMenu;

/**
 * ...
 * @author axel@cunity.me
 */

@:connect
class SettingsForm extends BaseForm
{

	public function new(?props:FormProps) 
	{
		super(props);		
		//dataDisplay = SettingsFormModel.dataDisplay;
		if (props.jwt == null)
		{
			trace(props);
		}
		else{
			trace(props.jwt);
		}
		sideMenu = {
			menuBlocks:[
				{
					codeClass:'auth.User',
					isActive:true,
					label:'Meine KontoDaten',
					onActivate:switchContent,
					items:[
						{handler:editMe,label:'Bearbeiten',segment:'edit'}
					],
					segment:'user'
				},
				{
					codeClass:'settings.Bookmarks',
					label:'Lesezeichen',
					onActivate:switchContent,
					items:[
						{handler:createUserBookmark,label:'Neu',segment:'create'},
						{handler:editUserBookmark,label:'Bearbeiten',segment:'edit'},
						{handler:deleteUserBookmark,label:'Löschen',segment:'delete'}
					],
					segment:'bookmarks'
				},
				{
					codeClass:'settings.Design',
					label:'Design',
					onActivate:switchContent,
					items:[
						{handler:editColors,label:'Farben',segment:'editColors'},
						{handler:editFonts,label:'Schrift',segment:'editFont'}
					],
					segment:'design'
				}
				
			]
		};
		state = {
			clean:true,
			classPath:"auth.User",
			hasError:false,
			loading:true
		};
		requests = [];		
	}
	
	override public function componentDidMount():Void 
	{
		super.componentDidMount();
		trace(state.loading);	
		if (props.jwt == null)
		{
			trace(props);
			return;
		}
		//return;
		trace(Reflect.fields(props));
		trace(props.match);
				
	}
	
	public function createUserBookmark(ev:ReactEvent):Void
	{
		
	}
	public function deleteUserBookmark(ev:ReactEvent):Void
	{
		
	}
	public function editColors(ev:ReactEvent):Void
	{
		
	}	
	public function editFonts(ev:ReactEvent):Void
	{
		
	}
	public function editUserBookmark(ev:ReactEvent):Void
	{
		
	}
	public function editMe(ev:ReactEvent):Void
	{
		trace('hi :)');
		requests.push(AjaxLoader.load(	
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				className:'auth.User',
				action:'edit',
				filter:'user_name|${props.userName}',
				dataSource:Serializer.run(view.shared.io.User.userModel)
			},
			function(data:Dynamic )
			{
				if (data.rows == null)
					return;
				trace(data.rows.length);
				var dataRows:Array<Dynamic> = data.rows;
				trace(Reflect.fields(dataRows[0]));
				trace(dataRows[0].active);
				setState({data:['accountData'=>dataRows], loading:false});					
			}
		));
		setState({classPath:"edit"});
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
	
    override public function render() {
		//trace(Reflect.fields(props));
		//trace(props.match);
		//trace(props.history == App.store.getState().appWare.history);
        return jsx('		
				<div className="columns">
					<div className="tabComponentForm" children={renderContent()} />
					<SMenu className="menu" menuBlocks={sideMenu.menuBlocks}/>					
				</div>		
        ');
    }	
	
	function renderContent():ReactFragment
	{
		trace(state.classPath);
		return switch(state.classPath)
		{
			case "user":
				jsx('
					<FormUi name="accountData" data=${state.data == null? null:state.data["accountData"]}
					${...props} fullWidth={true}/>				
				');				
			default:
				null;
		}
	}
	
}