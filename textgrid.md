---
title: 'TextGridRep Status'
layout: textgrid
---


{%- capture textgridmessages %}

{% assign outages_array = site.data.outages | where_exp: "item", "item.hide != true"  %}
{% assign outages_array = outages_array | where_exp: "item", "item.date_end == nil"  %}
{% for outage in outages_array %}
  {% include textgrid.html item=outage itemtype='error' %}
{% endfor %}


{% assign announcements_array = site.data.announcements | where_exp: "item", "item.hide != true"  %}
{% for announcement in announcements_array %}
  {% include textgrid.html item=announcement itemtype='warning' %}
{% endfor %}

{%- endcapture %}

{% comment %} Make sure there is actually something (must be a class somewhere) {% endcomment %}
{% if textgridmessages contains "class" %}
  {{ textgridmessages }}
{% else %}
  <div class="status repstatus ok">
	  <p>Alles OK mit dem Lab. Aber diese Seite sollte trotzdem nicht angezeigt werden.</p>
  </div>
{% endif %}
