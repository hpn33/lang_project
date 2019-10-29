extends Node

onready var update_label = $UI/L1/InputPart/VBox/bar/update/Label
onready var compile_time_label = $UI/L1/InputPart/VBox/bar/update/CompileTime
onready var update_progress = $UI/L1/InputPart/VBox/bar/update/Progress

onready var input = $UI/L1/InputPart/VBox/input

onready var output = $UI/L1/OutputPart/output

onready var timer = $Timer
onready var compile_time = $CompileTime

onready var processor = $processor

func _ready() -> void:
	update_progress.max_value = timer.wait_time
	
	input.add_keyword_color('print', Color.red)
	input.add_keyword_color('var', Color.red)
	

func _process(delta: float) -> void:
	update_label.text = str(timer.time_left)
	
	if timer.is_stopped():
		update_progress.value = 0
	else:
		update_progress.value = timer.wait_time - timer.time_left

func _on_input_text_changed() -> void:
	timer.start()







func compile():
	output.text = processor.compile(input.text)


func _on_Timer_timeout() -> void:
	compile()

func _on_SimpleText_pressed() -> void:
	input.text = """print 'hello world'\nprint 'hello world'"""
	input.emit_signal("text_changed")


func _on_Compile_pressed() -> void:
	compile()
