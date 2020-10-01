---
title: 'DARIAH-DE Service Status'
layout: embed
---


{%- capture dariahmessages %}

{% assign outages_array = site.data.outages | where_exp: "item", "item.hide != true"  %}
{% assign outages_array = outages_array | where_exp: "item", "item.date_end == nil"  %}
{% for outage in outages_array %}
  {% include embed.html item=outage itemtype='error' %}
{% endfor %}


{% assign announcements_array = site.data.announcements | where_exp: "item", "item.hide != true"  %}
{% for announcement in announcements_array %}
  {% include embed.html item=announcement itemtype='warning' %}
{% endfor %}

{%- endcapture %}

{{ dariahmessages }}
