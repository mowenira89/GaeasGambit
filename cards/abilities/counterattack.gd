class_name Counterattack extends Ability

func use(user):
	GM.counterattacking.emit(user)

func get_phrase():
	return "Counterattack"
