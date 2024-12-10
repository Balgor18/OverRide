# Level02

En lancant le binaire, on peut s'attendre à voir :

```sh
===== [ Secure Access System v1.0 ] =====
/***************************************\
| You must login to access this system. |
\**************************************/
--[ Username:
--[ Password:
*****************************************
 does not have access!
```

Ensuite en vérifiant la liste des symboles disponibles, on trouve:

```sh
Non-debugging symbols:
0x0000000000400640  _init
0x0000000000400670  strncmp
0x00000000004006b0  system
0x00000000004006c0  printf
0x00000000004006f0  fgets
0x0000000000400700  fopen
0x0000000000400710  exit
0x0000000000400814  main
```

Dans la premiere partie du code on peut voir :

```sh
	mov    edx,0x400bb0
	mov    eax,0x400bb2  # <-- 0x400bb2 Contient "/home/users/level03/.pass"
	mov    rsi,rdx
	mov    rdi,rax
	call   0x400700 <fopen@plt> # <-- Ouvre le fichier donner en parametre

```

Une fois avoir disass le main, on peut y trouver :

```sh
	mov    edx,0x29               # <-- EDX = 41
	mov    rsi,rcx                # <-- RSI = Le password qui se trouvera dans le fichier "/home/users/level03/.pass"
	mov    rdi,rax                # <-- RDI = L'input du password
	call   0x400670 <strncmp@plt> # <-- Strncmp compare les registre rsi et rdi et prends en lenght edx
	test   eax,eax                # <-- Pour atteindre system il faut que eax = 0
	jne    0x400a96 <main+642>
	mov    eax,0x400d22
...
	call   0x4006c0 <printf@plt>
	mov    edi,0x400d32            # <-- Contient "/bin/sh"
	call   0x4006b0 <system@plt>   # <-- Besoin de passer par cette ligne
...
	call   0x4006c0 <printf@plt>   # <-- Cette appel a printf engendre une erreur
	mov    edi,0x400d3a
	call   0x400680 <puts@plt>

```

Vu que le code fais une comparaison pour pouvoir acceder a l'appel de la function systeme il nous
faut le code qui se trouve dans le fichier `.pass`.

```c
	char username [100];
...
	printf("--[ Username: ");
	fgets(username,100,stdin);
...
	printf(username); // Cette ligne cree une erreur car il n'est pas specifice de type avec le %.
	puts(" does not have access!");
```

Donc nous allons l'utiliser pour trouver le mot de passe du fichier `.pass`.

Le mot de passe est stoqué dans un buffer se trouvant sur la stack. À chaque paramètre
supplémentaire présent dans le `printf`, on recule sur la stack. Cela nous permet de l'afficher.

En affichant un maximum de `%p`, on peut assez rapidement se faire une bonne idée de ce à quoi
ressemble cette stack.

En testant plusieurs possibilités, on trouve assez rapidement les valeurs:

```
0x756e5052343768480x45414a35617339510x377a7143574e67580x354a35686e4758730x48336750664b394d
```

Le reste est principalement des valeurs nulles, ou des pointeurs. Ces valeurs sont petit
boutiste. Il faut donc les convertir. On peut utiliser [ce service](https://www.save-editor.com/tools/wse_hex.html)
pour la convertion.

Cela donne:

```
Hh74RPnuQ9sa5JAEXgNWCqz7sXGnh5J5M9KfPg3H
```

C'est notre flag.
