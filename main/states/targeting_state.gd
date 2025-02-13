class_name TargetingState extends State
@onready var deployment_round: DeploymentState = $"../DeploymentRound"

func enter():
	state_machine.round_display.set_text("Select Target")
	state_machine.round_display.show_cancel()
	GM.cancel_targeting.connect(cancel_targeting)
	GM.target_selected.connect(target_selected)

func exit():
	GM.cancel_targeting.disconnect(cancel_targeting)
	GM.target_selected.disconnect(target_selected)
	GM.using_ability=null	
	GM.current_board.gray_moveable()
	GM.ability_range.clear()
	state_machine.round_display.show_cancel()
	

func cancel_targeting():
	state_machine.change_state(deployment_round)
	

func target_selected(target):
	if !GM.using_ability.check_target(target):
		GM.improper_target.emit()
		
func play_piece(piece:UnitBody):
	GM.target_selected.emit(piece)
