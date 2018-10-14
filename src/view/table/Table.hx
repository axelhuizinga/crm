package view.table;

import haxe.Constraints.Function;
import haxe.Timer;
import haxe.ds.StringMap;
import haxe.extern.EitherType;
import js.html.DOMRect;
import js.html.Element;
import js.html.Node;
import js.html.NodeList;
import js.html.TableCellElement;
import js.html.TableElement;
import js.html.TableRowElement;
import js.html.DivElement;
import me.cunity.debug.Out;
import react.React;
import react.ReactRef;
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
	@:value('')
	@:optional var className:String;
	@:optional var editable:Bool;
	@:optional var flexGrow:Int;
	@:value('')
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
	@:optional var cellFormat:Function;
	@:optional var className:String;
	@:optional var data:Dynamic;// CELL CONTENT VALUE
	@:optional var dataDisplay:Dynamic;// CELL CONTENT DISPLAY VALUE
	@:optional var dataType:Dynamic;// CELL CONTENT VALUE TYPE
	@:optional var name:String;
	@:optional var id:String;
	@:optional var pos:DataCellPos;
	@:value(true)
	@:optional var show:Bool;
	@:optional var style:Dynamic;
	@:optional var title:String;
	@:optional var flexGrow:Int;
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
	var tableRef:ReactRef<TableElement>;
	var fixedHeader:ReactRef<DivElement>;
	var rowRef:ReactRef<TableRowElement>;
	var tHeadRef:ReactRef<TableRowElement>;
	var headerUpdated:Bool;
	
	public function new(?props:TableProps)
	{
		super(props);		
		headerUpdated = false;
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
		
		tableRef = React.createRef();
		fixedHeader = React.createRef();
		tHeadRef = React.createRef();
		rowRef = React.createRef();
		return jsx('		
			<div className="fixed-table-container sort-decoration">
				<div className="fixed-table-container-inner">		
					<table className=${props.className} ref={tableRef}>
						<thead>
							<tr ref=${tHeadRef}>
								${renderHeaderRow()}
							</tr>
						</thead>
						<tbody>
						${renderRows()}
						</tbody>
					</table>
				</div>
				<div className="header-background" >
					<div className="thead" ref={fixedHeader}>
					${renderHeaderDisplay()}
					</div>				
				</div>
			</div>					
		');		
	}
			
	/**
	   
	${renderHeaderRow()}
	   @return
	**/

	function renderHeaderRow():ReactFragment
	{
		if(props.dataState==null)
			return null;
		//trace(props.dataState.columns.keys());
		var headerRow:Array<ReactFragment> = [];
		for (field in props.dataState.columns.keys())
		{
			var hC:DataColumn = props.dataState.columns.get(field);
			if (hC.show == false)
				continue;
			//trace(hC);
			headerRow.push(jsx('	
			<th key={field} className={(hC.headerClassName != null? hC.headerClassName :hC.className)}>
				{hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
			</th>
			'));
		}
		trace(headerRow.length);
		return headerRow;
	}	
	
	function renderHeaderDisplay():ReactFragment
	{
		if(props.dataState==null)
			return null;
		//trace(props.dataState.columns.keys());
		var headerRow:Array<ReactFragment> = [];
		for (field in props.dataState.columns.keys())
		{
			var hC:DataColumn = props.dataState.columns.get(field);
			if (hC.show == false)
				continue;
			headerRow.push(jsx('	
			<div key={field} className={"th-box " + (hC.headerClassName != null? hC.headerClassName :hC.className)}>
			{hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
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
		var column:Int = 0;
		var cells:Array<DataCell> = fieldNames.map(function(fN:String){
					var columnDataState:DataColumn = props.dataState.columns.get(fN);
					var cD:DataCell = {
						cellFormat:columnDataState.cellFormat,
						className:columnDataState.className,
						data:rdMap[fN],
						dataDisplay:columnDataState.cellFormat != null ? columnDataState.cellFormat(rdMap[fN]):rdMap[fN],
						name:fN,
						pos:{column:column++, row:row},
						show:columnDataState.show != false
					};
					return cD;					
				});
		var rCs:Array<ReactFragment> = [];
		for (cD in cells)
		{
			if (!cD.show)
			 continue;
			rCs.push(
			jsx('<td className=${cD.className} key=${"r"+cD.pos.row+"c"+cD.pos.column} data-value=${cD.cellFormat!=null?cD.data:null}>
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
			jsx('<tr key=${"r"+row} ref=${row==0?rowRef:null} >
				${renderCells(dR, row++)}				
			</tr>'));
		}//
		return dRs;
	}
	
	override function componentDidUpdate(prevProps:Dynamic, prevState:Dynamic)
	{
		trace(headerUpdated); 

		if (tHeadRef != null)
		{
			if (headerUpdated)
				return;
			headerUpdated = true;			
			var tableHeight:Float = tableRef.current.clientHeight;
			trace('tableHeight:$tableHeight');
			fixedHeader.current.parentElement.setAttribute('style', 'margin-top:-${tableHeight}px;');
			//Out.dumpObjectTree(tHeadRef.current.cells[0].getBoundingClientRect());
			//Out.dumpObject(tHeadRef.current.cells[0].getBoundingClientRect());
			//Out.dumpObjectTree(fixedHeader.current.children);
			trace(tHeadRef.current.cells[0].getBoundingClientRect().width);
			trace(fixedHeader.current.children.length);
			var i:Int = 0;
			var x:Float = 0.0;// tHeadRef.current.cells[0].getBoundingClientRect().x;tHeadRef.current.remove()
			//showDims(rowRef);
			tHeadRef.current.style.visibility = "collapse";			

			for (cell in tHeadRef.current.cells)
			{
				var w:Float = cell.getBoundingClientRect().width;
				var fixedHeaderCell = cast(fixedHeader.current.childNodes[i],Element);
				fixedHeaderCell.setAttribute('style', 'left:${x}px;width:${w}px');
				i++;
				x += w;
				//trace(fixedHeaderCell.getAttribute('style'));
			}
			//showDims(tHeadRef);
			nodeDims(fixedHeader.current);
		}
	}
	
	function showDims(ref:Dynamic)
	{
		var i:Int = 0;
		var s:Float = 0;
		var cells:Array<TableCellElement> = (ref.current != null? ref.current.cells : ref.cells);
		for (cell in cells)
		{
			trace(untyped cell.getBoundingClientRect().toJSON());
			s += cell.getBoundingClientRect().width;
		}
		trace(' sum:$s');
	}

	function nodeDims(n:Node)
	{
		var i:Int = 0;
		var s:Float = 0;
		var cells:NodeList = n.childNodes;
		for (cell in cells)
		{
			var dRect:DOMRect = untyped cast(cell, Element).getBoundingClientRect().toJSON();
			trace(dRect);
			//Out.dumpObject(cast(cell, Element).getBoundingClientRect());
			s += cast(cell, Element).getBoundingClientRect().width;
		}
		trace(' sum:$s');
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