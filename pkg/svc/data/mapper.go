package data

import "my-app-example/pkg/pb"

type MappedObject interface {
	GetGrpcAnalogue() interface{}
}

func (usr MyUsers)GetGrpcAnalogue() interface{} {
	return pb.User{
		UserId:       usr.Id,
		UserName:     usr.Name,
		UserSurname:  usr.Surname,
		UserAge:      usr.Age,
		IsActiveUser: usr.Is_active,
	}
}

func (usrs MyUsersArr)GetGrpcAnalogue() interface{} {
	respUsers := make([]*pb.User, len(usrs))
	for index, value := range usrs {
		usr := value.GetGrpcAnalogue().(pb.User)
		respUsers[index] = &usr
	}
	return respUsers
}