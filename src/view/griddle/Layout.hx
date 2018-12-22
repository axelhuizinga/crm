package view.griddle;

import griddle.components.Components.Table;
import griddle.components.Pagination;
import griddle.components.Components.Filter;
import griddle.components.Components.GriddlePlugin;
import griddle.components.Components.SettingsWrapper;
import react.ReactType;
import react.ReactMacro.jsx;
//import redux.react.ReactRedux.connect;
//import redux.Store;
//import redux.Redux;
import view.shared.SMenu;
import view.griddle.Container;

typedef NewLayoutProps = {
  @:optional var Table:ReactType;
  @:optional var Pagination:ReactType;
  @:optional var Filter:ReactType;
  @:optional var SettingsWrapper:ReactType;
  @:optional var data:Dynamic;
  @:optional var plugins:Array<GriddlePlugin>;
  @:optional var sortProperties:Dynamic;
  @:optional var styleConfig:Dynamic;
  @:optional var initialState:Dynamic;
}

@:jsxStatic(render)
class Layout {
  public static function render(props:NewLayoutProps) {
    var Filter = props.Filter; // Needs an uppercase variable..
    var Pagination = props.Pagination; // Needs an uppercase variable..
    var Table = props.Table; // Needs an uppercase variable..
    trace(props);
    return jsx('
    <div className="columns">
        <div className="tabComponentForm"  >
            <form className="form60">
                <div>
                    <$Table />
                    <$Pagination />
                </div>
            </form>					
        </div>
        <$Container/>
    </div>
    ');//<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks} />	
  }
}