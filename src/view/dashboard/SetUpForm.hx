package view.dashboard;

import comments.StringTransform;
import haxe.http.HttpJs;
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
import view.shared.BaseForm;
import view.shared.BaseForm.BaseFormProps;

/**
 * ...
 * @author axel@cunity.me
 */

@:connect
class SetUpForm extends BaseForm//ReactComponentOf<RouteTabProps, Dynamic> 
{

	public function new(?props:BaseFormProps) 
	{
		super(props);	
		
	}
	
	static function mapStateToProps() {

		return function(aState:model.AppState) 
		{
			var uState = aState.appWare.user;
			trace(uState);			
			return {
				appConfig:aState.appWare.config,
				id:uState.id,
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
		var url:String = 'https://pitverwaltung.de/server.php?className=admin.CreateHistoryTrigger&action=run&jwt=${props.jwt}&user=${props.id}';
		trace(url);
		//var req:HttpJs = new HttpJs(url);
		var req:XMLHttpRequest = new XMLHttpRequest('');
		req.open('GET', url, true);
		req.onerror = function(err:Dynamic) trace(err);
		req.onreadystatechange = function(){
			trace(req.responseText); 
			if (req.responseText.length > 0)
			{
				trace(Json.parse(req.responseText)); 	
				setState(ReactUtil.copy(state, Json.parse(req.responseText)));				
			}
		};
		req.send();
	}
	//style=${{display:'flex',flexBasis: "auto", flexGrow: 1, flexShrink:0 }}
    override public function render() {
		trace(Reflect.fields(props));
		if (state.hasError)
			return jsx('<h1>Fehler in ${Type.getClassName(Type.getClass(this))}.</h1>');		
		trace(props.history == App.store.getState().appWare.history);
        return jsx('
				<div className="columns  is-flex is-fullheight">
					<div className="tabComponentForm column level">
							<div className="level-item" >
							<p style={{border:"1px solid #801111", borderRadius:"1rem", padding:"1rem"}}>
								${renderContent(state.content)}
							</p>
							</div>
					</div>
					<div className="column is-2 is-sidebar-menu is-right is-hidden-mobile">
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
	
	function renderContent(content:Array<String>):ReactFragment
	{
		if (content.length == 0)
			return null;
		var rC:Array<ReactFragment> = new Array();
		for (c in content)
		{
			rC.push(jsx('<div>$c</div>'));
		}
		return rC;
	}
	
}