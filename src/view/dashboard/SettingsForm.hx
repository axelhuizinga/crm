package view.dashboard;

import react.router.RouterMatch;
import haxe.Json;
import haxe.Serializer;
import me.cunity.debug.Out;
import model.AppState;
import model.AjaxLoader;
import react.React;
import react.ReactComponent.ReactComponentOfProps;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactComponent.ReactFragment;
import react.ReactUtil;
import view.dashboard.model.SettingsFormModel;
import view.shared.io.DataAccessForm.DataFormProps;
import view.shared.RouteTabProps;
import view.shared.BaseForm;
import view.shared.SMenu;
import view.shared.io.Bookmarks;
import view.shared.io.User;

/**
 * ...
 * @author axel@cunity.me
 */

@:connect
class SettingsForm extends BaseForm
{
	var childFormProps:DataFormProps;	
	
	public function new(?props:FormProps) 
	{
		super(props);	
		childFormProps = ReactUtil.copy(props, 
			{fullWidth: true, setStateFromChild:setStateFromChild});
		
		if (props.jwt == null)
		{
			trace(props);
		}
		else{
			//trace(props.jwt);
		}	
		state = {
			clean:true,
			//viewClassPath:"shared.io.User",
			viewClassPath:null,
			hasError:false,
			loading:true,
			sideMenu:{
				menuBlocks:[
					'user'=>{
						dataClassPath:'auth.User',
						viewClassPath:'shared.io.User',
						label:'UserDaten',
						onActivate:switchContent,
						items: function()return [
							{handler:null, label:'Speichern', disabled:state.clean},
							{handler:null, label:'Passwort ändern'},
						],
						section: 'user'
					},
					'bookmarks'=>{
						dataClassPath:'settings.Bookmarks',
						viewClassPath:'shared.io.Bookmarks',
						label:'Lesezeichen',
						onActivate:switchContent,
						items:function() return [
							{handler:createUserBookmark,label:'Neu',action:'create'},
							{handler:editUserBookmark,label:'Bearbeiten',action:'edit'},
							{handler:deleteUserBookmark,label:'Löschen',action:'delete'}
						],
						section: 'bookmarks'
					},
					'design'=>{
						dataClassPath:'settings.Design',
						viewClassPath:'shared.io.Design',
						label:'Design',
						onActivate:switchContent,
						items:function() return [
							{handler:editColors,label:'Farben',action:'editColors'},
							{handler:editFonts,label:'Schrift',action:'editFont'}
						],
						section: 'design'
					}				
				],
				section: 'bookmarks',
				sameWidth: true
			}
		};
		if(props.match.params.section!=null)
		{
			trace(props.match.params.section);
			state.viewClassPath = state.sideMenu.menuBlocks[props.match.params.section].viewClassPath;
			state.sideMenu.menuBlocks[props.match.params.section].isActive=true;

		}
		trace('${props.match.params.section} ${state.viewClassPath}');
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
	
	public function menuBlockItems():Array<SMItem>
	{
		return [];
	}
	override public function switchContent(reactEventSource:Dynamic)
	{
		super.switchContent(reactEventSource);
	}

		
	static function mapStateToProps(aState:AppState) {
		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			//trace(uState);		
			return {
				user_name:uState.user_name,
				jwt:uState.jwt,
				first_name:uState.first_name
			};
		};
	}	
	
	override public function render() {
		var match:RouterMatch = getRouterMatch();
		trace(match.params);
		return switch(match.params.section)
		{
			case "user":
				jsx('
					<User ${...childFormProps} sideMenu=${state.sideMenu}
					handleChange={true} handleSubmit={true} fullWidth={true}/>
				');	
			case "bookmarks"|null:
				jsx('
					<Bookmarks ${...childFormProps} sideMenu=${state.sideMenu}
					handleChange={true} handleSubmit={true} fullWidth={true}/>
				');
			default:		
				null;		
		}				
    }	
	/*
    override public function render() {
        return jsx('		
				<div className="columns">
					<div className="tabComponentForm" children={renderContent()} />
					<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks} />					
				</div>		
        ');
    }	
	
	function renderContent():ReactFragment
	{
		return switch(state.viewClassPath)
		{
			case "shared.io.User":
				jsx('
					<User ${...childFormProps} handleChange={true} handleSubmit={true} fullWidth={true}/>				
				');				
			default:
				null;
		}
	}*/
	
}