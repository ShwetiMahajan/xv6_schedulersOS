
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 10             	sub    $0x10,%esp
   8:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   b:	eb 1f                	jmp    2c <cat+0x2c>
   d:	8d 76 00             	lea    0x0(%esi),%esi
    if (write(1, buf, n) != n) {
  10:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  14:	c7 44 24 04 80 08 00 	movl   $0x880,0x4(%esp)
  1b:	00 
  1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  23:	e8 50 03 00 00       	call   378 <write>
  28:	39 c3                	cmp    %eax,%ebx
  2a:	75 28                	jne    54 <cat+0x54>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  2c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  33:	00 
  34:	c7 44 24 04 80 08 00 	movl   $0x880,0x4(%esp)
  3b:	00 
  3c:	89 34 24             	mov    %esi,(%esp)
  3f:	e8 2c 03 00 00       	call   370 <read>
  44:	83 f8 00             	cmp    $0x0,%eax
  47:	89 c3                	mov    %eax,%ebx
  49:	7f c5                	jg     10 <cat+0x10>
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
  4b:	75 20                	jne    6d <cat+0x6d>
    printf(1, "cat: read error\n");
    exit();
  }
}
  4d:	83 c4 10             	add    $0x10,%esp
  50:	5b                   	pop    %ebx
  51:	5e                   	pop    %esi
  52:	5d                   	pop    %ebp
  53:	c3                   	ret    
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
  54:	c7 44 24 04 f6 07 00 	movl   $0x7f6,0x4(%esp)
  5b:	00 
  5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  63:	e8 28 04 00 00       	call   490 <printf>
      exit();
  68:	e8 eb 02 00 00       	call   358 <exit>
    }
  }
  if(n < 0){
    printf(1, "cat: read error\n");
  6d:	c7 44 24 04 08 08 00 	movl   $0x808,0x4(%esp)
  74:	00 
  75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7c:	e8 0f 04 00 00       	call   490 <printf>
    exit();
  81:	e8 d2 02 00 00       	call   358 <exit>
  86:	8d 76 00             	lea    0x0(%esi),%esi
  89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000090 <main>:
  }
}

int
main(int argc, char *argv[])
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	83 e4 f0             	and    $0xfffffff0,%esp
  96:	57                   	push   %edi
  97:	56                   	push   %esi
  98:	53                   	push   %ebx
  99:	83 ec 24             	sub    $0x24,%esp
  9c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int fd, i;

  if(argc <= 1){
  9f:	83 ff 01             	cmp    $0x1,%edi
  a2:	7e 6c                	jle    110 <main+0x80>
    cat(0);
    exit();
  a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  a7:	be 01 00 00 00       	mov    $0x1,%esi
  ac:	83 c3 04             	add    $0x4,%ebx
  af:	90                   	nop
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b7:	00 
  b8:	8b 03                	mov    (%ebx),%eax
  ba:	89 04 24             	mov    %eax,(%esp)
  bd:	e8 d6 02 00 00       	call   398 <open>
  c2:	85 c0                	test   %eax,%eax
  c4:	78 2a                	js     f0 <main+0x60>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  c6:	89 04 24             	mov    %eax,(%esp)
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  c9:	83 c6 01             	add    $0x1,%esi
  cc:	83 c3 04             	add    $0x4,%ebx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  cf:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  d3:	e8 28 ff ff ff       	call   0 <cat>
    close(fd);
  d8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  dc:	89 04 24             	mov    %eax,(%esp)
  df:	e8 9c 02 00 00       	call   380 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  e4:	39 f7                	cmp    %esi,%edi
  e6:	7f c8                	jg     b0 <main+0x20>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
  e8:	e8 6b 02 00 00       	call   358 <exit>
  ed:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
  f0:	8b 03                	mov    (%ebx),%eax
  f2:	c7 44 24 04 19 08 00 	movl   $0x819,0x4(%esp)
  f9:	00 
  fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 101:	89 44 24 08          	mov    %eax,0x8(%esp)
 105:	e8 86 03 00 00       	call   490 <printf>
      exit();
 10a:	e8 49 02 00 00       	call   358 <exit>
 10f:	90                   	nop
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    cat(0);
 110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 117:	e8 e4 fe ff ff       	call   0 <cat>
    exit();
 11c:	e8 37 02 00 00       	call   358 <exit>
 121:	90                   	nop
 122:	90                   	nop
 123:	90                   	nop
 124:	90                   	nop
 125:	90                   	nop
 126:	90                   	nop
 127:	90                   	nop
 128:	90                   	nop
 129:	90                   	nop
 12a:	90                   	nop
 12b:	90                   	nop
 12c:	90                   	nop
 12d:	90                   	nop
 12e:	90                   	nop
 12f:	90                   	nop

00000130 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 130:	55                   	push   %ebp
 131:	31 d2                	xor    %edx,%edx
 133:	89 e5                	mov    %esp,%ebp
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	53                   	push   %ebx
 139:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 140:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 144:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 147:	83 c2 01             	add    $0x1,%edx
 14a:	84 c9                	test   %cl,%cl
 14c:	75 f2                	jne    140 <strcpy+0x10>
    ;
  return os;
}
 14e:	5b                   	pop    %ebx
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    
 151:	eb 0d                	jmp    160 <strcmp>
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

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
 166:	53                   	push   %ebx
 167:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 16a:	0f b6 01             	movzbl (%ecx),%eax
 16d:	84 c0                	test   %al,%al
 16f:	75 14                	jne    185 <strcmp+0x25>
 171:	eb 25                	jmp    198 <strcmp+0x38>
 173:	90                   	nop
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 178:	83 c1 01             	add    $0x1,%ecx
 17b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17e:	0f b6 01             	movzbl (%ecx),%eax
 181:	84 c0                	test   %al,%al
 183:	74 13                	je     198 <strcmp+0x38>
 185:	0f b6 1a             	movzbl (%edx),%ebx
 188:	38 d8                	cmp    %bl,%al
 18a:	74 ec                	je     178 <strcmp+0x18>
 18c:	0f b6 db             	movzbl %bl,%ebx
 18f:	0f b6 c0             	movzbl %al,%eax
 192:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 194:	5b                   	pop    %ebx
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    
 197:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 198:	0f b6 1a             	movzbl (%edx),%ebx
 19b:	31 c0                	xor    %eax,%eax
 19d:	0f b6 db             	movzbl %bl,%ebx
 1a0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 1a2:	5b                   	pop    %ebx
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    
 1a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <strlen>:

uint
strlen(char *s)
{
 1b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 1b1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1b3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 1b5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ba:	80 39 00             	cmpb   $0x0,(%ecx)
 1bd:	74 0c                	je     1cb <strlen+0x1b>
 1bf:	90                   	nop
 1c0:	83 c2 01             	add    $0x1,%edx
 1c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1c7:	89 d0                	mov    %edx,%eax
 1c9:	75 f5                	jne    1c0 <strlen+0x10>
    ;
  return n;
}
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    
 1cd:	8d 76 00             	lea    0x0(%esi),%esi

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 55 08             	mov    0x8(%ebp),%edx
 1d6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	89 d7                	mov    %edx,%edi
 1df:	fc                   	cld    
 1e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1e2:	89 d0                	mov    %edx,%eax
 1e4:	5f                   	pop    %edi
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    
 1e7:	89 f6                	mov    %esi,%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1fa:	0f b6 10             	movzbl (%eax),%edx
 1fd:	84 d2                	test   %dl,%dl
 1ff:	75 11                	jne    212 <strchr+0x22>
 201:	eb 15                	jmp    218 <strchr+0x28>
 203:	90                   	nop
 204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 208:	83 c0 01             	add    $0x1,%eax
 20b:	0f b6 10             	movzbl (%eax),%edx
 20e:	84 d2                	test   %dl,%dl
 210:	74 06                	je     218 <strchr+0x28>
    if(*s == c)
 212:	38 ca                	cmp    %cl,%dl
 214:	75 f2                	jne    208 <strchr+0x18>
      return (char*)s;
  return 0;
}
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 218:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 21a:	5d                   	pop    %ebp
 21b:	90                   	nop
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 220:	c3                   	ret    
 221:	eb 0d                	jmp    230 <atoi>
 223:	90                   	nop
 224:	90                   	nop
 225:	90                   	nop
 226:	90                   	nop
 227:	90                   	nop
 228:	90                   	nop
 229:	90                   	nop
 22a:	90                   	nop
 22b:	90                   	nop
 22c:	90                   	nop
 22d:	90                   	nop
 22e:	90                   	nop
 22f:	90                   	nop

00000230 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 231:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 233:	89 e5                	mov    %esp,%ebp
 235:	8b 4d 08             	mov    0x8(%ebp),%ecx
 238:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 239:	0f b6 11             	movzbl (%ecx),%edx
 23c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 23f:	80 fb 09             	cmp    $0x9,%bl
 242:	77 1c                	ja     260 <atoi+0x30>
 244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 248:	0f be d2             	movsbl %dl,%edx
 24b:	83 c1 01             	add    $0x1,%ecx
 24e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 251:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 255:	0f b6 11             	movzbl (%ecx),%edx
 258:	8d 5a d0             	lea    -0x30(%edx),%ebx
 25b:	80 fb 09             	cmp    $0x9,%bl
 25e:	76 e8                	jbe    248 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	53                   	push   %ebx
 278:	8b 5d 10             	mov    0x10(%ebp),%ebx
 27b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 db                	test   %ebx,%ebx
 280:	7e 14                	jle    296 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 282:	31 d2                	xor    %edx,%edx
 284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 288:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 28c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 28f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 292:	39 da                	cmp    %ebx,%edx
 294:	75 f2                	jne    288 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 296:	5b                   	pop    %ebx
 297:	5e                   	pop    %esi
 298:	5d                   	pop    %ebp
 299:	c3                   	ret    
 29a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002a0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2a9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2ac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 2af:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2bb:	00 
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 d4 00 00 00       	call   398 <open>
  if(fd < 0)
 2c4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2c8:	78 19                	js     2e3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	89 1c 24             	mov    %ebx,(%esp)
 2d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d4:	e8 d7 00 00 00       	call   3b0 <fstat>
  close(fd);
 2d9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2dc:	89 c6                	mov    %eax,%esi
  close(fd);
 2de:	e8 9d 00 00 00       	call   380 <close>
  return r;
}
 2e3:	89 f0                	mov    %esi,%eax
 2e5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2e8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2eb:	89 ec                	mov    %ebp,%esp
 2ed:	5d                   	pop    %ebp
 2ee:	c3                   	ret    
 2ef:	90                   	nop

000002f0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	31 f6                	xor    %esi,%esi
 2f7:	53                   	push   %ebx
 2f8:	83 ec 2c             	sub    $0x2c,%esp
 2fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fe:	eb 06                	jmp    306 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 300:	3c 0a                	cmp    $0xa,%al
 302:	74 39                	je     33d <gets+0x4d>
 304:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 306:	8d 5e 01             	lea    0x1(%esi),%ebx
 309:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 30c:	7d 31                	jge    33f <gets+0x4f>
    cc = read(0, &c, 1);
 30e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 311:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 318:	00 
 319:	89 44 24 04          	mov    %eax,0x4(%esp)
 31d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 324:	e8 47 00 00 00       	call   370 <read>
    if(cc < 1)
 329:	85 c0                	test   %eax,%eax
 32b:	7e 12                	jle    33f <gets+0x4f>
      break;
    buf[i++] = c;
 32d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 331:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 335:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 339:	3c 0d                	cmp    $0xd,%al
 33b:	75 c3                	jne    300 <gets+0x10>
 33d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 33f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 343:	89 f8                	mov    %edi,%eax
 345:	83 c4 2c             	add    $0x2c,%esp
 348:	5b                   	pop    %ebx
 349:	5e                   	pop    %esi
 34a:	5f                   	pop    %edi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    
 34d:	90                   	nop
 34e:	90                   	nop
 34f:	90                   	nop

00000350 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <exit>:
SYSCALL(exit)
 358:	b8 02 00 00 00       	mov    $0x2,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <wait>:
SYSCALL(wait)
 360:	b8 03 00 00 00       	mov    $0x3,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <pipe>:
SYSCALL(pipe)
 368:	b8 04 00 00 00       	mov    $0x4,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <read>:
SYSCALL(read)
 370:	b8 05 00 00 00       	mov    $0x5,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <write>:
SYSCALL(write)
 378:	b8 10 00 00 00       	mov    $0x10,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <close>:
SYSCALL(close)
 380:	b8 15 00 00 00       	mov    $0x15,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <kill>:
SYSCALL(kill)
 388:	b8 06 00 00 00       	mov    $0x6,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <exec>:
SYSCALL(exec)
 390:	b8 07 00 00 00       	mov    $0x7,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <open>:
SYSCALL(open)
 398:	b8 0f 00 00 00       	mov    $0xf,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <mknod>:
SYSCALL(mknod)
 3a0:	b8 11 00 00 00       	mov    $0x11,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <unlink>:
SYSCALL(unlink)
 3a8:	b8 12 00 00 00       	mov    $0x12,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <fstat>:
SYSCALL(fstat)
 3b0:	b8 08 00 00 00       	mov    $0x8,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <link>:
SYSCALL(link)
 3b8:	b8 13 00 00 00       	mov    $0x13,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mkdir>:
SYSCALL(mkdir)
 3c0:	b8 14 00 00 00       	mov    $0x14,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <chdir>:
SYSCALL(chdir)
 3c8:	b8 09 00 00 00       	mov    $0x9,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <dup>:
SYSCALL(dup)
 3d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <getpid>:
SYSCALL(getpid)
 3d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <sbrk>:
SYSCALL(sbrk)
 3e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <sleep>:
SYSCALL(sleep)
 3e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <set_tickets>:
SYSCALL(set_tickets)
 3f0:	b8 16 00 00 00       	mov    $0x16,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    
 3f8:	90                   	nop
 3f9:	90                   	nop
 3fa:	90                   	nop
 3fb:	90                   	nop
 3fc:	90                   	nop
 3fd:	90                   	nop
 3fe:	90                   	nop
 3ff:	90                   	nop

00000400 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	89 cf                	mov    %ecx,%edi
 406:	56                   	push   %esi
 407:	89 c6                	mov    %eax,%esi
 409:	53                   	push   %ebx
 40a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 410:	85 c9                	test   %ecx,%ecx
 412:	74 04                	je     418 <printint+0x18>
 414:	85 d2                	test   %edx,%edx
 416:	78 68                	js     480 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 418:	89 d0                	mov    %edx,%eax
 41a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 421:	31 c9                	xor    %ecx,%ecx
 423:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 426:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 428:	31 d2                	xor    %edx,%edx
 42a:	f7 f7                	div    %edi
 42c:	0f b6 92 35 08 00 00 	movzbl 0x835(%edx),%edx
 433:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 436:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 439:	85 c0                	test   %eax,%eax
 43b:	75 eb                	jne    428 <printint+0x28>
  if(neg)
 43d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 440:	85 c0                	test   %eax,%eax
 442:	74 08                	je     44c <printint+0x4c>
    buf[i++] = '-';
 444:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 449:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 44c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 44f:	90                   	nop
 450:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 454:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 457:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 45e:	00 
 45f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 462:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 465:	8d 45 e7             	lea    -0x19(%ebp),%eax
 468:	89 44 24 04          	mov    %eax,0x4(%esp)
 46c:	e8 07 ff ff ff       	call   378 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 471:	83 ff ff             	cmp    $0xffffffff,%edi
 474:	75 da                	jne    450 <printint+0x50>
    putc(fd, buf[i]);
}
 476:	83 c4 4c             	add    $0x4c,%esp
 479:	5b                   	pop    %ebx
 47a:	5e                   	pop    %esi
 47b:	5f                   	pop    %edi
 47c:	5d                   	pop    %ebp
 47d:	c3                   	ret    
 47e:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 480:	89 d0                	mov    %edx,%eax
 482:	f7 d8                	neg    %eax
 484:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 48b:	eb 94                	jmp    421 <printint+0x21>
 48d:	8d 76 00             	lea    0x0(%esi),%esi

00000490 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
 496:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 499:	8b 45 0c             	mov    0xc(%ebp),%eax
 49c:	0f b6 10             	movzbl (%eax),%edx
 49f:	84 d2                	test   %dl,%dl
 4a1:	0f 84 c1 00 00 00    	je     568 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4a7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4aa:	31 ff                	xor    %edi,%edi
 4ac:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 4af:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 4b4:	eb 1e                	jmp    4d4 <printf+0x44>
 4b6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4b8:	83 fa 25             	cmp    $0x25,%edx
 4bb:	0f 85 af 00 00 00    	jne    570 <printf+0xe0>
 4c1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c5:	83 c3 01             	add    $0x1,%ebx
 4c8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4cc:	84 d2                	test   %dl,%dl
 4ce:	0f 84 94 00 00 00    	je     568 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4d4:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4d6:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 4d9:	74 dd                	je     4b8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4db:	83 ff 25             	cmp    $0x25,%edi
 4de:	75 e5                	jne    4c5 <printf+0x35>
      if(c == 'd'){
 4e0:	83 fa 64             	cmp    $0x64,%edx
 4e3:	0f 84 3f 01 00 00    	je     628 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e9:	83 fa 70             	cmp    $0x70,%edx
 4ec:	0f 84 a6 00 00 00    	je     598 <printf+0x108>
 4f2:	83 fa 78             	cmp    $0x78,%edx
 4f5:	0f 84 9d 00 00 00    	je     598 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4fb:	83 fa 73             	cmp    $0x73,%edx
 4fe:	66 90                	xchg   %ax,%ax
 500:	0f 84 ba 00 00 00    	je     5c0 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 506:	83 fa 63             	cmp    $0x63,%edx
 509:	0f 84 41 01 00 00    	je     650 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 50f:	83 fa 25             	cmp    $0x25,%edx
 512:	0f 84 00 01 00 00    	je     618 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 518:	8b 4d 08             	mov    0x8(%ebp),%ecx
 51b:	89 55 cc             	mov    %edx,-0x34(%ebp)
 51e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 522:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 529:	00 
 52a:	89 74 24 04          	mov    %esi,0x4(%esp)
 52e:	89 0c 24             	mov    %ecx,(%esp)
 531:	e8 42 fe ff ff       	call   378 <write>
 536:	8b 55 cc             	mov    -0x34(%ebp),%edx
 539:	88 55 e7             	mov    %dl,-0x19(%ebp)
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 53f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 542:	31 ff                	xor    %edi,%edi
 544:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 54b:	00 
 54c:	89 74 24 04          	mov    %esi,0x4(%esp)
 550:	89 04 24             	mov    %eax,(%esp)
 553:	e8 20 fe ff ff       	call   378 <write>
 558:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 55b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 55f:	84 d2                	test   %dl,%dl
 561:	0f 85 6d ff ff ff    	jne    4d4 <printf+0x44>
 567:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 568:	83 c4 3c             	add    $0x3c,%esp
 56b:	5b                   	pop    %ebx
 56c:	5e                   	pop    %esi
 56d:	5f                   	pop    %edi
 56e:	5d                   	pop    %ebp
 56f:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 570:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 573:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 576:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 57d:	00 
 57e:	89 74 24 04          	mov    %esi,0x4(%esp)
 582:	89 04 24             	mov    %eax,(%esp)
 585:	e8 ee fd ff ff       	call   378 <write>
 58a:	8b 45 0c             	mov    0xc(%ebp),%eax
 58d:	e9 33 ff ff ff       	jmp    4c5 <printf+0x35>
 592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 598:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 59b:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 5a0:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5a9:	8b 10                	mov    (%eax),%edx
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	e8 4d fe ff ff       	call   400 <printint>
 5b3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5b6:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5ba:	e9 06 ff ff ff       	jmp    4c5 <printf+0x35>
 5bf:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 5c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 5c3:	b9 2e 08 00 00       	mov    $0x82e,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5c8:	8b 3a                	mov    (%edx),%edi
        ap++;
 5ca:	83 c2 04             	add    $0x4,%edx
 5cd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 5d0:	85 ff                	test   %edi,%edi
 5d2:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 5d5:	0f b6 17             	movzbl (%edi),%edx
 5d8:	84 d2                	test   %dl,%dl
 5da:	74 33                	je     60f <printf+0x17f>
 5dc:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5df:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 5e8:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5eb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f5:	00 
 5f6:	89 74 24 04          	mov    %esi,0x4(%esp)
 5fa:	89 1c 24             	mov    %ebx,(%esp)
 5fd:	e8 76 fd ff ff       	call   378 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 602:	0f b6 17             	movzbl (%edi),%edx
 605:	84 d2                	test   %dl,%dl
 607:	75 df                	jne    5e8 <printf+0x158>
 609:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 60c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 60f:	31 ff                	xor    %edi,%edi
 611:	e9 af fe ff ff       	jmp    4c5 <printf+0x35>
 616:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 618:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 61c:	e9 1b ff ff ff       	jmp    53c <printf+0xac>
 621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 628:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 62b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 630:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 633:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 63a:	8b 10                	mov    (%eax),%edx
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	e8 bc fd ff ff       	call   400 <printint>
 644:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 647:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 64b:	e9 75 fe ff ff       	jmp    4c5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 650:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 653:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 655:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 658:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 65a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 661:	00 
 662:	89 74 24 04          	mov    %esi,0x4(%esp)
 666:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 669:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 66c:	e8 07 fd ff ff       	call   378 <write>
 671:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 674:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 678:	e9 48 fe ff ff       	jmp    4c5 <printf+0x35>
 67d:	90                   	nop
 67e:	90                   	nop
 67f:	90                   	nop

00000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	a1 68 08 00 00       	mov    0x868,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 686:	89 e5                	mov    %esp,%ebp
 688:	57                   	push   %edi
 689:	56                   	push   %esi
 68a:	53                   	push   %ebx
 68b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	39 c8                	cmp    %ecx,%eax
 693:	73 1d                	jae    6b2 <free+0x32>
 695:	8d 76 00             	lea    0x0(%esi),%esi
 698:	8b 10                	mov    (%eax),%edx
 69a:	39 d1                	cmp    %edx,%ecx
 69c:	72 1a                	jb     6b8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69e:	39 d0                	cmp    %edx,%eax
 6a0:	72 08                	jb     6aa <free+0x2a>
 6a2:	39 c8                	cmp    %ecx,%eax
 6a4:	72 12                	jb     6b8 <free+0x38>
 6a6:	39 d1                	cmp    %edx,%ecx
 6a8:	72 0e                	jb     6b8 <free+0x38>
 6aa:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ac:	39 c8                	cmp    %ecx,%eax
 6ae:	66 90                	xchg   %ax,%ax
 6b0:	72 e6                	jb     698 <free+0x18>
 6b2:	8b 10                	mov    (%eax),%edx
 6b4:	eb e8                	jmp    69e <free+0x1e>
 6b6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b8:	8b 71 04             	mov    0x4(%ecx),%esi
 6bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6be:	39 d7                	cmp    %edx,%edi
 6c0:	74 19                	je     6db <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6c2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6c5:	8b 50 04             	mov    0x4(%eax),%edx
 6c8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6cb:	39 ce                	cmp    %ecx,%esi
 6cd:	74 23                	je     6f2 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6cf:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6d1:	a3 68 08 00 00       	mov    %eax,0x868
}
 6d6:	5b                   	pop    %ebx
 6d7:	5e                   	pop    %esi
 6d8:	5f                   	pop    %edi
 6d9:	5d                   	pop    %ebp
 6da:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6db:	03 72 04             	add    0x4(%edx),%esi
 6de:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e1:	8b 10                	mov    (%eax),%edx
 6e3:	8b 12                	mov    (%edx),%edx
 6e5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6e8:	8b 50 04             	mov    0x4(%eax),%edx
 6eb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ee:	39 ce                	cmp    %ecx,%esi
 6f0:	75 dd                	jne    6cf <free+0x4f>
    p->s.size += bp->s.size;
 6f2:	03 51 04             	add    0x4(%ecx),%edx
 6f5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6fb:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 6fd:	a3 68 08 00 00       	mov    %eax,0x868
}
 702:	5b                   	pop    %ebx
 703:	5e                   	pop    %esi
 704:	5f                   	pop    %edi
 705:	5d                   	pop    %ebp
 706:	c3                   	ret    
 707:	89 f6                	mov    %esi,%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000710 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 719:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 71c:	8b 0d 68 08 00 00    	mov    0x868,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 722:	83 c3 07             	add    $0x7,%ebx
 725:	c1 eb 03             	shr    $0x3,%ebx
 728:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 72b:	85 c9                	test   %ecx,%ecx
 72d:	0f 84 9b 00 00 00    	je     7ce <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 733:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 735:	8b 50 04             	mov    0x4(%eax),%edx
 738:	39 d3                	cmp    %edx,%ebx
 73a:	76 27                	jbe    763 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 73c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 743:	be 00 80 00 00       	mov    $0x8000,%esi
 748:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 74b:	90                   	nop
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 750:	3b 05 68 08 00 00    	cmp    0x868,%eax
 756:	74 30                	je     788 <malloc+0x78>
 758:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 75c:	8b 50 04             	mov    0x4(%eax),%edx
 75f:	39 d3                	cmp    %edx,%ebx
 761:	77 ed                	ja     750 <malloc+0x40>
      if(p->s.size == nunits)
 763:	39 d3                	cmp    %edx,%ebx
 765:	74 61                	je     7c8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 767:	29 da                	sub    %ebx,%edx
 769:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 76c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 76f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 772:	89 0d 68 08 00 00    	mov    %ecx,0x868
      return (void*)(p + 1);
 778:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 77b:	83 c4 2c             	add    $0x2c,%esp
 77e:	5b                   	pop    %ebx
 77f:	5e                   	pop    %esi
 780:	5f                   	pop    %edi
 781:	5d                   	pop    %ebp
 782:	c3                   	ret    
 783:	90                   	nop
 784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 791:	bf 00 10 00 00       	mov    $0x1000,%edi
 796:	0f 43 fb             	cmovae %ebx,%edi
 799:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 79c:	89 04 24             	mov    %eax,(%esp)
 79f:	e8 3c fc ff ff       	call   3e0 <sbrk>
  if(p == (char*)-1)
 7a4:	83 f8 ff             	cmp    $0xffffffff,%eax
 7a7:	74 18                	je     7c1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7a9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 7ac:	83 c0 08             	add    $0x8,%eax
 7af:	89 04 24             	mov    %eax,(%esp)
 7b2:	e8 c9 fe ff ff       	call   680 <free>
  return freep;
 7b7:	8b 0d 68 08 00 00    	mov    0x868,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7bd:	85 c9                	test   %ecx,%ecx
 7bf:	75 99                	jne    75a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7c1:	31 c0                	xor    %eax,%eax
 7c3:	eb b6                	jmp    77b <malloc+0x6b>
 7c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7c8:	8b 10                	mov    (%eax),%edx
 7ca:	89 11                	mov    %edx,(%ecx)
 7cc:	eb a4                	jmp    772 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7ce:	c7 05 68 08 00 00 60 	movl   $0x860,0x868
 7d5:	08 00 00 
    base.s.size = 0;
 7d8:	b9 60 08 00 00       	mov    $0x860,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7dd:	c7 05 60 08 00 00 60 	movl   $0x860,0x860
 7e4:	08 00 00 
    base.s.size = 0;
 7e7:	c7 05 64 08 00 00 00 	movl   $0x0,0x864
 7ee:	00 00 00 
 7f1:	e9 3d ff ff ff       	jmp    733 <malloc+0x23>
