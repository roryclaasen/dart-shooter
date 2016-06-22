import PyYAML
import os

path = os.path.dirname(os.path.realpath(__file__))
path = path[:-len("scripts")]

pubspec = {}
with open(path + "pubspec.yaml")  as stream:
	pubspec = yaml.load(stream)

data = dict(
    name = pubspec['name'],
    description = pubspec['description'],
	version = pubspec['version'],
	homepage = pubspec['homepage']
)

with open(path + 'build/web/data.yml', 'w') as outfile:
    outfile.write(yaml.dump(data, default_flow_style=False))

with open(path + 'build/web/README.md', 'w') as outfile:
	outfile.write('# Dart Shooter ' + data['version'] + '\n')
	outfile.write(data['description'] + '\n\n')
	outfile.write('This branch gets updated automatically!\n\n')
	outfile.write('Any change or commit will be **overwritten**!\n')
