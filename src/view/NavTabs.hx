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

@:wrap(react.router.ReactRouter.withRouter)
class NavTabs extends ReactComponentOfProps<RouteComponentProps>
{
	public function new(?props:RouteComponentProps, ?context:Dynamic) 
	{
		trace(props);
		trace(context);
		super(props, context);		
	}
	
	override public function render()
	{
		trace(props);
		trace(Reflect.field(props,'computedMatch'));
		trace(Reflect.fields(props));
		return jsx('
		<>
			<Tabs centered={true}>				
				<ul>
					<TabLink to="/dashboard" ${...props}>DashBoard</TabLink> 
					<TabLink to="/qc" ${...props}>QC</TabLink>
					<TabLink to="/contacts" ${...props}>Contacts</TabLink>
				</ul>
			</Tabs>	
			${props.children}
		</>		
		');
	}	
	
	function TabLink(rprops)
	{
		trace(rprops);
		trace(Reflect.fields(rprops));
		return jsx('
		<li className=${rprops.to == rprops.location.pathname?"is-active":""}><NavLink to=${rprops.to}>${rprops.children}</NavLink></li>
		');
	}
}