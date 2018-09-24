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

 
 typedef BaseTableProps =
 {
	//> RouteTabProps,
	> TableProps,
	data:Array<Dynamic>,// ROWS OF HASHES
	?disableHeader:Bool,
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

typedef BaseTableState =
{
	data:Array<Dynamic>,
	loading:Bool,
	scrollbarWidth:Int,
	hasError:Bool
}


class BaseTable extends ReactComponentOf<BaseTableProps,BaseTableState> 
{
	
	public function new(?props:BaseTableProps) 
	{
		super(props);	
		this.state = 
		{
			data:new Array(),
			loading:false,
			hasError:false,
			scrollbarWidth:0
		}
	}
	
	function createColumns():ReactFragment
	{
		return Lambda.array(Lambda.map(Reflect.fields(state.data[0]), function(field:String) return jsx('	
			<Column
			  label=${field.substr(0, 1).toUpperCase() + field.substr(1).toLowerCase()}
			  dataKey={field}
			  width = {100}
			  flexGrow = {1}
			/>		
		')));
	}

	override function componentDidCatch(error, info) {
		// Display fallback UI
		this.setState({ hasError: true });
		trace(error);
	}		
	
	override public function componentDidMount():Void 
	{		
		AjaxLoader.load(
			'${App.config.api}', 
			{
				userName:props.userName,
				jwt:props.jwt,
				firstName:props.firstName,
				className:'admin.CreateUsers',
				action:'fromViciDial'
			},
			function(data){
				trace(data); 
				if (data.length > 0)
				{
					//var sData:StringMap<Dynamic> = state.data;
					//sData.set('userGroups', Json.parse(data).data.rows);
					//setState(ReactUtil.copy(state, {data:sData}));				
					setState({data:Json.parse(data).data.rows});				
				}
			}
		);
		setState({loading:true});
	}
	
    override function render() {
		trace(state.data);
		if (state.data == null || state.data.length == 0)
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
		  <Table
			width={300}
			height={300}
			headerHeight={20}
			rowHeight={30}
			rowCount=${state.data.length}
			rowGetter = ${function(index) return state.data[index.index]}
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
	
}