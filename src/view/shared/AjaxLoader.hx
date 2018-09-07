package view.shared;

/**
 * ...
 * @author axel@cunity.me
 */

 class AjaxLoader 
{

	public function new(url:String, cB:Void->Void, async:Bool = true) 
	{
		js.Browser.window.fetch(url).then(cB);
	}
	
}