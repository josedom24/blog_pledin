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
#feature_row2:
#  - image_path: 
#    alt: ""
#    title: "Blogroll"
#    excerpt: '<li><a href="http://www.gonzalonazareno.org">Gonzalo Nazareno</a></li>
#  <li><a href="https://albertomolina.wordpress.com/">Desde lo alto del cerro</a></li>
#  <li><a href="http://ral-arturo.org/">ral-arturo.org</a></li>
#  '
#  - image_path: assets/wp-content/uploads/2011/02/revistas.jpg
#    alt: "Revistas"
#    title: "Revistas Libres de Software Libre"
#    excerpt: ''
#    url: "https://www.josedomingo.org/pledin/revistas/"
#  - image_path: 
#    alt: ""
#    title: "Twitter"
#    excerpt: '<a class="twitter-timeline"  href="https://twitter.com/Pledin_JD" data-widget-id="310016635949940736">Tweets por el @Pledin_JD.</a>
#            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?"http":"https";if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'
#    
#    
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
feature_row2:
  - image_path: 
    alt: ""
    title: "Últimos cursos..."
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

<!--
<h1 id="page-title" class="page__title" itemprop="headline">Microblog</h1>
{% assign sorted_posts = site.microblog | sort: 'date' | reverse %}
{% for post in sorted_posts limit: 3%}
<div class="page__inner-wrap-principal">
        <header>
          {% if post.title %}<h1 id="page-title" class="page__title" itemprop="headline">{{ post.title | markdownify | remove: "<p>" | remove: "</p>" }}</h1>{% endif %}
        </header>
      <section class="page__content" itemprop="text">
        {{ post.content}}
      </section>
  </div>
  
{% endfor %}

-->
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


<div class="feature__wrapper">
        <div class="archive__item-body">
          <h2 class="archive__item-title">Más posts...</h2>
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
        </div>   
        <div class="archive__item-body">
          <h2 class="archive__item-title">Últimos cursos...</h2>
            <ul>
              <li><a href="https://plataforma.josedomingo.org/pledin/cursos/osv4_paas/index.html">Curso: OpenShift v4 como PaaS (2023)</a></li>
              <li><a href="https://plataforma.josedomingo.org/pledin/cursos/osv4_k8s/index.html">Aprende Kubernetes con OpenShift v4 (2023)</a></li>
              <li><a href="https://josedom24.github.io/curso_docker_2022/">Curso: Introducción a  Docker. CPR Badajoz. (2022)</a></li>
              <li><a href="https://github.com/iesgn/curso_kubernetes_cep">Curso: Introducción a Kubernetes. CEP Castilleja de la Cuesta (2022)</a></li>
              <li><a href="https://www.josedomingo.org/pledin/2022/05/curso-cloud-iesgn">"Mini" Curso: Virtualización y Cloud Computing en el IES Gonzalo Nazareno (2022)</a></li>
              <li><a href="https://plataforma.josedomingo.org/">Más cursos...</a></li>
            </ul>
        </div>
        <!--<div class="archive__item-body">
          <h2 class="archive__item-title">Microblog</h2>
            <ul>
            {% assign sorted_posts = site.microblog | sort: 'date' | reverse %}
            {% for post in sorted_posts limit: 6%}
                <li>
                  <a href="{{ site.baseurl }}{{ post.url }}">
                    {{ post.title }}
                  </a>
                  <small>({{ post.date | date: "%d-%m-%Y" }})</small>
                </li>
              {% endfor %}
            </ul>
        </div>   -->
</div>


{% include feature_row id="feature_row4" type="center" %}
