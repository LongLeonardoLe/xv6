
_chown:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char* argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  11:	89 c8                	mov    %ecx,%eax
    char *uidIn = argv[1];
  13:	8b 50 04             	mov    0x4(%eax),%edx
  16:	8b 52 04             	mov    0x4(%edx),%edx
  19:	89 55 f4             	mov    %edx,-0xc(%ebp)
    char *path = argv[2];
  1c:	8b 40 04             	mov    0x4(%eax),%eax
  1f:	8b 40 08             	mov    0x8(%eax),%eax
  22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int uid = atoi(uidIn);
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	ff 75 f4             	pushl  -0xc(%ebp)
  2b:	e8 18 02 00 00       	call   248 <atoi>
  30:	83 c4 10             	add    $0x10,%esp
  33:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(uidIn[0] == '-') {
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	0f b6 00             	movzbl (%eax),%eax
  3c:	3c 2d                	cmp    $0x2d,%al
  3e:	75 17                	jne    57 <main+0x57>
        printf(2, "Invalid UID\n");
  40:	83 ec 08             	sub    $0x8,%esp
  43:	68 f5 08 00 00       	push   $0x8f5
  48:	6a 02                	push   $0x2
  4a:	e8 f0 04 00 00       	call   53f <printf>
  4f:	83 c4 10             	add    $0x10,%esp
        exit();
  52:	e8 11 03 00 00       	call   368 <exit>
    }
    if(chown(path, uid) < 0)
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	ff 75 ec             	pushl  -0x14(%ebp)
  5d:	ff 75 f0             	pushl  -0x10(%ebp)
  60:	e8 f3 03 00 00       	call   458 <chown>
  65:	83 c4 10             	add    $0x10,%esp
  68:	85 c0                	test   %eax,%eax
  6a:	79 12                	jns    7e <main+0x7e>
        printf(2, "Error: exec chown failure\n");
  6c:	83 ec 08             	sub    $0x8,%esp
  6f:	68 02 09 00 00       	push   $0x902
  74:	6a 02                	push   $0x2
  76:	e8 c4 04 00 00       	call   53f <printf>
  7b:	83 c4 10             	add    $0x10,%esp
    exit();
  7e:	e8 e5 02 00 00       	call   368 <exit>

00000083 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  83:	55                   	push   %ebp
  84:	89 e5                	mov    %esp,%ebp
  86:	57                   	push   %edi
  87:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8b:	8b 55 10             	mov    0x10(%ebp),%edx
  8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  91:	89 cb                	mov    %ecx,%ebx
  93:	89 df                	mov    %ebx,%edi
  95:	89 d1                	mov    %edx,%ecx
  97:	fc                   	cld    
  98:	f3 aa                	rep stos %al,%es:(%edi)
  9a:	89 ca                	mov    %ecx,%edx
  9c:	89 fb                	mov    %edi,%ebx
  9e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a4:	90                   	nop
  a5:	5b                   	pop    %ebx
  a6:	5f                   	pop    %edi
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b5:	90                   	nop
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	8d 50 01             	lea    0x1(%eax),%edx
  bc:	89 55 08             	mov    %edx,0x8(%ebp)
  bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  c2:	8d 4a 01             	lea    0x1(%edx),%ecx
  c5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  c8:	0f b6 12             	movzbl (%edx),%edx
  cb:	88 10                	mov    %dl,(%eax)
  cd:	0f b6 00             	movzbl (%eax),%eax
  d0:	84 c0                	test   %al,%al
  d2:	75 e2                	jne    b6 <strcpy+0xd>
    ;
  return os;
  d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d7:	c9                   	leave  
  d8:	c3                   	ret    

000000d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  dc:	eb 08                	jmp    e6 <strcmp+0xd>
    p++, q++;
  de:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
  e9:	0f b6 00             	movzbl (%eax),%eax
  ec:	84 c0                	test   %al,%al
  ee:	74 10                	je     100 <strcmp+0x27>
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	0f b6 10             	movzbl (%eax),%edx
  f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  f9:	0f b6 00             	movzbl (%eax),%eax
  fc:	38 c2                	cmp    %al,%dl
  fe:	74 de                	je     de <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 00             	movzbl (%eax),%eax
 106:	0f b6 d0             	movzbl %al,%edx
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	0f b6 00             	movzbl (%eax),%eax
 10f:	0f b6 c0             	movzbl %al,%eax
 112:	29 c2                	sub    %eax,%edx
 114:	89 d0                	mov    %edx,%eax
}
 116:	5d                   	pop    %ebp
 117:	c3                   	ret    

00000118 <strlen>:

uint
strlen(char *s)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 125:	eb 04                	jmp    12b <strlen+0x13>
 127:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	01 d0                	add    %edx,%eax
 133:	0f b6 00             	movzbl (%eax),%eax
 136:	84 c0                	test   %al,%al
 138:	75 ed                	jne    127 <strlen+0xf>
    ;
  return n;
 13a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13d:	c9                   	leave  
 13e:	c3                   	ret    

0000013f <memset>:

void*
memset(void *dst, int c, uint n)
{
 13f:	55                   	push   %ebp
 140:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 142:	8b 45 10             	mov    0x10(%ebp),%eax
 145:	50                   	push   %eax
 146:	ff 75 0c             	pushl  0xc(%ebp)
 149:	ff 75 08             	pushl  0x8(%ebp)
 14c:	e8 32 ff ff ff       	call   83 <stosb>
 151:	83 c4 0c             	add    $0xc,%esp
  return dst;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
}
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <strchr>:

char*
strchr(const char *s, char c)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	83 ec 04             	sub    $0x4,%esp
 15f:	8b 45 0c             	mov    0xc(%ebp),%eax
 162:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 165:	eb 14                	jmp    17b <strchr+0x22>
    if(*s == c)
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	0f b6 00             	movzbl (%eax),%eax
 16d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 170:	75 05                	jne    177 <strchr+0x1e>
      return (char*)s;
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	eb 13                	jmp    18a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	84 c0                	test   %al,%al
 183:	75 e2                	jne    167 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 185:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18a:	c9                   	leave  
 18b:	c3                   	ret    

0000018c <gets>:

char*
gets(char *buf, int max)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 192:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 199:	eb 42                	jmp    1dd <gets+0x51>
    cc = read(0, &c, 1);
 19b:	83 ec 04             	sub    $0x4,%esp
 19e:	6a 01                	push   $0x1
 1a0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a3:	50                   	push   %eax
 1a4:	6a 00                	push   $0x0
 1a6:	e8 d5 01 00 00       	call   380 <read>
 1ab:	83 c4 10             	add    $0x10,%esp
 1ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b5:	7e 33                	jle    1ea <gets+0x5e>
      break;
    buf[i++] = c;
 1b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ba:	8d 50 01             	lea    0x1(%eax),%edx
 1bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c0:	89 c2                	mov    %eax,%edx
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	01 c2                	add    %eax,%edx
 1c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d1:	3c 0a                	cmp    $0xa,%al
 1d3:	74 16                	je     1eb <gets+0x5f>
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	3c 0d                	cmp    $0xd,%al
 1db:	74 0e                	je     1eb <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e0:	83 c0 01             	add    $0x1,%eax
 1e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e6:	7c b3                	jl     19b <gets+0xf>
 1e8:	eb 01                	jmp    1eb <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ea:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	01 d0                	add    %edx,%eax
 1f3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <stat>:

int
stat(char *n, struct stat *st)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 201:	83 ec 08             	sub    $0x8,%esp
 204:	6a 00                	push   $0x0
 206:	ff 75 08             	pushl  0x8(%ebp)
 209:	e8 9a 01 00 00       	call   3a8 <open>
 20e:	83 c4 10             	add    $0x10,%esp
 211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 218:	79 07                	jns    221 <stat+0x26>
    return -1;
 21a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21f:	eb 25                	jmp    246 <stat+0x4b>
  r = fstat(fd, st);
 221:	83 ec 08             	sub    $0x8,%esp
 224:	ff 75 0c             	pushl  0xc(%ebp)
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 91 01 00 00       	call   3c0 <fstat>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 235:	83 ec 0c             	sub    $0xc,%esp
 238:	ff 75 f4             	pushl  -0xc(%ebp)
 23b:	e8 50 01 00 00       	call   390 <close>
 240:	83 c4 10             	add    $0x10,%esp
  return r;
 243:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 246:	c9                   	leave  
 247:	c3                   	ret    

00000248 <atoi>:

int
atoi(const char *s)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 24e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 255:	eb 25                	jmp    27c <atoi+0x34>
    n = n*10 + *s++ - '0';
 257:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25a:	89 d0                	mov    %edx,%eax
 25c:	c1 e0 02             	shl    $0x2,%eax
 25f:	01 d0                	add    %edx,%eax
 261:	01 c0                	add    %eax,%eax
 263:	89 c1                	mov    %eax,%ecx
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	8d 50 01             	lea    0x1(%eax),%edx
 26b:	89 55 08             	mov    %edx,0x8(%ebp)
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	0f be c0             	movsbl %al,%eax
 274:	01 c8                	add    %ecx,%eax
 276:	83 e8 30             	sub    $0x30,%eax
 279:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 2f                	cmp    $0x2f,%al
 284:	7e 0a                	jle    290 <atoi+0x48>
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	3c 39                	cmp    $0x39,%al
 28e:	7e c7                	jle    257 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 290:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 293:	c9                   	leave  
 294:	c3                   	ret    

00000295 <atoo>:

int
atoo(const char *s)
{
 295:	55                   	push   %ebp
 296:	89 e5                	mov    %esp,%ebp
 298:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
 29b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
 2a2:	eb 04                	jmp    2a8 <atoo+0x13>
        s++;
 2a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3c 20                	cmp    $0x20,%al
 2b0:	74 f2                	je     2a4 <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	3c 2d                	cmp    $0x2d,%al
 2ba:	75 07                	jne    2c3 <atoo+0x2e>
 2bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c1:	eb 05                	jmp    2c8 <atoo+0x33>
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	3c 2b                	cmp    $0x2b,%al
 2d3:	74 0a                	je     2df <atoo+0x4a>
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	3c 2d                	cmp    $0x2d,%al
 2dd:	75 27                	jne    306 <atoo+0x71>
        s++;
 2df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
 2e3:	eb 21                	jmp    306 <atoo+0x71>
        n = n*8 + *s++ - '0';
 2e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	8d 50 01             	lea    0x1(%eax),%edx
 2f5:	89 55 08             	mov    %edx,0x8(%ebp)
 2f8:	0f b6 00             	movzbl (%eax),%eax
 2fb:	0f be c0             	movsbl %al,%eax
 2fe:	01 c8                	add    %ecx,%eax
 300:	83 e8 30             	sub    $0x30,%eax
 303:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	0f b6 00             	movzbl (%eax),%eax
 30c:	3c 2f                	cmp    $0x2f,%al
 30e:	7e 0a                	jle    31a <atoo+0x85>
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	0f b6 00             	movzbl (%eax),%eax
 316:	3c 37                	cmp    $0x37,%al
 318:	7e cb                	jle    2e5 <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
 31a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 31d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 321:	c9                   	leave  
 322:	c3                   	ret    

00000323 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 323:	55                   	push   %ebp
 324:	89 e5                	mov    %esp,%ebp
 326:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32f:	8b 45 0c             	mov    0xc(%ebp),%eax
 332:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 335:	eb 17                	jmp    34e <memmove+0x2b>
    *dst++ = *src++;
 337:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33a:	8d 50 01             	lea    0x1(%eax),%edx
 33d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 340:	8b 55 f8             	mov    -0x8(%ebp),%edx
 343:	8d 4a 01             	lea    0x1(%edx),%ecx
 346:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 349:	0f b6 12             	movzbl (%edx),%edx
 34c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34e:	8b 45 10             	mov    0x10(%ebp),%eax
 351:	8d 50 ff             	lea    -0x1(%eax),%edx
 354:	89 55 10             	mov    %edx,0x10(%ebp)
 357:	85 c0                	test   %eax,%eax
 359:	7f dc                	jg     337 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 360:	b8 01 00 00 00       	mov    $0x1,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <exit>:
SYSCALL(exit)
 368:	b8 02 00 00 00       	mov    $0x2,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <wait>:
SYSCALL(wait)
 370:	b8 03 00 00 00       	mov    $0x3,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <pipe>:
SYSCALL(pipe)
 378:	b8 04 00 00 00       	mov    $0x4,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <read>:
SYSCALL(read)
 380:	b8 05 00 00 00       	mov    $0x5,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <write>:
SYSCALL(write)
 388:	b8 10 00 00 00       	mov    $0x10,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <close>:
SYSCALL(close)
 390:	b8 15 00 00 00       	mov    $0x15,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <kill>:
SYSCALL(kill)
 398:	b8 06 00 00 00       	mov    $0x6,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <exec>:
SYSCALL(exec)
 3a0:	b8 07 00 00 00       	mov    $0x7,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <open>:
SYSCALL(open)
 3a8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <mknod>:
SYSCALL(mknod)
 3b0:	b8 11 00 00 00       	mov    $0x11,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <unlink>:
SYSCALL(unlink)
 3b8:	b8 12 00 00 00       	mov    $0x12,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <fstat>:
SYSCALL(fstat)
 3c0:	b8 08 00 00 00       	mov    $0x8,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <link>:
SYSCALL(link)
 3c8:	b8 13 00 00 00       	mov    $0x13,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mkdir>:
SYSCALL(mkdir)
 3d0:	b8 14 00 00 00       	mov    $0x14,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <chdir>:
SYSCALL(chdir)
 3d8:	b8 09 00 00 00       	mov    $0x9,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <dup>:
SYSCALL(dup)
 3e0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <getpid>:
SYSCALL(getpid)
 3e8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <sbrk>:
SYSCALL(sbrk)
 3f0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <sleep>:
SYSCALL(sleep)
 3f8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <uptime>:
SYSCALL(uptime)
 400:	b8 0e 00 00 00       	mov    $0xe,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <halt>:
SYSCALL(halt)
 408:	b8 16 00 00 00       	mov    $0x16,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <date>:
SYSCALL(date)
 410:	b8 17 00 00 00       	mov    $0x17,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <getuid>:
SYSCALL(getuid)
 418:	b8 18 00 00 00       	mov    $0x18,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <getgid>:
SYSCALL(getgid)
 420:	b8 19 00 00 00       	mov    $0x19,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <getppid>:
SYSCALL(getppid)
 428:	b8 1a 00 00 00       	mov    $0x1a,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <setuid>:
SYSCALL(setuid)
 430:	b8 1b 00 00 00       	mov    $0x1b,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <setgid>:
SYSCALL(setgid)
 438:	b8 1c 00 00 00       	mov    $0x1c,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <getprocs>:
SYSCALL(getprocs)
 440:	b8 1d 00 00 00       	mov    $0x1d,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <setpriority>:
SYSCALL(setpriority)
 448:	b8 1e 00 00 00       	mov    $0x1e,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <chmod>:
SYSCALL(chmod)
 450:	b8 1f 00 00 00       	mov    $0x1f,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <chown>:
SYSCALL(chown)
 458:	b8 20 00 00 00       	mov    $0x20,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <chgrp>:
SYSCALL(chgrp)
 460:	b8 21 00 00 00       	mov    $0x21,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 468:	55                   	push   %ebp
 469:	89 e5                	mov    %esp,%ebp
 46b:	83 ec 18             	sub    $0x18,%esp
 46e:	8b 45 0c             	mov    0xc(%ebp),%eax
 471:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 474:	83 ec 04             	sub    $0x4,%esp
 477:	6a 01                	push   $0x1
 479:	8d 45 f4             	lea    -0xc(%ebp),%eax
 47c:	50                   	push   %eax
 47d:	ff 75 08             	pushl  0x8(%ebp)
 480:	e8 03 ff ff ff       	call   388 <write>
 485:	83 c4 10             	add    $0x10,%esp
}
 488:	90                   	nop
 489:	c9                   	leave  
 48a:	c3                   	ret    

0000048b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48b:	55                   	push   %ebp
 48c:	89 e5                	mov    %esp,%ebp
 48e:	53                   	push   %ebx
 48f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 492:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 499:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 49d:	74 17                	je     4b6 <printint+0x2b>
 49f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a3:	79 11                	jns    4b6 <printint+0x2b>
    neg = 1;
 4a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 4af:	f7 d8                	neg    %eax
 4b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b4:	eb 06                	jmp    4bc <printint+0x31>
  } else {
    x = xx;
 4b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4c6:	8d 41 01             	lea    0x1(%ecx),%eax
 4c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d2:	ba 00 00 00 00       	mov    $0x0,%edx
 4d7:	f7 f3                	div    %ebx
 4d9:	89 d0                	mov    %edx,%eax
 4db:	0f b6 80 8c 0b 00 00 	movzbl 0xb8c(%eax),%eax
 4e2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ec:	ba 00 00 00 00       	mov    $0x0,%edx
 4f1:	f7 f3                	div    %ebx
 4f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fa:	75 c7                	jne    4c3 <printint+0x38>
  if(neg)
 4fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 500:	74 2d                	je     52f <printint+0xa4>
    buf[i++] = '-';
 502:	8b 45 f4             	mov    -0xc(%ebp),%eax
 505:	8d 50 01             	lea    0x1(%eax),%edx
 508:	89 55 f4             	mov    %edx,-0xc(%ebp)
 50b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 510:	eb 1d                	jmp    52f <printint+0xa4>
    putc(fd, buf[i]);
 512:	8d 55 dc             	lea    -0x24(%ebp),%edx
 515:	8b 45 f4             	mov    -0xc(%ebp),%eax
 518:	01 d0                	add    %edx,%eax
 51a:	0f b6 00             	movzbl (%eax),%eax
 51d:	0f be c0             	movsbl %al,%eax
 520:	83 ec 08             	sub    $0x8,%esp
 523:	50                   	push   %eax
 524:	ff 75 08             	pushl  0x8(%ebp)
 527:	e8 3c ff ff ff       	call   468 <putc>
 52c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 52f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 537:	79 d9                	jns    512 <printint+0x87>
    putc(fd, buf[i]);
}
 539:	90                   	nop
 53a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 53d:	c9                   	leave  
 53e:	c3                   	ret    

0000053f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 53f:	55                   	push   %ebp
 540:	89 e5                	mov    %esp,%ebp
 542:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 545:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 54c:	8d 45 0c             	lea    0xc(%ebp),%eax
 54f:	83 c0 04             	add    $0x4,%eax
 552:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 555:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 55c:	e9 59 01 00 00       	jmp    6ba <printf+0x17b>
    c = fmt[i] & 0xff;
 561:	8b 55 0c             	mov    0xc(%ebp),%edx
 564:	8b 45 f0             	mov    -0x10(%ebp),%eax
 567:	01 d0                	add    %edx,%eax
 569:	0f b6 00             	movzbl (%eax),%eax
 56c:	0f be c0             	movsbl %al,%eax
 56f:	25 ff 00 00 00       	and    $0xff,%eax
 574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 577:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57b:	75 2c                	jne    5a9 <printf+0x6a>
      if(c == '%'){
 57d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 581:	75 0c                	jne    58f <printf+0x50>
        state = '%';
 583:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 58a:	e9 27 01 00 00       	jmp    6b6 <printf+0x177>
      } else {
        putc(fd, c);
 58f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 592:	0f be c0             	movsbl %al,%eax
 595:	83 ec 08             	sub    $0x8,%esp
 598:	50                   	push   %eax
 599:	ff 75 08             	pushl  0x8(%ebp)
 59c:	e8 c7 fe ff ff       	call   468 <putc>
 5a1:	83 c4 10             	add    $0x10,%esp
 5a4:	e9 0d 01 00 00       	jmp    6b6 <printf+0x177>
      }
    } else if(state == '%'){
 5a9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ad:	0f 85 03 01 00 00    	jne    6b6 <printf+0x177>
      if(c == 'd'){
 5b3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b7:	75 1e                	jne    5d7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bc:	8b 00                	mov    (%eax),%eax
 5be:	6a 01                	push   $0x1
 5c0:	6a 0a                	push   $0xa
 5c2:	50                   	push   %eax
 5c3:	ff 75 08             	pushl  0x8(%ebp)
 5c6:	e8 c0 fe ff ff       	call   48b <printint>
 5cb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	e9 d8 00 00 00       	jmp    6af <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5d7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5db:	74 06                	je     5e3 <printf+0xa4>
 5dd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e1:	75 1e                	jne    601 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e6:	8b 00                	mov    (%eax),%eax
 5e8:	6a 00                	push   $0x0
 5ea:	6a 10                	push   $0x10
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 96 fe ff ff       	call   48b <printint>
 5f5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fc:	e9 ae 00 00 00       	jmp    6af <printf+0x170>
      } else if(c == 's'){
 601:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 605:	75 43                	jne    64a <printf+0x10b>
        s = (char*)*ap;
 607:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 617:	75 25                	jne    63e <printf+0xff>
          s = "(null)";
 619:	c7 45 f4 1d 09 00 00 	movl   $0x91d,-0xc(%ebp)
        while(*s != 0){
 620:	eb 1c                	jmp    63e <printf+0xff>
          putc(fd, *s);
 622:	8b 45 f4             	mov    -0xc(%ebp),%eax
 625:	0f b6 00             	movzbl (%eax),%eax
 628:	0f be c0             	movsbl %al,%eax
 62b:	83 ec 08             	sub    $0x8,%esp
 62e:	50                   	push   %eax
 62f:	ff 75 08             	pushl  0x8(%ebp)
 632:	e8 31 fe ff ff       	call   468 <putc>
 637:	83 c4 10             	add    $0x10,%esp
          s++;
 63a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 63e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 641:	0f b6 00             	movzbl (%eax),%eax
 644:	84 c0                	test   %al,%al
 646:	75 da                	jne    622 <printf+0xe3>
 648:	eb 65                	jmp    6af <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64e:	75 1d                	jne    66d <printf+0x12e>
        putc(fd, *ap);
 650:	8b 45 e8             	mov    -0x18(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	0f be c0             	movsbl %al,%eax
 658:	83 ec 08             	sub    $0x8,%esp
 65b:	50                   	push   %eax
 65c:	ff 75 08             	pushl  0x8(%ebp)
 65f:	e8 04 fe ff ff       	call   468 <putc>
 664:	83 c4 10             	add    $0x10,%esp
        ap++;
 667:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66b:	eb 42                	jmp    6af <printf+0x170>
      } else if(c == '%'){
 66d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 671:	75 17                	jne    68a <printf+0x14b>
        putc(fd, c);
 673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 676:	0f be c0             	movsbl %al,%eax
 679:	83 ec 08             	sub    $0x8,%esp
 67c:	50                   	push   %eax
 67d:	ff 75 08             	pushl  0x8(%ebp)
 680:	e8 e3 fd ff ff       	call   468 <putc>
 685:	83 c4 10             	add    $0x10,%esp
 688:	eb 25                	jmp    6af <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 68a:	83 ec 08             	sub    $0x8,%esp
 68d:	6a 25                	push   $0x25
 68f:	ff 75 08             	pushl  0x8(%ebp)
 692:	e8 d1 fd ff ff       	call   468 <putc>
 697:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 69a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69d:	0f be c0             	movsbl %al,%eax
 6a0:	83 ec 08             	sub    $0x8,%esp
 6a3:	50                   	push   %eax
 6a4:	ff 75 08             	pushl  0x8(%ebp)
 6a7:	e8 bc fd ff ff       	call   468 <putc>
 6ac:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 6bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c0:	01 d0                	add    %edx,%eax
 6c2:	0f b6 00             	movzbl (%eax),%eax
 6c5:	84 c0                	test   %al,%al
 6c7:	0f 85 94 fe ff ff    	jne    561 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6cd:	90                   	nop
 6ce:	c9                   	leave  
 6cf:	c3                   	ret    

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	83 e8 08             	sub    $0x8,%eax
 6dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6df:	a1 a8 0b 00 00       	mov    0xba8,%eax
 6e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e7:	eb 24                	jmp    70d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f1:	77 12                	ja     705 <free+0x35>
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f9:	77 24                	ja     71f <free+0x4f>
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 703:	77 1a                	ja     71f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 713:	76 d4                	jbe    6e9 <free+0x19>
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71d:	76 ca                	jbe    6e9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	01 c2                	add    %eax,%edx
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	39 c2                	cmp    %eax,%edx
 738:	75 24                	jne    75e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	8b 50 04             	mov    0x4(%eax),%edx
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 00                	mov    (%eax),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	01 c2                	add    %eax,%edx
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	8b 10                	mov    (%eax),%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	89 10                	mov    %edx,(%eax)
 75c:	eb 0a                	jmp    768 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	01 d0                	add    %edx,%eax
 77a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77d:	75 20                	jne    79f <free+0xcf>
    p->s.size += bp->s.size;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 50 04             	mov    0x4(%eax),%edx
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	01 c2                	add    %eax,%edx
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 08                	jmp    7a7 <free+0xd7>
  } else
    p->s.ptr = bp;
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a5:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	a3 a8 0b 00 00       	mov    %eax,0xba8
}
 7af:	90                   	nop
 7b0:	c9                   	leave  
 7b1:	c3                   	ret    

000007b2 <morecore>:

static Header*
morecore(uint nu)
{
 7b2:	55                   	push   %ebp
 7b3:	89 e5                	mov    %esp,%ebp
 7b5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7bf:	77 07                	ja     7c8 <morecore+0x16>
    nu = 4096;
 7c1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c8:	8b 45 08             	mov    0x8(%ebp),%eax
 7cb:	c1 e0 03             	shl    $0x3,%eax
 7ce:	83 ec 0c             	sub    $0xc,%esp
 7d1:	50                   	push   %eax
 7d2:	e8 19 fc ff ff       	call   3f0 <sbrk>
 7d7:	83 c4 10             	add    $0x10,%esp
 7da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7dd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e1:	75 07                	jne    7ea <morecore+0x38>
    return 0;
 7e3:	b8 00 00 00 00       	mov    $0x0,%eax
 7e8:	eb 26                	jmp    810 <morecore+0x5e>
  hp = (Header*)p;
 7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	8b 55 08             	mov    0x8(%ebp),%edx
 7f6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	83 c0 08             	add    $0x8,%eax
 7ff:	83 ec 0c             	sub    $0xc,%esp
 802:	50                   	push   %eax
 803:	e8 c8 fe ff ff       	call   6d0 <free>
 808:	83 c4 10             	add    $0x10,%esp
  return freep;
 80b:	a1 a8 0b 00 00       	mov    0xba8,%eax
}
 810:	c9                   	leave  
 811:	c3                   	ret    

00000812 <malloc>:

void*
malloc(uint nbytes)
{
 812:	55                   	push   %ebp
 813:	89 e5                	mov    %esp,%ebp
 815:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 818:	8b 45 08             	mov    0x8(%ebp),%eax
 81b:	83 c0 07             	add    $0x7,%eax
 81e:	c1 e8 03             	shr    $0x3,%eax
 821:	83 c0 01             	add    $0x1,%eax
 824:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 827:	a1 a8 0b 00 00       	mov    0xba8,%eax
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 833:	75 23                	jne    858 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 835:	c7 45 f0 a0 0b 00 00 	movl   $0xba0,-0x10(%ebp)
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	a3 a8 0b 00 00       	mov    %eax,0xba8
 844:	a1 a8 0b 00 00       	mov    0xba8,%eax
 849:	a3 a0 0b 00 00       	mov    %eax,0xba0
    base.s.size = 0;
 84e:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 855:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85b:	8b 00                	mov    (%eax),%eax
 85d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8b 40 04             	mov    0x4(%eax),%eax
 866:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 869:	72 4d                	jb     8b8 <malloc+0xa6>
      if(p->s.size == nunits)
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 40 04             	mov    0x4(%eax),%eax
 871:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 874:	75 0c                	jne    882 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	8b 10                	mov    (%eax),%edx
 87b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87e:	89 10                	mov    %edx,(%eax)
 880:	eb 26                	jmp    8a8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	8b 40 04             	mov    0x4(%eax),%eax
 888:	2b 45 ec             	sub    -0x14(%ebp),%eax
 88b:	89 c2                	mov    %eax,%edx
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	8b 40 04             	mov    0x4(%eax),%eax
 899:	c1 e0 03             	shl    $0x3,%eax
 89c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ab:	a3 a8 0b 00 00       	mov    %eax,0xba8
      return (void*)(p + 1);
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	83 c0 08             	add    $0x8,%eax
 8b6:	eb 3b                	jmp    8f3 <malloc+0xe1>
    }
    if(p == freep)
 8b8:	a1 a8 0b 00 00       	mov    0xba8,%eax
 8bd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c0:	75 1e                	jne    8e0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8c2:	83 ec 0c             	sub    $0xc,%esp
 8c5:	ff 75 ec             	pushl  -0x14(%ebp)
 8c8:	e8 e5 fe ff ff       	call   7b2 <morecore>
 8cd:	83 c4 10             	add    $0x10,%esp
 8d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d7:	75 07                	jne    8e0 <malloc+0xce>
        return 0;
 8d9:	b8 00 00 00 00       	mov    $0x0,%eax
 8de:	eb 13                	jmp    8f3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	8b 00                	mov    (%eax),%eax
 8eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ee:	e9 6d ff ff ff       	jmp    860 <malloc+0x4e>
}
 8f3:	c9                   	leave  
 8f4:	c3                   	ret    
