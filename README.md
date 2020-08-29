# IP et Nœud

Embarque un serveur Web Nginx qui écoute sur le port 80 pour délivrer une courte page contenant un horodatage, l'adresse IP du conteneur et facultativement une donnée personnalisée (par le biais de la variable d'environnement ID_NOEUD).

## Versions et fichiers `Dockerfile` correspondants

-   `1.0`,  `latest`

## Démarrage rapide

Initialiser un cluster Swarm
~~~
docker swarm init
~~~
Lancer 
~~~
docker service create --name ipetnoeud -p 80:80 -e $(docker info -f '{{.Swarm.NodeID}}') --replicas=10 diablotin/ip-et-noeud
~~~
## Variable d'environnement

-   `ID_NOEUD`: chaîne de caractères quelconque `sqlite3`  or  `mysql`  (valeur par défaut :  `identite du noeud`)