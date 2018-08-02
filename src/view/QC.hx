package view;

import react.Partial;
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
import redux.react.IConnectedComponent;
import Webpack.*;
import GlobalAppState;

@:expose('default')
class QC extends ReactComponentOfPropsAndState<RouteRenderProps, GlobalAppState>
	implements IConnectedComponent
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic)
	{
		state = App.store.getState().appWare;
		super(props);
		trace(this.state.themeColor);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
	}
	
	public function mapState(state:AppState, props:Dynamic):Dynamic
	{
		//trace(state);
		if(mounted)
			this.setState(function(_):Partial<GlobalAppState>{ return {themeColor:state.appWare.themeColor};});		
		else
			this.state = state.appWare;
		//trace(state);
		trace(this.state.themeColor);
		return props;
	}
	
    public static function onLoad() {
		trace(666);
    }	
	
    override function render() {
		trace(props);
        return jsx('
            <div className="tabComponent">
			<h3>< div style = ${{color:state.themeColor}} >Route:${props.location.pathname}</div></h3>
            </div>
        ');
    }
}
