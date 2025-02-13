class_name TargetingPanel extends Control
@onready var panel: Panel = $Panel
@onready var label: Label = $PanelContainer/Label
@onready var cancel: Button = $Cancel
@onready var color_rect: ColorRect = $ColorRect
@onready var notice: Label = $Panel/Notice

func _ready():
	GM.send_notice.connect(get_notice)
	GM.improper_target.connect(improper_target)
	
func improper_target():
	get_notice("Improper Target")
	
func get_notice(s:String):
	notice.text=s
	panel.visible=true
	await get_tree().create_timer(1).timeout
	panel.visible=false
	
	

func set_text(s:String):
	label.text=s

func show_cancel():
	cancel.visible=!cancel.visible

func _on_cancel_pressed() -> void:
	GM.ability_range.clear()
	GM.current_board.gray_moveable()
	GM.switch_state.emit('back')

func switch_player(player:Player):
	color_rect.color=player.color
