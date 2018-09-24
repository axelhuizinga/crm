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
	public static function load(url:String, ?params:Dynamic,?cB:String->Void)
	{
		var req = new HttpJs(url); 
		if(params!=null) for (k in Reflect.fields(params))
		{
			req.addParameter(k, Reflect.field(params, k));
		}		
		//req.addHeader('Access-Control-Allow-Methods', "PUT, GET, POST, DELETE, OPTIONS");
		//req.addHeader('Access-Control-Allow-Origin','*');
		if(cB != null)
			req.onData = cB;
		req.onError = function(err:String) trace(err);
		trace('POST? ' + params!=null);
		req.request(params!=null);
	}

	public static function loadData(loaders:Array<AsyncDataLoader>):Void
	{
		for (l in loaders)
		{
			load(l.url, l.params, l.cB);
		}
	}
	

	
}