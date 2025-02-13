class_name CardDataDisplay extends Control
@onready var _name: Label = $PanelContainer/Container/Name
@onready var stats: Label = $PanelContainer/Container/Stats
@onready var traits: Label = $PanelContainer/Container/Traits
@onready var container: VBoxContainer = $PanelContainer/Container
@onready var panel_container: PanelContainer = $PanelContainer

const ABILITY_DISPLAY = preload("res://ui/ability_display.tscn")

var paused:bool=false

func _ready():
	GM.close_card_details.connect(func():visible=false)
	GM.hold_card_details.connect(func():paused=true)


func create_display(body:UnitBody):
	var cd:CardData = body.card_data
	_name.text=cd.name
	stats.text = cd.types.keys()[cd.type]+str(cd.LVL)+" | STR "+str(cd.STR)+" VIT "+str(cd.VIT)+" MOV "+str(cd.MOV)
	var trts = ""
	for x in cd.traits:
		if trts!="":
			trts+=" | "
		trts+=CardData._traits.keys()[x]
	if trts!="":
		var trt_label=Label.new()
		container.add_child(trt_label)
		trt_label.text=trts
		
		
	if cd.STR>0:
		if GM.current_state is ResponseState and cd.owner==GM.opponent:
			var counter = Counterattack.new()
			counter.init(body.card_data)
			make_ability_display(counter,body)
		if cd.owner==GM.player:
			var attk = Attack.new()
			attk.init(body.card_data)
			make_ability_display(attk,body)
	for x in cd.abilities:
		var phrase = x.get_phrase()
		if phrase:
			if cd.owner==GM.player:
				make_ability_display(x,body)
			else:
				var new_label=Label.new()
				container.add_child(new_label)
				new_label.text=phrase

func make_ability_display(ab:Ability, body:UnitBody):
	var new_display = ABILITY_DISPLAY.instantiate()
	container.add_child(new_display)
	new_display.create_display(ab,body)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("right click"):
		queue_free()
