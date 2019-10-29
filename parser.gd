extends Node




func do(token_array: Array) -> String:
	u.parser('/////////parser')
	
	var out_text := way1_parser(token_array)
	
	return out_text
	

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


