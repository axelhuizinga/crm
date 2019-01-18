package model;
import view.shared.io.User;
import haxe.Json;
import haxe.ds.StringMap;
import history.History;
import history.Location;
import view.shared.io.User.UserProps;

typedef DataAccessState = 
{
	//compState:StringMap<CompState>,
	config:Dynamic,
	?hasError:Bool,
	user:UserProps,
    waiting:Bool
}
