package model;
import view.shared.io.User;
import history.Location;
import model.GlobalAppState;
import model.LocationState;
import view.shared.io.User.UserProps;
import model.StatusBarService.StatusBarState;

typedef AppState =
{
	appWare:GlobalAppState,
	//locationHistory:LocationState,
	statusBar:StatusBarState
}
