class_name ExtraPointsAbility extends Ability

@export var points:Dictionary = {
	"Spear":0,
	"Gear":0,
	"Book":0,
	"Basket":0
}

func on_payment_round_start(user):
	for x in GM.player.points:
		GM.player.points[x]+=points[x]
