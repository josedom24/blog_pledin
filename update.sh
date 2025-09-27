git commit -am "$1"
git push
ssh -t debian@endor.josedomingo.org "www/blog_pledin/blog.sh $2"
