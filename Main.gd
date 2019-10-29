extends Node

onready var update_label = $UI/L1/InputPart/VBox/bar/update/Label
onready var compile_time_label = $UI/L1/InputPart/VBox/bar/update/CompileTime
onready var update_progress = $UI/L1/InputPart/VBox/bar/update/Progress

onready var input = $UI/L1/InputPart/VBox/input

onready var output = $UI/L1/OutputPart/output

onready var timer = $Timer
onready var compile_time = $CompileTime

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

func split_text(text: String) -> Array:
	
	var array_text := []
	
	var letter_array := text_to_letter_array(text)
	print(letter_array)
	
	
	# way 1 pattern
	array_text = way1_lexer_pattern(letter_array)
	
	# normal pattern
	#array_text = normal_lexer_pattern(letter_array)
	
	return array_text





func way1_lexer_pattern(letter_array: PoolStringArray):
	
	var array_text := []
	
	var text := ''
	
	var letter_array_size = letter_array.size()
	var can_read := true
	var is_string := false
	var can_add := false
	var action := 'get_new_word'
	var index := 0
	var let := ''
	var type := ''
	var token := {}
	
	while can_read:
		u.lexer_p('loop ' + action)
		
		match action:
			'get_new_word':
				let = letter_array[index]
				u.lexer_p(let)
				action = 'check_letter'
			
			'check_letter':
				if let == '\n':
					let = ' '
				
				if let in ['\'']:
					u.lexer_p('is about string')
					action = 'is_string'
				elif let == ' ':
					u.lexer_p('is space')
					if is_string:
						action = 'add_to_text'
					else:
						action = 'next_index'
				
				else:
					u.lexer_p('is normal')
					action = 'add_to_text'
			
			'is_string':
				is_string = !is_string
				if not is_string:
					can_add = true
					u.lexer_p('is_string: ' + str(is_string))
				
				action = 'add_to_text'
			
			'next_index':
				index += 1
				action = 'check_index'
			
			'check_index':
				if index == letter_array_size:
					u.lexer_p('is end')
					action = 'end'
				else:
					action = 'get_new_word'
			
			'add_to_text':
				text += let
				u.lexer_p(text)
				action = 'check_text'
			
			'check_text':
				if text in ['print', 'var']:
					u.lexer_p('is keyword')
					action = 'kayword_token'
				elif can_add:
					can_add = false
					action = 'string_token'
				else:
					u.lexer_p('not match to pattern')
					action = 'next_index'
				
			
			'kayword_token':
				token = {
					type = 'kayword',
					value = text
				}
				text = ''
				
				action = 'add_to_array'
			
			'string_token':
				token = {
					type = 'value',
					value = text
				}
				
				text = ''
				
				action = 'add_to_array'
			
			'add_to_array':
				array_text.append(token)
				
				action = 'next_index'
			
			'end':
				can_read = false
	
	for t in array_text:
		u.lexer_p(str(t))
	
	return array_text



func normal_lexer_pattern(letter_array: PoolStringArray) -> Array:
	
	var array_text := []
	
	var string := ''
	var can_be_add := false
	var is_string := false
	
	for i in letter_array.size():
		
		var let = letter_array[i]
		
		if let == '\'':
			is_string = !is_string
			if not is_string:
				can_be_add = true
#			print(is_string)
		
		elif let != ' ' or is_string:
			
			string += let
#			print(let, '\t', string)
			if i+1 == letter_array.size():
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
	u.parser('/////////parser')
	
	var out_text := ''
	
	out_text = way1_parser(a_text)
	
	
	output.text = out_text
	output.text += u.output
	

func normal_parser(a_text: Array) -> String:
	
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
		
#		print('-', action)
#		print(token)
		
		match action:
			'check_token':
				if token == 'print':
					action = 'print'
				i+=1
			'print':
				out_text += token + '\n'
				action = 'check_token'
				i+=1
	
	return out_text

func way1_parser(array_token: Array) -> String:
	
	var can_go := true
	var i := 0
	var token := {}
	var action := 'check_index'
	var ready_action := ''
	var value_holder 
	
	var out_text := ''
	
#	out_text += str(array_token) + '\n'
	
	while can_go:
		
#		print(action)
		
		match action:
			'check_index':
				if i == array_token.size():
					action = 'end'
				else:
					action = 'get_token'
			
			'next_index':
				i+=1 
				
				action = 'check_index'
			
			'get_token':
				token = array_token[i]
				
				action = 'check_token'
			
			'check_token':
				
				if ready_action:
					action = 'has_ready_action'
				else:
					action = 'need_to_action'
				
			
			'has_ready_action':
				
				if ready_action == 'print':
					ready_action = ''
					action = 'do_print'
			
			'need_to_action':
#				print(token)
				if token.type == 'kayword':
					if token.value == 'print':
						action = 'get_next_token_for_print'
					elif token.value == 'var':
						action = 'next_index'
			
			'get_next_token_for_print':
				
				ready_action = 'print'
				
				action='next_index'
			
			'do_print':
#				out_text += token + '\n'
				
				out_text += token.value + '\n'
				
				action = 'next_index'
			
			'end':
				can_go = false
	
	return out_text

func text_to_letter_array(text:String) -> PoolStringArray:
	var letter_array := PoolStringArray()
	
	for let in text:
		letter_array.append(let)
	
	return letter_array







func compiling():
	compile_time.start()
	
	u.output = ''
	
	lexer(input.text)
	
	compile_time.stop()
	compile_time_label.text = str(compile_time.get_time())


func _on_Timer_timeout() -> void:
	compiling()

func _on_SimpleText_pressed() -> void:
	input.text = """print 'hello world'\nprint 'hello world'"""
	input.emit_signal("text_changed")


func _on_Compile_pressed() -> void:
	compiling()
