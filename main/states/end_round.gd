class_name EndState extends State
@onready var draw_round: DrawState = $"../DrawRound"


func enter():
	GM.switch_player()
	state_machine.change_state(draw_round)
