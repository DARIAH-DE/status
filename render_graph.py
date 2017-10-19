#!/usr/bin/env python
from graphviz import Digraph
import glob
import re
import yaml
import frontmatter

dot = Digraph(format='png')
dot.attr(label=r'DARIAH-DE Infrastructure')
dot.attr(fontsize='20')

collections = ['services','middlewares','servers','infrastructure']

for coll in collections:
    items = glob.glob('_'+coll+'/*.yaml')
    for item in items:
        itemkey = re.sub(r"^_", "/", item).replace(".yaml", "")
        itemdata = frontmatter.load(item)
        dot.node(itemkey,itemdata['title'])

for coll in collections:
    items = glob.glob('_'+coll+'/*.yaml')
    for item in items:
        itemkey = re.sub(r"^_", "/", item).replace(".yaml", "")
        itemdata = frontmatter.load(item)
        if 'dependencies' in itemdata.keys():
            if not itemdata['dependencies'] is None :
                for dependency in itemdata['dependencies']:
                    dot.edge(itemkey,dependency)

dot.render(filename='dariah-de-infrastructure.gv')

