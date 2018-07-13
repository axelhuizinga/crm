package model;

import action.AppAction;
import haxe.Http;
import haxe.Json;
import js.Promise;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DataListState =
{
	loading:Bool,
	cells:Array<DataCell>,
	?confName:String,
	?url:String
}

typedef DataCell =
{
	?id:String,
	?url:String,
	?loading:Bool,
	?html:String,
	?text:String	
}

class DataList 
	implements IReducer<AppAction, DataListState>
	implements IMiddleware<AppAction, ApplicationState>
{

	public var initState:DataListState =
	{
		loading:false,
		cells:[]
	};
	
	public var store:StoreMethods<ApplicationState>;
	
	var ID = 0;
	var loadPending:Promise<Bool>;
	
	public function new() 
	{
		
	}
	
	/* SERVICE */
	
	public function reduce(state:DataListState, action:AppAction):DataListState
	{
		return switch(action)
		{
			case Load:
				copy(state, {
					loading: true
				});
				
			case SetEntries(cells):
			{
				loading: false,
				cells: [
					for (cell in cells) {
						cell.id = '${++ID}';
						cell;
					}
				]//,
				//filter: FilterOption.All
			}	
			case SetLocale(locale):
				state;
		}
	}

	/* MIDDLEWARE */

	public function middleware(action:AppAction, next:Void -> Dynamic)
	{
		return switch(action)
		{
			case Load: loadEntries();
			default: next();
		}
	}

	function loadEntries():Promise<Bool>
	{
		// guard for multiple requests
		if (loadPending != null) return loadPending;

		return loadPending = new Promise(function(resolve, reject) {
			var http = new Http('data/data.json');
			http.onData = function(data) {
				loadPending = null;
				var entries = Json.parse(data).items;
				store.dispatch(AppAction.SetEntries(entries));
				resolve(true);
			}
			http.onError = function(error) {
				loadPending = null;
				store.dispatch(AppAction.SetEntries([]));
				resolve(true);
			}
			http.request();
		});
	}	
}