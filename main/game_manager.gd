extends Node

var players:Array[Player]
var territories:TerritoriesDeck

var player:Player
var opponent:Player

var current_board:Board
var currently_moving:UnitBody
var moveable_to:Array[int]
var current_state:State

var using_ability:Ability
var ability_range:Array[int]

signal new_game

signal play_initial_card
signal play_card_from_hand
signal moving_card
signal card_dropped
signal unit_placed
signal end_turn
signal update_points
signal show_hand

signal targeting
signal cancel_targeting
signal target_selected
signal improper_target

signal show_card_details
signal close_card_details
signal hold_card_details

signal play_card
signal play_piece
signal piece_traveled

signal confirmation
signal new_turn

signal enter_payment_phase
signal enter_deployment_phase

signal switch_state
signal trigger_response
signal counterattacking

signal send_notice

signal victory

func _ready():
	player = load("res://player/test_player.tres")
	opponent = load("res://player/test_player_2.tres")
	players.append(player)
	players.append(opponent)
	players[0].initialize_deck()
	players[1].initialize_deck()
	territories = load("res://cards/decks/test_territories.tres")
	

func switch_player():
	if player==players[0]:
		player=players[1]
		opponent=players[0]
	else:
		player=players[0]
		opponent=players[1]
		
