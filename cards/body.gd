class_name UnitBody extends Control

const PAYMENT_PANEL = preload("res://ui/payment_panel.tscn")
const DETAILS_PANEL = preload("res://ui/card_data_display.tscn")

@onready var color_rect: ColorRect = $ColorRect

var card_data:CardData
var card_ref:Card
var moving=true
var from_hand=true
@onready var sprite: TextureRect = $Sprite2D
var current_position:Vector2
var current_territory:int=-1
@onready var cost_holder: VBoxContainer = $CostHolder

var movement_points:float
var tokens

var mouse_movement_offset:Vector2
var placement_offset:Vector2

var first_turn:bool=true

signal price_paid


func _ready():
	var x_offset = -sprite.size.x/4
	var y_offset = -sprite.size.y/2
	mouse_movement_offset=Vector2(x_offset,y_offset)
	y_offset+=sprite.size.y/4
	placement_offset=Vector2(x_offset,y_offset)
	GM.new_turn.connect(new_turn)
	GM.enter_payment_phase.connect(enter_payment_phase)

func create_body(cardref:Card):
	card_data=cardref.card_data
	card_ref=cardref
	sprite.texture=card_data.sprite
	if card_data is Building:
		sprite.scale=Vector2(.05,.05)
	elif card_data is Agent:
		sprite.scale=Vector2(.025,.025)
	color_rect.color=card_data.owner.color
	

func _process(delta: float) -> void:
	if moving:
		global_position=get_global_mouse_position()+mouse_movement_offset

func drop():
	if from_hand:
		card_ref.return_to_hand()
		queue_free()
	else:
		global_position=current_position
		moving=false
	GM.card_dropped.emit()
	GM.moveable_to.clear()
	GM.currently_moving=null
		
func change_movement_points(d:int):
	movement_points=clamp(movement_points+d,-5,card_data.MOV)
		

		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right click") and moving:
		drop()

				
func place(t:int):
	global_position=get_global_mouse_position()+placement_offset
	from_hand=false
	moving=false
	card_data.location=CardData.card_locations.Field
	if current_territory==-1:
		card_data.owner.deck.pile.erase(card_data)
	if current_territory!=null and t!=current_territory:
		var tert:Territory = GM.current_board.territories.get_child(t)
		change_movement_points(-tert.territory_data.movement_req)
		GM.piece_traveled.emit(self)
		if tert._owner==GM.opponent:
			GM.trigger_response.emit(tert,current_territory,self,null)
	
	current_territory=t
	current_position=global_position
	GM.currently_moving=null
	GM.moveable_to.clear()
	GM.current_board.gray_moveable()
	GM.unit_placed.emit(self)
	
func display_cost():
	for x in card_data.cost:
		if card_data.cost[x]>0:
			var new_cost_panel=PAYMENT_PANEL.instantiate()	
			cost_holder.add_child(new_cost_panel)
			new_cost_panel.set_panel(self,x,card_data.cost[x])
	
func pay_price():
	if cost_holder.get_children().size()==1:
		price_paid.emit(self)	

func _on_gui_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("click") and GM.currently_moving==null:
		GM.play_piece.emit(self)
	elif event.is_action_pressed("right click"):
		GM.hold_card_details.emit()
				
		
func reposition():
	moving=true
	GM.currently_moving=self
	GM.moveable_to.append(current_territory)
	GM.current_board.highlight_moveable_region(GM.moveable_to)
	
func move_deployed_unit():
	moving=true
	GM.currently_moving=self
	#if passive ability has method special_movement_zone else 
	var moveable_region = GM.current_board.get_agent_movement_zone()
	GM.moveable_to=moveable_region
	GM.current_board.highlight_moveable_region(moveable_region)


	
func can_be_on_water():
	if CardData._traits.Aquatic in card_data.traits or CardData._traits.Flight in card_data.traits:
		return true
	return false


func _on_mouse_entered() -> void:
	GM.show_card_details.emit(self)

func new_turn():
	first_turn=false
	movement_points=card_data.MOV

func enter_payment_phase():
	if card_data.owner==GM.player:
		for x in card_data.abilities:
			x.on_payment_round_start(self)

func take_damage(d:float):
	for x in card_data.abilities:
		d=x.on_take_damage(self,d)
	card_data.VIT-=d
	if card_data.VIT<=0:
		die()
	
	
func die():
	for x in card_data.abilities:
		x.on_death(self)
	card_data.owner.graveyard.append(card_data)
	queue_free()
