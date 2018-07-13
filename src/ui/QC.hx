package ui;

import react.ReactComponent;
import react.ReactMacro.jsx;


import Webpack.*;

class QC extends ReactComponent {

   /* static var STYLES = require('./Foo.css');
	* 
}onSubmit={submitForm}
return jsx('<Form onSubmit={formSubmit} render={formRender}/>');
    static var IMG = require('./bug.png');*/
    static var CONFIG = require('../config.json');
	
    override function render() {
        return jsx('
            <div className="dashboard">
				<form  id="user-login"></form>
            </div>
        ');
    }
}
