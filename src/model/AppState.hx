package model;
import history.Location;
import model.GlobalAppState;
import model.LocationState;
import model.UserService.UserState;
import model.StatusBarService.StatusBarState;

typedef AppState =
{
	appWare:GlobalAppState,
	//locationHistory:LocationState,
	statusBar:StatusBarState
	
}
