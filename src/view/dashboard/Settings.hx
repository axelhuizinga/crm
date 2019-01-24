package view.dashboard;

import react.router.RouterMatch;
import haxe.Json;
import haxe.Serializer;
import haxe.http.HttpJs;
import js.html.XMLHttpRequest;
import me.cunity.debug.Out;
import model.AppState;
import model.AjaxLoader;
import react.React;
import react.ReactComponent.ReactComponentOf;
import react.ReactEvent;
import react.ReactMacro.jsx;
import react.ReactComponent.ReactFragment;
import react.ReactUtil;
//import view.dashboard.model.SettingsFormModel;
import view.shared.io.DataFormProps;
import view.shared.io.Design;
import view.shared.io.FormContainer;
import view.shared.FormState;
import view.shared.OneOf;
import view.shared.SMenu;
import view.shared.io.Bookmarks;
import view.shared.io.User;

/**
 * ...
 * @author axel@cunity.me
 */

//@:connect
class Settings extends ReactComponentOf<DataFormProps,FormState>
{
	//var childFormProps:DataFormProps;	
	public function new(?props:DataFormProps) 
	{
		super(props);	
		/*childFormProps = ReactUtil.copy(props, 
			{fullWidth: true, setStateFromChild:setStateFromChild});*/
		
		state = {
			clean:true,
			hasError:false,
			mounted:false,
			loading:true,
			sideMenu:{}/*initSideMenu(
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
			)*/
		};
		if(props.match.params.section!=null)
		{
			trace(props.match.params.section);
			//state.viewClassPath = state.sideMenu.menuBlocks[props.match.params.section].viewClassPath;
			state.sideMenu.menuBlocks[props.match.params.section].isActive=true;

		}
		trace('${props.match.params.section} ${props.match.params.action}');
	}
	
	override public function componentDidMount():Void 
	{
		super.componentDidMount();
		trace(state.loading);	
		trace(Reflect.fields(props));
		trace(props.match.params.section);				
		trace(props.formContainer);				
		//setState{sideMenu:}
	}
	
	/*override public function switchContent(reactEventSource:Dynamic)
	{
		super.switchContent(reactEventSource);
	}

		
	static function mapStateToProps(aState:AppState) {
		return function(aState:AppState) 
		{
			var uState = aState.appWare.user;
			//trace(uState);		
			return {
				user:uState
			};
		};
	}	*/
	
	override public function render() {
		return jsx('<FormContainer ${...props} sideMenu=${state.sideMenu} render=${renderContent}/>');
	}

	public function renderContent(cState:FormState) {
		trace(props.match.params);
		return switch(props.match.params.section)
		{
			case "user":
				jsx('
					<User ${...props} sideMenu=${state.sideMenu}  formContainer=${cState.formContainer}
					 fullWidth={true}/>
				');	
			case "bookmarks"|null:
				jsx('
					<Bookmarks ${...props} sideMenu=${state.sideMenu}  formContainer=${cState.formContainer}
					 fullWidth={true}/>
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