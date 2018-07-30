package;
import view.User;

typedef RootProps = 
{
	activeUser:User,
	userList:Array<UserState>
};

typedef ApplicationState = 
{
	route: String,
	?themeColor:String,
	?hasError:Bool,
	?component: react.React.CreateElementType,
	?history:Dynamic,
	?locale:String,
	user:User
}
