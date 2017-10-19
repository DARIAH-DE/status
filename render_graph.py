#!/usr/bin/env python
from graphviz import Digraph
import glob
import re
import frontmatter

dot = Digraph(format='png')
dot.attr(label=r'DARIAH-DE Infrastructure', fontsize='20', fontname='helvetica')

collections = ['services','middlewares','servers','infrastructure']
shapes = {'services': 'oval', 'middlewares': 'hexagon', 'servers': 'house', 'infrastructure': 'box'}
colors = {'services': 'forestgreen', 'middlewares': 'red', 'servers': 'blue3', 'infrastructure': 'blue3'}
for coll in collections:
    #dot.attr('node', shape=shapes[coll],style='rounded,bold',color=colors[coll])
    with dot.subgraph(name='cluster_'+coll, node_attr={'shape': shapes[coll], 'style': 'rounded,bold', 'color': colors[coll], 'fontname': 'helvetica' }) as c:
        c.attr(label='',color='white')
        items = glob.glob('_'+coll+'/*.yaml')
        for item in items:
            itemkey = re.sub(r"^_", "/", item).replace(".yaml", "")
            itemdata = frontmatter.load(item)
            c.node(itemkey,itemdata['title'])

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

