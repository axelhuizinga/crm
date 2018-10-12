package view.grid;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;
import view.grid.DefaultHeader;
import view.grid.SmartGrid;


/**
 * ...
 * @author axel@cunity.me
 */

class GridHeader extends ReactComponentOfProps<Dynamic>
{

	public function new(?props:Dynamic) 
	{
		super(props);
		
	}
	
	public function  handleOnClick(event:Dynamic):Void
	{
        var sortColumn:String = event.currentTarget.getAttribute('data-column');
        var sortDirection = null;
        if(sortColumn == props.sortColumn){
            if (props.sortDirection =='ASC')
                sortDirection = 'DESC';
            else
                sortDirection = 'ASC';
        }
        else{
            sortDirection = 'ASC';
        }
        props.onChangeGrid(event,{
            sortColumn: sortColumn,
            sortDirection: sortDirection
        });
    }
	
    public function render():ReactFragment;
	{
        var HeaderCells = props.columnMetadata.map(function(columnMeta:Any,columnIndex:Int){
            var displayName:String = columnMeta.displayName;
            var sortIcon:String =  null;
            if(columnMeta.columnName == props.sortColumn){
                if(props.sortDirection == 'ASC')
                    sortIcon =  "▲";
                else if(props.sortDirection == 'DESC')
                    sortIcon = "▼";
            }

            var style:Dynamic = columnMeta.flexBasis != null ? {flexBasis:columnMeta.flexBasis,flexGrow:0,flexShrink:0} : {};
            if (columnMeta.flexGrow !== null) {
              style.flexGrow = columnMeta.flexGrow;
            }

            style = 
			Object.assign(style,columnMeta.style,columnMeta.headerStyle);

            return (
              <div data-column = {columnMeta.columnName} title={columnMeta.toolTip||displayName} className={'defaultCell column-'+columnIndex+' column-'+columnMeta.columnName+' header-cell'} style={style} onClick = {handleOnClick} key={columnIndex}>
                  {displayName}<span style={{position:'relative'}}>{sortIcon}</span>
              </div>);
        });

        return (
          <div className = 'defaultRow header'>
            {HeaderCells}
          </div>);
    }
	
}