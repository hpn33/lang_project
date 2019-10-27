extends Node

onready var update_label = $UI/L1/InputPart/VBox/bar/update/Label
onready var update_progress = $UI/L1/InputPart/VBox/bar/update/Progress
onready var input = $UI/L1/InputPart/VBox/input

onready var output = $UI/L1/OutputPart/output


onready var timer = $Timer

func _ready() -> void:
	update_progress.max_value = timer.wait_time

func _process(delta: float) -> void:
	update_label.text = str(timer.time_left)
	
	if timer.is_stopped():
		update_progress.value = 0
	else:
		update_progress.value = timer.wait_time - timer.time_left

func _on_input_text_changed() -> void:
	timer.start()

func split_text(text: String) -> Array:
	var array_text := []
	
	var string := ''
	var can_be_add = false
	var is_string = false
	
	var text_array := []
	
	for l in text:
		text_array.append(l)
	
	for i in text_array.size():
		
		var let = text_array[i]
		
		if let == '\'':
			is_string = !is_string
			if not is_string:
				can_be_add = true
#			print(is_string)
		
		elif let != ' ' or is_string:
			
			string += let
#			print(let, '\t', string)
			if i+1 == text_array.size():
				can_be_add =  true
		else:
#			print('space')
			if not is_string:
				can_be_add = true
		
		if can_be_add:
			array_text.append(string)
			string = ''
			can_be_add = false
	
	return array_text

func lexer(input: String) -> void:
	var array_text = split_text(input)
	
	parser(array_text)

func parser(a_text: Array) -> void:
	print('/////////parser')
	var can_go := true
	var i := 0
	var action := 'check_token'
	var out_text := ''
	
	out_text += str(a_text) + '\n'
	
	while can_go:
		
		if i == a_text.size():
			can_go = false
			continue
		
		var token : String= a_text[i]
		
		token = token.replace('\n', '')
		
		print('-', action)
		print(token)
		
		match action:
			'check_token':
				if token == 'print':
					action = 'print'
				i+=1
			'print':
				out_text += token + '\n'
				action = 'check_token'
				i+=1
	
	
	
	output.text = out_text

func _on_Timer_timeout() -> void:
	lexer(input.text)

func _on_SimpleText_pressed() -> void:
	input.text = """print 'hello world'"""
	input.emit_signal("text_changed")


func _on_Compile_pressed() -> void:
	lexer(input.text)
