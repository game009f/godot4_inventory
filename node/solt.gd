class_name Solt extends ColorRect


@export() var item_data:Item = null

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready() -> void:
	texture_rect.visible = false
	label.visible = false
	#必须设置一个值才能显示提示面板
	tooltip_text = "tip"
	#添加事件被背包处理
	mouse_entered.connect(Callable(Inventory._on_mouse_entered.bind(self)))
	mouse_exited.connect(Callable(Inventory._on_mouse_exited.bind(self)))


## 增加预览提示 如装备信息展示
func _make_custom_tooltip(for_text):
	var label1 = Label.new()
	if item_data:
		label1.text = item_data.name
	return label1


## 设置格子数据
## [param data]: 格子数据 
func set_item_data(data:Item):
	item_data = data
	refresh()


func refresh():
	if item_data == null:
		texture_rect.texture = null
		texture_rect.visible = false
		label.text = ""
	else:
		texture_rect.texture = item_data.ico
		texture_rect.visible = true
		label.text = str(item_data.amount)
		label.visible = true if item_data.amount > 1 else false

## 禁用鼠标交互
func disable_mouse()->void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
