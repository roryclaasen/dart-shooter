import os

path = os.path.dirname(os.path.realpath(__file__))
path = path[:-len("scripts")]

data = ""
toKeep = ['name:', 'description:', 'version:', 'homepage:']
with open(path + 'pubspec.yaml', 'r') as f:
	for line in f:
		if line.startswith(tuple(toKeep)):
			data += line
			print(line)

print("Saving gh-pages data file")
with open(path + 'build/web/data.yaml', 'w') as outfile:
	outfile.write(data)

print("Creating gh-pages readme")
with open(path + 'build/web/README.md', 'w') as outfile:
	outfile.write('# Dart Shooter\n\n')
	outfile.write('This branch gets updated automatically!\n\n')
	outfile.write('Any change or commit will be **overwritten**!\n')

print("Creating gh-pages gitignore")
with open(path + 'build/web/.gitignore', 'w') as outfile:
	outfile.write('*.psd')
	
exit(0)
