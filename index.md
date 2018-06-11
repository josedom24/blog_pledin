---
layout: single
author_profile: true
classes: wide
sidebar:
  nav: "all"
---

# PLEDIN 3.0

{% include figure image_path="/assets/wp-content/uploads/2014/10/logo3.png" alt="pledin" %}


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