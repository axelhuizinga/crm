package view.table;

import haxe.Constraints.Function;
import haxe.ds.StringMap;
import haxe.extern.EitherType;
import react.ReactComponent.ReactFragment;
import react.ReactComponent;
import react.ReactComponent.*;
import react.ReactMacro.jsx;
import shared.Utils;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DataState =
{
	columns:StringMap<DataColumn>,
	?defaultSearch:StringMap<DataColumn>,
	?search:StringMap<DataColumn>
}

typedef DataColumn = 
{
	@:optional var cellFormat:Function;
	@:optional var className:String;
	@:optional var editable:Bool;
	@:optional var flexGrow:Int;
	@:optional var headerClassName:String;
	@:optional var headerFormat:Function;
	@:optional var headerStyle:Dynamic;
	@:optional var label:String;
	@:optional var name:String;
	@:optional var search:SortDirection;
	@:value(true)
	@:optional var show:Bool;
	@:optional var style:Dynamic;
}

typedef DataCellPos =
{
	column:Int,
	row:Int
}
typedef DataCell =
{
	?cellFormat:Function,
	?className:String,
	?data:Dynamic,// CELL CONTENT VALUE
	?dataDisplay:Dynamic,// CELL CONTENT DISPLAY VALUE
	?dataType:Dynamic,// CELL CONTENT VALUE TYPE
	?name:String,
	?id:String,
	?pos:DataCellPos,
	?style:Dynamic,
	?title:String,
	?flexGrow:Int
}

typedef Size =
{
	?height:Int,
	?width:Int
}

@:enum
abstract SortDirection(String){
	var ASC = 'ASC';
	var DESC = 'DESC';
	var NONE = '';
}

typedef SortProps =
{
	column:String,
	direction:SortDirection
}

typedef TableProps =
{
	?className:String,
	data:Array<Dynamic>,
	dataState:DataState,
	?disableHeader:Bool,
	?oddClassName: String,
    ?evenClassName:String,	
	?defaultSort:Dynamic,
	?defaultSortDescending:Bool,
	?filterable:Dynamic,
	?id:String,
	?itemsPerPage:Int,
	?onFilter:String->Void,
	?onPageChange:SortProps->Void,
	?onSort:Int->Void,
	?pageButtonLimit:Int,
	?sortable:EitherType<Bool, Array<EitherType<String,Dynamic>>>
}

class Table extends ReactComponentOf<TableProps, Dynamic>
{
	var fieldNames:Array<String>;
	
	public function new(?props:TableProps)
	{
		super(props);		
		fieldNames = [];
		for (k in props.dataState.columns.keys())
		{
			//trace(k);
			fieldNames.push(k);
		}	
		trace(fieldNames);
	}
	
	override public function render():ReactFragment
	{
		if(props.data != null)
		trace(props.data.length);
		trace(props.className);
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
		return jsx('
			<div className="fixed-table-container sort-decoration">
				<div className="header-background"> ${renderHeaderRow()}</div>
				<div className="fixed-table-container-inner">		
					<table className=${props.className}>
						<tbody>
						${renderRows()}
						</tbody>
					</table>
				</div>
			</div>					
		');		
	}
					
	function renderHeaderRow():ReactFragment
	{
		if(props.dataState==null)
			return null;
		trace(props.dataState.columns.keys());
		var headerRow:Array<ReactFragment> = [];
		for (field in props.dataState.columns.keys())
		{
			var hC:DataColumn = props.dataState.columns.get(field);
			//trace(hC);
			headerRow.push(jsx('	
			<div key={field} className={hC.headerClassName != null? hC.headerClassName :hC.className}>
				{hC.label != null? hC.label : hC.name}									
			</div>
			'));
		}
		return headerRow;
	}	
//<span>{hC.data}<span className="fa fa-sort"></span></span><span className="2fa 2fa-sort"></span>
	function renderCells(rD:Dynamic, row:Int):ReactFragment
	{
		@:arrayAccess
		var rdMap:Map<String,Any> = Utils.dynaMap(rD);
		
		var cells:Array<DataCell> = fieldNames.map(function(fN:String){
					var columnDataState:DataColumn = props.dataState.columns.get(fN);
					var cD:DataCell = {
						cellFormat:columnDataState.cellFormat,
						className:columnDataState.className,
						data:rdMap[fN],
						dataDisplay:columnDataState.cellFormat != null ? columnDataState.cellFormat(rdMap[fN]):rdMap[fN],
						name:fN
					};
					return cD;					
				});
		var rCs:Array<ReactFragment> = [];
		for (cD in cells)
		{
			rCs.push(
			jsx('<td className=${cD.className} data-value=${cD.cellFormat!=null?cD.data:null}>
				${cD.dataDisplay}
			</td>'));
		}
		return rCs;
	}
	
	function renderRows(?dRows:Array<Dynamic>):ReactFragment
	{
		if (dRows == null)
			dRows = props.data;
		var dRs:Array<ReactFragment> = [];

		var row:Int = 0;
		for (dR in dRows)
		{			
			dRs.push(
			jsx('<tr >
				${renderCells(dR, row)}
				
			</tr>'));
		}
		return dRs;
	}
	
	function renderTh():ReactFragment
	{
		trace(props);
		return jsx('
				<div className="th-inner">
					<span>Test...</span>
					<span className="fa-sort"></span>
				</div>
		');
	}
	
}

	/*function createColumns():ReactFragment
	{
		if(state.data.length>0)
			trace(Reflect.fields(state.data[0]));
		trace(Reflect.fields(props.headerColumns));
		var cols:Array<ReactFragment> = [];
		for (field in props.headerColumns.keys())
		{
			var hC:DataCell = props.headerColumns.get(field);
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
	}*/