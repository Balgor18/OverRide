# Level 06


En lançant le binaire, on peut s'attendre à voir :

```sh
level06@OverRide:~$ ./level06
***********************************
*		level06		  *
***********************************
-> Enter Login:
***********************************
***** NEW ACCOUNT DETECTED ********
***********************************
-> Enter Serial:
```

Après avoir décompilé le binaire sur [Dogbolt](https://dogbolt.org/).

On remarque que notre objectif est d'accéder a `system` dans la fonction `main`.
```c
/* ... */
	tmp = auth();
	if (tmp == 0) {
		puts("Authenticated!");
		system("/bin/sh");
	}
/* ... */
```

Regardons du coup de plus près ce qui se trouve dans la fonction `auth` et surtout qu'elle est la valeur qui est return.
```c
/* ... */
      cmp_value = ((int)user[3] ^ 4919) + 622193;
      for (i = 0; i < (int)sVar1; i = i + 1) {
        if (user[i] < ' ') {
          return 1;
        }
        cmp_value = cmp_value + ((int)user[i] ^ cmp_value) % 1337;
      }
      if (serial_int == cmp_value) {
        uVar2 = 0;
      }
      else {
        uVar2 = 1;
      }
/* ... */
  return uVar2;
/* ... */
```

Donc une fois avoir découvert le calcul et la comparaison. Il nous suffit de reproduire le calcul avec nos valeurs pour résoudre le niveau.

```sh
user=aaaaaa
serial=6231562
```

Après avoir rentré la commande :
```sh
( python -c "print 'aaaaaa\n' + '6231562\n'" ; cat - ) | ./level06
```
Il ne reste plus qu'à récupérer le pass.