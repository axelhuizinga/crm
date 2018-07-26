package view;

import react.ReactComponent;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
//import react.form.Form;
//import react.form.Text;


import Webpack.*;
@:expose('default')
class Accounting extends ReactComponentOfProps<RouteRenderProps>
{	
    override function render() {
        return jsx('
            <div className="tabComponent">

            </div>
        ');
    }
}
