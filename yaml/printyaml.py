#!/usr/bin/env python

import sys,yaml

yamlfilename=sys.argv[1]

with open(yamlfilename,'r') as filehandle:
  print(yaml.load(filehandle.read()))
