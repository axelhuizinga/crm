package view.shared;

import react.ReactComponent.ReactComponentOf;

/**
 * ...
 * @author axel@cunity.me
 */

 typedef BaseDataProps =
 {
	 > RouteTabProps,
	 dataContent:Dynamic,
	 store:Store<AppState>
 }
 
 typedef BaseDataState =
 {
	 loading:Bool,
 }
 
class Data extends ReactComponentOf<BaseDataProps,BaseDataProps>
{

	public function new(?props:TProps, ?context:Dynamic) 
	{
		super(props, context);
		
	}
	
}