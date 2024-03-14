---
title: Microblog
layout: microblog
classes: wide
sidebar:
  nav: "microblog"
author_profile: true
---
<div id="list-container">
    <ul id="infinite-list">
        {% for post in site.microblog %}
    
        <li class="tweet">
            <div class="author-image">
                <img src="https://www.josedomingo.org/pledin/assets/images/bio-photo.jpg" alt="Avatar">
            </div>
            <div class="tweet-content">
                <div class="author">José Domingo Muñoz</div>
                <div class="content">{{ post.content }}</div>
                <div class="date">{{ post.date }}</div>
            </div>
        </li>
        {% endfor %}
        
    </ul>
</div>

<div id="list-container">
  <ul id="infinite-list">
    {% for post in site.microblog %}
      <li>{{ post.content }}</li>
    {% endfor %}
  </ul>
</div>

<script>
  // Número de elementos para agregar en cada carga
  const batchSize = 10;

  // Función para agregar elementos a la lista
  function addItems() {
    const list = document.getElementById('infinite-list');

    // Simulando carga de datos
    setTimeout(() => {
      // Obtener el último índice de la lista de posts
      const lastIndex = document.querySelectorAll('#infinite-list li').length;

      {% for post in site.microblog limit: batchSize %}
        const listItem = document.createElement('li');
        listItem.textContent = '{{ post.title }}';
        list.appendChild(listItem);
      {% endfor %}
    }, 500); // Simulación de tiempo de carga
  }

  // Listener para detectar el scroll
  window.addEventListener('scroll', () => {
    const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
    if (scrollTop + clientHeight >= scrollHeight - 5) {
      // Agregar más elementos cuando se alcanza el final de la página
      addItems();
    }
  });

  // Agregar algunos elementos al cargar la página
  addItems();
</script>
