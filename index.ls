text = """
Commencer a 2000
Vider a
Vider a
Incrementer b
Decrementer b
Complementer b
Vider b
Decrementer x
Comparer a a la memoire
Comparer x a la memoire
Decaler mathematiquement a vers la droite
Decaler logiquement b vers la gauche
Mettre a sur la pile
Prendre x de la pile
Decaler a vers la gauche
Decaler b vers la droite
Soustraire 5 de a
Enregistrer d dans $2010
Attendre interruption
Tester
Ne rien faire
""" |> trim

expressions =
	* /Commencer a ([0-9]+)/ -> "ORG #{it.1}"
	* /Vider ([abdxy])/ -> "clr#{it.1}"
	* /Incrementer ([abdxy])/ -> "in#{if it.1 in <[a b]> then 'c' else ''}#{it.1}"
	* /Decrementer ([abdxy])/ -> "de#{if it.1 in <[a b]> then 'c' else ''}#{it.1}"
	* /Complementer ([abdxy])/ -> "com#{it.1}"
	* /Decaler mathematiquement ([ab]) vers la gauche/ -> "asl#{it.1}"
	* /Decaler mathematiquement ([ab]) vers la droite/ -> "asr#{it.1}"
	* /Decaler logiquement ([abd]) vers la gauche/ -> "lsl#{it.1}"
	* /Decaler logiquement ([abd]) vers la droite/ -> "lsr#{it.1}"
	[/Comparer ([abdxy]) a la memoire/ ->
		if it.1 in <[a b]> then "cmp#{it.1}"
		else "cp#{it.1}"]
	[/Mettre (\$?[0-9]+) dans ([abdxy])/ ->
		(switch it.2
			| 'a' 'b' => "lda#{it.2}"
			| 'd'     => "ldd"
			| 'x' 'y' => "ld#{it.2}"
		) + " ##{it.1}"]
	* /Mettre ([abxy]) sur la pile/ -> "psh#{it.1}"
	* /Prendre ([abxy]) de la pile/ -> "pul#{it.1}"
	* /Decaler ([ab]) vers la (gauche|droite)/ -> "ro#{if it.2 is 'gauche' then 'l' else 'r'}#{it.1}"
	* /Soustraire (\$?[0-9]+) de ([abd])/ -> "sub#{it.2} #{it.1}"
	* /Enregistrer ([abd]) dans (\$?[0-9]+)/ -> "st#{if it.1 is 'd' then '' else 'a'}#{it.1} #{it.2}"
	* /Echanger ([d]) avec ([xy])/ -> "xgd#{it.2}"
	* /Attendre interruption/ -> "wai"
	* /Tester/ -> "test"
	* /Ne rien faire/ -> "nop"

parse text / '\n' |> console.log

function parse(lines)
	str = []

	for line in lines
		found = false

		for [rule, method] in expressions
			if rule.exec line
				str.push method that
				found = true

		throw new Error "Cannot parse : #line" unless found

	str * '\n'

function trim then it - /^\s|\n$/