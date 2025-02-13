class_name DeploymentState extends State
@onready var targeting_state: Node = $"../TargetingState"
@onready var end_round: Node = $"../EndRound"

func enter():
	
	state_machine.round_display.set_text("Deployment Phase")
	GM.end_turn.connect(end_turn)
	GM.targeting.connect(targeting)
	GM.play_card.connect(play_card)
	
	
func exit():
	GM.end_turn.disconnect(end_turn)
	GM.targeting.disconnect(targeting)
	GM.play_card.disconnect(play_card)
	
func end_turn():
	state_machine.change_state(end_round)

func targeting():
	state_machine.change_state(targeting_state)

func play_card(card:Card):
	GM.current_board.create_piece(card)
	GM.play_card_from_hand.emit()
	
func play_piece(piece:UnitBody):
	if piece.card_data.owner==GM.opponent:
		piece.reposition()
	else:
		if piece.movement_points<=0:
			piece.reposition()
		else:
			piece.move_deployed_unit()
