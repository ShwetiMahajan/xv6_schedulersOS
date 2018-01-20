
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	53                   	push   %ebx
   7:	83 ec 1c             	sub    $0x1c,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  11:	00 
  12:	c7 04 24 d6 07 00 00 	movl   $0x7d6,(%esp)
  19:	e8 5a 03 00 00       	call   378 <open>
  1e:	85 c0                	test   %eax,%eax
  20:	0f 88 af 00 00 00    	js     d5 <main+0xd5>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2d:	e8 7e 03 00 00       	call   3b0 <dup>
  dup(0);  // stderr
  32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  39:	e8 72 03 00 00       	call   3b0 <dup>
  3e:	66 90                	xchg   %ax,%ax

  for(;;){
    printf(1, "init: starting sh\n");
  40:	c7 44 24 04 de 07 00 	movl   $0x7de,0x4(%esp)
  47:	00 
  48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4f:	e8 1c 04 00 00       	call   470 <printf>
    pid = fork();
  54:	e8 d7 02 00 00       	call   330 <fork>
    if(pid < 0){
  59:	83 f8 00             	cmp    $0x0,%eax
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
  5c:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  5e:	7c 28                	jl     88 <main+0x88>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  60:	74 46                	je     a8 <main+0xa8>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  62:	e8 d9 02 00 00       	call   340 <wait>
  67:	85 c0                	test   %eax,%eax
  69:	78 d5                	js     40 <main+0x40>
  6b:	39 c3                	cmp    %eax,%ebx
  6d:	8d 76 00             	lea    0x0(%esi),%esi
  70:	74 ce                	je     40 <main+0x40>
      printf(1, "zombie!\n");
  72:	c7 44 24 04 1d 08 00 	movl   $0x81d,0x4(%esp)
  79:	00 
  7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  81:	e8 ea 03 00 00       	call   470 <printf>
  86:	eb da                	jmp    62 <main+0x62>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  88:	c7 44 24 04 f1 07 00 	movl   $0x7f1,0x4(%esp)
  8f:	00 
  90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  97:	e8 d4 03 00 00       	call   470 <printf>
      exit();
  9c:	e8 97 02 00 00       	call   338 <exit>
  a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    if(pid == 0){
      exec("sh", argv);
  a8:	c7 44 24 04 40 08 00 	movl   $0x840,0x4(%esp)
  af:	00 
  b0:	c7 04 24 04 08 00 00 	movl   $0x804,(%esp)
  b7:	e8 b4 02 00 00       	call   370 <exec>
      printf(1, "init: exec sh failed\n");
  bc:	c7 44 24 04 07 08 00 	movl   $0x807,0x4(%esp)
  c3:	00 
  c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cb:	e8 a0 03 00 00       	call   470 <printf>
      exit();
  d0:	e8 63 02 00 00       	call   338 <exit>
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
  d5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  dc:	00 
  dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 d6 07 00 00 	movl   $0x7d6,(%esp)
  ec:	e8 8f 02 00 00       	call   380 <mknod>
    open("console", O_RDWR);
  f1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  f8:	00 
  f9:	c7 04 24 d6 07 00 00 	movl   $0x7d6,(%esp)
 100:	e8 73 02 00 00       	call   378 <open>
 105:	e9 1c ff ff ff       	jmp    26 <main+0x26>
 10a:	90                   	nop
 10b:	90                   	nop
 10c:	90                   	nop
 10d:	90                   	nop
 10e:	90                   	nop
 10f:	90                   	nop

00000110 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 110:	55                   	push   %ebp
 111:	31 d2                	xor    %edx,%edx
 113:	89 e5                	mov    %esp,%ebp
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	53                   	push   %ebx
 119:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 120:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 124:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 127:	83 c2 01             	add    $0x1,%edx
 12a:	84 c9                	test   %cl,%cl
 12c:	75 f2                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 12e:	5b                   	pop    %ebx
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    
 131:	eb 0d                	jmp    140 <strcmp>
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

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 4d 08             	mov    0x8(%ebp),%ecx
 146:	53                   	push   %ebx
 147:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 14a:	0f b6 01             	movzbl (%ecx),%eax
 14d:	84 c0                	test   %al,%al
 14f:	75 14                	jne    165 <strcmp+0x25>
 151:	eb 25                	jmp    178 <strcmp+0x38>
 153:	90                   	nop
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 158:	83 c1 01             	add    $0x1,%ecx
 15b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15e:	0f b6 01             	movzbl (%ecx),%eax
 161:	84 c0                	test   %al,%al
 163:	74 13                	je     178 <strcmp+0x38>
 165:	0f b6 1a             	movzbl (%edx),%ebx
 168:	38 d8                	cmp    %bl,%al
 16a:	74 ec                	je     158 <strcmp+0x18>
 16c:	0f b6 db             	movzbl %bl,%ebx
 16f:	0f b6 c0             	movzbl %al,%eax
 172:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 174:	5b                   	pop    %ebx
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 178:	0f b6 1a             	movzbl (%edx),%ebx
 17b:	31 c0                	xor    %eax,%eax
 17d:	0f b6 db             	movzbl %bl,%ebx
 180:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 182:	5b                   	pop    %ebx
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
 185:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <strlen>:

uint
strlen(char *s)
{
 190:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 191:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 193:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 195:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 19a:	80 39 00             	cmpb   $0x0,(%ecx)
 19d:	74 0c                	je     1ab <strlen+0x1b>
 19f:	90                   	nop
 1a0:	83 c2 01             	add    $0x1,%edx
 1a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1a7:	89 d0                	mov    %edx,%eax
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
 1ad:	8d 76 00             	lea    0x0(%esi),%esi

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 55 08             	mov    0x8(%ebp),%edx
 1b6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	89 d7                	mov    %edx,%edi
 1bf:	fc                   	cld    
 1c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c2:	89 d0                	mov    %edx,%eax
 1c4:	5f                   	pop    %edi
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	89 f6                	mov    %esi,%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1da:	0f b6 10             	movzbl (%eax),%edx
 1dd:	84 d2                	test   %dl,%dl
 1df:	75 11                	jne    1f2 <strchr+0x22>
 1e1:	eb 15                	jmp    1f8 <strchr+0x28>
 1e3:	90                   	nop
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e8:	83 c0 01             	add    $0x1,%eax
 1eb:	0f b6 10             	movzbl (%eax),%edx
 1ee:	84 d2                	test   %dl,%dl
 1f0:	74 06                	je     1f8 <strchr+0x28>
    if(*s == c)
 1f2:	38 ca                	cmp    %cl,%dl
 1f4:	75 f2                	jne    1e8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1f6:	5d                   	pop    %ebp
 1f7:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f8:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 1fa:	5d                   	pop    %ebp
 1fb:	90                   	nop
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 200:	c3                   	ret    
 201:	eb 0d                	jmp    210 <atoi>
 203:	90                   	nop
 204:	90                   	nop
 205:	90                   	nop
 206:	90                   	nop
 207:	90                   	nop
 208:	90                   	nop
 209:	90                   	nop
 20a:	90                   	nop
 20b:	90                   	nop
 20c:	90                   	nop
 20d:	90                   	nop
 20e:	90                   	nop
 20f:	90                   	nop

00000210 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 211:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 213:	89 e5                	mov    %esp,%ebp
 215:	8b 4d 08             	mov    0x8(%ebp),%ecx
 218:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 219:	0f b6 11             	movzbl (%ecx),%edx
 21c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 21f:	80 fb 09             	cmp    $0x9,%bl
 222:	77 1c                	ja     240 <atoi+0x30>
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 228:	0f be d2             	movsbl %dl,%edx
 22b:	83 c1 01             	add    $0x1,%ecx
 22e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 231:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 235:	0f b6 11             	movzbl (%ecx),%edx
 238:	8d 5a d0             	lea    -0x30(%edx),%ebx
 23b:	80 fb 09             	cmp    $0x9,%bl
 23e:	76 e8                	jbe    228 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 240:	5b                   	pop    %ebx
 241:	5d                   	pop    %ebp
 242:	c3                   	ret    
 243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	56                   	push   %esi
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	53                   	push   %ebx
 258:	8b 5d 10             	mov    0x10(%ebp),%ebx
 25b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25e:	85 db                	test   %ebx,%ebx
 260:	7e 14                	jle    276 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 262:	31 d2                	xor    %edx,%edx
 264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 268:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 26c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 26f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 272:	39 da                	cmp    %ebx,%edx
 274:	75 f2                	jne    268 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 276:	5b                   	pop    %ebx
 277:	5e                   	pop    %esi
 278:	5d                   	pop    %ebp
 279:	c3                   	ret    
 27a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000280 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 286:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 289:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 28c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 28f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 294:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29b:	00 
 29c:	89 04 24             	mov    %eax,(%esp)
 29f:	e8 d4 00 00 00       	call   378 <open>
  if(fd < 0)
 2a4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2a8:	78 19                	js     2c3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 1c 24             	mov    %ebx,(%esp)
 2b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b4:	e8 d7 00 00 00       	call   390 <fstat>
  close(fd);
 2b9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2bc:	89 c6                	mov    %eax,%esi
  close(fd);
 2be:	e8 9d 00 00 00       	call   360 <close>
  return r;
}
 2c3:	89 f0                	mov    %esi,%eax
 2c5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2c8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2cb:	89 ec                	mov    %ebp,%esp
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    
 2cf:	90                   	nop

000002d0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	31 f6                	xor    %esi,%esi
 2d7:	53                   	push   %ebx
 2d8:	83 ec 2c             	sub    $0x2c,%esp
 2db:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2de:	eb 06                	jmp    2e6 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e0:	3c 0a                	cmp    $0xa,%al
 2e2:	74 39                	je     31d <gets+0x4d>
 2e4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e6:	8d 5e 01             	lea    0x1(%esi),%ebx
 2e9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ec:	7d 31                	jge    31f <gets+0x4f>
    cc = read(0, &c, 1);
 2ee:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2f8:	00 
 2f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 304:	e8 47 00 00 00       	call   350 <read>
    if(cc < 1)
 309:	85 c0                	test   %eax,%eax
 30b:	7e 12                	jle    31f <gets+0x4f>
      break;
    buf[i++] = c;
 30d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 311:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 315:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 319:	3c 0d                	cmp    $0xd,%al
 31b:	75 c3                	jne    2e0 <gets+0x10>
 31d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 31f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 323:	89 f8                	mov    %edi,%eax
 325:	83 c4 2c             	add    $0x2c,%esp
 328:	5b                   	pop    %ebx
 329:	5e                   	pop    %esi
 32a:	5f                   	pop    %edi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	90                   	nop
 32e:	90                   	nop
 32f:	90                   	nop

00000330 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 330:	b8 01 00 00 00       	mov    $0x1,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <exit>:
SYSCALL(exit)
 338:	b8 02 00 00 00       	mov    $0x2,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <wait>:
SYSCALL(wait)
 340:	b8 03 00 00 00       	mov    $0x3,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <pipe>:
SYSCALL(pipe)
 348:	b8 04 00 00 00       	mov    $0x4,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <read>:
SYSCALL(read)
 350:	b8 05 00 00 00       	mov    $0x5,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <write>:
SYSCALL(write)
 358:	b8 10 00 00 00       	mov    $0x10,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <close>:
SYSCALL(close)
 360:	b8 15 00 00 00       	mov    $0x15,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <kill>:
SYSCALL(kill)
 368:	b8 06 00 00 00       	mov    $0x6,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <exec>:
SYSCALL(exec)
 370:	b8 07 00 00 00       	mov    $0x7,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <open>:
SYSCALL(open)
 378:	b8 0f 00 00 00       	mov    $0xf,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <mknod>:
SYSCALL(mknod)
 380:	b8 11 00 00 00       	mov    $0x11,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <unlink>:
SYSCALL(unlink)
 388:	b8 12 00 00 00       	mov    $0x12,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <fstat>:
SYSCALL(fstat)
 390:	b8 08 00 00 00       	mov    $0x8,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <link>:
SYSCALL(link)
 398:	b8 13 00 00 00       	mov    $0x13,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <mkdir>:
SYSCALL(mkdir)
 3a0:	b8 14 00 00 00       	mov    $0x14,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <chdir>:
SYSCALL(chdir)
 3a8:	b8 09 00 00 00       	mov    $0x9,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <dup>:
SYSCALL(dup)
 3b0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <getpid>:
SYSCALL(getpid)
 3b8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <sbrk>:
SYSCALL(sbrk)
 3c0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <sleep>:
SYSCALL(sleep)
 3c8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <set_tickets>:
SYSCALL(set_tickets)
 3d0:	b8 16 00 00 00       	mov    $0x16,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    
 3d8:	90                   	nop
 3d9:	90                   	nop
 3da:	90                   	nop
 3db:	90                   	nop
 3dc:	90                   	nop
 3dd:	90                   	nop
 3de:	90                   	nop
 3df:	90                   	nop

000003e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	89 cf                	mov    %ecx,%edi
 3e6:	56                   	push   %esi
 3e7:	89 c6                	mov    %eax,%esi
 3e9:	53                   	push   %ebx
 3ea:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3f0:	85 c9                	test   %ecx,%ecx
 3f2:	74 04                	je     3f8 <printint+0x18>
 3f4:	85 d2                	test   %edx,%edx
 3f6:	78 68                	js     460 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f8:	89 d0                	mov    %edx,%eax
 3fa:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 401:	31 c9                	xor    %ecx,%ecx
 403:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 406:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 408:	31 d2                	xor    %edx,%edx
 40a:	f7 f7                	div    %edi
 40c:	0f b6 92 2d 08 00 00 	movzbl 0x82d(%edx),%edx
 413:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 416:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 419:	85 c0                	test   %eax,%eax
 41b:	75 eb                	jne    408 <printint+0x28>
  if(neg)
 41d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 420:	85 c0                	test   %eax,%eax
 422:	74 08                	je     42c <printint+0x4c>
    buf[i++] = '-';
 424:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 429:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 42c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 42f:	90                   	nop
 430:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 434:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 437:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 43e:	00 
 43f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 442:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 445:	8d 45 e7             	lea    -0x19(%ebp),%eax
 448:	89 44 24 04          	mov    %eax,0x4(%esp)
 44c:	e8 07 ff ff ff       	call   358 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 451:	83 ff ff             	cmp    $0xffffffff,%edi
 454:	75 da                	jne    430 <printint+0x50>
    putc(fd, buf[i]);
}
 456:	83 c4 4c             	add    $0x4c,%esp
 459:	5b                   	pop    %ebx
 45a:	5e                   	pop    %esi
 45b:	5f                   	pop    %edi
 45c:	5d                   	pop    %ebp
 45d:	c3                   	ret    
 45e:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 460:	89 d0                	mov    %edx,%eax
 462:	f7 d8                	neg    %eax
 464:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 46b:	eb 94                	jmp    401 <printint+0x21>
 46d:	8d 76 00             	lea    0x0(%esi),%esi

00000470 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 479:	8b 45 0c             	mov    0xc(%ebp),%eax
 47c:	0f b6 10             	movzbl (%eax),%edx
 47f:	84 d2                	test   %dl,%dl
 481:	0f 84 c1 00 00 00    	je     548 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 487:	8d 4d 10             	lea    0x10(%ebp),%ecx
 48a:	31 ff                	xor    %edi,%edi
 48c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 48f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 491:	8d 75 e7             	lea    -0x19(%ebp),%esi
 494:	eb 1e                	jmp    4b4 <printf+0x44>
 496:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 498:	83 fa 25             	cmp    $0x25,%edx
 49b:	0f 85 af 00 00 00    	jne    550 <printf+0xe0>
 4a1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a5:	83 c3 01             	add    $0x1,%ebx
 4a8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4ac:	84 d2                	test   %dl,%dl
 4ae:	0f 84 94 00 00 00    	je     548 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4b4:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4b6:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 4b9:	74 dd                	je     498 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4bb:	83 ff 25             	cmp    $0x25,%edi
 4be:	75 e5                	jne    4a5 <printf+0x35>
      if(c == 'd'){
 4c0:	83 fa 64             	cmp    $0x64,%edx
 4c3:	0f 84 3f 01 00 00    	je     608 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4c9:	83 fa 70             	cmp    $0x70,%edx
 4cc:	0f 84 a6 00 00 00    	je     578 <printf+0x108>
 4d2:	83 fa 78             	cmp    $0x78,%edx
 4d5:	0f 84 9d 00 00 00    	je     578 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4db:	83 fa 73             	cmp    $0x73,%edx
 4de:	66 90                	xchg   %ax,%ax
 4e0:	0f 84 ba 00 00 00    	je     5a0 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4e6:	83 fa 63             	cmp    $0x63,%edx
 4e9:	0f 84 41 01 00 00    	je     630 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ef:	83 fa 25             	cmp    $0x25,%edx
 4f2:	0f 84 00 01 00 00    	je     5f8 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4fb:	89 55 cc             	mov    %edx,-0x34(%ebp)
 4fe:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 502:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 509:	00 
 50a:	89 74 24 04          	mov    %esi,0x4(%esp)
 50e:	89 0c 24             	mov    %ecx,(%esp)
 511:	e8 42 fe ff ff       	call   358 <write>
 516:	8b 55 cc             	mov    -0x34(%ebp),%edx
 519:	88 55 e7             	mov    %dl,-0x19(%ebp)
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 51f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 522:	31 ff                	xor    %edi,%edi
 524:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 52b:	00 
 52c:	89 74 24 04          	mov    %esi,0x4(%esp)
 530:	89 04 24             	mov    %eax,(%esp)
 533:	e8 20 fe ff ff       	call   358 <write>
 538:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 53b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 53f:	84 d2                	test   %dl,%dl
 541:	0f 85 6d ff ff ff    	jne    4b4 <printf+0x44>
 547:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 548:	83 c4 3c             	add    $0x3c,%esp
 54b:	5b                   	pop    %ebx
 54c:	5e                   	pop    %esi
 54d:	5f                   	pop    %edi
 54e:	5d                   	pop    %ebp
 54f:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 550:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 553:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 556:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 55d:	00 
 55e:	89 74 24 04          	mov    %esi,0x4(%esp)
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 ee fd ff ff       	call   358 <write>
 56a:	8b 45 0c             	mov    0xc(%ebp),%eax
 56d:	e9 33 ff ff ff       	jmp    4a5 <printf+0x35>
 572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 578:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 57b:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 580:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 582:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 589:	8b 10                	mov    (%eax),%edx
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	e8 4d fe ff ff       	call   3e0 <printint>
 593:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 596:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 59a:	e9 06 ff ff ff       	jmp    4a5 <printf+0x35>
 59f:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 5a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 5a3:	b9 26 08 00 00       	mov    $0x826,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5a8:	8b 3a                	mov    (%edx),%edi
        ap++;
 5aa:	83 c2 04             	add    $0x4,%edx
 5ad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 5b0:	85 ff                	test   %edi,%edi
 5b2:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 5b5:	0f b6 17             	movzbl (%edi),%edx
 5b8:	84 d2                	test   %dl,%dl
 5ba:	74 33                	je     5ef <printf+0x17f>
 5bc:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 5c8:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5cb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d5:	00 
 5d6:	89 74 24 04          	mov    %esi,0x4(%esp)
 5da:	89 1c 24             	mov    %ebx,(%esp)
 5dd:	e8 76 fd ff ff       	call   358 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e2:	0f b6 17             	movzbl (%edi),%edx
 5e5:	84 d2                	test   %dl,%dl
 5e7:	75 df                	jne    5c8 <printf+0x158>
 5e9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5ec:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ef:	31 ff                	xor    %edi,%edi
 5f1:	e9 af fe ff ff       	jmp    4a5 <printf+0x35>
 5f6:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5f8:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5fc:	e9 1b ff ff ff       	jmp    51c <printf+0xac>
 601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 60b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 610:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 613:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 61a:	8b 10                	mov    (%eax),%edx
 61c:	8b 45 08             	mov    0x8(%ebp),%eax
 61f:	e8 bc fd ff ff       	call   3e0 <printint>
 624:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 627:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 62b:	e9 75 fe ff ff       	jmp    4a5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 630:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 633:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 635:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 638:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 63a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 641:	00 
 642:	89 74 24 04          	mov    %esi,0x4(%esp)
 646:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 649:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64c:	e8 07 fd ff ff       	call   358 <write>
 651:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 654:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 658:	e9 48 fe ff ff       	jmp    4a5 <printf+0x35>
 65d:	90                   	nop
 65e:	90                   	nop
 65f:	90                   	nop

00000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	a1 50 08 00 00       	mov    0x850,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	89 e5                	mov    %esp,%ebp
 668:	57                   	push   %edi
 669:	56                   	push   %esi
 66a:	53                   	push   %ebx
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	39 c8                	cmp    %ecx,%eax
 673:	73 1d                	jae    692 <free+0x32>
 675:	8d 76 00             	lea    0x0(%esi),%esi
 678:	8b 10                	mov    (%eax),%edx
 67a:	39 d1                	cmp    %edx,%ecx
 67c:	72 1a                	jb     698 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	39 d0                	cmp    %edx,%eax
 680:	72 08                	jb     68a <free+0x2a>
 682:	39 c8                	cmp    %ecx,%eax
 684:	72 12                	jb     698 <free+0x38>
 686:	39 d1                	cmp    %edx,%ecx
 688:	72 0e                	jb     698 <free+0x38>
 68a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68c:	39 c8                	cmp    %ecx,%eax
 68e:	66 90                	xchg   %ax,%ax
 690:	72 e6                	jb     678 <free+0x18>
 692:	8b 10                	mov    (%eax),%edx
 694:	eb e8                	jmp    67e <free+0x1e>
 696:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 698:	8b 71 04             	mov    0x4(%ecx),%esi
 69b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69e:	39 d7                	cmp    %edx,%edi
 6a0:	74 19                	je     6bb <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6a5:	8b 50 04             	mov    0x4(%eax),%edx
 6a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ab:	39 ce                	cmp    %ecx,%esi
 6ad:	74 23                	je     6d2 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6af:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6b1:	a3 50 08 00 00       	mov    %eax,0x850
}
 6b6:	5b                   	pop    %ebx
 6b7:	5e                   	pop    %esi
 6b8:	5f                   	pop    %edi
 6b9:	5d                   	pop    %ebp
 6ba:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6bb:	03 72 04             	add    0x4(%edx),%esi
 6be:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c1:	8b 10                	mov    (%eax),%edx
 6c3:	8b 12                	mov    (%edx),%edx
 6c5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c8:	8b 50 04             	mov    0x4(%eax),%edx
 6cb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ce:	39 ce                	cmp    %ecx,%esi
 6d0:	75 dd                	jne    6af <free+0x4f>
    p->s.size += bp->s.size;
 6d2:	03 51 04             	add    0x4(%ecx),%edx
 6d5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6db:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 6dd:	a3 50 08 00 00       	mov    %eax,0x850
}
 6e2:	5b                   	pop    %ebx
 6e3:	5e                   	pop    %esi
 6e4:	5f                   	pop    %edi
 6e5:	5d                   	pop    %ebp
 6e6:	c3                   	ret    
 6e7:	89 f6                	mov    %esi,%esi
 6e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 6fc:	8b 0d 50 08 00 00    	mov    0x850,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	83 c3 07             	add    $0x7,%ebx
 705:	c1 eb 03             	shr    $0x3,%ebx
 708:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 70b:	85 c9                	test   %ecx,%ecx
 70d:	0f 84 9b 00 00 00    	je     7ae <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 713:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 715:	8b 50 04             	mov    0x4(%eax),%edx
 718:	39 d3                	cmp    %edx,%ebx
 71a:	76 27                	jbe    743 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 71c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 723:	be 00 80 00 00       	mov    $0x8000,%esi
 728:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 72b:	90                   	nop
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 730:	3b 05 50 08 00 00    	cmp    0x850,%eax
 736:	74 30                	je     768 <malloc+0x78>
 738:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 73c:	8b 50 04             	mov    0x4(%eax),%edx
 73f:	39 d3                	cmp    %edx,%ebx
 741:	77 ed                	ja     730 <malloc+0x40>
      if(p->s.size == nunits)
 743:	39 d3                	cmp    %edx,%ebx
 745:	74 61                	je     7a8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 747:	29 da                	sub    %ebx,%edx
 749:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 74c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 74f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 752:	89 0d 50 08 00 00    	mov    %ecx,0x850
      return (void*)(p + 1);
 758:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 75b:	83 c4 2c             	add    $0x2c,%esp
 75e:	5b                   	pop    %ebx
 75f:	5e                   	pop    %esi
 760:	5f                   	pop    %edi
 761:	5d                   	pop    %ebp
 762:	c3                   	ret    
 763:	90                   	nop
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 771:	bf 00 10 00 00       	mov    $0x1000,%edi
 776:	0f 43 fb             	cmovae %ebx,%edi
 779:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 77c:	89 04 24             	mov    %eax,(%esp)
 77f:	e8 3c fc ff ff       	call   3c0 <sbrk>
  if(p == (char*)-1)
 784:	83 f8 ff             	cmp    $0xffffffff,%eax
 787:	74 18                	je     7a1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 789:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 78c:	83 c0 08             	add    $0x8,%eax
 78f:	89 04 24             	mov    %eax,(%esp)
 792:	e8 c9 fe ff ff       	call   660 <free>
  return freep;
 797:	8b 0d 50 08 00 00    	mov    0x850,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 79d:	85 c9                	test   %ecx,%ecx
 79f:	75 99                	jne    73a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7a1:	31 c0                	xor    %eax,%eax
 7a3:	eb b6                	jmp    75b <malloc+0x6b>
 7a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7a8:	8b 10                	mov    (%eax),%edx
 7aa:	89 11                	mov    %edx,(%ecx)
 7ac:	eb a4                	jmp    752 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7ae:	c7 05 50 08 00 00 48 	movl   $0x848,0x850
 7b5:	08 00 00 
    base.s.size = 0;
 7b8:	b9 48 08 00 00       	mov    $0x848,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7bd:	c7 05 48 08 00 00 48 	movl   $0x848,0x848
 7c4:	08 00 00 
    base.s.size = 0;
 7c7:	c7 05 4c 08 00 00 00 	movl   $0x0,0x84c
 7ce:	00 00 00 
 7d1:	e9 3d ff ff ff       	jmp    713 <malloc+0x23>
