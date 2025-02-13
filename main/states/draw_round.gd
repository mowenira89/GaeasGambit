class_name DrawState extends State

@onready var payment_round: PaymentState = $"../PaymentRound"

func enter():
	state_machine.ui.round_display.switch_player(GM.player)
	state_machine.round_display.set_text("Draw Phase")
	GM.player.discard_hand()
	GM.player.draw_hand()
	#TODO: logic for redrawing hand here
	state_machine.change_state(payment_round)
	if GM.player==GM.players[0]:
		GM.new_turn.emit()
