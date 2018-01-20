
_test2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"


int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
        set_tickets(10);
   9:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10:	e8 eb 02 00 00       	call   300 <set_tickets>
  15:	31 d2                	xor    %edx,%edx
  17:	90                   	nop
        int i , k;
        const int loop = 43000;
        for( i=0; i<loop ; i++)
  18:	31 c0                	xor    %eax,%eax
  1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        {
                for(k =0 ; k<loop;k++)
                {
			asm("nop");
  20:	90                   	nop
        set_tickets(10);
        int i , k;
        const int loop = 43000;
        for( i=0; i<loop ; i++)
        {
                for(k =0 ; k<loop;k++)
  21:	83 c0 01             	add    $0x1,%eax
  24:	3d f8 a7 00 00       	cmp    $0xa7f8,%eax
  29:	75 f5                	jne    20 <main+0x20>
int main(int argc, char *argv[])
{
        set_tickets(10);
        int i , k;
        const int loop = 43000;
        for( i=0; i<loop ; i++)
  2b:	83 c2 01             	add    $0x1,%edx
  2e:	81 fa f8 a7 00 00    	cmp    $0xa7f8,%edx
  34:	75 e2                	jne    18 <main+0x18>
                for(k =0 ; k<loop;k++)
                {
			asm("nop");
                }
        }
        exit();
  36:	e8 2d 02 00 00       	call   268 <exit>
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop

00000040 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  40:	55                   	push   %ebp
  41:	31 d2                	xor    %edx,%edx
  43:	89 e5                	mov    %esp,%ebp
  45:	8b 45 08             	mov    0x8(%ebp),%eax
  48:	53                   	push   %ebx
  49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  50:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  57:	83 c2 01             	add    $0x1,%edx
  5a:	84 c9                	test   %cl,%cl
  5c:	75 f2                	jne    50 <strcpy+0x10>
    ;
  return os;
}
  5e:	5b                   	pop    %ebx
  5f:	5d                   	pop    %ebp
  60:	c3                   	ret    
  61:	eb 0d                	jmp    70 <strcmp>
  63:	90                   	nop
  64:	90                   	nop
  65:	90                   	nop
  66:	90                   	nop
  67:	90                   	nop
  68:	90                   	nop
  69:	90                   	nop
  6a:	90                   	nop
  6b:	90                   	nop
  6c:	90                   	nop
  6d:	90                   	nop
  6e:	90                   	nop
  6f:	90                   	nop

00000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  76:	53                   	push   %ebx
  77:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  7a:	0f b6 01             	movzbl (%ecx),%eax
  7d:	84 c0                	test   %al,%al
  7f:	75 14                	jne    95 <strcmp+0x25>
  81:	eb 25                	jmp    a8 <strcmp+0x38>
  83:	90                   	nop
  84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  88:	83 c1 01             	add    $0x1,%ecx
  8b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8e:	0f b6 01             	movzbl (%ecx),%eax
  91:	84 c0                	test   %al,%al
  93:	74 13                	je     a8 <strcmp+0x38>
  95:	0f b6 1a             	movzbl (%edx),%ebx
  98:	38 d8                	cmp    %bl,%al
  9a:	74 ec                	je     88 <strcmp+0x18>
  9c:	0f b6 db             	movzbl %bl,%ebx
  9f:	0f b6 c0             	movzbl %al,%eax
  a2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  a4:	5b                   	pop    %ebx
  a5:	5d                   	pop    %ebp
  a6:	c3                   	ret    
  a7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a8:	0f b6 1a             	movzbl (%edx),%ebx
  ab:	31 c0                	xor    %eax,%eax
  ad:	0f b6 db             	movzbl %bl,%ebx
  b0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  b2:	5b                   	pop    %ebx
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    
  b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000c0 <strlen>:

uint
strlen(char *s)
{
  c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  c1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  c3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
  c5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ca:	80 39 00             	cmpb   $0x0,(%ecx)
  cd:	74 0c                	je     db <strlen+0x1b>
  cf:	90                   	nop
  d0:	83 c2 01             	add    $0x1,%edx
  d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  d7:	89 d0                	mov    %edx,%eax
  d9:	75 f5                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    
  dd:	8d 76 00             	lea    0x0(%esi),%esi

000000e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 55 08             	mov    0x8(%ebp),%edx
  e6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	89 d7                	mov    %edx,%edi
  ef:	fc                   	cld    
  f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f2:	89 d0                	mov    %edx,%eax
  f4:	5f                   	pop    %edi
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    
  f7:	89 f6                	mov    %esi,%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 10a:	0f b6 10             	movzbl (%eax),%edx
 10d:	84 d2                	test   %dl,%dl
 10f:	75 11                	jne    122 <strchr+0x22>
 111:	eb 15                	jmp    128 <strchr+0x28>
 113:	90                   	nop
 114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 118:	83 c0 01             	add    $0x1,%eax
 11b:	0f b6 10             	movzbl (%eax),%edx
 11e:	84 d2                	test   %dl,%dl
 120:	74 06                	je     128 <strchr+0x28>
    if(*s == c)
 122:	38 ca                	cmp    %cl,%dl
 124:	75 f2                	jne    118 <strchr+0x18>
      return (char*)s;
  return 0;
}
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 128:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 12a:	5d                   	pop    %ebp
 12b:	90                   	nop
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 130:	c3                   	ret    
 131:	eb 0d                	jmp    140 <atoi>
 133:	90                   	nop
 134:	90                   	nop
 135:	90                   	nop
 136:	90                   	nop
 137:	90                   	nop
 138:	90                   	nop
 139:	90                   	nop
 13a:	90                   	nop
 13b:	90                   	nop
 13c:	90                   	nop
 13d:	90                   	nop
 13e:	90                   	nop
 13f:	90                   	nop

00000140 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 140:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 141:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 143:	89 e5                	mov    %esp,%ebp
 145:	8b 4d 08             	mov    0x8(%ebp),%ecx
 148:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 149:	0f b6 11             	movzbl (%ecx),%edx
 14c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 14f:	80 fb 09             	cmp    $0x9,%bl
 152:	77 1c                	ja     170 <atoi+0x30>
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 158:	0f be d2             	movsbl %dl,%edx
 15b:	83 c1 01             	add    $0x1,%ecx
 15e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 161:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 165:	0f b6 11             	movzbl (%ecx),%edx
 168:	8d 5a d0             	lea    -0x30(%edx),%ebx
 16b:	80 fb 09             	cmp    $0x9,%bl
 16e:	76 e8                	jbe    158 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 170:	5b                   	pop    %ebx
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    
 173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	56                   	push   %esi
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	53                   	push   %ebx
 188:	8b 5d 10             	mov    0x10(%ebp),%ebx
 18b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 18e:	85 db                	test   %ebx,%ebx
 190:	7e 14                	jle    1a6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 192:	31 d2                	xor    %edx,%edx
 194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 198:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 19c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 19f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1a2:	39 da                	cmp    %ebx,%edx
 1a4:	75 f2                	jne    198 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1a6:	5b                   	pop    %ebx
 1a7:	5e                   	pop    %esi
 1a8:	5d                   	pop    %ebp
 1a9:	c3                   	ret    
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001b0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1b9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1bc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 1bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1cb:	00 
 1cc:	89 04 24             	mov    %eax,(%esp)
 1cf:	e8 d4 00 00 00       	call   2a8 <open>
  if(fd < 0)
 1d4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1d8:	78 19                	js     1f3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	89 1c 24             	mov    %ebx,(%esp)
 1e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e4:	e8 d7 00 00 00       	call   2c0 <fstat>
  close(fd);
 1e9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1ec:	89 c6                	mov    %eax,%esi
  close(fd);
 1ee:	e8 9d 00 00 00       	call   290 <close>
  return r;
}
 1f3:	89 f0                	mov    %esi,%eax
 1f5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 1f8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 1fb:	89 ec                	mov    %ebp,%esp
 1fd:	5d                   	pop    %ebp
 1fe:	c3                   	ret    
 1ff:	90                   	nop

00000200 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
 205:	31 f6                	xor    %esi,%esi
 207:	53                   	push   %ebx
 208:	83 ec 2c             	sub    $0x2c,%esp
 20b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	eb 06                	jmp    216 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 210:	3c 0a                	cmp    $0xa,%al
 212:	74 39                	je     24d <gets+0x4d>
 214:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 216:	8d 5e 01             	lea    0x1(%esi),%ebx
 219:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 21c:	7d 31                	jge    24f <gets+0x4f>
    cc = read(0, &c, 1);
 21e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 221:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 228:	00 
 229:	89 44 24 04          	mov    %eax,0x4(%esp)
 22d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 234:	e8 47 00 00 00       	call   280 <read>
    if(cc < 1)
 239:	85 c0                	test   %eax,%eax
 23b:	7e 12                	jle    24f <gets+0x4f>
      break;
    buf[i++] = c;
 23d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 241:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 245:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 249:	3c 0d                	cmp    $0xd,%al
 24b:	75 c3                	jne    210 <gets+0x10>
 24d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 24f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 253:	89 f8                	mov    %edi,%eax
 255:	83 c4 2c             	add    $0x2c,%esp
 258:	5b                   	pop    %ebx
 259:	5e                   	pop    %esi
 25a:	5f                   	pop    %edi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
 25d:	90                   	nop
 25e:	90                   	nop
 25f:	90                   	nop

00000260 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 260:	b8 01 00 00 00       	mov    $0x1,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <exit>:
SYSCALL(exit)
 268:	b8 02 00 00 00       	mov    $0x2,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <wait>:
SYSCALL(wait)
 270:	b8 03 00 00 00       	mov    $0x3,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <pipe>:
SYSCALL(pipe)
 278:	b8 04 00 00 00       	mov    $0x4,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <read>:
SYSCALL(read)
 280:	b8 05 00 00 00       	mov    $0x5,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <write>:
SYSCALL(write)
 288:	b8 10 00 00 00       	mov    $0x10,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <close>:
SYSCALL(close)
 290:	b8 15 00 00 00       	mov    $0x15,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <kill>:
SYSCALL(kill)
 298:	b8 06 00 00 00       	mov    $0x6,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <exec>:
SYSCALL(exec)
 2a0:	b8 07 00 00 00       	mov    $0x7,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <open>:
SYSCALL(open)
 2a8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <mknod>:
SYSCALL(mknod)
 2b0:	b8 11 00 00 00       	mov    $0x11,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <unlink>:
SYSCALL(unlink)
 2b8:	b8 12 00 00 00       	mov    $0x12,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <fstat>:
SYSCALL(fstat)
 2c0:	b8 08 00 00 00       	mov    $0x8,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <link>:
SYSCALL(link)
 2c8:	b8 13 00 00 00       	mov    $0x13,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <mkdir>:
SYSCALL(mkdir)
 2d0:	b8 14 00 00 00       	mov    $0x14,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <chdir>:
SYSCALL(chdir)
 2d8:	b8 09 00 00 00       	mov    $0x9,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <dup>:
SYSCALL(dup)
 2e0:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <getpid>:
SYSCALL(getpid)
 2e8:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <sbrk>:
SYSCALL(sbrk)
 2f0:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <sleep>:
SYSCALL(sleep)
 2f8:	b8 0d 00 00 00       	mov    $0xd,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <set_tickets>:
SYSCALL(set_tickets)
 300:	b8 16 00 00 00       	mov    $0x16,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    
 308:	90                   	nop
 309:	90                   	nop
 30a:	90                   	nop
 30b:	90                   	nop
 30c:	90                   	nop
 30d:	90                   	nop
 30e:	90                   	nop
 30f:	90                   	nop

00000310 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	89 cf                	mov    %ecx,%edi
 316:	56                   	push   %esi
 317:	89 c6                	mov    %eax,%esi
 319:	53                   	push   %ebx
 31a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 31d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 320:	85 c9                	test   %ecx,%ecx
 322:	74 04                	je     328 <printint+0x18>
 324:	85 d2                	test   %edx,%edx
 326:	78 68                	js     390 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 328:	89 d0                	mov    %edx,%eax
 32a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 331:	31 c9                	xor    %ecx,%ecx
 333:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 336:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 338:	31 d2                	xor    %edx,%edx
 33a:	f7 f7                	div    %edi
 33c:	0f b6 92 0d 07 00 00 	movzbl 0x70d(%edx),%edx
 343:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 346:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 349:	85 c0                	test   %eax,%eax
 34b:	75 eb                	jne    338 <printint+0x28>
  if(neg)
 34d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 350:	85 c0                	test   %eax,%eax
 352:	74 08                	je     35c <printint+0x4c>
    buf[i++] = '-';
 354:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 359:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 35c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 35f:	90                   	nop
 360:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 364:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 367:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 36e:	00 
 36f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 372:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 375:	8d 45 e7             	lea    -0x19(%ebp),%eax
 378:	89 44 24 04          	mov    %eax,0x4(%esp)
 37c:	e8 07 ff ff ff       	call   288 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 381:	83 ff ff             	cmp    $0xffffffff,%edi
 384:	75 da                	jne    360 <printint+0x50>
    putc(fd, buf[i]);
}
 386:	83 c4 4c             	add    $0x4c,%esp
 389:	5b                   	pop    %ebx
 38a:	5e                   	pop    %esi
 38b:	5f                   	pop    %edi
 38c:	5d                   	pop    %ebp
 38d:	c3                   	ret    
 38e:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 390:	89 d0                	mov    %edx,%eax
 392:	f7 d8                	neg    %eax
 394:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 39b:	eb 94                	jmp    331 <printint+0x21>
 39d:	8d 76 00             	lea    0x0(%esi),%esi

000003a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
 3a6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	0f b6 10             	movzbl (%eax),%edx
 3af:	84 d2                	test   %dl,%dl
 3b1:	0f 84 c1 00 00 00    	je     478 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3b7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3ba:	31 ff                	xor    %edi,%edi
 3bc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 3bf:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3c1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 3c4:	eb 1e                	jmp    3e4 <printf+0x44>
 3c6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3c8:	83 fa 25             	cmp    $0x25,%edx
 3cb:	0f 85 af 00 00 00    	jne    480 <printf+0xe0>
 3d1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3d5:	83 c3 01             	add    $0x1,%ebx
 3d8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 3dc:	84 d2                	test   %dl,%dl
 3de:	0f 84 94 00 00 00    	je     478 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 3e4:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 3e6:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 3e9:	74 dd                	je     3c8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3eb:	83 ff 25             	cmp    $0x25,%edi
 3ee:	75 e5                	jne    3d5 <printf+0x35>
      if(c == 'd'){
 3f0:	83 fa 64             	cmp    $0x64,%edx
 3f3:	0f 84 3f 01 00 00    	je     538 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3f9:	83 fa 70             	cmp    $0x70,%edx
 3fc:	0f 84 a6 00 00 00    	je     4a8 <printf+0x108>
 402:	83 fa 78             	cmp    $0x78,%edx
 405:	0f 84 9d 00 00 00    	je     4a8 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 40b:	83 fa 73             	cmp    $0x73,%edx
 40e:	66 90                	xchg   %ax,%ax
 410:	0f 84 ba 00 00 00    	je     4d0 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 416:	83 fa 63             	cmp    $0x63,%edx
 419:	0f 84 41 01 00 00    	je     560 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 41f:	83 fa 25             	cmp    $0x25,%edx
 422:	0f 84 00 01 00 00    	je     528 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 428:	8b 4d 08             	mov    0x8(%ebp),%ecx
 42b:	89 55 cc             	mov    %edx,-0x34(%ebp)
 42e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 432:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 439:	00 
 43a:	89 74 24 04          	mov    %esi,0x4(%esp)
 43e:	89 0c 24             	mov    %ecx,(%esp)
 441:	e8 42 fe ff ff       	call   288 <write>
 446:	8b 55 cc             	mov    -0x34(%ebp),%edx
 449:	88 55 e7             	mov    %dl,-0x19(%ebp)
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 44f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 452:	31 ff                	xor    %edi,%edi
 454:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 45b:	00 
 45c:	89 74 24 04          	mov    %esi,0x4(%esp)
 460:	89 04 24             	mov    %eax,(%esp)
 463:	e8 20 fe ff ff       	call   288 <write>
 468:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 46b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 46f:	84 d2                	test   %dl,%dl
 471:	0f 85 6d ff ff ff    	jne    3e4 <printf+0x44>
 477:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 478:	83 c4 3c             	add    $0x3c,%esp
 47b:	5b                   	pop    %ebx
 47c:	5e                   	pop    %esi
 47d:	5f                   	pop    %edi
 47e:	5d                   	pop    %ebp
 47f:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 480:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 483:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 486:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48d:	00 
 48e:	89 74 24 04          	mov    %esi,0x4(%esp)
 492:	89 04 24             	mov    %eax,(%esp)
 495:	e8 ee fd ff ff       	call   288 <write>
 49a:	8b 45 0c             	mov    0xc(%ebp),%eax
 49d:	e9 33 ff ff ff       	jmp    3d5 <printf+0x35>
 4a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4ab:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 4b0:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4b9:	8b 10                	mov    (%eax),%edx
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	e8 4d fe ff ff       	call   310 <printint>
 4c3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 4c6:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4ca:	e9 06 ff ff ff       	jmp    3d5 <printf+0x35>
 4cf:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 4d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 4d3:	b9 06 07 00 00       	mov    $0x706,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 4d8:	8b 3a                	mov    (%edx),%edi
        ap++;
 4da:	83 c2 04             	add    $0x4,%edx
 4dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 4e0:	85 ff                	test   %edi,%edi
 4e2:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 4e5:	0f b6 17             	movzbl (%edi),%edx
 4e8:	84 d2                	test   %dl,%dl
 4ea:	74 33                	je     51f <printf+0x17f>
 4ec:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 4f8:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4fb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 505:	00 
 506:	89 74 24 04          	mov    %esi,0x4(%esp)
 50a:	89 1c 24             	mov    %ebx,(%esp)
 50d:	e8 76 fd ff ff       	call   288 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 512:	0f b6 17             	movzbl (%edi),%edx
 515:	84 d2                	test   %dl,%dl
 517:	75 df                	jne    4f8 <printf+0x158>
 519:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 51c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 51f:	31 ff                	xor    %edi,%edi
 521:	e9 af fe ff ff       	jmp    3d5 <printf+0x35>
 526:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 528:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 52c:	e9 1b ff ff ff       	jmp    44c <printf+0xac>
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 53b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 540:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 543:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 54a:	8b 10                	mov    (%eax),%edx
 54c:	8b 45 08             	mov    0x8(%ebp),%eax
 54f:	e8 bc fd ff ff       	call   310 <printint>
 554:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 557:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 55b:	e9 75 fe ff ff       	jmp    3d5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 560:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 563:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 565:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 568:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 571:	00 
 572:	89 74 24 04          	mov    %esi,0x4(%esp)
 576:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 579:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 57c:	e8 07 fd ff ff       	call   288 <write>
 581:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 584:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 588:	e9 48 fe ff ff       	jmp    3d5 <printf+0x35>
 58d:	90                   	nop
 58e:	90                   	nop
 58f:	90                   	nop

00000590 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 590:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	a1 28 07 00 00       	mov    0x728,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 596:	89 e5                	mov    %esp,%ebp
 598:	57                   	push   %edi
 599:	56                   	push   %esi
 59a:	53                   	push   %ebx
 59b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 59e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a1:	39 c8                	cmp    %ecx,%eax
 5a3:	73 1d                	jae    5c2 <free+0x32>
 5a5:	8d 76 00             	lea    0x0(%esi),%esi
 5a8:	8b 10                	mov    (%eax),%edx
 5aa:	39 d1                	cmp    %edx,%ecx
 5ac:	72 1a                	jb     5c8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ae:	39 d0                	cmp    %edx,%eax
 5b0:	72 08                	jb     5ba <free+0x2a>
 5b2:	39 c8                	cmp    %ecx,%eax
 5b4:	72 12                	jb     5c8 <free+0x38>
 5b6:	39 d1                	cmp    %edx,%ecx
 5b8:	72 0e                	jb     5c8 <free+0x38>
 5ba:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5bc:	39 c8                	cmp    %ecx,%eax
 5be:	66 90                	xchg   %ax,%ax
 5c0:	72 e6                	jb     5a8 <free+0x18>
 5c2:	8b 10                	mov    (%eax),%edx
 5c4:	eb e8                	jmp    5ae <free+0x1e>
 5c6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5c8:	8b 71 04             	mov    0x4(%ecx),%esi
 5cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ce:	39 d7                	cmp    %edx,%edi
 5d0:	74 19                	je     5eb <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5d5:	8b 50 04             	mov    0x4(%eax),%edx
 5d8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5db:	39 ce                	cmp    %ecx,%esi
 5dd:	74 23                	je     602 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5df:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5e1:	a3 28 07 00 00       	mov    %eax,0x728
}
 5e6:	5b                   	pop    %ebx
 5e7:	5e                   	pop    %esi
 5e8:	5f                   	pop    %edi
 5e9:	5d                   	pop    %ebp
 5ea:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5eb:	03 72 04             	add    0x4(%edx),%esi
 5ee:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5f1:	8b 10                	mov    (%eax),%edx
 5f3:	8b 12                	mov    (%edx),%edx
 5f5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5f8:	8b 50 04             	mov    0x4(%eax),%edx
 5fb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5fe:	39 ce                	cmp    %ecx,%esi
 600:	75 dd                	jne    5df <free+0x4f>
    p->s.size += bp->s.size;
 602:	03 51 04             	add    0x4(%ecx),%edx
 605:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 608:	8b 53 f8             	mov    -0x8(%ebx),%edx
 60b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 60d:	a3 28 07 00 00       	mov    %eax,0x728
}
 612:	5b                   	pop    %ebx
 613:	5e                   	pop    %esi
 614:	5f                   	pop    %edi
 615:	5d                   	pop    %ebp
 616:	c3                   	ret    
 617:	89 f6                	mov    %esi,%esi
 619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000620 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 629:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 62c:	8b 0d 28 07 00 00    	mov    0x728,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 632:	83 c3 07             	add    $0x7,%ebx
 635:	c1 eb 03             	shr    $0x3,%ebx
 638:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 63b:	85 c9                	test   %ecx,%ecx
 63d:	0f 84 9b 00 00 00    	je     6de <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 643:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 645:	8b 50 04             	mov    0x4(%eax),%edx
 648:	39 d3                	cmp    %edx,%ebx
 64a:	76 27                	jbe    673 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 64c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 653:	be 00 80 00 00       	mov    $0x8000,%esi
 658:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 65b:	90                   	nop
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 660:	3b 05 28 07 00 00    	cmp    0x728,%eax
 666:	74 30                	je     698 <malloc+0x78>
 668:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 66c:	8b 50 04             	mov    0x4(%eax),%edx
 66f:	39 d3                	cmp    %edx,%ebx
 671:	77 ed                	ja     660 <malloc+0x40>
      if(p->s.size == nunits)
 673:	39 d3                	cmp    %edx,%ebx
 675:	74 61                	je     6d8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 677:	29 da                	sub    %ebx,%edx
 679:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 67c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 67f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 682:	89 0d 28 07 00 00    	mov    %ecx,0x728
      return (void*)(p + 1);
 688:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 68b:	83 c4 2c             	add    $0x2c,%esp
 68e:	5b                   	pop    %ebx
 68f:	5e                   	pop    %esi
 690:	5f                   	pop    %edi
 691:	5d                   	pop    %ebp
 692:	c3                   	ret    
 693:	90                   	nop
 694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6a1:	bf 00 10 00 00       	mov    $0x1000,%edi
 6a6:	0f 43 fb             	cmovae %ebx,%edi
 6a9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6ac:	89 04 24             	mov    %eax,(%esp)
 6af:	e8 3c fc ff ff       	call   2f0 <sbrk>
  if(p == (char*)-1)
 6b4:	83 f8 ff             	cmp    $0xffffffff,%eax
 6b7:	74 18                	je     6d1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6b9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6bc:	83 c0 08             	add    $0x8,%eax
 6bf:	89 04 24             	mov    %eax,(%esp)
 6c2:	e8 c9 fe ff ff       	call   590 <free>
  return freep;
 6c7:	8b 0d 28 07 00 00    	mov    0x728,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6cd:	85 c9                	test   %ecx,%ecx
 6cf:	75 99                	jne    66a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6d1:	31 c0                	xor    %eax,%eax
 6d3:	eb b6                	jmp    68b <malloc+0x6b>
 6d5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 6d8:	8b 10                	mov    (%eax),%edx
 6da:	89 11                	mov    %edx,(%ecx)
 6dc:	eb a4                	jmp    682 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6de:	c7 05 28 07 00 00 20 	movl   $0x720,0x728
 6e5:	07 00 00 
    base.s.size = 0;
 6e8:	b9 20 07 00 00       	mov    $0x720,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6ed:	c7 05 20 07 00 00 20 	movl   $0x720,0x720
 6f4:	07 00 00 
    base.s.size = 0;
 6f7:	c7 05 24 07 00 00 00 	movl   $0x0,0x724
 6fe:	00 00 00 
 701:	e9 3d ff ff ff       	jmp    643 <malloc+0x23>
