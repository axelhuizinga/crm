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
import react_virtualized.Column;
import react_virtualized.Table;
import react_virtualized.Table.TableProps;
import react_virtualized.Types.SortDirection;
import redux.Redux.Dispatch;
import redux.Store;
import view.shared.RouteTabProps;


/**
 * ...
 * @author axel@cunity.me
 */

 
 typedef MultiTableProps =
 {
	//> RouteTabProps,
	> TableProps,
	data:Array<Dynamic>,// ROWS OF HASHES
	?dataColumns:Array<Dynamic>,// FORMAT + STYLE
	//dataLoad
	?disableHeader:Bool,
	?headerColumns:Array<Dynamic>,// FORMAT + STYLE
	?headerHeight: Int,
	height: Int,
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

typedef MultiTableState =
{
	clean:Bool,
	data:Array<Dynamic>,
	loading:Bool,
	scrollbarWidth:Int,
	hasError:Bool
}


class MultiTable extends ReactComponentOf<MultiTableProps,MultiTableState> 
{
	
	public function new(?props:MultiTableProps) 
	{
		this.state = 
		{
			clean:false,
			data:new Array(),
			loading:false,
			hasError:false,
			scrollbarWidth:0
		}
		super(props);
		trace(state.clean);
	}
	
	function createColumns():ReactFragment
	{
		trace(Reflect.fields(props.data[0]));
		return Lambda.array(Lambda.map(Reflect.fields(props.data[0]), function(field:String) return jsx('	
			<Column
			  label=${field.substr(0, 1).toUpperCase() + field.substr(1).toLowerCase()}
			  dataKey={field}
			  width = {100}
			  flexGrow = {0}
			/>		
		')));
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
		return jsx('
		  < Table
			autoHeight={true} 
			width={300}
			height = {300}
			headerHeight={20}
			rowHeight={30}
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