package pb

import "github.com/infobloxopen/atlas-app-toolkit/gateway"

func init()  {
	fwd := gateway.ForwardResponseMessage

	forward_MyAppExample_GetVersion_0 = fwd
	forward_MyAppExample_GetVersion_1 = fwd

	forward_MyAppExample_GetAllUsers_0 = fwd
	forward_MyAppExample_GetSomeString_0 = fwd
	forward_MyAppExample_GetUserById_0 = fwd
	forward_MyAppExample_TestPostMessage_0 = fwd
	forward_MyAppExample_AddNewUser_0 = fwd
}