package view.shared;
import haxe.ds.StringMap;
import haxe.http.HttpJs;

/**
 * ...
 * @author axel@cunity.me
 */


 class AjaxLoader 
{
	
	public static function load(url:String, ?params:StringMap<String>,?cB:String->Void)
	{
		var req = new HttpJs(url); 
		for (k in params.keys())
		{
			req.addParameter(k, params.get(k));
		}		
		//req.addHeader('Access-Control-Allow-Methods', "PUT, GET, POST, DELETE, OPTIONS");
		//req.addHeader('Access-Control-Allow-Origin','*');
		if(cB != null)
			req.onData = cB;
		req.onError = function(err:String) trace(err);
		trace('POST? '.params.keys().hasNext());
		req.request(params.keys().hasNext());
	}
	
}