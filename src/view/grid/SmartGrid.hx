package view.grid;

import haxe.ds.StringMap;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import haxe.Constraints.Function;


/**
 * ...
 * @author axel@cunity.me
 */

typedef TDProps =
{
	?className:String,
	?headerClassName:String,
	?data:Dynamic,// ARRAY OF PLAIN CELL CONTENT VALUES
	?fieldName:String,
	?id:Dynamic,
	?style:Dynamic,
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
}

typedef SortProps =
{
	column:String,
	direction:SortDirection
}

typedef TableProps =
{
	?className:String,
	?currentPage: Int,
	data:Array<Dynamic>,
	?dataColumns:StringMap<TDProps>,// FORMAT + STYLE
	?disableHeader:Bool,
	?headerColumns:StringMap<TDProps>,// FORMAT + STYLE	
	?oddClassName: String,
    ?evenClassName:String,	
	//?filterable:Dynamic,
	//?onFilter:String->Void,
	//?onPageChange:SortProps->Void,
	//?onSort:Int->Void,
	//?pageButtonLimit:Int,
	//?sortable:EitherType<Bool, Array<EitherType<String,Dynamic>>>
	?resultsPerPage: Int,
	?sortColumn: String,
	?sortDirection: SortDirection,
	?forceRender: Bool,
	loading: Bool,
	layout: String, //'row',
	actionList: Array<Dynamic>,
	onActionClick: Function,
	onHeaderClick: Function,
	onFooterClick: Function,
	showHeader: Bool,
	showFooter: Bool,
	selectedRows: Dynamic,
	elementId: String,
	transform: Function
        	
}

class SmartGrid extends ReactComponentOf<TableProps,TableProps>
{

	public function new(props:TableProps){
		super(props);
	};
	
	public function getOrderedColumns(columnMetadata:Array<Dynamic>):Array<Dynamic>
	{
		return columnMetadata;
	}
	
	public function onChangeGrid(event:Dynamic, ?data:Dynamic) {
        if (data == null) 
			data = {};
       if (props.onChangeGrid != null)
	   {
		   props.onChangeGrid(event, data, props.elementId);
	   }
    }
	
	public function getDefaultProps() {
        return{
            className: '',
            data: null,
            resultsPerPage: 10,
            currentPage: 1,
            sortColumn: '',
            sortDirection: '',
            forceRender: false,
            loading: false,
            layout: 'row',
            actionList: [],
            onActionClick: function(){},
            onHeaderClick: null,
            onFooterClick: null,
            showHeader: true,
            showFooter: true,
            selectedRows: {},
            elementId: null,
            transform: function (response:Dynamic, ?elementId:String) {
                return response.body.data;
            }
        };
    }
	
	public function getResponseData():Array<Dynamic>
	{
        var startIndex = (props.currentPage - 1) * props.resultsPerPage;
        var endIndex = startIndex + props.resultsPerPage;
        var data = sortDataOnColumn(props.data);
        data = patternMatch(state.search,data);
        data = data.slice(startIndex, endIndex);
        return data;
    }
	
    
	public function patternMatch(text:String, data:Array<Dynamic>):Array<Dynamic>
	{
        if(!text){return data}
        var columnMetadata = props.columnMetadata;

        var filteredData:Array<Dynamic> = [];
        /*data.map( function(row:Dynamic){
            var rowMatched = false;
            var columns = Reflect.fields(row);
            for(i in columns){
                if(columns[i]==='_index')
                    continue;
                var columnValue = row[columns[i]];
                var formattedValue = columnMetadata[i].formatter?columnMetadata[i].formatter(columnValue).toString():columnValue.toString();
                if(typeof formattedValue === 'string' && formattedValue.toLowerCase().indexOf(text.trim().toLowerCase())!=-1){
                    rowMatched = true;
                    break;
                }
            }
            if(rowMatched===true)
                filteredData.push(row);
        });*/
        return filteredData;
    }
	    
	public function searchHandler(event:Dynamic) {
		trace(event);
        this.setState({
            search: event.target.value
        });
    }
	    
	public function getInitialState():Dynamic
	{
		return {};
	}
	
	public function 
	public function 
	public function sortDataOnColumn(data:Array<Dynamic>):Array<Dynamic>
	{

        if (props.sortColumn === '' || data == null || data.length == 0)
            return data;

		trace('${props.sortColumn} ${props.sortDirection}');
		var sortedList:Array<Dynamic> = data;
		trace(sortedList[0]);
		sortedList.sort(
			function (e1:Dynamic, e2:Dynamic) return Reflect.compare(
				Reflect.field(e1, props.sortColumn), Reflect.field(e2, props.sortColumn))
				);
		switch(sP.sortDirection)
		{
			case(SortDirection.DESC):
				sortedList.reverse();
			default:
		}
		trace(data[0]);
		trace(sortedList[0]);
		return sortedList;
	}
	
	override public function render():ReactFragment
	{
		var data = props.data != null ? getResponseData() : null;
        if(props.data.length<props.resultsPerPage && props.currentPage>1){
            props.onChangeGrid(null, {
                currentPage:1
            });
        }
        var resultsOnPage = data!=null && data.length <= props.resultsPerPage ? data.length : props.resultsPerPage;
        return jsx(
            <div className={'gridParent'} style={props.style}>
            {
                    props.localSearch?
                        <input type="SmartInput" placeholder="search" value={state.search} className="grid-search" onChange={searchHandler}/>
                    :null
                }
                <div className="smartGridScroll">
                    <div className={'smartGrid '+ props.layout}
                         style={{width:props.width}}>

                        <GridHeader {...props}
                            className=''
                            style={{}}
                            onChangeGrid={onChangeGrid}
                            resultsOnPage={resultsOnPage}
                            data={data}
                        />
                        <GridRows {...props}
                            className=''
                            style={{}}
                            onChangeGrid={onChangeGrid}
                            resultsOnPage={resultsOnPage}
                            data={data}
                        />
                    </div>
                </div>
                <GridFooter {...props}
                    className=''
                    style={{}}
                    currentPage={parseInt(props.currentPage)}
                    totalCount={props.data.length}
                    onChangeGrid={onChangeGrid}
                    resultsOnPage={resultsOnPage}/>
            </div>
        );		
	}

}