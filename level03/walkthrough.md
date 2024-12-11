# Level03

En lancant le binaire, on peut s'attendre à voir :

```sh
level03@OverRide:~$ ./level03
***********************************
*		level03		**
***********************************
Password:

Invalid Password
```

Donc le binaire s'attends a recevoir un mot de passe. Si on le reverse et que l'on regarde les appels dans le main. On peut voir :
```sh
	call   0x8048530 <__isoc99_scanf@plt>      # <-- Recuperation du password.
	mov    eax,DWORD PTR [esp+0x1c]
	mov    DWORD PTR [esp+0x4],0x1337d00d
	mov    DWORD PTR [esp],eax
	call   0x8048747 <test>                    # <-- Envoie du password dans la fonction test.
```


Donc la fonction test, on remarque beaucoup d'appel a la fonction `decrypt`.

```sh
	sub    ecx,eax                   # <-- On peut remaquer une soustraction sur notre parametre d'entré.
...
	call   0x8048660 <decrypt>
...
	call   0x8048660 <decrypt>
...
	call   0x8048660 <decrypt>
...
	call   0x8048660 <decrypt>
...
	call   0x8048660 <decrypt>
...
	call   0x8048660 <decrypt>
```


Maintenant nous allons utiliser une autre méthode en plus de GDB. [DogBolt](https://dogbolt.org/) un decompilateur en ligne : 

```c
int decrypt(EVP_PKEY_CTX *ctx, /* useless enter data */){
...
  local_21[0] = 0x51; // Valeur utilisé plus tard dans le `XOR`
  local_21[1] = 0x7d;
  local_21[2] = 0x7c;
  local_21[3] = 0x75;
  local_21[4] = 0x60;
  local_21[5] = 0x73;
  local_21[6] = 0x66;
  local_21[7] = 0x67;
  local_21[8] = 0x7e;
  local_21[9] = 0x73;
  local_21[10] = 0x66;
  local_21[0xb] = 0x7b;
  local_21[0xc] = 0x7d;
  local_21[0xd] = 0x7c;
  local_21[0xe] = 0x61;
  local_21[0xf] = 0x33;
  local_21[0x10] = 0;
...
  pbVar5 = (byte *)"Congratulations!";
...
  if ((!bVar6 && !bVar7) == bVar6) {
    iVar3 = system("/bin/sh");
  }
  else {
    iVar3 = puts("\nInvalid Password");
  }
}

```

Nous allons maintenant utiliser [Dcode](https://www.dcode.fr/xor-cipher) en utilisant les valeurs '51 7d 7c 75 60 73 66 67 7e 73 66 7b 7d 7c 61 33'. Ce sont les vlauers du tableau local_21. Si on regarde le resultats du site on peut voir que la valeur 12 donne une resultats qui ressemble a "Congratulations!".

|---------|------------|
| Decimal | Hexadecimal|
|    18   |     12     |
|---------|------------|

Donc après avoir trouvée la valeur du deuxieme parametre d'entré de la fonction `test`. Nous avons juste a recupere sa valeur et faire un -18 dessus pour avoir le mot de passe.

Deuxieme parametre d'entré de `test` = 322424845.

322424845 - 18 = 322424827

```sh
level03@OverRide:~$ ./level03
***********************************
*		level03		**
***********************************
Password:322424827
$ whoami
level04
```




