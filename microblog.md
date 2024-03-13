---
title: Microblog
layout: default
permalink: /microblog/
collection: microblog
classes: wide
---
{% for post in paginator.microblog %}
  <!-- Aquí va el código para mostrar cada publicación -->
{{post.date}}
{% endfor %}

<!-- Enlaces de navegación -->
<div class="pagination">
  {% if paginator.previous_page %}
    <a href="{{ paginator.previous_page_path }}" class="previous">Anterior</a>
  {% endif %}
  
  {% if paginator.next_page %}
    <a href="{{ paginator.next_page_path }}" class="next">Siguiente</a>
  {% endif %}
</div>
