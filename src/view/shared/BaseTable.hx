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
	 ?style:Dynamic
 }
 
 typedef BaseTableProps =
 {
	//> RouteTabProps,
	> TableProps,
	autoSize:Bool,
	autoSizerProps:AutoSizerProps,
	columnSizerProps:ColumnSizerProps,
	data:Array<Dynamic>,// ROWS OF HASHES
	?dataColumns:Array<BaseCellProps>,// FORMAT + STYLE
	//dataLoad
	?disableHeader:Bool,
	?headerColumns:Array<BaseCellProps>,// FORMAT + STYLE
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
		trace(Reflect.fields(props.data[0]));
		trace(Reflect.fields(props.headerColumns));
		//var fieldNames = Lambda.map(props.headerColumns, function(hC:BaseCellProps) return hC.fieldName);
		return Lambda.array(Lambda.map(Reflect.fields(props.data[0]), 
			function(field:String) return
			jsx('	
			<Column
			  label=${field.substr(0, 1).toUpperCase() + field.substr(1).toLowerCase()}
			  dataKey={field}
			  key={field}
			  width = {100}
			  flexGrow = {field=="full_name" || field=="user_group"? 1:0}
			/>		
		')));
	}
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		this.setState({ hasError: true });
		trace(error);
	}		
	
    override function render() {
		//trace(state.data);
		if(props.data != null)
			trace(props.data.length);
		if (props.data == null || props.data.length == 0)
		{
			return jsx('
			<section className="hero is-alt">
			  <div className="hero-body">
			  <div className="loader"  style=${{width:'3rem', height:'3rem', margin:'auto', borderWidth:'0.58rem'}}/>
			  </div>
			</section>
			');					
		}
		if (!props.autoSize)
			return renderTable({});
		return jsx('
			<AutoSizer disableWidth children=${renderTable}/>
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
	
	//function _renderColumns(
//
	function renderTable(size:Size):ReactFragment
	{
		trace(size);
		return jsx('
		  <Table
			disableHeader={props.disableHeader}
			width={size != null && size.width !=null ? size.width:800}
			height = {size.height}
			headerClassName = {props.headerClassName}
			headerHeight={25}
			rowHeight = {25}
			rowClassName = {rowClassName}
			rowCount=${props.data.length}
			rowGetter = ${function(index) return props.data[index.index]}
		  >${createColumns()}</Table>		
		');		
	}
	
	public function loaded(data:Array<Dynamic>)
	{
		state.data = data;
	}
	
	function renderDataTable(content:Array<Dynamic>):ReactFragment
	{
		//trace(content);
		if (content == null || content.length == 0)
			return null;
		var rC:Array<ReactFragment> = new Array();
		var k:Int = 1;
		for (c in content)
		{
			rC.push(jsx('<div key=${k++}>${c.user_group}</div>'));
		}
		return rC;
	}
	
	static function getDerivedStateFromProps(props, state) {
		//trace(props);
		trace(state);
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
	