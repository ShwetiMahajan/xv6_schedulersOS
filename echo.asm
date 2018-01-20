
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	57                   	push   %edi
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	83 ec 14             	sub    $0x14,%esp
   c:	8b 75 08             	mov    0x8(%ebp),%esi
   f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  for(i = 1; i < argc; i++)
  12:	83 fe 01             	cmp    $0x1,%esi
  15:	7e 60                	jle    77 <main+0x77>
  17:	bb 01 00 00 00       	mov    $0x1,%ebx
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1c:	83 c3 01             	add    $0x1,%ebx
  1f:	39 de                	cmp    %ebx,%esi
  21:	7e 30                	jle    53 <main+0x53>
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  28:	c7 44 24 0c 46 07 00 	movl   $0x746,0xc(%esp)
  2f:	00 
  30:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  34:	83 c3 01             	add    $0x1,%ebx
  37:	c7 44 24 04 48 07 00 	movl   $0x748,0x4(%esp)
  3e:	00 
  3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  46:	89 44 24 08          	mov    %eax,0x8(%esp)
  4a:	e8 91 03 00 00       	call   3e0 <printf>
  4f:	39 de                	cmp    %ebx,%esi
  51:	7f d5                	jg     28 <main+0x28>
  53:	c7 44 24 0c 4d 07 00 	movl   $0x74d,0xc(%esp)
  5a:	00 
  5b:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  5f:	c7 44 24 04 48 07 00 	movl   $0x748,0x4(%esp)
  66:	00 
  67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  72:	e8 69 03 00 00       	call   3e0 <printf>
  exit();
  77:	e8 2c 02 00 00       	call   2a8 <exit>
  7c:	90                   	nop
  7d:	90                   	nop
  7e:	90                   	nop
  7f:	90                   	nop

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  80:	55                   	push   %ebp
  81:	31 d2                	xor    %edx,%edx
  83:	89 e5                	mov    %esp,%ebp
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	53                   	push   %ebx
  89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  97:	83 c2 01             	add    $0x1,%edx
  9a:	84 c9                	test   %cl,%cl
  9c:	75 f2                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9e:	5b                   	pop    %ebx
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    
  a1:	eb 0d                	jmp    b0 <strcmp>
  a3:	90                   	nop
  a4:	90                   	nop
  a5:	90                   	nop
  a6:	90                   	nop
  a7:	90                   	nop
  a8:	90                   	nop
  a9:	90                   	nop
  aa:	90                   	nop
  ab:	90                   	nop
  ac:	90                   	nop
  ad:	90                   	nop
  ae:	90                   	nop
  af:	90                   	nop

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b6:	53                   	push   %ebx
  b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ba:	0f b6 01             	movzbl (%ecx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 14                	jne    d5 <strcmp+0x25>
  c1:	eb 25                	jmp    e8 <strcmp+0x38>
  c3:	90                   	nop
  c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  c8:	83 c1 01             	add    $0x1,%ecx
  cb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	0f b6 01             	movzbl (%ecx),%eax
  d1:	84 c0                	test   %al,%al
  d3:	74 13                	je     e8 <strcmp+0x38>
  d5:	0f b6 1a             	movzbl (%edx),%ebx
  d8:	38 d8                	cmp    %bl,%al
  da:	74 ec                	je     c8 <strcmp+0x18>
  dc:	0f b6 db             	movzbl %bl,%ebx
  df:	0f b6 c0             	movzbl %al,%eax
  e2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  e4:	5b                   	pop    %ebx
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e8:	0f b6 1a             	movzbl (%edx),%ebx
  eb:	31 c0                	xor    %eax,%eax
  ed:	0f b6 db             	movzbl %bl,%ebx
  f0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  f2:	5b                   	pop    %ebx
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 101:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 103:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 105:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 10a:	80 39 00             	cmpb   $0x0,(%ecx)
 10d:	74 0c                	je     11b <strlen+0x1b>
 10f:	90                   	nop
 110:	83 c2 01             	add    $0x1,%edx
 113:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 117:	89 d0                	mov    %edx,%eax
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 55 08             	mov    0x8(%ebp),%edx
 126:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	89 d0                	mov    %edx,%eax
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	89 f6                	mov    %esi,%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 11                	jne    162 <strchr+0x22>
 151:	eb 15                	jmp    168 <strchr+0x28>
 153:	90                   	nop
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 158:	83 c0 01             	add    $0x1,%eax
 15b:	0f b6 10             	movzbl (%eax),%edx
 15e:	84 d2                	test   %dl,%dl
 160:	74 06                	je     168 <strchr+0x28>
    if(*s == c)
 162:	38 ca                	cmp    %cl,%dl
 164:	75 f2                	jne    158 <strchr+0x18>
      return (char*)s;
  return 0;
}
 166:	5d                   	pop    %ebp
 167:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 16a:	5d                   	pop    %ebp
 16b:	90                   	nop
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 170:	c3                   	ret    
 171:	eb 0d                	jmp    180 <atoi>
 173:	90                   	nop
 174:	90                   	nop
 175:	90                   	nop
 176:	90                   	nop
 177:	90                   	nop
 178:	90                   	nop
 179:	90                   	nop
 17a:	90                   	nop
 17b:	90                   	nop
 17c:	90                   	nop
 17d:	90                   	nop
 17e:	90                   	nop
 17f:	90                   	nop

00000180 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 180:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 181:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 183:	89 e5                	mov    %esp,%ebp
 185:	8b 4d 08             	mov    0x8(%ebp),%ecx
 188:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 189:	0f b6 11             	movzbl (%ecx),%edx
 18c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 18f:	80 fb 09             	cmp    $0x9,%bl
 192:	77 1c                	ja     1b0 <atoi+0x30>
 194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 198:	0f be d2             	movsbl %dl,%edx
 19b:	83 c1 01             	add    $0x1,%ecx
 19e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a5:	0f b6 11             	movzbl (%ecx),%edx
 1a8:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1ab:	80 fb 09             	cmp    $0x9,%bl
 1ae:	76 e8                	jbe    198 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1b0:	5b                   	pop    %ebx
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	53                   	push   %ebx
 1c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ce:	85 db                	test   %ebx,%ebx
 1d0:	7e 14                	jle    1e6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 1d2:	31 d2                	xor    %edx,%edx
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 1d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1df:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1e2:	39 da                	cmp    %ebx,%edx
 1e4:	75 f2                	jne    1d8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1e6:	5b                   	pop    %ebx
 1e7:	5e                   	pop    %esi
 1e8:	5d                   	pop    %ebp
 1e9:	c3                   	ret    
 1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001f0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1f9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 1ff:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 204:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20b:	00 
 20c:	89 04 24             	mov    %eax,(%esp)
 20f:	e8 d4 00 00 00       	call   2e8 <open>
  if(fd < 0)
 214:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 216:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 218:	78 19                	js     233 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 1c 24             	mov    %ebx,(%esp)
 220:	89 44 24 04          	mov    %eax,0x4(%esp)
 224:	e8 d7 00 00 00       	call   300 <fstat>
  close(fd);
 229:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 22c:	89 c6                	mov    %eax,%esi
  close(fd);
 22e:	e8 9d 00 00 00       	call   2d0 <close>
  return r;
}
 233:	89 f0                	mov    %esi,%eax
 235:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 238:	8b 75 fc             	mov    -0x4(%ebp),%esi
 23b:	89 ec                	mov    %ebp,%esp
 23d:	5d                   	pop    %ebp
 23e:	c3                   	ret    
 23f:	90                   	nop

00000240 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	56                   	push   %esi
 245:	31 f6                	xor    %esi,%esi
 247:	53                   	push   %ebx
 248:	83 ec 2c             	sub    $0x2c,%esp
 24b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24e:	eb 06                	jmp    256 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 250:	3c 0a                	cmp    $0xa,%al
 252:	74 39                	je     28d <gets+0x4d>
 254:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	8d 5e 01             	lea    0x1(%esi),%ebx
 259:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 25c:	7d 31                	jge    28f <gets+0x4f>
    cc = read(0, &c, 1);
 25e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 261:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 268:	00 
 269:	89 44 24 04          	mov    %eax,0x4(%esp)
 26d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 274:	e8 47 00 00 00       	call   2c0 <read>
    if(cc < 1)
 279:	85 c0                	test   %eax,%eax
 27b:	7e 12                	jle    28f <gets+0x4f>
      break;
    buf[i++] = c;
 27d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 281:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 285:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 289:	3c 0d                	cmp    $0xd,%al
 28b:	75 c3                	jne    250 <gets+0x10>
 28d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 28f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 293:	89 f8                	mov    %edi,%eax
 295:	83 c4 2c             	add    $0x2c,%esp
 298:	5b                   	pop    %ebx
 299:	5e                   	pop    %esi
 29a:	5f                   	pop    %edi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	90                   	nop
 29e:	90                   	nop
 29f:	90                   	nop

000002a0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a0:	b8 01 00 00 00       	mov    $0x1,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <exit>:
SYSCALL(exit)
 2a8:	b8 02 00 00 00       	mov    $0x2,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <wait>:
SYSCALL(wait)
 2b0:	b8 03 00 00 00       	mov    $0x3,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <pipe>:
SYSCALL(pipe)
 2b8:	b8 04 00 00 00       	mov    $0x4,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <read>:
SYSCALL(read)
 2c0:	b8 05 00 00 00       	mov    $0x5,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <write>:
SYSCALL(write)
 2c8:	b8 10 00 00 00       	mov    $0x10,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <close>:
SYSCALL(close)
 2d0:	b8 15 00 00 00       	mov    $0x15,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <kill>:
SYSCALL(kill)
 2d8:	b8 06 00 00 00       	mov    $0x6,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <exec>:
SYSCALL(exec)
 2e0:	b8 07 00 00 00       	mov    $0x7,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <open>:
SYSCALL(open)
 2e8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <mknod>:
SYSCALL(mknod)
 2f0:	b8 11 00 00 00       	mov    $0x11,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <unlink>:
SYSCALL(unlink)
 2f8:	b8 12 00 00 00       	mov    $0x12,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <fstat>:
SYSCALL(fstat)
 300:	b8 08 00 00 00       	mov    $0x8,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <link>:
SYSCALL(link)
 308:	b8 13 00 00 00       	mov    $0x13,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mkdir>:
SYSCALL(mkdir)
 310:	b8 14 00 00 00       	mov    $0x14,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <chdir>:
SYSCALL(chdir)
 318:	b8 09 00 00 00       	mov    $0x9,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <dup>:
SYSCALL(dup)
 320:	b8 0a 00 00 00       	mov    $0xa,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <getpid>:
SYSCALL(getpid)
 328:	b8 0b 00 00 00       	mov    $0xb,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <sbrk>:
SYSCALL(sbrk)
 330:	b8 0c 00 00 00       	mov    $0xc,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <sleep>:
SYSCALL(sleep)
 338:	b8 0d 00 00 00       	mov    $0xd,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <set_tickets>:
SYSCALL(set_tickets)
 340:	b8 16 00 00 00       	mov    $0x16,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    
 348:	90                   	nop
 349:	90                   	nop
 34a:	90                   	nop
 34b:	90                   	nop
 34c:	90                   	nop
 34d:	90                   	nop
 34e:	90                   	nop
 34f:	90                   	nop

00000350 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	89 cf                	mov    %ecx,%edi
 356:	56                   	push   %esi
 357:	89 c6                	mov    %eax,%esi
 359:	53                   	push   %ebx
 35a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 35d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 360:	85 c9                	test   %ecx,%ecx
 362:	74 04                	je     368 <printint+0x18>
 364:	85 d2                	test   %edx,%edx
 366:	78 68                	js     3d0 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 368:	89 d0                	mov    %edx,%eax
 36a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 371:	31 c9                	xor    %ecx,%ecx
 373:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 376:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 378:	31 d2                	xor    %edx,%edx
 37a:	f7 f7                	div    %edi
 37c:	0f b6 92 56 07 00 00 	movzbl 0x756(%edx),%edx
 383:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 386:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 389:	85 c0                	test   %eax,%eax
 38b:	75 eb                	jne    378 <printint+0x28>
  if(neg)
 38d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 390:	85 c0                	test   %eax,%eax
 392:	74 08                	je     39c <printint+0x4c>
    buf[i++] = '-';
 394:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 399:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 39c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 39f:	90                   	nop
 3a0:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 3a4:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ae:	00 
 3af:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3b2:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3b5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bc:	e8 07 ff ff ff       	call   2c8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3c1:	83 ff ff             	cmp    $0xffffffff,%edi
 3c4:	75 da                	jne    3a0 <printint+0x50>
    putc(fd, buf[i]);
}
 3c6:	83 c4 4c             	add    $0x4c,%esp
 3c9:	5b                   	pop    %ebx
 3ca:	5e                   	pop    %esi
 3cb:	5f                   	pop    %edi
 3cc:	5d                   	pop    %ebp
 3cd:	c3                   	ret    
 3ce:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3d0:	89 d0                	mov    %edx,%eax
 3d2:	f7 d8                	neg    %eax
 3d4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 3db:	eb 94                	jmp    371 <printint+0x21>
 3dd:	8d 76 00             	lea    0x0(%esi),%esi

000003e0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ec:	0f b6 10             	movzbl (%eax),%edx
 3ef:	84 d2                	test   %dl,%dl
 3f1:	0f 84 c1 00 00 00    	je     4b8 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3f7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3fa:	31 ff                	xor    %edi,%edi
 3fc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 3ff:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 401:	8d 75 e7             	lea    -0x19(%ebp),%esi
 404:	eb 1e                	jmp    424 <printf+0x44>
 406:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 408:	83 fa 25             	cmp    $0x25,%edx
 40b:	0f 85 af 00 00 00    	jne    4c0 <printf+0xe0>
 411:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 415:	83 c3 01             	add    $0x1,%ebx
 418:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 41c:	84 d2                	test   %dl,%dl
 41e:	0f 84 94 00 00 00    	je     4b8 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 424:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 426:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 429:	74 dd                	je     408 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 42b:	83 ff 25             	cmp    $0x25,%edi
 42e:	75 e5                	jne    415 <printf+0x35>
      if(c == 'd'){
 430:	83 fa 64             	cmp    $0x64,%edx
 433:	0f 84 3f 01 00 00    	je     578 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 439:	83 fa 70             	cmp    $0x70,%edx
 43c:	0f 84 a6 00 00 00    	je     4e8 <printf+0x108>
 442:	83 fa 78             	cmp    $0x78,%edx
 445:	0f 84 9d 00 00 00    	je     4e8 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 44b:	83 fa 73             	cmp    $0x73,%edx
 44e:	66 90                	xchg   %ax,%ax
 450:	0f 84 ba 00 00 00    	je     510 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 456:	83 fa 63             	cmp    $0x63,%edx
 459:	0f 84 41 01 00 00    	je     5a0 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 45f:	83 fa 25             	cmp    $0x25,%edx
 462:	0f 84 00 01 00 00    	je     568 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 468:	8b 4d 08             	mov    0x8(%ebp),%ecx
 46b:	89 55 cc             	mov    %edx,-0x34(%ebp)
 46e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 472:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 479:	00 
 47a:	89 74 24 04          	mov    %esi,0x4(%esp)
 47e:	89 0c 24             	mov    %ecx,(%esp)
 481:	e8 42 fe ff ff       	call   2c8 <write>
 486:	8b 55 cc             	mov    -0x34(%ebp),%edx
 489:	88 55 e7             	mov    %dl,-0x19(%ebp)
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 48f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 492:	31 ff                	xor    %edi,%edi
 494:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 49b:	00 
 49c:	89 74 24 04          	mov    %esi,0x4(%esp)
 4a0:	89 04 24             	mov    %eax,(%esp)
 4a3:	e8 20 fe ff ff       	call   2c8 <write>
 4a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4ab:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4af:	84 d2                	test   %dl,%dl
 4b1:	0f 85 6d ff ff ff    	jne    424 <printf+0x44>
 4b7:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4b8:	83 c4 3c             	add    $0x3c,%esp
 4bb:	5b                   	pop    %ebx
 4bc:	5e                   	pop    %esi
 4bd:	5f                   	pop    %edi
 4be:	5d                   	pop    %ebp
 4bf:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4c3:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cd:	00 
 4ce:	89 74 24 04          	mov    %esi,0x4(%esp)
 4d2:	89 04 24             	mov    %eax,(%esp)
 4d5:	e8 ee fd ff ff       	call   2c8 <write>
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	e9 33 ff ff ff       	jmp    415 <printf+0x35>
 4e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4eb:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 4f0:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4f9:	8b 10                	mov    (%eax),%edx
 4fb:	8b 45 08             	mov    0x8(%ebp),%eax
 4fe:	e8 4d fe ff ff       	call   350 <printint>
 503:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 506:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 50a:	e9 06 ff ff ff       	jmp    415 <printf+0x35>
 50f:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 510:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 513:	b9 4f 07 00 00       	mov    $0x74f,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 518:	8b 3a                	mov    (%edx),%edi
        ap++;
 51a:	83 c2 04             	add    $0x4,%edx
 51d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 520:	85 ff                	test   %edi,%edi
 522:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 525:	0f b6 17             	movzbl (%edi),%edx
 528:	84 d2                	test   %dl,%dl
 52a:	74 33                	je     55f <printf+0x17f>
 52c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 52f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 538:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 53b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 545:	00 
 546:	89 74 24 04          	mov    %esi,0x4(%esp)
 54a:	89 1c 24             	mov    %ebx,(%esp)
 54d:	e8 76 fd ff ff       	call   2c8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 552:	0f b6 17             	movzbl (%edi),%edx
 555:	84 d2                	test   %dl,%dl
 557:	75 df                	jne    538 <printf+0x158>
 559:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 55c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 55f:	31 ff                	xor    %edi,%edi
 561:	e9 af fe ff ff       	jmp    415 <printf+0x35>
 566:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 568:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 56c:	e9 1b ff ff ff       	jmp    48c <printf+0xac>
 571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 578:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 57b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 580:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 583:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 58a:	8b 10                	mov    (%eax),%edx
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
 58f:	e8 bc fd ff ff       	call   350 <printint>
 594:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 597:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 59b:	e9 75 fe ff ff       	jmp    415 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 5a3:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a8:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5aa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b1:	00 
 5b2:	89 74 24 04          	mov    %esi,0x4(%esp)
 5b6:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b9:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5bc:	e8 07 fd ff ff       	call   2c8 <write>
 5c1:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 5c4:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5c8:	e9 48 fe ff ff       	jmp    415 <printf+0x35>
 5cd:	90                   	nop
 5ce:	90                   	nop
 5cf:	90                   	nop

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 70 07 00 00       	mov    0x770,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	39 c8                	cmp    %ecx,%eax
 5e3:	73 1d                	jae    602 <free+0x32>
 5e5:	8d 76 00             	lea    0x0(%esi),%esi
 5e8:	8b 10                	mov    (%eax),%edx
 5ea:	39 d1                	cmp    %edx,%ecx
 5ec:	72 1a                	jb     608 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ee:	39 d0                	cmp    %edx,%eax
 5f0:	72 08                	jb     5fa <free+0x2a>
 5f2:	39 c8                	cmp    %ecx,%eax
 5f4:	72 12                	jb     608 <free+0x38>
 5f6:	39 d1                	cmp    %edx,%ecx
 5f8:	72 0e                	jb     608 <free+0x38>
 5fa:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fc:	39 c8                	cmp    %ecx,%eax
 5fe:	66 90                	xchg   %ax,%ax
 600:	72 e6                	jb     5e8 <free+0x18>
 602:	8b 10                	mov    (%eax),%edx
 604:	eb e8                	jmp    5ee <free+0x1e>
 606:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 608:	8b 71 04             	mov    0x4(%ecx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	39 d7                	cmp    %edx,%edi
 610:	74 19                	je     62b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 612:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 615:	8b 50 04             	mov    0x4(%eax),%edx
 618:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61b:	39 ce                	cmp    %ecx,%esi
 61d:	74 23                	je     642 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 61f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 621:	a3 70 07 00 00       	mov    %eax,0x770
}
 626:	5b                   	pop    %ebx
 627:	5e                   	pop    %esi
 628:	5f                   	pop    %edi
 629:	5d                   	pop    %ebp
 62a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 62b:	03 72 04             	add    0x4(%edx),%esi
 62e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 631:	8b 10                	mov    (%eax),%edx
 633:	8b 12                	mov    (%edx),%edx
 635:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 638:	8b 50 04             	mov    0x4(%eax),%edx
 63b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 63e:	39 ce                	cmp    %ecx,%esi
 640:	75 dd                	jne    61f <free+0x4f>
    p->s.size += bp->s.size;
 642:	03 51 04             	add    0x4(%ecx),%edx
 645:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 648:	8b 53 f8             	mov    -0x8(%ebx),%edx
 64b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 64d:	a3 70 07 00 00       	mov    %eax,0x770
}
 652:	5b                   	pop    %ebx
 653:	5e                   	pop    %esi
 654:	5f                   	pop    %edi
 655:	5d                   	pop    %ebp
 656:	c3                   	ret    
 657:	89 f6                	mov    %esi,%esi
 659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 66c:	8b 0d 70 07 00 00    	mov    0x770,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	83 c3 07             	add    $0x7,%ebx
 675:	c1 eb 03             	shr    $0x3,%ebx
 678:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 67b:	85 c9                	test   %ecx,%ecx
 67d:	0f 84 9b 00 00 00    	je     71e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 683:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	39 d3                	cmp    %edx,%ebx
 68a:	76 27                	jbe    6b3 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 68c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 693:	be 00 80 00 00       	mov    $0x8000,%esi
 698:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 69b:	90                   	nop
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6a0:	3b 05 70 07 00 00    	cmp    0x770,%eax
 6a6:	74 30                	je     6d8 <malloc+0x78>
 6a8:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6aa:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6ac:	8b 50 04             	mov    0x4(%eax),%edx
 6af:	39 d3                	cmp    %edx,%ebx
 6b1:	77 ed                	ja     6a0 <malloc+0x40>
      if(p->s.size == nunits)
 6b3:	39 d3                	cmp    %edx,%ebx
 6b5:	74 61                	je     718 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6b7:	29 da                	sub    %ebx,%edx
 6b9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6bc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6bf:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6c2:	89 0d 70 07 00 00    	mov    %ecx,0x770
      return (void*)(p + 1);
 6c8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6cb:	83 c4 2c             	add    $0x2c,%esp
 6ce:	5b                   	pop    %ebx
 6cf:	5e                   	pop    %esi
 6d0:	5f                   	pop    %edi
 6d1:	5d                   	pop    %ebp
 6d2:	c3                   	ret    
 6d3:	90                   	nop
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 6d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6db:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6e1:	bf 00 10 00 00       	mov    $0x1000,%edi
 6e6:	0f 43 fb             	cmovae %ebx,%edi
 6e9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6ec:	89 04 24             	mov    %eax,(%esp)
 6ef:	e8 3c fc ff ff       	call   330 <sbrk>
  if(p == (char*)-1)
 6f4:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f7:	74 18                	je     711 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6f9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6fc:	83 c0 08             	add    $0x8,%eax
 6ff:	89 04 24             	mov    %eax,(%esp)
 702:	e8 c9 fe ff ff       	call   5d0 <free>
  return freep;
 707:	8b 0d 70 07 00 00    	mov    0x770,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 70d:	85 c9                	test   %ecx,%ecx
 70f:	75 99                	jne    6aa <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 711:	31 c0                	xor    %eax,%eax
 713:	eb b6                	jmp    6cb <malloc+0x6b>
 715:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 718:	8b 10                	mov    (%eax),%edx
 71a:	89 11                	mov    %edx,(%ecx)
 71c:	eb a4                	jmp    6c2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 71e:	c7 05 70 07 00 00 68 	movl   $0x768,0x770
 725:	07 00 00 
    base.s.size = 0;
 728:	b9 68 07 00 00       	mov    $0x768,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 72d:	c7 05 68 07 00 00 68 	movl   $0x768,0x768
 734:	07 00 00 
    base.s.size = 0;
 737:	c7 05 6c 07 00 00 00 	movl   $0x0,0x76c
 73e:	00 00 00 
 741:	e9 3d ff ff ff       	jmp    683 <malloc+0x23>
