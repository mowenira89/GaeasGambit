class_name CardData extends Resource

enum types {Spear, Gear, Book, Basket}
enum _traits{Aquatic, Bombard, Flight, LongRange}
enum card_locations {Deck,Hand,Discard,Field,Grave}

@export var image:Texture2D
@export var sprite:Texture2D
@export var name:String
@export var type:types
@export var LVL:float

@export var STR:float
@export var VIT:float
@export var MOV:float
@export var cost:Dictionary={
	"Spear":0,
	"Gear":0,
	"Book":0,
	"Basket":0
}
@export var traits:Array[_traits]
@export var abilities:Array[Ability]

@export var owner:Player
var location:card_locations=0

func get_color():
	match type:
		types.Spear:
			return "#ffaca3"
		types.Gear:
			return "#c9aca3"
		types.Book:
			return "#f5e488"
		types.Basket:
			return "#b8f891"
