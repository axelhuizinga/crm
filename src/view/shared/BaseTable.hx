package view.shared;

import haxe.Constraints.Function;
import haxe.Json;
import haxe.ds.StringMap;
import haxe.extern.EitherType;
import js.html.Event;
import model.AppState;
import model.AjaxLoader;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import react.router.Route.RouteRenderProps;
import react_virtualized.AutoSizer;
import react_virtualized.Column;
import react_virtualized.ColumnSizer;
import react_virtualized.Table;
//import react_virtualized.Table.TableProps;
import react_virtualized.Types.SortDirection;
import redux.Redux.Dispatch;
import redux.Store;
import view.shared.RouteTabProps;
using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */


 typedef BaseCellProps =
 {
	 ?className:String,
	 ?data:Dynamic,
	 ?fieldName:String,
	 ?id:Dynamic,
	 ?style:Dynamic,
	 ?flexGrow:Int
 }
 
 typedef BaseTableProps =
 {
	//> RouteTabProps,
	> TableProps,
	autoSize:Bool,
	autoSizerProps:AutoSizerProps,
	columnSizerProps:ColumnSizerProps,
	data:Array<Dynamic>,// ROWS OF HASHES
	?dataColumns:StringMap<BaseCellProps>,// FORMAT + STYLE
	//dataLoad
	?disableHeader:Bool,
	?headerColumns:StringMap<BaseCellProps>,// FORMAT + STYLE
	?headerHeight: Int,
	?headerClassName: String,
	?oddClassName: String,
    ?evenClassName:String,
	height: Int,
	width: Int,
	?hideIndexRow: Bool,
	overscanRowCount: Int,
	rowCount: Int,
	sortBy:String,
	scrollToIndex: Int,
	sortDirection:SortDirection, 	
	?userName:String,
	?jwt:String,
	?firstName:String
}

typedef BaseTableState =
{
	clean:Bool,
	data:Array<Dynamic>,
	loading:Bool,
	scrollbarWidth:Int,
	hasError:Bool
}


class BaseTable extends ReactComponentOf<BaseTableProps,BaseTableState> 
{
	
	public function new(?props:BaseTableProps) 
	{
		this.state = 
		{
			clean:false,
			data:new Array(),
			loading:false,
			hasError:false,
			scrollbarWidth:0
		}
		//props.;
		super(props);
		trace(state.clean);
	}
	
	function createColumns():ReactFragment
	{
		if(state.data.length>0)
			trace(Reflect.fields(state.data[0]));
		trace(Reflect.fields(props.headerColumns));
		var cols:Array<ReactFragment> = [];
		for (field in props.headerColumns.keys())
		{
			var hC:BaseCellProps = props.headerColumns.get(field);
			cols.push(jsx('	
				<Column
					label=${field.substr(0, 1).toUpperCase() + field.substr(1).toLowerCase()}
					dataKey={field}
					key={field}
					width = {122}
					className = {hC.className}
					flexGrow = {hC.flexGrow}
				/>
				')
			);
		}
		return cols;
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		this.setState({ hasError: true });
		trace(error);
	}		
	
    override function render() {
		if(state.data != null)
			trace(state.data[2]);
		if (state.data.length == 0)
		{
			return jsx('
			<section className="hero is-alt">
			  <div className="hero-body">
			  <div className="loader"  style=${{width:'3rem', height:'3rem', margin:'auto', borderWidth:'0.58rem'}}/>
			  </div>
			</section>
			');					
		}
		trace(!props.autoSize);
		if (!props.autoSize)
			return renderTable({});
		return jsx('
			<AutoSizer  children=${renderTable}/>
		');
    }	
	
	function rowClassName(row:{index:Int}):String
	{
		if (row.index < 0) {
		  return props.headerClassName != null ? props.headerClassName : props.oddClassName;
		} else {
		  return row.index % 2 != 0 ? props.evenClassName : props.oddClassName;
		}	
	}
	
	//

	function renderTable(size:Size):ReactFragment
	{
		trace(size);
		return jsx('
		  <Table
			autoHeight 
			disableHeader={props.disableHeader}
			width={size != null && size.width !=null ? size.width:800}
			height = {size != null && size.height !=null ? size.height:600}
			headerClassName = {props.headerClassName}
			headerHeight={25}
			rowHeight = {25}
			rowClassName = {rowClassName}
			rowCount=${state.data.length}
			rowGetter = ${function(index) return state.data[index.index]}
			sort = {_sort}
			sortBy = {props.sortBy} 
			sortDirection = {props.sortDirection != null ? props.sortDirection : SortDirection.ASC }
		  >${createColumns()}</Table>		
		');		
	}
	
	function _sort(sP:{sortBy:String, sortDirection:SortDirection})
	{
		if (state.data.length == 0)
			return;
		//trace('$sP.sortBy $sP.sortDirection');
		trace('${sP.sortBy} ${sP.sortDirection}');
		var sortedList:Array<Dynamic> = state.data;
		trace(sortedList[0]);
		sortedList.sort(
			function (e1:Dynamic, e2:Dynamic) return Reflect.compare(
				Reflect.field(e1, props.sortBy), Reflect.field(e2, props.sortBy))
				);
		switch(sP.sortDirection)
		{
			case(SortDirection.DESC):
				sortedList.reverse();
			default:
		}
		trace(sortedList[0]);
		this.setState({data:sortedList});
		//trace(Reflect.field(e1, props.sortBy));
		//return Reflect.compare(
	}
	
	public function loaded(data:Array<Dynamic>)
	{
		state.data = data;
	}
	
	static function getDerivedStateFromProps(props, state) {
		trace(state.data.length);
		if (props.data != null && state.data.length==0)
		{
			trace(state.data.length);
			return {data:props.data};
		}
		//trace(state);
		return null;
	}
}
	/*override function shouldComponentUpdate(nextProps, nextState) {
		trace(nextProps == props);
		return(!(nextProps == props));
		trace(nextState == state);
		trace(state.clean);
		if (!state.clean && props.data != null && props.data.length > 0)
		{
			setState({clean:true});
			trace('returning true after setting state.clean=true');
			return true;
		}	
		return state.clean;
	}*/	
	