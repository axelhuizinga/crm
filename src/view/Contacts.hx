package view;
import bulma_components.*;
import react.ReactComponent;
import react.ReactDateTimeClock;
import react.ReactMacro.jsx;
import react.Partial;
import react.router.Route.RouteRenderProps;
import redux.react.IConnectedComponent;
import redux.StoreMethods;
//import react.form.Form;
//import react.form.Text;


import Webpack.*;
import GlobalAppState;

@:expose('default')
class Contacts extends ReactComponentOfPropsAndState<RouteRenderProps, GlobalAppState>
	implements IConnectedComponent
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic, context:Dynamic)
	{
		trace(context);
		this.state = App.store.getState().appWare;
		super(props);
		trace(this.state);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		trace(this.state);
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyService(error, info);
		trace(error);
	}	
	
	function isClean(newState:GlobalAppState):Bool
	{
		for (f in Reflect.fields(state))
		{
			if (Reflect.field(state, f) != Reflect.field(newState, f))
			{
				trace('$f: ${Reflect.field(state, f)} != ${Reflect.field(newState, f)}');
				return false;
			}
		}
		return true;
	}
	
	public function mapState(state:AppState, props:Dynamic):Partial<GlobalAppState>
	{
		trace(mounted + ' status unchanged? ' + (isClean(state.appWare)? 'Y':'N'));
		if (mounted)
		{
			if (! isClean(state.appWare))
			{
				trace(state.appWare);
				trace(this.state);
				this.setState( {
						themeColor:state.appWare.themeColor,  route:state.appWare.route				
				});					
			}

		}
		else
		{
			trace(state.appWare);
			this.state = state.appWare;
		}
		//trace(state);
		trace(this.state);
		trace(this.state.userList.length+ ' status changed? ' + (this.state != state.appWare?'Y':'N'));
		return {};
	}	
	
    override function render() {
		trace(props.match);
        return jsx('
		<>
            <div className="tabComponent">
				...
            </div>
			<StatusBar {...props}/>
        </>
		');
    }
}
