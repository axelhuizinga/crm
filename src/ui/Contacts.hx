package ui;

import react.ReactComponent;
import react.ReactMacro.jsx;

//import react.form.Form;
//import react.form.Text;


import Webpack.*;

class Contacts extends ReactComponent {

    static var CONFIG = require('../config.json');
	
    override function render() {
        return jsx('
            <div className="dashboard">

            </div>
        ');
    }
}
