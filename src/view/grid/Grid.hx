package view.grid;

import haxe.Constraints.Function;
import haxe.Timer;
import haxe.ds.StringMap;
import haxe.extern.EitherType;
import js.html.DOMRect;
import js.html.DOMRectList;
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

class Grid extends ReactComponentOf<TableProps, Dynamic>
{
	var fieldNames:Array<String>;
	var gridRef:ReactRef<DivElement>;
	var fixedHeader:ReactRef<DivElement>;
	var rowRef:ReactRef<TableRowElement>;
	var gridHead:ReactRef<TableRowElement>;
	var gridStyle:String;
	var visibleColumns:Int;
	var headerUpdated:Bool;
	
	public function new(?props:TableProps)
	{
		super(props);		
		headerUpdated = false;
		visibleColumns = 0;
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
		//className="${props.className} sort-decoration"
		gridRef = React.createRef();
		fixedHeader = React.createRef();
		gridHead = React.createRef();
		rowRef = React.createRef();
		return jsx('		
			<div className="fixed-grid-container" >
				<div className="header-background" >
					<div className="grid head" ref={fixedHeader}>
					${renderHeaderDisplay()}
					</div>				
				</div>				
				<div className="${props.className} grid-container-inner">							
					<div className="grid body" ref={gridRef}>
						${renderHeaderRow()}
						${renderRows()}
					</div>
				</div>
				<div className="pager">
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
		var col:Int = 0;
		gridStyle = '';
		for (field in props.dataState.columns.keys())
		{
			var hC:DataColumn = props.dataState.columns.get(field);
			if (hC.show == false)
				continue;
			//' auto';//
			gridStyle +=  (hC.flexGrow == 1?' 1fr':' auto');
			if (col == 0)
				trace('${hC.headerClassName} :${hC.className}');
			headerRow.push(jsx('	
			<div key={field} 
				className= ${"gridHeadItem "+(hC.headerClassName != null? hC.headerClassName :
					(hC.className!=null?hC.className:''))}
				ref=${col==0?gridHead:null}>
				{hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
			</div>
			'));
			col++;
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
			visibleColumns++;
			headerRow.push(jsx('	
			<div key={field} className={"gridHeadItem " + (hC.headerClassName != null? hC.headerClassName :hC.className)}>
			{hC.label != null? hC.label : hC.name}<span className="sort-box fa fa-sort"></span>
			</div>
			'));
		}
		return headerRow;
	}	

	function renderCells(rD:Dynamic, row:Int):ReactFragment
	{
		@:arrayAccess
		var rdMap:Map<String,Any> = Utils.dynaMap(rD);
		var column:Int = 0;
		var rowClass = (row % 2 == 0?'even':'odd');
		var cells:Array<DataCell> = fieldNames.map(function(fN:String){
			var columnDataState:DataColumn = props.dataState.columns.get(fN);
			var cD:DataCell = {
				cellFormat:columnDataState.cellFormat,
				className:'${columnDataState.className} ${rowClass}',
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
			jsx('<div className=${cD.className} key=${"r"+cD.pos.row+"c"+cD.pos.column} data-value=${cD.cellFormat!=null?cD.data:null}>
				${cD.dataDisplay}
			</div>'));
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
			jsx('
				${renderCells(dR, row++)}				
			'));
		}//
		return dRs;
	}
	
	override function componentDidUpdate(prevProps:Dynamic, prevState:Dynamic)
	{
		trace(headerUpdated); 

		if (gridHead != null)
		{
			if (headerUpdated)
				return;
			headerUpdated = true;		
			//gridRef.current.style.se.style.setProperty('grid-template-columns', gridStyle);
			var gridHeight:Float = gridRef.current.clientHeight;
			var scrollBarWidth = gridRef.current.parentElement.offsetWidth - gridRef.current.offsetWidth;
			trace('$scrollBarWidth ${gridRef.current.parentElement.offsetWidth} ${gridRef.current.offsetWidth}');
			fixedHeader.current.style.setProperty('padding-right', '${scrollBarWidth}px');
			trace('gridHeight:$gridHeight');
			//fixedHeader.current.parentElement.setAttribute('style', 'margin-top:-${gridHeight}px;');
			//Out.dumpObjectTree(gridHead.current.cells[0].getBoundingClientRect());
			//Out.dumpObject(gridHead.current.cells[0].getBoundingClientRect());
			//Out.dumpObjectTree(fixedHeader.current.children);grid-template-columns
			trace(gridRef.current + 'visibleColumns:$visibleColumns');
			// .childNodes[0], Element).getBoundingClientRect().width);
			//trace(fixedHeader.current.children.length);
			var i:Int = 0;
			var x:Float = 0.0;// gridHead.current.cells[0].getBoundingClientRect().x;gridHead.current.remove()
			//showDims(rowRef);
			fixedHeader.current.style.setProperty('grid-template-columns', gridStyle);
			var grid:Element = gridRef.current;
			grid.style.setProperty('grid-template-columns', gridStyle);
			grid.style.setProperty('grid-template-rows', '0px auto');
			//var gH:Element = cast(gridHead.current, Element);
			var gH:Element = gridHead.current;
			gridHead.current.style.visibility = "collapse";	
			trace(gH.offsetWidth + ':' + gH.clientWidth);
			var cRects:DOMRectList = gH.getClientRects();
			for (cR in cRects)
			{
				Out.dumpObject(cR);
			}
			//trace();
			Out.dumpObject(gH.getBoundingClientRect());
			var rowRects:Array<DOMRect> = [gH.getBoundingClientRect()];
			gH.style.setProperty('visibility', "collapse");			
			for (i in 1...visibleColumns) 
			{
				trace(i);
				gH = gH.nextElementSibling;
				rowRects.push(gH.getBoundingClientRect());
				gH.style.setProperty('visibility', 'collapse');
				trace(gH);
				//cast(gridHead.current.nextSibling,Element).style.visibility = "collapse";
			}
			trace(fixedHeader);
			trace(gridHead);
			return;
			for (fixedHeaderCell in fixedHeader.current.children)
			{
				trace(fixedHeaderCell);
				var r:DOMRect = rowRects.shift();
				//var w:Float = cell. .getBoundingClientRect().width;left:${x}px;
				//var fixedHeaderCell = cast(fixedHeader.current.childNodes[i],Element);
				fixedHeaderCell.setAttribute('style', 'left:${r.left}px;width:${r.width}px;');
				i++;
				//x += w;
				//trace(fixedHeaderCell.getAttribute('style'));
			}
			//showDims(gridHead);
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