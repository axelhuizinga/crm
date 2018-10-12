package shared;

/**
 * ...
 * @author axel@cunity.me
 */
class Utils 
{

	public static function extend(obj1: Dynamic, obj2: Dynamic): Dynamic {
		
		var keys = Reflect.fields(obj2);
		
		for (k in keys) {
			var value: Dynamic = Reflect.field(obj2, k);
			Reflect.setField(obj1, k, value);
		}
		
		return obj1;
	}
	
	public static function each(object: Dynamic, cb: String -> Dynamic -> Void) {
		
		var keys = Reflect.fields(object);
		
		for (k in keys) {
			cb(k, Reflect.field(object, k));
		}
		
	}
	
	public static function dynaMap(object:Dynamic):Map<String,Any>
	{
		return [
			for (k in Reflect.fields(object))
				k => Reflect.field(object, k)
		];
	}
	
}