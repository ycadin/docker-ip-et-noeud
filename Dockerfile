# Consulter éventuellement https://wiki.alpinelinux.org/wiki/Nginx

FROM alpine:3.9

LABEL maintainer="Yannick Cadin <yannick@diablotin.fr>"

RUN apk update && \
    apk upgrade && \
    apk add nginx nginx-mod-http-headers-more nginx-mod-devel-kit nginx-mod-http-perl && \
    rm -r /var/cache/apk/*

WORKDIR /etc/nginx/conf.d

RUN mkdir -p /run/nginx && \
    echo "ssi on;" > ssi.conf && \ 
    echo 'more_set_headers "Server: mon serveur web rien qua moi";' > aquicestleserveur.conf && \
    sed -i 's=return 404=root /var/www/localhost/htdocs/=' default.conf && \
    ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/
COPY index.html /var/www/localhost/htdocs/

#VOLUME ["/var/www/localhost/htdocs"]	# met automatiquement en place un dossier partagé entre l'hôte et le conteneur qui sera TOUT AUSSI automatiquement supprimé quand le conteneur aura disparu (avec docker rm ou l'option --rm de docker run). ET CE SANS AVOIR NULLEMENT BESOIN D'EMPLOYER L'OPTION -v DANS LA COMMANDE docker run ! Il N'est donc PAS persistant !
# Et pour lister le dossier partagé une fois le conteneur démarré :
#    ls -l $(docker inspect --format '{{range .Mounts}}{{ .Source }}{{end}}' $(docker ps -lq))

EXPOSE 80

# ce qui suit sert essentiellement d'auto-documentation, faire docker run -e $(docker info -f '{{.Swarm.NodeID}}') dans le cas d'un cluster Swarm 
ENV ID_NOEUD "identite du noeud"

CMD ["nginx", "-g", "daemon off;"]
