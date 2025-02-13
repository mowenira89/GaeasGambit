class_name Hand extends HBoxContainer

const card = preload("res://cards/card.tscn")

func _ready():
	GM.show_hand.connect(show_hand)
	
func show_hand(player:Player):
	for x in get_children():
		x.queue_free()
	for x in player.hand:
		var new_card = card.instantiate()
		add_child(new_card)
		new_card.create_new_card(x)
