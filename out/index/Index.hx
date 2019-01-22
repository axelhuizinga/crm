package D:\d\shared\dev\crm-connect\out.index.Index.hx;
typedef Hash = { };
extern class Form<T:(Hash), K:(T)> extends React.Component<FormProps<T, K>, Dynamic> {

}
extern class Field<T> extends React.Component<FieldProps<T>> {

}
extern class List<T> extends React.Component<ListProps<T>, Dynamic> {

}
extern class Set<T> extends React.Component<SetProps<T>> {

}
extern class Map<T:({ }), K:(T)> extends React.Component<MapProps<T, K>, Dynamic> {

}
extern class State<T:({ })> extends React.Component<StateProps<T>> {

}
extern class Value<T> extends React.Component<ValueProps<T>> {

}
typedef Events = { };
extern class IndexTopLevel {
	static var Active : React.ComponentType<haxe.extern.EitherType<{ @:optional
	var onChange : ActiveChange; var render : ActiveRender; }, { @:optional
	var onChange : ActiveChange; var children : ActiveRender; }>>;
	static var Compose : React.ComponentType;
	static var Counter : React.ComponentType<haxe.extern.EitherType<{ @:optional
	var initial : Float; @:optional
	var onChange : CounterChange; var render : CounterRender; }, { @:optional
	var initial : Float; @:optional
	var onChange : CounterChange; var children : CounterRender; }>>;
	static var Focus : React.ComponentType<haxe.extern.EitherType<{ @:optional
	var onChange : FocusChange; var render : FocusRender; }, { @:optional
	var onChange : FocusChange; var children : FocusRender; }>>;
	static var FocusManager : React.ComponentType<haxe.extern.EitherType<{ @:optional
	var onChange : FocusManagerChange; var render : FocusManagerRender; }, { @:optional
	var onChange : FocusManagerChange; var children : FocusManagerRender; }>>;
	static var Hover : React.ComponentType<haxe.extern.EitherType<{ @:optional
	var onChange : HoverChange; var render : HoverRender; }, { @:optional
	var onChange : HoverChange; var children : HoverRender; }>>;
	static var Toggle : React.ComponentType<haxe.extern.EitherType<{ @:optional
	var initial : Bool; @:optional
	var onChange : ToggleChange; var render : ToggleRender; }, { @:optional
	var initial : Bool; @:optional
	var onChange : ToggleChange; var children : ToggleRender; }>>;
	static var Touch : React.ComponentType<haxe.extern.EitherType<{ @:optional
	var onChange : TouchChange; var render : TouchRender; }, { @:optional
	var onChange : TouchChange; var children : TouchRender; }>>;
	static function composeEvents(arguments:haxe.extern.Rest<Events>):Events;
}
