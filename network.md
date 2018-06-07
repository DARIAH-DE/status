---
title: 'Interactive Graph'
layout: index
---

<script>
var data = {
  "nodes": [
  {%- comment -%}
    Look for all nodes.
  {%- endcomment -%}
{%- for coll in site.collections -%}
{%- assign cindex = forloop.index -%}
{%- assign clength = forloop.length -%}
{%- if coll.label != 'posts' -%}
{%- for item in coll.docs -%}
  {%- if cindex == clength and forloop.last -%}
    {"id": "{{ item.title | replace: ' ', '.' }}", "group": {{ cindex }}}
  {%- else -%}
    {"id": "{{ item.title | replace: ' ', '.' }}", "group": {{ cindex }}},
  {%- endif -%}
{%- endfor -%}
{%- endif -%}
{%- endfor -%}
],
  "links": [
{%- comment -%}
    Create the links.
{%- endcomment -%}
{%- capture links -%}{%- for coll in site.collections -%}
  {%- if coll.label != 'posts' -%}
  {%- for item in coll.docs -%}
    {%- assign sz = item.dependencies | size -%}
    {%- if sz == 0 -%}{%- else -%}
      {%- for dep in item.dependencies -%}
        {%- if dep contains '/servers/' -%}
          {%- assign depobj = site.servers | where:"id", dep | first -%}
        {%- elsif dep contains '/middlewares/' -%}
          {%- assign depobj = site.middlewares | where:"id", dep | first -%}
        {%- elsif dep contains '/services/' -%}
          {%- assign depobj = site.services | where:"id", dep | first -%}
        {%- elsif dep contains '/infrastructure/' -%}
          {%- assign depobj = site.infrastructure | where:"id", dep | first -%}
        {%- endif -%}
        {"source": "{{ item.title | replace: ' ', '.' }}", "target": "{{ depobj.title | strip | replace: ' ', '.' }}", "value": 1}|
      {%- endfor -%}
    {%- endif -%}
  {%- endfor -%}
  {%- endif -%}
{%- endfor -%}{%- endcapture -%}
{%- assign array = links | remove: "\n" | remove: " " | split: "|" | uniq -%}
{%- for a in array -%}
{%- if forloop.last == true -%}
{{ a }}
{%- else -%}
{{ a | append: ","}}
{%- endif -%}
{%- endfor -%}
]}
</script>
<svg class="network" width="500" height="800"></svg>
<script src="https://d3js.org/d3.v4.min.js"></script>
<script>

var svg = d3.select("svg"),
    width = +svg.attr("width"),
    height = +svg.attr("height");

var color = d3.scaleOrdinal(d3.schemeCategory10);

var simulation = d3.forceSimulation()
    .force("link", d3.forceLink().id(function(d) { return d.id; }))
    .force("charge", d3.forceManyBody())
    .force("center", d3.forceCenter(width / 2, height / 2));


 var link = svg.selectAll(".link")
            .data(links)
            .enter()
            .append("line")
            .attr("class", "link")

  var node = svg.selectAll(".node")
            .data(data.nodes)
            .enter()
            .append("g")
            .attr("class", "node")
            .call(d3.drag()
                    .on("start", dragstarted)
                    .on("drag", dragged)
                    //.on("end", dragended)
            );
  node.append("circle")
              .attr("r", 5)
              .style("fill", function (d, i) {return colors(i);})
    node.append("title")
        .text(function (d) {return d.id;});

    node.append("text")
        .attr("dy", -3)
        .text(function (d) {return d.name+":"+d.label;});

  simulation
      .nodes(data.nodes)
      .on("tick", ticked);

  simulation.force("link")
      .links(data.links);

  function ticked() {
    link
        .attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node
        .attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });
  }


function dragstarted(d) {
  if (!d3.event.active) simulation.alphaTarget(0.3).restart();
  d.fx = d.x;
  d.fy = d.y;
}

function dragged(d) {
  d.fx = d3.event.x;
  d.fy = d3.event.y;
}

function dragended(d) {
  if (!d3.event.active) simulation.alphaTarget(0);
  d.fx = null;
  d.fy = null;
}

</script>
