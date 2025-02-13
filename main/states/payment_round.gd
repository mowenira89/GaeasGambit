class_name PaymentState extends State
@onready var deployment_round: Node = $"../DeploymentRound"

var needs_payment:Array[UnitBody]

func enter():
	
	state_machine.round_display.set_text("Payment Phase")
	
	state_machine.board.extract_points()
	
	var terts = state_machine.board.territories.get_children()
	for x in terts:
		if x is Territory:
			var agents = x.agents.get_children()
			var buildings = x.buildings.get_children()
			var ter_contents = agents+buildings
			for a in ter_contents:
				if a is UnitBody:
					if a.card_data.owner==GM.player:
						for y in a.card_data.cost:
							if a.card_data.cost[y]!=0:
								needs_payment.append(a)
								a.display_cost()
								a.price_paid.connect(pay_price)
								break
	GM.end_turn.connect(end_turn)
	if needs_payment.is_empty():
		state_machine.change_state(deployment_round)

func pay_price(who:UnitBody):
	needs_payment.erase(who)
	if needs_payment.is_empty():
		state_machine.change_state(deployment_round)


func end_turn():
	for x in needs_payment:
		if x is UnitBody:
			GM.player.graveyard.append(x.card_data)
			x.queue_free()
	state_machine.change_state(deployment_round)

func exit():
	GM.end_turn.disconnect(end_turn)
	needs_payment.clear()
