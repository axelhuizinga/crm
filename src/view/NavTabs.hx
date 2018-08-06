package view;

import react.ReactComponent;
import react.ReactMacro.jsx;
import react.router.Route;
import react.router.Route.RouteComponentProps;
import react.router.Link;
import react.router.NavLink;
import bulma_components.Tabs;

/**
 * ...
 * @author axel@cunity.me
 */
typedef NavProps =
{
	> RouteComponentProps,
	debug:String
}

//@:wrap(react.router.ReactRouter.withRouter)
class NavTabs extends ReactComponentOfProps<NavProps>
{
	public function new(?props:NavProps, ?context:Dynamic) 
	{
		//trace(props);
		trace(context);
		trace(Reflect.fields(props));
		super(props);		
	}
	
	override public function render()
	{
		//trace(props.children);
		trace(Reflect.field(props,'computedMatch'));
		//trace(Reflect.fields(props));
		return jsx('
		<>
			<Tabs centered={true} boxed={true}>				
				<ul>
					<TabLink to="/dashboard" ${...props}>DashBoard</TabLink> 
					<TabLink to="/qc" ${...props}>QC</TabLink>
					<TabLink to="/contacts" ${...props}>Kontakte</TabLink>
					<TabLink to="/accounting" ${...props}>Buchhaltung</TabLink>
					<TabLink to="/reports" ${...props}>Berichte</TabLink>
				</ul>
			</Tabs>	
			${props.children}
		</>		
		');
	}	
	
	function TabLink(rprops)
	{
		//trace(rprops);
		//trace(Reflect.fields(rprops));
		return jsx('
		<li className=${rprops.location.pathname.indexOf(rprops.to) == 0 ?"is-active":""}><NavLink to=${rprops.to}>${rprops.children}</NavLink></li>
		');
	}
}