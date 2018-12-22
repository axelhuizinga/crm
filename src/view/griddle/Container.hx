package view.griddle;

import griddle.components.Components.GriddlePlugin;
import react.ReactComponent.ReactComponentOf;
import griddle.Griddle;

import react.ReactType;
import react.ReactMacro.jsx;
import redux.react.ReactRedux.connect;
import redux.Store;
import redux.Redux;
//import view.griddle.NewLayout;
import view.griddle.Layout.NewLayoutProps;
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
class Container extends ReactComponentOf<NewLayoutProps,Dynamic>
{
  public function new(props:NewLayoutProps, state:Dynamic)
  {
    super(props,state);
    trace(props);
  }
    
  override public function render() return null;

  public static function plugin(p:Dynamic):GriddlePlugin
  {
    trace(p);
    return {
      components:null,
      reducer:null,
      selectors:null
    };
  }
}