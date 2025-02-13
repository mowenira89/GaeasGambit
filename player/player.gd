class_name Player extends Resource

@export var name:String
@export var color:Color
var territories:Array[Territory]
@export var points:Dictionary={
	"Spear":0,
	"Gear":0,
	"Book":0,
	"Basket":0
}
@export var deck:Deck
@export var hand:Array[CardData]
@export var discard:Array[CardData]
@export var graveyard:Array[CardData]

func create_new_player(_name:String,_color:Color):
	name=_name
	color=_color
	
func initialize_deck():
	for x in deck.pile:
		if x is CardData:
			x.owner=self
			pass
	
func restore_deck():
	deck.pile=discard
	deck.pile.shuffle()

func discard_hand():
	discard.append_array(hand)
	hand.clear()

func draw_card(player:Player):
	if deck.pile.is_empty():
		restore_deck()
		if deck.pile.is_empty():
			return false
	var new_card:CardData = deck.pile.pop_at(0)
	new_card.location=CardData.card_locations.Hand
	hand.append(new_card)
	GM.show_hand.emit(player)
	
func draw_hand():
	for x in 6:
		draw_card(GM.player)
	
