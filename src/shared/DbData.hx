package shared;

import hxbit.Schema;
import hxbit.Serializable;
import hxbit.Serializer;

/**
 * ...
 * @author axel@cunity.me
 */
class DbData implements Serializable 
{

	@:s public var dataErrors:Map<String,Dynamic>;
	@:s public var dataInfo:Map<String,Dynamic>;
	@:s public var dataParams:Map<String,Map<String,String>>;
	@:s public var dataRows:Array<Map<String,String>>;
	
	public function new() 
	{
		dataErrors = new Map();
		dataInfo = new Map();
		dataRows = new Array();		
	}
	
}