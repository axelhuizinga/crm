package view.shared;

import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.*;
import gigatables_react.Reactables;
import gigatables_react.Header;
import shared.Utils;

/**
 * 
 * @author axel@cunity.me
 */

 typedef DataProps =
 {
	>RouteTabProps,
	>ReactableProps,
	autoSize:Bool,
	data:Array<Dynamic>,
	?headerHeight: Int,
	?headerClassName: String,
	height: Int,
	width: Int,
	rowCount: Int,
	settings:ReactableSettings,
	sortBy:String,
	scrollToIndex: Int,
	?defaultSort:Dynamic, 	
	?userName:String,
	?jwt:String,
	?firstName:String
}

typedef DataState =
{
	clean:Bool,
	//tableConfig:Dynamic,
	loading:Bool,
	//scrollbarWidth:Int,
	hasError:Bool
}

class DataBox extends ReactComponentOf<DataProps,DataState> 
{
	
	public function new(props:DataProps) 
	{
		this.state = 
		{
			clean:true,
			loading:false,
			hasError:false
		};

		super(props);
		trace(state.clean);
	}	
	
	function onRowClick(event:Dynamic, data:Dynamic) {
			trace(event);
			trace(data);
	}
	
	function onChangeGrid(event:Dynamic, data:Dynamic) {
        //var tableConfig = this.state.tableConfig;
		trace(data);
        /*Utils.extend(tableConfig, data);
        this.setState({
            tableConfig: tableConfig
        });*/
    }
	
	override function componentDidCatch(error, info) {
		// Display fallback UI
		this.setState({ hasError: true });
		trace(error);
	}		
	
	function renderHeader():ReactFragment
	{
		if (props.settings.data == null || props.settings.data.length == 0)
			return null;
		var hI:Int = 1;
		return props.settings.columns.map(function(column:Dynamic){
			return jsx('<Header key=${hI++} data=${column.data}>${column.label}</Header>');
		});
	}
	
    override function render():ReactFragment
 	{
		if(props.settings.data != null)
			trace(props.settings.data[2]);
		if (props.settings.data == null || props.settings.data.length == 0)
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
			<Reactables settings={props.settings}>
				${renderHeader()}
			</Reactables>
		');

	}
	
}