package model;
import action.HistoryAction;
import haxe.Http;
import haxe.Json;
import js.Browser;
import js.Promise;
import react.ReactUtil.copy;
import redux.IMiddleware;
import redux.IReducer;
import redux.StoreMethods;
/**
 * ...
 * @author axel@cunity.me
 */

 typedef HistoryState = {
	 var entries:Array<Dynamic>;
	 var pos:Int;
 }
 
class HistoryWare 
	implements IReducer<HistoryAction, HistoryState>
	implements IMiddleware<HistoryAction, ApplicationState>
{
	public var initState: HistoryState =
	{
		entries:[Browser.window.history.state],
		pos:0
	};
	public var store:StoreMethods<ApplicationState>;
	
	public function new() 
	{
		
	}
	
	public function reduce(state:HistoryState, action:HistoryAction):HistoryState
	{
		return switch(action)
		{
			case Pop:
				copy(state, state);
			case Push:
				copy(state, {
					entries: state.entries.concat([]),
					pos: state.entries.length
				});
			case Replace:
				copy(state, state);
			case Go:
				copy(state, state);
			case Back:
				copy(state, state);
			case Forward:
				copy(state, state);
		}
	}
	
	public function middleware(action:HistoryAction, next:Void -> Dynamic)
	{
		return switch(action)
		{
			default: next();
		}
	}
	
}