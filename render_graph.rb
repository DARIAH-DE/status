require 'graphviz'
require 'yaml'

dot = GraphViz.new( :G, :type => :digraph )
dot['fontname' => 'helvetica', 'fontsize' => 20, 'label' => 'DARIAH-DE Infrastructure']

collections = ['services','middlewares','servers','infrastructure']
shapes = {'services'=> 'oval', 'middlewares'=> 'hexagon', 'servers'=> 'house', 'infrastructure'=> 'box'}
colors = {'services'=> 'forestgreen', 'middlewares'=> 'red', 'servers'=> 'blue3', 'infrastructure'=> 'blue3'}

nodes = {}

for coll in collections
  c = dot.add_graph("cluster_"+coll, 'color' => 'white', 'label' => '')
  c.node['shape' => shapes[coll], 'style' => 'rounded,bold', 'color' => colors[coll], 'fontname' => 'helvetica']
  items = Dir.glob('_'+coll+'/*.yaml')
  for item in items
    itemkey = item.gsub(/^_/, '/').gsub('.yaml', '')
    itemdata = YAML.load_file(item)
    nodes[itemkey] = c.add_nodes(itemkey, 'label'=> itemdata['title'])
  end
end

for coll in collections
  items = Dir.glob('_'+coll+'/*.yaml')
  for item in items
    itemkey = item.gsub(/^_/, "/").gsub(".yaml", "")
    itemdata = YAML.load_file(item)
    if itemdata.key?('dependencies')
      for dependency in itemdata['dependencies']
        dot.add_edges(nodes[itemkey],nodes[dependency])
      end
    end
  end
end

# Generate output image
dot.output( :png => "dariah_infrastructure.png" )
dot.output( :canon => "dariah_infrastructure.gv" )

