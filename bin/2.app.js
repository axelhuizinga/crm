webpackJsonp([2],{

/***/ "./node_modules/haxe-loader/index.js?build/view_DashBoard!./":
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(global) {/* eslint-disable */ 
var $hx_exports = module.exports, $global = global;
var $s = $global.$hx_scope;
var React_Component = $s.a, haxe_Log = $s.b, react_ReactUtil = $s.c, redux__$Redux_Action_$Impl_$ = $s.d, action_AppAction = $s.e, $extend = $s.f, App = $s.g, React = $s.h, $bind = $s.i, PropTypes = $s.j;
$hx_exports["me"] = $hx_exports["me"] || {};
$hx_exports["me"]["cunity"] = $hx_exports["me"]["cunity"] || {};
$hx_exports["me"]["cunity"]["debug"] = $hx_exports["me"]["cunity"]["debug"] || {};
$hx_exports["me"]["cunity"]["debug"]["Out"] = $hx_exports["me"]["cunity"]["debug"]["Out"] || {};
var bulma_$components_Button = __webpack_require__("./node_modules/reactbulma/lib/components/index.js").Button;
var Icon = __webpack_require__("./node_modules/reactbulma/lib/components/index.js").Icon;
var react_redux_form_ControlText = __webpack_require__("./node_modules/react-redux-form/lib/index.js").Control.text;
var redux_react_IConnectedComponent = function() { };
redux_react_IConnectedComponent.__name__ = ["redux","react","IConnectedComponent"];
var view_DashBoard = $hx_exports["default"] = function(props,state) {
	React_Component.call(this,props,state);
	haxe_Log.trace(this.props,{ fileName : "DashBoard.hx", lineNumber : 30, className : "view.DashBoard", methodName : "new"});
	haxe_Log.trace(this.context,{ fileName : "DashBoard.hx", lineNumber : 31, className : "view.DashBoard", methodName : "new"});
	haxe_Log.trace(this.state,{ fileName : "DashBoard.hx", lineNumber : 32, className : "view.DashBoard", methodName : "new"});
	this.__state = this.mapState(this.context.store.getState(),props);
	if(state == null) {
		state = this.__state;
	} else {
		state = react_ReactUtil.copy(state,this.__state);
	}
};
view_DashBoard.__name__ = ["view","DashBoard"];
view_DashBoard.__interfaces__ = [redux_react_IConnectedComponent];
view_DashBoard.mapStateToProps = function(state) {
	return { locale : state.locale, themeColor : state.themeColor};
};
view_DashBoard.mapDispatchToProps = function(dispatch) {
	haxe_Log.trace(dispatch,{ fileName : "DashBoard.hx", lineNumber : 64, className : "view.DashBoard", methodName : "mapDispatchToProps"});
	return { onClick : function() {
		return dispatch(redux__$Redux_Action_$Impl_$.map(action_AppAction.SetTheme("grey")));
	}};
};
view_DashBoard.__super__ = React_Component;
view_DashBoard.prototype = $extend(React_Component.prototype,{
	componentWillReceiveProps: function(nextProps) {
		haxe_Log.trace(nextProps,{ fileName : "DashBoard.hx", lineNumber : 38, className : "view.DashBoard", methodName : "componentWillReceiveProps"});
		React_Component.prototype.componentWillReceiveProps.call(this,nextProps);
	}
	,mapState: function(state,props) {
		var s = App.store.getState().appWare;
		haxe_Log.trace(s.themeColor,{ fileName : "DashBoard.hx", lineNumber : 45, className : "view.DashBoard", methodName : "mapState"});
		this.state = s;
		props.themeColor = s.themeColor;
		haxe_Log.trace(props,{ fileName : "DashBoard.hx", lineNumber : 49, className : "view.DashBoard", methodName : "mapState"});
		return props;
	}
	,setThemeColor: function() {
		haxe_Log.trace("ok",{ fileName : "DashBoard.hx", lineNumber : 72, className : "view.DashBoard", methodName : "setThemeColor"});
		App.store.dispatch(redux__$Redux_Action_$Impl_$.map(action_AppAction.SetTheme("violet")));
	}
	,render: function() {
		haxe_Log.trace(this.state,{ fileName : "DashBoard.hx", lineNumber : 79, className : "view.DashBoard", methodName : "render"});
		var c = this.state.themeColor;
		var tmp = $$tre;
		var tmp1 = { "$$typeof" : $$tre, type : "h3", props : { children : { "$$typeof" : $$tre, type : "div", props : { style : { color : c}, children : ["Route:",this.props.location.pathname]}, key : null, ref : null}}, key : null, ref : null};
		var tmp2 = { "$$typeof" : $$tre, type : "form", props : { id : "user-login", children : [{ "$$typeof" : $$tre, type : "label", props : { htmlFor : "user.firstName", children : "Vorname:"}, key : null, ref : null},React.createElement(react_redux_form_ControlText,{ id : "user.firstName", model : "user.firstName"}),{ "$$typeof" : $$tre, type : "button", props : { type : "submit", className : "mb-4 btn btn-primary", children : "Submit "}, key : null, ref : null},"\t\t\t\t\t"]}, key : null, ref : null};
		var tmp3 = { "$$typeof" : $$tre, type : "span", props : { children : "Download"}, key : null, ref : null};
		var tmp4 = React.createElement(Icon,{ small : true},{ "$$typeof" : $$tre, type : "i", props : { className : "fa fa-download"}, key : null, ref : null});
		return { $$typeof : tmp, type : "div", props : { className : "tabComponent", children : [tmp1,tmp2,React.createElement(bulma_$components_Button,{ success : true, onClick : $bind(this,this.setThemeColor)},tmp3,tmp4)]}, key : null, ref : null};
	}
	,dispatch: function(action) {
		return this.context.store.dispatch(action);
	}
	,__unsubscribe: null
	,__state: null
	,__connect: function() {
		if(this.__unsubscribe != null) {
			var state = this.mapState(this.context.store.getState(),this.props);
			if(this.__state == null || !react_ReactUtil.shallowCompare(this.__state,state)) {
				this.__state = state;
				this.setState(state);
			}
		}
	}
	,componentDidMount: function() {
		this.__unsubscribe = this.context.store.subscribe($bind(this,this.__connect));
	}
	,componentWillUnmount: function() {
		if(this.__unsubscribe != null) {
			this.__unsubscribe();
			this.__unsubscribe = null;
		}
		this.__state = null;
	}
	,__class__: view_DashBoard
});
var $_, $fid = 0;
var $$tre = (typeof Symbol === "function" && Symbol.for && Symbol.for("react.element")) || 0xeac7;
view_DashBoard.user = { firstName : "dummy"};
view_DashBoard.contextTypes = { store : PropTypes.object.isRequired};
view_DashBoard.displayName = "DashBoard";
$s.view_DashBoard = view_DashBoard; 

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__("./node_modules/webpack/buildin/global.js")))

/***/ })

});