package model;
import history.Location;
import model.GlobalAppState;
import model.LocationState;
import view.User.UserProps;
import model.StatusBarService.StatusBarState;

typedef AppState =
{
	appWare:GlobalAppState,
	//locationHistory:LocationState,
	statusBar:StatusBarState
	
}
