
data = ['h', 'e', 'l', 'l', 'o', 'w', 'o', 'r', 'l', 'd']

d3.select 'body'
	.selectAll 'g'
	.data data
	.enter()
	.append 'p'
	.text (d) -> d