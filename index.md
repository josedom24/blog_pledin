---
layout: single
author_profile: true
classes: wide
sidebar:
  nav: "all"
---

# PLEDIN 3.0

Bienvenido a la página personal de José Domingo Muñoz

<ul>
  {% for post in site.posts[:5] %}
    <li>
      <a href="{{ post.url }}">
        {{ post.title }}
      </a>
      <time>{{ post.date | date: "%B %-d, %Y" }}</time>
    </li>
  {% endfor %}
</ul>