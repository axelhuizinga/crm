package view;

import react.ReactComponent;
import react.ReactMacro.jsx;
import react.router.Route;
import react.router.Route.RouteComponentProps;
import react.router.Link;
import react.router.NavLink;
import bulma_components.Tabs;
import view.shared.SLink;

/**
 * ...
 * @author axel@cunity.me
 */
typedef NavProps =
{
	> RouteComponentProps,
	debug:String
}

@:wrap(react.router.ReactRouter.withRouter)
class NavTabs extends ReactComponentOfProps<NavProps>
{
	static var tabsRendered:Int=0;
	
	public function new(?props:NavProps, ?context:Dynamic) 
	{
		trace(Reflect.fields(props));
		//trace(context);
		trace(Reflect.fields(props));
		super(props);		
	}
	
	override public function render()
	{
		return jsx('
			<Tabs centered={true} boxed={false}>				
				${buildNav()}
			</Tabs>		
		');
	}	
	
	function TabLink(rprops)
	{
		return jsx('
		<li className=${rprops.location.pathname.indexOf(rprops.to) == 0 ?"is-active":""}><NavLink to=${rprops.to}>${rprops.children}</NavLink></li>
		');
	}

	function buildNav()
	{
		var state = App.store.getState().appWare.user;
		trace(state);
		if (state.id == null || state.id == '' || state.jwt == null || state.jwt == '')
		{
			// WE NEED TO LOGIN FIRST
			return null;
		}
		else		
		return jsx('
		<>
			<ul>
				<TabLink to="/dashboard" ${...props}>DashBoard</TabLink> 
				<TabLink to="/contacts" ${...props}>Kontakte</TabLink>
				<TabLink to="/qc" ${...props}>QC</TabLink>
				<TabLink to="/accounting" ${...props}>Buchhaltung</TabLink>
				<TabLink to="/reports" ${...props}>Berichte</TabLink>
			</ul>		
			 <i className = "icon is-pulled-right fa fa-sign-out"  title = "Abmelden"  onClick=${App.logOut}
			 style={{margin:"0.1rem .8rem 0rem .5rem",fontSize:"1.7rem", cursor:"pointer", color:"#801111"}}></i>
		</>
		');
	}
}