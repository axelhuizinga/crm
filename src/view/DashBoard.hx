package view;

import bulma_components.Button;
import bulma_components.*;
import react.ReactComponent;
import react.ReactPropTypes;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;

import react.redux.form.Control.ControlProps;
import react.redux.form.Control;


import Webpack.*;
@:expose('default')
class DashBoard extends ReactComponentOfProps<RouteRenderProps>
{
	static var user = {firstName:'dummy'};
	
	function dump(el:Dynamic)
	{
		trace(el);
		return 'OK';
	}
	
    override function render() {
		trace(props);
        return jsx('
            <div className="tabComponent" >
				<form  id="user-login">
				 <label htmlFor="user.firstName">Vorname:</label>
				 <ControlText model="user.firstName" id="user.firstName" />
					<button type="submit" className="mb-4 btn btn-primary">
						Submit 
					</button>					
				</form>
				<Button success={true}><span>Download</span><Icon small={true}><i className="fa fa-download"/></Icon></Button>
            </div>
        ');
    }
}
