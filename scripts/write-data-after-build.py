import os

path = os.path.dirname(os.path.realpath(__file__))
path = path[:-len("scripts")]

data = ""
with open(path + "pubspec.yaml) as f:
    for line in f:
        if line.startswith("name:") or line.startswith("description:") or line.startswith("version:") or line.startswith("homepage:"):
        	data += line
with open(path + 'build/web/data.yaml', 'w') as outfile:
	outfile.write(data)
	
with open(path + 'build/web/README.md', 'w') as outfile:
	outfile.write('# Dart Shooter\n\n')
	outfile.write('This branch gets updated automatically!\n\n')
	outfile.write('Any change or commit will be **overwritten**!\n')
