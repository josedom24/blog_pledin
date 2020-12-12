git commit -am "$1"
git push
ssh debian@endor.josedomingo.org "www/blog_pledin/blog.sh"
