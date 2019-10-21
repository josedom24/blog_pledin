---
title: "Plataforma Educativa Informática"
layout: splash
date: 2016-03-23T11:48:41-04:00
header:
  overlay_color: "#000"
  overlay_filter: "0.6"
  overlay_image: /assets/images/ord.png
  #cta_label: "Download"
  #cta_url: "https://github.com/mmistakes/minimal-mistakes/"
  caption: "Servidores IESGN"
excerpt: ""
intro: 
  - excerpt: 'Bienvenidos a la página personal de José Domingo Muñoz Rodríguez, aquí podrás encontrar...'
feature_row:
  - image_path: /assets/images/blog.png
    alt: ""
    excerpt: "Accede a las entradas de mi blog donde escribo de Informática y Educación."
    url: "/blog/"
    btn_label: "Blog Pledin"
    btn_class: "btn--primary btn--small"
  - image_path: /assets/images/cursos.png
    alt: ""
    excerpt: "Accede a los materiales de los cursos que he impartido."
    url: "https://plataforma.josedomingo.org"
    btn_label: "Plataforma Pledin"
    btn_class: "btn--primary btn--small"
  - image_path: /assets/images/modulos.png
    alt: ""
    excerpt: "Accede a los contenido de los módulos de FP que estoy impartiendo en la actualidad."
    url: "https://fp.josedomingo.org"
    btn_label: "Módulos FP"
    btn_class: "btn--primary btn--small"
feature_row2:
  - image_path: 
    alt: ""
    title: "Blogroll"
    excerpt: '<li><a href="http://www.gonzalonazareno.org">Gonzalo Nazareno</a></li>
  <li><a href="https://albertomolina.wordpress.com/">Desde lo alto del cerro</a></li>
  <li><a href="http://ral-arturo.org/">ral-arturo.org</a></li>
  <li><a href="https://www.linuxarena.net/">Linuxarena</a></li>'
  - image_path: assets/wp-content/uploads/2011/02/revistas.jpg
    alt: "Revistas"
    title: "Revistas Libres de Software Libre"
    excerpt: ''
    url: "https://www.josedomingo.org/pledin/revistas/"
  - image_path: 
    alt: ""
    title: "Twitter"
    excerpt: '<a class="twitter-timeline"  href="https://twitter.com/Pledin_JD" data-widget-id="310016635949940736">Tweets por el @Pledin_JD.</a>
            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?"http":"https";if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'
    
    
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
  - image_path: /assets/wp-content/uploads/2010/04/88x31.png
    alt: "cc"
    title: "Licencia"
    excerpt: 'Licencia: Puedes copiar y modificar todos los contenidos, pero siempre respetando los términos de la licencia CC-BY-SA.'
    url: "https://creativecommons.org/licenses/by-sa/3.0/es/"
    btn_label: "Ver"
    btn_class: "btn--primary"
---

{% include feature_row id="intro" type="center" %}

{% include feature_row %}
<h1 id="page-title" class="page__title" itemprop="headline">Últimos posts...</h1>
{% for post in site.posts limit:3 %}
<div class="page__inner-wrap-principal">
        <header>
          {% if post.title %}<h1 id="page-title" class="page__title" itemprop="headline">{{ post.title | markdownify | remove: "<p>" | remove: "</p>" }}</h1>{% endif %}
        </header>
      <section class="page__content" itemprop="text">
        {{ post.excerpt}}
        <a href="{{ site.baseurl }}{{post.url}}">Seguir leyendo...</a><br/>
      </section>
  </div>
  
{% endfor %}


<table>
<tr>
<td>
<h2>Más posts...</h2>
<ul>
  {% for post in site.posts offset: 3 limit: 6%}
    <li>
      <a href="{{ site.baseurl }}{{ post.url }}">
        {{ post.title }}
      </a>
      <small>({{ post.date | date: "%d-%m-%Y" }})</small>
    </li>
  {% endfor %}
</ul>


</td>
<td>
<h2>Últimos cursos...</h2>
<ul>
  <li><a href="https://plataforma.josedomingo.org/pledin/cursos/programacion/">Introducción a la programación con pseudocódigo (2018)</a></li>
  <li><a href="https://plataforma.josedomingo.org/pledin/cursos/apache24/">Curso Apache2.4 (2018)</a></li>
  <li><a href="https://plataforma.josedomingo.org/pledin/cursos/flask/">Curso sobre Flask (Miniframework python para desarrollar páginas web) (2017)</a></li>
  <li><a href="https://plataforma.josedomingo.org/pledin/cursos/python3/">Curso de python3 (2017)</a></li>
  <li><a href="https://github.com/iesgn/curso-ual17">Curso de infraestructura Cloud con OpenStack. Universidad de Almería (2017) (github)</a></li>
  <li><a href="http://iesgn.github.io/emergya/">Curso OpenStack (2016) (github.io)</a></li>
  <li><a href="http://iesgn.github.io/cloud3/">Introducción al Cloud Computing con OpenStack y OpenShift (2015) (github.io)</a></li>
  <li><a href="https://plataforma.josedomingo.org/">Más cursos...</a></li>
  </ul>
</td>
</tr>
</table>


{% include feature_row id="feature_row2" %}
<table style="width: 100%;">
<tr>

<td style="width: 50px; vertical-align:top"><h2>Blogroll</h2>
<ul>
  <li><a href="http://www.gonzalonazareno.org">Gonzalo Nazareno</a></li>
  <li><a href="https://albertomolina.wordpress.com/">Desde lo alto del cerro</a></li>
  <li><a href="http://ral-arturo.org/">ral-arturo.org</a></li>
  <li><a href="https://www.linuxarena.net/">Linuxarena</a></li>
</ul>
<h2>Revistas Libres de Software Libre</h2>
<center><a href="revistas"><img src="assets/wp-content/uploads/2011/02/revistas.jpg"/></a></center>
</td>
<td width="50%">
   <a class="twitter-timeline"  href="https://twitter.com/Pledin_JD" data-widget-id="310016635949940736">Tweets por el @Pledin_JD.</a>
            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
</td>
</tr>
</table>

{% include feature_row id="feature_row4" type="center" %}
