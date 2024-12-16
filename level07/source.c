#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int	store_number(unsigned int	*data)
{
	unsigned int	input = 0;
	unsigned int	index = 0;

	input = atoi(readline("Number: "));
	index = atoi(readline("Index: "));

	if(index % 3 == 0 || (input >> 24) == 183)
	{
		printf(" *** ERROR! ***\n");
		printf("   This index is reserved for wil!\n");
		printf(" *** ERROR! ***\n");
		return 1;
	}

	data[index] = input;

	return 0;
}


int	read_number(unsigned int	*data)
{
	unsigned int	index = 0;

	printf(" Index: ");
	index = atoi(readline(NULL));
	printf(" Number at data[%u] is %u\n", index, data[index]);
	return 0;
}

int	main(int	argc, char	**argv, char	**envp)
{
	int				ret = 1;
	char			str[20];
	unsigned int	arr[100];

	printf(
	"----------------------------------------------------\n"\
	"  Welcome to wil's crappy number storage service!   \n"\
	"----------------------------------------------------\n"\
	" Commands:                                          \n"\
	"    store - store a number into the data storage    \n"\
	"    read  - read a number from the data storage     \n"\
	"    quit  - exit the program                        \n"\
	"----------------------------------------------------\n"\
	"   wil has reserved some storage :>                 \n"\
	"----------------------------------------------------\n"\
	"\n");

	while(1) {
		printf("Input command: ");
		fgets(str, 20, stdin);
		str[strlen(str)-1] = '\0';
		if(!strncmp(str, "store", 5))
			ret = store_number(arr);
		else if(!strncmp(str, "read", 4))
			ret = read_number(arr);
		else if(!strncmp(str, "quit", 4))
			break;
		if(ret)
			printf(" Failed to do %s command\n", str);
		else
			printf(" Completed %s command successfully\n", str);
		memset(str, 0, sizeof(str));
	}
	return 0;
}