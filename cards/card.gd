class_name Card extends Control

const body = preload("res://cards/body.tscn")
@onready var image: TextureRect = $ColorRect/MarginContainer/Image
@onready var color_rect: ColorRect = $ColorRect
@onready var _name: Label = $ColorRect/MarginContainer2/Name
@onready var lvl: Label = $ColorRect/MarginContainer2/LVL
@onready var stats: Label = $ColorRect/MarginContainer2/Stats
@onready var card_back: ColorRect = $ColorRect/CardBack
@onready var card_back_label: RichTextLabel = $ColorRect/CardBack/CardBackLabel
@onready var margin_container: MarginContainer = $ColorRect/MarginContainer
@onready var margin_container_2: MarginContainer = $ColorRect/MarginContainer2


var card_data:CardData


func create_new_card(_card_data:CardData):
	card_data=_card_data
	image.texture=card_data.image
	_name.text = card_data.name
	lvl.text = str(card_data.LVL)
	stats.text = "STR"+str(card_data.STR)+" VIT"+str(card_data.VIT)+" MOV"+str(card_data.MOV)
	var trts=""
	for x in card_data.traits:
		if trts!="":
			trts+=" | "
		trts+=CardData._traits.keys()[x]
	var back_text = ""
	if trts!="":
		back_text+=trts+"\n"
	for x in card_data.abilities:
		var phrase = x.get_phrase()
		if phrase:
			back_text+=phrase + "\n"
	card_back_label.text=back_text
	color_rect.color = card_data.get_color()


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		GM.play_card.emit(self)
	if event.is_action_pressed("right click") and !GM.currently_moving:
		margin_container.visible=!margin_container.visible
		margin_container_2.visible=!margin_container_2.visible
		card_back.visible=!card_back.visible
			
func discard():
	card_data.owner.discard.append(card_data)
	queue_free()
			
func return_to_hand():
	visible=true
