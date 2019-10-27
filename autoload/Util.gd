extends Node

var debug := true
var levels := {
	normal = false,
	lexer = false,
	lexer_p = false,
	parser = true,
	info= false
}

var output := ''

func p(text, level = 'normal'):
	
	output += text + '\n'
	
	if debug and levels[level]:
		print(text)

func info(text):
	p(text, 'info')

func lexer_p(text):
	p(text, 'lexer_p')

func parser(text):
	p(text, 'parser')

