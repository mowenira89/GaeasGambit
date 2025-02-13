extends Camera2D

@export var pan_speed:float=10

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MWD"):
		zoom-=Vector2(.05,.05)
	elif event.is_action_pressed("MWU"):
		zoom+=Vector2(.05,.05)
	
func _process(delta):
	pan()
	
func pan():
	if Input.is_action_pressed('a'):
		position.x+=pan_speed
	if Input.is_action_pressed('w'):
		position.y+=pan_speed
	if Input.is_action_pressed('d'):
		position.x-=pan_speed
	if Input.is_action_pressed('s'):
		position.y-=pan_speed
