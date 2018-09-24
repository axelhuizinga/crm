package view.shared;

import react.ReactMacro;
import react_virtualized.Grid;

/**
 * 
 * @author axel@cunity.me
 */
class GridBox extends Grid 
{
	var data:Array<Array<Dynamic>>;
	
	public function new(?props:GridProps) 
	{
		super(props);	
		data = new Array();
		setState( {
			instanceProps:state.instanceProps,
			isScrolling:false,
			scrollDirectionHorizontal:1,
			scrollDirectionVertical:1,
			scrollLeft:0,
			scrollTop:0,
			scrollPositionChangeReason:null,
			needToResetStyleCache:false
		});			
	}
	
	override public function render()
	{
		if (data.length == 0)
			return null;
		return ReactMacro.jsx('
		<Grid
			cellRenderer={cellRenderer}
			columnCount={data[0].length}
			columnWidth={100}
			height={null}
			rowCount={list.length}
			rowHeight={30}
			width={300}
		  />
		');
	}
	
}