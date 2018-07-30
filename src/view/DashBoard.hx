package view;

import action.AppAction;
import bulma_components.Button;
import bulma_components.*;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactPropTypes;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;

import react.redux.form.Control.ControlProps;
import react.redux.form.Control;
import redux.Redux;
import redux.react.ReactRedux.connect;
import redux.react.IConnectedComponent;

import Webpack.*;

typedef ModuleProps =
{
	> RouteRenderProps,
	themeColor:String
}

//@:connect
@:expose('default')
class DashBoard extends ReactComponentOfProps<RouteRenderProps>
	implements IConnectedComponent
{
	static var user = {firstName:'dummy'};
	var mounted:Bool = false;
	
	public function new(?props:Dynamic)
	{
		var s:ApplicationState = untyped App.store.getState().appWare;
		state = {themeColor:s.themeColor};
		super(props,state);
		trace(this.props);
		trace(this.context);
		trace(this.state);
		//unsubscribe = App.store.subscribe(handleChange)
	}
	
	override public function componentWillReceiveProps(nextProps:Dynamic):Void 
	{
		trace(nextProps);
		super.componentWillReceiveProps(nextProps);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
	}
	
	public function mapState(state:ApplicationState, props:Dynamic):Dynamic
	{
		var s:ApplicationState = untyped App.store.getState().appWare;
		trace(s.themeColor);
		if(mounted)
		this.setState(function(_) return {themeColor:s.themeColor});		
		//trace(state);
		//props.themeColor = s.themeColor;
		trace(this.state);
		return props;
	}
	
	static function mapStateToProps(state:ApplicationState):Dynamic
	{
		trace(Reflect.fields(state));
		return {
			locale:state.locale,
			themeColor:state.themeColor
		};
	}	
	
	static function mapDispatchToProps(dispatch:Dispatch):Dynamic
    {
		trace(dispatch);
        return {
            onClick: function() return {}// dispatch(SetTheme('grey'))
        };
    }
	
	function setThemeColor()
	{
		trace('ok');	
		App.store.dispatch(AppAction.SetTheme('violet'));
	}
	
    override function render() {
		//trace(props);
		//var s:ApplicationState = untyped App.store.getState().appWare;
		trace(state);
		var c = state.themeColor;// 'red';
        return jsx('
            <div className="tabComponent" >
			<h3>< div style = ${{color:c}} >Route:${props.location.pathname}</div></h3>
				<form  id="user-login" >
				 <label htmlFor="user.firstName">Vorname:</label>
				 <ControlText model="user.firstName" id="user.firstName" />
					<button type="submit" className="mb-4 btn btn-primary" >
						Submit 
					</button>					
				</form>
				<Button success={true} onClick={setThemeColor} ><span>Download</span><Icon small={true}><i className="fa fa-download"/></Icon></Button>
            </div>
        ');
    }
}
