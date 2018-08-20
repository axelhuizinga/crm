package model;
import history.Action;
import history.Location;
import model.AppState;
import react.ReactComponent;
import redux.Store;

/**
 * ...
 * @author axel@cunity.me
 */
class CState 
{
	static var getState:Dynamic;
	
	public static function handleTransition(message:String, callback:Bool->Void)
	{
		trace(message);
		callback(true);
	}
	
	public static function blockTransition(location:Location, action:Action):String
	{
		trace(location.pathname);
		trace(action);
		return location.pathname;
	}
	
	public static function historyChange(location:Location, action:Action):Bool
	{
		trace(location);
		trace(action);
		return false;
	}
	
	public static function addComponent(comp:ReactComponent):Void
	{
		
	}
	
	public static function init(store:Store<AppState>)
	{
		getState = store.getState;
		getState().appWare.history.block(blockTransition);
	}

}