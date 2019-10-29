extends Node

onready var lexer = $lexer
onready var parser = $parser

func compile(input: String) -> String:
	
	var output = parser.do(lexer.do(input))
	
	return output
