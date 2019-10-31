extends Node

var temp := {
	next = {
		'var': {
			type = 'keyword',
			next = {
				'name': {
					type = 'value_name',
					next = {
						'=': {
							type = 'assign',
							next = {
								'value': {
									type = 'value',
									next = {
										'end': 'end'
									}
								}
							}
						}
					}
				}
			}
		},
		'print': {
			type = 'keyword',
			next = {
				'value': {
					type = 'value',
					next = {
						'end': 'end'
					}
				},
				'value_name': {
					type = 'value_name',
					next = {
						'end': 'end'
					}
				}
			}
		}
	}
}

"""
@keyword = [print, var]

var value_name = value

print
	value
	value_name


"""
