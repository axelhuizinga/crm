package view.shared;

import haxe.Constraints.Function;
import haxe.Timer;
import js.html.InputElement;
import react.Fragment;
import react.PureComponent.PureComponentOf;
import react.ReactComponent;
import react.React;
import react.ReactMacro.jsx;
import bulma_components.Button;
import react.ReactRef;

/**
 * ...
 * @author axel@cunity.me
 */

typedef SMenuBlock =
{
	?codeClass:String,
	?className:String,
	?onActivate:Function,
	?img:String,
	?info:String,
	?isActive:Bool,
	items:Array<SMItem>,
	?label:String,	
	?segment:String,
}

typedef SMItem =
{
	?codeClass:String,
	?className:String,
	?component:ReactComponent,
	?handler:Function,
	?segment:String,
	?img:String,
	?info:String,
	?label:String,	
}
 
typedef SMenuProps =
{
	?className:String,
	?basePath:String,
	?hidden:Bool,
	?menuBlocks:Array<SMenuBlock>,
	?items:Array<SMItem>,
	?right:Bool		
}

typedef SMenuState =
{
	hidden:Bool
}


class SMenu extends PureComponentOf<SMenuProps,SMenuState>

{
	var initialActiveHeaderRef:ReactRef<InputElement>;
	public function new(props:SMenuProps) 
	{
		super(props);
		state = {
			hidden:props.hidden||false
		}
	}
	
	function activate()
	{
		trace(initialActiveHeaderRef.current);
		if (initialActiveHeaderRef.current != null)
		{
			initialActiveHeaderRef.current.checked = true;
		}
	}

	function renderHeader():ReactFragment
	{
		initialActiveHeaderRef = React.createRef();
		if (props.menuBlocks.length == 0)
			return null;
		var i:Int = 1;		
		return props.menuBlocks.map(function(block:SMenuBlock) return jsx('
		<input type="radio" key=${i} id=${"sMenuPanel-"+(i++)} name="accordion-select" data-classpath=${block.codeClass} onChange=${block.onActivate} value=${block.segment} ref=${block.isActive?initialActiveHeaderRef:null}/>
		'));
	}

	function renderPanels():ReactFragment
	{
		if (props.menuBlocks.length == 0)
			return null;
		var i:Int = 1;
		return props.menuBlocks.map(function(block:SMenuBlock) return jsx('	
			<div className="panel" key=${i}>
			  <label className="panel-heading" htmlFor=${"sMenuPanel-"+i}>${block.label}</label>
			  <div className=${"panel-block body-"+(i++)} children=${renderItems(block.items)}/>
			</div>		
		'));
	}		
	
	// <button className="toggle" aria-label="toggle"></button>
	
	function renderItems(items:Array<SMItem>):ReactFragment
	{
		//trace(items);
		if (items.length == 0)
			return null;
		var i:Int = 1;
		return items.map(function(item:SMItem) return jsx('
			<Button key=${i++} onClick=${item.handler}>${item.label}</Button>	
		'));
	}
	
	override public function render()
	{
		return jsx('
		<div className="is-right is-hidden-mobile">
			<aside className="menu">
				${renderHeader()}
				${renderPanels()}
			</aside>
		</div>	
		');
	}
	
	override public function componentDidMount():Void 
	{
		//Timer.delay(function(){
			/*if (App.bulmaAccordion != null)
			{
				trace(App.bulmaAccordion);
				var accordions = App.bulmaAccordion.attach();
				trace(accordions);
			}		*/
		//}, 1000);
		activate();
	}
	
	override public function componentDidUpdate(prevProps:SMenuProps, prevState:SMenuState):Void 
	{
		//super.componentDidUpdate(prevProps, prevState);
	}
}