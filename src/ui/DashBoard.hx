package ui;

import bulma_components.Button;
import react.ReactComponent;
import react.ReactPropTypes;
import react.ReactMacro.jsx;

//import react.redux.form.Control.ControlProps;
import react.redux.form.Control;


import Webpack.*;

class DashBoard extends ReactComponentOfProps<ControlProps> {

    static var CONFIG = require('../config.json');
	static var user = {firstName:'dummy'};
	
    override function render() {
        return jsx('
            <div className="dashboard">
				<form  id="user-login">
				 <label htmlFor="user.firstName">Vorname:</label>
				 <ControlText model="user.firstName" id="user.firstName" />
					<button type="submit" className="mb-4 btn btn-primary">
						Submit
					</button>					
				</form>
				<Button icon="download" iconRight="true">Download</Button>
            </div>
        ');
    }
}
