package view;
import bulma_components.*;
import action.AppAction;
import react.ReactComponent;
import react.ReactDateTimeClock;
import react.ReactMacro.jsx;
import react.Partial;
import react.router.Route.RouteRenderProps;
import redux.react.IConnectedComponent;
import redux.Redux;
import redux.StoreMethods;
//import react.form.Form;
//import react.form.Text;


import Webpack.*;
import AppState;

@:connect
class Accounting extends ReactComponentOfProps<RouteRenderProps>
	
{
	var mounted:Bool = false;
	
	public function new(?props:Dynamic, context:Dynamic)
	{
		trace(context);
		//this.state = App.store.getState().appWare;
		super(props);
		//trace(this.state);
	}
		
	static function mapStateToProps() {
		//var getVisibleTodos = TodoSelector.makeGetVisibleTodos();

		return function(state:AppState) {
			trace(state);
			return {
				
			};
		};
	}

	static function mapDispatchToProps(dispatch:Dispatch) {
		return {
			onTodoClick: function(id:Int) return dispatch(AppAction.SetTheme('orange'))
		};
	}
	
	override public function componentDidMount():Void 
	{
		mounted = true;
		//trace(state);
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		//this.setState({ hasError: true });
		// You can also log the error to an error reporting service
		//logErrorToMyService(error, info);
		trace(error);
	}	
	
    override function render() {
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
