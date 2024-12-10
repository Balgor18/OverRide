# Walkthrough

En décompilant la fonction `main` du binaire, on peut trouver:

```text
0x080484de <+74>:     call   0x80483d0 <__isoc99_scanf@plt>
0x080484e3 <+79>:     mov    eax,DWORD PTR [esp+0x1c]
0x080484e7 <+83>:     cmp    eax,0x149c
0x080484ec <+88>:     jne    0x804850d <main+121>
```

En d'autre termes, le programme lit un entier et le compare à 0x149c (5276 en décimal). Si oui,
alors le programme saute vers une autre partie de la fonction.

On peut ainsi deviner que le mot de passe est **5276**.
