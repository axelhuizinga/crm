package action;
import haxe.extern.EitherType;
import history.History;
import history.Location;

/**
 * @author axel@cunity.me
 */

enum LocationAction
{
	Push(url:String, ?state:Dynamic);
	Replace(url:String, ?state:Dynamic);
	Go(to:Int);
	Back;
	Forward;
	InitHistory(history:History);
	LocationChange(location:Location);
}