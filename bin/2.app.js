webpackJsonp([2],{

/***/ "./node_modules/haxe-loader/index.js?build/view_DashBoard!./":
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {/* eslint-disable */ 
var $hx_exports = module.exports, $global = global;
var $s = $global.$hx_scope;
var React_Component = $s.a, $extend = $s.b, haxe_Log = $s.c, React = $s.d;
$hx_exports["me"] = $hx_exports["me"] || {};
$hx_exports["me"]["cunity"] = $hx_exports["me"]["cunity"] || {};
$hx_exports["me"]["cunity"]["debug"] = $hx_exports["me"]["cunity"]["debug"] || {};
$hx_exports["me"]["cunity"]["debug"]["Out"] = $hx_exports["me"]["cunity"]["debug"]["Out"] || {};
var bulma_$components_Button = __webpack_require__("./node_modules/reactbulma/lib/components/index.js").Button;
var Icon = __webpack_require__("./node_modules/reactbulma/lib/components/index.js").Icon;
var react_redux_form_ControlText = __webpack_require__("./node_modules/react-redux-form/lib/index.js").Control.text;
var view_DashBoard = $hx_exports["default"] = function(props,context) {
	React_Component.call(this,props,context);
};
view_DashBoard.__name__ = ["view","DashBoard"];
view_DashBoard.__super__ = React_Component;
view_DashBoard.prototype = $extend(React_Component.prototype,{
	dump: function(el) {
		haxe_Log.trace(el,{ fileName : "DashBoard.hx", lineNumber : 22, className : "view.DashBoard", methodName : "dump"});
		return "OK";
	}
	,render: function() {
		haxe_Log.trace(this.props,{ fileName : "DashBoard.hx", lineNumber : 27, className : "view.DashBoard", methodName : "render"});
		var tmp = $$tre;
		var tmp1 = { "$$typeof" : $$tre, type : "form", props : { id : "user-login", children : [{ "$$typeof" : $$tre, type : "label", props : { htmlFor : "user.firstName", children : "Vorname:"}, key : null, ref : null},React.createElement(react_redux_form_ControlText,{ id : "user.firstName", model : "user.firstName"}),{ "$$typeof" : $$tre, type : "button", props : { type : "submit", className : "mb-4 btn btn-primary", children : "Submit "}, key : null, ref : null},"\t\t\t\t\t"]}, key : null, ref : null};
		var tmp2 = { "$$typeof" : $$tre, type : "span", props : { children : "Download"}, key : null, ref : null};
		var tmp3 = React.createElement(Icon,{ small : true},{ "$$typeof" : $$tre, type : "i", props : { className : "fa fa-download"}, key : null, ref : null});
		return { $$typeof : tmp, type : "div", props : { className : "tabComponent", children : [tmp1,React.createElement(bulma_$components_Button,{ success : true},tmp2,tmp3)]}, key : null, ref : null};
	}
	,__class__: view_DashBoard
});
var $_, $fid = 0;
var $$tre = (typeof Symbol === "function" && Symbol.for && Symbol.for("react.element")) || 0xeac7;
view_DashBoard.user = { firstName : "dummy"};
view_DashBoard.displayName = "DashBoard";
$s.view_DashBoard = view_DashBoard; 

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__("./node_modules/webpack/buildin/global.js")))

/***/ })

});