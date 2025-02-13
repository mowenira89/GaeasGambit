class_name PaymentPanel extends Control

@onready var point_type_label: Label = $Panel/MarginContainer/PointType
@onready var amount_label: Label = $Panel/MarginContainer/Amount

var _unit:UnitBody
var _point_type:String
var _amount:float

func set_panel(unit:UnitBody,pt:String,amt:float):
	_unit=unit
	_point_type=pt
	_amount=amt
	point_type_label.text=pt
	amount_label.text=str(amt)
	
func pay_price():
	var player_points = GM.player.points
	if player_points[_point_type]-_amount>=0:
		player_points[_point_type]-=_amount
		return true
	return false
	



func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if pay_price():
			_unit.pay_price()
			GM.update_points.emit()
			queue_free()
