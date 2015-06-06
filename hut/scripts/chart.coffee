
data = ['h', 'e', 'l', 'l', 'o', 'w', 'o', 'r', 'l', 'd']

d3.select 'body'
	.selectAll 'p'
	.data data
	.enter()
	.append 'p'
	.text (d) -> d