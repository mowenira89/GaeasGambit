extends CanvasLayer
@onready var hand: Hand = $Hand
@onready var cards_display: GridContainer = $CardsDisplay
@onready var buttons: HBoxContainer = $Buttons
@onready var points_display: VBoxContainer = $PointsDisplay
@onready var round_display: TargetingPanel = $RoundDisplay
@onready var card_detail_display_holder: Control = $CardDetailDisplayHolder


const CARD = preload("res://cards/card.tscn")
	
func show_card_display():
	hand.visible=false
	buttons.visible=false
	points_display.visible=false
	cards_display.visible=true

func close_card_display():
	hand.visible=true
	buttons.visible=true
	points_display.visible=true
	cards_display.visible=false

func clear_display():
	for x in cards_display.get_children():
		x.queue_free()
		

func display_buildings():
	clear_display()
	for x in GM.player.deck.pile:
		if x is Building:
			var new_card = CARD.instantiate()
			cards_display.add_child(new_card)
			new_card.create_new_card(x)
	show_card_display()


func _on_end_turn_pressed() -> void:
	GM.end_turn.emit()
