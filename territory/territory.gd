class_name Territory extends Control

const DISPLAY = preload("res://ui/territory_data_display.tscn")

@onready var textr: TextureRect = $OuterBorder/MarginContainer/InnerBorder/MarginContainer/TextureRect
@onready var buildings: Node2D = $Buildings
@onready var agents: Node2D = $Agents

@export var territory_data:TerritoryData

@onready var outer_border: ColorRect = $OuterBorder
@onready var inner_border: ColorRect = $OuterBorder/MarginContainer/InnerBorder

@export var index:int
@export var _owner:Player

@export var capacity_filled:int

func _ready():
	GM.new_game.connect(new_game)
	
func new_game():
	index = GM.current_board.territories.get_children().find(self)
	territory_data=GM.territories.pile.pick_random()
	textr.texture=territory_data.image
	neutralize()

func set_territory(data:TerritoryData):
	index = GM.current_board.territories.get_children().find(self)
	territory_data=data
	textr.texture = territory_data.image

func get_summoning_total(type:CardData.types):
	var base_total = CardData.types.keys()[type]
	var total = territory_data.points[base_total]
	for x in buildings.get_children():
		if x is UnitBody:
			if x.card_data is Building:
				if x.card_data.type==type:
					total+=x.card_data.LVL
	return total



func building_test(building:UnitBody):
	if territory_data.type==TerritoryData.types.Aquatic:
		if CardData._traits.Aquatic not in GM.currently_moving.card_data.traits:
			return false
	if building.card_data.owner==_owner:
		if check_capacity(building):
			pass

func check_capacity(building:UnitBody):
	if capacity_filled+building.card_data.LVL<=territory_data.capacity:
		return true
	else:
		print('returning false')
		return false



func place_piece(piece:UnitBody):
	if piece.card_data is Building:
		piece.reparent(buildings)
		capacity_filled+=piece.card_data.LVL		
		if _owner==null:
			grant_territory(piece.card_data.owner)
	elif piece.card_data is Agent:
		piece.reparent(agents)
	piece.place(index)
		
func neutralize():
	_owner=null
	outer_border.color="#747474"
	
func gray_border():
	inner_border.color="#5b5b5b"
	
func green_border():
	inner_border.color="#5be95b"
	
	
func grant_territory(player:Player):
	_owner=player
	outer_border.color=_owner.color


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and GM.currently_moving!=null:
		if index in GM.moveable_to:
			place_piece(GM.currently_moving)		
	elif event.is_action_pressed("right click") and GM.currently_moving==null:
		var display = DISPLAY.instantiate()
		get_tree().root.add_child(display)
		display.create_panel(self)
