class_name PointsDisplay extends VBoxContainer

@onready var spear_points: Label = $Spears/MarginContainer/SpearPoints
@onready var gear_points: Label = $Gears/MarginContainer/GearPoints
@onready var book_points: Label = $Books/MarginContainer/BookPoints
@onready var basket_points: Label = $Baskets/MarginContainer/BasketPoints

func _ready():
	GM.update_points.connect(update_points)
	
func update_points():
	var points = GM.player.points
	spear_points.text=str(points["Spear"])
	gear_points.text=str(points["Gear"])
	book_points.text=str(points["Book"])
	basket_points.text=str(points["Basket"])
