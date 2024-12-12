# Level 08

Dans ce niveau, on remarque que le binaire nous renvoie : 
```sh
level08@OverRide:~$ ./level08
Usage: ./level08 filename
ERROR: Failed to open ./backups/.log
```

Ce qui nous intéresse le plus dans ce retour est le code d'erreur.

Après plusieurs test, On remarque que le projet nous renvoie une copie du fichier que nous donnons en paramètre.

Donc, en étant malin, on peut faire :
```sh
level08@OverRide:/tmp$ ~/./level08 /home/users/level09/.pass
ERROR: Failed to open ./backups//home/users/level09/.pass
```

Or, il n'arrive toujours pas à trouver le dossier backup. Donc il nous reste plus qu'a le crée.

Vous n'avez plus qu'à récupérer le pass dans le dossier.