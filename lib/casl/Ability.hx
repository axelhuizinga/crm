package casl;
import haxe.Json;
import haxe.extern.EitherType;
import js.Error;

/**
 * ...
 * @author axel@cunity.me
 */

typedef AbilityOptions =
{
	subjectName:Dynamic->Void
}
 
 @:jsRequire('casl', 'default')
 extern class Ability 
{
	public static function addAlias(alias:String, fields: EitherType<String, Array<String>>):Void;
	
	public function new(rules?:Array<Rule>, options?: AbilityOptions):Void;
	
	public function update(rules:Array<Rule>):Ability;

	public function can(action:String, subject:Dynamic):Bool;

	public function cannot(action:String, subject:Dynamic):Bool;

	public function rulesFor(action:String, subject:Dynamic):Array<Rule>;

	public function throwUnlessCan(action:String, subject:Dynamic):Void;
}

extern class Rule
{
	
}

extern class AbilityBuilderParts {
	var rules: Array<Rule>;
	
	public function can(action: EitherType<String, Array<String>>, subject: EitherType<String, Array<String>>, conditions?: Dynamic): Rule;

	public cannot(action: EitherType<String, Array<String>>, subject: EitherType<String, Array<String>>, conditions?: Dynamic): Rule;
}

extern class AbilityBuilder extends AbilityBuilderParts {
	@:overload(function(params: AbilityOptions, dsl: Dynamic): Ability{})
	public static function(dsl: Dynamic): Ability;

	public static function extract(): AbilityBuilderParts
}

extern class ForbiddenError extends Error{}