## 背包管理
##
## 实时更新鼠标指向物品
## 鼠标左键按下，如果指向物品存在则拾取
## 左键松开，如果鼠标指向空节点，则直接发放下，不为空则交换数据
## 注意事项 MouseSolt需要设置成鼠标穿透不接受消息.
extends Control


signal show_solt(solt:Solt) ## 显示物品
signal hide_solt(solt:Solt) ## 退出显示物品

const SOLT = preload("res://node/solt.tscn") ##预览效果


## 当前鼠标指向物品
var current_mouse_node:Solt
## 抓取格子
var drop_solt:Solt
## 抓取物品显示
var mouse_solt: Solt 
## 抓取物品显示偏移
var mouse_offset:Vector2


func _process(delta: float) -> void:
	if mouse_solt:
		mouse_solt.position = get_global_mouse_position() + mouse_offset
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed: ## 按下
				if current_mouse_node: ## 如果鼠标指向物品
					pickup_solt(current_mouse_node) #拾取
			else: ## 松开
				if drop_solt: ##存在抓取物品
					if current_mouse_node: ##存在指向格子
						put_solt(current_mouse_node) #放下
					else: ##鼠标指向空
						cancel_swap() #取消


func _on_mouse_entered(solt:Solt) -> void:
	emit_signal("show_solt", solt)
	#print("entered:" + solt.name)
	current_mouse_node = solt


func _on_mouse_exited(solt:Solt) -> void:
	emit_signal("hide_solt", solt)
	#print("exited:" + solt.name)
	current_mouse_node = null


#增加一个抓取图标预览
func add_preview_item():
	var _solt = SOLT.instantiate() ##后面可以用自定义格子替换方便修改显示效果
	get_tree().root.add_child(_solt)
	mouse_solt = _solt
	_solt.z_index = 1000
	mouse_solt.disable_mouse()
	mouse_solt.set_item_data(null)
	return mouse_solt


#移除预览
func remove_preview_item():
	mouse_solt.queue_free()
	mouse_solt = null


## 拾取
## [param solt]: 格子数据 
func pickup_solt(solt:Solt):
	if solt.item_data == null: #如果目标为空则放弃
		return
	drop_solt = solt
	add_preview_item()
	swap_solt(solt, mouse_solt) #暂存在鼠标格子上展示用
	#居中显示
	mouse_offset = -mouse_solt.size / 2 # drop_solt.position - get_global_mouse_position()

## 放下
## [param solt]: 格子数据 
func put_solt(solt:Solt):
	if solt.item_data: #要交换的格子不为空
		swap_solt(solt, mouse_solt)
		swap_solt(drop_solt, mouse_solt)
		drop_solt = null
	else: #交换格子为空
		swap_solt(solt, mouse_solt)
		drop_solt = null
	remove_preview_item()

## 取消交换
func cancel_swap():
	if mouse_solt.item_data:
		swap_solt(drop_solt, mouse_solt)
		drop_solt = null
	remove_preview_item()

## 交换
## [param form]: 格子数据 
## [param to]: 格子数据 
func swap_solt(form:Solt, to:Solt):
	var data = form.duplicate()
	form.set_item_data(to.item_data)
	to.set_item_data(data.item_data)
