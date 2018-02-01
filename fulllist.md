---
title: 'Full List'
layout: index
---

# Full Dependencies List

This page lists all dependencies by showing all services affected by outages of infrastructure components.

Additionally, this page detects dependency cycles in the infrastructure data.
In such a case, the follwing error will occur:
```
Liquid Exception: Liquid error (line xx): Nesting too deep in fulllist.md
```

{% for coll in site.collections %}

{% if coll.label != 'posts' %}

## {{ coll.label | capitalize }}

{% for item in coll.docs %}
{% capture headline %}Outage of **{{ item.title }}** affects:{% endcapture %}

{%- capture list_affected %}{% include list_affected.html affected=item.id %}{% endcapture %}
{%- assign array_affected = list_affected | split: ";" %}
{%- include render_affected.html affected_services=array_affected headline=headline %}

{% endfor %}

{% endif %}

{% endfor %}


