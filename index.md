---
layout: single
author_profile: true
classes: wide
  
sidebar:
  - nav: "all"
  - title: "Title"
    image: http://placehold.it/350x250
    image_alt: "image"
    text: "Some text here."
  - title: "Another Title"
    text: "More text here."
---

![pledin]({{ site.url }}{{ site.baseurl }}/assets/images/logo3.png)

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