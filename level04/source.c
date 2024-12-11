#include <signal.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <sys/reg.h>
#include <sys/prctl.h>
#include <wait.h>

int main(void)

{
	char	buf[156];
	int		child;
	int		sys;
	int		status;

	child = fork();
	if (child == 0) {
		prctl(1,1);
		ptrace(PTRACE_TRACEME,0,0,0);
		puts("Give me some shellcode, k");
		gets(buf);
	}
	else {
		while (1) {
			wait(&status);

			if (WIFEXITED(status) || WIFSIGNALED(status)){
				printf("child is exiting...");
				break;
			}
			sys = ptrace(PTRACE_PEEKUSER ,child ,44 ,0 );
		}
	}
	return 0;
}




