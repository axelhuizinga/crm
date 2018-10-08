package view.shared;

import haxe.Constraints.Function;
import react.Fragment;
import react.PureComponent.PureComponentOf;
import react.ReactComponent;
import react.ReactMacro.jsx;
import bulma_components.Button;

/**
 * ...
 * @author axel@cunity.me
 */

typedef SMItem =
{
	?className:String,
	?handler:Function,
	?img:String,
	?info:String,
	?label:String,
	
}
 
typedef SMenuProps =
{
	?className:String,
	?hidden:Bool,
	itemsData:Array<SMItem>,
	?right:Bool		
}

typedef SMenuState =
{
	hidden:Bool
}


class SMenu extends PureComponentOf<SMenuProps,SMenuState>

{

	public function new(props:SMenuProps) 
	{
		super(props);
		state = {
			hidden:props.hidden||false
		}
	}
	
	function renderItems():ReactFragment
	{
		if (props.itemsData.length == 0)
			return null;
		var i:Int = 1;
		return props.itemsData.map(function(iData:SMItem) return jsx('
			<li key=${i++}><Button onClick=${iData.handler}>${iData.label}</Button></li>		
		'));
	}
	
	override public function render()
	{
		return jsx('
		<div className="is-right is-hidden-mobile">
			<aside className="menu">
			  <ul className="menu-list" children=${renderItems()}/>
			</aside>
		</div>	
		');
	}
	
}