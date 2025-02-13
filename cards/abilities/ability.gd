class_name Ability extends Resource

@export var term:String
@export_multiline var phrase:String
@export var owner:CardData

func init(o):
	owner=o
	
func setup_targeting():
	GM.using_ability=self
	GM.targeting.emit()
	
	
func on_payment_round_start(user:UnitBody):
	pass

func get_phrase():
	pass

func use(user:UnitBody):
	pass

func check_target(target):
	pass

func get_range():
	pass
	
func on_take_damage(damagee:UnitBody,damage:float):
	pass
	
func on_death(dier:UnitBody):
	pass
