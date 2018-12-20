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

typedef NewLayoutProps = {
  var Table:ReactType;
  var Pagination:ReactType;
  var Filter:ReactType;
  var SettingsWrapper:ReactType;
  @:optional var data:Dynamic;
  @:optional var plugins:Array<GriddlePlugin>;
  @:optional var sortProperties:Dynamic;
  @:optional var styleConfig:Dynamic;
}

@:jsxStatic(render)
class Layout {
  public static function render(props:NewLayoutProps) {
    var Filter = props.Filter; // Needs an uppercase variable..
    var Pagination = props.Pagination; // Needs an uppercase variable..
    var Table = props.Table; // Needs an uppercase variable..
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
        				
    </div>
    ');//<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks} />	
  }
}