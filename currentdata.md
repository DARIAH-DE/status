---
layout: index
---

# Current data

All listed outages:

````yaml
{%- if site.data.outages.size > 0 %}
---
{% for item in site.data.outages -%}
{% include outage_announce_item.yaml item=item %}
{% endfor -%}
{% endif -%}
````

All listed announcements:

````yaml
{%- if site.data.announcements.size > 0 %}
---
{% for item in site.data.announcements -%}
{% include outage_announce_item.yaml item=item %}
{% endfor -%}
{% endif -%}
````
