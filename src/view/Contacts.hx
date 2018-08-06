package view;
import bulma_components.*;
import me.cunity.debug.Out;
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

@:connect
class Contacts extends ReactComponentOfProps<RouteRenderProps>
	
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic, context:Dynamic)
	{
		trace(context);
		//this.state = App.store.getState().appWare;
		super(props);
		//trace(this.state);
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		//trace(this.state);
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyService(error, info);
		trace(error);
	}	
	
    override function render() {
		//trace(props.match);
		Out.dumpObjectTree(props);
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
