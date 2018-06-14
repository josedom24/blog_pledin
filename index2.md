---
title: "PLEDIN"
layout: splash
permalink: /splash-page/
date: 2016-03-23T11:48:41-04:00
header:
  overlay_color: "#000"
  overlay_filter: "0.2"
  overlay_image: /assets/images/ord.png
  #cta_label: "Download"
  #cta_url: "https://github.com/mmistakes/minimal-mistakes/"
  caption: "Servidores IESGN"
excerpt: "Plataforma Educativa Informática"
intro: 
  - excerpt: 'Bienvenidos a la página personal de José Domingo Muñoz Rodríguez, aquí podrás encontrar...'
feature_row:
  - image_path: http://via.placeholder.com/250x150
    alt: "placeholder image 1"
    title: "Blog"
    excerpt: "Accede a las entradas de mi blog donde escribo de Informática y Educación."
  - image_path: http://via.placeholder.com/250x150
    image_caption: "Prueba..."
    alt: "placeholder image 2"
    title: "Cursos"
    excerpt: "Accede a los materiales de los cursos que he impartido."
    #url: "#test-link"
    #btn_label: "Read More"
    #btn_class: "btn--primary"
  - image_path: http://via.placeholder.com/250x150
    title: "Módulos"
    excerpt: "Accede a los contenido de los módulos de FP que estoy impartiendo en la actualidad."
feature_row2:
  - image_path: /assets/images/unsplash-gallery-image-2-th.jpg
    alt: "placeholder image 2"
    title: "Placeholder Image Left Aligned"
    excerpt: 'This is some sample content that goes here with **Markdown** formatting. Left aligned with `type="left"`'
    url: "#test-link"
    btn_label: "Read More"
    btn_class: "btn--primary"
feature_row3:
  - image_path: 
    alt: ""
    title: "Últimos posts..."
    excerpt: ''
    #url: "#test-link"
    #btn_label: "Read More"
    #btn_class: "btn--primary"
  - image_path: 
    alt: ""
    title: ""
    excerpt: ''
    #url: "#test-link"
    #btn_label: "Read More"
    #btn_class: "btn--primary"
feature_row4:
  - image_path:
    alt: "cc"
    title: "Licencia"
    excerpt: 'Licencia Puedes copiar y modificar todos los contenidos, pero siempre respetando los términos de la licencia CC-BY-SA.'
    url: "https://creativecommons.org/licenses/by-sa/3.0/es/"
    btn_label: "Licencia"
    btn_class: "btn--primary"
---

{% include feature_row id="intro" type="center" %}

{% include feature_row %}

**Últimos posts...**
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



![](https://www.josedomingo.org/pledin/wp-content/uploads/2010/04/88x31.png){: .align-center}
{% include feature_row id="feature_row4" type="center" %}
