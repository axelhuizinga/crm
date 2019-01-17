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
import view.shared.io.Design;
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
			hasError:false,
			loading:true,
			sideMenu:initSideMenu(
				[
					{
						dataClassPath:'auth.User',
						label:'UserDaten',
						section: 'user',
						items: User.menuItems
					},
					{
						dataClassPath:'settings.Bookmarks',
						label:'Lesezeichen',
						section: 'bookmarks',
						items: Bookmarks.menuItems
					},
					{
						dataClassPath:'settings.Design',
						label:'Design',
						section: 'design',
						items: Design.menuItems
					},										
				],
				{section: 'bookmarks',	sameWidth: true}
			)
		};
		if(props.match.params.section!=null)
		{
			trace(props.match.params.section);
			//state.viewClassPath = state.sideMenu.menuBlocks[props.match.params.section].viewClassPath;
			state.sideMenu.menuBlocks[props.match.params.section].isActive=true;

		}
		trace('${props.match.params.section} ${props.match.params.action}');
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
		trace(props.match.params);				
	}
	
	/*override public function switchContent(reactEventSource:Dynamic)
	{
		super.switchContent(reactEventSource);
	}*/

		
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
		return super.render();
	}

	override public function renderContent() {
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