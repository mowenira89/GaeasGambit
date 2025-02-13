class_name TerritoryData extends Resource

enum types {Flatland,Forest,Wetlands,Mountain,Aquatic}

@export var image:Texture2D
@export var name:String
@export var capacity:float
@export var movement_req:float
@export var defense_bonus:float
@export var type:types
@export var points:Dictionary = {
	"Spear":0,
	"Gear":0,
	"Book":0,
	"Basket":0
}
