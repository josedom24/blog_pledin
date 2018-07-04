git commit -am "$1"
git push
ssh -p2222 -A root@playerone.josedomingo.org ./blog.sh
