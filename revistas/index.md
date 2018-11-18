---
layout: single
permalink: /revistas/index.html
author_profile: true
classes: wide
sidebar:
  nav: "all"
comments: true
---
# Revistas Libres de Software Libre
{: .text-center}
![presentación]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2011/02/revistas.jpg){: .align-center}

{% for revista in site.data.revistas_new %}
## {{revista.name}}
<table>
<tr>
<td width="20%"><img src="img/{{revista.img}}"/></td>
<td>
{{revista.descripcion}}
<ul>
  <li>Último número: <strong>{{revista.numero}}</strong></li>
  <li><a href="{{revista.url}}">Accede a todos los números</a></li>
  {% if revista.web != ""%}
  <li><a href="{{revista.web}}">Página web</a></li>
  {% endif %}
</ul>
</td>
</tr>
</table>
{% endfor %}

# [Accede a la colección de revistas antiguas](oldrevistas.html)
{: .text-center}