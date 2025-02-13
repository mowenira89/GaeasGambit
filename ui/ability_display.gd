class_name AbilityDisplay extends Control

@export var ability:Ability
@onready var label: Label = $ColorRect/Label
var _owner:UnitBody


func create_display(a:Ability, o:UnitBody):
	ability=a
	label.text = ability.get_phrase()
	_owner=o

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if GM.current_state is ResponseState and _owner.card_data.owner==GM.opponent:
			if _owner.movement_points>0:
				_owner.movement_points-=1
				ability.use(_owner)
			else:
				GM.send_notice.emit("Not enough MOV")
		
		else:			
			if _owner.card_data.owner==GM.player:
				if _owner.movement_points>0:
					_owner.movement_points-=1
					ability.use(_owner)
				else:
					GM.send_notice.emit("Not enough MOV")
		
