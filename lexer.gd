extends Node



func do(input: String) -> Array:
	
	var letter_array := u.text_to_letter_array(input)
	
#	var token_array := normal_lexer_pattern(letter_array)
#	var token_array := way1_lexer_pattern(letter_array)
	var token_array := grammer_pattern(letter_array)
	
	return token_array


func grammer_pattern(letter_array: PoolStringArray) -> Array:
	
	var gram :Dictionary= grammer.temp
	var gram_way := []
	
	var token_array := []
	
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
				
				# check index
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
				
				if text in get_g_keys(gram_way):
					u.lexer_p('is keyword')
					gram_way.append(text)
					print(gram_way)
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
				token_array.append(token)
				
				action = 'next_index'
			
			'end':
				can_read = false
	
	for t in token_array:
		u.lexer_p(str(t))
	
	print(token_array)
	return token_array

func get_g_keys(gram_way: Array) -> Array:
	var gram := grammer.temp
	
	var size := gram_way.size()
	
	var keys := []
	
	if size==0:
		keys= gram.next.keys()
	
	else:
		
		for i in size:
			gram = gram.next[gram_way[i]]
		
		keys = gram.next.keys()
	
	return keys

func get_g_values(level: int) -> Array:
	return []


func way1_lexer_pattern(letter_array: PoolStringArray) -> Array:
	
	var token_array := []
	
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
				token_array.append(token)
				
				action = 'next_index'
			
			'end':
				can_read = false
	
	for t in token_array:
		u.lexer_p(str(t))
	
	return token_array


func normal_lexer_pattern(letter_array: PoolStringArray) -> Array:
	
	var token_array := []
	
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
			token_array.append(string)
			string = ''
			can_be_add = false
	
	return token_array


