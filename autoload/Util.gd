extends Node

var debug := true
var levels := {
	normal = true,
	lexer = false,
	lexer_p = false,
	parser = true,
	info= false
}

var output := ''

func p(text:String, level := 'normal'):
	
	if levels[level]:
		
		output += text + '\n'
		
		if debug:
			print(text)

func info(text:String):
	p(text, 'info')

func lexer_p(text:String):
	p(text, 'lexer_p')

func parser(text:String):
	p(text, 'parser')

