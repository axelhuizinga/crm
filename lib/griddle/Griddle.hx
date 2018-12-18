package griddle;

import react.ReactComponent.ReactComponent;
import haxe.Constraints.Function;
import haxe.Json;

typedef GriddleProps =
{
    ?columns:Array<String>,
    //array - The columns that should be displayed by default. The other columns can be chosen via the grid settings. If no columns are set, Griddle will display all columns by default Default: []
    ?columnMetadata:Array<Dynamic>,
        //array - Behavior and properties for the columns within the grid Default: []
    ?results:Array<Json>,
       // array - The data that should be displayed within the grid. This data needs to be an array of JSON objects. Default: []
    ?resultsPerPage:Int,
       //int - The number of results that should be displayed on each page. If 'getExternalResults' is defined, this value will be what's used as the 'pageSize' argument. Default: 5
    ?initialSort:String,
       // string - The column that the grid should be sorted on initially. By default, this is an empty string so the data will be sorted as it's received Default: 
    ?initialSortAscending:Bool,
        //bool - The direction that the grid should be sorted on initially. By default, this is true. Default: true
    ?gridClassName:String,
       // string - The CSS class name to apply to the griddle elements. Default: 
    ?tableClassName:String,
       // string - The CSS class name to apply to the table elements. Default: 
    ?customFormatClassName:String,
        //string - The CSS class name to apply to the custom format wrapper. Default: 
    ?settingsText:String,
        //string - The text value to use for toggling the settings area. Default: Settings
    ?filterPlaceholderText:String,
        //string - The text to be displayed as a placeholder in the filter text box. Default: Filter Results
    ?nextText:String,
        //string - The text on the button that moves to the next page of results. Default: Next
    ?previousText:String,
        //?string:, - The text on the button that moves to the previous page of results. Default: Previous
    ?maxRowsText:String,
        //string - The text that appears in the Settings / Column chooser next to the select box for page size Default: Rows per page
    ?enableCustomFormatText:String,
        //string - The text that appears in the Settings / Column chooser next to the check box to enable custom formatting Default: Enable Custom Formatting
    ?childrenColumnName:String,
        //string - The name of the column that contains a list of child items for a given object. Default: children
    ?metadataColumns:Array<Dynamic>,
        //array - List of columns that should not be rendered. Default: []
    ?showFilter:Bool,
        //bool - Whether or not to display the "Filter" section of Griddle. Default: false
    ?useCustomFilterer:Bool,
        //bool - Determines if a custom filter function is used Default: false
    ?customFilterer:Function,
        //function - The function called when the filter is changed. Expects items and the query, returns filtered items Default: null
    ?useCustomFilterComponent:Bool,
        //bool - Determines if a custom filter component is used Default: false
    ?customFilterComponent:ReactComponent,
        //React Component - The component that is rendered above the table for filtering Default: null
    ?showSettings:Bool,
        //bool - Whether or not to display the "Settings" section of Griddle. Default: false
    ?useCustomRowComponent:Bool,
        //bool - Determines if a custom row format component is used Default: false
    ?useCustomGridComponent:Bool,
        //bool - Determines if a custom grid format component is used Default: false
    ?useCustomPagerComponent:Bool,
        //bool - Determines if a custom pager component is used Default: false
    ?useGriddleStyles:Bool,
        //bool - Determines if the inline, default styles for Griddle are used. When disabled Griddle will render as a simple table (unless infinite turned on) Default: true
    ?customRowComponent:ReactComponent,
        //React Component - The component that should be rendered for each data row. Default: null
    ?customGridComponent:ReactComponent,
        //React Component - The component that should be rendered instead of the overall grid. Default: null
    ?customPagerComponent:ReactComponent,
        //React Component - The component that should be rendered instead of the default pagination component Default: {}
    ?enableToggleCustom:Bool,
        //bool - Determines whether or not the option to toggle between custom component and default grid is available in the settings Default: false
    ?noDataMessage:String,
        //string - The message to display when no data is available. Default: There is no data to display.
    ?customNoDataComponent:ReactComponent,
        //React Component - The component to display when there is no data available. Default: null
    ?showTableHeading:Bool,
        //bool - Determines if the table heading should be displayed. Default: true
    ?showPager:Bool,
        //bool - Determines if the pagination controls should be displayed. Default: true
    ?useFixedHeader:Bool,
        //bool - Determines if the table header should stay in the same place while table data is scrolled. Default: false
    ?useExternal:Bool,
        //bool - States that the data should be loaded externally rather than all at once. Default: false
    ?externalSetPage:Function,
        //function - The method that will be called when the grid changes pages. Default: null
    ?externalChangeSort:Function,
        //function - The method that will be called when the column sort is changed. Default: null
    ?externalSetFilter:Function,
        //function - The method that will be called when the filter is changed. Default: null
    ?externalSetPageSize:Function,
        //function - The method that will be called when the page size is requested to change. Default: null
    ?externalMaxPage:Int,
        //int - The max page for the current data set. Default: null
    ?externalCurrentPage:Int,
        //int - The page of data that is currently being displayed. Default: null
    ?externalSortColumn:String,
        //string - The column that is currently sorted. Default: null
    ?externalSortAscending:Bool,
        //bool - Whether the data is sorted in ascending or descending order Default: null
    ?externalLoadingComponent:ReactComponent,
        //React Component - The component that should be displayed when the data is loading. Default: null
    ?externalIsLoading:Bool,
        //bool - Whether or not the loading component should be displayed instead of grid data. Default: false
    ?enableInfiniteScroll:Bool,
        //bool - Should infinite scrolling be enabled. Default: false
    ?bodyHeight:Int,
        //int - The height, in pixels, of the grid body. Default: null
    ?paddingHeight:Int,
        //int - The height, in pixels, of the the top/bottom padding used inside of a row. Only used when 'useGriddleStyles' is true. Default: 5
    ?rowHeight:Int,
        //int - The minimum height, in pixels, of a row. Only used when 'useGriddleStyles' is true. Default: 25
    ?infiniteScrollLoadTreshold:Int,
        //int - The height, in pixels, used to trigger paging. Changing this property should be a pretty rare occurrence. Default: 50
    ?useFixedLayout:Bool,
        //bool - Whether or not a fixed table layout should be used. Default: true
    ?isSubGriddle:Bool,
        //bool - Is the current grid a child of another Griddle component. (This should mainly be used for SubGrids by Griddle). Default: false
    ?enableSort:Bool,
        //bool - Determines if sorting is enabled. Default: true
    ?sortAscendingClassName:String,
        //string - When sorted in ascending order, the CSS class name to apply to the th of the currently sorted column. Default: sort-ascending
    ?sortDescendingClassName:String,
        //string - When sorted in descending order, the CSS class name to apply to the th of the currently sorted column Default: sort-descending
    ?parentRowCollapsedClassName:String,
        //string - The CSS class that is applied to a row that contains child records when the records are not being displayed. Default: parent-row
    ?parentRowExpandedClassName:String,
        //string - The CSS class that is applied to a row that contains child records when the records are currently displayed. Default: parent-row expanded
    ?settingsToggleClassName:String,
        //string - The CSS class that is applied to the settings toggle button that is (by default) at the top right of Griddle. Default: settings
    ?nextClassName:String,
        //string - The CSS class name to apply to the pagination "next" control. Default: griddle-next
    ?previousClassName:String,
        //string - The CSS class name to apply to the pagination "previous" control. Default: griddle-previous
    ?sortAscendingComponent:String,
        //string - The component to display in a th element when the column is sorted in ascending order. This component will be to the right of the column heading text. Default: ▲
    ?sortDescendingComponent:String,
        //string - The component to display in a th element when the column is sorted in descending order. This component will be to the right of the column heading text. Default: ▼
    ?parentRowCollapsedComponent:String,
        //string - The component to the left of the first column of a grid row that contains child records when those records are not currently displayed. Default: ▶
    ?parentRowExpandedComponent:String,
        //string - The component to the left of the first column of a grid row that contains child records when those records are currently displayed. Default: ▼
    ?settingsIconComponent:String,
        //string - The component to display to the right of the "Settings" text. Default: 
    ?nextIconComponent:String,
        //string - The component that should be displayed to the right of the "Next" text in the pagination component. Default: 
    ?previousIconComponent:String,
        //string - The component that should be displayed to the left of the "Previous" text in the pagination component. Default: 
    ?onRowClick:Function,
        //function - A function that should be called when a row has been clicked. The 'gridRow' and event will be passed in as arguments. Default: null
    ?onRowMouseEnter:Function,
        //function - A function that should be called when a mouse entered a row. The 'gridRow' and event will be passed in as arguments. Default: null
    ?onRowMouseLeave:Function,
        //function - A function that should be called when a mouse left a row. The 'gridRow' and event will be passed in as arguments. Default: null
    ?onRowWillMount:Function,
        //function - A function that should be called before a row was mounted. The 'gridRow' will be passed in as argument. Default: null
    ?onRowWillUnmount:Function
        //function - A function that should be called before a row was unmounted. The 'gridRow' will be passed in as argument. Default: null
}
@:jsRequire('griddle-react', 'default')
extern class Griddle extends ReactComponent{}