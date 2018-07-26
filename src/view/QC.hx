package view;

import react.ReactComponent;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;

import Webpack.*;

@:expose('default')
class QC extends ReactComponentOfProps<RouteRenderProps> 
{
    public static function onLoad() {
		trace(666);
    }	
	
    override function render() {
		trace(props);
        return jsx('
            <div className="dashboard">
			<h3>< div style = ${{color:'green'}} >Route:${props.location.pathname}</div></h3>
            </div>
        ');
    }
}
