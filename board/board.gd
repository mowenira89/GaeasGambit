class_name Board extends Node2D

@onready var territories: GridContainer = $Control/Territories
const BODY = preload("res://cards/body.tscn")

func _ready():
	GM.current_board=self
	GM.play_card_from_hand.connect(play_from_hand)
	GM.card_dropped.connect(gray_moveable)
	GM.play_initial_card.connect(base_placement)
	for x in territories.get_children():
		x.set_territory(GM.territories.pile.pick_random())
	GM.new_game.connect(new_game)	
	
func new_game():
	gray_moveable()

func get_player_territories():
	var player_territories:Array[int]=[]
	var all_territories = territories.get_children()
	for x in 25:
		if all_territories[x]._owner==GM.player:
			player_territories.append(x)
	return player_territories		

func get_moveable_zone(piece:UnitBody):
	var moveable_to:Array[int] = []
	var territory:Array[int] = get_player_territories()
	var walking_dist = [-1,-6,-5,-4,1,4,5,6]
	var on_water=piece.can_be_on_water()
	for t in territory:
		for x in walking_dist:
			var frontier = t+x
			if frontier<0 or frontier>24:
				continue
			var frontier_space = territories.get_child(frontier)			
			if !on_water and frontier_space.territory_data.type==TerritoryData.types.Aquatic:
				continue
			if frontier not in moveable_to:
				moveable_to.append(frontier)
	return moveable_to
	
func highlight_moveable_region(moveable:Array[int]):
	var terts = territories.get_children()
	for x in 25:
		terts[x].gray_border()
		if x in moveable:
			terts[x].green_border()
	
func gray_moveable():
	for x in territories.get_children():
		x.gray_border()
	
func get_building_placement_zone():
	var b = GM.currently_moving
	var player_territories:Array[int] = get_player_territories()
	var frontier:Array[int] = get_moveable_zone(b)
	var terts = territories.get_children()
	for x in range(frontier.size()-1,-1,-1):
		if terts[frontier[x]]._owner==GM.opponent:
			frontier.remove_at(x)
	player_territories.append_array(frontier)
	print(player_territories)
	for x in range(player_territories.size()-1,-1,-1):
		if !terts[player_territories[x]].check_capacity(b):
			player_territories.remove_at(x)
	print(player_territories)
	return player_territories
	
func play_from_hand():
	if GM.currently_moving.card_data is Building:
		var moveable_zone:Array[int] = get_building_placement_zone()
		highlight_moveable_region(moveable_zone)	
		GM.moveable_to=moveable_zone	
	elif GM.currently_moving.card_data is Agent:
		summon_agent()
		
func base_placement():
	var base:Array[int] = []
	var player_1_side:Array[int]=[20,21,22,23,24]
	var player_2_side:Array[int]=[0,1,2,3,4]
	base = player_1_side if GM.player==GM.players[0] else player_2_side
	var terts = territories.get_children()
	for x in range(base.size()-1,-1,-1):
		var tert:Territory = terts[base[x]]
		if tert.territory_data.type == TerritoryData.types.Aquatic:
			if !GM.currently_moving.can_be_on_water():
				base.remove_at(x)
		elif !tert.check_capacity(GM.currently_moving):
			base.remove_at(x)
	highlight_moveable_region(base)
	print(base)
	GM.moveable_to=base

func extract_points():
	var points = {
		"Spear":0,
		"Gear":0,
		"Book":0,
		"Basket":0
	}
	var player_terts = get_player_territories()
	for x in player_terts:
		var pt:Territory = territories.get_child(x)
		for p in pt.territory_data.points:
			points[p]+=pt.territory_data.points[p]
		for b in pt.buildings.get_children():
			if b is UnitBody:
				match b.card_data.type:
					0:points["Spear"]+=b.card_data.LVL
					1:points["Gear"]+=b.card_data.LVL
					2:points["Book"]+=b.card_data.LVL
					3:points["Basket"]+=b.card_data.LVL
	
	GM.player.points=points
	GM.update_points.emit()
	
func get_agent_movement_zone():
	var moveable_region:Array[int]=[]
	var idx = GM.currently_moving.current_territory
	var terts = territories.get_children()
	moveable_region.append(idx)
	for x in [-1,-4,-5,-6,1,4,5,6]:
		var new_idx=idx+x
		if new_idx>=0 and new_idx<=24:
			var tert=terts[new_idx]
			if tert is Territory:
				if terts[new_idx].territory_data.type==TerritoryData.types.Aquatic:
					if !GM.currently_moving.can_be_on_water():
						continue
			moveable_region.append(new_idx)
	return moveable_region 

func summon_agent():
	var pts = get_player_territories()
	var terts = GM.current_board.territories.get_children()
	var move_to:Array[int]
	for x in pts:
		if terts[x].get_summoning_total(GM.currently_moving.card_data.type)>=GM.currently_moving.card_data.LVL:
			move_to.append(x)
	GM.moveable_to=move_to
	highlight_moveable_region(move_to)	
		
func create_piece(card:Card):
		var new_body = BODY.instantiate()
		add_child(new_body)
		GM.currently_moving=new_body
		new_body.create_body(card)
		card.visible=false

func check_victory():
	var player_1_territories=[]
	var player_2_territories=[]
	for x in territories.get_children():
		if x is Territory:
			if x._owner==GM.players[0]:
				player_1_territories.append(x)
			elif x._owner==GM.players[1]:
				player_2_territories.append(x)
	if player_1_territories.is_empty():
		GM.victory.emit(GM.players[1])
	elif player_2_territories.is_empty():
		GM.victory.emit(GM.players[0])
	
