#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

unsigned int	log_wrapper(FILE	*logfile, const char	*str, const char	*filename)
{
	char	dest[264];

	strcpy(dest, str);
	snprintf(&dest[strlen(dest)], 254 - strlen(dest), filename);
	dest[strcspn(dest, "\n")] = 0;
	fprintf(logfile, "LOG: %s\n", dest);
	return 0;
}

int	main(int	argc, const char	**argv, const char	**envp)
{
	FILE	*log;
	FILE	*file;
	int		fd;
	char	buffer;
	char	dest[104];

	buffer = -1;
	if ( argc != 2 )
		printf("Usage: %s filename\n", *argv);
	log = fopen("./backups/.log", "w");
	if ( !log )
	{
		printf("ERROR: Failed to open %s\n", "./backups/.log");
		exit(1);
	}
	log_wrapper(log, "Starting back up: ", argv[1]);
	file = fopen(argv[1], "r");
	if ( !file )
	{
		printf("ERROR: Failed to open %s\n", argv[1]);
		exit(1);
	}
	strcpy(dest, "./backups/");
	strncat(dest, argv[1], 99 - strlen(dest));
	fd = open(dest,  O_RDONLY | O_WRONLY | O_EXCL | O_CREAT );
	if ( fd < 0 )
	{
		printf("ERROR: Failed to open %s%s\n", "./backups/", argv[1]);
		exit(1);
	}
	while ( 1 )
	{
		buffer = fgetc(file);
		if ( buffer == -1 )
		break;
		write(fd, &buffer, 1uLL);
	}
	log_wrapper(log, "Finished back up ", argv[1]);
	fclose(file);
	close(fd);

	return 0;
}