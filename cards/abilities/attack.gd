class_name Attack extends Ability

var targ:UnitBody
var attacker:UnitBody

func use(user):
	attacker=user
	setup_targeting()
	get_targetting_area(user)

func check_target(target):
	if target is UnitBody:
		if target.card_data.owner==owner:
			return false
		if target.current_territory not in GM.ability_range:
			return false
		targ=target
		GM.trigger_response.emit(null,-1,null,target)
		
		
func get_phrase():
	return "Attack"		

func get_targetting_area(user:UnitBody):
	var range_region:Array[int]=[]
	range_region.append(user.current_territory)
	if CardData._traits.LongRange in user.card_data.traits:
		for x in [-1,-6,-5,-4,4,5,6,1]:
			range_region.append(range_region[0]+x)
		for x in range(range_region.size()-1,-1,-1):
			if range_region[x]>24 or range_region[x]<0:
				range_region.remove_at(x)
	GM.current_board.highlight_moveable_region(range_region)
	GM.ability_range=range_region

func complete_attack():
	var terts = GM.current_board.territories.get_children()
	var def_bonus = terts[targ.current_territory].territory_data.defense_bonus
	var damage = attacker.card_data.STR-def_bonus
	if targ.card_data is Building:
		if CardData._traits.Bombard not in attacker.card_data.traits:
			damage*=.25
	targ.take_damage(damage)
	
func counterattacking(counterattacker:UnitBody):
	var terts = GM.current_board.territories.get_children()
	var def_bonus = terts[targ.current_territory].territory_data.defense_bonus
		
	var dta = counterattacker.card_data.STR
	var dtc = (attacker.card_data.STR-def_bonus)/2
		
	
	attacker.take_damage(dta)
	counterattacker.take_damage(dtc)
	targ.take_damage(dtc)
	
