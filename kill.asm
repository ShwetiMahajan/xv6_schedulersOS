
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	57                   	push   %edi
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
  int i;

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
   9:	bb 01 00 00 00       	mov    $0x1,%ebx
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   e:	83 ec 14             	sub    $0x14,%esp
  11:	8b 75 08             	mov    0x8(%ebp),%esi
  14:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 2){
  17:	83 fe 01             	cmp    $0x1,%esi
  1a:	7e 24                	jle    40 <main+0x40>
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  20:	8b 04 9f             	mov    (%edi,%ebx,4),%eax

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  23:	83 c3 01             	add    $0x1,%ebx
    kill(atoi(argv[i]));
  26:	89 04 24             	mov    %eax,(%esp)
  29:	e8 32 01 00 00       	call   160 <atoi>
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 82 02 00 00       	call   2b8 <kill>

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  36:	39 de                	cmp    %ebx,%esi
  38:	7f e6                	jg     20 <main+0x20>
    kill(atoi(argv[i]));
  exit();
  3a:	e8 49 02 00 00       	call   288 <exit>
  3f:	90                   	nop
main(int argc, char **argv)
{
  int i;

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
  40:	c7 44 24 04 26 07 00 	movl   $0x726,0x4(%esp)
  47:	00 
  48:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  4f:	e8 6c 03 00 00       	call   3c0 <printf>
    exit();
  54:	e8 2f 02 00 00       	call   288 <exit>
  59:	90                   	nop
  5a:	90                   	nop
  5b:	90                   	nop
  5c:	90                   	nop
  5d:	90                   	nop
  5e:	90                   	nop
  5f:	90                   	nop

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  60:	55                   	push   %ebp
  61:	31 d2                	xor    %edx,%edx
  63:	89 e5                	mov    %esp,%ebp
  65:	8b 45 08             	mov    0x8(%ebp),%eax
  68:	53                   	push   %ebx
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  77:	83 c2 01             	add    $0x1,%edx
  7a:	84 c9                	test   %cl,%cl
  7c:	75 f2                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7e:	5b                   	pop    %ebx
  7f:	5d                   	pop    %ebp
  80:	c3                   	ret    
  81:	eb 0d                	jmp    90 <strcmp>
  83:	90                   	nop
  84:	90                   	nop
  85:	90                   	nop
  86:	90                   	nop
  87:	90                   	nop
  88:	90                   	nop
  89:	90                   	nop
  8a:	90                   	nop
  8b:	90                   	nop
  8c:	90                   	nop
  8d:	90                   	nop
  8e:	90                   	nop
  8f:	90                   	nop

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  96:	53                   	push   %ebx
  97:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9a:	0f b6 01             	movzbl (%ecx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 14                	jne    b5 <strcmp+0x25>
  a1:	eb 25                	jmp    c8 <strcmp+0x38>
  a3:	90                   	nop
  a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  a8:	83 c1 01             	add    $0x1,%ecx
  ab:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ae:	0f b6 01             	movzbl (%ecx),%eax
  b1:	84 c0                	test   %al,%al
  b3:	74 13                	je     c8 <strcmp+0x38>
  b5:	0f b6 1a             	movzbl (%edx),%ebx
  b8:	38 d8                	cmp    %bl,%al
  ba:	74 ec                	je     a8 <strcmp+0x18>
  bc:	0f b6 db             	movzbl %bl,%ebx
  bf:	0f b6 c0             	movzbl %al,%eax
  c2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  c4:	5b                   	pop    %ebx
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	0f b6 1a             	movzbl (%edx),%ebx
  cb:	31 c0                	xor    %eax,%eax
  cd:	0f b6 db             	movzbl %bl,%ebx
  d0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  d2:	5b                   	pop    %ebx
  d3:	5d                   	pop    %ebp
  d4:	c3                   	ret    
  d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strlen>:

uint
strlen(char *s)
{
  e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  e1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
  e5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ea:	80 39 00             	cmpb   $0x0,(%ecx)
  ed:	74 0c                	je     fb <strlen+0x1b>
  ef:	90                   	nop
  f0:	83 c2 01             	add    $0x1,%edx
  f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f7:	89 d0                	mov    %edx,%eax
  f9:	75 f5                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 55 08             	mov    0x8(%ebp),%edx
 106:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 107:	8b 4d 10             	mov    0x10(%ebp),%ecx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 d7                	mov    %edx,%edi
 10f:	fc                   	cld    
 110:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 112:	89 d0                	mov    %edx,%eax
 114:	5f                   	pop    %edi
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    
 117:	89 f6                	mov    %esi,%esi
 119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 12a:	0f b6 10             	movzbl (%eax),%edx
 12d:	84 d2                	test   %dl,%dl
 12f:	75 11                	jne    142 <strchr+0x22>
 131:	eb 15                	jmp    148 <strchr+0x28>
 133:	90                   	nop
 134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 138:	83 c0 01             	add    $0x1,%eax
 13b:	0f b6 10             	movzbl (%eax),%edx
 13e:	84 d2                	test   %dl,%dl
 140:	74 06                	je     148 <strchr+0x28>
    if(*s == c)
 142:	38 ca                	cmp    %cl,%dl
 144:	75 f2                	jne    138 <strchr+0x18>
      return (char*)s;
  return 0;
}
 146:	5d                   	pop    %ebp
 147:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 148:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 14a:	5d                   	pop    %ebp
 14b:	90                   	nop
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 150:	c3                   	ret    
 151:	eb 0d                	jmp    160 <atoi>
 153:	90                   	nop
 154:	90                   	nop
 155:	90                   	nop
 156:	90                   	nop
 157:	90                   	nop
 158:	90                   	nop
 159:	90                   	nop
 15a:	90                   	nop
 15b:	90                   	nop
 15c:	90                   	nop
 15d:	90                   	nop
 15e:	90                   	nop
 15f:	90                   	nop

00000160 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 160:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 161:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 163:	89 e5                	mov    %esp,%ebp
 165:	8b 4d 08             	mov    0x8(%ebp),%ecx
 168:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 169:	0f b6 11             	movzbl (%ecx),%edx
 16c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 16f:	80 fb 09             	cmp    $0x9,%bl
 172:	77 1c                	ja     190 <atoi+0x30>
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 178:	0f be d2             	movsbl %dl,%edx
 17b:	83 c1 01             	add    $0x1,%ecx
 17e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 181:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 185:	0f b6 11             	movzbl (%ecx),%edx
 188:	8d 5a d0             	lea    -0x30(%edx),%ebx
 18b:	80 fb 09             	cmp    $0x9,%bl
 18e:	76 e8                	jbe    178 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 190:	5b                   	pop    %ebx
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	53                   	push   %ebx
 1a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ae:	85 db                	test   %ebx,%ebx
 1b0:	7e 14                	jle    1c6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 1b2:	31 d2                	xor    %edx,%edx
 1b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 1b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1bf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1c2:	39 da                	cmp    %ebx,%edx
 1c4:	75 f2                	jne    1b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    
 1ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001d0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1d9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 1df:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1eb:	00 
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 d4 00 00 00       	call   2c8 <open>
  if(fd < 0)
 1f4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1f8:	78 19                	js     213 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	89 1c 24             	mov    %ebx,(%esp)
 200:	89 44 24 04          	mov    %eax,0x4(%esp)
 204:	e8 d7 00 00 00       	call   2e0 <fstat>
  close(fd);
 209:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 20c:	89 c6                	mov    %eax,%esi
  close(fd);
 20e:	e8 9d 00 00 00       	call   2b0 <close>
  return r;
}
 213:	89 f0                	mov    %esi,%eax
 215:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 218:	8b 75 fc             	mov    -0x4(%ebp),%esi
 21b:	89 ec                	mov    %ebp,%esp
 21d:	5d                   	pop    %ebp
 21e:	c3                   	ret    
 21f:	90                   	nop

00000220 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	31 f6                	xor    %esi,%esi
 227:	53                   	push   %ebx
 228:	83 ec 2c             	sub    $0x2c,%esp
 22b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	eb 06                	jmp    236 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 230:	3c 0a                	cmp    $0xa,%al
 232:	74 39                	je     26d <gets+0x4d>
 234:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 236:	8d 5e 01             	lea    0x1(%esi),%ebx
 239:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 23c:	7d 31                	jge    26f <gets+0x4f>
    cc = read(0, &c, 1);
 23e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 241:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 248:	00 
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 254:	e8 47 00 00 00       	call   2a0 <read>
    if(cc < 1)
 259:	85 c0                	test   %eax,%eax
 25b:	7e 12                	jle    26f <gets+0x4f>
      break;
    buf[i++] = c;
 25d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 261:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 265:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 269:	3c 0d                	cmp    $0xd,%al
 26b:	75 c3                	jne    230 <gets+0x10>
 26d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 26f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 273:	89 f8                	mov    %edi,%eax
 275:	83 c4 2c             	add    $0x2c,%esp
 278:	5b                   	pop    %ebx
 279:	5e                   	pop    %esi
 27a:	5f                   	pop    %edi
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	90                   	nop
 27e:	90                   	nop
 27f:	90                   	nop

00000280 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 280:	b8 01 00 00 00       	mov    $0x1,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <exit>:
SYSCALL(exit)
 288:	b8 02 00 00 00       	mov    $0x2,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <wait>:
SYSCALL(wait)
 290:	b8 03 00 00 00       	mov    $0x3,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <pipe>:
SYSCALL(pipe)
 298:	b8 04 00 00 00       	mov    $0x4,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <read>:
SYSCALL(read)
 2a0:	b8 05 00 00 00       	mov    $0x5,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <write>:
SYSCALL(write)
 2a8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <close>:
SYSCALL(close)
 2b0:	b8 15 00 00 00       	mov    $0x15,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <kill>:
SYSCALL(kill)
 2b8:	b8 06 00 00 00       	mov    $0x6,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <exec>:
SYSCALL(exec)
 2c0:	b8 07 00 00 00       	mov    $0x7,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <open>:
SYSCALL(open)
 2c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <mknod>:
SYSCALL(mknod)
 2d0:	b8 11 00 00 00       	mov    $0x11,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <unlink>:
SYSCALL(unlink)
 2d8:	b8 12 00 00 00       	mov    $0x12,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <fstat>:
SYSCALL(fstat)
 2e0:	b8 08 00 00 00       	mov    $0x8,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <link>:
SYSCALL(link)
 2e8:	b8 13 00 00 00       	mov    $0x13,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <mkdir>:
SYSCALL(mkdir)
 2f0:	b8 14 00 00 00       	mov    $0x14,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <chdir>:
SYSCALL(chdir)
 2f8:	b8 09 00 00 00       	mov    $0x9,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <dup>:
SYSCALL(dup)
 300:	b8 0a 00 00 00       	mov    $0xa,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <getpid>:
SYSCALL(getpid)
 308:	b8 0b 00 00 00       	mov    $0xb,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <sbrk>:
SYSCALL(sbrk)
 310:	b8 0c 00 00 00       	mov    $0xc,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <sleep>:
SYSCALL(sleep)
 318:	b8 0d 00 00 00       	mov    $0xd,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <set_tickets>:
SYSCALL(set_tickets)
 320:	b8 16 00 00 00       	mov    $0x16,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    
 328:	90                   	nop
 329:	90                   	nop
 32a:	90                   	nop
 32b:	90                   	nop
 32c:	90                   	nop
 32d:	90                   	nop
 32e:	90                   	nop
 32f:	90                   	nop

00000330 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	89 cf                	mov    %ecx,%edi
 336:	56                   	push   %esi
 337:	89 c6                	mov    %eax,%esi
 339:	53                   	push   %ebx
 33a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 33d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 340:	85 c9                	test   %ecx,%ecx
 342:	74 04                	je     348 <printint+0x18>
 344:	85 d2                	test   %edx,%edx
 346:	78 68                	js     3b0 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 348:	89 d0                	mov    %edx,%eax
 34a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 351:	31 c9                	xor    %ecx,%ecx
 353:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 356:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 358:	31 d2                	xor    %edx,%edx
 35a:	f7 f7                	div    %edi
 35c:	0f b6 92 41 07 00 00 	movzbl 0x741(%edx),%edx
 363:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 366:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 369:	85 c0                	test   %eax,%eax
 36b:	75 eb                	jne    358 <printint+0x28>
  if(neg)
 36d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 370:	85 c0                	test   %eax,%eax
 372:	74 08                	je     37c <printint+0x4c>
    buf[i++] = '-';
 374:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 379:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 37c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 37f:	90                   	nop
 380:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 384:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 387:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 38e:	00 
 38f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 392:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 395:	8d 45 e7             	lea    -0x19(%ebp),%eax
 398:	89 44 24 04          	mov    %eax,0x4(%esp)
 39c:	e8 07 ff ff ff       	call   2a8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3a1:	83 ff ff             	cmp    $0xffffffff,%edi
 3a4:	75 da                	jne    380 <printint+0x50>
    putc(fd, buf[i]);
}
 3a6:	83 c4 4c             	add    $0x4c,%esp
 3a9:	5b                   	pop    %ebx
 3aa:	5e                   	pop    %esi
 3ab:	5f                   	pop    %edi
 3ac:	5d                   	pop    %ebp
 3ad:	c3                   	ret    
 3ae:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3b0:	89 d0                	mov    %edx,%eax
 3b2:	f7 d8                	neg    %eax
 3b4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 3bb:	eb 94                	jmp    351 <printint+0x21>
 3bd:	8d 76 00             	lea    0x0(%esi),%esi

000003c0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
 3c5:	53                   	push   %ebx
 3c6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	0f b6 10             	movzbl (%eax),%edx
 3cf:	84 d2                	test   %dl,%dl
 3d1:	0f 84 c1 00 00 00    	je     498 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3d7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3da:	31 ff                	xor    %edi,%edi
 3dc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 3df:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3e1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 3e4:	eb 1e                	jmp    404 <printf+0x44>
 3e6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3e8:	83 fa 25             	cmp    $0x25,%edx
 3eb:	0f 85 af 00 00 00    	jne    4a0 <printf+0xe0>
 3f1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f5:	83 c3 01             	add    $0x1,%ebx
 3f8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 3fc:	84 d2                	test   %dl,%dl
 3fe:	0f 84 94 00 00 00    	je     498 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 404:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 406:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 409:	74 dd                	je     3e8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 40b:	83 ff 25             	cmp    $0x25,%edi
 40e:	75 e5                	jne    3f5 <printf+0x35>
      if(c == 'd'){
 410:	83 fa 64             	cmp    $0x64,%edx
 413:	0f 84 3f 01 00 00    	je     558 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 419:	83 fa 70             	cmp    $0x70,%edx
 41c:	0f 84 a6 00 00 00    	je     4c8 <printf+0x108>
 422:	83 fa 78             	cmp    $0x78,%edx
 425:	0f 84 9d 00 00 00    	je     4c8 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 42b:	83 fa 73             	cmp    $0x73,%edx
 42e:	66 90                	xchg   %ax,%ax
 430:	0f 84 ba 00 00 00    	je     4f0 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 436:	83 fa 63             	cmp    $0x63,%edx
 439:	0f 84 41 01 00 00    	je     580 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 43f:	83 fa 25             	cmp    $0x25,%edx
 442:	0f 84 00 01 00 00    	je     548 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 448:	8b 4d 08             	mov    0x8(%ebp),%ecx
 44b:	89 55 cc             	mov    %edx,-0x34(%ebp)
 44e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 452:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 459:	00 
 45a:	89 74 24 04          	mov    %esi,0x4(%esp)
 45e:	89 0c 24             	mov    %ecx,(%esp)
 461:	e8 42 fe ff ff       	call   2a8 <write>
 466:	8b 55 cc             	mov    -0x34(%ebp),%edx
 469:	88 55 e7             	mov    %dl,-0x19(%ebp)
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 46f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 472:	31 ff                	xor    %edi,%edi
 474:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 47b:	00 
 47c:	89 74 24 04          	mov    %esi,0x4(%esp)
 480:	89 04 24             	mov    %eax,(%esp)
 483:	e8 20 fe ff ff       	call   2a8 <write>
 488:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 48b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 48f:	84 d2                	test   %dl,%dl
 491:	0f 85 6d ff ff ff    	jne    404 <printf+0x44>
 497:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 498:	83 c4 3c             	add    $0x3c,%esp
 49b:	5b                   	pop    %ebx
 49c:	5e                   	pop    %esi
 49d:	5f                   	pop    %edi
 49e:	5d                   	pop    %ebp
 49f:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4a3:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ad:	00 
 4ae:	89 74 24 04          	mov    %esi,0x4(%esp)
 4b2:	89 04 24             	mov    %eax,(%esp)
 4b5:	e8 ee fd ff ff       	call   2a8 <write>
 4ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bd:	e9 33 ff ff ff       	jmp    3f5 <printf+0x35>
 4c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4cb:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 4d0:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4d9:	8b 10                	mov    (%eax),%edx
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	e8 4d fe ff ff       	call   330 <printint>
 4e3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 4e6:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4ea:	e9 06 ff ff ff       	jmp    3f5 <printf+0x35>
 4ef:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 4f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 4f3:	b9 3a 07 00 00       	mov    $0x73a,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 4f8:	8b 3a                	mov    (%edx),%edi
        ap++;
 4fa:	83 c2 04             	add    $0x4,%edx
 4fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 500:	85 ff                	test   %edi,%edi
 502:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 505:	0f b6 17             	movzbl (%edi),%edx
 508:	84 d2                	test   %dl,%dl
 50a:	74 33                	je     53f <printf+0x17f>
 50c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 50f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 518:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 51b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 51e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 525:	00 
 526:	89 74 24 04          	mov    %esi,0x4(%esp)
 52a:	89 1c 24             	mov    %ebx,(%esp)
 52d:	e8 76 fd ff ff       	call   2a8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 532:	0f b6 17             	movzbl (%edi),%edx
 535:	84 d2                	test   %dl,%dl
 537:	75 df                	jne    518 <printf+0x158>
 539:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 53c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53f:	31 ff                	xor    %edi,%edi
 541:	e9 af fe ff ff       	jmp    3f5 <printf+0x35>
 546:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 548:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 54c:	e9 1b ff ff ff       	jmp    46c <printf+0xac>
 551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 55b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 560:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 563:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 56a:	8b 10                	mov    (%eax),%edx
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	e8 bc fd ff ff       	call   330 <printint>
 574:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 577:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 57b:	e9 75 fe ff ff       	jmp    3f5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 580:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 583:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 585:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 588:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 58a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 591:	00 
 592:	89 74 24 04          	mov    %esi,0x4(%esp)
 596:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 599:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 59c:	e8 07 fd ff ff       	call   2a8 <write>
 5a1:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 5a4:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5a8:	e9 48 fe ff ff       	jmp    3f5 <printf+0x35>
 5ad:	90                   	nop
 5ae:	90                   	nop
 5af:	90                   	nop

000005b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b1:	a1 5c 07 00 00       	mov    0x75c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c1:	39 c8                	cmp    %ecx,%eax
 5c3:	73 1d                	jae    5e2 <free+0x32>
 5c5:	8d 76 00             	lea    0x0(%esi),%esi
 5c8:	8b 10                	mov    (%eax),%edx
 5ca:	39 d1                	cmp    %edx,%ecx
 5cc:	72 1a                	jb     5e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ce:	39 d0                	cmp    %edx,%eax
 5d0:	72 08                	jb     5da <free+0x2a>
 5d2:	39 c8                	cmp    %ecx,%eax
 5d4:	72 12                	jb     5e8 <free+0x38>
 5d6:	39 d1                	cmp    %edx,%ecx
 5d8:	72 0e                	jb     5e8 <free+0x38>
 5da:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5dc:	39 c8                	cmp    %ecx,%eax
 5de:	66 90                	xchg   %ax,%ax
 5e0:	72 e6                	jb     5c8 <free+0x18>
 5e2:	8b 10                	mov    (%eax),%edx
 5e4:	eb e8                	jmp    5ce <free+0x1e>
 5e6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e8:	8b 71 04             	mov    0x4(%ecx),%esi
 5eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ee:	39 d7                	cmp    %edx,%edi
 5f0:	74 19                	je     60b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5f5:	8b 50 04             	mov    0x4(%eax),%edx
 5f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5fb:	39 ce                	cmp    %ecx,%esi
 5fd:	74 23                	je     622 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
 601:	a3 5c 07 00 00       	mov    %eax,0x75c
}
 606:	5b                   	pop    %ebx
 607:	5e                   	pop    %esi
 608:	5f                   	pop    %edi
 609:	5d                   	pop    %ebp
 60a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 60b:	03 72 04             	add    0x4(%edx),%esi
 60e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 611:	8b 10                	mov    (%eax),%edx
 613:	8b 12                	mov    (%edx),%edx
 615:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 618:	8b 50 04             	mov    0x4(%eax),%edx
 61b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61e:	39 ce                	cmp    %ecx,%esi
 620:	75 dd                	jne    5ff <free+0x4f>
    p->s.size += bp->s.size;
 622:	03 51 04             	add    0x4(%ecx),%edx
 625:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 628:	8b 53 f8             	mov    -0x8(%ebx),%edx
 62b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 62d:	a3 5c 07 00 00       	mov    %eax,0x75c
}
 632:	5b                   	pop    %ebx
 633:	5e                   	pop    %esi
 634:	5f                   	pop    %edi
 635:	5d                   	pop    %ebp
 636:	c3                   	ret    
 637:	89 f6                	mov    %esi,%esi
 639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000640 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 649:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 64c:	8b 0d 5c 07 00 00    	mov    0x75c,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 652:	83 c3 07             	add    $0x7,%ebx
 655:	c1 eb 03             	shr    $0x3,%ebx
 658:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 65b:	85 c9                	test   %ecx,%ecx
 65d:	0f 84 9b 00 00 00    	je     6fe <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 663:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	39 d3                	cmp    %edx,%ebx
 66a:	76 27                	jbe    693 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 66c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 673:	be 00 80 00 00       	mov    $0x8000,%esi
 678:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 67b:	90                   	nop
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 680:	3b 05 5c 07 00 00    	cmp    0x75c,%eax
 686:	74 30                	je     6b8 <malloc+0x78>
 688:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 68a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 68c:	8b 50 04             	mov    0x4(%eax),%edx
 68f:	39 d3                	cmp    %edx,%ebx
 691:	77 ed                	ja     680 <malloc+0x40>
      if(p->s.size == nunits)
 693:	39 d3                	cmp    %edx,%ebx
 695:	74 61                	je     6f8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 697:	29 da                	sub    %ebx,%edx
 699:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 69c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 69f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6a2:	89 0d 5c 07 00 00    	mov    %ecx,0x75c
      return (void*)(p + 1);
 6a8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6ab:	83 c4 2c             	add    $0x2c,%esp
 6ae:	5b                   	pop    %ebx
 6af:	5e                   	pop    %esi
 6b0:	5f                   	pop    %edi
 6b1:	5d                   	pop    %ebp
 6b2:	c3                   	ret    
 6b3:	90                   	nop
 6b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 6b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bb:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6c1:	bf 00 10 00 00       	mov    $0x1000,%edi
 6c6:	0f 43 fb             	cmovae %ebx,%edi
 6c9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6cc:	89 04 24             	mov    %eax,(%esp)
 6cf:	e8 3c fc ff ff       	call   310 <sbrk>
  if(p == (char*)-1)
 6d4:	83 f8 ff             	cmp    $0xffffffff,%eax
 6d7:	74 18                	je     6f1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6d9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6dc:	83 c0 08             	add    $0x8,%eax
 6df:	89 04 24             	mov    %eax,(%esp)
 6e2:	e8 c9 fe ff ff       	call   5b0 <free>
  return freep;
 6e7:	8b 0d 5c 07 00 00    	mov    0x75c,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6ed:	85 c9                	test   %ecx,%ecx
 6ef:	75 99                	jne    68a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6f1:	31 c0                	xor    %eax,%eax
 6f3:	eb b6                	jmp    6ab <malloc+0x6b>
 6f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 6f8:	8b 10                	mov    (%eax),%edx
 6fa:	89 11                	mov    %edx,(%ecx)
 6fc:	eb a4                	jmp    6a2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6fe:	c7 05 5c 07 00 00 54 	movl   $0x754,0x75c
 705:	07 00 00 
    base.s.size = 0;
 708:	b9 54 07 00 00       	mov    $0x754,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 70d:	c7 05 54 07 00 00 54 	movl   $0x754,0x754
 714:	07 00 00 
    base.s.size = 0;
 717:	c7 05 58 07 00 00 00 	movl   $0x0,0x758
 71e:	00 00 00 
 721:	e9 3d ff ff ff       	jmp    663 <malloc+0x23>
