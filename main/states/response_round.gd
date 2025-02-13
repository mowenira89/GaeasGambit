class_name ResponseState extends State

@onready var deployment_round: DeploymentState = $"../DeploymentRound"

var responding_to:UnitBody
var entered_from:int
var territory:Territory
var target:UnitBody

func init():
	GM.trigger_response.connect(set_response)
	GM.counterattacking.connect(counter)

func enter():
	GM.piece_traveled.connect(_piece_traveled)
	state_machine.ui.round_display.color_rect.color=GM.opponent.color
	state_machine.ui.round_display.set_text("Response Phase")
	GM.show_hand.emit(GM.opponent)
	
func exit():
	GM.piece_traveled.disconnect(_piece_traveled)
	state_machine.ui.round_display.color_rect.color=GM.player.color
	GM.show_hand.emit(GM.player)

func set_response(t:Territory,tt:int, b:UnitBody,targ:UnitBody):
	responding_to=b
	territory=t
	target=targ
	entered_from=tt
	state_machine.change_state(self)
	
func play_piece(piece:UnitBody):
	if piece.card_data.owner==GM.player:
		piece.reposition()
	else:
		if piece.movement_points<=0:
			piece.reposition()
		else:
			get_retreat_zone()
	
func get_retreat_zone():
	var moveable_to:Array[int]=[]
	moveable_to.append(territory.index)
	var terts = GM.current_board.territories.get_children()
	for x in [1,4,5,6,-1,-4,-5,-6]:
		var new_index = territory.index+x
		if new_index>24 or new_index<0: 
			continue
		if new_index==entered_from:
			continue
		if terts[new_index]._owner==GM.opponent:
			moveable_to.append(new_index)
	GM.moveable_to=moveable_to
	GM.current_board.highlight_moveable_region(moveable_to)

func _piece_traveled(body:UnitBody):
	if GM.using_ability is Attack:
		if body!=target:
			GM.using_ability.complete_attack()
			#a different piece has been moved
	state_machine.change_state(deployment_round)
		
func counter(attacker:UnitBody):
	if GM.using_ability is Attack:
		GM.using_ability.counterattacking(attacker)
	state_machine.change_state(deployment_round)
