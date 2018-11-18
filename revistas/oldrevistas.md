---
layout: single
permalink: /revistas/oldrevistas.html
author_profile: true
classes: wide
sidebar:
  nav: "all"
comments: true
---
# Revistas Libres de Software Libre
{: .text-center}
![presentación]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2011/02/revistas.jpg){: .align-center}

## Revistas antiguas
Aquí podrás encontrar una colección de revistas de Software Libre que ya no están activas o son la primera época de algunas revistas actuales. Puedes descargarte todos los números en formato zip.

{% for revista in site.data.revistas %}
### {{revista.name}}
<table>
<tr>
<td width="20%"><img src="img/{{revista.img}}"/></td>
<td>
{{revista.descripcion}}
<ul>
  <li>Números: {{revista.numeros}}</li>
  <li>Años: {{revista.years}}</li>
  <li><a href="{{revista.url}}">Descarga</a></li>
  {% if revista.web != ""%}
  <li><a href="{{revista.web}}">Página web</a></li>
  {% endif %}
</ul>
</td>
</tr>
</table>
{% endfor %}

# [Accede a la colección de revistas actuales](index.html)
{: .text-center}
