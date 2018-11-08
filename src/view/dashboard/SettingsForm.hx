package view.dashboard;

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
			trace(props.jwt);
		}		
		state = {
			clean:true,
			viewClassPath:"shared.io.User",
			hasError:false,
			loading:true,
			sideMenu:{
				menuBlocks:[
					'user'=>{
						dataClassPath:'auth.User',
						viewClassPath:'shared.io.User',
						isActive:true,
						label:'UserDaten',
						onActivate:switchContent,
						items: null//User.menuItems
					},
					'bookmarks'=>{
						dataClassPath:'settings.Bookmarks',
						viewClassPath:'shared.io.Bookmarks',
						label:'Lesezeichen',
						onActivate:switchContent,
						items:function() return [
							{handler:createUserBookmark,label:'Neu',segment:'create'},
							{handler:editUserBookmark,label:'Bearbeiten',segment:'edit'},
							{handler:deleteUserBookmark,label:'Löschen',segment:'delete'}
						]
					},
					'design'=>{
						dataClassPath:'settings.Design',
						viewClassPath:'shared.io.Design',
						label:'Design',
						onActivate:switchContent,
						items:function() return [
							{handler:editColors,label:'Farben',segment:'editColors'},
							{handler:editFonts,label:'Schrift',segment:'editFont'}
						]
					}				
				]
			}
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
			trace(uState);		
			return {
				userName:uState.userName,
				jwt:uState.jwt,
				firstName:uState.firstName
			};
		};
	}	
	
	override public function render() {
        return switch(state.viewClassPath)
		{
			case "shared.io.User":
				jsx('
					<User ${...childFormProps} sideMenu=${state.sideMenu}
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