---
layout: single
author_profile: true
classes: wide
sidebar:
  nav: "all"
---

{% include figure image_path="/assets/images/logo3.png" alt="pledin" %}


Bienvenido a la página personal de José Domingo Muñoz, 

<ul>
  {% for post in site.posts offset: 0 limit: 5%}
    <li>
      <a href="{{ site.baseurl }}{{ post.url }}">
        {{ post.title }}
      </a>
      <small>({{ post.date | date: "%d-%m-%Y" }})</small>
    </li>
  {% endfor %}
</ul>