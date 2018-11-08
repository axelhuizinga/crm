package model;
import haxe.ds.StringMap;
import haxe.http.HttpJs;
import haxe.Json;
import react.ReactComponent;

/**
 * ...
 * @author axel@cunity.me
 */

typedef AsyncDataLoader =
{
	url:String,
	?params:StringMap<String>,
	?cB:String->Void,
	?dataField:String,
	?component:ReactComponent
}

 class AjaxLoader 
{	
	public static function load(url:String, ?params:Dynamic,?cB:Dynamic->Void):HttpJs
	{
		var req = new HttpJs(url); 
		if(params!=null) for (k in Reflect.fields(params))
		{
			req.addParameter(k, Reflect.field(params, k));
		}		
		req.addHeader('Access-Control-Allow-Methods', "PUT, GET, POST, DELETE, OPTIONS");
		req.addHeader('Access-Control-Allow-Origin', '*');
		var loader:AjaxLoader = new AjaxLoader(cB);
		req.onData = loader._onData;
		req.onError = function(err:String) trace(err);
		trace('POST? ' + params != null);
		req.withCredentials = true;
		req.request(params != null);
		return req;
	} 
	
	var cB:Dynamic->Void;
	public function new(?cb:String->Void)
	{
		cB = cb;
	}
	
	function _onData(response:String)
	{
		if (response.length > 0)
		{
			var dataObj = Json.parse(response);
			if (dataObj.error != '')
			{
				trace(dataObj.error);
				trace(App.store.getState().appWare.history);
				//return;
				dataObj.data = {error: dataObj.error, rows:[]};
			}
			if (cB != null)
				cB(dataObj.data);					
		}
	}

	/*public static function loadData(loaders:Array<AsyncDataLoader>):Array<HttpJs>
	{
		var rqs:Array<HttpJs> = [];
		for (l in loaders)
		{
			rqs.push(load(l.url, l.params, l.cB));
		}
		return rqs;
	}*/
	

	
}