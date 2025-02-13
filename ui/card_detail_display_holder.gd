class_name CardDetailDisplayHolder extends Control

const DETAILS = preload("res://ui/card_data_display.tscn")

func _ready():
	GM.show_card_details.connect(show_details)
	
func show_details(body:UnitBody):
	if !get_children().is_empty():
		var c = get_child(0)
		if c is CardDataDisplay:
			if c.paused:
				return false
	for x in get_children():
		x.queue_free()
	var nd = DETAILS.instantiate()
	add_child(nd)
	nd.create_display(body)
