package view.shared;
import haxe.http.HttpJs;

/**
 * ...
 * @author axel@cunity.me
 */

 class AjaxLoader 
{
	
	public static function load(url:String, ?cB:String->Void)
	{
		var req = new HttpJs(url); 
		req.addHeader('Access-Control-Allow-Methods', "PUT, GET, POST, DELETE, OPTIONS");
		req.addHeader('Access-Control-Allow-Origin','*');
		if(cB != null)
		req.onData = cB;
		req.onError = function(err:String) trace(err);
		req.request();
	}
	
}