class_name TerritoryDataDisplay extends Control
@onready var color_rect: ColorRect = $ColorRect

@onready var _name: Label = $ColorRect/Name

@onready var spears: Label = $ColorRect/HBoxContainer/ColorRect/Spears
@onready var gears: Label = $ColorRect/HBoxContainer/ColorRect2/Gears
@onready var books: Label = $ColorRect/HBoxContainer/ColorRect3/Books
@onready var baskets: Label = $ColorRect/HBoxContainer/ColorRect4/Baskets
@onready var capacity: Label = $ColorRect/Capacity

func create_panel(t:Territory):
	var pts = t.territory_data.points
	_name.text=t.territory_data.name
	var total_spear = pts["Spear"]
	var total_gear = pts["Gear"]
	var total_book = pts["Book"]
	var total_basket = pts["Basket"]	

	for x in t.buildings.get_children():
		if x is UnitBody:
			if x.card_data.owner==t._owner:
				match x.card_data.type:
					0:total_spear+=x.card_data.LVL
					1:total_gear+=x.card_data.LVL
					2:total_book+=x.card_data.LVL
					3:total_basket+=x.card_data.LVL

	spears.text = str(total_spear)
	gears.text = str(total_gear)
	books.text = str(total_book)
	baskets.text = str(total_basket)
	
	capacity.text=str(t.capacity_filled)+"/"+str(t.territory_data.capacity)
	color_rect.position=get_global_mouse_position()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") or event.is_action_pressed("right click"):
		queue_free()
		
