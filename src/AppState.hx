package;
import model.GlobalAppState;
import model.UserService.UserState;
import model.StatusBarService.StatusBarState;

typedef AppState =
{
	appWare:GlobalAppState,
	statusBar:StatusBarState,
	userService:UserState
}