
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	57                   	push   %edi
   7:	56                   	push   %esi
   8:	53                   	push   %ebx

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
    if(fork() > 0)
   9:	31 db                	xor    %ebx,%ebx
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   b:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));
  11:	8d 74 24 16          	lea    0x16(%esp),%esi

int
main(int argc, char *argv[])
{
  int fd, i;
  char path[] = "stressfs0";
  15:	c7 84 24 16 02 00 00 	movl   $0x65727473,0x216(%esp)
  1c:	73 74 72 65 
  20:	c7 84 24 1a 02 00 00 	movl   $0x73667373,0x21a(%esp)
  27:	73 73 66 73 
  2b:	66 c7 84 24 1e 02 00 	movw   $0x30,0x21e(%esp)
  32:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  35:	c7 44 24 04 26 08 00 	movl   $0x826,0x4(%esp)
  3c:	00 
  3d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  44:	e8 77 04 00 00       	call   4c0 <printf>
  memset(data, 'a', sizeof(data));
  49:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  50:	00 
  51:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  58:	00 
  59:	89 34 24             	mov    %esi,(%esp)
  5c:	e8 9f 01 00 00       	call   200 <memset>

  for(i = 0; i < 4; i++)
    if(fork() > 0)
  61:	e8 1a 03 00 00       	call   380 <fork>
  66:	85 c0                	test   %eax,%eax
  68:	7f 2b                	jg     95 <main+0x95>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  70:	e8 0b 03 00 00       	call   380 <fork>
  75:	b3 01                	mov    $0x1,%bl
  77:	85 c0                	test   %eax,%eax
  79:	7f 1a                	jg     95 <main+0x95>
  7b:	e8 00 03 00 00       	call   380 <fork>
  80:	b3 02                	mov    $0x2,%bl
  82:	85 c0                	test   %eax,%eax
  84:	7f 0f                	jg     95 <main+0x95>
  86:	e8 f5 02 00 00       	call   380 <fork>
  8b:	31 db                	xor    %ebx,%ebx
  8d:	85 c0                	test   %eax,%eax
  8f:	0f 9e c3             	setle  %bl
  92:	83 c3 03             	add    $0x3,%ebx
      break;

  printf(1, "write %d\n", i);
  95:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  99:	c7 44 24 04 39 08 00 	movl   $0x839,0x4(%esp)
  a0:	00 
  a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a8:	e8 13 04 00 00       	call   4c0 <printf>

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  ad:	8d 84 24 16 02 00 00 	lea    0x216(%esp),%eax
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);

  path[8] += i;
  b4:	00 9c 24 1e 02 00 00 	add    %bl,0x21e(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bb:	31 db                	xor    %ebx,%ebx
  bd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c4:	00 
  c5:	89 04 24             	mov    %eax,(%esp)
  c8:	e8 fb 02 00 00       	call   3c8 <open>
  cd:	89 c7                	mov    %eax,%edi
  cf:	90                   	nop
  for(i = 0; i < 20; i++)
  d0:	83 c3 01             	add    $0x1,%ebx
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  d3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  da:	00 
  db:	89 74 24 04          	mov    %esi,0x4(%esp)
  df:	89 3c 24             	mov    %edi,(%esp)
  e2:	e8 c1 02 00 00       	call   3a8 <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  e7:	83 fb 14             	cmp    $0x14,%ebx
  ea:	75 e4                	jne    d0 <main+0xd0>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  ec:	89 3c 24             	mov    %edi,(%esp)

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  ef:	30 db                	xor    %bl,%bl
  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  f1:	e8 ba 02 00 00       	call   3b0 <close>

  printf(1, "read\n");
  f6:	c7 44 24 04 43 08 00 	movl   $0x843,0x4(%esp)
  fd:	00 
  fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 105:	e8 b6 03 00 00       	call   4c0 <printf>

  fd = open(path, O_RDONLY);
 10a:	8d 84 24 16 02 00 00 	lea    0x216(%esp),%eax
 111:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 118:	00 
 119:	89 04 24             	mov    %eax,(%esp)
 11c:	e8 a7 02 00 00       	call   3c8 <open>
 121:	89 c7                	mov    %eax,%edi
 123:	90                   	nop
 124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < 20; i++)
 128:	83 c3 01             	add    $0x1,%ebx
    read(fd, data, sizeof(data));
 12b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 132:	00 
 133:	89 74 24 04          	mov    %esi,0x4(%esp)
 137:	89 3c 24             	mov    %edi,(%esp)
 13a:	e8 61 02 00 00       	call   3a0 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 13f:	83 fb 14             	cmp    $0x14,%ebx
 142:	75 e4                	jne    128 <main+0x128>
    read(fd, data, sizeof(data));
  close(fd);
 144:	89 3c 24             	mov    %edi,(%esp)
 147:	e8 64 02 00 00       	call   3b0 <close>

  wait();
 14c:	e8 3f 02 00 00       	call   390 <wait>

  exit();
 151:	e8 32 02 00 00       	call   388 <exit>
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

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 160:	55                   	push   %ebp
 161:	31 d2                	xor    %edx,%edx
 163:	89 e5                	mov    %esp,%ebp
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	53                   	push   %ebx
 169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 170:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 174:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 177:	83 c2 01             	add    $0x1,%edx
 17a:	84 c9                	test   %cl,%cl
 17c:	75 f2                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 17e:	5b                   	pop    %ebx
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	eb 0d                	jmp    190 <strcmp>
 183:	90                   	nop
 184:	90                   	nop
 185:	90                   	nop
 186:	90                   	nop
 187:	90                   	nop
 188:	90                   	nop
 189:	90                   	nop
 18a:	90                   	nop
 18b:	90                   	nop
 18c:	90                   	nop
 18d:	90                   	nop
 18e:	90                   	nop
 18f:	90                   	nop

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 4d 08             	mov    0x8(%ebp),%ecx
 196:	53                   	push   %ebx
 197:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 19a:	0f b6 01             	movzbl (%ecx),%eax
 19d:	84 c0                	test   %al,%al
 19f:	75 14                	jne    1b5 <strcmp+0x25>
 1a1:	eb 25                	jmp    1c8 <strcmp+0x38>
 1a3:	90                   	nop
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 1a8:	83 c1 01             	add    $0x1,%ecx
 1ab:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ae:	0f b6 01             	movzbl (%ecx),%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	74 13                	je     1c8 <strcmp+0x38>
 1b5:	0f b6 1a             	movzbl (%edx),%ebx
 1b8:	38 d8                	cmp    %bl,%al
 1ba:	74 ec                	je     1a8 <strcmp+0x18>
 1bc:	0f b6 db             	movzbl %bl,%ebx
 1bf:	0f b6 c0             	movzbl %al,%eax
 1c2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 1c4:	5b                   	pop    %ebx
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c8:	0f b6 1a             	movzbl (%edx),%ebx
 1cb:	31 c0                	xor    %eax,%eax
 1cd:	0f b6 db             	movzbl %bl,%ebx
 1d0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 1d2:	5b                   	pop    %ebx
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    
 1d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <strlen>:

uint
strlen(char *s)
{
 1e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 1e1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 1e5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ea:	80 39 00             	cmpb   $0x0,(%ecx)
 1ed:	74 0c                	je     1fb <strlen+0x1b>
 1ef:	90                   	nop
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	75 f5                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi

00000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 55 08             	mov    0x8(%ebp),%edx
 206:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 207:	8b 4d 10             	mov    0x10(%ebp),%ecx
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 d7                	mov    %edx,%edi
 20f:	fc                   	cld    
 210:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 212:	89 d0                	mov    %edx,%eax
 214:	5f                   	pop    %edi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    
 217:	89 f6                	mov    %esi,%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 22a:	0f b6 10             	movzbl (%eax),%edx
 22d:	84 d2                	test   %dl,%dl
 22f:	75 11                	jne    242 <strchr+0x22>
 231:	eb 15                	jmp    248 <strchr+0x28>
 233:	90                   	nop
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 238:	83 c0 01             	add    $0x1,%eax
 23b:	0f b6 10             	movzbl (%eax),%edx
 23e:	84 d2                	test   %dl,%dl
 240:	74 06                	je     248 <strchr+0x28>
    if(*s == c)
 242:	38 ca                	cmp    %cl,%dl
 244:	75 f2                	jne    238 <strchr+0x18>
      return (char*)s;
  return 0;
}
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 248:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 24a:	5d                   	pop    %ebp
 24b:	90                   	nop
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	c3                   	ret    
 251:	eb 0d                	jmp    260 <atoi>
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

00000260 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 260:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 261:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 263:	89 e5                	mov    %esp,%ebp
 265:	8b 4d 08             	mov    0x8(%ebp),%ecx
 268:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 269:	0f b6 11             	movzbl (%ecx),%edx
 26c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 26f:	80 fb 09             	cmp    $0x9,%bl
 272:	77 1c                	ja     290 <atoi+0x30>
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 278:	0f be d2             	movsbl %dl,%edx
 27b:	83 c1 01             	add    $0x1,%ecx
 27e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 281:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 285:	0f b6 11             	movzbl (%ecx),%edx
 288:	8d 5a d0             	lea    -0x30(%edx),%ebx
 28b:	80 fb 09             	cmp    $0x9,%bl
 28e:	76 e8                	jbe    278 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 290:	5b                   	pop    %ebx
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    
 293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	53                   	push   %ebx
 2a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	85 db                	test   %ebx,%ebx
 2b0:	7e 14                	jle    2c6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 2b2:	31 d2                	xor    %edx,%edx
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 2b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2bf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c2:	39 da                	cmp    %ebx,%edx
 2c4:	75 f2                	jne    2b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    
 2ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002d0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2d9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 2df:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2eb:	00 
 2ec:	89 04 24             	mov    %eax,(%esp)
 2ef:	e8 d4 00 00 00       	call   3c8 <open>
  if(fd < 0)
 2f4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2f8:	78 19                	js     313 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fd:	89 1c 24             	mov    %ebx,(%esp)
 300:	89 44 24 04          	mov    %eax,0x4(%esp)
 304:	e8 d7 00 00 00       	call   3e0 <fstat>
  close(fd);
 309:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 30c:	89 c6                	mov    %eax,%esi
  close(fd);
 30e:	e8 9d 00 00 00       	call   3b0 <close>
  return r;
}
 313:	89 f0                	mov    %esi,%eax
 315:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 318:	8b 75 fc             	mov    -0x4(%ebp),%esi
 31b:	89 ec                	mov    %ebp,%esp
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret    
 31f:	90                   	nop

00000320 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	31 f6                	xor    %esi,%esi
 327:	53                   	push   %ebx
 328:	83 ec 2c             	sub    $0x2c,%esp
 32b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32e:	eb 06                	jmp    336 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 330:	3c 0a                	cmp    $0xa,%al
 332:	74 39                	je     36d <gets+0x4d>
 334:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 336:	8d 5e 01             	lea    0x1(%esi),%ebx
 339:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 33c:	7d 31                	jge    36f <gets+0x4f>
    cc = read(0, &c, 1);
 33e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 341:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 348:	00 
 349:	89 44 24 04          	mov    %eax,0x4(%esp)
 34d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 354:	e8 47 00 00 00       	call   3a0 <read>
    if(cc < 1)
 359:	85 c0                	test   %eax,%eax
 35b:	7e 12                	jle    36f <gets+0x4f>
      break;
    buf[i++] = c;
 35d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 361:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 365:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 369:	3c 0d                	cmp    $0xd,%al
 36b:	75 c3                	jne    330 <gets+0x10>
 36d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 36f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 373:	89 f8                	mov    %edi,%eax
 375:	83 c4 2c             	add    $0x2c,%esp
 378:	5b                   	pop    %ebx
 379:	5e                   	pop    %esi
 37a:	5f                   	pop    %edi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
 37d:	90                   	nop
 37e:	90                   	nop
 37f:	90                   	nop

00000380 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 380:	b8 01 00 00 00       	mov    $0x1,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exit>:
SYSCALL(exit)
 388:	b8 02 00 00 00       	mov    $0x2,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <wait>:
SYSCALL(wait)
 390:	b8 03 00 00 00       	mov    $0x3,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <pipe>:
SYSCALL(pipe)
 398:	b8 04 00 00 00       	mov    $0x4,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <read>:
SYSCALL(read)
 3a0:	b8 05 00 00 00       	mov    $0x5,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <write>:
SYSCALL(write)
 3a8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <close>:
SYSCALL(close)
 3b0:	b8 15 00 00 00       	mov    $0x15,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <kill>:
SYSCALL(kill)
 3b8:	b8 06 00 00 00       	mov    $0x6,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <exec>:
SYSCALL(exec)
 3c0:	b8 07 00 00 00       	mov    $0x7,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <open>:
SYSCALL(open)
 3c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mknod>:
SYSCALL(mknod)
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <unlink>:
SYSCALL(unlink)
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <fstat>:
SYSCALL(fstat)
 3e0:	b8 08 00 00 00       	mov    $0x8,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <link>:
SYSCALL(link)
 3e8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mkdir>:
SYSCALL(mkdir)
 3f0:	b8 14 00 00 00       	mov    $0x14,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <chdir>:
SYSCALL(chdir)
 3f8:	b8 09 00 00 00       	mov    $0x9,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <dup>:
SYSCALL(dup)
 400:	b8 0a 00 00 00       	mov    $0xa,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getpid>:
SYSCALL(getpid)
 408:	b8 0b 00 00 00       	mov    $0xb,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sbrk>:
SYSCALL(sbrk)
 410:	b8 0c 00 00 00       	mov    $0xc,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleep>:
SYSCALL(sleep)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <set_tickets>:
SYSCALL(set_tickets)
 420:	b8 16 00 00 00       	mov    $0x16,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    
 428:	90                   	nop
 429:	90                   	nop
 42a:	90                   	nop
 42b:	90                   	nop
 42c:	90                   	nop
 42d:	90                   	nop
 42e:	90                   	nop
 42f:	90                   	nop

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	89 cf                	mov    %ecx,%edi
 436:	56                   	push   %esi
 437:	89 c6                	mov    %eax,%esi
 439:	53                   	push   %ebx
 43a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 440:	85 c9                	test   %ecx,%ecx
 442:	74 04                	je     448 <printint+0x18>
 444:	85 d2                	test   %edx,%edx
 446:	78 68                	js     4b0 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 448:	89 d0                	mov    %edx,%eax
 44a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 451:	31 c9                	xor    %ecx,%ecx
 453:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 456:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 458:	31 d2                	xor    %edx,%edx
 45a:	f7 f7                	div    %edi
 45c:	0f b6 92 50 08 00 00 	movzbl 0x850(%edx),%edx
 463:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 466:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 469:	85 c0                	test   %eax,%eax
 46b:	75 eb                	jne    458 <printint+0x28>
  if(neg)
 46d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 470:	85 c0                	test   %eax,%eax
 472:	74 08                	je     47c <printint+0x4c>
    buf[i++] = '-';
 474:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 479:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 47c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 47f:	90                   	nop
 480:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 484:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 487:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48e:	00 
 48f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 492:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 495:	8d 45 e7             	lea    -0x19(%ebp),%eax
 498:	89 44 24 04          	mov    %eax,0x4(%esp)
 49c:	e8 07 ff ff ff       	call   3a8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a1:	83 ff ff             	cmp    $0xffffffff,%edi
 4a4:	75 da                	jne    480 <printint+0x50>
    putc(fd, buf[i]);
}
 4a6:	83 c4 4c             	add    $0x4c,%esp
 4a9:	5b                   	pop    %ebx
 4aa:	5e                   	pop    %esi
 4ab:	5f                   	pop    %edi
 4ac:	5d                   	pop    %ebp
 4ad:	c3                   	ret    
 4ae:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4b0:	89 d0                	mov    %edx,%eax
 4b2:	f7 d8                	neg    %eax
 4b4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 4bb:	eb 94                	jmp    451 <printint+0x21>
 4bd:	8d 76 00             	lea    0x0(%esi),%esi

000004c0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	53                   	push   %ebx
 4c6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cc:	0f b6 10             	movzbl (%eax),%edx
 4cf:	84 d2                	test   %dl,%dl
 4d1:	0f 84 c1 00 00 00    	je     598 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4d7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4da:	31 ff                	xor    %edi,%edi
 4dc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 4df:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4e1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 4e4:	eb 1e                	jmp    504 <printf+0x44>
 4e6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4e8:	83 fa 25             	cmp    $0x25,%edx
 4eb:	0f 85 af 00 00 00    	jne    5a0 <printf+0xe0>
 4f1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4f5:	83 c3 01             	add    $0x1,%ebx
 4f8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4fc:	84 d2                	test   %dl,%dl
 4fe:	0f 84 94 00 00 00    	je     598 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 504:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 506:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 509:	74 dd                	je     4e8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 50b:	83 ff 25             	cmp    $0x25,%edi
 50e:	75 e5                	jne    4f5 <printf+0x35>
      if(c == 'd'){
 510:	83 fa 64             	cmp    $0x64,%edx
 513:	0f 84 3f 01 00 00    	je     658 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 519:	83 fa 70             	cmp    $0x70,%edx
 51c:	0f 84 a6 00 00 00    	je     5c8 <printf+0x108>
 522:	83 fa 78             	cmp    $0x78,%edx
 525:	0f 84 9d 00 00 00    	je     5c8 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 52b:	83 fa 73             	cmp    $0x73,%edx
 52e:	66 90                	xchg   %ax,%ax
 530:	0f 84 ba 00 00 00    	je     5f0 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 536:	83 fa 63             	cmp    $0x63,%edx
 539:	0f 84 41 01 00 00    	je     680 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 53f:	83 fa 25             	cmp    $0x25,%edx
 542:	0f 84 00 01 00 00    	je     648 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 548:	8b 4d 08             	mov    0x8(%ebp),%ecx
 54b:	89 55 cc             	mov    %edx,-0x34(%ebp)
 54e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 552:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 559:	00 
 55a:	89 74 24 04          	mov    %esi,0x4(%esp)
 55e:	89 0c 24             	mov    %ecx,(%esp)
 561:	e8 42 fe ff ff       	call   3a8 <write>
 566:	8b 55 cc             	mov    -0x34(%ebp),%edx
 569:	88 55 e7             	mov    %dl,-0x19(%ebp)
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 56f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 572:	31 ff                	xor    %edi,%edi
 574:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 57b:	00 
 57c:	89 74 24 04          	mov    %esi,0x4(%esp)
 580:	89 04 24             	mov    %eax,(%esp)
 583:	e8 20 fe ff ff       	call   3a8 <write>
 588:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 58b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 58f:	84 d2                	test   %dl,%dl
 591:	0f 85 6d ff ff ff    	jne    504 <printf+0x44>
 597:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 598:	83 c4 3c             	add    $0x3c,%esp
 59b:	5b                   	pop    %ebx
 59c:	5e                   	pop    %esi
 59d:	5f                   	pop    %edi
 59e:	5d                   	pop    %ebp
 59f:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5a3:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5ad:	00 
 5ae:	89 74 24 04          	mov    %esi,0x4(%esp)
 5b2:	89 04 24             	mov    %eax,(%esp)
 5b5:	e8 ee fd ff ff       	call   3a8 <write>
 5ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bd:	e9 33 ff ff ff       	jmp    4f5 <printf+0x35>
 5c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5cb:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 5d0:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5d9:	8b 10                	mov    (%eax),%edx
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	e8 4d fe ff ff       	call   430 <printint>
 5e3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5e6:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5ea:	e9 06 ff ff ff       	jmp    4f5 <printf+0x35>
 5ef:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 5f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 5f3:	b9 49 08 00 00       	mov    $0x849,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5f8:	8b 3a                	mov    (%edx),%edi
        ap++;
 5fa:	83 c2 04             	add    $0x4,%edx
 5fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 600:	85 ff                	test   %edi,%edi
 602:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 605:	0f b6 17             	movzbl (%edi),%edx
 608:	84 d2                	test   %dl,%dl
 60a:	74 33                	je     63f <printf+0x17f>
 60c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 60f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 618:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 61b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 625:	00 
 626:	89 74 24 04          	mov    %esi,0x4(%esp)
 62a:	89 1c 24             	mov    %ebx,(%esp)
 62d:	e8 76 fd ff ff       	call   3a8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 632:	0f b6 17             	movzbl (%edi),%edx
 635:	84 d2                	test   %dl,%dl
 637:	75 df                	jne    618 <printf+0x158>
 639:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 63c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 63f:	31 ff                	xor    %edi,%edi
 641:	e9 af fe ff ff       	jmp    4f5 <printf+0x35>
 646:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 648:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 64c:	e9 1b ff ff ff       	jmp    56c <printf+0xac>
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 65b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 660:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 663:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 66a:	8b 10                	mov    (%eax),%edx
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	e8 bc fd ff ff       	call   430 <printint>
 674:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 677:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 67b:	e9 75 fe ff ff       	jmp    4f5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 680:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 683:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 685:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 688:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 68a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 691:	00 
 692:	89 74 24 04          	mov    %esi,0x4(%esp)
 696:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 699:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 69c:	e8 07 fd ff ff       	call   3a8 <write>
 6a1:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 6a4:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6a8:	e9 48 fe ff ff       	jmp    4f5 <printf+0x35>
 6ad:	90                   	nop
 6ae:	90                   	nop
 6af:	90                   	nop

000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b1:	a1 6c 08 00 00       	mov    0x86c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b6:	89 e5                	mov    %esp,%ebp
 6b8:	57                   	push   %edi
 6b9:	56                   	push   %esi
 6ba:	53                   	push   %ebx
 6bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c1:	39 c8                	cmp    %ecx,%eax
 6c3:	73 1d                	jae    6e2 <free+0x32>
 6c5:	8d 76 00             	lea    0x0(%esi),%esi
 6c8:	8b 10                	mov    (%eax),%edx
 6ca:	39 d1                	cmp    %edx,%ecx
 6cc:	72 1a                	jb     6e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ce:	39 d0                	cmp    %edx,%eax
 6d0:	72 08                	jb     6da <free+0x2a>
 6d2:	39 c8                	cmp    %ecx,%eax
 6d4:	72 12                	jb     6e8 <free+0x38>
 6d6:	39 d1                	cmp    %edx,%ecx
 6d8:	72 0e                	jb     6e8 <free+0x38>
 6da:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dc:	39 c8                	cmp    %ecx,%eax
 6de:	66 90                	xchg   %ax,%ax
 6e0:	72 e6                	jb     6c8 <free+0x18>
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	eb e8                	jmp    6ce <free+0x1e>
 6e6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e8:	8b 71 04             	mov    0x4(%ecx),%esi
 6eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ee:	39 d7                	cmp    %edx,%edi
 6f0:	74 19                	je     70b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6f5:	8b 50 04             	mov    0x4(%eax),%edx
 6f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6fb:	39 ce                	cmp    %ecx,%esi
 6fd:	74 23                	je     722 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
 701:	a3 6c 08 00 00       	mov    %eax,0x86c
}
 706:	5b                   	pop    %ebx
 707:	5e                   	pop    %esi
 708:	5f                   	pop    %edi
 709:	5d                   	pop    %ebp
 70a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70b:	03 72 04             	add    0x4(%edx),%esi
 70e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 711:	8b 10                	mov    (%eax),%edx
 713:	8b 12                	mov    (%edx),%edx
 715:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 718:	8b 50 04             	mov    0x4(%eax),%edx
 71b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 71e:	39 ce                	cmp    %ecx,%esi
 720:	75 dd                	jne    6ff <free+0x4f>
    p->s.size += bp->s.size;
 722:	03 51 04             	add    0x4(%ecx),%edx
 725:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 728:	8b 53 f8             	mov    -0x8(%ebx),%edx
 72b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 72d:	a3 6c 08 00 00       	mov    %eax,0x86c
}
 732:	5b                   	pop    %ebx
 733:	5e                   	pop    %esi
 734:	5f                   	pop    %edi
 735:	5d                   	pop    %ebp
 736:	c3                   	ret    
 737:	89 f6                	mov    %esi,%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000740 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	57                   	push   %edi
 744:	56                   	push   %esi
 745:	53                   	push   %ebx
 746:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 749:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 74c:	8b 0d 6c 08 00 00    	mov    0x86c,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 752:	83 c3 07             	add    $0x7,%ebx
 755:	c1 eb 03             	shr    $0x3,%ebx
 758:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 75b:	85 c9                	test   %ecx,%ecx
 75d:	0f 84 9b 00 00 00    	je     7fe <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 763:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 765:	8b 50 04             	mov    0x4(%eax),%edx
 768:	39 d3                	cmp    %edx,%ebx
 76a:	76 27                	jbe    793 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 76c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 773:	be 00 80 00 00       	mov    $0x8000,%esi
 778:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 77b:	90                   	nop
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 780:	3b 05 6c 08 00 00    	cmp    0x86c,%eax
 786:	74 30                	je     7b8 <malloc+0x78>
 788:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 78c:	8b 50 04             	mov    0x4(%eax),%edx
 78f:	39 d3                	cmp    %edx,%ebx
 791:	77 ed                	ja     780 <malloc+0x40>
      if(p->s.size == nunits)
 793:	39 d3                	cmp    %edx,%ebx
 795:	74 61                	je     7f8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 797:	29 da                	sub    %ebx,%edx
 799:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 79c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 79f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7a2:	89 0d 6c 08 00 00    	mov    %ecx,0x86c
      return (void*)(p + 1);
 7a8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ab:	83 c4 2c             	add    $0x2c,%esp
 7ae:	5b                   	pop    %ebx
 7af:	5e                   	pop    %esi
 7b0:	5f                   	pop    %edi
 7b1:	5d                   	pop    %ebp
 7b2:	c3                   	ret    
 7b3:	90                   	nop
 7b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 7b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7bb:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 7c1:	bf 00 10 00 00       	mov    $0x1000,%edi
 7c6:	0f 43 fb             	cmovae %ebx,%edi
 7c9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 7cc:	89 04 24             	mov    %eax,(%esp)
 7cf:	e8 3c fc ff ff       	call   410 <sbrk>
  if(p == (char*)-1)
 7d4:	83 f8 ff             	cmp    $0xffffffff,%eax
 7d7:	74 18                	je     7f1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7d9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 7dc:	83 c0 08             	add    $0x8,%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 c9 fe ff ff       	call   6b0 <free>
  return freep;
 7e7:	8b 0d 6c 08 00 00    	mov    0x86c,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7ed:	85 c9                	test   %ecx,%ecx
 7ef:	75 99                	jne    78a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7f1:	31 c0                	xor    %eax,%eax
 7f3:	eb b6                	jmp    7ab <malloc+0x6b>
 7f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7f8:	8b 10                	mov    (%eax),%edx
 7fa:	89 11                	mov    %edx,(%ecx)
 7fc:	eb a4                	jmp    7a2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7fe:	c7 05 6c 08 00 00 64 	movl   $0x864,0x86c
 805:	08 00 00 
    base.s.size = 0;
 808:	b9 64 08 00 00       	mov    $0x864,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 80d:	c7 05 64 08 00 00 64 	movl   $0x864,0x864
 814:	08 00 00 
    base.s.size = 0;
 817:	c7 05 68 08 00 00 00 	movl   $0x0,0x868
 81e:	00 00 00 
 821:	e9 3d ff ff ff       	jmp    763 <malloc+0x23>
