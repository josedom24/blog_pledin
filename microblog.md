---
title: Microblog
layout: microblog
classes: wide
sidebar:
  nav: "microblog"
author_profile: true
---

<!-- Contenedor de la lista -->
<div id="list-container">
    <ul id="infinite-list">
        <!-- Las publicaciones se agregarán aquí mediante JavaScript -->
    </ul>
</div>
<!-- Script JavaScript -->

<script>
    // Número de elementos para agregar en cada carga
    const batchSize = 3;
    // Función para agregar elementos a la lista
    function addItems() {
    const list = document.getElementById('infinite-list');

    // Simulando carga de datos
    setTimeout(() => {
        // Obtener el último índice de la lista de posts
        const lastIndex = document.querySelectorAll('#infinite-list li').length;
        {% assign sorted_posts = site.microblog | sort: 'date' | reverse %}
        {% for post in sorted_posts limit: batchSize %}
            const listItem = document.createElement('li');
            listItem.innerHTML = `
                <div class="tweet">
                    <div class="author-image">
                        <img src="{{ post.photo }}" alt="Avatar">
                    </div>
                    <div class="tweet-content">
                        <div class="author">{{ post.author }}</div>
                        <div class="content">{{ post.content }}</div>
                        <div class="date">{{ post.date | date: "%d-%m-%Y" }}</div>
                    </div>
                </div>`;
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
