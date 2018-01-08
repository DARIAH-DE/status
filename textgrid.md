---
title: 'TextGridRep Status'
layout: textgrid
---


{% comment %} Load TG services {% endcomment %}
{% assign tglab = site.services | where:"id", '/services/tglab' | first %}
{% assign tgrep = site.services | where:"id", '/services/tgrep' | first %}

{% assign outages_array = site.data.outages | where_exp: "item", "item.hide != true"  %}
{% assign outages_array = outages_array | where_exp: "item", "item.date_end == nil"  %}

{% for outage in outages_array %}

  {% comment %} Check whether tg services are affected by this outage {% endcomment %}

  {% for affected_item in outage.affected %}

    {% capture tglab_is_affected %}{% include check_service.html service=tglab affected_item=affected_item %}{% endcapture %}
    {% capture tgrep_is_affected %}{% include check_service.html service=tgrep affected_item=affected_item %}{% endcapture %}

  {% endfor %}

  {% comment %} Process outage data {% endcomment %}
  {% if tglab_is_affected contains "yepp" %}
    TGLab affected
  {% endif %}

  {% if tgrep_is_affected contains "yepp" %}
    TGRep affected
  {% endif %}


{% endfor %}


