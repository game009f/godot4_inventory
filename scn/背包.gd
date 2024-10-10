extends Control


var items:Array[Item]=[
	load( "res://res/rpg_icons_25.tres"),
	load( "res://res/rpg_icons_26.tres"),
	load( "res://res/rpg_icons_27.tres"),
	load( "res://res/rpg_icons_28.tres")
]

@onready var container: GridContainer = $Container
@onready var item_label: Label = $ItemLabel



func _ready() -> void:
	var chils = container.get_children()
	for i in items.size():
		chils[i].set_item_data(items[i])
	Inventory.show_solt.connect(show_item)
	Inventory.hide_solt.connect(hide_item)


func show_item(solt:Solt):
	if solt.item_data:
		item_label.text = solt.item_data.name


func hide_item(solt:Solt):
	item_label.text = ""
