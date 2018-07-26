import haxe.Log;
import js.Browser;
import js.html.DivElement;
import react.ReactDOM;
import react.ReactMacro.jsx;

class Go
{

	public static function main()
	{
		//Log.trace = Out._trace;
		render(createRoot());
	}

	static function createRoot():DivElement
	{
		var root:DivElement = Browser.document.createDivElement();
		root.className = 'rootBox';
		Browser.document.body.appendChild(root);
		return root;
	}

	static function render(root:DivElement)
	{

		var app = ReactDOM.render(jsx('
					<App />
		'), root);
		
		//trace(app);
		
		#if (debug && react_hot)
		ReactHMR.autoRefresh(app);
		#end
	}
}
