extends Node




func do(token_array: Array) -> String:
	u.parser('/////////parser')

	var out_text := keywords_parser(token_array)
	
	return out_text


func keywords_parser(token_array: Array) -> String:
	
	var index =0
	var can_read =true
	
	
	while can_read:
		if not( index < token_array.size()):
			can_read = false
			continue
		
		var tok :u.Token= token_array[index]
		
		if tok.text == 'print':
			if not (index +1 < token_array.size()):
				can_read= false
				print('print need string input')
				index += 1
				continue
			else:
				index += 1
				tok = token_array[index]
				if tok.type == 'string':
					print(tok.text)
					index += 1
					continue
				else:
					print("print need string input")
					index += 1
					continue
		else:
			index += 1
			continue
	
	return ''



