package view;

import action.AppAction;
import bulma_components.*;
import react.Partial;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactPropTypes;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;

import react.redux.form.Control.ControlProps;
import react.redux.form.Control;
import redux.Redux;
//import redux.react.ReactRedux.connect;
import redux.react.IConnectedComponent;

import Webpack.*;
import AppState;

@:connect
class DashBoard extends ReactComponentOfProps<RouteRenderProps>
	
{
	static var user = {firstName:'dummy'};
	var mounted:Bool = false;
	
	public function new(?props:Dynamic)
	{
		//state = App.store.getState().appWare;
		//trace(props);
		super(props);
		//trace(untyped this.state.history);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyService(error, info);
		trace(error);
	}		
	
	static function mapDispatchToProps(dispatch:Dispatch):Dynamic
    {
		trace(dispatch);
        return {};
    }
	
	function setThemeColor()
	{
		trace('ok');	
		App.store.dispatch(AppAction.SetTheme('violet'));
	}
	
    override function render() {
		//trace(props);
		//var s:ApplicationState = untyped App.store.getState().appWare;
		//trace(this.state);
        return jsx('
		<>
            <div className="tabComponent" >
				<form  id="user-login" >
				 <label htmlFor="user.firstName">Vorname:</label>
				 <ControlText model="user.firstName" id="user.firstName" />
					<button type="submit" className="mb-4 btn btn-primary" >
						Submit 
					</button>					
				</form>
				<Button success={true} onClick={setThemeColor} ><span>Download</span><Icon small={true}><i className="fa fa-download"/></Icon></Button>
            </div>
			<StatusBar {...props}/>
		</>
        ');
    }
}
