class_name SetupState extends State
@onready var draw_round: DrawState = $"../DrawRound"


func init():
	pass
	
func enter():
	GM.play_card.connect(play_card)
	state_machine.round_display.set_text("Setup Round")
	state_machine.ui.display_buildings()
	state_machine.ui.round_display.switch_player(GM.player)
	await GM.unit_placed
	GM.current_board.gray_moveable()
	GM.switch_player()
	state_machine.ui.round_display.switch_player(GM.player)
	state_machine.ui.display_buildings()
	await GM.unit_placed
	GM.current_board.gray_moveable()
	GM.switch_player()
	state_machine.ui.close_card_display()
	GM.player.deck.pile.shuffle()
	GM.opponent.deck.pile.shuffle()
	state_machine.change_state(draw_round)
	
	
func exit():
	GM.play_card.disconnect(play_card)
	
func play_card(card:Card):
	GM.current_board.create_piece(card)
	GM.play_initial_card.emit()
