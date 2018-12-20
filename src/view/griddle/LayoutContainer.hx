package view.griddle;

import react.ReactComponent.ReactComponentOf;
import griddle.Griddle;
import griddle.components.Components.Table;
import griddle.components.Pagination;
import griddle.components.Components.Filter;
import griddle.components.Components.SettingsWrapper;
import react.ReactType;
import react.ReactMacro.jsx;
import redux.react.ReactRedux.connect;
import redux.Store;
import redux.Redux;
//import view.griddle.NewLayout;
import view.griddle.Layout;
import view.shared.SMenu;

/*typedef NewLayoutProps = {
  @:optional var Table:ReactType;
  //var Pagination:ReactType;
  @:optional varPagination:ReactType;
  @:optional varFilter:Filter;
  @:optional varSettingsWrapper:SettingsWrapper;
  @:optional varstate:view.shared.BaseForm.FormState;
};*/

@:connect
class LayoutContainer extends ReactComponentOf<NewLayoutProps, Dynamic> {
  
  override public function render() {
    var Filter = props.Filter; // Needs an uppercase variable..
    var Pagination = props.Pagination; // Needs an uppercase variable..
    var Table = props.Table; // Needs an uppercase variable..
    trace(props);
    trace(state);
    return jsx('
    <$Griddle components=${{"Layout":Layout.render}} data=${props.data} sortProperties=${props.sortProperties} styleConfig=${props.styleConfig} plugins=${props.plugins}/>
    ');
  }

  public function new(props:NewLayoutProps, state:Dynamic)
  {
    super(props,state);
    trace(props);
    //trace(state);
  }
}