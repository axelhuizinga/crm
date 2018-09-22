package react_virtualized;
import react_virtualized.Types.CellRenderer;
import react_virtualized.Types.CellRangeRenderer;
import react_virtualized.Types.CellSize;
import react_virtualized.Types.NoContentRenderer;
import react_virtualized.Types.OverscanIndicesGetter;
import haxe.Constraints.Function;
import haxe.extern.EitherType;
import react.ReactComponent.ReactComponentOf;

/**
 * ...
 * @author axel@cunity.me
 */

typedef GridProps = {
	aria - label:String,
	?autoContainerWidth:Bool,
	?autoHeight:Bool,
	?autoWidth:Bool,
	?cellRangeRenderer:CellRangeRenderer,
	?cellRenderer:CellRenderer,
	?className:String,
	?columnCount:Int,
	?columnWidth:EitherType<Int,Function>,
	?containerProps:Dynamic,
	?containerRole:String,
	
}

typedef GridState = {
      columnCount: Int,
      height: Int,
      overscanColumnCount: Int,
      overscanRowCount: Int,
      rowHeight: Int,
      rowCount: Int,
      scrollToColumn: Int,
      scrollToRow: Int,
      useDynamicRowHeight: Bool
}

@:jsRequire('react-virtualized', 'Grid')
@:autoBuild(react.ReactMacro.buildComponent())
@:autoBuild(react.ReactTypeMacro.alterComponentSignatures())
#if (debug && react_render_warning)
@:autoBuild(react.ReactDebugMacro.buildComponent())
#end
extern class Grid implements Dynamic extends ReactComponentOf<Dynamic,GridState>
{
	public function new()
	{
		this.state = {
			  columnCount: 1000,
			  height: 300,
			  overscanColumnCount: 0,
			  overscanRowCount: 10,
			  rowHeight: 30,
			  rowCount: 500,
			  scrollToColumn: undefined,
			  scrollToRow: undefined,
			  useDynamicRowHeight: false,
		};		
	}
}
