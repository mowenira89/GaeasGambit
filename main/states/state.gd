class_name State extends Node

var state_machine:StateMachine

func init():
	pass
	
func enter():
	pass
	
func exit():
	pass
	
func process(delta)->State:
	return null
	
func physics(delta)->State:
	return null

func handle_input(event)->State:
	return null

func play_piece(piece:UnitBody):
	piece.reposition()
