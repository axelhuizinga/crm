package view.griddle;

import griddle.components.Components.Table;
import griddle.components.Pagination;
import griddle.components.Components.Filter;
import griddle.components.Components.SettingsWrapper;
import react.ReactType;
import react.ReactMacro.jsx;
import redux.react.ReactRedux.connect;
import redux.Store;
import redux.Redux;
import view.shared.SMenu;

/*typedef NewLayoutProps = {
  @:optional var Table:ReactType;
  //var Pagination:ReactType;
  @:optional var Pagination:ReactType;
  @:optional var Filter:Filter;
  @:optional var SettingsWrapper:SettingsWrapper;
  @:optional var state:view.shared.BaseForm.FormState;
};*/

typedef NewLayoutProps = {
  var Table:ReactType;
  //var Pagination:ReactType;
  var Pagination:ReactType;
  var Filter:ReactType;
  var SettingsWrapper:ReactType;
  //var state:view.shared.BaseForm.FormState;
};

@:jsxStatic(render)
class NewLayout {
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
        				
    </div>
    ');//<SMenu className="menu" menuBlocks={state.sideMenu.menuBlocks} />	
  }
}