
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <validateint>:
  printf(stdout, "sbrk test OK\n");
}

void
validateint(int *p)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
       3:	5d                   	pop    %ebp
       4:	c3                   	ret    
       5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
       9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000010 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
      10:	69 05 10 59 00 00 0d 	imul   $0x19660d,0x5910,%eax
      17:	66 19 00 
}

unsigned long randstate = 1;
unsigned int
rand()
{
      1a:	55                   	push   %ebp
      1b:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
  return randstate;
}
      1d:	5d                   	pop    %ebp

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
      1e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
      23:	a3 10 59 00 00       	mov    %eax,0x5910
  return randstate;
}
      28:	c3                   	ret    
      29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000030 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
      30:	55                   	push   %ebp
      31:	89 e5                	mov    %esp,%ebp
      33:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
      36:	a1 0c 59 00 00       	mov    0x590c,%eax
      3b:	c7 44 24 04 48 41 00 	movl   $0x4148,0x4(%esp)
      42:	00 
      43:	89 04 24             	mov    %eax,(%esp)
      46:	e8 95 3d 00 00       	call   3de0 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
      4b:	80 3d c0 59 00 00 00 	cmpb   $0x0,0x59c0
      52:	75 36                	jne    8a <bsstest+0x5a>
      54:	b8 01 00 00 00       	mov    $0x1,%eax
      59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      60:	80 b8 c0 59 00 00 00 	cmpb   $0x0,0x59c0(%eax)
      67:	75 21                	jne    8a <bsstest+0x5a>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
      69:	83 c0 01             	add    $0x1,%eax
      6c:	3d 10 27 00 00       	cmp    $0x2710,%eax
      71:	75 ed                	jne    60 <bsstest+0x30>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
      73:	a1 0c 59 00 00       	mov    0x590c,%eax
      78:	c7 44 24 04 63 41 00 	movl   $0x4163,0x4(%esp)
      7f:	00 
      80:	89 04 24             	mov    %eax,(%esp)
      83:	e8 58 3d 00 00       	call   3de0 <printf>
}
      88:	c9                   	leave  
      89:	c3                   	ret    
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      8a:	a1 0c 59 00 00       	mov    0x590c,%eax
      8f:	c7 44 24 04 52 41 00 	movl   $0x4152,0x4(%esp)
      96:	00 
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 41 3d 00 00       	call   3de0 <printf>
      exit();
      9f:	e8 04 3c 00 00       	call   3ca8 <exit>
      a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000b0 <opentest>:

// simple file system tests

void
opentest(void)
{
      b0:	55                   	push   %ebp
      b1:	89 e5                	mov    %esp,%ebp
      b3:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
      b6:	a1 0c 59 00 00       	mov    0x590c,%eax
      bb:	c7 44 24 04 70 41 00 	movl   $0x4170,0x4(%esp)
      c2:	00 
      c3:	89 04 24             	mov    %eax,(%esp)
      c6:	e8 15 3d 00 00       	call   3de0 <printf>
  fd = open("echo", 0);
      cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      d2:	00 
      d3:	c7 04 24 7b 41 00 00 	movl   $0x417b,(%esp)
      da:	e8 09 3c 00 00       	call   3ce8 <open>
  if(fd < 0){
      df:	85 c0                	test   %eax,%eax
      e1:	78 37                	js     11a <opentest+0x6a>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
      e3:	89 04 24             	mov    %eax,(%esp)
      e6:	e8 e5 3b 00 00       	call   3cd0 <close>
  fd = open("doesnotexist", 0);
      eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      f2:	00 
      f3:	c7 04 24 93 41 00 00 	movl   $0x4193,(%esp)
      fa:	e8 e9 3b 00 00       	call   3ce8 <open>
  if(fd >= 0){
      ff:	85 c0                	test   %eax,%eax
     101:	79 31                	jns    134 <opentest+0x84>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
     103:	a1 0c 59 00 00       	mov    0x590c,%eax
     108:	c7 44 24 04 be 41 00 	movl   $0x41be,0x4(%esp)
     10f:	00 
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 c8 3c 00 00       	call   3de0 <printf>
}
     118:	c9                   	leave  
     119:	c3                   	ret    
  int fd;

  printf(stdout, "open test\n");
  fd = open("echo", 0);
  if(fd < 0){
    printf(stdout, "open echo failed!\n");
     11a:	a1 0c 59 00 00       	mov    0x590c,%eax
     11f:	c7 44 24 04 80 41 00 	movl   $0x4180,0x4(%esp)
     126:	00 
     127:	89 04 24             	mov    %eax,(%esp)
     12a:	e8 b1 3c 00 00       	call   3de0 <printf>
    exit();
     12f:	e8 74 3b 00 00       	call   3ca8 <exit>
  }
  close(fd);
  fd = open("doesnotexist", 0);
  if(fd >= 0){
    printf(stdout, "open doesnotexist succeeded!\n");
     134:	a1 0c 59 00 00       	mov    0x590c,%eax
     139:	c7 44 24 04 a0 41 00 	movl   $0x41a0,0x4(%esp)
     140:	00 
     141:	89 04 24             	mov    %eax,(%esp)
     144:	e8 97 3c 00 00       	call   3de0 <printf>
    exit();
     149:	e8 5a 3b 00 00       	call   3ca8 <exit>
     14e:	66 90                	xchg   %ax,%ax

00000150 <argptest>:
  wait();
  printf(1, "uio test done\n");
}

void argptest()
{
     150:	55                   	push   %ebp
     151:	89 e5                	mov    %esp,%ebp
     153:	53                   	push   %ebx
     154:	83 ec 14             	sub    $0x14,%esp
  int fd;
  fd = open("init", O_RDONLY);
     157:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     15e:	00 
     15f:	c7 04 24 cc 41 00 00 	movl   $0x41cc,(%esp)
     166:	e8 7d 3b 00 00       	call   3ce8 <open>
  if (fd < 0) {
     16b:	85 c0                	test   %eax,%eax
}

void argptest()
{
  int fd;
  fd = open("init", O_RDONLY);
     16d:	89 c3                	mov    %eax,%ebx
  if (fd < 0) {
     16f:	78 45                	js     1b6 <argptest+0x66>
    printf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
     171:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     178:	e8 b3 3b 00 00       	call   3d30 <sbrk>
     17d:	89 1c 24             	mov    %ebx,(%esp)
     180:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
     187:	ff 
     188:	83 e8 01             	sub    $0x1,%eax
     18b:	89 44 24 04          	mov    %eax,0x4(%esp)
     18f:	e8 2c 3b 00 00       	call   3cc0 <read>
  close(fd);
     194:	89 1c 24             	mov    %ebx,(%esp)
     197:	e8 34 3b 00 00       	call   3cd0 <close>
  printf(1, "arg test passed\n");
     19c:	c7 44 24 04 de 41 00 	movl   $0x41de,0x4(%esp)
     1a3:	00 
     1a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1ab:	e8 30 3c 00 00       	call   3de0 <printf>
}
     1b0:	83 c4 14             	add    $0x14,%esp
     1b3:	5b                   	pop    %ebx
     1b4:	5d                   	pop    %ebp
     1b5:	c3                   	ret    
void argptest()
{
  int fd;
  fd = open("init", O_RDONLY);
  if (fd < 0) {
    printf(2, "open failed\n");
     1b6:	c7 44 24 04 d1 41 00 	movl   $0x41d1,0x4(%esp)
     1bd:	00 
     1be:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     1c5:	e8 16 3c 00 00       	call   3de0 <printf>
    exit();
     1ca:	e8 d9 3a 00 00       	call   3ca8 <exit>
     1cf:	90                   	nop

000001d0 <uio>:
  printf(1, "fsfull test finished\n");
}

void
uio()
{
     1d0:	55                   	push   %ebp
     1d1:	89 e5                	mov    %esp,%ebp
     1d3:	83 ec 18             	sub    $0x18,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
     1d6:	c7 44 24 04 ef 41 00 	movl   $0x41ef,0x4(%esp)
     1dd:	00 
     1de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1e5:	e8 f6 3b 00 00       	call   3de0 <printf>
  pid = fork();
     1ea:	e8 b1 3a 00 00       	call   3ca0 <fork>
  if(pid == 0){
     1ef:	83 f8 00             	cmp    $0x0,%eax
     1f2:	74 1d                	je     211 <uio+0x41>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit();
  } else if(pid < 0){
     1f4:	7c 42                	jl     238 <uio+0x68>
    printf (1, "fork failed\n");
    exit();
  }
  wait();
     1f6:	e8 b5 3a 00 00       	call   3cb0 <wait>
  printf(1, "uio test done\n");
     1fb:	c7 44 24 04 f9 41 00 	movl   $0x41f9,0x4(%esp)
     202:	00 
     203:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     20a:	e8 d1 3b 00 00       	call   3de0 <printf>
}
     20f:	c9                   	leave  
     210:	c3                   	ret    
  pid = fork();
  if(pid == 0){
    port = RTC_ADDR;
    val = 0x09;  /* year */
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
     211:	ba 70 00 00 00       	mov    $0x70,%edx
     216:	b8 09 00 00 00       	mov    $0x9,%eax
     21b:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
     21c:	b2 71                	mov    $0x71,%dl
     21e:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
     21f:	c7 44 24 04 6c 51 00 	movl   $0x516c,0x4(%esp)
     226:	00 
     227:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     22e:	e8 ad 3b 00 00       	call   3de0 <printf>
    exit();
     233:	e8 70 3a 00 00       	call   3ca8 <exit>
  } else if(pid < 0){
    printf (1, "fork failed\n");
     238:	c7 44 24 04 bf 45 00 	movl   $0x45bf,0x4(%esp)
     23f:	00 
     240:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     247:	e8 94 3b 00 00       	call   3de0 <printf>
    exit();
     24c:	e8 57 3a 00 00       	call   3ca8 <exit>
     251:	eb 0d                	jmp    260 <forktest>
     253:	90                   	nop
     254:	90                   	nop
     255:	90                   	nop
     256:	90                   	nop
     257:	90                   	nop
     258:	90                   	nop
     259:	90                   	nop
     25a:	90                   	nop
     25b:	90                   	nop
     25c:	90                   	nop
     25d:	90                   	nop
     25e:	90                   	nop
     25f:	90                   	nop

00000260 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
     260:	55                   	push   %ebp
     261:	89 e5                	mov    %esp,%ebp
     263:	53                   	push   %ebx
  int n, pid;

  printf(1, "fork test\n");
     264:	31 db                	xor    %ebx,%ebx
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
     266:	83 ec 14             	sub    $0x14,%esp
  int n, pid;

  printf(1, "fork test\n");
     269:	c7 44 24 04 08 42 00 	movl   $0x4208,0x4(%esp)
     270:	00 
     271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     278:	e8 63 3b 00 00       	call   3de0 <printf>
     27d:	eb 0e                	jmp    28d <forktest+0x2d>
     27f:	90                   	nop

  for(n=0; n<1000; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
     280:	74 6a                	je     2ec <forktest+0x8c>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
     282:	83 c3 01             	add    $0x1,%ebx
     285:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
     28b:	74 4b                	je     2d8 <forktest+0x78>
    pid = fork();
     28d:	e8 0e 3a 00 00       	call   3ca0 <fork>
    if(pid < 0)
     292:	83 f8 00             	cmp    $0x0,%eax
     295:	7d e9                	jge    280 <forktest+0x20>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }

  for(; n > 0; n--){
     297:	85 db                	test   %ebx,%ebx
     299:	74 13                	je     2ae <forktest+0x4e>
     29b:	90                   	nop
     29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(wait() < 0){
     2a0:	e8 0b 3a 00 00       	call   3cb0 <wait>
     2a5:	85 c0                	test   %eax,%eax
     2a7:	78 48                	js     2f1 <forktest+0x91>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }

  for(; n > 0; n--){
     2a9:	83 eb 01             	sub    $0x1,%ebx
     2ac:	75 f2                	jne    2a0 <forktest+0x40>
     2ae:	66 90                	xchg   %ax,%ax
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
     2b0:	e8 fb 39 00 00       	call   3cb0 <wait>
     2b5:	83 f8 ff             	cmp    $0xffffffff,%eax
     2b8:	75 50                	jne    30a <forktest+0xaa>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
     2ba:	c7 44 24 04 3a 42 00 	movl   $0x423a,0x4(%esp)
     2c1:	00 
     2c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c9:	e8 12 3b 00 00       	call   3de0 <printf>
}
     2ce:	83 c4 14             	add    $0x14,%esp
     2d1:	5b                   	pop    %ebx
     2d2:	5d                   	pop    %ebp
     2d3:	c3                   	ret    
     2d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid == 0)
      exit();
  }

  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
     2d8:	c7 44 24 04 90 51 00 	movl   $0x5190,0x4(%esp)
     2df:	00 
     2e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2e7:	e8 f4 3a 00 00       	call   3de0 <printf>
    exit();
     2ec:	e8 b7 39 00 00       	call   3ca8 <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
     2f1:	c7 44 24 04 13 42 00 	movl   $0x4213,0x4(%esp)
     2f8:	00 
     2f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     300:	e8 db 3a 00 00       	call   3de0 <printf>
      exit();
     305:	e8 9e 39 00 00       	call   3ca8 <exit>
    }
  }

  if(wait() != -1){
    printf(1, "wait got too many\n");
     30a:	c7 44 24 04 27 42 00 	movl   $0x4227,0x4(%esp)
     311:	00 
     312:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     319:	e8 c2 3a 00 00       	call   3de0 <printf>
    exit();
     31e:	e8 85 39 00 00       	call   3ca8 <exit>
     323:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000330 <exitwait>:
}

// try to find any races between exit and wait
void
exitwait(void)
{
     330:	55                   	push   %ebp
     331:	89 e5                	mov    %esp,%ebp
     333:	56                   	push   %esi
     334:	31 f6                	xor    %esi,%esi
     336:	53                   	push   %ebx
     337:	83 ec 10             	sub    $0x10,%esp
     33a:	eb 17                	jmp    353 <exitwait+0x23>
     33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     340:	74 79                	je     3bb <exitwait+0x8b>
      if(wait() != pid){
     342:	e8 69 39 00 00       	call   3cb0 <wait>
     347:	39 c3                	cmp    %eax,%ebx
     349:	75 35                	jne    380 <exitwait+0x50>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     34b:	83 c6 01             	add    $0x1,%esi
     34e:	83 fe 64             	cmp    $0x64,%esi
     351:	74 4d                	je     3a0 <exitwait+0x70>
    pid = fork();
     353:	e8 48 39 00 00       	call   3ca0 <fork>
    if(pid < 0){
     358:	83 f8 00             	cmp    $0x0,%eax
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     35b:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     35d:	7d e1                	jge    340 <exitwait+0x10>
      printf(1, "fork failed\n");
     35f:	c7 44 24 04 bf 45 00 	movl   $0x45bf,0x4(%esp)
     366:	00 
     367:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     36e:	e8 6d 3a 00 00       	call   3de0 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     373:	83 c4 10             	add    $0x10,%esp
     376:	5b                   	pop    %ebx
     377:	5e                   	pop    %esi
     378:	5d                   	pop    %ebp
     379:	c3                   	ret    
     37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
     380:	c7 44 24 04 48 42 00 	movl   $0x4248,0x4(%esp)
     387:	00 
     388:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     38f:	e8 4c 3a 00 00       	call   3de0 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     394:	83 c4 10             	add    $0x10,%esp
     397:	5b                   	pop    %ebx
     398:	5e                   	pop    %esi
     399:	5d                   	pop    %ebp
     39a:	c3                   	ret    
     39b:	90                   	nop
     39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     3a0:	c7 44 24 04 58 42 00 	movl   $0x4258,0x4(%esp)
     3a7:	00 
     3a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3af:	e8 2c 3a 00 00       	call   3de0 <printf>
}
     3b4:	83 c4 10             	add    $0x10,%esp
     3b7:	5b                   	pop    %ebx
     3b8:	5e                   	pop    %esi
     3b9:	5d                   	pop    %ebp
     3ba:	c3                   	ret    
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
        return;
      }
    } else {
      exit();
     3bb:	e8 e8 38 00 00       	call   3ca8 <exit>

000003c0 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
     3c0:	55                   	push   %ebp
     3c1:	89 e5                	mov    %esp,%ebp
     3c3:	57                   	push   %edi
     3c4:	56                   	push   %esi
     3c5:	53                   	push   %ebx
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
     3c6:	31 db                	xor    %ebx,%ebx

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
     3c8:	83 ec 5c             	sub    $0x5c,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
     3cb:	c7 44 24 04 65 42 00 	movl   $0x4265,0x4(%esp)
     3d2:	00 
     3d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3da:	e8 01 3a 00 00       	call   3de0 <printf>
     3df:	90                   	nop

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     3e0:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
     3e5:	89 d9                	mov    %ebx,%ecx
     3e7:	f7 eb                	imul   %ebx
     3e9:	c1 f9 1f             	sar    $0x1f,%ecx

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
     3ec:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
     3f0:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     3f4:	c1 fa 06             	sar    $0x6,%edx
     3f7:	29 ca                	sub    %ecx,%edx
    name[2] = '0' + (nfiles % 1000) / 100;
     3f9:	69 f2 e8 03 00 00    	imul   $0x3e8,%edx,%esi
  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     3ff:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
     402:	89 da                	mov    %ebx,%edx
  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     404:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
     407:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
     40c:	c7 44 24 04 72 42 00 	movl   $0x4272,0x4(%esp)
     413:	00 

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     414:	29 f2                	sub    %esi,%edx
     416:	89 d6                	mov    %edx,%esi
     418:	f7 ea                	imul   %edx
    name[3] = '0' + (nfiles % 100) / 10;
     41a:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     41f:	c1 fe 1f             	sar    $0x1f,%esi
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
     422:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     429:	c1 fa 05             	sar    $0x5,%edx
     42c:	29 f2                	sub    %esi,%edx
    name[3] = '0' + (nfiles % 100) / 10;
     42e:	be 67 66 66 66       	mov    $0x66666667,%esi

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     433:	83 c2 30             	add    $0x30,%edx
     436:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
     439:	f7 eb                	imul   %ebx
     43b:	c1 fa 05             	sar    $0x5,%edx
     43e:	29 ca                	sub    %ecx,%edx
     440:	6b fa 64             	imul   $0x64,%edx,%edi
     443:	89 da                	mov    %ebx,%edx
     445:	29 fa                	sub    %edi,%edx
     447:	89 d0                	mov    %edx,%eax
     449:	89 d7                	mov    %edx,%edi
     44b:	f7 ee                	imul   %esi
    name[4] = '0' + (nfiles % 10);
     44d:	89 d8                	mov    %ebx,%eax
  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
     44f:	c1 ff 1f             	sar    $0x1f,%edi
     452:	c1 fa 02             	sar    $0x2,%edx
     455:	29 fa                	sub    %edi,%edx
     457:	83 c2 30             	add    $0x30,%edx
     45a:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
     45d:	f7 ee                	imul   %esi
     45f:	c1 fa 02             	sar    $0x2,%edx
     462:	29 ca                	sub    %ecx,%edx
     464:	8d 04 92             	lea    (%edx,%edx,4),%eax
     467:	89 da                	mov    %ebx,%edx
     469:	01 c0                	add    %eax,%eax
     46b:	29 c2                	sub    %eax,%edx
     46d:	89 d0                	mov    %edx,%eax
     46f:	83 c0 30             	add    $0x30,%eax
     472:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    printf(1, "writing %s\n", name);
     475:	8d 45 a8             	lea    -0x58(%ebp),%eax
     478:	89 44 24 08          	mov    %eax,0x8(%esp)
     47c:	e8 5f 39 00 00       	call   3de0 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
     481:	8d 55 a8             	lea    -0x58(%ebp),%edx
     484:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     48b:	00 
     48c:	89 14 24             	mov    %edx,(%esp)
     48f:	e8 54 38 00 00       	call   3ce8 <open>
    if(fd < 0){
     494:	85 c0                	test   %eax,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
    int fd = open(name, O_CREATE|O_RDWR);
     496:	89 c7                	mov    %eax,%edi
    if(fd < 0){
     498:	78 53                	js     4ed <fsfull+0x12d>
      printf(1, "open %s failed\n", name);
      break;
     49a:	31 f6                	xor    %esi,%esi
     49c:	eb 04                	jmp    4a2 <fsfull+0xe2>
     49e:	66 90                	xchg   %ax,%ax
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
     4a0:	01 c6                	add    %eax,%esi
      printf(1, "open %s failed\n", name);
      break;
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
     4a2:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     4a9:	00 
     4aa:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
     4b1:	00 
     4b2:	89 3c 24             	mov    %edi,(%esp)
     4b5:	e8 0e 38 00 00       	call   3cc8 <write>
      if(cc < 512)
     4ba:	3d ff 01 00 00       	cmp    $0x1ff,%eax
     4bf:	7f df                	jg     4a0 <fsfull+0xe0>
        break;
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
     4c1:	89 74 24 08          	mov    %esi,0x8(%esp)
     4c5:	c7 44 24 04 8e 42 00 	movl   $0x428e,0x4(%esp)
     4cc:	00 
     4cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4d4:	e8 07 39 00 00       	call   3de0 <printf>
    close(fd);
     4d9:	89 3c 24             	mov    %edi,(%esp)
     4dc:	e8 ef 37 00 00       	call   3cd0 <close>
    if(total == 0)
     4e1:	85 f6                	test   %esi,%esi
     4e3:	74 23                	je     508 <fsfull+0x148>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
     4e5:	83 c3 01             	add    $0x1,%ebx
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
     4e8:	e9 f3 fe ff ff       	jmp    3e0 <fsfull+0x20>
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf(1, "open %s failed\n", name);
     4ed:	8d 45 a8             	lea    -0x58(%ebp),%eax
     4f0:	89 44 24 08          	mov    %eax,0x8(%esp)
     4f4:	c7 44 24 04 7e 42 00 	movl   $0x427e,0x4(%esp)
     4fb:	00 
     4fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     503:	e8 d8 38 00 00       	call   3de0 <printf>
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     508:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
     50d:	89 d9                	mov    %ebx,%ecx
     50f:	f7 eb                	imul   %ebx
     511:	c1 f9 1f             	sar    $0x1f,%ecx
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
     514:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
     518:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     51c:	c1 fa 06             	sar    $0x6,%edx
     51f:	29 ca                	sub    %ecx,%edx
    name[2] = '0' + (nfiles % 1000) / 100;
     521:	69 f2 e8 03 00 00    	imul   $0x3e8,%edx,%esi
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     527:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
     52a:	89 da                	mov    %ebx,%edx
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     52c:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
     52f:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
     534:	29 f2                	sub    %esi,%edx
     536:	89 d6                	mov    %edx,%esi
     538:	f7 ea                	imul   %edx
    name[3] = '0' + (nfiles % 100) / 10;
     53a:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     53f:	c1 fe 1f             	sar    $0x1f,%esi
     542:	c1 fa 05             	sar    $0x5,%edx
     545:	29 f2                	sub    %esi,%edx
    name[3] = '0' + (nfiles % 100) / 10;
     547:	be 67 66 66 66       	mov    $0x66666667,%esi

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     54c:	83 c2 30             	add    $0x30,%edx
     54f:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
     552:	f7 eb                	imul   %ebx
     554:	c1 fa 05             	sar    $0x5,%edx
     557:	29 ca                	sub    %ecx,%edx
     559:	6b fa 64             	imul   $0x64,%edx,%edi
     55c:	89 da                	mov    %ebx,%edx
     55e:	29 fa                	sub    %edi,%edx
     560:	89 d0                	mov    %edx,%eax
     562:	89 d7                	mov    %edx,%edi
     564:	f7 ee                	imul   %esi
    name[4] = '0' + (nfiles % 10);
     566:	89 d8                	mov    %ebx,%eax
  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
     568:	c1 ff 1f             	sar    $0x1f,%edi
     56b:	c1 fa 02             	sar    $0x2,%edx
     56e:	29 fa                	sub    %edi,%edx
     570:	83 c2 30             	add    $0x30,%edx
     573:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
     576:	f7 ee                	imul   %esi
     578:	c1 fa 02             	sar    $0x2,%edx
     57b:	29 ca                	sub    %ecx,%edx
     57d:	8d 04 92             	lea    (%edx,%edx,4),%eax
     580:	89 da                	mov    %ebx,%edx
     582:	01 c0                	add    %eax,%eax
    name[5] = '\0';
    unlink(name);
    nfiles--;
     584:	83 eb 01             	sub    $0x1,%ebx
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
     587:	29 c2                	sub    %eax,%edx
     589:	89 d0                	mov    %edx,%eax
     58b:	83 c0 30             	add    $0x30,%eax
     58e:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    unlink(name);
     591:	8d 45 a8             	lea    -0x58(%ebp),%eax
     594:	89 04 24             	mov    %eax,(%esp)
     597:	e8 5c 37 00 00       	call   3cf8 <unlink>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
     59c:	83 fb ff             	cmp    $0xffffffff,%ebx
     59f:	0f 85 63 ff ff ff    	jne    508 <fsfull+0x148>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
     5a5:	c7 44 24 04 9e 42 00 	movl   $0x429e,0x4(%esp)
     5ac:	00 
     5ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5b4:	e8 27 38 00 00       	call   3de0 <printf>
}
     5b9:	83 c4 5c             	add    $0x5c,%esp
     5bc:	5b                   	pop    %ebx
     5bd:	5e                   	pop    %esi
     5be:	5f                   	pop    %edi
     5bf:	5d                   	pop    %ebp
     5c0:	c3                   	ret    
     5c1:	eb 0d                	jmp    5d0 <bigwrite>
     5c3:	90                   	nop
     5c4:	90                   	nop
     5c5:	90                   	nop
     5c6:	90                   	nop
     5c7:	90                   	nop
     5c8:	90                   	nop
     5c9:	90                   	nop
     5ca:	90                   	nop
     5cb:	90                   	nop
     5cc:	90                   	nop
     5cd:	90                   	nop
     5ce:	90                   	nop
     5cf:	90                   	nop

000005d0 <bigwrite>:
}

// test writes that are larger than the log.
void
bigwrite(void)
{
     5d0:	55                   	push   %ebp
     5d1:	89 e5                	mov    %esp,%ebp
     5d3:	56                   	push   %esi
     5d4:	53                   	push   %ebx
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
     5d5:	bb f3 01 00 00       	mov    $0x1f3,%ebx
}

// test writes that are larger than the log.
void
bigwrite(void)
{
     5da:	83 ec 10             	sub    $0x10,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
     5dd:	c7 44 24 04 b4 42 00 	movl   $0x42b4,0x4(%esp)
     5e4:	00 
     5e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5ec:	e8 ef 37 00 00       	call   3de0 <printf>

  unlink("bigwrite");
     5f1:	c7 04 24 c3 42 00 00 	movl   $0x42c3,(%esp)
     5f8:	e8 fb 36 00 00       	call   3cf8 <unlink>
     5fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(sz = 499; sz < 12*512; sz += 471){
    fd = open("bigwrite", O_CREATE | O_RDWR);
     600:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     607:	00 
     608:	c7 04 24 c3 42 00 00 	movl   $0x42c3,(%esp)
     60f:	e8 d4 36 00 00       	call   3ce8 <open>
    if(fd < 0){
     614:	85 c0                	test   %eax,%eax

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    fd = open("bigwrite", O_CREATE | O_RDWR);
     616:	89 c6                	mov    %eax,%esi
    if(fd < 0){
     618:	0f 88 8e 00 00 00    	js     6ac <bigwrite+0xdc>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
     61e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     622:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
     629:	00 
     62a:	89 04 24             	mov    %eax,(%esp)
     62d:	e8 96 36 00 00       	call   3cc8 <write>
      if(cc != sz){
     632:	39 c3                	cmp    %eax,%ebx
     634:	75 55                	jne    68b <bigwrite+0xbb>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
     636:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     63a:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
     641:	00 
     642:	89 34 24             	mov    %esi,(%esp)
     645:	e8 7e 36 00 00       	call   3cc8 <write>
      if(cc != sz){
     64a:	39 d8                	cmp    %ebx,%eax
     64c:	75 3d                	jne    68b <bigwrite+0xbb>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
     64e:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
     654:	89 34 24             	mov    %esi,(%esp)
     657:	e8 74 36 00 00       	call   3cd0 <close>
    unlink("bigwrite");
     65c:	c7 04 24 c3 42 00 00 	movl   $0x42c3,(%esp)
     663:	e8 90 36 00 00       	call   3cf8 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
     668:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
     66e:	75 90                	jne    600 <bigwrite+0x30>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
     670:	c7 44 24 04 f6 42 00 	movl   $0x42f6,0x4(%esp)
     677:	00 
     678:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     67f:	e8 5c 37 00 00       	call   3de0 <printf>
}
     684:	83 c4 10             	add    $0x10,%esp
     687:	5b                   	pop    %ebx
     688:	5e                   	pop    %esi
     689:	5d                   	pop    %ebp
     68a:	c3                   	ret    
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
     68b:	89 44 24 0c          	mov    %eax,0xc(%esp)
     68f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     693:	c7 44 24 04 e4 42 00 	movl   $0x42e4,0x4(%esp)
     69a:	00 
     69b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6a2:	e8 39 37 00 00       	call   3de0 <printf>
        exit();
     6a7:	e8 fc 35 00 00       	call   3ca8 <exit>

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    fd = open("bigwrite", O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
     6ac:	c7 44 24 04 cc 42 00 	movl   $0x42cc,0x4(%esp)
     6b3:	00 
     6b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6bb:	e8 20 37 00 00       	call   3de0 <printf>
      exit();
     6c0:	e8 e3 35 00 00       	call   3ca8 <exit>
     6c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     6c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006d0 <unlinkread>:
}

// can I unlink a file and still read it?
void
unlinkread(void)
{
     6d0:	55                   	push   %ebp
     6d1:	89 e5                	mov    %esp,%ebp
     6d3:	56                   	push   %esi
     6d4:	53                   	push   %ebx
     6d5:	83 ec 10             	sub    $0x10,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
     6d8:	c7 44 24 04 03 43 00 	movl   $0x4303,0x4(%esp)
     6df:	00 
     6e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6e7:	e8 f4 36 00 00       	call   3de0 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
     6ec:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     6f3:	00 
     6f4:	c7 04 24 14 43 00 00 	movl   $0x4314,(%esp)
     6fb:	e8 e8 35 00 00       	call   3ce8 <open>
  if(fd < 0){
     700:	85 c0                	test   %eax,%eax
unlinkread(void)
{
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
     702:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     704:	0f 88 fe 00 00 00    	js     808 <unlinkread+0x138>
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
     70a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
     711:	00 
     712:	c7 44 24 04 39 43 00 	movl   $0x4339,0x4(%esp)
     719:	00 
     71a:	89 04 24             	mov    %eax,(%esp)
     71d:	e8 a6 35 00 00       	call   3cc8 <write>
  close(fd);
     722:	89 1c 24             	mov    %ebx,(%esp)
     725:	e8 a6 35 00 00       	call   3cd0 <close>

  fd = open("unlinkread", O_RDWR);
     72a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     731:	00 
     732:	c7 04 24 14 43 00 00 	movl   $0x4314,(%esp)
     739:	e8 aa 35 00 00       	call   3ce8 <open>
  if(fd < 0){
     73e:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
     740:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     742:	0f 88 3d 01 00 00    	js     885 <unlinkread+0x1b5>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
     748:	c7 04 24 14 43 00 00 	movl   $0x4314,(%esp)
     74f:	e8 a4 35 00 00       	call   3cf8 <unlink>
     754:	85 c0                	test   %eax,%eax
     756:	0f 85 10 01 00 00    	jne    86c <unlinkread+0x19c>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     75c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     763:	00 
     764:	c7 04 24 14 43 00 00 	movl   $0x4314,(%esp)
     76b:	e8 78 35 00 00       	call   3ce8 <open>
  write(fd1, "yyy", 3);
     770:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
     777:	00 
     778:	c7 44 24 04 71 43 00 	movl   $0x4371,0x4(%esp)
     77f:	00 
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     780:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
     782:	89 04 24             	mov    %eax,(%esp)
     785:	e8 3e 35 00 00       	call   3cc8 <write>
  close(fd1);
     78a:	89 34 24             	mov    %esi,(%esp)
     78d:	e8 3e 35 00 00       	call   3cd0 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
     792:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     799:	00 
     79a:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
     7a1:	00 
     7a2:	89 1c 24             	mov    %ebx,(%esp)
     7a5:	e8 16 35 00 00       	call   3cc0 <read>
     7aa:	83 f8 05             	cmp    $0x5,%eax
     7ad:	0f 85 a0 00 00 00    	jne    853 <unlinkread+0x183>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
     7b3:	80 3d e0 80 00 00 68 	cmpb   $0x68,0x80e0
     7ba:	75 7e                	jne    83a <unlinkread+0x16a>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
     7bc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     7c3:	00 
     7c4:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
     7cb:	00 
     7cc:	89 1c 24             	mov    %ebx,(%esp)
     7cf:	e8 f4 34 00 00       	call   3cc8 <write>
     7d4:	83 f8 0a             	cmp    $0xa,%eax
     7d7:	75 48                	jne    821 <unlinkread+0x151>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
     7d9:	89 1c 24             	mov    %ebx,(%esp)
     7dc:	e8 ef 34 00 00       	call   3cd0 <close>
  unlink("unlinkread");
     7e1:	c7 04 24 14 43 00 00 	movl   $0x4314,(%esp)
     7e8:	e8 0b 35 00 00       	call   3cf8 <unlink>
  printf(1, "unlinkread ok\n");
     7ed:	c7 44 24 04 bc 43 00 	movl   $0x43bc,0x4(%esp)
     7f4:	00 
     7f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7fc:	e8 df 35 00 00       	call   3de0 <printf>
}
     801:	83 c4 10             	add    $0x10,%esp
     804:	5b                   	pop    %ebx
     805:	5e                   	pop    %esi
     806:	5d                   	pop    %ebp
     807:	c3                   	ret    
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create unlinkread failed\n");
     808:	c7 44 24 04 1f 43 00 	movl   $0x431f,0x4(%esp)
     80f:	00 
     810:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     817:	e8 c4 35 00 00       	call   3de0 <printf>
    exit();
     81c:	e8 87 34 00 00       	call   3ca8 <exit>
  if(buf[0] != 'h'){
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    printf(1, "unlinkread write failed\n");
     821:	c7 44 24 04 a3 43 00 	movl   $0x43a3,0x4(%esp)
     828:	00 
     829:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     830:	e8 ab 35 00 00       	call   3de0 <printf>
    exit();
     835:	e8 6e 34 00 00       	call   3ca8 <exit>
  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    printf(1, "unlinkread wrong data\n");
     83a:	c7 44 24 04 8c 43 00 	movl   $0x438c,0x4(%esp)
     841:	00 
     842:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     849:	e8 92 35 00 00       	call   3de0 <printf>
    exit();
     84e:	e8 55 34 00 00       	call   3ca8 <exit>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
  write(fd1, "yyy", 3);
  close(fd1);

  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "unlinkread read failed");
     853:	c7 44 24 04 75 43 00 	movl   $0x4375,0x4(%esp)
     85a:	00 
     85b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     862:	e8 79 35 00 00       	call   3de0 <printf>
    exit();
     867:	e8 3c 34 00 00       	call   3ca8 <exit>
  if(fd < 0){
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
     86c:	c7 44 24 04 57 43 00 	movl   $0x4357,0x4(%esp)
     873:	00 
     874:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     87b:	e8 60 35 00 00       	call   3de0 <printf>
    exit();
     880:	e8 23 34 00 00       	call   3ca8 <exit>
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
  if(fd < 0){
    printf(1, "open unlinkread failed\n");
     885:	c7 44 24 04 3f 43 00 	movl   $0x433f,0x4(%esp)
     88c:	00 
     88d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     894:	e8 47 35 00 00       	call   3de0 <printf>
    exit();
     899:	e8 0a 34 00 00       	call   3ca8 <exit>
     89e:	66 90                	xchg   %ax,%ax

000008a0 <createdelete>:
}

// four processes create and delete different files in same directory
void
createdelete(void)
{
     8a0:	55                   	push   %ebp
     8a1:	89 e5                	mov    %esp,%ebp
     8a3:	57                   	push   %edi
     8a4:	56                   	push   %esi
     8a5:	53                   	push   %ebx
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
     8a6:	31 db                	xor    %ebx,%ebx
}

// four processes create and delete different files in same directory
void
createdelete(void)
{
     8a8:	83 ec 4c             	sub    $0x4c,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
     8ab:	c7 44 24 04 cb 43 00 	movl   $0x43cb,0x4(%esp)
     8b2:	00 
     8b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8ba:	e8 21 35 00 00       	call   3de0 <printf>

  for(pi = 0; pi < 4; pi++){
    pid = fork();
     8bf:	e8 dc 33 00 00       	call   3ca0 <fork>
    if(pid < 0){
     8c4:	83 f8 00             	cmp    $0x0,%eax
     8c7:	0f 8c c7 01 00 00    	jl     a94 <createdelete+0x1f4>
     8cd:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
     8d0:	0f 84 e9 00 00 00    	je     9bf <createdelete+0x11f>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
     8d6:	83 c3 01             	add    $0x1,%ebx
     8d9:	83 fb 04             	cmp    $0x4,%ebx
     8dc:	75 e1                	jne    8bf <createdelete+0x1f>
     8de:	8d 75 c8             	lea    -0x38(%ebp),%esi

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
     8e1:	31 ff                	xor    %edi,%edi
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
     8e3:	e8 c8 33 00 00       	call   3cb0 <wait>
     8e8:	e8 c3 33 00 00       	call   3cb0 <wait>
     8ed:	e8 be 33 00 00       	call   3cb0 <wait>
     8f2:	e8 b9 33 00 00       	call   3cb0 <wait>
  }

  name[0] = name[1] = name[2] = 0;
     8f7:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
     8fb:	89 75 c0             	mov    %esi,-0x40(%ebp)
     8fe:	66 90                	xchg   %ax,%ax
  for(i = 0; i < N; i++){
     900:	8d 47 30             	lea    0x30(%edi),%eax
     903:	85 ff                	test   %edi,%edi
     905:	88 45 c4             	mov    %al,-0x3c(%ebp)
     908:	0f 94 c0             	sete   %al
     90b:	83 ff 09             	cmp    $0x9,%edi
     90e:	0f 9f c2             	setg   %dl
     911:	bb 70 00 00 00       	mov    $0x70,%ebx
     916:	89 d6                	mov    %edx,%esi
     918:	09 c6                	or     %eax,%esi
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
     91a:	8d 47 ff             	lea    -0x1(%edi),%eax
     91d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
     920:	8b 55 c0             	mov    -0x40(%ebp),%edx

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
     923:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
     927:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
      fd = open(name, 0);
     92a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     931:	00 
     932:	89 14 24             	mov    %edx,(%esp)

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
     935:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
     938:	e8 ab 33 00 00       	call   3ce8 <open>
      if((i == 0 || i >= N/2) && fd < 0){
     93d:	89 f2                	mov    %esi,%edx
     93f:	84 d2                	test   %dl,%dl
     941:	74 08                	je     94b <createdelete+0xab>
     943:	85 c0                	test   %eax,%eax
     945:	0f 88 f6 00 00 00    	js     a41 <createdelete+0x1a1>
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
     94b:	85 c0                	test   %eax,%eax
     94d:	8d 76 00             	lea    0x0(%esi),%esi
     950:	0f 89 0b 01 00 00    	jns    a61 <createdelete+0x1c1>
        printf(1, "oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
        close(fd);
     956:	83 c3 01             	add    $0x1,%ebx
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
     959:	80 fb 74             	cmp    $0x74,%bl
     95c:	75 c2                	jne    920 <createdelete+0x80>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
     95e:	83 c7 01             	add    $0x1,%edi
     961:	83 ff 14             	cmp    $0x14,%edi
     964:	75 9a                	jne    900 <createdelete+0x60>
     966:	8b 75 c0             	mov    -0x40(%ebp),%esi
     969:	bf 70 00 00 00       	mov    $0x70,%edi
     96e:	89 75 c4             	mov    %esi,-0x3c(%ebp)
     971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
     978:	8d 77 c0             	lea    -0x40(%edi),%esi
     97b:	31 db                	xor    %ebx,%ebx
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
     97d:	89 fa                	mov    %edi,%edx
      name[1] = '0' + i;
     97f:	89 f0                	mov    %esi,%eax
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
     981:	88 55 c8             	mov    %dl,-0x38(%ebp)
      name[1] = '0' + i;
      unlink(name);
     984:	8b 55 c4             	mov    -0x3c(%ebp),%edx
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
     987:	83 c3 01             	add    $0x1,%ebx
      name[0] = 'p' + i;
      name[1] = '0' + i;
     98a:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
     98d:	89 14 24             	mov    %edx,(%esp)
     990:	e8 63 33 00 00       	call   3cf8 <unlink>
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
     995:	83 fb 04             	cmp    $0x4,%ebx
     998:	75 e3                	jne    97d <createdelete+0xdd>
     99a:	83 c7 01             	add    $0x1,%edi
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
     99d:	89 f8                	mov    %edi,%eax
     99f:	3c 84                	cmp    $0x84,%al
     9a1:	75 d5                	jne    978 <createdelete+0xd8>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
     9a3:	c7 44 24 04 ed 43 00 	movl   $0x43ed,0x4(%esp)
     9aa:	00 
     9ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9b2:	e8 29 34 00 00       	call   3de0 <printf>
}
     9b7:	83 c4 4c             	add    $0x4c,%esp
     9ba:	5b                   	pop    %ebx
     9bb:	5e                   	pop    %esi
     9bc:	5f                   	pop    %edi
     9bd:	5d                   	pop    %ebp
     9be:	c3                   	ret    
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
      name[0] = 'p' + pi;
     9bf:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
     9c2:	bf 01 00 00 00       	mov    $0x1,%edi
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
      name[0] = 'p' + pi;
     9c7:	88 5d c8             	mov    %bl,-0x38(%ebp)
     9ca:	8d 75 c8             	lea    -0x38(%ebp),%esi
      name[2] = '\0';
     9cd:	31 db                	xor    %ebx,%ebx
     9cf:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
     9d3:	eb 0e                	jmp    9e3 <createdelete+0x143>
     9d5:	8d 76 00             	lea    0x0(%esi),%esi
      for(i = 0; i < N; i++){
     9d8:	83 ff 13             	cmp    $0x13,%edi
     9db:	7f 7f                	jg     a5c <createdelete+0x1bc>
      exit();
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
     9dd:	83 c3 01             	add    $0x1,%ebx
     9e0:	83 c7 01             	add    $0x1,%edi
      for(i = 0; i < N; i++){
        name[1] = '0' + i;
     9e3:	8d 43 30             	lea    0x30(%ebx),%eax
     9e6:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
     9e9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     9f0:	00 
     9f1:	89 34 24             	mov    %esi,(%esp)
     9f4:	e8 ef 32 00 00       	call   3ce8 <open>
        if(fd < 0){
     9f9:	85 c0                	test   %eax,%eax
     9fb:	0f 88 ac 00 00 00    	js     aad <createdelete+0x20d>
          printf(1, "create failed\n");
          exit();
        }
        close(fd);
     a01:	89 04 24             	mov    %eax,(%esp)
     a04:	e8 c7 32 00 00       	call   3cd0 <close>
        if(i > 0 && (i % 2 ) == 0){
     a09:	85 db                	test   %ebx,%ebx
     a0b:	74 d0                	je     9dd <createdelete+0x13d>
     a0d:	f6 c3 01             	test   $0x1,%bl
     a10:	75 c6                	jne    9d8 <createdelete+0x138>
          name[1] = '0' + (i / 2);
     a12:	89 d8                	mov    %ebx,%eax
     a14:	d1 f8                	sar    %eax
     a16:	83 c0 30             	add    $0x30,%eax
     a19:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
     a1c:	89 34 24             	mov    %esi,(%esp)
     a1f:	e8 d4 32 00 00       	call   3cf8 <unlink>
     a24:	85 c0                	test   %eax,%eax
     a26:	79 b0                	jns    9d8 <createdelete+0x138>
            printf(1, "unlink failed\n");
     a28:	c7 44 24 04 de 43 00 	movl   $0x43de,0x4(%esp)
     a2f:	00 
     a30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a37:	e8 a4 33 00 00       	call   3de0 <printf>
            exit();
     a3c:	e8 67 32 00 00       	call   3ca8 <exit>
     a41:	8b 75 c0             	mov    -0x40(%ebp),%esi
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
     a44:	c7 44 24 04 b4 51 00 	movl   $0x51b4,0x4(%esp)
     a4b:	00 
     a4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a53:	89 74 24 08          	mov    %esi,0x8(%esp)
     a57:	e8 84 33 00 00       	call   3de0 <printf>
        exit();
     a5c:	e8 47 32 00 00       	call   3ca8 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     a61:	83 7d bc 08          	cmpl   $0x8,-0x44(%ebp)
     a65:	76 0d                	jbe    a74 <createdelete+0x1d4>
        printf(1, "oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
        close(fd);
     a67:	89 04 24             	mov    %eax,(%esp)
     a6a:	e8 61 32 00 00       	call   3cd0 <close>
     a6f:	e9 e2 fe ff ff       	jmp    956 <createdelete+0xb6>
     a74:	8b 75 c0             	mov    -0x40(%ebp),%esi
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
        printf(1, "oops createdelete %s did exist\n", name);
     a77:	c7 44 24 04 d8 51 00 	movl   $0x51d8,0x4(%esp)
     a7e:	00 
     a7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a86:	89 74 24 08          	mov    %esi,0x8(%esp)
     a8a:	e8 51 33 00 00       	call   3de0 <printf>
        exit();
     a8f:	e8 14 32 00 00       	call   3ca8 <exit>
  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
     a94:	c7 44 24 04 bf 45 00 	movl   $0x45bf,0x4(%esp)
     a9b:	00 
     a9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     aa3:	e8 38 33 00 00       	call   3de0 <printf>
      exit();
     aa8:	e8 fb 31 00 00       	call   3ca8 <exit>
      name[2] = '\0';
      for(i = 0; i < N; i++){
        name[1] = '0' + i;
        fd = open(name, O_CREATE | O_RDWR);
        if(fd < 0){
          printf(1, "create failed\n");
     aad:	c7 44 24 04 55 46 00 	movl   $0x4655,0x4(%esp)
     ab4:	00 
     ab5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     abc:	e8 1f 33 00 00       	call   3de0 <printf>
          exit();
     ac1:	e8 e2 31 00 00       	call   3ca8 <exit>
     ac6:	8d 76 00             	lea    0x0(%esi),%esi
     ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ad0 <createtest>:
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     ad0:	55                   	push   %ebp
     ad1:	89 e5                	mov    %esp,%ebp
     ad3:	53                   	push   %ebx
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
     ad4:	bb 30 00 00 00       	mov    $0x30,%ebx
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     ad9:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     adc:	a1 0c 59 00 00       	mov    0x590c,%eax
     ae1:	c7 44 24 04 f8 51 00 	movl   $0x51f8,0x4(%esp)
     ae8:	00 
     ae9:	89 04 24             	mov    %eax,(%esp)
     aec:	e8 ef 32 00 00       	call   3de0 <printf>

  name[0] = 'a';
     af1:	c6 05 e0 a0 00 00 61 	movb   $0x61,0xa0e0
  name[2] = '\0';
     af8:	c6 05 e2 a0 00 00 00 	movb   $0x0,0xa0e2
     aff:	90                   	nop
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     b00:	88 1d e1 a0 00 00    	mov    %bl,0xa0e1
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
     b06:	83 c3 01             	add    $0x1,%ebx

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
     b09:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     b10:	00 
     b11:	c7 04 24 e0 a0 00 00 	movl   $0xa0e0,(%esp)
     b18:	e8 cb 31 00 00       	call   3ce8 <open>
    close(fd);
     b1d:	89 04 24             	mov    %eax,(%esp)
     b20:	e8 ab 31 00 00       	call   3cd0 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     b25:	80 fb 64             	cmp    $0x64,%bl
     b28:	75 d6                	jne    b00 <createtest+0x30>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     b2a:	c6 05 e0 a0 00 00 61 	movb   $0x61,0xa0e0
  name[2] = '\0';
     b31:	bb 30 00 00 00       	mov    $0x30,%ebx
     b36:	c6 05 e2 a0 00 00 00 	movb   $0x0,0xa0e2
     b3d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     b40:	88 1d e1 a0 00 00    	mov    %bl,0xa0e1
    unlink(name);
     b46:	83 c3 01             	add    $0x1,%ebx
     b49:	c7 04 24 e0 a0 00 00 	movl   $0xa0e0,(%esp)
     b50:	e8 a3 31 00 00       	call   3cf8 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     b55:	80 fb 64             	cmp    $0x64,%bl
     b58:	75 e6                	jne    b40 <createtest+0x70>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     b5a:	a1 0c 59 00 00       	mov    0x590c,%eax
     b5f:	c7 44 24 04 20 52 00 	movl   $0x5220,0x4(%esp)
     b66:	00 
     b67:	89 04 24             	mov    %eax,(%esp)
     b6a:	e8 71 32 00 00       	call   3de0 <printf>
}
     b6f:	83 c4 14             	add    $0x14,%esp
     b72:	5b                   	pop    %ebx
     b73:	5d                   	pop    %ebp
     b74:	c3                   	ret    
     b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b80 <writetest1>:
  printf(stdout, "small file test ok\n");
}

void
writetest1(void)
{
     b80:	55                   	push   %ebp
     b81:	89 e5                	mov    %esp,%ebp
     b83:	56                   	push   %esi
     b84:	53                   	push   %ebx
     b85:	83 ec 10             	sub    $0x10,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     b88:	a1 0c 59 00 00       	mov    0x590c,%eax
     b8d:	c7 44 24 04 fe 43 00 	movl   $0x43fe,0x4(%esp)
     b94:	00 
     b95:	89 04 24             	mov    %eax,(%esp)
     b98:	e8 43 32 00 00       	call   3de0 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     b9d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     ba4:	00 
     ba5:	c7 04 24 78 44 00 00 	movl   $0x4478,(%esp)
     bac:	e8 37 31 00 00       	call   3ce8 <open>
  if(fd < 0){
     bb1:	85 c0                	test   %eax,%eax
{
  int i, fd, n;

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
     bb3:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     bb5:	0f 88 7a 01 00 00    	js     d35 <writetest1+0x1b5>
    printf(stdout, "error: creat big failed!\n");
    exit();
     bbb:	31 db                	xor    %ebx,%ebx
     bbd:	8d 76 00             	lea    0x0(%esi),%esi
  }

  for(i = 0; i < MAXFILE; i++){
    ((int*)buf)[0] = i;
     bc0:	89 1d e0 80 00 00    	mov    %ebx,0x80e0
    if(write(fd, buf, 512) != 512){
     bc6:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     bcd:	00 
     bce:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
     bd5:	00 
     bd6:	89 34 24             	mov    %esi,(%esp)
     bd9:	e8 ea 30 00 00       	call   3cc8 <write>
     bde:	3d 00 02 00 00       	cmp    $0x200,%eax
     be3:	0f 85 b2 00 00 00    	jne    c9b <writetest1+0x11b>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     be9:	83 c3 01             	add    $0x1,%ebx
     bec:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     bf2:	75 cc                	jne    bc0 <writetest1+0x40>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     bf4:	89 34 24             	mov    %esi,(%esp)
     bf7:	e8 d4 30 00 00       	call   3cd0 <close>

  fd = open("big", O_RDONLY);
     bfc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c03:	00 
     c04:	c7 04 24 78 44 00 00 	movl   $0x4478,(%esp)
     c0b:	e8 d8 30 00 00       	call   3ce8 <open>
  if(fd < 0){
     c10:	85 c0                	test   %eax,%eax
    }
  }

  close(fd);

  fd = open("big", O_RDONLY);
     c12:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     c14:	0f 88 01 01 00 00    	js     d1b <writetest1+0x19b>
    printf(stdout, "error: open big failed!\n");
    exit();
     c1a:	31 db                	xor    %ebx,%ebx
     c1c:	eb 1d                	jmp    c3b <writetest1+0xbb>
     c1e:	66 90                	xchg   %ax,%ax
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     c20:	3d 00 02 00 00       	cmp    $0x200,%eax
     c25:	0f 85 b0 00 00 00    	jne    cdb <writetest1+0x15b>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
     c2b:	a1 e0 80 00 00       	mov    0x80e0,%eax
     c30:	39 d8                	cmp    %ebx,%eax
     c32:	0f 85 81 00 00 00    	jne    cb9 <writetest1+0x139>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     c38:	83 c3 01             	add    $0x1,%ebx
    exit();
  }

  n = 0;
  for(;;){
    i = read(fd, buf, 512);
     c3b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     c42:	00 
     c43:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
     c4a:	00 
     c4b:	89 34 24             	mov    %esi,(%esp)
     c4e:	e8 6d 30 00 00       	call   3cc0 <read>
    if(i == 0){
     c53:	85 c0                	test   %eax,%eax
     c55:	75 c9                	jne    c20 <writetest1+0xa0>
      if(n == MAXFILE - 1){
     c57:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     c5d:	0f 84 96 00 00 00    	je     cf9 <writetest1+0x179>
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     c63:	89 34 24             	mov    %esi,(%esp)
     c66:	e8 65 30 00 00       	call   3cd0 <close>
  if(unlink("big") < 0){
     c6b:	c7 04 24 78 44 00 00 	movl   $0x4478,(%esp)
     c72:	e8 81 30 00 00       	call   3cf8 <unlink>
     c77:	85 c0                	test   %eax,%eax
     c79:	0f 88 d0 00 00 00    	js     d4f <writetest1+0x1cf>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
     c7f:	a1 0c 59 00 00       	mov    0x590c,%eax
     c84:	c7 44 24 04 9f 44 00 	movl   $0x449f,0x4(%esp)
     c8b:	00 
     c8c:	89 04 24             	mov    %eax,(%esp)
     c8f:	e8 4c 31 00 00       	call   3de0 <printf>
}
     c94:	83 c4 10             	add    $0x10,%esp
     c97:	5b                   	pop    %ebx
     c98:	5e                   	pop    %esi
     c99:	5d                   	pop    %ebp
     c9a:	c3                   	ret    
  }

  for(i = 0; i < MAXFILE; i++){
    ((int*)buf)[0] = i;
    if(write(fd, buf, 512) != 512){
      printf(stdout, "error: write big file failed\n", i);
     c9b:	a1 0c 59 00 00       	mov    0x590c,%eax
     ca0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     ca4:	c7 44 24 04 28 44 00 	movl   $0x4428,0x4(%esp)
     cab:	00 
     cac:	89 04 24             	mov    %eax,(%esp)
     caf:	e8 2c 31 00 00       	call   3de0 <printf>
      exit();
     cb4:	e8 ef 2f 00 00       	call   3ca8 <exit>
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     cb9:	89 44 24 0c          	mov    %eax,0xc(%esp)
     cbd:	a1 0c 59 00 00       	mov    0x590c,%eax
     cc2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     cc6:	c7 44 24 04 48 52 00 	movl   $0x5248,0x4(%esp)
     ccd:	00 
     cce:	89 04 24             	mov    %eax,(%esp)
     cd1:	e8 0a 31 00 00       	call   3de0 <printf>
             n, ((int*)buf)[0]);
      exit();
     cd6:	e8 cd 2f 00 00       	call   3ca8 <exit>
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
     cdb:	89 44 24 08          	mov    %eax,0x8(%esp)
     cdf:	a1 0c 59 00 00       	mov    0x590c,%eax
     ce4:	c7 44 24 04 7c 44 00 	movl   $0x447c,0x4(%esp)
     ceb:	00 
     cec:	89 04 24             	mov    %eax,(%esp)
     cef:	e8 ec 30 00 00       	call   3de0 <printf>
      exit();
     cf4:	e8 af 2f 00 00       	call   3ca8 <exit>
  n = 0;
  for(;;){
    i = read(fd, buf, 512);
    if(i == 0){
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
     cf9:	a1 0c 59 00 00       	mov    0x590c,%eax
     cfe:	c7 44 24 08 8b 00 00 	movl   $0x8b,0x8(%esp)
     d05:	00 
     d06:	c7 44 24 04 5f 44 00 	movl   $0x445f,0x4(%esp)
     d0d:	00 
     d0e:	89 04 24             	mov    %eax,(%esp)
     d11:	e8 ca 30 00 00       	call   3de0 <printf>
        exit();
     d16:	e8 8d 2f 00 00       	call   3ca8 <exit>

  close(fd);

  fd = open("big", O_RDONLY);
  if(fd < 0){
    printf(stdout, "error: open big failed!\n");
     d1b:	a1 0c 59 00 00       	mov    0x590c,%eax
     d20:	c7 44 24 04 46 44 00 	movl   $0x4446,0x4(%esp)
     d27:	00 
     d28:	89 04 24             	mov    %eax,(%esp)
     d2b:	e8 b0 30 00 00       	call   3de0 <printf>
    exit();
     d30:	e8 73 2f 00 00       	call   3ca8 <exit>

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
     d35:	a1 0c 59 00 00       	mov    0x590c,%eax
     d3a:	c7 44 24 04 0e 44 00 	movl   $0x440e,0x4(%esp)
     d41:	00 
     d42:	89 04 24             	mov    %eax,(%esp)
     d45:	e8 96 30 00 00       	call   3de0 <printf>
    exit();
     d4a:	e8 59 2f 00 00       	call   3ca8 <exit>
    }
    n++;
  }
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
     d4f:	a1 0c 59 00 00       	mov    0x590c,%eax
     d54:	c7 44 24 04 8c 44 00 	movl   $0x448c,0x4(%esp)
     d5b:	00 
     d5c:	89 04 24             	mov    %eax,(%esp)
     d5f:	e8 7c 30 00 00       	call   3de0 <printf>
    exit();
     d64:	e8 3f 2f 00 00       	call   3ca8 <exit>
     d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d70 <writetest>:
  printf(stdout, "open test ok\n");
}

void
writetest(void)
{
     d70:	55                   	push   %ebp
     d71:	89 e5                	mov    %esp,%ebp
     d73:	56                   	push   %esi
     d74:	53                   	push   %ebx
     d75:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     d78:	a1 0c 59 00 00       	mov    0x590c,%eax
     d7d:	c7 44 24 04 ad 44 00 	movl   $0x44ad,0x4(%esp)
     d84:	00 
     d85:	89 04 24             	mov    %eax,(%esp)
     d88:	e8 53 30 00 00       	call   3de0 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     d8d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     d94:	00 
     d95:	c7 04 24 be 44 00 00 	movl   $0x44be,(%esp)
     d9c:	e8 47 2f 00 00       	call   3ce8 <open>
  if(fd >= 0){
     da1:	85 c0                	test   %eax,%eax
{
  int fd;
  int i;

  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
     da3:	89 c6                	mov    %eax,%esi
  if(fd >= 0){
     da5:	0f 88 b1 01 00 00    	js     f5c <writetest+0x1ec>
    printf(stdout, "creat small succeeded; ok\n");
     dab:	a1 0c 59 00 00       	mov    0x590c,%eax
     db0:	31 db                	xor    %ebx,%ebx
     db2:	c7 44 24 04 c4 44 00 	movl   $0x44c4,0x4(%esp)
     db9:	00 
     dba:	89 04 24             	mov    %eax,(%esp)
     dbd:	e8 1e 30 00 00       	call   3de0 <printf>
     dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     dc8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     dcf:	00 
     dd0:	c7 44 24 04 fb 44 00 	movl   $0x44fb,0x4(%esp)
     dd7:	00 
     dd8:	89 34 24             	mov    %esi,(%esp)
     ddb:	e8 e8 2e 00 00       	call   3cc8 <write>
     de0:	83 f8 0a             	cmp    $0xa,%eax
     de3:	0f 85 e9 00 00 00    	jne    ed2 <writetest+0x162>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     de9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     df0:	00 
     df1:	c7 44 24 04 06 45 00 	movl   $0x4506,0x4(%esp)
     df8:	00 
     df9:	89 34 24             	mov    %esi,(%esp)
     dfc:	e8 c7 2e 00 00       	call   3cc8 <write>
     e01:	83 f8 0a             	cmp    $0xa,%eax
     e04:	0f 85 e6 00 00 00    	jne    ef0 <writetest+0x180>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     e0a:	83 c3 01             	add    $0x1,%ebx
     e0d:	83 fb 64             	cmp    $0x64,%ebx
     e10:	75 b6                	jne    dc8 <writetest+0x58>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     e12:	a1 0c 59 00 00       	mov    0x590c,%eax
     e17:	c7 44 24 04 11 45 00 	movl   $0x4511,0x4(%esp)
     e1e:	00 
     e1f:	89 04 24             	mov    %eax,(%esp)
     e22:	e8 b9 2f 00 00       	call   3de0 <printf>
  close(fd);
     e27:	89 34 24             	mov    %esi,(%esp)
     e2a:	e8 a1 2e 00 00       	call   3cd0 <close>
  fd = open("small", O_RDONLY);
     e2f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e36:	00 
     e37:	c7 04 24 be 44 00 00 	movl   $0x44be,(%esp)
     e3e:	e8 a5 2e 00 00       	call   3ce8 <open>
  if(fd >= 0){
     e43:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  printf(stdout, "writes ok\n");
  close(fd);
  fd = open("small", O_RDONLY);
     e45:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     e47:	0f 88 c1 00 00 00    	js     f0e <writetest+0x19e>
    printf(stdout, "open small succeeded ok\n");
     e4d:	a1 0c 59 00 00       	mov    0x590c,%eax
     e52:	c7 44 24 04 1c 45 00 	movl   $0x451c,0x4(%esp)
     e59:	00 
     e5a:	89 04 24             	mov    %eax,(%esp)
     e5d:	e8 7e 2f 00 00       	call   3de0 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     e62:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     e69:	00 
     e6a:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
     e71:	00 
     e72:	89 1c 24             	mov    %ebx,(%esp)
     e75:	e8 46 2e 00 00       	call   3cc0 <read>
  if(i == 2000){
     e7a:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     e7f:	0f 85 a3 00 00 00    	jne    f28 <writetest+0x1b8>
    printf(stdout, "read succeeded ok\n");
     e85:	a1 0c 59 00 00       	mov    0x590c,%eax
     e8a:	c7 44 24 04 50 45 00 	movl   $0x4550,0x4(%esp)
     e91:	00 
     e92:	89 04 24             	mov    %eax,(%esp)
     e95:	e8 46 2f 00 00       	call   3de0 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     e9a:	89 1c 24             	mov    %ebx,(%esp)
     e9d:	e8 2e 2e 00 00       	call   3cd0 <close>

  if(unlink("small") < 0){
     ea2:	c7 04 24 be 44 00 00 	movl   $0x44be,(%esp)
     ea9:	e8 4a 2e 00 00       	call   3cf8 <unlink>
     eae:	85 c0                	test   %eax,%eax
     eb0:	0f 88 8c 00 00 00    	js     f42 <writetest+0x1d2>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
     eb6:	a1 0c 59 00 00       	mov    0x590c,%eax
     ebb:	c7 44 24 04 78 45 00 	movl   $0x4578,0x4(%esp)
     ec2:	00 
     ec3:	89 04 24             	mov    %eax,(%esp)
     ec6:	e8 15 2f 00 00       	call   3de0 <printf>
}
     ecb:	83 c4 10             	add    $0x10,%esp
     ece:	5b                   	pop    %ebx
     ecf:	5e                   	pop    %esi
     ed0:	5d                   	pop    %ebp
     ed1:	c3                   	ret    
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
      printf(stdout, "error: write aa %d new file failed\n", i);
     ed2:	a1 0c 59 00 00       	mov    0x590c,%eax
     ed7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     edb:	c7 44 24 04 68 52 00 	movl   $0x5268,0x4(%esp)
     ee2:	00 
     ee3:	89 04 24             	mov    %eax,(%esp)
     ee6:	e8 f5 2e 00 00       	call   3de0 <printf>
      exit();
     eeb:	e8 b8 2d 00 00       	call   3ca8 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
     ef0:	a1 0c 59 00 00       	mov    0x590c,%eax
     ef5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     ef9:	c7 44 24 04 8c 52 00 	movl   $0x528c,0x4(%esp)
     f00:	00 
     f01:	89 04 24             	mov    %eax,(%esp)
     f04:	e8 d7 2e 00 00       	call   3de0 <printf>
      exit();
     f09:	e8 9a 2d 00 00       	call   3ca8 <exit>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     f0e:	a1 0c 59 00 00       	mov    0x590c,%eax
     f13:	c7 44 24 04 35 45 00 	movl   $0x4535,0x4(%esp)
     f1a:	00 
     f1b:	89 04 24             	mov    %eax,(%esp)
     f1e:	e8 bd 2e 00 00       	call   3de0 <printf>
    exit();
     f23:	e8 80 2d 00 00       	call   3ca8 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     f28:	a1 0c 59 00 00       	mov    0x590c,%eax
     f2d:	c7 44 24 04 2c 43 00 	movl   $0x432c,0x4(%esp)
     f34:	00 
     f35:	89 04 24             	mov    %eax,(%esp)
     f38:	e8 a3 2e 00 00       	call   3de0 <printf>
    exit();
     f3d:	e8 66 2d 00 00       	call   3ca8 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     f42:	a1 0c 59 00 00       	mov    0x590c,%eax
     f47:	c7 44 24 04 63 45 00 	movl   $0x4563,0x4(%esp)
     f4e:	00 
     f4f:	89 04 24             	mov    %eax,(%esp)
     f52:	e8 89 2e 00 00       	call   3de0 <printf>
    exit();
     f57:	e8 4c 2d 00 00       	call   3ca8 <exit>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     f5c:	a1 0c 59 00 00       	mov    0x590c,%eax
     f61:	c7 44 24 04 df 44 00 	movl   $0x44df,0x4(%esp)
     f68:	00 
     f69:	89 04 24             	mov    %eax,(%esp)
     f6c:	e8 6f 2e 00 00       	call   3de0 <printf>
    exit();
     f71:	e8 32 2d 00 00       	call   3ca8 <exit>
     f76:	8d 76 00             	lea    0x0(%esi),%esi
     f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000f80 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
     f80:	55                   	push   %ebp
     f81:	89 e5                	mov    %esp,%ebp
     f83:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
     f86:	c7 04 24 8c 45 00 00 	movl   $0x458c,(%esp)
     f8d:	e8 66 2d 00 00       	call   3cf8 <unlink>
  pid = fork();
     f92:	e8 09 2d 00 00       	call   3ca0 <fork>
  if(pid == 0){
     f97:	83 f8 00             	cmp    $0x0,%eax
     f9a:	74 44                	je     fe0 <bigargtest+0x60>
     f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
     fa0:	0f 8c d0 00 00 00    	jl     1076 <bigargtest+0xf6>
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
     fa6:	e8 05 2d 00 00       	call   3cb0 <wait>
  fd = open("bigarg-ok", 0);
     fab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     fb2:	00 
     fb3:	c7 04 24 8c 45 00 00 	movl   $0x458c,(%esp)
     fba:	e8 29 2d 00 00       	call   3ce8 <open>
  if(fd < 0){
     fbf:	85 c0                	test   %eax,%eax
     fc1:	0f 88 95 00 00 00    	js     105c <bigargtest+0xdc>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
     fc7:	89 04 24             	mov    %eax,(%esp)
     fca:	e8 01 2d 00 00       	call   3cd0 <close>
  unlink("bigarg-ok");
     fcf:	c7 04 24 8c 45 00 00 	movl   $0x458c,(%esp)
     fd6:	e8 1d 2d 00 00       	call   3cf8 <unlink>
}
     fdb:	c9                   	leave  
     fdc:	c3                   	ret    
     fdd:	8d 76 00             	lea    0x0(%esi),%esi
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
     fe0:	c7 04 85 20 59 00 00 	movl   $0x52b0,0x5920(,%eax,4)
     fe7:	b0 52 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
     feb:	83 c0 01             	add    $0x1,%eax
     fee:	83 f8 1f             	cmp    $0x1f,%eax
     ff1:	75 ed                	jne    fe0 <bigargtest+0x60>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    printf(stdout, "bigarg test\n");
     ff3:	a1 0c 59 00 00       	mov    0x590c,%eax
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
     ff8:	c7 05 9c 59 00 00 00 	movl   $0x0,0x599c
     fff:	00 00 00 
    printf(stdout, "bigarg test\n");
    1002:	c7 44 24 04 96 45 00 	movl   $0x4596,0x4(%esp)
    1009:	00 
    100a:	89 04 24             	mov    %eax,(%esp)
    100d:	e8 ce 2d 00 00       	call   3de0 <printf>
    exec("echo", args);
    1012:	c7 44 24 04 20 59 00 	movl   $0x5920,0x4(%esp)
    1019:	00 
    101a:	c7 04 24 7b 41 00 00 	movl   $0x417b,(%esp)
    1021:	e8 ba 2c 00 00       	call   3ce0 <exec>
    printf(stdout, "bigarg test ok\n");
    1026:	a1 0c 59 00 00       	mov    0x590c,%eax
    102b:	c7 44 24 04 a3 45 00 	movl   $0x45a3,0x4(%esp)
    1032:	00 
    1033:	89 04 24             	mov    %eax,(%esp)
    1036:	e8 a5 2d 00 00       	call   3de0 <printf>
    fd = open("bigarg-ok", O_CREATE);
    103b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1042:	00 
    1043:	c7 04 24 8c 45 00 00 	movl   $0x458c,(%esp)
    104a:	e8 99 2c 00 00       	call   3ce8 <open>
    close(fd);
    104f:	89 04 24             	mov    %eax,(%esp)
    1052:	e8 79 2c 00 00       	call   3cd0 <close>
    exit();
    1057:	e8 4c 2c 00 00       	call   3ca8 <exit>
    exit();
  }
  wait();
  fd = open("bigarg-ok", 0);
  if(fd < 0){
    printf(stdout, "bigarg test failed!\n");
    105c:	a1 0c 59 00 00       	mov    0x590c,%eax
    1061:	c7 44 24 04 cc 45 00 	movl   $0x45cc,0x4(%esp)
    1068:	00 
    1069:	89 04 24             	mov    %eax,(%esp)
    106c:	e8 6f 2d 00 00       	call   3de0 <printf>
    exit();
    1071:	e8 32 2c 00 00       	call   3ca8 <exit>
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    printf(stdout, "bigargtest: fork failed\n");
    1076:	a1 0c 59 00 00       	mov    0x590c,%eax
    107b:	c7 44 24 04 b3 45 00 	movl   $0x45b3,0x4(%esp)
    1082:	00 
    1083:	89 04 24             	mov    %eax,(%esp)
    1086:	e8 55 2d 00 00       	call   3de0 <printf>
    exit();
    108b:	e8 18 2c 00 00       	call   3ca8 <exit>

00001090 <exectest>:
  printf(stdout, "mkdir test ok\n");
}

void
exectest(void)
{
    1090:	55                   	push   %ebp
    1091:	89 e5                	mov    %esp,%ebp
    1093:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
    1096:	a1 0c 59 00 00       	mov    0x590c,%eax
    109b:	c7 44 24 04 e1 45 00 	movl   $0x45e1,0x4(%esp)
    10a2:	00 
    10a3:	89 04 24             	mov    %eax,(%esp)
    10a6:	e8 35 2d 00 00       	call   3de0 <printf>
  if(exec("echo", echoargv) < 0){
    10ab:	c7 44 24 04 f8 58 00 	movl   $0x58f8,0x4(%esp)
    10b2:	00 
    10b3:	c7 04 24 7b 41 00 00 	movl   $0x417b,(%esp)
    10ba:	e8 21 2c 00 00       	call   3ce0 <exec>
    10bf:	85 c0                	test   %eax,%eax
    10c1:	78 02                	js     10c5 <exectest+0x35>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
    10c3:	c9                   	leave  
    10c4:	c3                   	ret    
void
exectest(void)
{
  printf(stdout, "exec test\n");
  if(exec("echo", echoargv) < 0){
    printf(stdout, "exec echo failed\n");
    10c5:	a1 0c 59 00 00       	mov    0x590c,%eax
    10ca:	c7 44 24 04 ec 45 00 	movl   $0x45ec,0x4(%esp)
    10d1:	00 
    10d2:	89 04 24             	mov    %eax,(%esp)
    10d5:	e8 06 2d 00 00       	call   3de0 <printf>
    exit();
    10da:	e8 c9 2b 00 00       	call   3ca8 <exit>
    10df:	90                   	nop

000010e0 <validatetest>:
      "ebx");
}

void
validatetest(void)
{
    10e0:	55                   	push   %ebp
    10e1:	89 e5                	mov    %esp,%ebp
    10e3:	56                   	push   %esi
    10e4:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    10e5:	31 db                	xor    %ebx,%ebx
      "ebx");
}

void
validatetest(void)
{
    10e7:	83 ec 10             	sub    $0x10,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    10ea:	a1 0c 59 00 00       	mov    0x590c,%eax
    10ef:	c7 44 24 04 fe 45 00 	movl   $0x45fe,0x4(%esp)
    10f6:	00 
    10f7:	89 04 24             	mov    %eax,(%esp)
    10fa:	e8 e1 2c 00 00       	call   3de0 <printf>
    10ff:	90                   	nop
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    if((pid = fork()) == 0){
    1100:	e8 9b 2b 00 00       	call   3ca0 <fork>
    1105:	85 c0                	test   %eax,%eax
    1107:	89 c6                	mov    %eax,%esi
    1109:	74 79                	je     1184 <validatetest+0xa4>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit();
    }
    sleep(0);
    110b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1112:	e8 21 2c 00 00       	call   3d38 <sleep>
    sleep(0);
    1117:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    111e:	e8 15 2c 00 00       	call   3d38 <sleep>
    kill(pid);
    1123:	89 34 24             	mov    %esi,(%esp)
    1126:	e8 ad 2b 00 00       	call   3cd8 <kill>
    wait();
    112b:	e8 80 2b 00 00       	call   3cb0 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    1130:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1134:	c7 04 24 0d 46 00 00 	movl   $0x460d,(%esp)
    113b:	e8 c8 2b 00 00       	call   3d08 <link>
    1140:	83 f8 ff             	cmp    $0xffffffff,%eax
    1143:	75 2a                	jne    116f <validatetest+0x8f>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    1145:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    114b:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
    1151:	75 ad                	jne    1100 <validatetest+0x20>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    1153:	a1 0c 59 00 00       	mov    0x590c,%eax
    1158:	c7 44 24 04 31 46 00 	movl   $0x4631,0x4(%esp)
    115f:	00 
    1160:	89 04 24             	mov    %eax,(%esp)
    1163:	e8 78 2c 00 00       	call   3de0 <printf>
}
    1168:	83 c4 10             	add    $0x10,%esp
    116b:	5b                   	pop    %ebx
    116c:	5e                   	pop    %esi
    116d:	5d                   	pop    %ebp
    116e:	c3                   	ret    
    kill(pid);
    wait();

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
      printf(stdout, "link should not succeed\n");
    116f:	a1 0c 59 00 00       	mov    0x590c,%eax
    1174:	c7 44 24 04 18 46 00 	movl   $0x4618,0x4(%esp)
    117b:	00 
    117c:	89 04 24             	mov    %eax,(%esp)
    117f:	e8 5c 2c 00 00       	call   3de0 <printf>
      exit();
    1184:	e8 1f 2b 00 00       	call   3ca8 <exit>
    1189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001190 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	56                   	push   %esi
    1194:	53                   	push   %ebx
    1195:	83 ec 20             	sub    $0x20,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1198:	c7 44 24 04 3e 46 00 	movl   $0x463e,0x4(%esp)
    119f:	00 
    11a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11a7:	e8 34 2c 00 00       	call   3de0 <printf>
  unlink("bd");
    11ac:	c7 04 24 4b 46 00 00 	movl   $0x464b,(%esp)
    11b3:	e8 40 2b 00 00       	call   3cf8 <unlink>

  fd = open("bd", O_CREATE);
    11b8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    11bf:	00 
    11c0:	c7 04 24 4b 46 00 00 	movl   $0x464b,(%esp)
    11c7:	e8 1c 2b 00 00       	call   3ce8 <open>
  if(fd < 0){
    11cc:	85 c0                	test   %eax,%eax
    11ce:	0f 88 e6 00 00 00    	js     12ba <bigdir+0x12a>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
    11d4:	89 04 24             	mov    %eax,(%esp)
    11d7:	31 db                	xor    %ebx,%ebx
    11d9:	e8 f2 2a 00 00       	call   3cd0 <close>
    11de:	8d 75 ee             	lea    -0x12(%ebp),%esi
    11e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    11e8:	89 d8                	mov    %ebx,%eax
    11ea:	c1 f8 06             	sar    $0x6,%eax
    11ed:	83 c0 30             	add    $0x30,%eax
    11f0:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    11f3:	89 d8                	mov    %ebx,%eax
    11f5:	83 e0 3f             	and    $0x3f,%eax
    11f8:	83 c0 30             	add    $0x30,%eax
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    11fb:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    11ff:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1202:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
    1206:	89 74 24 04          	mov    %esi,0x4(%esp)
    120a:	c7 04 24 4b 46 00 00 	movl   $0x464b,(%esp)
    1211:	e8 f2 2a 00 00       	call   3d08 <link>
    1216:	85 c0                	test   %eax,%eax
    1218:	75 6e                	jne    1288 <bigdir+0xf8>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    121a:	83 c3 01             	add    $0x1,%ebx
    121d:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1223:	75 c3                	jne    11e8 <bigdir+0x58>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1225:	c7 04 24 4b 46 00 00 	movl   $0x464b,(%esp)
    122c:	66 31 db             	xor    %bx,%bx
    122f:	e8 c4 2a 00 00       	call   3cf8 <unlink>
    1234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    1238:	89 d8                	mov    %ebx,%eax
    123a:	c1 f8 06             	sar    $0x6,%eax
    123d:	83 c0 30             	add    $0x30,%eax
    1240:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1243:	89 d8                	mov    %ebx,%eax
    1245:	83 e0 3f             	and    $0x3f,%eax
    1248:	83 c0 30             	add    $0x30,%eax
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    124b:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    124f:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1252:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
    1256:	89 34 24             	mov    %esi,(%esp)
    1259:	e8 9a 2a 00 00       	call   3cf8 <unlink>
    125e:	85 c0                	test   %eax,%eax
    1260:	75 3f                	jne    12a1 <bigdir+0x111>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1262:	83 c3 01             	add    $0x1,%ebx
    1265:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    126b:	75 cb                	jne    1238 <bigdir+0xa8>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    126d:	c7 44 24 04 8d 46 00 	movl   $0x468d,0x4(%esp)
    1274:	00 
    1275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    127c:	e8 5f 2b 00 00       	call   3de0 <printf>
}
    1281:	83 c4 20             	add    $0x20,%esp
    1284:	5b                   	pop    %ebx
    1285:	5e                   	pop    %esi
    1286:	5d                   	pop    %ebp
    1287:	c3                   	ret    
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
      printf(1, "bigdir link failed\n");
    1288:	c7 44 24 04 64 46 00 	movl   $0x4664,0x4(%esp)
    128f:	00 
    1290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1297:	e8 44 2b 00 00       	call   3de0 <printf>
      exit();
    129c:	e8 07 2a 00 00       	call   3ca8 <exit>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(unlink(name) != 0){
      printf(1, "bigdir unlink failed");
    12a1:	c7 44 24 04 78 46 00 	movl   $0x4678,0x4(%esp)
    12a8:	00 
    12a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12b0:	e8 2b 2b 00 00       	call   3de0 <printf>
      exit();
    12b5:	e8 ee 29 00 00       	call   3ca8 <exit>
  printf(1, "bigdir test\n");
  unlink("bd");

  fd = open("bd", O_CREATE);
  if(fd < 0){
    printf(1, "bigdir create failed\n");
    12ba:	c7 44 24 04 4e 46 00 	movl   $0x464e,0x4(%esp)
    12c1:	00 
    12c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c9:	e8 12 2b 00 00       	call   3de0 <printf>
    exit();
    12ce:	e8 d5 29 00 00       	call   3ca8 <exit>
    12d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    12d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000012e0 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    12e0:	55                   	push   %ebp
    12e1:	89 e5                	mov    %esp,%ebp
    12e3:	57                   	push   %edi
    12e4:	56                   	push   %esi
    12e5:	53                   	push   %ebx
    12e6:	83 ec 2c             	sub    $0x2c,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    12e9:	c7 44 24 04 98 46 00 	movl   $0x4698,0x4(%esp)
    12f0:	00 
    12f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12f8:	e8 e3 2a 00 00       	call   3de0 <printf>

  unlink("x");
    12fd:	c7 04 24 75 4d 00 00 	movl   $0x4d75,(%esp)
    1304:	e8 ef 29 00 00       	call   3cf8 <unlink>
  pid = fork();
    1309:	e8 92 29 00 00       	call   3ca0 <fork>
  if(pid < 0){
    130e:	85 c0                	test   %eax,%eax
  int pid, i;

  printf(1, "linkunlink test\n");

  unlink("x");
  pid = fork();
    1310:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1313:	0f 88 b0 00 00 00    	js     13c9 <linkunlink+0xe9>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    1319:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
    131d:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    1322:	19 db                	sbb    %ebx,%ebx
    1324:	31 f6                	xor    %esi,%esi
    1326:	83 e3 60             	and    $0x60,%ebx
    1329:	83 c3 01             	add    $0x1,%ebx
    132c:	eb 1b                	jmp    1349 <linkunlink+0x69>
    132e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    } else if((x % 3) == 1){
    1330:	83 f8 01             	cmp    $0x1,%eax
    1333:	74 7b                	je     13b0 <linkunlink+0xd0>
      link("cat", "x");
    } else {
      unlink("x");
    1335:	c7 04 24 75 4d 00 00 	movl   $0x4d75,(%esp)
    133c:	e8 b7 29 00 00       	call   3cf8 <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1341:	83 c6 01             	add    $0x1,%esi
    1344:	83 fe 64             	cmp    $0x64,%esi
    1347:	74 3f                	je     1388 <linkunlink+0xa8>
    x = x * 1103515245 + 12345;
    1349:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    134f:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    1355:	89 d8                	mov    %ebx,%eax
    1357:	f7 e7                	mul    %edi
    1359:	89 d8                	mov    %ebx,%eax
    135b:	d1 ea                	shr    %edx
    135d:	8d 14 52             	lea    (%edx,%edx,2),%edx
    1360:	29 d0                	sub    %edx,%eax
    1362:	75 cc                	jne    1330 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1364:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    136b:	00 
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    136c:	83 c6 01             	add    $0x1,%esi
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    136f:	c7 04 24 75 4d 00 00 	movl   $0x4d75,(%esp)
    1376:	e8 6d 29 00 00       	call   3ce8 <open>
    137b:	89 04 24             	mov    %eax,(%esp)
    137e:	e8 4d 29 00 00       	call   3cd0 <close>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1383:	83 fe 64             	cmp    $0x64,%esi
    1386:	75 c1                	jne    1349 <linkunlink+0x69>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    138b:	85 c0                	test   %eax,%eax
    138d:	74 53                	je     13e2 <linkunlink+0x102>
    wait();
    138f:	e8 1c 29 00 00       	call   3cb0 <wait>
  else
    exit();

  printf(1, "linkunlink ok\n");
    1394:	c7 44 24 04 ad 46 00 	movl   $0x46ad,0x4(%esp)
    139b:	00 
    139c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13a3:	e8 38 2a 00 00       	call   3de0 <printf>
}
    13a8:	83 c4 2c             	add    $0x2c,%esp
    13ab:	5b                   	pop    %ebx
    13ac:	5e                   	pop    %esi
    13ad:	5f                   	pop    %edi
    13ae:	5d                   	pop    %ebp
    13af:	c3                   	ret    
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    } else if((x % 3) == 1){
      link("cat", "x");
    13b0:	c7 44 24 04 75 4d 00 	movl   $0x4d75,0x4(%esp)
    13b7:	00 
    13b8:	c7 04 24 a9 46 00 00 	movl   $0x46a9,(%esp)
    13bf:	e8 44 29 00 00       	call   3d08 <link>
    13c4:	e9 78 ff ff ff       	jmp    1341 <linkunlink+0x61>
  printf(1, "linkunlink test\n");

  unlink("x");
  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
    13c9:	c7 44 24 04 bf 45 00 	movl   $0x45bf,0x4(%esp)
    13d0:	00 
    13d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13d8:	e8 03 2a 00 00       	call   3de0 <printf>
    exit();
    13dd:	e8 c6 28 00 00       	call   3ca8 <exit>
  }

  if(pid)
    wait();
  else
    exit();
    13e2:	e8 c1 28 00 00       	call   3ca8 <exit>
    13e7:	89 f6                	mov    %esi,%esi
    13e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000013f0 <linktest>:
  printf(1, "unlinkread ok\n");
}

void
linktest(void)
{
    13f0:	55                   	push   %ebp
    13f1:	89 e5                	mov    %esp,%ebp
    13f3:	53                   	push   %ebx
    13f4:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "linktest\n");
    13f7:	c7 44 24 04 bc 46 00 	movl   $0x46bc,0x4(%esp)
    13fe:	00 
    13ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1406:	e8 d5 29 00 00       	call   3de0 <printf>

  unlink("lf1");
    140b:	c7 04 24 c6 46 00 00 	movl   $0x46c6,(%esp)
    1412:	e8 e1 28 00 00       	call   3cf8 <unlink>
  unlink("lf2");
    1417:	c7 04 24 ca 46 00 00 	movl   $0x46ca,(%esp)
    141e:	e8 d5 28 00 00       	call   3cf8 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1423:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    142a:	00 
    142b:	c7 04 24 c6 46 00 00 	movl   $0x46c6,(%esp)
    1432:	e8 b1 28 00 00       	call   3ce8 <open>
  if(fd < 0){
    1437:	85 c0                	test   %eax,%eax
  printf(1, "linktest\n");

  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
    1439:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    143b:	0f 88 26 01 00 00    	js     1567 <linktest+0x177>
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    1441:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1448:	00 
    1449:	c7 44 24 04 39 43 00 	movl   $0x4339,0x4(%esp)
    1450:	00 
    1451:	89 04 24             	mov    %eax,(%esp)
    1454:	e8 6f 28 00 00       	call   3cc8 <write>
    1459:	83 f8 05             	cmp    $0x5,%eax
    145c:	0f 85 cd 01 00 00    	jne    162f <linktest+0x23f>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    1462:	89 1c 24             	mov    %ebx,(%esp)
    1465:	e8 66 28 00 00       	call   3cd0 <close>

  if(link("lf1", "lf2") < 0){
    146a:	c7 44 24 04 ca 46 00 	movl   $0x46ca,0x4(%esp)
    1471:	00 
    1472:	c7 04 24 c6 46 00 00 	movl   $0x46c6,(%esp)
    1479:	e8 8a 28 00 00       	call   3d08 <link>
    147e:	85 c0                	test   %eax,%eax
    1480:	0f 88 90 01 00 00    	js     1616 <linktest+0x226>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    1486:	c7 04 24 c6 46 00 00 	movl   $0x46c6,(%esp)
    148d:	e8 66 28 00 00       	call   3cf8 <unlink>

  if(open("lf1", 0) >= 0){
    1492:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1499:	00 
    149a:	c7 04 24 c6 46 00 00 	movl   $0x46c6,(%esp)
    14a1:	e8 42 28 00 00       	call   3ce8 <open>
    14a6:	85 c0                	test   %eax,%eax
    14a8:	0f 89 4f 01 00 00    	jns    15fd <linktest+0x20d>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    14ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14b5:	00 
    14b6:	c7 04 24 ca 46 00 00 	movl   $0x46ca,(%esp)
    14bd:	e8 26 28 00 00       	call   3ce8 <open>
  if(fd < 0){
    14c2:	85 c0                	test   %eax,%eax
  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    14c4:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    14c6:	0f 88 18 01 00 00    	js     15e4 <linktest+0x1f4>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    14cc:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    14d3:	00 
    14d4:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    14db:	00 
    14dc:	89 04 24             	mov    %eax,(%esp)
    14df:	e8 dc 27 00 00       	call   3cc0 <read>
    14e4:	83 f8 05             	cmp    $0x5,%eax
    14e7:	0f 85 de 00 00 00    	jne    15cb <linktest+0x1db>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    14ed:	89 1c 24             	mov    %ebx,(%esp)
    14f0:	e8 db 27 00 00       	call   3cd0 <close>

  if(link("lf2", "lf2") >= 0){
    14f5:	c7 44 24 04 ca 46 00 	movl   $0x46ca,0x4(%esp)
    14fc:	00 
    14fd:	c7 04 24 ca 46 00 00 	movl   $0x46ca,(%esp)
    1504:	e8 ff 27 00 00       	call   3d08 <link>
    1509:	85 c0                	test   %eax,%eax
    150b:	0f 89 a1 00 00 00    	jns    15b2 <linktest+0x1c2>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    1511:	c7 04 24 ca 46 00 00 	movl   $0x46ca,(%esp)
    1518:	e8 db 27 00 00       	call   3cf8 <unlink>
  if(link("lf2", "lf1") >= 0){
    151d:	c7 44 24 04 c6 46 00 	movl   $0x46c6,0x4(%esp)
    1524:	00 
    1525:	c7 04 24 ca 46 00 00 	movl   $0x46ca,(%esp)
    152c:	e8 d7 27 00 00       	call   3d08 <link>
    1531:	85 c0                	test   %eax,%eax
    1533:	79 64                	jns    1599 <linktest+0x1a9>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    1535:	c7 44 24 04 c6 46 00 	movl   $0x46c6,0x4(%esp)
    153c:	00 
    153d:	c7 04 24 92 4c 00 00 	movl   $0x4c92,(%esp)
    1544:	e8 bf 27 00 00       	call   3d08 <link>
    1549:	85 c0                	test   %eax,%eax
    154b:	79 33                	jns    1580 <linktest+0x190>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    154d:	c7 44 24 04 64 47 00 	movl   $0x4764,0x4(%esp)
    1554:	00 
    1555:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    155c:	e8 7f 28 00 00       	call   3de0 <printf>
}
    1561:	83 c4 14             	add    $0x14,%esp
    1564:	5b                   	pop    %ebx
    1565:	5d                   	pop    %ebp
    1566:	c3                   	ret    
  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "create lf1 failed\n");
    1567:	c7 44 24 04 ce 46 00 	movl   $0x46ce,0x4(%esp)
    156e:	00 
    156f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1576:	e8 65 28 00 00       	call   3de0 <printf>
    exit();
    157b:	e8 28 27 00 00       	call   3ca8 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    printf(1, "link . lf1 succeeded! oops\n");
    1580:	c7 44 24 04 48 47 00 	movl   $0x4748,0x4(%esp)
    1587:	00 
    1588:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    158f:	e8 4c 28 00 00       	call   3de0 <printf>
    exit();
    1594:	e8 0f 27 00 00       	call   3ca8 <exit>
    exit();
  }

  unlink("lf2");
  if(link("lf2", "lf1") >= 0){
    printf(1, "link non-existant succeeded! oops\n");
    1599:	c7 44 24 04 b8 53 00 	movl   $0x53b8,0x4(%esp)
    15a0:	00 
    15a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15a8:	e8 33 28 00 00       	call   3de0 <printf>
    exit();
    15ad:	e8 f6 26 00 00       	call   3ca8 <exit>
    exit();
  }
  close(fd);

  if(link("lf2", "lf2") >= 0){
    printf(1, "link lf2 lf2 succeeded! oops\n");
    15b2:	c7 44 24 04 2a 47 00 	movl   $0x472a,0x4(%esp)
    15b9:	00 
    15ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c1:	e8 1a 28 00 00       	call   3de0 <printf>
    exit();
    15c6:	e8 dd 26 00 00       	call   3ca8 <exit>
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "read lf2 failed\n");
    15cb:	c7 44 24 04 19 47 00 	movl   $0x4719,0x4(%esp)
    15d2:	00 
    15d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15da:	e8 01 28 00 00       	call   3de0 <printf>
    exit();
    15df:	e8 c4 26 00 00       	call   3ca8 <exit>
    exit();
  }

  fd = open("lf2", 0);
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    15e4:	c7 44 24 04 08 47 00 	movl   $0x4708,0x4(%esp)
    15eb:	00 
    15ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15f3:	e8 e8 27 00 00       	call   3de0 <printf>
    exit();
    15f8:	e8 ab 26 00 00       	call   3ca8 <exit>
    exit();
  }
  unlink("lf1");

  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    15fd:	c7 44 24 04 90 53 00 	movl   $0x5390,0x4(%esp)
    1604:	00 
    1605:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    160c:	e8 cf 27 00 00       	call   3de0 <printf>
    exit();
    1611:	e8 92 26 00 00       	call   3ca8 <exit>
    exit();
  }
  close(fd);

  if(link("lf1", "lf2") < 0){
    printf(1, "link lf1 lf2 failed\n");
    1616:	c7 44 24 04 f3 46 00 	movl   $0x46f3,0x4(%esp)
    161d:	00 
    161e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1625:	e8 b6 27 00 00       	call   3de0 <printf>
    exit();
    162a:	e8 79 26 00 00       	call   3ca8 <exit>
  if(fd < 0){
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    printf(1, "write lf1 failed\n");
    162f:	c7 44 24 04 e1 46 00 	movl   $0x46e1,0x4(%esp)
    1636:	00 
    1637:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    163e:	e8 9d 27 00 00       	call   3de0 <printf>
    exit();
    1643:	e8 60 26 00 00       	call   3ca8 <exit>
    1648:	90                   	nop
    1649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001650 <sbrktest>:
  printf(1, "fork test OK\n");
}

void
sbrktest(void)
{
    1650:	55                   	push   %ebp
    1651:	89 e5                	mov    %esp,%ebp
    1653:	57                   	push   %edi
    1654:	56                   	push   %esi

  printf(stdout, "sbrk test\n");
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
    1655:	31 f6                	xor    %esi,%esi
  printf(1, "fork test OK\n");
}

void
sbrktest(void)
{
    1657:	53                   	push   %ebx
    1658:	83 ec 7c             	sub    $0x7c,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    165b:	a1 0c 59 00 00       	mov    0x590c,%eax
    1660:	c7 44 24 04 71 47 00 	movl   $0x4771,0x4(%esp)
    1667:	00 
    1668:	89 04 24             	mov    %eax,(%esp)
    166b:	e8 70 27 00 00       	call   3de0 <printf>
  oldbrk = sbrk(0);
    1670:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1677:	e8 b4 26 00 00       	call   3d30 <sbrk>

  // can one sbrk() less than a page?
  a = sbrk(0);
    167c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
  oldbrk = sbrk(0);
    1683:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    1686:	e8 a5 26 00 00       	call   3d30 <sbrk>
    168b:	89 c3                	mov    %eax,%ebx
    168d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;
  for(i = 0; i < 5000; i++){
    b = sbrk(1);
    1690:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1697:	e8 94 26 00 00       	call   3d30 <sbrk>
    if(b != a){
    169c:	39 c3                	cmp    %eax,%ebx
    169e:	0f 85 82 02 00 00    	jne    1926 <sbrktest+0x2d6>
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){
    16a4:	83 c6 01             	add    $0x1,%esi
    b = sbrk(1);
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    16a7:	c6 03 01             	movb   $0x1,(%ebx)
    a = b + 1;
    16aa:	83 c3 01             	add    $0x1,%ebx
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){
    16ad:	81 fe 88 13 00 00    	cmp    $0x1388,%esi
    16b3:	75 db                	jne    1690 <sbrktest+0x40>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    16b5:	e8 e6 25 00 00       	call   3ca0 <fork>
  if(pid < 0){
    16ba:	85 c0                	test   %eax,%eax
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    16bc:	89 c6                	mov    %eax,%esi
  if(pid < 0){
    16be:	0f 88 d0 03 00 00    	js     1a94 <sbrktest+0x444>
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    16c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c = sbrk(1);
  if(c != a + 1){
    16cb:	83 c3 01             	add    $0x1,%ebx
  pid = fork();
  if(pid < 0){
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    16ce:	e8 5d 26 00 00       	call   3d30 <sbrk>
  c = sbrk(1);
    16d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16da:	e8 51 26 00 00       	call   3d30 <sbrk>
  if(c != a + 1){
    16df:	39 d8                	cmp    %ebx,%eax
    16e1:	0f 85 93 03 00 00    	jne    1a7a <sbrktest+0x42a>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    16e7:	85 f6                	test   %esi,%esi
    16e9:	0f 84 86 03 00 00    	je     1a75 <sbrktest+0x425>
    16ef:	90                   	nop
    exit();
  wait();
    16f0:	e8 bb 25 00 00       	call   3cb0 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    16f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    16fc:	e8 2f 26 00 00       	call   3d30 <sbrk>
    1701:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
  p = sbrk(amt);
    1703:	b8 00 00 40 06       	mov    $0x6400000,%eax
    1708:	29 d8                	sub    %ebx,%eax
    170a:	89 04 24             	mov    %eax,(%esp)
    170d:	e8 1e 26 00 00       	call   3d30 <sbrk>
  if (p != a) {
    1712:	39 c3                	cmp    %eax,%ebx
    1714:	0f 85 46 03 00 00    	jne    1a60 <sbrktest+0x410>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    171a:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    1721:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1728:	e8 03 26 00 00       	call   3d30 <sbrk>
  c = sbrk(-4096);
    172d:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;

  // can one de-allocate?
  a = sbrk(0);
    1734:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    1736:	e8 f5 25 00 00       	call   3d30 <sbrk>
  if(c == (char*)0xffffffff){
    173b:	83 f8 ff             	cmp    $0xffffffff,%eax
    173e:	0f 84 02 03 00 00    	je     1a46 <sbrktest+0x3f6>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    1744:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    174b:	e8 e0 25 00 00       	call   3d30 <sbrk>
  if(c != a - 4096){
    1750:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    1756:	39 d0                	cmp    %edx,%eax
    1758:	0f 85 c6 02 00 00    	jne    1a24 <sbrktest+0x3d4>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    175e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1765:	e8 c6 25 00 00       	call   3d30 <sbrk>
  c = sbrk(4096);
    176a:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    1771:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    1773:	e8 b8 25 00 00       	call   3d30 <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    1778:	39 c3                	cmp    %eax,%ebx
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
  c = sbrk(4096);
    177a:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    177c:	0f 85 80 02 00 00    	jne    1a02 <sbrktest+0x3b2>
    1782:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1789:	e8 a2 25 00 00       	call   3d30 <sbrk>
    178e:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    1794:	39 d0                	cmp    %edx,%eax
    1796:	0f 85 66 02 00 00    	jne    1a02 <sbrktest+0x3b2>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    179c:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    17a3:	0f 84 3f 02 00 00    	je     19e8 <sbrktest+0x398>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    17a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  c = sbrk(-(sbrk(0) - oldbrk));
  if(c != a){
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
    17b0:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    17b5:	e8 76 25 00 00       	call   3d30 <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    17ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    17c1:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    17c3:	e8 68 25 00 00       	call   3d30 <sbrk>
    17c8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
    17cb:	29 c2                	sub    %eax,%edx
    17cd:	89 14 24             	mov    %edx,(%esp)
    17d0:	e8 5b 25 00 00       	call   3d30 <sbrk>
  if(c != a){
    17d5:	39 c6                	cmp    %eax,%esi
    17d7:	0f 85 e9 01 00 00    	jne    19c6 <sbrktest+0x376>
    17dd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    ppid = getpid();
    17e0:	e8 43 25 00 00       	call   3d28 <getpid>
    17e5:	89 c6                	mov    %eax,%esi
    pid = fork();
    17e7:	e8 b4 24 00 00       	call   3ca0 <fork>
    if(pid < 0){
    17ec:	83 f8 00             	cmp    $0x0,%eax
    17ef:	0f 8c b7 01 00 00    	jl     19ac <sbrktest+0x35c>
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
    17f5:	0f 84 84 01 00 00    	je     197f <sbrktest+0x32f>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    17fb:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    if(pid == 0){
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    1801:	e8 aa 24 00 00       	call   3cb0 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1806:	81 fb 80 84 1e 80    	cmp    $0x801e8480,%ebx
    180c:	75 d2                	jne    17e0 <sbrktest+0x190>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    180e:	8d 45 dc             	lea    -0x24(%ebp),%eax
    1811:	89 04 24             	mov    %eax,(%esp)
    1814:	e8 9f 24 00 00       	call   3cb8 <pipe>
    1819:	85 c0                	test   %eax,%eax
    181b:	0f 85 45 01 00 00    	jne    1966 <sbrktest+0x316>
    printf(1, "pipe() failed\n");
    exit();
    1821:	31 db                	xor    %ebx,%ebx
    1823:	8d 7d b4             	lea    -0x4c(%ebp),%edi
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
    1826:	e8 75 24 00 00       	call   3ca0 <fork>
    182b:	85 c0                	test   %eax,%eax
    182d:	89 c6                	mov    %eax,%esi
    182f:	0f 84 a7 00 00 00    	je     18dc <sbrktest+0x28c>
      sbrk(BIG - (uint)sbrk(0));
      write(fds[1], "x", 1);
      // sit around until killed
      for(;;) sleep(1000);
    }
    if(pids[i] != -1)
    1835:	83 f8 ff             	cmp    $0xffffffff,%eax
    1838:	74 1a                	je     1854 <sbrktest+0x204>
      read(fds[0], &scratch, 1);
    183a:	8d 45 e7             	lea    -0x19(%ebp),%eax
    183d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1841:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1844:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    184b:	00 
    184c:	89 04 24             	mov    %eax,(%esp)
    184f:	e8 6c 24 00 00       	call   3cc0 <read>
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
    1854:	89 34 9f             	mov    %esi,(%edi,%ebx,4)
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    1857:	83 c3 01             	add    $0x1,%ebx
    185a:	83 fb 0a             	cmp    $0xa,%ebx
    185d:	75 c7                	jne    1826 <sbrktest+0x1d6>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    185f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    1866:	30 db                	xor    %bl,%bl
    1868:	e8 c3 24 00 00       	call   3d30 <sbrk>
    186d:	89 c6                	mov    %eax,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
    186f:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
    1872:	83 f8 ff             	cmp    $0xffffffff,%eax
    1875:	74 0d                	je     1884 <sbrktest+0x234>
      continue;
    kill(pids[i]);
    1877:	89 04 24             	mov    %eax,(%esp)
    187a:	e8 59 24 00 00       	call   3cd8 <kill>
    wait();
    187f:	e8 2c 24 00 00       	call   3cb0 <wait>
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    1884:	83 c3 01             	add    $0x1,%ebx
    1887:	83 fb 0a             	cmp    $0xa,%ebx
    188a:	75 e3                	jne    186f <sbrktest+0x21f>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    188c:	83 fe ff             	cmp    $0xffffffff,%esi
    188f:	0f 84 b7 00 00 00    	je     194c <sbrktest+0x2fc>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    1895:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    189c:	e8 8f 24 00 00       	call   3d30 <sbrk>
    18a1:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
    18a4:	73 19                	jae    18bf <sbrktest+0x26f>
    sbrk(-(sbrk(0) - oldbrk));
    18a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    18ad:	e8 7e 24 00 00       	call   3d30 <sbrk>
    18b2:	8b 55 a4             	mov    -0x5c(%ebp),%edx
    18b5:	29 c2                	sub    %eax,%edx
    18b7:	89 14 24             	mov    %edx,(%esp)
    18ba:	e8 71 24 00 00       	call   3d30 <sbrk>

  printf(stdout, "sbrk test OK\n");
    18bf:	a1 0c 59 00 00       	mov    0x590c,%eax
    18c4:	c7 44 24 04 28 48 00 	movl   $0x4828,0x4(%esp)
    18cb:	00 
    18cc:	89 04 24             	mov    %eax,(%esp)
    18cf:	e8 0c 25 00 00       	call   3de0 <printf>
}
    18d4:	83 c4 7c             	add    $0x7c,%esp
    18d7:	5b                   	pop    %ebx
    18d8:	5e                   	pop    %esi
    18d9:	5f                   	pop    %edi
    18da:	5d                   	pop    %ebp
    18db:	c3                   	ret    
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    18dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    18e3:	e8 48 24 00 00       	call   3d30 <sbrk>
    18e8:	ba 00 00 40 06       	mov    $0x6400000,%edx
    18ed:	29 c2                	sub    %eax,%edx
    18ef:	89 14 24             	mov    %edx,(%esp)
    18f2:	e8 39 24 00 00       	call   3d30 <sbrk>
      write(fds[1], "x", 1);
    18f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
    18fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1901:	00 
    1902:	c7 44 24 04 75 4d 00 	movl   $0x4d75,0x4(%esp)
    1909:	00 
    190a:	89 04 24             	mov    %eax,(%esp)
    190d:	e8 b6 23 00 00       	call   3cc8 <write>
    1912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      // sit around until killed
      for(;;) sleep(1000);
    1918:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    191f:	e8 14 24 00 00       	call   3d38 <sleep>
    1924:	eb f2                	jmp    1918 <sbrktest+0x2c8>
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){
    b = sbrk(1);
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    1926:	89 44 24 10          	mov    %eax,0x10(%esp)
    192a:	a1 0c 59 00 00       	mov    0x590c,%eax
    192f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1933:	89 74 24 08          	mov    %esi,0x8(%esp)
    1937:	c7 44 24 04 7c 47 00 	movl   $0x477c,0x4(%esp)
    193e:	00 
    193f:	89 04 24             	mov    %eax,(%esp)
    1942:	e8 99 24 00 00       	call   3de0 <printf>
      exit();
    1947:	e8 5c 23 00 00       	call   3ca8 <exit>
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    printf(stdout, "failed sbrk leaked memory\n");
    194c:	a1 0c 59 00 00       	mov    0x590c,%eax
    1951:	c7 44 24 04 0d 48 00 	movl   $0x480d,0x4(%esp)
    1958:	00 
    1959:	89 04 24             	mov    %eax,(%esp)
    195c:	e8 7f 24 00 00       	call   3de0 <printf>
    exit();
    1961:	e8 42 23 00 00       	call   3ca8 <exit>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    1966:	c7 44 24 04 fe 47 00 	movl   $0x47fe,0x4(%esp)
    196d:	00 
    196e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1975:	e8 66 24 00 00       	call   3de0 <printf>
    exit();
    197a:	e8 29 23 00 00       	call   3ca8 <exit>
    if(pid < 0){
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
      printf(stdout, "oops could read %x = %x\n", a, *a);
    197f:	0f be 03             	movsbl (%ebx),%eax
    1982:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1986:	c7 44 24 04 e5 47 00 	movl   $0x47e5,0x4(%esp)
    198d:	00 
    198e:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1992:	a1 0c 59 00 00       	mov    0x590c,%eax
    1997:	89 04 24             	mov    %eax,(%esp)
    199a:	e8 41 24 00 00       	call   3de0 <printf>
      kill(ppid);
    199f:	89 34 24             	mov    %esi,(%esp)
    19a2:	e8 31 23 00 00       	call   3cd8 <kill>
      exit();
    19a7:	e8 fc 22 00 00       	call   3ca8 <exit>
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    ppid = getpid();
    pid = fork();
    if(pid < 0){
      printf(stdout, "fork failed\n");
    19ac:	a1 0c 59 00 00       	mov    0x590c,%eax
    19b1:	c7 44 24 04 bf 45 00 	movl   $0x45bf,0x4(%esp)
    19b8:	00 
    19b9:	89 04 24             	mov    %eax,(%esp)
    19bc:	e8 1f 24 00 00       	call   3de0 <printf>
      exit();
    19c1:	e8 e2 22 00 00       	call   3ca8 <exit>
  }

  a = sbrk(0);
  c = sbrk(-(sbrk(0) - oldbrk));
  if(c != a){
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    19c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
    19ca:	a1 0c 59 00 00       	mov    0x590c,%eax
    19cf:	89 74 24 08          	mov    %esi,0x8(%esp)
    19d3:	c7 44 24 04 ac 54 00 	movl   $0x54ac,0x4(%esp)
    19da:	00 
    19db:	89 04 24             	mov    %eax,(%esp)
    19de:	e8 fd 23 00 00       	call   3de0 <printf>
    exit();
    19e3:	e8 c0 22 00 00       	call   3ca8 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    19e8:	a1 0c 59 00 00       	mov    0x590c,%eax
    19ed:	c7 44 24 04 7c 54 00 	movl   $0x547c,0x4(%esp)
    19f4:	00 
    19f5:	89 04 24             	mov    %eax,(%esp)
    19f8:	e8 e3 23 00 00       	call   3de0 <printf>
    exit();
    19fd:	e8 a6 22 00 00       	call   3ca8 <exit>

  // can one re-allocate that page?
  a = sbrk(0);
  c = sbrk(4096);
  if(c != a || sbrk(0) != a + 4096){
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    1a02:	a1 0c 59 00 00       	mov    0x590c,%eax
    1a07:	89 74 24 0c          	mov    %esi,0xc(%esp)
    1a0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1a0f:	c7 44 24 04 54 54 00 	movl   $0x5454,0x4(%esp)
    1a16:	00 
    1a17:	89 04 24             	mov    %eax,(%esp)
    1a1a:	e8 c1 23 00 00       	call   3de0 <printf>
    exit();
    1a1f:	e8 84 22 00 00       	call   3ca8 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
  if(c != a - 4096){
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    1a24:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1a28:	a1 0c 59 00 00       	mov    0x590c,%eax
    1a2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1a31:	c7 44 24 04 1c 54 00 	movl   $0x541c,0x4(%esp)
    1a38:	00 
    1a39:	89 04 24             	mov    %eax,(%esp)
    1a3c:	e8 9f 23 00 00       	call   3de0 <printf>
    exit();
    1a41:	e8 62 22 00 00       	call   3ca8 <exit>

  // can one de-allocate?
  a = sbrk(0);
  c = sbrk(-4096);
  if(c == (char*)0xffffffff){
    printf(stdout, "sbrk could not deallocate\n");
    1a46:	a1 0c 59 00 00       	mov    0x590c,%eax
    1a4b:	c7 44 24 04 ca 47 00 	movl   $0x47ca,0x4(%esp)
    1a52:	00 
    1a53:	89 04 24             	mov    %eax,(%esp)
    1a56:	e8 85 23 00 00       	call   3de0 <printf>
    exit();
    1a5b:	e8 48 22 00 00       	call   3ca8 <exit>
#define BIG (100*1024*1024)
  a = sbrk(0);
  amt = (BIG) - (uint)a;
  p = sbrk(amt);
  if (p != a) {
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    1a60:	a1 0c 59 00 00       	mov    0x590c,%eax
    1a65:	c7 44 24 04 dc 53 00 	movl   $0x53dc,0x4(%esp)
    1a6c:	00 
    1a6d:	89 04 24             	mov    %eax,(%esp)
    1a70:	e8 6b 23 00 00       	call   3de0 <printf>
    exit();
    1a75:	e8 2e 22 00 00       	call   3ca8 <exit>
    exit();
  }
  c = sbrk(1);
  c = sbrk(1);
  if(c != a + 1){
    printf(stdout, "sbrk test failed post-fork\n");
    1a7a:	a1 0c 59 00 00       	mov    0x590c,%eax
    1a7f:	c7 44 24 04 ae 47 00 	movl   $0x47ae,0x4(%esp)
    1a86:	00 
    1a87:	89 04 24             	mov    %eax,(%esp)
    1a8a:	e8 51 23 00 00       	call   3de0 <printf>
    exit();
    1a8f:	e8 14 22 00 00       	call   3ca8 <exit>
    *b = 1;
    a = b + 1;
  }
  pid = fork();
  if(pid < 0){
    printf(stdout, "sbrk test fork failed\n");
    1a94:	a1 0c 59 00 00       	mov    0x590c,%eax
    1a99:	c7 44 24 04 97 47 00 	movl   $0x4797,0x4(%esp)
    1aa0:	00 
    1aa1:	89 04 24             	mov    %eax,(%esp)
    1aa4:	e8 37 23 00 00       	call   3de0 <printf>
    exit();
    1aa9:	e8 fa 21 00 00       	call   3ca8 <exit>
    1aae:	66 90                	xchg   %ax,%ax

00001ab0 <preempt>:
}

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    1ab0:	55                   	push   %ebp
    1ab1:	89 e5                	mov    %esp,%ebp
    1ab3:	57                   	push   %edi
    1ab4:	56                   	push   %esi
    1ab5:	53                   	push   %ebx
    1ab6:	83 ec 2c             	sub    $0x2c,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    1ab9:	c7 44 24 04 36 48 00 	movl   $0x4836,0x4(%esp)
    1ac0:	00 
    1ac1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ac8:	e8 13 23 00 00       	call   3de0 <printf>
  pid1 = fork();
    1acd:	e8 ce 21 00 00       	call   3ca0 <fork>
  if(pid1 == 0)
    1ad2:	85 c0                	test   %eax,%eax
{
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
  pid1 = fork();
    1ad4:	89 c7                	mov    %eax,%edi
  if(pid1 == 0)
    1ad6:	75 02                	jne    1ada <preempt+0x2a>
    1ad8:	eb fe                	jmp    1ad8 <preempt+0x28>
    1ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(;;)
      ;

  pid2 = fork();
    1ae0:	e8 bb 21 00 00       	call   3ca0 <fork>
  if(pid2 == 0)
    1ae5:	85 c0                	test   %eax,%eax
  pid1 = fork();
  if(pid1 == 0)
    for(;;)
      ;

  pid2 = fork();
    1ae7:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
    1ae9:	75 02                	jne    1aed <preempt+0x3d>
    1aeb:	eb fe                	jmp    1aeb <preempt+0x3b>
    for(;;)
      ;

  pipe(pfds);
    1aed:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1af0:	89 04 24             	mov    %eax,(%esp)
    1af3:	e8 c0 21 00 00       	call   3cb8 <pipe>
  pid3 = fork();
    1af8:	e8 a3 21 00 00       	call   3ca0 <fork>
  if(pid3 == 0){
    1afd:	85 c0                	test   %eax,%eax
  if(pid2 == 0)
    for(;;)
      ;

  pipe(pfds);
  pid3 = fork();
    1aff:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
    1b01:	75 4c                	jne    1b4f <preempt+0x9f>
    close(pfds[0]);
    1b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1b06:	89 04 24             	mov    %eax,(%esp)
    1b09:	e8 c2 21 00 00       	call   3cd0 <close>
    if(write(pfds[1], "x", 1) != 1)
    1b0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1b11:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1b18:	00 
    1b19:	c7 44 24 04 75 4d 00 	movl   $0x4d75,0x4(%esp)
    1b20:	00 
    1b21:	89 04 24             	mov    %eax,(%esp)
    1b24:	e8 9f 21 00 00       	call   3cc8 <write>
    1b29:	83 f8 01             	cmp    $0x1,%eax
    1b2c:	74 14                	je     1b42 <preempt+0x92>
      printf(1, "preempt write error");
    1b2e:	c7 44 24 04 40 48 00 	movl   $0x4840,0x4(%esp)
    1b35:	00 
    1b36:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b3d:	e8 9e 22 00 00       	call   3de0 <printf>
    close(pfds[1]);
    1b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1b45:	89 04 24             	mov    %eax,(%esp)
    1b48:	e8 83 21 00 00       	call   3cd0 <close>
    1b4d:	eb fe                	jmp    1b4d <preempt+0x9d>
    for(;;)
      ;
  }

  close(pfds[1]);
    1b4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1b52:	89 04 24             	mov    %eax,(%esp)
    1b55:	e8 76 21 00 00       	call   3cd0 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1b5d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1b64:	00 
    1b65:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    1b6c:	00 
    1b6d:	89 04 24             	mov    %eax,(%esp)
    1b70:	e8 4b 21 00 00       	call   3cc0 <read>
    1b75:	83 f8 01             	cmp    $0x1,%eax
    1b78:	74 1c                	je     1b96 <preempt+0xe6>
    printf(1, "preempt read error");
    1b7a:	c7 44 24 04 54 48 00 	movl   $0x4854,0x4(%esp)
    1b81:	00 
    1b82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b89:	e8 52 22 00 00       	call   3de0 <printf>
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
    1b8e:	83 c4 2c             	add    $0x2c,%esp
    1b91:	5b                   	pop    %ebx
    1b92:	5e                   	pop    %esi
    1b93:	5f                   	pop    %edi
    1b94:	5d                   	pop    %ebp
    1b95:	c3                   	ret    
  close(pfds[1]);
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    printf(1, "preempt read error");
    return;
  }
  close(pfds[0]);
    1b96:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1b99:	89 04 24             	mov    %eax,(%esp)
    1b9c:	e8 2f 21 00 00       	call   3cd0 <close>
  printf(1, "kill... ");
    1ba1:	c7 44 24 04 67 48 00 	movl   $0x4867,0x4(%esp)
    1ba8:	00 
    1ba9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bb0:	e8 2b 22 00 00       	call   3de0 <printf>
  kill(pid1);
    1bb5:	89 3c 24             	mov    %edi,(%esp)
    1bb8:	e8 1b 21 00 00       	call   3cd8 <kill>
  kill(pid2);
    1bbd:	89 34 24             	mov    %esi,(%esp)
    1bc0:	e8 13 21 00 00       	call   3cd8 <kill>
  kill(pid3);
    1bc5:	89 1c 24             	mov    %ebx,(%esp)
    1bc8:	e8 0b 21 00 00       	call   3cd8 <kill>
  printf(1, "wait... ");
    1bcd:	c7 44 24 04 70 48 00 	movl   $0x4870,0x4(%esp)
    1bd4:	00 
    1bd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bdc:	e8 ff 21 00 00       	call   3de0 <printf>
  wait();
    1be1:	e8 ca 20 00 00       	call   3cb0 <wait>
  wait();
    1be6:	e8 c5 20 00 00       	call   3cb0 <wait>
    1beb:	90                   	nop
    1bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  wait();
    1bf0:	e8 bb 20 00 00       	call   3cb0 <wait>
  printf(1, "preempt ok\n");
    1bf5:	c7 44 24 04 79 48 00 	movl   $0x4879,0x4(%esp)
    1bfc:	00 
    1bfd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c04:	e8 d7 21 00 00       	call   3de0 <printf>
    1c09:	eb 83                	jmp    1b8e <preempt+0xde>
    1c0b:	90                   	nop
    1c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001c10 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    1c10:	55                   	push   %ebp
    1c11:	89 e5                	mov    %esp,%ebp
    1c13:	57                   	push   %edi
    1c14:	56                   	push   %esi
    1c15:	53                   	push   %ebx
    1c16:	83 ec 2c             	sub    $0x2c,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    1c19:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1c1c:	89 04 24             	mov    %eax,(%esp)
    1c1f:	e8 94 20 00 00       	call   3cb8 <pipe>
    1c24:	85 c0                	test   %eax,%eax
    1c26:	0f 85 3b 01 00 00    	jne    1d67 <pipe1+0x157>
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
    1c2c:	e8 6f 20 00 00       	call   3ca0 <fork>
  seq = 0;
  if(pid == 0){
    1c31:	83 f8 00             	cmp    $0x0,%eax
    1c34:	0f 84 80 00 00 00    	je     1cba <pipe1+0xaa>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
    1c3a:	0f 8e 40 01 00 00    	jle    1d80 <pipe1+0x170>
    close(fds[1]);
    1c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1c43:	31 ff                	xor    %edi,%edi
    1c45:	be 01 00 00 00       	mov    $0x1,%esi
    1c4a:	31 db                	xor    %ebx,%ebx
    1c4c:	89 04 24             	mov    %eax,(%esp)
    1c4f:	e8 7c 20 00 00       	call   3cd0 <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
    1c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1c57:	89 74 24 08          	mov    %esi,0x8(%esp)
    1c5b:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    1c62:	00 
    1c63:	89 04 24             	mov    %eax,(%esp)
    1c66:	e8 55 20 00 00       	call   3cc0 <read>
    1c6b:	85 c0                	test   %eax,%eax
    1c6d:	0f 8e a9 00 00 00    	jle    1d1c <pipe1+0x10c>
    1c73:	31 d2                	xor    %edx,%edx
    1c75:	8d 76 00             	lea    0x0(%esi),%esi
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1c78:	38 9a e0 80 00 00    	cmp    %bl,0x80e0(%edx)
    1c7e:	75 1e                	jne    1c9e <pipe1+0x8e>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    1c80:	83 c2 01             	add    $0x1,%edx
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1c83:	83 c3 01             	add    $0x1,%ebx
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    1c86:	39 d0                	cmp    %edx,%eax
    1c88:	7f ee                	jg     1c78 <pipe1+0x68>
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
      cc = cc * 2;
    1c8a:	01 f6                	add    %esi,%esi
      if(cc > sizeof(buf))
    1c8c:	ba 00 20 00 00       	mov    $0x2000,%edx
    1c91:	81 fe 01 20 00 00    	cmp    $0x2001,%esi
    1c97:	0f 43 f2             	cmovae %edx,%esi
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
    1c9a:	01 c7                	add    %eax,%edi
    1c9c:	eb b6                	jmp    1c54 <pipe1+0x44>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
    1c9e:	c7 44 24 04 93 48 00 	movl   $0x4893,0x4(%esp)
    1ca5:	00 
    1ca6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cad:	e8 2e 21 00 00       	call   3de0 <printf>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
    1cb2:	83 c4 2c             	add    $0x2c,%esp
    1cb5:	5b                   	pop    %ebx
    1cb6:	5e                   	pop    %esi
    1cb7:	5f                   	pop    %edi
    1cb8:	5d                   	pop    %ebp
    1cb9:	c3                   	ret    
    exit();
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    1cba:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1cbd:	31 db                	xor    %ebx,%ebx
    1cbf:	89 04 24             	mov    %eax,(%esp)
    1cc2:	e8 09 20 00 00       	call   3cd0 <close>
    for(n = 0; n < 5; n++){
    1cc7:	31 c0                	xor    %eax,%eax
    1cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
    1cd0:	8d 14 03             	lea    (%ebx,%eax,1),%edx
    1cd3:	88 90 e0 80 00 00    	mov    %dl,0x80e0(%eax)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    1cd9:	83 c0 01             	add    $0x1,%eax
    1cdc:	3d 09 04 00 00       	cmp    $0x409,%eax
    1ce1:	75 ed                	jne    1cd0 <pipe1+0xc0>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    1ce3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    1ce6:	81 c3 09 04 00 00    	add    $0x409,%ebx
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    1cec:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
    1cf3:	00 
    1cf4:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    1cfb:	00 
    1cfc:	89 04 24             	mov    %eax,(%esp)
    1cff:	e8 c4 1f 00 00       	call   3cc8 <write>
    1d04:	3d 09 04 00 00       	cmp    $0x409,%eax
    1d09:	0f 85 8a 00 00 00    	jne    1d99 <pipe1+0x189>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
    1d0f:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
    1d15:	75 b0                	jne    1cc7 <pipe1+0xb7>
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
      printf(1, "pipe1 oops 3 total %d\n", total);
      exit();
    1d17:	e8 8c 1f 00 00       	call   3ca8 <exit>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
    1d1c:	81 ff 2d 14 00 00    	cmp    $0x142d,%edi
    1d22:	75 29                	jne    1d4d <pipe1+0x13d>
      printf(1, "pipe1 oops 3 total %d\n", total);
      exit();
    }
    close(fds[0]);
    1d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1d27:	89 04 24             	mov    %eax,(%esp)
    1d2a:	e8 a1 1f 00 00       	call   3cd0 <close>
    wait();
    1d2f:	e8 7c 1f 00 00       	call   3cb0 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
    1d34:	c7 44 24 04 b8 48 00 	movl   $0x48b8,0x4(%esp)
    1d3b:	00 
    1d3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d43:	e8 98 20 00 00       	call   3de0 <printf>
    1d48:	e9 65 ff ff ff       	jmp    1cb2 <pipe1+0xa2>
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
      printf(1, "pipe1 oops 3 total %d\n", total);
    1d4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
    1d51:	c7 44 24 04 a1 48 00 	movl   $0x48a1,0x4(%esp)
    1d58:	00 
    1d59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d60:	e8 7b 20 00 00       	call   3de0 <printf>
    1d65:	eb b0                	jmp    1d17 <pipe1+0x107>
{
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    1d67:	c7 44 24 04 fe 47 00 	movl   $0x47fe,0x4(%esp)
    1d6e:	00 
    1d6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d76:	e8 65 20 00 00       	call   3de0 <printf>
    exit();
    1d7b:	e8 28 1f 00 00       	call   3ca8 <exit>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    1d80:	c7 44 24 04 c2 48 00 	movl   $0x48c2,0x4(%esp)
    1d87:	00 
    1d88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d8f:	e8 4c 20 00 00       	call   3de0 <printf>
    exit();
    1d94:	e8 0f 1f 00 00       	call   3ca8 <exit>
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
    1d99:	c7 44 24 04 85 48 00 	movl   $0x4885,0x4(%esp)
    1da0:	00 
    1da1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1da8:	e8 33 20 00 00       	call   3de0 <printf>
        exit();
    1dad:	e8 f6 1e 00 00       	call   3ca8 <exit>
    1db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001dc0 <fourteen>:
  printf(1, "bigfile test ok\n");
}

void
fourteen(void)
{
    1dc0:	55                   	push   %ebp
    1dc1:	89 e5                	mov    %esp,%ebp
    1dc3:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    1dc6:	c7 44 24 04 d1 48 00 	movl   $0x48d1,0x4(%esp)
    1dcd:	00 
    1dce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dd5:	e8 06 20 00 00       	call   3de0 <printf>

  if(mkdir("12345678901234") != 0){
    1dda:	c7 04 24 0c 49 00 00 	movl   $0x490c,(%esp)
    1de1:	e8 2a 1f 00 00       	call   3d10 <mkdir>
    1de6:	85 c0                	test   %eax,%eax
    1de8:	0f 85 92 00 00 00    	jne    1e80 <fourteen+0xc0>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    1dee:	c7 04 24 d0 54 00 00 	movl   $0x54d0,(%esp)
    1df5:	e8 16 1f 00 00       	call   3d10 <mkdir>
    1dfa:	85 c0                	test   %eax,%eax
    1dfc:	0f 85 fb 00 00 00    	jne    1efd <fourteen+0x13d>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    1e02:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1e09:	00 
    1e0a:	c7 04 24 20 55 00 00 	movl   $0x5520,(%esp)
    1e11:	e8 d2 1e 00 00       	call   3ce8 <open>
  if(fd < 0){
    1e16:	85 c0                	test   %eax,%eax
    1e18:	0f 88 c6 00 00 00    	js     1ee4 <fourteen+0x124>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    1e1e:	89 04 24             	mov    %eax,(%esp)
    1e21:	e8 aa 1e 00 00       	call   3cd0 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    1e26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1e2d:	00 
    1e2e:	c7 04 24 90 55 00 00 	movl   $0x5590,(%esp)
    1e35:	e8 ae 1e 00 00       	call   3ce8 <open>
  if(fd < 0){
    1e3a:	85 c0                	test   %eax,%eax
    1e3c:	0f 88 89 00 00 00    	js     1ecb <fourteen+0x10b>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    1e42:	89 04 24             	mov    %eax,(%esp)
    1e45:	e8 86 1e 00 00       	call   3cd0 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    1e4a:	c7 04 24 fd 48 00 00 	movl   $0x48fd,(%esp)
    1e51:	e8 ba 1e 00 00       	call   3d10 <mkdir>
    1e56:	85 c0                	test   %eax,%eax
    1e58:	74 58                	je     1eb2 <fourteen+0xf2>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    1e5a:	c7 04 24 2c 56 00 00 	movl   $0x562c,(%esp)
    1e61:	e8 aa 1e 00 00       	call   3d10 <mkdir>
    1e66:	85 c0                	test   %eax,%eax
    1e68:	74 2f                	je     1e99 <fourteen+0xd9>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
    1e6a:	c7 44 24 04 1b 49 00 	movl   $0x491b,0x4(%esp)
    1e71:	00 
    1e72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e79:	e8 62 1f 00 00       	call   3de0 <printf>
}
    1e7e:	c9                   	leave  
    1e7f:	c3                   	ret    

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");

  if(mkdir("12345678901234") != 0){
    printf(1, "mkdir 12345678901234 failed\n");
    1e80:	c7 44 24 04 e0 48 00 	movl   $0x48e0,0x4(%esp)
    1e87:	00 
    1e88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e8f:	e8 4c 1f 00 00       	call   3de0 <printf>
    exit();
    1e94:	e8 0f 1e 00 00       	call   3ca8 <exit>
  if(mkdir("12345678901234/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    1e99:	c7 44 24 04 4c 56 00 	movl   $0x564c,0x4(%esp)
    1ea0:	00 
    1ea1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ea8:	e8 33 1f 00 00       	call   3de0 <printf>
    exit();
    1ead:	e8 f6 1d 00 00       	call   3ca8 <exit>
    exit();
  }
  close(fd);

  if(mkdir("12345678901234/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    1eb2:	c7 44 24 04 fc 55 00 	movl   $0x55fc,0x4(%esp)
    1eb9:	00 
    1eba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ec1:	e8 1a 1f 00 00       	call   3de0 <printf>
    exit();
    1ec6:	e8 dd 1d 00 00       	call   3ca8 <exit>
    exit();
  }
  close(fd);
  fd = open("12345678901234/12345678901234/12345678901234", 0);
  if(fd < 0){
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    1ecb:	c7 44 24 04 c0 55 00 	movl   $0x55c0,0x4(%esp)
    1ed2:	00 
    1ed3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eda:	e8 01 1f 00 00       	call   3de0 <printf>
    exit();
    1edf:	e8 c4 1d 00 00       	call   3ca8 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
  if(fd < 0){
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    1ee4:	c7 44 24 04 50 55 00 	movl   $0x5550,0x4(%esp)
    1eeb:	00 
    1eec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ef3:	e8 e8 1e 00 00       	call   3de0 <printf>
    exit();
    1ef8:	e8 ab 1d 00 00       	call   3ca8 <exit>
  if(mkdir("12345678901234") != 0){
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    1efd:	c7 44 24 04 f0 54 00 	movl   $0x54f0,0x4(%esp)
    1f04:	00 
    1f05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f0c:	e8 cf 1e 00 00       	call   3de0 <printf>
    exit();
    1f11:	e8 92 1d 00 00       	call   3ca8 <exit>
    1f16:	8d 76 00             	lea    0x0(%esi),%esi
    1f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001f20 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
    1f20:	55                   	push   %ebp
    1f21:	89 e5                	mov    %esp,%ebp
    1f23:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
    1f26:	a1 0c 59 00 00       	mov    0x590c,%eax
    1f2b:	c7 44 24 04 28 49 00 	movl   $0x4928,0x4(%esp)
    1f32:	00 
    1f33:	89 04 24             	mov    %eax,(%esp)
    1f36:	e8 a5 1e 00 00       	call   3de0 <printf>
  if(mkdir("oidir") < 0){
    1f3b:	c7 04 24 37 49 00 00 	movl   $0x4937,(%esp)
    1f42:	e8 c9 1d 00 00       	call   3d10 <mkdir>
    1f47:	85 c0                	test   %eax,%eax
    1f49:	0f 88 9e 00 00 00    	js     1fed <openiputtest+0xcd>
    printf(stdout, "mkdir oidir failed\n");
    exit();
  }
  pid = fork();
    1f4f:	e8 4c 1d 00 00       	call   3ca0 <fork>
  if(pid < 0){
    1f54:	83 f8 00             	cmp    $0x0,%eax
    1f57:	0f 8c aa 00 00 00    	jl     2007 <openiputtest+0xe7>
    1f5d:	8d 76 00             	lea    0x0(%esi),%esi
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
    1f60:	75 36                	jne    1f98 <openiputtest+0x78>
    int fd = open("oidir", O_RDWR);
    1f62:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1f69:	00 
    1f6a:	c7 04 24 37 49 00 00 	movl   $0x4937,(%esp)
    1f71:	e8 72 1d 00 00       	call   3ce8 <open>
    if(fd >= 0){
    1f76:	85 c0                	test   %eax,%eax
    1f78:	78 6e                	js     1fe8 <openiputtest+0xc8>
      printf(stdout, "open directory for write succeeded\n");
    1f7a:	a1 0c 59 00 00       	mov    0x590c,%eax
    1f7f:	c7 44 24 04 80 56 00 	movl   $0x5680,0x4(%esp)
    1f86:	00 
    1f87:	89 04 24             	mov    %eax,(%esp)
    1f8a:	e8 51 1e 00 00       	call   3de0 <printf>
      exit();
    1f8f:	e8 14 1d 00 00       	call   3ca8 <exit>
    1f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    exit();
  }
  sleep(1);
    1f98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f9f:	e8 94 1d 00 00       	call   3d38 <sleep>
  if(unlink("oidir") != 0){
    1fa4:	c7 04 24 37 49 00 00 	movl   $0x4937,(%esp)
    1fab:	e8 48 1d 00 00       	call   3cf8 <unlink>
    1fb0:	85 c0                	test   %eax,%eax
    1fb2:	75 1c                	jne    1fd0 <openiputtest+0xb0>
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
    1fb4:	e8 f7 1c 00 00       	call   3cb0 <wait>
  printf(stdout, "openiput test ok\n");
    1fb9:	a1 0c 59 00 00       	mov    0x590c,%eax
    1fbe:	c7 44 24 04 51 49 00 	movl   $0x4951,0x4(%esp)
    1fc5:	00 
    1fc6:	89 04 24             	mov    %eax,(%esp)
    1fc9:	e8 12 1e 00 00       	call   3de0 <printf>
}
    1fce:	c9                   	leave  
    1fcf:	c3                   	ret    
    }
    exit();
  }
  sleep(1);
  if(unlink("oidir") != 0){
    printf(stdout, "unlink failed\n");
    1fd0:	a1 0c 59 00 00       	mov    0x590c,%eax
    1fd5:	c7 44 24 04 de 43 00 	movl   $0x43de,0x4(%esp)
    1fdc:	00 
    1fdd:	89 04 24             	mov    %eax,(%esp)
    1fe0:	e8 fb 1d 00 00       	call   3de0 <printf>
    1fe5:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
    1fe8:	e8 bb 1c 00 00       	call   3ca8 <exit>
{
  int pid;

  printf(stdout, "openiput test\n");
  if(mkdir("oidir") < 0){
    printf(stdout, "mkdir oidir failed\n");
    1fed:	a1 0c 59 00 00       	mov    0x590c,%eax
    1ff2:	c7 44 24 04 3d 49 00 	movl   $0x493d,0x4(%esp)
    1ff9:	00 
    1ffa:	89 04 24             	mov    %eax,(%esp)
    1ffd:	e8 de 1d 00 00       	call   3de0 <printf>
    exit();
    2002:	e8 a1 1c 00 00       	call   3ca8 <exit>
  }
  pid = fork();
  if(pid < 0){
    printf(stdout, "fork failed\n");
    2007:	a1 0c 59 00 00       	mov    0x590c,%eax
    200c:	c7 44 24 04 bf 45 00 	movl   $0x45bf,0x4(%esp)
    2013:	00 
    2014:	89 04 24             	mov    %eax,(%esp)
    2017:	e8 c4 1d 00 00       	call   3de0 <printf>
    exit();
    201c:	e8 87 1c 00 00       	call   3ca8 <exit>
    2021:	eb 0d                	jmp    2030 <iref>
    2023:	90                   	nop
    2024:	90                   	nop
    2025:	90                   	nop
    2026:	90                   	nop
    2027:	90                   	nop
    2028:	90                   	nop
    2029:	90                   	nop
    202a:	90                   	nop
    202b:	90                   	nop
    202c:	90                   	nop
    202d:	90                   	nop
    202e:	90                   	nop
    202f:	90                   	nop

00002030 <iref>:
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2030:	55                   	push   %ebp
    2031:	89 e5                	mov    %esp,%ebp
    2033:	53                   	push   %ebx
  int i, fd;

  printf(1, "empty file name\n");
    2034:	31 db                	xor    %ebx,%ebx
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2036:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2039:	c7 44 24 04 63 49 00 	movl   $0x4963,0x4(%esp)
    2040:	00 
    2041:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2048:	e8 93 1d 00 00       	call   3de0 <printf>
    204d:	8d 76 00             	lea    0x0(%esi),%esi

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
    2050:	c7 04 24 74 49 00 00 	movl   $0x4974,(%esp)
    2057:	e8 b4 1c 00 00       	call   3d10 <mkdir>
    205c:	85 c0                	test   %eax,%eax
    205e:	0f 85 b2 00 00 00    	jne    2116 <iref+0xe6>
      printf(1, "mkdir irefd failed\n");
      exit();
    }
    if(chdir("irefd") != 0){
    2064:	c7 04 24 74 49 00 00 	movl   $0x4974,(%esp)
    206b:	e8 a8 1c 00 00       	call   3d18 <chdir>
    2070:	85 c0                	test   %eax,%eax
    2072:	0f 85 b7 00 00 00    	jne    212f <iref+0xff>
      printf(1, "chdir irefd failed\n");
      exit();
    }

    mkdir("");
    2078:	c7 04 24 2d 51 00 00 	movl   $0x512d,(%esp)
    207f:	e8 8c 1c 00 00       	call   3d10 <mkdir>
    link("README", "");
    2084:	c7 44 24 04 2d 51 00 	movl   $0x512d,0x4(%esp)
    208b:	00 
    208c:	c7 04 24 a2 49 00 00 	movl   $0x49a2,(%esp)
    2093:	e8 70 1c 00 00       	call   3d08 <link>
    fd = open("", O_CREATE);
    2098:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    209f:	00 
    20a0:	c7 04 24 2d 51 00 00 	movl   $0x512d,(%esp)
    20a7:	e8 3c 1c 00 00       	call   3ce8 <open>
    if(fd >= 0)
    20ac:	85 c0                	test   %eax,%eax
    20ae:	78 08                	js     20b8 <iref+0x88>
      close(fd);
    20b0:	89 04 24             	mov    %eax,(%esp)
    20b3:	e8 18 1c 00 00       	call   3cd0 <close>
    fd = open("xx", O_CREATE);
    20b8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    20bf:	00 
    20c0:	c7 04 24 74 4d 00 00 	movl   $0x4d74,(%esp)
    20c7:	e8 1c 1c 00 00       	call   3ce8 <open>
    if(fd >= 0)
    20cc:	85 c0                	test   %eax,%eax
    20ce:	78 08                	js     20d8 <iref+0xa8>
      close(fd);
    20d0:	89 04 24             	mov    %eax,(%esp)
    20d3:	e8 f8 1b 00 00       	call   3cd0 <close>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    20d8:	83 c3 01             	add    $0x1,%ebx
    if(fd >= 0)
      close(fd);
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    20db:	c7 04 24 74 4d 00 00 	movl   $0x4d74,(%esp)
    20e2:	e8 11 1c 00 00       	call   3cf8 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    20e7:	83 fb 33             	cmp    $0x33,%ebx
    20ea:	0f 85 60 ff ff ff    	jne    2050 <iref+0x20>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    20f0:	c7 04 24 a9 49 00 00 	movl   $0x49a9,(%esp)
    20f7:	e8 1c 1c 00 00       	call   3d18 <chdir>
  printf(1, "empty file name OK\n");
    20fc:	c7 44 24 04 ab 49 00 	movl   $0x49ab,0x4(%esp)
    2103:	00 
    2104:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    210b:	e8 d0 1c 00 00       	call   3de0 <printf>
}
    2110:	83 c4 14             	add    $0x14,%esp
    2113:	5b                   	pop    %ebx
    2114:	5d                   	pop    %ebp
    2115:	c3                   	ret    
  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    2116:	c7 44 24 04 7a 49 00 	movl   $0x497a,0x4(%esp)
    211d:	00 
    211e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2125:	e8 b6 1c 00 00       	call   3de0 <printf>
      exit();
    212a:	e8 79 1b 00 00       	call   3ca8 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    212f:	c7 44 24 04 8e 49 00 	movl   $0x498e,0x4(%esp)
    2136:	00 
    2137:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    213e:	e8 9d 1c 00 00       	call   3de0 <printf>
      exit();
    2143:	e8 60 1b 00 00       	call   3ca8 <exit>
    2148:	90                   	nop
    2149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00002150 <dirfile>:
  printf(1, "rmdot ok\n");
}

void
dirfile(void)
{
    2150:	55                   	push   %ebp
    2151:	89 e5                	mov    %esp,%ebp
    2153:	53                   	push   %ebx
    2154:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "dir vs file\n");
    2157:	c7 44 24 04 bf 49 00 	movl   $0x49bf,0x4(%esp)
    215e:	00 
    215f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2166:	e8 75 1c 00 00       	call   3de0 <printf>

  fd = open("dirfile", O_CREATE);
    216b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2172:	00 
    2173:	c7 04 24 cc 49 00 00 	movl   $0x49cc,(%esp)
    217a:	e8 69 1b 00 00       	call   3ce8 <open>
  if(fd < 0){
    217f:	85 c0                	test   %eax,%eax
    2181:	0f 88 4e 01 00 00    	js     22d5 <dirfile+0x185>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    2187:	89 04 24             	mov    %eax,(%esp)
    218a:	e8 41 1b 00 00       	call   3cd0 <close>
  if(chdir("dirfile") == 0){
    218f:	c7 04 24 cc 49 00 00 	movl   $0x49cc,(%esp)
    2196:	e8 7d 1b 00 00       	call   3d18 <chdir>
    219b:	85 c0                	test   %eax,%eax
    219d:	0f 84 19 01 00 00    	je     22bc <dirfile+0x16c>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    21a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    21aa:	00 
    21ab:	c7 04 24 05 4a 00 00 	movl   $0x4a05,(%esp)
    21b2:	e8 31 1b 00 00       	call   3ce8 <open>
  if(fd >= 0){
    21b7:	85 c0                	test   %eax,%eax
    21b9:	0f 89 e4 00 00 00    	jns    22a3 <dirfile+0x153>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    21bf:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    21c6:	00 
    21c7:	c7 04 24 05 4a 00 00 	movl   $0x4a05,(%esp)
    21ce:	e8 15 1b 00 00       	call   3ce8 <open>
  if(fd >= 0){
    21d3:	85 c0                	test   %eax,%eax
    21d5:	0f 89 c8 00 00 00    	jns    22a3 <dirfile+0x153>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    21db:	c7 04 24 05 4a 00 00 	movl   $0x4a05,(%esp)
    21e2:	e8 29 1b 00 00       	call   3d10 <mkdir>
    21e7:	85 c0                	test   %eax,%eax
    21e9:	0f 84 7c 01 00 00    	je     236b <dirfile+0x21b>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    21ef:	c7 04 24 05 4a 00 00 	movl   $0x4a05,(%esp)
    21f6:	e8 fd 1a 00 00       	call   3cf8 <unlink>
    21fb:	85 c0                	test   %eax,%eax
    21fd:	0f 84 4f 01 00 00    	je     2352 <dirfile+0x202>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    2203:	c7 44 24 04 05 4a 00 	movl   $0x4a05,0x4(%esp)
    220a:	00 
    220b:	c7 04 24 a2 49 00 00 	movl   $0x49a2,(%esp)
    2212:	e8 f1 1a 00 00       	call   3d08 <link>
    2217:	85 c0                	test   %eax,%eax
    2219:	0f 84 1a 01 00 00    	je     2339 <dirfile+0x1e9>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    221f:	c7 04 24 cc 49 00 00 	movl   $0x49cc,(%esp)
    2226:	e8 cd 1a 00 00       	call   3cf8 <unlink>
    222b:	85 c0                	test   %eax,%eax
    222d:	0f 85 ed 00 00 00    	jne    2320 <dirfile+0x1d0>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    2233:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    223a:	00 
    223b:	c7 04 24 92 4c 00 00 	movl   $0x4c92,(%esp)
    2242:	e8 a1 1a 00 00       	call   3ce8 <open>
  if(fd >= 0){
    2247:	85 c0                	test   %eax,%eax
    2249:	0f 89 b8 00 00 00    	jns    2307 <dirfile+0x1b7>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    224f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2256:	00 
    2257:	c7 04 24 92 4c 00 00 	movl   $0x4c92,(%esp)
    225e:	e8 85 1a 00 00       	call   3ce8 <open>
  if(write(fd, "x", 1) > 0){
    2263:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    226a:	00 
    226b:	c7 44 24 04 75 4d 00 	movl   $0x4d75,0x4(%esp)
    2272:	00 
  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    2273:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2275:	89 04 24             	mov    %eax,(%esp)
    2278:	e8 4b 1a 00 00       	call   3cc8 <write>
    227d:	85 c0                	test   %eax,%eax
    227f:	7f 6d                	jg     22ee <dirfile+0x19e>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
    2281:	89 1c 24             	mov    %ebx,(%esp)
    2284:	e8 47 1a 00 00       	call   3cd0 <close>

  printf(1, "dir vs file OK\n");
    2289:	c7 44 24 04 95 4a 00 	movl   $0x4a95,0x4(%esp)
    2290:	00 
    2291:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2298:	e8 43 1b 00 00       	call   3de0 <printf>
}
    229d:	83 c4 14             	add    $0x14,%esp
    22a0:	5b                   	pop    %ebx
    22a1:	5d                   	pop    %ebp
    22a2:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
    22a3:	c7 44 24 04 10 4a 00 	movl   $0x4a10,0x4(%esp)
    22aa:	00 
    22ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22b2:	e8 29 1b 00 00       	call   3de0 <printf>
    exit();
    22b7:	e8 ec 19 00 00       	call   3ca8 <exit>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
  if(chdir("dirfile") == 0){
    printf(1, "chdir dirfile succeeded!\n");
    22bc:	c7 44 24 04 eb 49 00 	movl   $0x49eb,0x4(%esp)
    22c3:	00 
    22c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22cb:	e8 10 1b 00 00       	call   3de0 <printf>
    exit();
    22d0:	e8 d3 19 00 00       	call   3ca8 <exit>

  printf(1, "dir vs file\n");

  fd = open("dirfile", O_CREATE);
  if(fd < 0){
    printf(1, "create dirfile failed\n");
    22d5:	c7 44 24 04 d4 49 00 	movl   $0x49d4,0x4(%esp)
    22dc:	00 
    22dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22e4:	e8 f7 1a 00 00       	call   3de0 <printf>
    exit();
    22e9:	e8 ba 19 00 00       	call   3ca8 <exit>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
  if(write(fd, "x", 1) > 0){
    printf(1, "write . succeeded!\n");
    22ee:	c7 44 24 04 81 4a 00 	movl   $0x4a81,0x4(%esp)
    22f5:	00 
    22f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22fd:	e8 de 1a 00 00       	call   3de0 <printf>
    exit();
    2302:	e8 a1 19 00 00       	call   3ca8 <exit>
    exit();
  }

  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
    2307:	c7 44 24 04 c4 56 00 	movl   $0x56c4,0x4(%esp)
    230e:	00 
    230f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2316:	e8 c5 1a 00 00       	call   3de0 <printf>
    exit();
    231b:	e8 88 19 00 00       	call   3ca8 <exit>
  if(link("README", "dirfile/xx") == 0){
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    printf(1, "unlink dirfile failed!\n");
    2320:	c7 44 24 04 69 4a 00 	movl   $0x4a69,0x4(%esp)
    2327:	00 
    2328:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    232f:	e8 ac 1a 00 00       	call   3de0 <printf>
    exit();
    2334:	e8 6f 19 00 00       	call   3ca8 <exit>
  if(unlink("dirfile/xx") == 0){
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    printf(1, "link to dirfile/xx succeeded!\n");
    2339:	c7 44 24 04 a4 56 00 	movl   $0x56a4,0x4(%esp)
    2340:	00 
    2341:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2348:	e8 93 1a 00 00       	call   3de0 <printf>
    exit();
    234d:	e8 56 19 00 00       	call   3ca8 <exit>
  if(mkdir("dirfile/xx") == 0){
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    printf(1, "unlink dirfile/xx succeeded!\n");
    2352:	c7 44 24 04 4b 4a 00 	movl   $0x4a4b,0x4(%esp)
    2359:	00 
    235a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2361:	e8 7a 1a 00 00       	call   3de0 <printf>
    exit();
    2366:	e8 3d 19 00 00       	call   3ca8 <exit>
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    printf(1, "mkdir dirfile/xx succeeded!\n");
    236b:	c7 44 24 04 2e 4a 00 	movl   $0x4a2e,0x4(%esp)
    2372:	00 
    2373:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    237a:	e8 61 1a 00 00       	call   3de0 <printf>
    exit();
    237f:	e8 24 19 00 00       	call   3ca8 <exit>
    2384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    238a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00002390 <rmdot>:
  printf(1, "fourteen ok\n");
}

void
rmdot(void)
{
    2390:	55                   	push   %ebp
    2391:	89 e5                	mov    %esp,%ebp
    2393:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    2396:	c7 44 24 04 a5 4a 00 	movl   $0x4aa5,0x4(%esp)
    239d:	00 
    239e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23a5:	e8 36 1a 00 00       	call   3de0 <printf>
  if(mkdir("dots") != 0){
    23aa:	c7 04 24 b1 4a 00 00 	movl   $0x4ab1,(%esp)
    23b1:	e8 5a 19 00 00       	call   3d10 <mkdir>
    23b6:	85 c0                	test   %eax,%eax
    23b8:	0f 85 9a 00 00 00    	jne    2458 <rmdot+0xc8>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    23be:	c7 04 24 b1 4a 00 00 	movl   $0x4ab1,(%esp)
    23c5:	e8 4e 19 00 00       	call   3d18 <chdir>
    23ca:	85 c0                	test   %eax,%eax
    23cc:	0f 85 35 01 00 00    	jne    2507 <rmdot+0x177>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    23d2:	c7 04 24 92 4c 00 00 	movl   $0x4c92,(%esp)
    23d9:	e8 1a 19 00 00       	call   3cf8 <unlink>
    23de:	85 c0                	test   %eax,%eax
    23e0:	0f 84 08 01 00 00    	je     24ee <rmdot+0x15e>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    23e6:	c7 04 24 91 4c 00 00 	movl   $0x4c91,(%esp)
    23ed:	e8 06 19 00 00       	call   3cf8 <unlink>
    23f2:	85 c0                	test   %eax,%eax
    23f4:	0f 84 db 00 00 00    	je     24d5 <rmdot+0x145>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    23fa:	c7 04 24 a9 49 00 00 	movl   $0x49a9,(%esp)
    2401:	e8 12 19 00 00       	call   3d18 <chdir>
    2406:	85 c0                	test   %eax,%eax
    2408:	0f 85 ae 00 00 00    	jne    24bc <rmdot+0x12c>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    240e:	c7 04 24 09 4b 00 00 	movl   $0x4b09,(%esp)
    2415:	e8 de 18 00 00       	call   3cf8 <unlink>
    241a:	85 c0                	test   %eax,%eax
    241c:	0f 84 81 00 00 00    	je     24a3 <rmdot+0x113>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    2422:	c7 04 24 27 4b 00 00 	movl   $0x4b27,(%esp)
    2429:	e8 ca 18 00 00       	call   3cf8 <unlink>
    242e:	85 c0                	test   %eax,%eax
    2430:	74 58                	je     248a <rmdot+0xfa>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    2432:	c7 04 24 b1 4a 00 00 	movl   $0x4ab1,(%esp)
    2439:	e8 ba 18 00 00       	call   3cf8 <unlink>
    243e:	85 c0                	test   %eax,%eax
    2440:	75 2f                	jne    2471 <rmdot+0xe1>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
    2442:	c7 44 24 04 5c 4b 00 	movl   $0x4b5c,0x4(%esp)
    2449:	00 
    244a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2451:	e8 8a 19 00 00       	call   3de0 <printf>
}
    2456:	c9                   	leave  
    2457:	c3                   	ret    
void
rmdot(void)
{
  printf(1, "rmdot test\n");
  if(mkdir("dots") != 0){
    printf(1, "mkdir dots failed\n");
    2458:	c7 44 24 04 b6 4a 00 	movl   $0x4ab6,0x4(%esp)
    245f:	00 
    2460:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2467:	e8 74 19 00 00       	call   3de0 <printf>
    exit();
    246c:	e8 37 18 00 00       	call   3ca8 <exit>
  if(unlink("dots/..") == 0){
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    printf(1, "unlink dots failed!\n");
    2471:	c7 44 24 04 47 4b 00 	movl   $0x4b47,0x4(%esp)
    2478:	00 
    2479:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2480:	e8 5b 19 00 00       	call   3de0 <printf>
    exit();
    2485:	e8 1e 18 00 00       	call   3ca8 <exit>
  if(unlink("dots/.") == 0){
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    printf(1, "unlink dots/.. worked!\n");
    248a:	c7 44 24 04 2f 4b 00 	movl   $0x4b2f,0x4(%esp)
    2491:	00 
    2492:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2499:	e8 42 19 00 00       	call   3de0 <printf>
    exit();
    249e:	e8 05 18 00 00       	call   3ca8 <exit>
  if(chdir("/") != 0){
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    printf(1, "unlink dots/. worked!\n");
    24a3:	c7 44 24 04 10 4b 00 	movl   $0x4b10,0x4(%esp)
    24aa:	00 
    24ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24b2:	e8 29 19 00 00       	call   3de0 <printf>
    exit();
    24b7:	e8 ec 17 00 00       	call   3ca8 <exit>
  if(unlink("..") == 0){
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    printf(1, "chdir / failed\n");
    24bc:	c7 44 24 04 f9 4a 00 	movl   $0x4af9,0x4(%esp)
    24c3:	00 
    24c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24cb:	e8 10 19 00 00       	call   3de0 <printf>
    exit();
    24d0:	e8 d3 17 00 00       	call   3ca8 <exit>
  if(unlink(".") == 0){
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    printf(1, "rm .. worked!\n");
    24d5:	c7 44 24 04 ea 4a 00 	movl   $0x4aea,0x4(%esp)
    24dc:	00 
    24dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24e4:	e8 f7 18 00 00       	call   3de0 <printf>
    exit();
    24e9:	e8 ba 17 00 00       	call   3ca8 <exit>
  if(chdir("dots") != 0){
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    printf(1, "rm . worked!\n");
    24ee:	c7 44 24 04 dc 4a 00 	movl   $0x4adc,0x4(%esp)
    24f5:	00 
    24f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24fd:	e8 de 18 00 00       	call   3de0 <printf>
    exit();
    2502:	e8 a1 17 00 00       	call   3ca8 <exit>
  if(mkdir("dots") != 0){
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    printf(1, "chdir dots failed\n");
    2507:	c7 44 24 04 c9 4a 00 	movl   $0x4ac9,0x4(%esp)
    250e:	00 
    250f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2516:	e8 c5 18 00 00       	call   3de0 <printf>
    exit();
    251b:	e8 88 17 00 00       	call   3ca8 <exit>

00002520 <subdir>:
  printf(1, "bigdir ok\n");
}

void
subdir(void)
{
    2520:	55                   	push   %ebp
    2521:	89 e5                	mov    %esp,%ebp
    2523:	53                   	push   %ebx
    2524:	83 ec 14             	sub    $0x14,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    2527:	c7 44 24 04 66 4b 00 	movl   $0x4b66,0x4(%esp)
    252e:	00 
    252f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2536:	e8 a5 18 00 00       	call   3de0 <printf>

  unlink("ff");
    253b:	c7 04 24 ef 4b 00 00 	movl   $0x4bef,(%esp)
    2542:	e8 b1 17 00 00       	call   3cf8 <unlink>
  if(mkdir("dd") != 0){
    2547:	c7 04 24 8c 4c 00 00 	movl   $0x4c8c,(%esp)
    254e:	e8 bd 17 00 00       	call   3d10 <mkdir>
    2553:	85 c0                	test   %eax,%eax
    2555:	0f 85 07 06 00 00    	jne    2b62 <subdir+0x642>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    255b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2562:	00 
    2563:	c7 04 24 c5 4b 00 00 	movl   $0x4bc5,(%esp)
    256a:	e8 79 17 00 00       	call   3ce8 <open>
  if(fd < 0){
    256f:	85 c0                	test   %eax,%eax
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    2571:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2573:	0f 88 d0 05 00 00    	js     2b49 <subdir+0x629>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    2579:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    2580:	00 
    2581:	c7 44 24 04 ef 4b 00 	movl   $0x4bef,0x4(%esp)
    2588:	00 
    2589:	89 04 24             	mov    %eax,(%esp)
    258c:	e8 37 17 00 00       	call   3cc8 <write>
  close(fd);
    2591:	89 1c 24             	mov    %ebx,(%esp)
    2594:	e8 37 17 00 00       	call   3cd0 <close>

  if(unlink("dd") >= 0){
    2599:	c7 04 24 8c 4c 00 00 	movl   $0x4c8c,(%esp)
    25a0:	e8 53 17 00 00       	call   3cf8 <unlink>
    25a5:	85 c0                	test   %eax,%eax
    25a7:	0f 89 83 05 00 00    	jns    2b30 <subdir+0x610>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    25ad:	c7 04 24 a0 4b 00 00 	movl   $0x4ba0,(%esp)
    25b4:	e8 57 17 00 00       	call   3d10 <mkdir>
    25b9:	85 c0                	test   %eax,%eax
    25bb:	0f 85 56 05 00 00    	jne    2b17 <subdir+0x5f7>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    25c1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    25c8:	00 
    25c9:	c7 04 24 c2 4b 00 00 	movl   $0x4bc2,(%esp)
    25d0:	e8 13 17 00 00       	call   3ce8 <open>
  if(fd < 0){
    25d5:	85 c0                	test   %eax,%eax
  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    25d7:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    25d9:	0f 88 25 04 00 00    	js     2a04 <subdir+0x4e4>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    25df:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    25e6:	00 
    25e7:	c7 44 24 04 e3 4b 00 	movl   $0x4be3,0x4(%esp)
    25ee:	00 
    25ef:	89 04 24             	mov    %eax,(%esp)
    25f2:	e8 d1 16 00 00       	call   3cc8 <write>
  close(fd);
    25f7:	89 1c 24             	mov    %ebx,(%esp)
    25fa:	e8 d1 16 00 00       	call   3cd0 <close>

  fd = open("dd/dd/../ff", 0);
    25ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2606:	00 
    2607:	c7 04 24 e6 4b 00 00 	movl   $0x4be6,(%esp)
    260e:	e8 d5 16 00 00       	call   3ce8 <open>
  if(fd < 0){
    2613:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
    2615:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2617:	0f 88 ce 03 00 00    	js     29eb <subdir+0x4cb>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    261d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2624:	00 
    2625:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    262c:	00 
    262d:	89 04 24             	mov    %eax,(%esp)
    2630:	e8 8b 16 00 00       	call   3cc0 <read>
  if(cc != 2 || buf[0] != 'f'){
    2635:	83 f8 02             	cmp    $0x2,%eax
    2638:	0f 85 fe 02 00 00    	jne    293c <subdir+0x41c>
    263e:	80 3d e0 80 00 00 66 	cmpb   $0x66,0x80e0
    2645:	0f 85 f1 02 00 00    	jne    293c <subdir+0x41c>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    264b:	89 1c 24             	mov    %ebx,(%esp)
    264e:	e8 7d 16 00 00       	call   3cd0 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2653:	c7 44 24 04 26 4c 00 	movl   $0x4c26,0x4(%esp)
    265a:	00 
    265b:	c7 04 24 c2 4b 00 00 	movl   $0x4bc2,(%esp)
    2662:	e8 a1 16 00 00       	call   3d08 <link>
    2667:	85 c0                	test   %eax,%eax
    2669:	0f 85 c7 03 00 00    	jne    2a36 <subdir+0x516>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    266f:	c7 04 24 c2 4b 00 00 	movl   $0x4bc2,(%esp)
    2676:	e8 7d 16 00 00       	call   3cf8 <unlink>
    267b:	85 c0                	test   %eax,%eax
    267d:	0f 85 eb 02 00 00    	jne    296e <subdir+0x44e>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2683:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    268a:	00 
    268b:	c7 04 24 c2 4b 00 00 	movl   $0x4bc2,(%esp)
    2692:	e8 51 16 00 00       	call   3ce8 <open>
    2697:	85 c0                	test   %eax,%eax
    2699:	0f 89 5f 04 00 00    	jns    2afe <subdir+0x5de>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    269f:	c7 04 24 8c 4c 00 00 	movl   $0x4c8c,(%esp)
    26a6:	e8 6d 16 00 00       	call   3d18 <chdir>
    26ab:	85 c0                	test   %eax,%eax
    26ad:	0f 85 32 04 00 00    	jne    2ae5 <subdir+0x5c5>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    26b3:	c7 04 24 5a 4c 00 00 	movl   $0x4c5a,(%esp)
    26ba:	e8 59 16 00 00       	call   3d18 <chdir>
    26bf:	85 c0                	test   %eax,%eax
    26c1:	0f 85 8e 02 00 00    	jne    2955 <subdir+0x435>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    26c7:	c7 04 24 80 4c 00 00 	movl   $0x4c80,(%esp)
    26ce:	e8 45 16 00 00       	call   3d18 <chdir>
    26d3:	85 c0                	test   %eax,%eax
    26d5:	0f 85 7a 02 00 00    	jne    2955 <subdir+0x435>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    26db:	c7 04 24 8f 4c 00 00 	movl   $0x4c8f,(%esp)
    26e2:	e8 31 16 00 00       	call   3d18 <chdir>
    26e7:	85 c0                	test   %eax,%eax
    26e9:	0f 85 2e 03 00 00    	jne    2a1d <subdir+0x4fd>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    26ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    26f6:	00 
    26f7:	c7 04 24 26 4c 00 00 	movl   $0x4c26,(%esp)
    26fe:	e8 e5 15 00 00       	call   3ce8 <open>
  if(fd < 0){
    2703:	85 c0                	test   %eax,%eax
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    2705:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2707:	0f 88 81 05 00 00    	js     2c8e <subdir+0x76e>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    270d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2714:	00 
    2715:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    271c:	00 
    271d:	89 04 24             	mov    %eax,(%esp)
    2720:	e8 9b 15 00 00       	call   3cc0 <read>
    2725:	83 f8 02             	cmp    $0x2,%eax
    2728:	0f 85 47 05 00 00    	jne    2c75 <subdir+0x755>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    272e:	89 1c 24             	mov    %ebx,(%esp)
    2731:	e8 9a 15 00 00       	call   3cd0 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2736:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    273d:	00 
    273e:	c7 04 24 c2 4b 00 00 	movl   $0x4bc2,(%esp)
    2745:	e8 9e 15 00 00       	call   3ce8 <open>
    274a:	85 c0                	test   %eax,%eax
    274c:	0f 89 4e 02 00 00    	jns    29a0 <subdir+0x480>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2752:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2759:	00 
    275a:	c7 04 24 da 4c 00 00 	movl   $0x4cda,(%esp)
    2761:	e8 82 15 00 00       	call   3ce8 <open>
    2766:	85 c0                	test   %eax,%eax
    2768:	0f 89 19 02 00 00    	jns    2987 <subdir+0x467>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    276e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2775:	00 
    2776:	c7 04 24 ff 4c 00 00 	movl   $0x4cff,(%esp)
    277d:	e8 66 15 00 00       	call   3ce8 <open>
    2782:	85 c0                	test   %eax,%eax
    2784:	0f 89 42 03 00 00    	jns    2acc <subdir+0x5ac>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    278a:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2791:	00 
    2792:	c7 04 24 8c 4c 00 00 	movl   $0x4c8c,(%esp)
    2799:	e8 4a 15 00 00       	call   3ce8 <open>
    279e:	85 c0                	test   %eax,%eax
    27a0:	0f 89 0d 03 00 00    	jns    2ab3 <subdir+0x593>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    27a6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    27ad:	00 
    27ae:	c7 04 24 8c 4c 00 00 	movl   $0x4c8c,(%esp)
    27b5:	e8 2e 15 00 00       	call   3ce8 <open>
    27ba:	85 c0                	test   %eax,%eax
    27bc:	0f 89 d8 02 00 00    	jns    2a9a <subdir+0x57a>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    27c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    27c9:	00 
    27ca:	c7 04 24 8c 4c 00 00 	movl   $0x4c8c,(%esp)
    27d1:	e8 12 15 00 00       	call   3ce8 <open>
    27d6:	85 c0                	test   %eax,%eax
    27d8:	0f 89 a3 02 00 00    	jns    2a81 <subdir+0x561>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    27de:	c7 44 24 04 6e 4d 00 	movl   $0x4d6e,0x4(%esp)
    27e5:	00 
    27e6:	c7 04 24 da 4c 00 00 	movl   $0x4cda,(%esp)
    27ed:	e8 16 15 00 00       	call   3d08 <link>
    27f2:	85 c0                	test   %eax,%eax
    27f4:	0f 84 6e 02 00 00    	je     2a68 <subdir+0x548>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    27fa:	c7 44 24 04 6e 4d 00 	movl   $0x4d6e,0x4(%esp)
    2801:	00 
    2802:	c7 04 24 ff 4c 00 00 	movl   $0x4cff,(%esp)
    2809:	e8 fa 14 00 00       	call   3d08 <link>
    280e:	85 c0                	test   %eax,%eax
    2810:	0f 84 39 02 00 00    	je     2a4f <subdir+0x52f>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2816:	c7 44 24 04 26 4c 00 	movl   $0x4c26,0x4(%esp)
    281d:	00 
    281e:	c7 04 24 c5 4b 00 00 	movl   $0x4bc5,(%esp)
    2825:	e8 de 14 00 00       	call   3d08 <link>
    282a:	85 c0                	test   %eax,%eax
    282c:	0f 84 a0 01 00 00    	je     29d2 <subdir+0x4b2>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    2832:	c7 04 24 da 4c 00 00 	movl   $0x4cda,(%esp)
    2839:	e8 d2 14 00 00       	call   3d10 <mkdir>
    283e:	85 c0                	test   %eax,%eax
    2840:	0f 84 73 01 00 00    	je     29b9 <subdir+0x499>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    2846:	c7 04 24 ff 4c 00 00 	movl   $0x4cff,(%esp)
    284d:	e8 be 14 00 00       	call   3d10 <mkdir>
    2852:	85 c0                	test   %eax,%eax
    2854:	0f 84 02 04 00 00    	je     2c5c <subdir+0x73c>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    285a:	c7 04 24 26 4c 00 00 	movl   $0x4c26,(%esp)
    2861:	e8 aa 14 00 00       	call   3d10 <mkdir>
    2866:	85 c0                	test   %eax,%eax
    2868:	0f 84 d5 03 00 00    	je     2c43 <subdir+0x723>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    286e:	c7 04 24 ff 4c 00 00 	movl   $0x4cff,(%esp)
    2875:	e8 7e 14 00 00       	call   3cf8 <unlink>
    287a:	85 c0                	test   %eax,%eax
    287c:	0f 84 a8 03 00 00    	je     2c2a <subdir+0x70a>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    2882:	c7 04 24 da 4c 00 00 	movl   $0x4cda,(%esp)
    2889:	e8 6a 14 00 00       	call   3cf8 <unlink>
    288e:	85 c0                	test   %eax,%eax
    2890:	0f 84 7b 03 00 00    	je     2c11 <subdir+0x6f1>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    2896:	c7 04 24 c5 4b 00 00 	movl   $0x4bc5,(%esp)
    289d:	e8 76 14 00 00       	call   3d18 <chdir>
    28a2:	85 c0                	test   %eax,%eax
    28a4:	0f 84 4e 03 00 00    	je     2bf8 <subdir+0x6d8>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    28aa:	c7 04 24 71 4d 00 00 	movl   $0x4d71,(%esp)
    28b1:	e8 62 14 00 00       	call   3d18 <chdir>
    28b6:	85 c0                	test   %eax,%eax
    28b8:	0f 84 21 03 00 00    	je     2bdf <subdir+0x6bf>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    28be:	c7 04 24 26 4c 00 00 	movl   $0x4c26,(%esp)
    28c5:	e8 2e 14 00 00       	call   3cf8 <unlink>
    28ca:	85 c0                	test   %eax,%eax
    28cc:	0f 85 9c 00 00 00    	jne    296e <subdir+0x44e>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    28d2:	c7 04 24 c5 4b 00 00 	movl   $0x4bc5,(%esp)
    28d9:	e8 1a 14 00 00       	call   3cf8 <unlink>
    28de:	85 c0                	test   %eax,%eax
    28e0:	0f 85 e0 02 00 00    	jne    2bc6 <subdir+0x6a6>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    28e6:	c7 04 24 8c 4c 00 00 	movl   $0x4c8c,(%esp)
    28ed:	e8 06 14 00 00       	call   3cf8 <unlink>
    28f2:	85 c0                	test   %eax,%eax
    28f4:	0f 84 b3 02 00 00    	je     2bad <subdir+0x68d>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    28fa:	c7 04 24 a1 4b 00 00 	movl   $0x4ba1,(%esp)
    2901:	e8 f2 13 00 00       	call   3cf8 <unlink>
    2906:	85 c0                	test   %eax,%eax
    2908:	0f 88 86 02 00 00    	js     2b94 <subdir+0x674>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    290e:	c7 04 24 8c 4c 00 00 	movl   $0x4c8c,(%esp)
    2915:	e8 de 13 00 00       	call   3cf8 <unlink>
    291a:	85 c0                	test   %eax,%eax
    291c:	0f 88 59 02 00 00    	js     2b7b <subdir+0x65b>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    2922:	c7 44 24 04 6e 4e 00 	movl   $0x4e6e,0x4(%esp)
    2929:	00 
    292a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2931:	e8 aa 14 00 00       	call   3de0 <printf>
}
    2936:	83 c4 14             	add    $0x14,%esp
    2939:	5b                   	pop    %ebx
    293a:	5d                   	pop    %ebp
    293b:	c3                   	ret    
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
  if(cc != 2 || buf[0] != 'f'){
    printf(1, "dd/dd/../ff wrong content\n");
    293c:	c7 44 24 04 0b 4c 00 	movl   $0x4c0b,0x4(%esp)
    2943:	00 
    2944:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    294b:	e8 90 14 00 00       	call   3de0 <printf>
    exit();
    2950:	e8 53 13 00 00       	call   3ca8 <exit>
  if(chdir("dd/../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    2955:	c7 44 24 04 66 4c 00 	movl   $0x4c66,0x4(%esp)
    295c:	00 
    295d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2964:	e8 77 14 00 00       	call   3de0 <printf>
    exit();
    2969:	e8 3a 13 00 00       	call   3ca8 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    296e:	c7 44 24 04 31 4c 00 	movl   $0x4c31,0x4(%esp)
    2975:	00 
    2976:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    297d:	e8 5e 14 00 00       	call   3de0 <printf>
    exit();
    2982:	e8 21 13 00 00       	call   3ca8 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    2987:	c7 44 24 04 e3 4c 00 	movl   $0x4ce3,0x4(%esp)
    298e:	00 
    298f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2996:	e8 45 14 00 00       	call   3de0 <printf>
    exit();
    299b:	e8 08 13 00 00       	call   3ca8 <exit>
    exit();
  }
  close(fd);

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    29a0:	c7 44 24 04 54 57 00 	movl   $0x5754,0x4(%esp)
    29a7:	00 
    29a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29af:	e8 2c 14 00 00       	call   3de0 <printf>
    exit();
    29b4:	e8 ef 12 00 00       	call   3ca8 <exit>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    29b9:	c7 44 24 04 77 4d 00 	movl   $0x4d77,0x4(%esp)
    29c0:	00 
    29c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29c8:	e8 13 14 00 00       	call   3de0 <printf>
    exit();
    29cd:	e8 d6 12 00 00       	call   3ca8 <exit>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    29d2:	c7 44 24 04 c4 57 00 	movl   $0x57c4,0x4(%esp)
    29d9:	00 
    29da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29e1:	e8 fa 13 00 00       	call   3de0 <printf>
    exit();
    29e6:	e8 bd 12 00 00       	call   3ca8 <exit>
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/../ff failed\n");
    29eb:	c7 44 24 04 f2 4b 00 	movl   $0x4bf2,0x4(%esp)
    29f2:	00 
    29f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29fa:	e8 e1 13 00 00       	call   3de0 <printf>
    exit();
    29ff:	e8 a4 12 00 00       	call   3ca8 <exit>
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/dd/ff failed\n");
    2a04:	c7 44 24 04 cb 4b 00 	movl   $0x4bcb,0x4(%esp)
    2a0b:	00 
    2a0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a13:	e8 c8 13 00 00       	call   3de0 <printf>
    exit();
    2a18:	e8 8b 12 00 00       	call   3ca8 <exit>
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    2a1d:	c7 44 24 04 94 4c 00 	movl   $0x4c94,0x4(%esp)
    2a24:	00 
    2a25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a2c:	e8 af 13 00 00       	call   3de0 <printf>
    exit();
    2a31:	e8 72 12 00 00       	call   3ca8 <exit>
    exit();
  }
  close(fd);

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2a36:	c7 44 24 04 0c 57 00 	movl   $0x570c,0x4(%esp)
    2a3d:	00 
    2a3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a45:	e8 96 13 00 00       	call   3de0 <printf>
    exit();
    2a4a:	e8 59 12 00 00       	call   3ca8 <exit>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2a4f:	c7 44 24 04 a0 57 00 	movl   $0x57a0,0x4(%esp)
    2a56:	00 
    2a57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a5e:	e8 7d 13 00 00       	call   3de0 <printf>
    exit();
    2a63:	e8 40 12 00 00       	call   3ca8 <exit>
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2a68:	c7 44 24 04 7c 57 00 	movl   $0x577c,0x4(%esp)
    2a6f:	00 
    2a70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a77:	e8 64 13 00 00       	call   3de0 <printf>
    exit();
    2a7c:	e8 27 12 00 00       	call   3ca8 <exit>
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    2a81:	c7 44 24 04 53 4d 00 	movl   $0x4d53,0x4(%esp)
    2a88:	00 
    2a89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a90:	e8 4b 13 00 00       	call   3de0 <printf>
    exit();
    2a95:	e8 0e 12 00 00       	call   3ca8 <exit>
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    2a9a:	c7 44 24 04 3a 4d 00 	movl   $0x4d3a,0x4(%esp)
    2aa1:	00 
    2aa2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aa9:	e8 32 13 00 00       	call   3de0 <printf>
    exit();
    2aae:	e8 f5 11 00 00       	call   3ca8 <exit>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    2ab3:	c7 44 24 04 24 4d 00 	movl   $0x4d24,0x4(%esp)
    2aba:	00 
    2abb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ac2:	e8 19 13 00 00       	call   3de0 <printf>
    exit();
    2ac7:	e8 dc 11 00 00       	call   3ca8 <exit>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    2acc:	c7 44 24 04 08 4d 00 	movl   $0x4d08,0x4(%esp)
    2ad3:	00 
    2ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2adb:	e8 00 13 00 00       	call   3de0 <printf>
    exit();
    2ae0:	e8 c3 11 00 00       	call   3ca8 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    printf(1, "chdir dd failed\n");
    2ae5:	c7 44 24 04 49 4c 00 	movl   $0x4c49,0x4(%esp)
    2aec:	00 
    2aed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2af4:	e8 e7 12 00 00       	call   3de0 <printf>
    exit();
    2af9:	e8 aa 11 00 00       	call   3ca8 <exit>
  if(unlink("dd/dd/ff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2afe:	c7 44 24 04 30 57 00 	movl   $0x5730,0x4(%esp)
    2b05:	00 
    2b06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b0d:	e8 ce 12 00 00       	call   3de0 <printf>
    exit();
    2b12:	e8 91 11 00 00       	call   3ca8 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    2b17:	c7 44 24 04 a7 4b 00 	movl   $0x4ba7,0x4(%esp)
    2b1e:	00 
    2b1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b26:	e8 b5 12 00 00       	call   3de0 <printf>
    exit();
    2b2b:	e8 78 11 00 00       	call   3ca8 <exit>
  }
  write(fd, "ff", 2);
  close(fd);

  if(unlink("dd") >= 0){
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2b30:	c7 44 24 04 e4 56 00 	movl   $0x56e4,0x4(%esp)
    2b37:	00 
    2b38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b3f:	e8 9c 12 00 00       	call   3de0 <printf>
    exit();
    2b44:	e8 5f 11 00 00       	call   3ca8 <exit>
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/ff failed\n");
    2b49:	c7 44 24 04 8b 4b 00 	movl   $0x4b8b,0x4(%esp)
    2b50:	00 
    2b51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b58:	e8 83 12 00 00       	call   3de0 <printf>
    exit();
    2b5d:	e8 46 11 00 00       	call   3ca8 <exit>

  printf(1, "subdir test\n");

  unlink("ff");
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    2b62:	c7 44 24 04 73 4b 00 	movl   $0x4b73,0x4(%esp)
    2b69:	00 
    2b6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b71:	e8 6a 12 00 00       	call   3de0 <printf>
    exit();
    2b76:	e8 2d 11 00 00       	call   3ca8 <exit>
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    printf(1, "unlink dd failed\n");
    2b7b:	c7 44 24 04 5c 4e 00 	movl   $0x4e5c,0x4(%esp)
    2b82:	00 
    2b83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b8a:	e8 51 12 00 00       	call   3de0 <printf>
    exit();
    2b8f:	e8 14 11 00 00       	call   3ca8 <exit>
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    2b94:	c7 44 24 04 47 4e 00 	movl   $0x4e47,0x4(%esp)
    2b9b:	00 
    2b9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ba3:	e8 38 12 00 00       	call   3de0 <printf>
    exit();
    2ba8:	e8 fb 10 00 00       	call   3ca8 <exit>
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    2bad:	c7 44 24 04 e8 57 00 	movl   $0x57e8,0x4(%esp)
    2bb4:	00 
    2bb5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bbc:	e8 1f 12 00 00       	call   3de0 <printf>
    exit();
    2bc1:	e8 e2 10 00 00       	call   3ca8 <exit>
  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    2bc6:	c7 44 24 04 32 4e 00 	movl   $0x4e32,0x4(%esp)
    2bcd:	00 
    2bce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bd5:	e8 06 12 00 00       	call   3de0 <printf>
    exit();
    2bda:	e8 c9 10 00 00       	call   3ca8 <exit>
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    printf(1, "chdir dd/xx succeeded!\n");
    2bdf:	c7 44 24 04 1a 4e 00 	movl   $0x4e1a,0x4(%esp)
    2be6:	00 
    2be7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bee:	e8 ed 11 00 00       	call   3de0 <printf>
    exit();
    2bf3:	e8 b0 10 00 00       	call   3ca8 <exit>
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    2bf8:	c7 44 24 04 02 4e 00 	movl   $0x4e02,0x4(%esp)
    2bff:	00 
    2c00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c07:	e8 d4 11 00 00       	call   3de0 <printf>
    exit();
    2c0c:	e8 97 10 00 00       	call   3ca8 <exit>
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2c11:	c7 44 24 04 e6 4d 00 	movl   $0x4de6,0x4(%esp)
    2c18:	00 
    2c19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c20:	e8 bb 11 00 00       	call   3de0 <printf>
    exit();
    2c25:	e8 7e 10 00 00       	call   3ca8 <exit>
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2c2a:	c7 44 24 04 ca 4d 00 	movl   $0x4dca,0x4(%esp)
    2c31:	00 
    2c32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c39:	e8 a2 11 00 00       	call   3de0 <printf>
    exit();
    2c3e:	e8 65 10 00 00       	call   3ca8 <exit>
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2c43:	c7 44 24 04 ad 4d 00 	movl   $0x4dad,0x4(%esp)
    2c4a:	00 
    2c4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c52:	e8 89 11 00 00       	call   3de0 <printf>
    exit();
    2c57:	e8 4c 10 00 00       	call   3ca8 <exit>
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2c5c:	c7 44 24 04 92 4d 00 	movl   $0x4d92,0x4(%esp)
    2c63:	00 
    2c64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c6b:	e8 70 11 00 00       	call   3de0 <printf>
    exit();
    2c70:	e8 33 10 00 00       	call   3ca8 <exit>
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    printf(1, "read dd/dd/ffff wrong len\n");
    2c75:	c7 44 24 04 bf 4c 00 	movl   $0x4cbf,0x4(%esp)
    2c7c:	00 
    2c7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c84:	e8 57 11 00 00       	call   3de0 <printf>
    exit();
    2c89:	e8 1a 10 00 00       	call   3ca8 <exit>
    exit();
  }

  fd = open("dd/dd/ffff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    2c8e:	c7 44 24 04 a7 4c 00 	movl   $0x4ca7,0x4(%esp)
    2c95:	00 
    2c96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c9d:	e8 3e 11 00 00       	call   3de0 <printf>
    exit();
    2ca2:	e8 01 10 00 00       	call   3ca8 <exit>
    2ca7:	89 f6                	mov    %esi,%esi
    2ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002cb0 <dirtest>:
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
}

void dirtest(void)
{
    2cb0:	55                   	push   %ebp
    2cb1:	89 e5                	mov    %esp,%ebp
    2cb3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
    2cb6:	a1 0c 59 00 00       	mov    0x590c,%eax
    2cbb:	c7 44 24 04 79 4e 00 	movl   $0x4e79,0x4(%esp)
    2cc2:	00 
    2cc3:	89 04 24             	mov    %eax,(%esp)
    2cc6:	e8 15 11 00 00       	call   3de0 <printf>

  if(mkdir("dir0") < 0){
    2ccb:	c7 04 24 85 4e 00 00 	movl   $0x4e85,(%esp)
    2cd2:	e8 39 10 00 00       	call   3d10 <mkdir>
    2cd7:	85 c0                	test   %eax,%eax
    2cd9:	78 4b                	js     2d26 <dirtest+0x76>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
    2cdb:	c7 04 24 85 4e 00 00 	movl   $0x4e85,(%esp)
    2ce2:	e8 31 10 00 00       	call   3d18 <chdir>
    2ce7:	85 c0                	test   %eax,%eax
    2ce9:	0f 88 85 00 00 00    	js     2d74 <dirtest+0xc4>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
    2cef:	c7 04 24 91 4c 00 00 	movl   $0x4c91,(%esp)
    2cf6:	e8 1d 10 00 00       	call   3d18 <chdir>
    2cfb:	85 c0                	test   %eax,%eax
    2cfd:	78 5b                	js     2d5a <dirtest+0xaa>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
    2cff:	c7 04 24 85 4e 00 00 	movl   $0x4e85,(%esp)
    2d06:	e8 ed 0f 00 00       	call   3cf8 <unlink>
    2d0b:	85 c0                	test   %eax,%eax
    2d0d:	78 31                	js     2d40 <dirtest+0x90>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
    2d0f:	a1 0c 59 00 00       	mov    0x590c,%eax
    2d14:	c7 44 24 04 d0 4e 00 	movl   $0x4ed0,0x4(%esp)
    2d1b:	00 
    2d1c:	89 04 24             	mov    %eax,(%esp)
    2d1f:	e8 bc 10 00 00       	call   3de0 <printf>
}
    2d24:	c9                   	leave  
    2d25:	c3                   	ret    
void dirtest(void)
{
  printf(stdout, "mkdir test\n");

  if(mkdir("dir0") < 0){
    printf(stdout, "mkdir failed\n");
    2d26:	a1 0c 59 00 00       	mov    0x590c,%eax
    2d2b:	c7 44 24 04 8a 4e 00 	movl   $0x4e8a,0x4(%esp)
    2d32:	00 
    2d33:	89 04 24             	mov    %eax,(%esp)
    2d36:	e8 a5 10 00 00       	call   3de0 <printf>
    exit();
    2d3b:	e8 68 0f 00 00       	call   3ca8 <exit>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
    printf(stdout, "unlink dir0 failed\n");
    2d40:	a1 0c 59 00 00       	mov    0x590c,%eax
    2d45:	c7 44 24 04 bc 4e 00 	movl   $0x4ebc,0x4(%esp)
    2d4c:	00 
    2d4d:	89 04 24             	mov    %eax,(%esp)
    2d50:	e8 8b 10 00 00       	call   3de0 <printf>
    exit();
    2d55:	e8 4e 0f 00 00       	call   3ca8 <exit>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
    printf(stdout, "chdir .. failed\n");
    2d5a:	a1 0c 59 00 00       	mov    0x590c,%eax
    2d5f:	c7 44 24 04 ab 4e 00 	movl   $0x4eab,0x4(%esp)
    2d66:	00 
    2d67:	89 04 24             	mov    %eax,(%esp)
    2d6a:	e8 71 10 00 00       	call   3de0 <printf>
    exit();
    2d6f:	e8 34 0f 00 00       	call   3ca8 <exit>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
    printf(stdout, "chdir dir0 failed\n");
    2d74:	a1 0c 59 00 00       	mov    0x590c,%eax
    2d79:	c7 44 24 04 98 4e 00 	movl   $0x4e98,0x4(%esp)
    2d80:	00 
    2d81:	89 04 24             	mov    %eax,(%esp)
    2d84:	e8 57 10 00 00       	call   3de0 <printf>
    exit();
    2d89:	e8 1a 0f 00 00       	call   3ca8 <exit>
    2d8e:	66 90                	xchg   %ax,%ax

00002d90 <exitiputtest>:
}

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
    2d90:	55                   	push   %ebp
    2d91:	89 e5                	mov    %esp,%ebp
    2d93:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
    2d96:	a1 0c 59 00 00       	mov    0x590c,%eax
    2d9b:	c7 44 24 04 df 4e 00 	movl   $0x4edf,0x4(%esp)
    2da2:	00 
    2da3:	89 04 24             	mov    %eax,(%esp)
    2da6:	e8 35 10 00 00       	call   3de0 <printf>

  pid = fork();
    2dab:	e8 f0 0e 00 00       	call   3ca0 <fork>
  if(pid < 0){
    2db0:	83 f8 00             	cmp    $0x0,%eax
    2db3:	7c 75                	jl     2e2a <exitiputtest+0x9a>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
    2db5:	75 39                	jne    2df0 <exitiputtest+0x60>
    if(mkdir("iputdir") < 0){
    2db7:	c7 04 24 05 4f 00 00 	movl   $0x4f05,(%esp)
    2dbe:	e8 4d 0f 00 00       	call   3d10 <mkdir>
    2dc3:	85 c0                	test   %eax,%eax
    2dc5:	0f 88 93 00 00 00    	js     2e5e <exitiputtest+0xce>
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
    2dcb:	c7 04 24 05 4f 00 00 	movl   $0x4f05,(%esp)
    2dd2:	e8 41 0f 00 00       	call   3d18 <chdir>
    2dd7:	85 c0                	test   %eax,%eax
    2dd9:	78 69                	js     2e44 <exitiputtest+0xb4>
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
    2ddb:	c7 04 24 02 4f 00 00 	movl   $0x4f02,(%esp)
    2de2:	e8 11 0f 00 00       	call   3cf8 <unlink>
    2de7:	85 c0                	test   %eax,%eax
    2de9:	78 25                	js     2e10 <exitiputtest+0x80>
      printf(stdout, "unlink ../iputdir failed\n");
      exit();
    }
    exit();
    2deb:	e8 b8 0e 00 00       	call   3ca8 <exit>
  }
  wait();
    2df0:	e8 bb 0e 00 00       	call   3cb0 <wait>
  printf(stdout, "exitiput test ok\n");
    2df5:	a1 0c 59 00 00       	mov    0x590c,%eax
    2dfa:	c7 44 24 04 27 4f 00 	movl   $0x4f27,0x4(%esp)
    2e01:	00 
    2e02:	89 04 24             	mov    %eax,(%esp)
    2e05:	e8 d6 0f 00 00       	call   3de0 <printf>
}
    2e0a:	c9                   	leave  
    2e0b:	c3                   	ret    
    2e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(chdir("iputdir") < 0){
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
      printf(stdout, "unlink ../iputdir failed\n");
    2e10:	a1 0c 59 00 00       	mov    0x590c,%eax
    2e15:	c7 44 24 04 0d 4f 00 	movl   $0x4f0d,0x4(%esp)
    2e1c:	00 
    2e1d:	89 04 24             	mov    %eax,(%esp)
    2e20:	e8 bb 0f 00 00       	call   3de0 <printf>
      exit();
    2e25:	e8 7e 0e 00 00       	call   3ca8 <exit>

  printf(stdout, "exitiput test\n");

  pid = fork();
  if(pid < 0){
    printf(stdout, "fork failed\n");
    2e2a:	a1 0c 59 00 00       	mov    0x590c,%eax
    2e2f:	c7 44 24 04 bf 45 00 	movl   $0x45bf,0x4(%esp)
    2e36:	00 
    2e37:	89 04 24             	mov    %eax,(%esp)
    2e3a:	e8 a1 0f 00 00       	call   3de0 <printf>
    exit();
    2e3f:	e8 64 0e 00 00       	call   3ca8 <exit>
    if(mkdir("iputdir") < 0){
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
      printf(stdout, "child chdir failed\n");
    2e44:	a1 0c 59 00 00       	mov    0x590c,%eax
    2e49:	c7 44 24 04 ee 4e 00 	movl   $0x4eee,0x4(%esp)
    2e50:	00 
    2e51:	89 04 24             	mov    %eax,(%esp)
    2e54:	e8 87 0f 00 00       	call   3de0 <printf>
      exit();
    2e59:	e8 4a 0e 00 00       	call   3ca8 <exit>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
    if(mkdir("iputdir") < 0){
      printf(stdout, "mkdir failed\n");
    2e5e:	a1 0c 59 00 00       	mov    0x590c,%eax
    2e63:	c7 44 24 04 8a 4e 00 	movl   $0x4e8a,0x4(%esp)
    2e6a:	00 
    2e6b:	89 04 24             	mov    %eax,(%esp)
    2e6e:	e8 6d 0f 00 00       	call   3de0 <printf>
      exit();
    2e73:	e8 30 0e 00 00       	call   3ca8 <exit>
    2e78:	90                   	nop
    2e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00002e80 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
    2e80:	55                   	push   %ebp
    2e81:	89 e5                	mov    %esp,%ebp
    2e83:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
    2e86:	a1 0c 59 00 00       	mov    0x590c,%eax
    2e8b:	c7 44 24 04 2c 49 00 	movl   $0x492c,0x4(%esp)
    2e92:	00 
    2e93:	89 04 24             	mov    %eax,(%esp)
    2e96:	e8 45 0f 00 00       	call   3de0 <printf>

  if(mkdir("iputdir") < 0){
    2e9b:	c7 04 24 05 4f 00 00 	movl   $0x4f05,(%esp)
    2ea2:	e8 69 0e 00 00       	call   3d10 <mkdir>
    2ea7:	85 c0                	test   %eax,%eax
    2ea9:	78 4b                	js     2ef6 <iputtest+0x76>
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
    2eab:	c7 04 24 05 4f 00 00 	movl   $0x4f05,(%esp)
    2eb2:	e8 61 0e 00 00       	call   3d18 <chdir>
    2eb7:	85 c0                	test   %eax,%eax
    2eb9:	0f 88 85 00 00 00    	js     2f44 <iputtest+0xc4>
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
    2ebf:	c7 04 24 02 4f 00 00 	movl   $0x4f02,(%esp)
    2ec6:	e8 2d 0e 00 00       	call   3cf8 <unlink>
    2ecb:	85 c0                	test   %eax,%eax
    2ecd:	78 5b                	js     2f2a <iputtest+0xaa>
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
    2ecf:	c7 04 24 a9 49 00 00 	movl   $0x49a9,(%esp)
    2ed6:	e8 3d 0e 00 00       	call   3d18 <chdir>
    2edb:	85 c0                	test   %eax,%eax
    2edd:	78 31                	js     2f10 <iputtest+0x90>
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
    2edf:	a1 0c 59 00 00       	mov    0x590c,%eax
    2ee4:	c7 44 24 04 55 49 00 	movl   $0x4955,0x4(%esp)
    2eeb:	00 
    2eec:	89 04 24             	mov    %eax,(%esp)
    2eef:	e8 ec 0e 00 00       	call   3de0 <printf>
}
    2ef4:	c9                   	leave  
    2ef5:	c3                   	ret    
iputtest(void)
{
  printf(stdout, "iput test\n");

  if(mkdir("iputdir") < 0){
    printf(stdout, "mkdir failed\n");
    2ef6:	a1 0c 59 00 00       	mov    0x590c,%eax
    2efb:	c7 44 24 04 8a 4e 00 	movl   $0x4e8a,0x4(%esp)
    2f02:	00 
    2f03:	89 04 24             	mov    %eax,(%esp)
    2f06:	e8 d5 0e 00 00       	call   3de0 <printf>
    exit();
    2f0b:	e8 98 0d 00 00       	call   3ca8 <exit>
  if(unlink("../iputdir") < 0){
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
    printf(stdout, "chdir / failed\n");
    2f10:	a1 0c 59 00 00       	mov    0x590c,%eax
    2f15:	c7 44 24 04 f9 4a 00 	movl   $0x4af9,0x4(%esp)
    2f1c:	00 
    2f1d:	89 04 24             	mov    %eax,(%esp)
    2f20:	e8 bb 0e 00 00       	call   3de0 <printf>
    exit();
    2f25:	e8 7e 0d 00 00       	call   3ca8 <exit>
  if(chdir("iputdir") < 0){
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
    printf(stdout, "unlink ../iputdir failed\n");
    2f2a:	a1 0c 59 00 00       	mov    0x590c,%eax
    2f2f:	c7 44 24 04 0d 4f 00 	movl   $0x4f0d,0x4(%esp)
    2f36:	00 
    2f37:	89 04 24             	mov    %eax,(%esp)
    2f3a:	e8 a1 0e 00 00       	call   3de0 <printf>
    exit();
    2f3f:	e8 64 0d 00 00       	call   3ca8 <exit>
  if(mkdir("iputdir") < 0){
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
    printf(stdout, "chdir iputdir failed\n");
    2f44:	a1 0c 59 00 00       	mov    0x590c,%eax
    2f49:	c7 44 24 04 39 4f 00 	movl   $0x4f39,0x4(%esp)
    2f50:	00 
    2f51:	89 04 24             	mov    %eax,(%esp)
    2f54:	e8 87 0e 00 00       	call   3de0 <printf>
    exit();
    2f59:	e8 4a 0d 00 00       	call   3ca8 <exit>
    2f5e:	66 90                	xchg   %ax,%ax

00002f60 <bigfile>:
  printf(1, "bigwrite ok\n");
}

void
bigfile(void)
{
    2f60:	55                   	push   %ebp
    2f61:	89 e5                	mov    %esp,%ebp
    2f63:	57                   	push   %edi
    2f64:	56                   	push   %esi
    2f65:	53                   	push   %ebx
    2f66:	83 ec 1c             	sub    $0x1c,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2f69:	c7 44 24 04 4f 4f 00 	movl   $0x4f4f,0x4(%esp)
    2f70:	00 
    2f71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f78:	e8 63 0e 00 00       	call   3de0 <printf>

  unlink("bigfile");
    2f7d:	c7 04 24 6b 4f 00 00 	movl   $0x4f6b,(%esp)
    2f84:	e8 6f 0d 00 00       	call   3cf8 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2f89:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2f90:	00 
    2f91:	c7 04 24 6b 4f 00 00 	movl   $0x4f6b,(%esp)
    2f98:	e8 4b 0d 00 00       	call   3ce8 <open>
  if(fd < 0){
    2f9d:	85 c0                	test   %eax,%eax
  int fd, i, total, cc;

  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
    2f9f:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2fa1:	0f 88 7f 01 00 00    	js     3126 <bigfile+0x1c6>
    printf(1, "cannot create bigfile");
    exit();
    2fa7:	31 db                	xor    %ebx,%ebx
    2fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
    2fb0:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2fb7:	00 
    2fb8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    2fbc:	c7 04 24 e0 80 00 00 	movl   $0x80e0,(%esp)
    2fc3:	e8 58 0b 00 00       	call   3b20 <memset>
    if(write(fd, buf, 600) != 600){
    2fc8:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2fcf:	00 
    2fd0:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    2fd7:	00 
    2fd8:	89 34 24             	mov    %esi,(%esp)
    2fdb:	e8 e8 0c 00 00       	call   3cc8 <write>
    2fe0:	3d 58 02 00 00       	cmp    $0x258,%eax
    2fe5:	0f 85 09 01 00 00    	jne    30f4 <bigfile+0x194>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    2feb:	83 c3 01             	add    $0x1,%ebx
    2fee:	83 fb 14             	cmp    $0x14,%ebx
    2ff1:	75 bd                	jne    2fb0 <bigfile+0x50>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2ff3:	89 34 24             	mov    %esi,(%esp)
    2ff6:	e8 d5 0c 00 00       	call   3cd0 <close>

  fd = open("bigfile", 0);
    2ffb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3002:	00 
    3003:	c7 04 24 6b 4f 00 00 	movl   $0x4f6b,(%esp)
    300a:	e8 d9 0c 00 00       	call   3ce8 <open>
  if(fd < 0){
    300f:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  close(fd);

  fd = open("bigfile", 0);
    3011:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    3013:	0f 88 f4 00 00 00    	js     310d <bigfile+0x1ad>
    printf(1, "cannot open bigfile\n");
    exit();
    3019:	31 f6                	xor    %esi,%esi
    301b:	31 db                	xor    %ebx,%ebx
    301d:	eb 2f                	jmp    304e <bigfile+0xee>
    301f:	90                   	nop
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    3020:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    3025:	0f 85 97 00 00 00    	jne    30c2 <bigfile+0x162>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    302b:	0f be 05 e0 80 00 00 	movsbl 0x80e0,%eax
    3032:	89 da                	mov    %ebx,%edx
    3034:	d1 fa                	sar    %edx
    3036:	39 d0                	cmp    %edx,%eax
    3038:	75 6f                	jne    30a9 <bigfile+0x149>
    303a:	0f be 15 0b 82 00 00 	movsbl 0x820b,%edx
    3041:	39 d0                	cmp    %edx,%eax
    3043:	75 64                	jne    30a9 <bigfile+0x149>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
    3045:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    304b:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
    304e:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    3055:	00 
    3056:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    305d:	00 
    305e:	89 3c 24             	mov    %edi,(%esp)
    3061:	e8 5a 0c 00 00       	call   3cc0 <read>
    if(cc < 0){
    3066:	83 f8 00             	cmp    $0x0,%eax
    3069:	7c 70                	jl     30db <bigfile+0x17b>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    306b:	75 b3                	jne    3020 <bigfile+0xc0>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    306d:	89 3c 24             	mov    %edi,(%esp)
    3070:	e8 5b 0c 00 00       	call   3cd0 <close>
  if(total != 20*600){
    3075:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    307b:	0f 85 be 00 00 00    	jne    313f <bigfile+0x1df>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    3081:	c7 04 24 6b 4f 00 00 	movl   $0x4f6b,(%esp)
    3088:	e8 6b 0c 00 00       	call   3cf8 <unlink>

  printf(1, "bigfile test ok\n");
    308d:	c7 44 24 04 fa 4f 00 	movl   $0x4ffa,0x4(%esp)
    3094:	00 
    3095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    309c:	e8 3f 0d 00 00       	call   3de0 <printf>
}
    30a1:	83 c4 1c             	add    $0x1c,%esp
    30a4:	5b                   	pop    %ebx
    30a5:	5e                   	pop    %esi
    30a6:	5f                   	pop    %edi
    30a7:	5d                   	pop    %ebp
    30a8:	c3                   	ret    
    if(cc != 300){
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
    30a9:	c7 44 24 04 c7 4f 00 	movl   $0x4fc7,0x4(%esp)
    30b0:	00 
    30b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30b8:	e8 23 0d 00 00       	call   3de0 <printf>
      exit();
    30bd:	e8 e6 0b 00 00       	call   3ca8 <exit>
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
      printf(1, "short read bigfile\n");
    30c2:	c7 44 24 04 b3 4f 00 	movl   $0x4fb3,0x4(%esp)
    30c9:	00 
    30ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30d1:	e8 0a 0d 00 00       	call   3de0 <printf>
      exit();
    30d6:	e8 cd 0b 00 00       	call   3ca8 <exit>
  }
  total = 0;
  for(i = 0; ; i++){
    cc = read(fd, buf, 300);
    if(cc < 0){
      printf(1, "read bigfile failed\n");
    30db:	c7 44 24 04 9e 4f 00 	movl   $0x4f9e,0x4(%esp)
    30e2:	00 
    30e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30ea:	e8 f1 0c 00 00       	call   3de0 <printf>
      exit();
    30ef:	e8 b4 0b 00 00       	call   3ca8 <exit>
    exit();
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
    30f4:	c7 44 24 04 73 4f 00 	movl   $0x4f73,0x4(%esp)
    30fb:	00 
    30fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3103:	e8 d8 0c 00 00       	call   3de0 <printf>
      exit();
    3108:	e8 9b 0b 00 00       	call   3ca8 <exit>
  }
  close(fd);

  fd = open("bigfile", 0);
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    310d:	c7 44 24 04 89 4f 00 	movl   $0x4f89,0x4(%esp)
    3114:	00 
    3115:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    311c:	e8 bf 0c 00 00       	call   3de0 <printf>
    exit();
    3121:	e8 82 0b 00 00       	call   3ca8 <exit>
  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    3126:	c7 44 24 04 5d 4f 00 	movl   $0x4f5d,0x4(%esp)
    312d:	00 
    312e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3135:	e8 a6 0c 00 00       	call   3de0 <printf>
    exit();
    313a:	e8 69 0b 00 00       	call   3ca8 <exit>
    }
    total += cc;
  }
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    313f:	c7 44 24 04 e0 4f 00 	movl   $0x4fe0,0x4(%esp)
    3146:	00 
    3147:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    314e:	e8 8d 0c 00 00       	call   3de0 <printf>
    exit();
    3153:	e8 50 0b 00 00       	call   3ca8 <exit>
    3158:	90                   	nop
    3159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00003160 <concreate>:
}

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    3160:	55                   	push   %ebp
    3161:	89 e5                	mov    %esp,%ebp
    3163:	57                   	push   %edi
    3164:	56                   	push   %esi
    3165:	53                   	push   %ebx
    char name[14];
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
    3166:	31 db                	xor    %ebx,%ebx
}

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    3168:	83 ec 6c             	sub    $0x6c,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    316b:	c7 44 24 04 0b 50 00 	movl   $0x500b,0x4(%esp)
    3172:	00 
    3173:	8d 75 e5             	lea    -0x1b(%ebp),%esi
    3176:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    317d:	e8 5e 0c 00 00       	call   3de0 <printf>
  file[0] = 'C';
    3182:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    3186:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    318a:	eb 4f                	jmp    31db <concreate+0x7b>
    318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    3190:	b8 56 55 55 55       	mov    $0x55555556,%eax
    3195:	f7 eb                	imul   %ebx
    3197:	89 d8                	mov    %ebx,%eax
    3199:	c1 f8 1f             	sar    $0x1f,%eax
    319c:	29 c2                	sub    %eax,%edx
    319e:	8d 04 52             	lea    (%edx,%edx,2),%eax
    31a1:	89 da                	mov    %ebx,%edx
    31a3:	29 c2                	sub    %eax,%edx
    31a5:	83 fa 01             	cmp    $0x1,%edx
    31a8:	74 7e                	je     3228 <concreate+0xc8>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    31aa:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    31b1:	00 
    31b2:	89 34 24             	mov    %esi,(%esp)
    31b5:	e8 2e 0b 00 00       	call   3ce8 <open>
      if(fd < 0){
    31ba:	85 c0                	test   %eax,%eax
    31bc:	0f 88 53 02 00 00    	js     3415 <concreate+0x2b5>
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    31c2:	89 04 24             	mov    %eax,(%esp)
    31c5:	e8 06 0b 00 00       	call   3cd0 <close>
    }
    if(pid == 0)
    31ca:	85 ff                	test   %edi,%edi
    31cc:	74 52                	je     3220 <concreate+0xc0>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    31ce:	83 c3 01             	add    $0x1,%ebx
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    31d1:	e8 da 0a 00 00       	call   3cb0 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    31d6:	83 fb 28             	cmp    $0x28,%ebx
    31d9:	74 6d                	je     3248 <concreate+0xe8>
    file[1] = '0' + i;
    31db:	8d 43 30             	lea    0x30(%ebx),%eax
    31de:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    31e1:	89 34 24             	mov    %esi,(%esp)
    31e4:	e8 0f 0b 00 00       	call   3cf8 <unlink>
    pid = fork();
    31e9:	e8 b2 0a 00 00       	call   3ca0 <fork>
    if(pid && (i % 3) == 1){
    31ee:	85 c0                	test   %eax,%eax
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    31f0:	89 c7                	mov    %eax,%edi
    if(pid && (i % 3) == 1){
    31f2:	75 9c                	jne    3190 <concreate+0x30>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    31f4:	b8 67 66 66 66       	mov    $0x66666667,%eax
    31f9:	f7 eb                	imul   %ebx
    31fb:	89 d8                	mov    %ebx,%eax
    31fd:	c1 f8 1f             	sar    $0x1f,%eax
    3200:	d1 fa                	sar    %edx
    3202:	29 c2                	sub    %eax,%edx
    3204:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3207:	89 da                	mov    %ebx,%edx
    3209:	29 c2                	sub    %eax,%edx
    320b:	83 fa 01             	cmp    $0x1,%edx
    320e:	75 9a                	jne    31aa <concreate+0x4a>
      link("C0", file);
    3210:	89 74 24 04          	mov    %esi,0x4(%esp)
    3214:	c7 04 24 1b 50 00 00 	movl   $0x501b,(%esp)
    321b:	e8 e8 0a 00 00       	call   3d08 <link>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
        exit();
    3220:	e8 83 0a 00 00       	call   3ca8 <exit>
    3225:	8d 76 00             	lea    0x0(%esi),%esi
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    3228:	83 c3 01             	add    $0x1,%ebx
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    322b:	89 74 24 04          	mov    %esi,0x4(%esp)
    322f:	c7 04 24 1b 50 00 00 	movl   $0x501b,(%esp)
    3236:	e8 cd 0a 00 00       	call   3d08 <link>
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    323b:	e8 70 0a 00 00       	call   3cb0 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    3240:	83 fb 28             	cmp    $0x28,%ebx
    3243:	75 96                	jne    31db <concreate+0x7b>
    3245:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    3248:	8d 45 ac             	lea    -0x54(%ebp),%eax
    324b:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    3252:	00 
    3253:	8d 7d d4             	lea    -0x2c(%ebp),%edi
    3256:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    325d:	00 
    325e:	89 04 24             	mov    %eax,(%esp)
    3261:	e8 ba 08 00 00       	call   3b20 <memset>
  fd = open(".", 0);
    3266:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    326d:	00 
    326e:	c7 04 24 92 4c 00 00 	movl   $0x4c92,(%esp)
    3275:	e8 6e 0a 00 00       	call   3ce8 <open>
    327a:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
    3281:	89 c3                	mov    %eax,%ebx
    3283:	90                   	nop
    3284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    3288:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    328f:	00 
    3290:	89 7c 24 04          	mov    %edi,0x4(%esp)
    3294:	89 1c 24             	mov    %ebx,(%esp)
    3297:	e8 24 0a 00 00       	call   3cc0 <read>
    329c:	85 c0                	test   %eax,%eax
    329e:	7e 40                	jle    32e0 <concreate+0x180>
    if(de.inum == 0)
    32a0:	66 83 7d d4 00       	cmpw   $0x0,-0x2c(%ebp)
    32a5:	74 e1                	je     3288 <concreate+0x128>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    32a7:	80 7d d6 43          	cmpb   $0x43,-0x2a(%ebp)
    32ab:	75 db                	jne    3288 <concreate+0x128>
    32ad:	80 7d d8 00          	cmpb   $0x0,-0x28(%ebp)
    32b1:	75 d5                	jne    3288 <concreate+0x128>
      i = de.name[1] - '0';
    32b3:	0f be 45 d7          	movsbl -0x29(%ebp),%eax
    32b7:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    32ba:	83 f8 27             	cmp    $0x27,%eax
    32bd:	0f 87 6f 01 00 00    	ja     3432 <concreate+0x2d2>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    32c3:	80 7c 05 ac 00       	cmpb   $0x0,-0x54(%ebp,%eax,1)
    32c8:	0f 85 9d 01 00 00    	jne    346b <concreate+0x30b>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    32ce:	c6 44 05 ac 01       	movb   $0x1,-0x54(%ebp,%eax,1)
      n++;
    32d3:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
    32d7:	eb af                	jmp    3288 <concreate+0x128>
    32d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  close(fd);
    32e0:	89 1c 24             	mov    %ebx,(%esp)
    32e3:	e8 e8 09 00 00       	call   3cd0 <close>

  if(n != 40){
    32e8:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    32ec:	0f 85 60 01 00 00    	jne    3452 <concreate+0x2f2>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
    32f2:	31 db                	xor    %ebx,%ebx
    32f4:	e9 8d 00 00 00       	jmp    3386 <concreate+0x226>
    32f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    3300:	83 f8 01             	cmp    $0x1,%eax
    3303:	0f 85 b1 00 00 00    	jne    33ba <concreate+0x25a>
    3309:	85 ff                	test   %edi,%edi
    330b:	0f 84 a9 00 00 00    	je     33ba <concreate+0x25a>
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    3311:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3318:	00 
    3319:	89 34 24             	mov    %esi,(%esp)
    331c:	e8 c7 09 00 00       	call   3ce8 <open>
    3321:	89 04 24             	mov    %eax,(%esp)
    3324:	e8 a7 09 00 00       	call   3cd0 <close>
      close(open(file, 0));
    3329:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3330:	00 
    3331:	89 34 24             	mov    %esi,(%esp)
    3334:	e8 af 09 00 00       	call   3ce8 <open>
    3339:	89 04 24             	mov    %eax,(%esp)
    333c:	e8 8f 09 00 00       	call   3cd0 <close>
      close(open(file, 0));
    3341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3348:	00 
    3349:	89 34 24             	mov    %esi,(%esp)
    334c:	e8 97 09 00 00       	call   3ce8 <open>
    3351:	89 04 24             	mov    %eax,(%esp)
    3354:	e8 77 09 00 00       	call   3cd0 <close>
      close(open(file, 0));
    3359:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3360:	00 
    3361:	89 34 24             	mov    %esi,(%esp)
    3364:	e8 7f 09 00 00       	call   3ce8 <open>
    3369:	89 04 24             	mov    %eax,(%esp)
    336c:	e8 5f 09 00 00       	call   3cd0 <close>
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    3371:	85 ff                	test   %edi,%edi
    3373:	0f 84 a7 fe ff ff    	je     3220 <concreate+0xc0>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    3379:	83 c3 01             	add    $0x1,%ebx
      unlink(file);
    }
    if(pid == 0)
      exit();
    else
      wait();
    337c:	e8 2f 09 00 00       	call   3cb0 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    3381:	83 fb 28             	cmp    $0x28,%ebx
    3384:	74 5a                	je     33e0 <concreate+0x280>
    file[1] = '0' + i;
    3386:	8d 43 30             	lea    0x30(%ebx),%eax
    3389:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    338c:	e8 0f 09 00 00       	call   3ca0 <fork>
    if(pid < 0){
    3391:	85 c0                	test   %eax,%eax
    exit();
  }

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    3393:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    3395:	78 65                	js     33fc <concreate+0x29c>
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    3397:	b8 56 55 55 55       	mov    $0x55555556,%eax
    339c:	f7 eb                	imul   %ebx
    339e:	89 d8                	mov    %ebx,%eax
    33a0:	c1 f8 1f             	sar    $0x1f,%eax
    33a3:	29 c2                	sub    %eax,%edx
    33a5:	89 d8                	mov    %ebx,%eax
    33a7:	8d 14 52             	lea    (%edx,%edx,2),%edx
    33aa:	29 d0                	sub    %edx,%eax
    33ac:	0f 85 4e ff ff ff    	jne    3300 <concreate+0x1a0>
    33b2:	85 ff                	test   %edi,%edi
    33b4:	0f 84 57 ff ff ff    	je     3311 <concreate+0x1b1>
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
    } else {
      unlink(file);
    33ba:	89 34 24             	mov    %esi,(%esp)
    33bd:	e8 36 09 00 00       	call   3cf8 <unlink>
      unlink(file);
    33c2:	89 34 24             	mov    %esi,(%esp)
    33c5:	e8 2e 09 00 00       	call   3cf8 <unlink>
      unlink(file);
    33ca:	89 34 24             	mov    %esi,(%esp)
    33cd:	e8 26 09 00 00       	call   3cf8 <unlink>
      unlink(file);
    33d2:	89 34 24             	mov    %esi,(%esp)
    33d5:	e8 1e 09 00 00       	call   3cf8 <unlink>
    33da:	eb 95                	jmp    3371 <concreate+0x211>
    33dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    33e0:	c7 44 24 04 70 50 00 	movl   $0x5070,0x4(%esp)
    33e7:	00 
    33e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33ef:	e8 ec 09 00 00       	call   3de0 <printf>
}
    33f4:	83 c4 6c             	add    $0x6c,%esp
    33f7:	5b                   	pop    %ebx
    33f8:	5e                   	pop    %esi
    33f9:	5f                   	pop    %edi
    33fa:	5d                   	pop    %ebp
    33fb:	c3                   	ret    

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    33fc:	c7 44 24 04 bf 45 00 	movl   $0x45bf,0x4(%esp)
    3403:	00 
    3404:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    340b:	e8 d0 09 00 00       	call   3de0 <printf>
      exit();
    3410:	e8 93 08 00 00       	call   3ca8 <exit>
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "concreate create %s failed\n", file);
    3415:	89 74 24 08          	mov    %esi,0x8(%esp)
    3419:	c7 44 24 04 1e 50 00 	movl   $0x501e,0x4(%esp)
    3420:	00 
    3421:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3428:	e8 b3 09 00 00       	call   3de0 <printf>
        exit();
    342d:	e8 76 08 00 00       	call   3ca8 <exit>
    if(de.inum == 0)
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
    3432:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    3435:	89 44 24 08          	mov    %eax,0x8(%esp)
    3439:	c7 44 24 04 3a 50 00 	movl   $0x503a,0x4(%esp)
    3440:	00 
    3441:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3448:	e8 93 09 00 00       	call   3de0 <printf>
    344d:	e9 ce fd ff ff       	jmp    3220 <concreate+0xc0>
    }
  }
  close(fd);

  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    3452:	c7 44 24 04 08 58 00 	movl   $0x5808,0x4(%esp)
    3459:	00 
    345a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3461:	e8 7a 09 00 00       	call   3de0 <printf>
    exit();
    3466:	e8 3d 08 00 00       	call   3ca8 <exit>
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
        printf(1, "concreate duplicate file %s\n", de.name);
    346b:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    346e:	89 44 24 08          	mov    %eax,0x8(%esp)
    3472:	c7 44 24 04 53 50 00 	movl   $0x5053,0x4(%esp)
    3479:	00 
    347a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3481:	e8 5a 09 00 00       	call   3de0 <printf>
        exit();
    3486:	e8 1d 08 00 00       	call   3ca8 <exit>
    348b:	90                   	nop
    348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003490 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    3490:	55                   	push   %ebp
    3491:	89 e5                	mov    %esp,%ebp
    3493:	57                   	push   %edi
    3494:	56                   	push   %esi
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");
    3495:	be 7e 50 00 00       	mov    $0x507e,%esi

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    349a:	53                   	push   %ebx
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");
    349b:	31 db                	xor    %ebx,%ebx

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    349d:	83 ec 3c             	sub    $0x3c,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");
    34a0:	c7 44 24 04 84 50 00 	movl   $0x5084,0x4(%esp)
    34a7:	00 

  for(pi = 0; pi < 4; pi++){
    34a8:	8d 7d d8             	lea    -0x28(%ebp),%edi
// time, to test block allocation.
void
fourfiles(void)
{
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    34ab:	c7 45 d8 7e 50 00 00 	movl   $0x507e,-0x28(%ebp)
    34b2:	c7 45 dc c7 46 00 00 	movl   $0x46c7,-0x24(%ebp)
    34b9:	c7 45 e0 cb 46 00 00 	movl   $0x46cb,-0x20(%ebp)
    34c0:	c7 45 e4 81 50 00 00 	movl   $0x5081,-0x1c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    34c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34ce:	e8 0d 09 00 00       	call   3de0 <printf>

  for(pi = 0; pi < 4; pi++){
    fname = names[pi];
    unlink(fname);
    34d3:	89 34 24             	mov    %esi,(%esp)
    34d6:	e8 1d 08 00 00       	call   3cf8 <unlink>

    pid = fork();
    34db:	e8 c0 07 00 00       	call   3ca0 <fork>
    if(pid < 0){
    34e0:	83 f8 00             	cmp    $0x0,%eax
    34e3:	0f 8c 88 01 00 00    	jl     3671 <fourfiles+0x1e1>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
    34e9:	0f 84 e8 00 00 00    	je     35d7 <fourfiles+0x147>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    34ef:	83 c3 01             	add    $0x1,%ebx
    34f2:	83 fb 04             	cmp    $0x4,%ebx
    34f5:	74 05                	je     34fc <fourfiles+0x6c>
    34f7:	8b 34 9f             	mov    (%edi,%ebx,4),%esi
    34fa:	eb d7                	jmp    34d3 <fourfiles+0x43>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
    34fc:	e8 af 07 00 00       	call   3cb0 <wait>
    3501:	bb 30 00 00 00       	mov    $0x30,%ebx
    3506:	e8 a5 07 00 00       	call   3cb0 <wait>
    350b:	e8 a0 07 00 00       	call   3cb0 <wait>
    3510:	e8 9b 07 00 00       	call   3cb0 <wait>
    3515:	c7 45 d4 7e 50 00 00 	movl   $0x507e,-0x2c(%ebp)
  }

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    351c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    351f:	31 f6                	xor    %esi,%esi
    3521:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3528:	00 
    3529:	89 04 24             	mov    %eax,(%esp)
    352c:	e8 b7 07 00 00       	call   3ce8 <open>
    3531:	89 c7                	mov    %eax,%edi
    3533:	90                   	nop
    3534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3538:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    353f:	00 
    3540:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    3547:	00 
    3548:	89 3c 24             	mov    %edi,(%esp)
    354b:	e8 70 07 00 00       	call   3cc0 <read>
    3550:	85 c0                	test   %eax,%eax
    3552:	7e 1a                	jle    356e <fourfiles+0xde>
    3554:	31 d2                	xor    %edx,%edx
    3556:	66 90                	xchg   %ax,%ax
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
    3558:	0f be 8a e0 80 00 00 	movsbl 0x80e0(%edx),%ecx
    355f:	39 d9                	cmp    %ebx,%ecx
    3561:	75 5b                	jne    35be <fourfiles+0x12e>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    3563:	83 c2 01             	add    $0x1,%edx
    3566:	39 d0                	cmp    %edx,%eax
    3568:	7f ee                	jg     3558 <fourfiles+0xc8>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    356a:	01 c6                	add    %eax,%esi
    356c:	eb ca                	jmp    3538 <fourfiles+0xa8>
    }
    close(fd);
    356e:	89 3c 24             	mov    %edi,(%esp)
    3571:	e8 5a 07 00 00       	call   3cd0 <close>
    if(total != 12*500){
    3576:	81 fe 70 17 00 00    	cmp    $0x1770,%esi
    357c:	0f 85 d2 00 00 00    	jne    3654 <fourfiles+0x1c4>
      printf(1, "wrong length %d\n", total);
      exit();
    }
    unlink(fname);
    3582:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3585:	89 04 24             	mov    %eax,(%esp)
    3588:	e8 6b 07 00 00       	call   3cf8 <unlink>

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    358d:	83 fb 31             	cmp    $0x31,%ebx
    3590:	75 1c                	jne    35ae <fourfiles+0x11e>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    3592:	c7 44 24 04 c2 50 00 	movl   $0x50c2,0x4(%esp)
    3599:	00 
    359a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35a1:	e8 3a 08 00 00       	call   3de0 <printf>
}
    35a6:	83 c4 3c             	add    $0x3c,%esp
    35a9:	5b                   	pop    %ebx
    35aa:	5e                   	pop    %esi
    35ab:	5f                   	pop    %edi
    35ac:	5d                   	pop    %ebp
    35ad:	c3                   	ret    

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    35ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
    35b1:	bb 31 00 00 00       	mov    $0x31,%ebx
    35b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    35b9:	e9 5e ff ff ff       	jmp    351c <fourfiles+0x8c>
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
    35be:	c7 44 24 04 a5 50 00 	movl   $0x50a5,0x4(%esp)
    35c5:	00 
    35c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35cd:	e8 0e 08 00 00       	call   3de0 <printf>
          exit();
    35d2:	e8 d1 06 00 00       	call   3ca8 <exit>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
      fd = open(fname, O_CREATE | O_RDWR);
    35d7:	89 34 24             	mov    %esi,(%esp)
    35da:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    35e1:	00 
    35e2:	e8 01 07 00 00       	call   3ce8 <open>
      if(fd < 0){
    35e7:	85 c0                	test   %eax,%eax
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
      fd = open(fname, O_CREATE | O_RDWR);
    35e9:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    35eb:	0f 88 99 00 00 00    	js     368a <fourfiles+0x1fa>
        printf(1, "create failed\n");
        exit();
      }

      memset(buf, '0'+pi, 512);
    35f1:	83 c3 30             	add    $0x30,%ebx
    35f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    35f8:	31 db                	xor    %ebx,%ebx
    35fa:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    3601:	00 
    3602:	c7 04 24 e0 80 00 00 	movl   $0x80e0,(%esp)
    3609:	e8 12 05 00 00       	call   3b20 <memset>
    360e:	eb 08                	jmp    3618 <fourfiles+0x188>
      for(i = 0; i < 12; i++){
    3610:	83 c3 01             	add    $0x1,%ebx
    3613:	83 fb 0c             	cmp    $0xc,%ebx
    3616:	74 ba                	je     35d2 <fourfiles+0x142>
        if((n = write(fd, buf, 500)) != 500){
    3618:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    361f:	00 
    3620:	c7 44 24 04 e0 80 00 	movl   $0x80e0,0x4(%esp)
    3627:	00 
    3628:	89 34 24             	mov    %esi,(%esp)
    362b:	e8 98 06 00 00       	call   3cc8 <write>
    3630:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    3635:	74 d9                	je     3610 <fourfiles+0x180>
          printf(1, "write failed %d\n", n);
    3637:	89 44 24 08          	mov    %eax,0x8(%esp)
    363b:	c7 44 24 04 94 50 00 	movl   $0x5094,0x4(%esp)
    3642:	00 
    3643:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    364a:	e8 91 07 00 00       	call   3de0 <printf>
          exit();
    364f:	e8 54 06 00 00       	call   3ca8 <exit>
      }
      total += n;
    }
    close(fd);
    if(total != 12*500){
      printf(1, "wrong length %d\n", total);
    3654:	89 74 24 08          	mov    %esi,0x8(%esp)
    3658:	c7 44 24 04 b1 50 00 	movl   $0x50b1,0x4(%esp)
    365f:	00 
    3660:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3667:	e8 74 07 00 00       	call   3de0 <printf>
      exit();
    366c:	e8 37 06 00 00       	call   3ca8 <exit>
    fname = names[pi];
    unlink(fname);

    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    3671:	c7 44 24 04 bf 45 00 	movl   $0x45bf,0x4(%esp)
    3678:	00 
    3679:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3680:	e8 5b 07 00 00       	call   3de0 <printf>
      exit();
    3685:	e8 1e 06 00 00       	call   3ca8 <exit>
    }

    if(pid == 0){
      fd = open(fname, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "create failed\n");
    368a:	c7 44 24 04 55 46 00 	movl   $0x4655,0x4(%esp)
    3691:	00 
    3692:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3699:	e8 42 07 00 00       	call   3de0 <printf>
        exit();
    369e:	e8 05 06 00 00       	call   3ca8 <exit>
    36a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    36a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000036b0 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    36b0:	55                   	push   %ebp
    36b1:	89 e5                	mov    %esp,%ebp
    36b3:	57                   	push   %edi
    36b4:	56                   	push   %esi
    36b5:	53                   	push   %ebx
    36b6:	83 ec 3c             	sub    $0x3c,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
    36b9:	c7 44 24 04 d0 50 00 	movl   $0x50d0,0x4(%esp)
    36c0:	00 
    36c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36c8:	e8 13 07 00 00       	call   3de0 <printf>

  unlink("sharedfd");
    36cd:	c7 04 24 df 50 00 00 	movl   $0x50df,(%esp)
    36d4:	e8 1f 06 00 00       	call   3cf8 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    36d9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    36e0:	00 
    36e1:	c7 04 24 df 50 00 00 	movl   $0x50df,(%esp)
    36e8:	e8 fb 05 00 00       	call   3ce8 <open>
  if(fd < 0){
    36ed:	85 c0                	test   %eax,%eax
  char buf[10];

  printf(1, "sharedfd test\n");

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
    36ef:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    36f1:	0f 88 2d 01 00 00    	js     3824 <sharedfd+0x174>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    36f7:	e8 a4 05 00 00       	call   3ca0 <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
    36fc:	8d 75 de             	lea    -0x22(%ebp),%esi
    36ff:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    3706:	00 
    3707:	89 34 24             	mov    %esi,(%esp)
    370a:	83 f8 01             	cmp    $0x1,%eax
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    370d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3710:	19 c0                	sbb    %eax,%eax
    3712:	31 db                	xor    %ebx,%ebx
    3714:	83 e0 f3             	and    $0xfffffff3,%eax
    3717:	83 c0 70             	add    $0x70,%eax
    371a:	89 44 24 04          	mov    %eax,0x4(%esp)
    371e:	e8 fd 03 00 00       	call   3b20 <memset>
    3723:	eb 0e                	jmp    3733 <sharedfd+0x83>
    3725:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < 1000; i++){
    3728:	83 c3 01             	add    $0x1,%ebx
    372b:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    3731:	74 2d                	je     3760 <sharedfd+0xb0>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3733:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    373a:	00 
    373b:	89 74 24 04          	mov    %esi,0x4(%esp)
    373f:	89 3c 24             	mov    %edi,(%esp)
    3742:	e8 81 05 00 00       	call   3cc8 <write>
    3747:	83 f8 0a             	cmp    $0xa,%eax
    374a:	74 dc                	je     3728 <sharedfd+0x78>
      printf(1, "fstests: write sharedfd failed\n");
    374c:	c7 44 24 04 68 58 00 	movl   $0x5868,0x4(%esp)
    3753:	00 
    3754:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    375b:	e8 80 06 00 00       	call   3de0 <printf>
      break;
    }
  }
  if(pid == 0)
    3760:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    3763:	85 d2                	test   %edx,%edx
    3765:	0f 84 07 01 00 00    	je     3872 <sharedfd+0x1c2>
    exit();
  else
    wait();
    376b:	e8 40 05 00 00       	call   3cb0 <wait>
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    3770:	31 db                	xor    %ebx,%ebx
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    3772:	89 3c 24             	mov    %edi,(%esp)
  fd = open("sharedfd", 0);
  if(fd < 0){
    3775:	31 ff                	xor    %edi,%edi
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    3777:	e8 54 05 00 00       	call   3cd0 <close>
  fd = open("sharedfd", 0);
    377c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3783:	00 
    3784:	c7 04 24 df 50 00 00 	movl   $0x50df,(%esp)
    378b:	e8 58 05 00 00       	call   3ce8 <open>
  if(fd < 0){
    3790:	85 c0                	test   %eax,%eax
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
    3792:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
    3795:	0f 88 a5 00 00 00    	js     3840 <sharedfd+0x190>
    379b:	90                   	nop
    379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    37a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    37a3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    37aa:	00 
    37ab:	89 74 24 04          	mov    %esi,0x4(%esp)
    37af:	89 04 24             	mov    %eax,(%esp)
    37b2:	e8 09 05 00 00       	call   3cc0 <read>
    37b7:	85 c0                	test   %eax,%eax
    37b9:	7e 26                	jle    37e1 <sharedfd+0x131>
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
    37bb:	31 c0                	xor    %eax,%eax
    37bd:	eb 14                	jmp    37d3 <sharedfd+0x123>
    37bf:	90                   	nop
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
        nc++;
      if(buf[i] == 'p')
        np++;
    37c0:	80 fa 70             	cmp    $0x70,%dl
    37c3:	0f 94 c2             	sete   %dl
    37c6:	0f b6 d2             	movzbl %dl,%edx
    37c9:	01 d3                	add    %edx,%ebx
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
    37cb:	83 c0 01             	add    $0x1,%eax
    37ce:	83 f8 0a             	cmp    $0xa,%eax
    37d1:	74 cd                	je     37a0 <sharedfd+0xf0>
      if(buf[i] == 'c')
    37d3:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
    37d7:	80 fa 63             	cmp    $0x63,%dl
    37da:	75 e4                	jne    37c0 <sharedfd+0x110>
        nc++;
    37dc:	83 c7 01             	add    $0x1,%edi
    37df:	eb ea                	jmp    37cb <sharedfd+0x11b>
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
    37e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    37e4:	89 04 24             	mov    %eax,(%esp)
    37e7:	e8 e4 04 00 00       	call   3cd0 <close>
  unlink("sharedfd");
    37ec:	c7 04 24 df 50 00 00 	movl   $0x50df,(%esp)
    37f3:	e8 00 05 00 00       	call   3cf8 <unlink>
  if(nc == 10000 && np == 10000){
    37f8:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    37fe:	75 56                	jne    3856 <sharedfd+0x1a6>
    3800:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
    3806:	75 4e                	jne    3856 <sharedfd+0x1a6>
    printf(1, "sharedfd ok\n");
    3808:	c7 44 24 04 e8 50 00 	movl   $0x50e8,0x4(%esp)
    380f:	00 
    3810:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3817:	e8 c4 05 00 00       	call   3de0 <printf>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
    381c:	83 c4 3c             	add    $0x3c,%esp
    381f:	5b                   	pop    %ebx
    3820:	5e                   	pop    %esi
    3821:	5f                   	pop    %edi
    3822:	5d                   	pop    %ebp
    3823:	c3                   	ret    
  printf(1, "sharedfd test\n");

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    3824:	c7 44 24 04 3c 58 00 	movl   $0x583c,0x4(%esp)
    382b:	00 
    382c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3833:	e8 a8 05 00 00       	call   3de0 <printf>
    printf(1, "sharedfd ok\n");
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
    3838:	83 c4 3c             	add    $0x3c,%esp
    383b:	5b                   	pop    %ebx
    383c:	5e                   	pop    %esi
    383d:	5f                   	pop    %edi
    383e:	5d                   	pop    %ebp
    383f:	c3                   	ret    
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    3840:	c7 44 24 04 88 58 00 	movl   $0x5888,0x4(%esp)
    3847:	00 
    3848:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    384f:	e8 8c 05 00 00       	call   3de0 <printf>
    return;
    3854:	eb c6                	jmp    381c <sharedfd+0x16c>
  close(fd);
  unlink("sharedfd");
  if(nc == 10000 && np == 10000){
    printf(1, "sharedfd ok\n");
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    3856:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    385a:	89 7c 24 08          	mov    %edi,0x8(%esp)
    385e:	c7 44 24 04 f5 50 00 	movl   $0x50f5,0x4(%esp)
    3865:	00 
    3866:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    386d:	e8 6e 05 00 00       	call   3de0 <printf>
    exit();
    3872:	e8 31 04 00 00       	call   3ca8 <exit>
    3877:	89 f6                	mov    %esi,%esi
    3879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003880 <mem>:
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    3880:	55                   	push   %ebp
    3881:	89 e5                	mov    %esp,%ebp
    3883:	57                   	push   %edi
    3884:	56                   	push   %esi
    3885:	53                   	push   %ebx
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    3886:	31 db                	xor    %ebx,%ebx
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    3888:	83 ec 1c             	sub    $0x1c,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
    388b:	c7 44 24 04 0a 51 00 	movl   $0x510a,0x4(%esp)
    3892:	00 
    3893:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    389a:	e8 41 05 00 00       	call   3de0 <printf>
  ppid = getpid();
    389f:	e8 84 04 00 00       	call   3d28 <getpid>
    38a4:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
    38a6:	e8 f5 03 00 00       	call   3ca0 <fork>
    38ab:	85 c0                	test   %eax,%eax
    38ad:	74 0d                	je     38bc <mem+0x3c>
    38af:	90                   	nop
    38b0:	eb 5f                	jmp    3911 <mem+0x91>
    38b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
    38b8:	89 18                	mov    %ebx,(%eax)
    38ba:	89 c3                	mov    %eax,%ebx

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
    38bc:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
    38c3:	e8 98 07 00 00       	call   4060 <malloc>
    38c8:	85 c0                	test   %eax,%eax
    38ca:	75 ec                	jne    38b8 <mem+0x38>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
    38cc:	85 db                	test   %ebx,%ebx
    38ce:	74 10                	je     38e0 <mem+0x60>
      m2 = *(char**)m1;
    38d0:	8b 3b                	mov    (%ebx),%edi
      free(m1);
    38d2:	89 1c 24             	mov    %ebx,(%esp)
    38d5:	e8 f6 06 00 00       	call   3fd0 <free>
    38da:	89 fb                	mov    %edi,%ebx
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
    38dc:	85 db                	test   %ebx,%ebx
    38de:	75 f0                	jne    38d0 <mem+0x50>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
    38e0:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
    38e7:	e8 74 07 00 00       	call   4060 <malloc>
    if(m1 == 0){
    38ec:	85 c0                	test   %eax,%eax
    38ee:	74 30                	je     3920 <mem+0xa0>
      printf(1, "couldn't allocate mem?!!\n");
      kill(ppid);
      exit();
    }
    free(m1);
    38f0:	89 04 24             	mov    %eax,(%esp)
    38f3:	e8 d8 06 00 00       	call   3fd0 <free>
    printf(1, "mem ok\n");
    38f8:	c7 44 24 04 2e 51 00 	movl   $0x512e,0x4(%esp)
    38ff:	00 
    3900:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3907:	e8 d4 04 00 00       	call   3de0 <printf>
    exit();
    390c:	e8 97 03 00 00       	call   3ca8 <exit>
  } else {
    wait();
  }
}
    3911:	83 c4 1c             	add    $0x1c,%esp
    3914:	5b                   	pop    %ebx
    3915:	5e                   	pop    %esi
    3916:	5f                   	pop    %edi
    3917:	5d                   	pop    %ebp
    }
    free(m1);
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
    3918:	e9 93 03 00 00       	jmp    3cb0 <wait>
    391d:	8d 76 00             	lea    0x0(%esi),%esi
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
    if(m1 == 0){
      printf(1, "couldn't allocate mem?!!\n");
    3920:	c7 44 24 04 14 51 00 	movl   $0x5114,0x4(%esp)
    3927:	00 
    3928:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    392f:	e8 ac 04 00 00       	call   3de0 <printf>
      kill(ppid);
    3934:	89 34 24             	mov    %esi,(%esp)
    3937:	e8 9c 03 00 00       	call   3cd8 <kill>
      exit();
    393c:	e8 67 03 00 00       	call   3ca8 <exit>
    3941:	eb 0d                	jmp    3950 <main>
    3943:	90                   	nop
    3944:	90                   	nop
    3945:	90                   	nop
    3946:	90                   	nop
    3947:	90                   	nop
    3948:	90                   	nop
    3949:	90                   	nop
    394a:	90                   	nop
    394b:	90                   	nop
    394c:	90                   	nop
    394d:	90                   	nop
    394e:	90                   	nop
    394f:	90                   	nop

00003950 <main>:
  return randstate;
}

int
main(int argc, char *argv[])
{
    3950:	55                   	push   %ebp
    3951:	89 e5                	mov    %esp,%ebp
    3953:	83 e4 f0             	and    $0xfffffff0,%esp
    3956:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    3959:	c7 44 24 04 36 51 00 	movl   $0x5136,0x4(%esp)
    3960:	00 
    3961:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3968:	e8 73 04 00 00       	call   3de0 <printf>

  if(open("usertests.ran", 0) >= 0){
    396d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3974:	00 
    3975:	c7 04 24 4a 51 00 00 	movl   $0x514a,(%esp)
    397c:	e8 67 03 00 00       	call   3ce8 <open>
    3981:	85 c0                	test   %eax,%eax
    3983:	78 1b                	js     39a0 <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3985:	c7 44 24 04 b4 58 00 	movl   $0x58b4,0x4(%esp)
    398c:	00 
    398d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3994:	e8 47 04 00 00       	call   3de0 <printf>
    exit();
    3999:	e8 0a 03 00 00       	call   3ca8 <exit>
    399e:	66 90                	xchg   %ax,%ax
  }
  close(open("usertests.ran", O_CREATE));
    39a0:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    39a7:	00 
    39a8:	c7 04 24 4a 51 00 00 	movl   $0x514a,(%esp)
    39af:	e8 34 03 00 00       	call   3ce8 <open>
    39b4:	89 04 24             	mov    %eax,(%esp)
    39b7:	e8 14 03 00 00       	call   3cd0 <close>

  argptest();
    39bc:	e8 8f c7 ff ff       	call   150 <argptest>
  createdelete();
    39c1:	e8 da ce ff ff       	call   8a0 <createdelete>
  linkunlink();
    39c6:	e8 15 d9 ff ff       	call   12e0 <linkunlink>
    39cb:	90                   	nop
    39cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  concreate();
    39d0:	e8 8b f7 ff ff       	call   3160 <concreate>
  fourfiles();
    39d5:	e8 b6 fa ff ff       	call   3490 <fourfiles>
  sharedfd();
    39da:	e8 d1 fc ff ff       	call   36b0 <sharedfd>
    39df:	90                   	nop

  bigargtest();
    39e0:	e8 9b d5 ff ff       	call   f80 <bigargtest>
  bigwrite();
    39e5:	e8 e6 cb ff ff       	call   5d0 <bigwrite>
  bigargtest();
    39ea:	e8 91 d5 ff ff       	call   f80 <bigargtest>
    39ef:	90                   	nop
  bsstest();
    39f0:	e8 3b c6 ff ff       	call   30 <bsstest>
  sbrktest();
    39f5:	e8 56 dc ff ff       	call   1650 <sbrktest>
  validatetest();
    39fa:	e8 e1 d6 ff ff       	call   10e0 <validatetest>
    39ff:	90                   	nop

  opentest();
    3a00:	e8 ab c6 ff ff       	call   b0 <opentest>
  writetest();
    3a05:	e8 66 d3 ff ff       	call   d70 <writetest>
  writetest1();
    3a0a:	e8 71 d1 ff ff       	call   b80 <writetest1>
    3a0f:	90                   	nop
  createtest();
    3a10:	e8 bb d0 ff ff       	call   ad0 <createtest>

  openiputtest();
    3a15:	e8 06 e5 ff ff       	call   1f20 <openiputtest>
  exitiputtest();
    3a1a:	e8 71 f3 ff ff       	call   2d90 <exitiputtest>
    3a1f:	90                   	nop
  iputtest();
    3a20:	e8 5b f4 ff ff       	call   2e80 <iputtest>

  mem();
    3a25:	e8 56 fe ff ff       	call   3880 <mem>
  pipe1();
    3a2a:	e8 e1 e1 ff ff       	call   1c10 <pipe1>
    3a2f:	90                   	nop
  preempt();
    3a30:	e8 7b e0 ff ff       	call   1ab0 <preempt>
  exitwait();
    3a35:	e8 f6 c8 ff ff       	call   330 <exitwait>

  rmdot();
    3a3a:	e8 51 e9 ff ff       	call   2390 <rmdot>
    3a3f:	90                   	nop
  fourteen();
    3a40:	e8 7b e3 ff ff       	call   1dc0 <fourteen>
  bigfile();
    3a45:	e8 16 f5 ff ff       	call   2f60 <bigfile>
  subdir();
    3a4a:	e8 d1 ea ff ff       	call   2520 <subdir>
    3a4f:	90                   	nop
  linktest();
    3a50:	e8 9b d9 ff ff       	call   13f0 <linktest>
  unlinkread();
    3a55:	e8 76 cc ff ff       	call   6d0 <unlinkread>
  dirfile();
    3a5a:	e8 f1 e6 ff ff       	call   2150 <dirfile>
    3a5f:	90                   	nop
  iref();
    3a60:	e8 cb e5 ff ff       	call   2030 <iref>
  forktest();
    3a65:	e8 f6 c7 ff ff       	call   260 <forktest>
  bigdir(); // slow
    3a6a:	e8 21 d7 ff ff       	call   1190 <bigdir>
    3a6f:	90                   	nop

  uio();
    3a70:	e8 5b c7 ff ff       	call   1d0 <uio>

  exectest();
    3a75:	e8 16 d6 ff ff       	call   1090 <exectest>

  exit();
    3a7a:	e8 29 02 00 00       	call   3ca8 <exit>
    3a7f:	90                   	nop

00003a80 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3a80:	55                   	push   %ebp
    3a81:	31 d2                	xor    %edx,%edx
    3a83:	89 e5                	mov    %esp,%ebp
    3a85:	8b 45 08             	mov    0x8(%ebp),%eax
    3a88:	53                   	push   %ebx
    3a89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    3a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3a90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
    3a94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    3a97:	83 c2 01             	add    $0x1,%edx
    3a9a:	84 c9                	test   %cl,%cl
    3a9c:	75 f2                	jne    3a90 <strcpy+0x10>
    ;
  return os;
}
    3a9e:	5b                   	pop    %ebx
    3a9f:	5d                   	pop    %ebp
    3aa0:	c3                   	ret    
    3aa1:	eb 0d                	jmp    3ab0 <strcmp>
    3aa3:	90                   	nop
    3aa4:	90                   	nop
    3aa5:	90                   	nop
    3aa6:	90                   	nop
    3aa7:	90                   	nop
    3aa8:	90                   	nop
    3aa9:	90                   	nop
    3aaa:	90                   	nop
    3aab:	90                   	nop
    3aac:	90                   	nop
    3aad:	90                   	nop
    3aae:	90                   	nop
    3aaf:	90                   	nop

00003ab0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3ab0:	55                   	push   %ebp
    3ab1:	89 e5                	mov    %esp,%ebp
    3ab3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3ab6:	53                   	push   %ebx
    3ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    3aba:	0f b6 01             	movzbl (%ecx),%eax
    3abd:	84 c0                	test   %al,%al
    3abf:	75 14                	jne    3ad5 <strcmp+0x25>
    3ac1:	eb 25                	jmp    3ae8 <strcmp+0x38>
    3ac3:	90                   	nop
    3ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
    3ac8:	83 c1 01             	add    $0x1,%ecx
    3acb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3ace:	0f b6 01             	movzbl (%ecx),%eax
    3ad1:	84 c0                	test   %al,%al
    3ad3:	74 13                	je     3ae8 <strcmp+0x38>
    3ad5:	0f b6 1a             	movzbl (%edx),%ebx
    3ad8:	38 d8                	cmp    %bl,%al
    3ada:	74 ec                	je     3ac8 <strcmp+0x18>
    3adc:	0f b6 db             	movzbl %bl,%ebx
    3adf:	0f b6 c0             	movzbl %al,%eax
    3ae2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    3ae4:	5b                   	pop    %ebx
    3ae5:	5d                   	pop    %ebp
    3ae6:	c3                   	ret    
    3ae7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3ae8:	0f b6 1a             	movzbl (%edx),%ebx
    3aeb:	31 c0                	xor    %eax,%eax
    3aed:	0f b6 db             	movzbl %bl,%ebx
    3af0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    3af2:	5b                   	pop    %ebx
    3af3:	5d                   	pop    %ebp
    3af4:	c3                   	ret    
    3af5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003b00 <strlen>:

uint
strlen(char *s)
{
    3b00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
    3b01:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    3b03:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
    3b05:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    3b07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    3b0a:	80 39 00             	cmpb   $0x0,(%ecx)
    3b0d:	74 0c                	je     3b1b <strlen+0x1b>
    3b0f:	90                   	nop
    3b10:	83 c2 01             	add    $0x1,%edx
    3b13:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    3b17:	89 d0                	mov    %edx,%eax
    3b19:	75 f5                	jne    3b10 <strlen+0x10>
    ;
  return n;
}
    3b1b:	5d                   	pop    %ebp
    3b1c:	c3                   	ret    
    3b1d:	8d 76 00             	lea    0x0(%esi),%esi

00003b20 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3b20:	55                   	push   %ebp
    3b21:	89 e5                	mov    %esp,%ebp
    3b23:	8b 55 08             	mov    0x8(%ebp),%edx
    3b26:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3b27:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b2d:	89 d7                	mov    %edx,%edi
    3b2f:	fc                   	cld    
    3b30:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3b32:	89 d0                	mov    %edx,%eax
    3b34:	5f                   	pop    %edi
    3b35:	5d                   	pop    %ebp
    3b36:	c3                   	ret    
    3b37:	89 f6                	mov    %esi,%esi
    3b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003b40 <strchr>:

char*
strchr(const char *s, char c)
{
    3b40:	55                   	push   %ebp
    3b41:	89 e5                	mov    %esp,%ebp
    3b43:	8b 45 08             	mov    0x8(%ebp),%eax
    3b46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    3b4a:	0f b6 10             	movzbl (%eax),%edx
    3b4d:	84 d2                	test   %dl,%dl
    3b4f:	75 11                	jne    3b62 <strchr+0x22>
    3b51:	eb 15                	jmp    3b68 <strchr+0x28>
    3b53:	90                   	nop
    3b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3b58:	83 c0 01             	add    $0x1,%eax
    3b5b:	0f b6 10             	movzbl (%eax),%edx
    3b5e:	84 d2                	test   %dl,%dl
    3b60:	74 06                	je     3b68 <strchr+0x28>
    if(*s == c)
    3b62:	38 ca                	cmp    %cl,%dl
    3b64:	75 f2                	jne    3b58 <strchr+0x18>
      return (char*)s;
  return 0;
}
    3b66:	5d                   	pop    %ebp
    3b67:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3b68:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
    3b6a:	5d                   	pop    %ebp
    3b6b:	90                   	nop
    3b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3b70:	c3                   	ret    
    3b71:	eb 0d                	jmp    3b80 <atoi>
    3b73:	90                   	nop
    3b74:	90                   	nop
    3b75:	90                   	nop
    3b76:	90                   	nop
    3b77:	90                   	nop
    3b78:	90                   	nop
    3b79:	90                   	nop
    3b7a:	90                   	nop
    3b7b:	90                   	nop
    3b7c:	90                   	nop
    3b7d:	90                   	nop
    3b7e:	90                   	nop
    3b7f:	90                   	nop

00003b80 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    3b80:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3b81:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
    3b83:	89 e5                	mov    %esp,%ebp
    3b85:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3b88:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3b89:	0f b6 11             	movzbl (%ecx),%edx
    3b8c:	8d 5a d0             	lea    -0x30(%edx),%ebx
    3b8f:	80 fb 09             	cmp    $0x9,%bl
    3b92:	77 1c                	ja     3bb0 <atoi+0x30>
    3b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
    3b98:	0f be d2             	movsbl %dl,%edx
    3b9b:	83 c1 01             	add    $0x1,%ecx
    3b9e:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3ba1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3ba5:	0f b6 11             	movzbl (%ecx),%edx
    3ba8:	8d 5a d0             	lea    -0x30(%edx),%ebx
    3bab:	80 fb 09             	cmp    $0x9,%bl
    3bae:	76 e8                	jbe    3b98 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    3bb0:	5b                   	pop    %ebx
    3bb1:	5d                   	pop    %ebp
    3bb2:	c3                   	ret    
    3bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003bc0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3bc0:	55                   	push   %ebp
    3bc1:	89 e5                	mov    %esp,%ebp
    3bc3:	56                   	push   %esi
    3bc4:	8b 45 08             	mov    0x8(%ebp),%eax
    3bc7:	53                   	push   %ebx
    3bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3bcb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3bce:	85 db                	test   %ebx,%ebx
    3bd0:	7e 14                	jle    3be6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
    3bd2:	31 d2                	xor    %edx,%edx
    3bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
    3bd8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    3bdc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    3bdf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3be2:	39 da                	cmp    %ebx,%edx
    3be4:	75 f2                	jne    3bd8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    3be6:	5b                   	pop    %ebx
    3be7:	5e                   	pop    %esi
    3be8:	5d                   	pop    %ebp
    3be9:	c3                   	ret    
    3bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003bf0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
    3bf0:	55                   	push   %ebp
    3bf1:	89 e5                	mov    %esp,%ebp
    3bf3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
    3bf9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    3bfc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    3bff:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3c04:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3c0b:	00 
    3c0c:	89 04 24             	mov    %eax,(%esp)
    3c0f:	e8 d4 00 00 00       	call   3ce8 <open>
  if(fd < 0)
    3c14:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3c16:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    3c18:	78 19                	js     3c33 <stat+0x43>
    return -1;
  r = fstat(fd, st);
    3c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c1d:	89 1c 24             	mov    %ebx,(%esp)
    3c20:	89 44 24 04          	mov    %eax,0x4(%esp)
    3c24:	e8 d7 00 00 00       	call   3d00 <fstat>
  close(fd);
    3c29:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    3c2c:	89 c6                	mov    %eax,%esi
  close(fd);
    3c2e:	e8 9d 00 00 00       	call   3cd0 <close>
  return r;
}
    3c33:	89 f0                	mov    %esi,%eax
    3c35:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    3c38:	8b 75 fc             	mov    -0x4(%ebp),%esi
    3c3b:	89 ec                	mov    %ebp,%esp
    3c3d:	5d                   	pop    %ebp
    3c3e:	c3                   	ret    
    3c3f:	90                   	nop

00003c40 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
    3c40:	55                   	push   %ebp
    3c41:	89 e5                	mov    %esp,%ebp
    3c43:	57                   	push   %edi
    3c44:	56                   	push   %esi
    3c45:	31 f6                	xor    %esi,%esi
    3c47:	53                   	push   %ebx
    3c48:	83 ec 2c             	sub    $0x2c,%esp
    3c4b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3c4e:	eb 06                	jmp    3c56 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    3c50:	3c 0a                	cmp    $0xa,%al
    3c52:	74 39                	je     3c8d <gets+0x4d>
    3c54:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3c56:	8d 5e 01             	lea    0x1(%esi),%ebx
    3c59:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3c5c:	7d 31                	jge    3c8f <gets+0x4f>
    cc = read(0, &c, 1);
    3c5e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3c61:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3c68:	00 
    3c69:	89 44 24 04          	mov    %eax,0x4(%esp)
    3c6d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3c74:	e8 47 00 00 00       	call   3cc0 <read>
    if(cc < 1)
    3c79:	85 c0                	test   %eax,%eax
    3c7b:	7e 12                	jle    3c8f <gets+0x4f>
      break;
    buf[i++] = c;
    3c7d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    3c81:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
    3c85:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    3c89:	3c 0d                	cmp    $0xd,%al
    3c8b:	75 c3                	jne    3c50 <gets+0x10>
    3c8d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    3c8f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    3c93:	89 f8                	mov    %edi,%eax
    3c95:	83 c4 2c             	add    $0x2c,%esp
    3c98:	5b                   	pop    %ebx
    3c99:	5e                   	pop    %esi
    3c9a:	5f                   	pop    %edi
    3c9b:	5d                   	pop    %ebp
    3c9c:	c3                   	ret    
    3c9d:	90                   	nop
    3c9e:	90                   	nop
    3c9f:	90                   	nop

00003ca0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3ca0:	b8 01 00 00 00       	mov    $0x1,%eax
    3ca5:	cd 40                	int    $0x40
    3ca7:	c3                   	ret    

00003ca8 <exit>:
SYSCALL(exit)
    3ca8:	b8 02 00 00 00       	mov    $0x2,%eax
    3cad:	cd 40                	int    $0x40
    3caf:	c3                   	ret    

00003cb0 <wait>:
SYSCALL(wait)
    3cb0:	b8 03 00 00 00       	mov    $0x3,%eax
    3cb5:	cd 40                	int    $0x40
    3cb7:	c3                   	ret    

00003cb8 <pipe>:
SYSCALL(pipe)
    3cb8:	b8 04 00 00 00       	mov    $0x4,%eax
    3cbd:	cd 40                	int    $0x40
    3cbf:	c3                   	ret    

00003cc0 <read>:
SYSCALL(read)
    3cc0:	b8 05 00 00 00       	mov    $0x5,%eax
    3cc5:	cd 40                	int    $0x40
    3cc7:	c3                   	ret    

00003cc8 <write>:
SYSCALL(write)
    3cc8:	b8 10 00 00 00       	mov    $0x10,%eax
    3ccd:	cd 40                	int    $0x40
    3ccf:	c3                   	ret    

00003cd0 <close>:
SYSCALL(close)
    3cd0:	b8 15 00 00 00       	mov    $0x15,%eax
    3cd5:	cd 40                	int    $0x40
    3cd7:	c3                   	ret    

00003cd8 <kill>:
SYSCALL(kill)
    3cd8:	b8 06 00 00 00       	mov    $0x6,%eax
    3cdd:	cd 40                	int    $0x40
    3cdf:	c3                   	ret    

00003ce0 <exec>:
SYSCALL(exec)
    3ce0:	b8 07 00 00 00       	mov    $0x7,%eax
    3ce5:	cd 40                	int    $0x40
    3ce7:	c3                   	ret    

00003ce8 <open>:
SYSCALL(open)
    3ce8:	b8 0f 00 00 00       	mov    $0xf,%eax
    3ced:	cd 40                	int    $0x40
    3cef:	c3                   	ret    

00003cf0 <mknod>:
SYSCALL(mknod)
    3cf0:	b8 11 00 00 00       	mov    $0x11,%eax
    3cf5:	cd 40                	int    $0x40
    3cf7:	c3                   	ret    

00003cf8 <unlink>:
SYSCALL(unlink)
    3cf8:	b8 12 00 00 00       	mov    $0x12,%eax
    3cfd:	cd 40                	int    $0x40
    3cff:	c3                   	ret    

00003d00 <fstat>:
SYSCALL(fstat)
    3d00:	b8 08 00 00 00       	mov    $0x8,%eax
    3d05:	cd 40                	int    $0x40
    3d07:	c3                   	ret    

00003d08 <link>:
SYSCALL(link)
    3d08:	b8 13 00 00 00       	mov    $0x13,%eax
    3d0d:	cd 40                	int    $0x40
    3d0f:	c3                   	ret    

00003d10 <mkdir>:
SYSCALL(mkdir)
    3d10:	b8 14 00 00 00       	mov    $0x14,%eax
    3d15:	cd 40                	int    $0x40
    3d17:	c3                   	ret    

00003d18 <chdir>:
SYSCALL(chdir)
    3d18:	b8 09 00 00 00       	mov    $0x9,%eax
    3d1d:	cd 40                	int    $0x40
    3d1f:	c3                   	ret    

00003d20 <dup>:
SYSCALL(dup)
    3d20:	b8 0a 00 00 00       	mov    $0xa,%eax
    3d25:	cd 40                	int    $0x40
    3d27:	c3                   	ret    

00003d28 <getpid>:
SYSCALL(getpid)
    3d28:	b8 0b 00 00 00       	mov    $0xb,%eax
    3d2d:	cd 40                	int    $0x40
    3d2f:	c3                   	ret    

00003d30 <sbrk>:
SYSCALL(sbrk)
    3d30:	b8 0c 00 00 00       	mov    $0xc,%eax
    3d35:	cd 40                	int    $0x40
    3d37:	c3                   	ret    

00003d38 <sleep>:
SYSCALL(sleep)
    3d38:	b8 0d 00 00 00       	mov    $0xd,%eax
    3d3d:	cd 40                	int    $0x40
    3d3f:	c3                   	ret    

00003d40 <set_tickets>:
SYSCALL(set_tickets)
    3d40:	b8 16 00 00 00       	mov    $0x16,%eax
    3d45:	cd 40                	int    $0x40
    3d47:	c3                   	ret    
    3d48:	90                   	nop
    3d49:	90                   	nop
    3d4a:	90                   	nop
    3d4b:	90                   	nop
    3d4c:	90                   	nop
    3d4d:	90                   	nop
    3d4e:	90                   	nop
    3d4f:	90                   	nop

00003d50 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    3d50:	55                   	push   %ebp
    3d51:	89 e5                	mov    %esp,%ebp
    3d53:	57                   	push   %edi
    3d54:	89 cf                	mov    %ecx,%edi
    3d56:	56                   	push   %esi
    3d57:	89 c6                	mov    %eax,%esi
    3d59:	53                   	push   %ebx
    3d5a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    3d5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3d60:	85 c9                	test   %ecx,%ecx
    3d62:	74 04                	je     3d68 <printint+0x18>
    3d64:	85 d2                	test   %edx,%edx
    3d66:	78 68                	js     3dd0 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    3d68:	89 d0                	mov    %edx,%eax
    3d6a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    3d71:	31 c9                	xor    %ecx,%ecx
    3d73:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    3d76:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    3d78:	31 d2                	xor    %edx,%edx
    3d7a:	f7 f7                	div    %edi
    3d7c:	0f b6 92 e7 58 00 00 	movzbl 0x58e7(%edx),%edx
    3d83:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
    3d86:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
    3d89:	85 c0                	test   %eax,%eax
    3d8b:	75 eb                	jne    3d78 <printint+0x28>
  if(neg)
    3d8d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    3d90:	85 c0                	test   %eax,%eax
    3d92:	74 08                	je     3d9c <printint+0x4c>
    buf[i++] = '-';
    3d94:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
    3d99:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
    3d9c:	8d 79 ff             	lea    -0x1(%ecx),%edi
    3d9f:	90                   	nop
    3da0:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
    3da4:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3da7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3dae:	00 
    3daf:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    3db2:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3db5:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3db8:	89 44 24 04          	mov    %eax,0x4(%esp)
    3dbc:	e8 07 ff ff ff       	call   3cc8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    3dc1:	83 ff ff             	cmp    $0xffffffff,%edi
    3dc4:	75 da                	jne    3da0 <printint+0x50>
    putc(fd, buf[i]);
}
    3dc6:	83 c4 4c             	add    $0x4c,%esp
    3dc9:	5b                   	pop    %ebx
    3dca:	5e                   	pop    %esi
    3dcb:	5f                   	pop    %edi
    3dcc:	5d                   	pop    %ebp
    3dcd:	c3                   	ret    
    3dce:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    3dd0:	89 d0                	mov    %edx,%eax
    3dd2:	f7 d8                	neg    %eax
    3dd4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    3ddb:	eb 94                	jmp    3d71 <printint+0x21>
    3ddd:	8d 76 00             	lea    0x0(%esi),%esi

00003de0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3de0:	55                   	push   %ebp
    3de1:	89 e5                	mov    %esp,%ebp
    3de3:	57                   	push   %edi
    3de4:	56                   	push   %esi
    3de5:	53                   	push   %ebx
    3de6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3de9:	8b 45 0c             	mov    0xc(%ebp),%eax
    3dec:	0f b6 10             	movzbl (%eax),%edx
    3def:	84 d2                	test   %dl,%dl
    3df1:	0f 84 c1 00 00 00    	je     3eb8 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    3df7:	8d 4d 10             	lea    0x10(%ebp),%ecx
    3dfa:	31 ff                	xor    %edi,%edi
    3dfc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    3dff:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3e01:	8d 75 e7             	lea    -0x19(%ebp),%esi
    3e04:	eb 1e                	jmp    3e24 <printf+0x44>
    3e06:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    3e08:	83 fa 25             	cmp    $0x25,%edx
    3e0b:	0f 85 af 00 00 00    	jne    3ec0 <printf+0xe0>
    3e11:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3e15:	83 c3 01             	add    $0x1,%ebx
    3e18:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    3e1c:	84 d2                	test   %dl,%dl
    3e1e:	0f 84 94 00 00 00    	je     3eb8 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
    3e24:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    3e26:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
    3e29:	74 dd                	je     3e08 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    3e2b:	83 ff 25             	cmp    $0x25,%edi
    3e2e:	75 e5                	jne    3e15 <printf+0x35>
      if(c == 'd'){
    3e30:	83 fa 64             	cmp    $0x64,%edx
    3e33:	0f 84 3f 01 00 00    	je     3f78 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3e39:	83 fa 70             	cmp    $0x70,%edx
    3e3c:	0f 84 a6 00 00 00    	je     3ee8 <printf+0x108>
    3e42:	83 fa 78             	cmp    $0x78,%edx
    3e45:	0f 84 9d 00 00 00    	je     3ee8 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3e4b:	83 fa 73             	cmp    $0x73,%edx
    3e4e:	66 90                	xchg   %ax,%ax
    3e50:	0f 84 ba 00 00 00    	je     3f10 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3e56:	83 fa 63             	cmp    $0x63,%edx
    3e59:	0f 84 41 01 00 00    	je     3fa0 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3e5f:	83 fa 25             	cmp    $0x25,%edx
    3e62:	0f 84 00 01 00 00    	je     3f68 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3e68:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3e6b:	89 55 cc             	mov    %edx,-0x34(%ebp)
    3e6e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3e72:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3e79:	00 
    3e7a:	89 74 24 04          	mov    %esi,0x4(%esp)
    3e7e:	89 0c 24             	mov    %ecx,(%esp)
    3e81:	e8 42 fe ff ff       	call   3cc8 <write>
    3e86:	8b 55 cc             	mov    -0x34(%ebp),%edx
    3e89:	88 55 e7             	mov    %dl,-0x19(%ebp)
    3e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3e8f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3e92:	31 ff                	xor    %edi,%edi
    3e94:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3e9b:	00 
    3e9c:	89 74 24 04          	mov    %esi,0x4(%esp)
    3ea0:	89 04 24             	mov    %eax,(%esp)
    3ea3:	e8 20 fe ff ff       	call   3cc8 <write>
    3ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3eab:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    3eaf:	84 d2                	test   %dl,%dl
    3eb1:	0f 85 6d ff ff ff    	jne    3e24 <printf+0x44>
    3eb7:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    3eb8:	83 c4 3c             	add    $0x3c,%esp
    3ebb:	5b                   	pop    %ebx
    3ebc:	5e                   	pop    %esi
    3ebd:	5f                   	pop    %edi
    3ebe:	5d                   	pop    %ebp
    3ebf:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    3ec3:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3ec6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3ecd:	00 
    3ece:	89 74 24 04          	mov    %esi,0x4(%esp)
    3ed2:	89 04 24             	mov    %eax,(%esp)
    3ed5:	e8 ee fd ff ff       	call   3cc8 <write>
    3eda:	8b 45 0c             	mov    0xc(%ebp),%eax
    3edd:	e9 33 ff ff ff       	jmp    3e15 <printf+0x35>
    3ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    3ee8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3eeb:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    3ef0:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    3ef2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3ef9:	8b 10                	mov    (%eax),%edx
    3efb:	8b 45 08             	mov    0x8(%ebp),%eax
    3efe:	e8 4d fe ff ff       	call   3d50 <printint>
    3f03:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    3f06:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    3f0a:	e9 06 ff ff ff       	jmp    3e15 <printf+0x35>
    3f0f:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
    3f10:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
    3f13:	b9 e0 58 00 00       	mov    $0x58e0,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    3f18:	8b 3a                	mov    (%edx),%edi
        ap++;
    3f1a:	83 c2 04             	add    $0x4,%edx
    3f1d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
    3f20:	85 ff                	test   %edi,%edi
    3f22:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
    3f25:	0f b6 17             	movzbl (%edi),%edx
    3f28:	84 d2                	test   %dl,%dl
    3f2a:	74 33                	je     3f5f <printf+0x17f>
    3f2c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    3f2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
    3f38:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    3f3b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3f3e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3f45:	00 
    3f46:	89 74 24 04          	mov    %esi,0x4(%esp)
    3f4a:	89 1c 24             	mov    %ebx,(%esp)
    3f4d:	e8 76 fd ff ff       	call   3cc8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    3f52:	0f b6 17             	movzbl (%edi),%edx
    3f55:	84 d2                	test   %dl,%dl
    3f57:	75 df                	jne    3f38 <printf+0x158>
    3f59:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    3f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3f5f:	31 ff                	xor    %edi,%edi
    3f61:	e9 af fe ff ff       	jmp    3e15 <printf+0x35>
    3f66:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3f68:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3f6c:	e9 1b ff ff ff       	jmp    3e8c <printf+0xac>
    3f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    3f78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3f7b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
    3f80:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    3f83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3f8a:	8b 10                	mov    (%eax),%edx
    3f8c:	8b 45 08             	mov    0x8(%ebp),%eax
    3f8f:	e8 bc fd ff ff       	call   3d50 <printint>
    3f94:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    3f97:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    3f9b:	e9 75 fe ff ff       	jmp    3e15 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3fa0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
    3fa3:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3fa5:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3fa8:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3faa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3fb1:	00 
    3fb2:	89 74 24 04          	mov    %esi,0x4(%esp)
    3fb6:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3fb9:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3fbc:	e8 07 fd ff ff       	call   3cc8 <write>
    3fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    3fc4:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    3fc8:	e9 48 fe ff ff       	jmp    3e15 <printf+0x35>
    3fcd:	90                   	nop
    3fce:	90                   	nop
    3fcf:	90                   	nop

00003fd0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3fd0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3fd1:	a1 a8 59 00 00       	mov    0x59a8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    3fd6:	89 e5                	mov    %esp,%ebp
    3fd8:	57                   	push   %edi
    3fd9:	56                   	push   %esi
    3fda:	53                   	push   %ebx
    3fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3fde:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3fe1:	39 c8                	cmp    %ecx,%eax
    3fe3:	73 1d                	jae    4002 <free+0x32>
    3fe5:	8d 76 00             	lea    0x0(%esi),%esi
    3fe8:	8b 10                	mov    (%eax),%edx
    3fea:	39 d1                	cmp    %edx,%ecx
    3fec:	72 1a                	jb     4008 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3fee:	39 d0                	cmp    %edx,%eax
    3ff0:	72 08                	jb     3ffa <free+0x2a>
    3ff2:	39 c8                	cmp    %ecx,%eax
    3ff4:	72 12                	jb     4008 <free+0x38>
    3ff6:	39 d1                	cmp    %edx,%ecx
    3ff8:	72 0e                	jb     4008 <free+0x38>
    3ffa:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3ffc:	39 c8                	cmp    %ecx,%eax
    3ffe:	66 90                	xchg   %ax,%ax
    4000:	72 e6                	jb     3fe8 <free+0x18>
    4002:	8b 10                	mov    (%eax),%edx
    4004:	eb e8                	jmp    3fee <free+0x1e>
    4006:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    4008:	8b 71 04             	mov    0x4(%ecx),%esi
    400b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    400e:	39 d7                	cmp    %edx,%edi
    4010:	74 19                	je     402b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    4012:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    4015:	8b 50 04             	mov    0x4(%eax),%edx
    4018:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    401b:	39 ce                	cmp    %ecx,%esi
    401d:	74 23                	je     4042 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    401f:	89 08                	mov    %ecx,(%eax)
  freep = p;
    4021:	a3 a8 59 00 00       	mov    %eax,0x59a8
}
    4026:	5b                   	pop    %ebx
    4027:	5e                   	pop    %esi
    4028:	5f                   	pop    %edi
    4029:	5d                   	pop    %ebp
    402a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    402b:	03 72 04             	add    0x4(%edx),%esi
    402e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
    4031:	8b 10                	mov    (%eax),%edx
    4033:	8b 12                	mov    (%edx),%edx
    4035:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    4038:	8b 50 04             	mov    0x4(%eax),%edx
    403b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    403e:	39 ce                	cmp    %ecx,%esi
    4040:	75 dd                	jne    401f <free+0x4f>
    p->s.size += bp->s.size;
    4042:	03 51 04             	add    0x4(%ecx),%edx
    4045:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4048:	8b 53 f8             	mov    -0x8(%ebx),%edx
    404b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
    404d:	a3 a8 59 00 00       	mov    %eax,0x59a8
}
    4052:	5b                   	pop    %ebx
    4053:	5e                   	pop    %esi
    4054:	5f                   	pop    %edi
    4055:	5d                   	pop    %ebp
    4056:	c3                   	ret    
    4057:	89 f6                	mov    %esi,%esi
    4059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00004060 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4060:	55                   	push   %ebp
    4061:	89 e5                	mov    %esp,%ebp
    4063:	57                   	push   %edi
    4064:	56                   	push   %esi
    4065:	53                   	push   %ebx
    4066:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
    406c:	8b 0d a8 59 00 00    	mov    0x59a8,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4072:	83 c3 07             	add    $0x7,%ebx
    4075:	c1 eb 03             	shr    $0x3,%ebx
    4078:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    407b:	85 c9                	test   %ecx,%ecx
    407d:	0f 84 9b 00 00 00    	je     411e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4083:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    4085:	8b 50 04             	mov    0x4(%eax),%edx
    4088:	39 d3                	cmp    %edx,%ebx
    408a:	76 27                	jbe    40b3 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    408c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    4093:	be 00 80 00 00       	mov    $0x8000,%esi
    4098:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    409b:	90                   	nop
    409c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    40a0:	3b 05 a8 59 00 00    	cmp    0x59a8,%eax
    40a6:	74 30                	je     40d8 <malloc+0x78>
    40a8:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    40aa:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    40ac:	8b 50 04             	mov    0x4(%eax),%edx
    40af:	39 d3                	cmp    %edx,%ebx
    40b1:	77 ed                	ja     40a0 <malloc+0x40>
      if(p->s.size == nunits)
    40b3:	39 d3                	cmp    %edx,%ebx
    40b5:	74 61                	je     4118 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    40b7:	29 da                	sub    %ebx,%edx
    40b9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    40bc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    40bf:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    40c2:	89 0d a8 59 00 00    	mov    %ecx,0x59a8
      return (void*)(p + 1);
    40c8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    40cb:	83 c4 2c             	add    $0x2c,%esp
    40ce:	5b                   	pop    %ebx
    40cf:	5e                   	pop    %esi
    40d0:	5f                   	pop    %edi
    40d1:	5d                   	pop    %ebp
    40d2:	c3                   	ret    
    40d3:	90                   	nop
    40d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    40d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    40db:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    40e1:	bf 00 10 00 00       	mov    $0x1000,%edi
    40e6:	0f 43 fb             	cmovae %ebx,%edi
    40e9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    40ec:	89 04 24             	mov    %eax,(%esp)
    40ef:	e8 3c fc ff ff       	call   3d30 <sbrk>
  if(p == (char*)-1)
    40f4:	83 f8 ff             	cmp    $0xffffffff,%eax
    40f7:	74 18                	je     4111 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    40f9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    40fc:	83 c0 08             	add    $0x8,%eax
    40ff:	89 04 24             	mov    %eax,(%esp)
    4102:	e8 c9 fe ff ff       	call   3fd0 <free>
  return freep;
    4107:	8b 0d a8 59 00 00    	mov    0x59a8,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    410d:	85 c9                	test   %ecx,%ecx
    410f:	75 99                	jne    40aa <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    4111:	31 c0                	xor    %eax,%eax
    4113:	eb b6                	jmp    40cb <malloc+0x6b>
    4115:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    4118:	8b 10                	mov    (%eax),%edx
    411a:	89 11                	mov    %edx,(%ecx)
    411c:	eb a4                	jmp    40c2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    411e:	c7 05 a8 59 00 00 a0 	movl   $0x59a0,0x59a8
    4125:	59 00 00 
    base.s.size = 0;
    4128:	b9 a0 59 00 00       	mov    $0x59a0,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    412d:	c7 05 a0 59 00 00 a0 	movl   $0x59a0,0x59a0
    4134:	59 00 00 
    base.s.size = 0;
    4137:	c7 05 a4 59 00 00 00 	movl   $0x0,0x59a4
    413e:	00 00 00 
    4141:	e9 3d ff ff ff       	jmp    4083 <malloc+0x23>
