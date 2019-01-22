package view.shared;
import react.ReactType;

typedef CompState =
{
	activeView:ReactType,
	hasError:Bool,
	?isMounted:Bool
}