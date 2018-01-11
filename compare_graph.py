#!/usr/bin/env python
import argparse
import networkx
import sys

parser = argparse.ArgumentParser(description='Compare two versions of the graphs')
parser.add_argument('-r', dest='referencefile', default='dariah_infrastructure.gv',
                    help='Filename of the reference graph, default: dariah_infrastructure.gv')
parser.add_argument('-g', dest='newgraphfile', required=True,
                    help='Filename of the graph to compare against the reference')
args = parser.parse_args()

oldgraph = networkx.drawing.nx_pydot.read_dot(args.referencefile)
newgraph = networkx.drawing.nx_pydot.read_dot(args.newgraphfile)

GM = networkx.algorithms.isomorphism.DiGraphMatcher(oldgraph, newgraph)

if GM.is_isomorphic():
    print("Graph unchanged.")
    sys.exit(0)
else:
    print("Graph changed!")
    sys.exit(1)

