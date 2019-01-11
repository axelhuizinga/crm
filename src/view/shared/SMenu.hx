package view.shared;

import js.Browser;
import js.html.DivElement;
import griddle.components.Components.Filter;
import haxe.ds.StringMap;
import haxe.Constraints.Function;
import haxe.Timer;
import js.html.InputElement;

import react.PureComponent.PureComponentOf;
import react.ReactComponent;
import react.ReactComponent.ReactComponentOf;
import react.ReactComponent.ReactFragment;
import react.React;
import react.ReactType;
import react.ReactMacro.jsx;
import bulma_components.Button;
import react.ReactRef;

using Lambda;

/**
 * ...
 * @author axel@cunity.me
 */

typedef SMenuBlock =
{
	?dataClassPath:String,
	?disabled:Bool,
	?viewClassPath:String,
	?className:String,
	?onActivate:Function,
	?img:String,
	?info:String,
	?isActive:Bool,
	?items:Array<SMItem>,
	?label:String,	
	?section:String,
}

typedef SMItem =
{
	?action:String,
	?className:String,
	?component:Dynamic,
	?dataClassPath:String,
	?disabled:Bool,	
	?handler:Function,
	?img:String,
	?info:String,
	?label:String,	
}
 
typedef SMenuProps =
{
	?className:String,
	?basePath:String,
	?hidden:Bool,
	?menuBlocks:Map<String,SMenuBlock>,
	?section:String,
	?items:Array<SMItem>,
	?right:Bool,
	?sameWidth:Bool
}

typedef SMenuState =
{
	?hidden:Bool,
	?disabled:Bool,
	?sameWidth:Int,
	?interactionStates:Map<String,InteractionState>
}

typedef  InteractionState =
{
	var disables:Array<String>;
	var enables:Array<String>;
}

class SMenu extends ReactComponentOf<SMenuProps,SMenuState>

{
	var menuRef:ReactRef<DivElement>;
	var aW:Int;
	public function new(props:SMenuProps) 
	{
		super(props);
		state = {
			hidden:props.hidden||false
		}
	}

	function renderHeader():ReactFragment
	{
		if (props.menuBlocks.empty())
			return null;
		var header:Array<ReactFragment> = new Array();
		var i:Int = 1;		

		props.menuBlocks.iter(function(block:SMenuBlock) {
			var check:Bool = props.section==block.section;
			if(props.section==null && i==1)
			{
				check=true;
			}
			trace(block.label + '::' + block.onActivate + ':' +check);
			//trace(props.section + '::' + block.section + ':' +check);
			header.push( jsx('
		<input type="radio" key=${i} id=${"sMenuPanel-"+(i++)} name="accordion-select" checked=${check} data-classpath=${block.viewClassPath} 
			onChange=${block.onActivate} data-section=${block.section} />
		'));
		});
		return header;
	}

	function renderPanels():ReactFragment
	{
		if (props.menuBlocks.empty())
			return null;
		var style:Dynamic = null;
		//var className = ''; 'panel-block';
		if(props.sameWidth && state.sameWidth>0) {
			style = {width:'${state.sameWidth}px'};
			//className = 'panel-block';
		}
		var i:Int = 1;
		//style = null;
		var panels:Array<ReactFragment> = [];
		props.menuBlocks.iter(function(block:SMenuBlock) panels.push( jsx('	
			<div className="panel" key=${i} style=${style}>
			  <label className="panel-heading" htmlFor=${"sMenuPanel-"+i}>${block.label}</label>
			  <div id=${"pblock" + i} className=${"panel-block body-"+(i++)} children=${renderItems(block.items)}/>
			</div>		
		')));
		trace(panels.length);
		return panels;
	}		
	
	function renderItems(items:Array<SMItem>):ReactFragment
	{
		if (items == null || items.length == 0)
			return null;
		var i:Int = 1;
		return items.map(function(item:SMItem) 
		{
			return switch(item.component)
			{
				case Filter: jsx('<$Filter  key=${i++}/>');
				default:jsx('<Button key=${i++} onClick=${item.handler} disabled=${item.disabled}>${item.label}</Button>');
			}
		}).array();
	}
	
	override public function render()
	{
		menuRef = React.createRef();
		var style:Dynamic = null;
		if(false&&props.sameWidth && state.sameWidth == null)//sameWidth
		{
			style = {
				visibility: 'hidden'
			};
		}
		return jsx('
		<div className="sidebar is-right">
			<aside style=${style} className="menu" ref=${menuRef}>
				${renderHeader()}
				${renderPanels()}
			</aside>
		</div>	
		');
	}

	function layout()
	{
		var i:Int = 0;
		var activePanel:Int = null;
		/*while (menuRef.current.childNodes.item(i).localName=='input')
		{
			var inp:InputElement = cast(menuRef.current.childNodes.item(i), InputElement);
			trace(inp.checked);
			if(inp.checked)
			{
				activePanel=i;
				i=0;
				break;
			}
			i++;
		}
		trace(activePanel);
		trace(Browser.document.getElementById('pblock${activePanel}').children.item(0).innerHTML);
		aW = Browser.document.getElementById('pblock${activePanel}').children.item(0).clientWidth;
		//aW = menuRef.current.childNodes.item(activePanel)
		trace(aW);
		while (menuRef.current.childNodes.item(i).localName=='input')
		{
			if(i==activePanel)
			{
				i++;
				continue;
			}
			var iW = null;//Browser.document.getElementById('pblock${i}').children.item(0).offsetWidth;
			var inp:InputElement = cast(menuRef.current.childNodes.item(i++), InputElement);
			inp.checked = true;
			trace(iW);
			if(iW>aW)
				aW = iW;
		}	*/
		aW = menuRef.current.getElementsByClassName('panel').item(0).offsetWidth;
		trace(aW);//
		/*for(panel in menuRef.current.getElementsByClassName('panel'))
		{
			panel.style.width = '${aW}px';
		}*/
		if(state.sameWidth==null)
		setState({sameWidth:aW},function (){
			trace("what's up?");
		});
	}
	
	override public function componentDidMount():Void 
	{
		//return;
		if(props.sameWidth && state.sameWidth == null)
		{
			//Timer.delay(layout,800);
			trace(menuRef.current.offsetWidth);
			layout();
			trace(menuRef.current.offsetWidth);
		}
	}
	
	override public function componentDidUpdate(prevProps:SMenuProps, prevState:SMenuState):Void 
	{
		//super.componentDidUpdate(prevProps, prevState);
	}
}