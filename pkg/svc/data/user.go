package data

type MyUsers struct {
	Id        int32  `gorm:"column:id"`
	Name      string `gorm:"column:name"`
	Surname   string `gorm:"column:surname"`
	Is_active bool   `gorm:"column:is_active"`
	Age       int32  `gorm:"column:age"`
}