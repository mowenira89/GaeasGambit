class_name ConfirmationWindow extends Control

@onready var question: Label = $PanelContainer/VBoxContainer/Question

func _on_yes_pressed() -> void:
	GM.confirmation.emit(true)
	queue_free()

func _on_no_pressed() -> void:
	GM.confirmation.emit(false)
