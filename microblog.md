---
title: Microblog
layout: microblog
classes: wide
sidebar:
  nav: "blog"
author_profile: true
---

<div id="list-container">
    <ul id="infinite-list">
        <!-- Las publicaciones se agregarán aquí mediante JavaScript -->
    </ul>
</div>


  <script>
// Variable para rastrear el índice del último post cargado
let lastLoadedIndex = 0;
// Almacena los IDs de los posts ya cargados
let loadedPostIds = [];

// Función para cargar los siguientes 10 posts
function loadNextPosts() {
    const list = document.getElementById('infinite-list');

    // Simulando carga de datos
    setTimeout(() => {
        // Obtener los siguientes 10 posts
        const batchSize = 10;
        let loadedPosts = 0;

        {% assign sorted_posts = site.microblog | sort: 'date' | reverse %}
        {% for post in sorted_posts %}
            // Omitir este post si ya ha sido cargado
            if (!loadedPostIds.includes('{{ post.id }}')) {
                let listItem = document.createElement('li');
                listItem.innerHTML = `
                    <div class="tweet">
                        <div class="author-image">
                            <img src="{{ post.photo }}" alt="Avatar">
                        </div>
                        <div class="tweet-content">
                            <div class="author">{{ post.author }}</div>
                            <div class="title">{{ post.title }}</div>
                            <div class="content">{{ post.content}}</div>
                            <div class="date">{{ post.date | date: "%d-%m-%Y" }}</div>
                        </div>
                    </div>`;
                list.appendChild(listItem);
                loadedPostIds.push('{{ post.id }}');
                loadedPosts++;
                lastLoadedIndex++;
            }
            if (loadedPosts >= batchSize) {
                return; // Salir de la función una vez que se hayan cargado los siguientes 10 posts
            }
        {% endfor %}
    }, 500); // Simulación de tiempo de carga
}

// Listener para detectar el scroll
window.addEventListener('scroll', () => {
    const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
    if (scrollTop + clientHeight >= scrollHeight - 5) {
        // Cargar los siguientes 10 posts cuando se alcance el final de la página
        loadNextPosts();
    }
});

// Cargar los primeros 10 posts al cargar
loadNextPosts();

</script>
