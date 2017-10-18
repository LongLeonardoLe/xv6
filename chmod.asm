
_chmod:     file format elf32-i386


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
    char *modeIn = argv[1];
  13:	8b 50 04             	mov    0x4(%eax),%edx
  16:	8b 52 04             	mov    0x4(%edx),%edx
  19:	89 55 f0             	mov    %edx,-0x10(%ebp)
    char *path = argv[2];
  1c:	8b 40 04             	mov    0x4(%eax),%eax
  1f:	8b 40 08             	mov    0x8(%eax),%eax
  22:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(strlen(modeIn) > 4)
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	ff 75 f0             	pushl  -0x10(%ebp)
  2b:	e8 45 01 00 00       	call   175 <strlen>
  30:	83 c4 10             	add    $0x10,%esp
  33:	83 f8 04             	cmp    $0x4,%eax
  36:	76 12                	jbe    4a <main+0x4a>
        printf(2, "Error: invalid MODE\n");
  38:	83 ec 08             	sub    $0x8,%esp
  3b:	68 52 09 00 00       	push   $0x952
  40:	6a 02                	push   $0x2
  42:	e8 55 05 00 00       	call   59c <printf>
  47:	83 c4 10             	add    $0x10,%esp
    for(int i = 0; i < strlen(modeIn); i++) {
  4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  51:	eb 39                	jmp    8c <main+0x8c>
        if(modeIn[i] < '0' || modeIn[i] > '7') {
  53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	01 d0                	add    %edx,%eax
  5b:	0f b6 00             	movzbl (%eax),%eax
  5e:	3c 2f                	cmp    $0x2f,%al
  60:	7e 0f                	jle    71 <main+0x71>
  62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  68:	01 d0                	add    %edx,%eax
  6a:	0f b6 00             	movzbl (%eax),%eax
  6d:	3c 37                	cmp    $0x37,%al
  6f:	7e 17                	jle    88 <main+0x88>
            printf(2, "Error: invalid MODE\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 52 09 00 00       	push   $0x952
  79:	6a 02                	push   $0x2
  7b:	e8 1c 05 00 00       	call   59c <printf>
  80:	83 c4 10             	add    $0x10,%esp
            exit();
  83:	e8 3d 03 00 00       	call   3c5 <exit>
{
    char *modeIn = argv[1];
    char *path = argv[2];
    if(strlen(modeIn) > 4)
        printf(2, "Error: invalid MODE\n");
    for(int i = 0; i < strlen(modeIn); i++) {
  88:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f0             	pushl  -0x10(%ebp)
  92:	e8 de 00 00 00       	call   175 <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	89 c2                	mov    %eax,%edx
  9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9f:	39 c2                	cmp    %eax,%edx
  a1:	77 b0                	ja     53 <main+0x53>
        if(modeIn[i] < '0' || modeIn[i] > '7') {
            printf(2, "Error: invalid MODE\n");
            exit();
        }
    }
    int mode = atoo(modeIn);
  a3:	83 ec 0c             	sub    $0xc,%esp
  a6:	ff 75 f0             	pushl  -0x10(%ebp)
  a9:	e8 44 02 00 00       	call   2f2 <atoo>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(chmod(path, mode) < 0)
  b4:	83 ec 08             	sub    $0x8,%esp
  b7:	ff 75 e8             	pushl  -0x18(%ebp)
  ba:	ff 75 ec             	pushl  -0x14(%ebp)
  bd:	e8 eb 03 00 00       	call   4ad <chmod>
  c2:	83 c4 10             	add    $0x10,%esp
  c5:	85 c0                	test   %eax,%eax
  c7:	79 12                	jns    db <main+0xdb>
        printf(2, "Error: exec chmod failure\n");
  c9:	83 ec 08             	sub    $0x8,%esp
  cc:	68 67 09 00 00       	push   $0x967
  d1:	6a 02                	push   $0x2
  d3:	e8 c4 04 00 00       	call   59c <printf>
  d8:	83 c4 10             	add    $0x10,%esp
    exit();
  db:	e8 e5 02 00 00       	call   3c5 <exit>

000000e0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e8:	8b 55 10             	mov    0x10(%ebp),%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	89 cb                	mov    %ecx,%ebx
  f0:	89 df                	mov    %ebx,%edi
  f2:	89 d1                	mov    %edx,%ecx
  f4:	fc                   	cld    
  f5:	f3 aa                	rep stos %al,%es:(%edi)
  f7:	89 ca                	mov    %ecx,%edx
  f9:	89 fb                	mov    %edi,%ebx
  fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
  fe:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 101:	90                   	nop
 102:	5b                   	pop    %ebx
 103:	5f                   	pop    %edi
 104:	5d                   	pop    %ebp
 105:	c3                   	ret    

00000106 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 112:	90                   	nop
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	8d 50 01             	lea    0x1(%eax),%edx
 119:	89 55 08             	mov    %edx,0x8(%ebp)
 11c:	8b 55 0c             	mov    0xc(%ebp),%edx
 11f:	8d 4a 01             	lea    0x1(%edx),%ecx
 122:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 125:	0f b6 12             	movzbl (%edx),%edx
 128:	88 10                	mov    %dl,(%eax)
 12a:	0f b6 00             	movzbl (%eax),%eax
 12d:	84 c0                	test   %al,%al
 12f:	75 e2                	jne    113 <strcpy+0xd>
    ;
  return os;
 131:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 134:	c9                   	leave  
 135:	c3                   	ret    

00000136 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 139:	eb 08                	jmp    143 <strcmp+0xd>
    p++, q++;
 13b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	84 c0                	test   %al,%al
 14b:	74 10                	je     15d <strcmp+0x27>
 14d:	8b 45 08             	mov    0x8(%ebp),%eax
 150:	0f b6 10             	movzbl (%eax),%edx
 153:	8b 45 0c             	mov    0xc(%ebp),%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	38 c2                	cmp    %al,%dl
 15b:	74 de                	je     13b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	0f b6 d0             	movzbl %al,%edx
 166:	8b 45 0c             	mov    0xc(%ebp),%eax
 169:	0f b6 00             	movzbl (%eax),%eax
 16c:	0f b6 c0             	movzbl %al,%eax
 16f:	29 c2                	sub    %eax,%edx
 171:	89 d0                	mov    %edx,%eax
}
 173:	5d                   	pop    %ebp
 174:	c3                   	ret    

00000175 <strlen>:

uint
strlen(char *s)
{
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 17b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 182:	eb 04                	jmp    188 <strlen+0x13>
 184:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 188:	8b 55 fc             	mov    -0x4(%ebp),%edx
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	01 d0                	add    %edx,%eax
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	84 c0                	test   %al,%al
 195:	75 ed                	jne    184 <strlen+0xf>
    ;
  return n;
 197:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19a:	c9                   	leave  
 19b:	c3                   	ret    

0000019c <memset>:

void*
memset(void *dst, int c, uint n)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 19f:	8b 45 10             	mov    0x10(%ebp),%eax
 1a2:	50                   	push   %eax
 1a3:	ff 75 0c             	pushl  0xc(%ebp)
 1a6:	ff 75 08             	pushl  0x8(%ebp)
 1a9:	e8 32 ff ff ff       	call   e0 <stosb>
 1ae:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b4:	c9                   	leave  
 1b5:	c3                   	ret    

000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	83 ec 04             	sub    $0x4,%esp
 1bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bf:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1c2:	eb 14                	jmp    1d8 <strchr+0x22>
    if(*s == c)
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	0f b6 00             	movzbl (%eax),%eax
 1ca:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1cd:	75 05                	jne    1d4 <strchr+0x1e>
      return (char*)s;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	eb 13                	jmp    1e7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	84 c0                	test   %al,%al
 1e0:	75 e2                	jne    1c4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <gets>:

char*
gets(char *buf, int max)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1f6:	eb 42                	jmp    23a <gets+0x51>
    cc = read(0, &c, 1);
 1f8:	83 ec 04             	sub    $0x4,%esp
 1fb:	6a 01                	push   $0x1
 1fd:	8d 45 ef             	lea    -0x11(%ebp),%eax
 200:	50                   	push   %eax
 201:	6a 00                	push   $0x0
 203:	e8 d5 01 00 00       	call   3dd <read>
 208:	83 c4 10             	add    $0x10,%esp
 20b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 20e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 212:	7e 33                	jle    247 <gets+0x5e>
      break;
    buf[i++] = c;
 214:	8b 45 f4             	mov    -0xc(%ebp),%eax
 217:	8d 50 01             	lea    0x1(%eax),%edx
 21a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 21d:	89 c2                	mov    %eax,%edx
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	01 c2                	add    %eax,%edx
 224:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 228:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 22a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22e:	3c 0a                	cmp    $0xa,%al
 230:	74 16                	je     248 <gets+0x5f>
 232:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 236:	3c 0d                	cmp    $0xd,%al
 238:	74 0e                	je     248 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23d:	83 c0 01             	add    $0x1,%eax
 240:	3b 45 0c             	cmp    0xc(%ebp),%eax
 243:	7c b3                	jl     1f8 <gets+0xf>
 245:	eb 01                	jmp    248 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 247:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 248:	8b 55 f4             	mov    -0xc(%ebp),%edx
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	01 d0                	add    %edx,%eax
 250:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 253:	8b 45 08             	mov    0x8(%ebp),%eax
}
 256:	c9                   	leave  
 257:	c3                   	ret    

00000258 <stat>:

int
stat(char *n, struct stat *st)
{
 258:	55                   	push   %ebp
 259:	89 e5                	mov    %esp,%ebp
 25b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	83 ec 08             	sub    $0x8,%esp
 261:	6a 00                	push   $0x0
 263:	ff 75 08             	pushl  0x8(%ebp)
 266:	e8 9a 01 00 00       	call   405 <open>
 26b:	83 c4 10             	add    $0x10,%esp
 26e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 275:	79 07                	jns    27e <stat+0x26>
    return -1;
 277:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 27c:	eb 25                	jmp    2a3 <stat+0x4b>
  r = fstat(fd, st);
 27e:	83 ec 08             	sub    $0x8,%esp
 281:	ff 75 0c             	pushl  0xc(%ebp)
 284:	ff 75 f4             	pushl  -0xc(%ebp)
 287:	e8 91 01 00 00       	call   41d <fstat>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 292:	83 ec 0c             	sub    $0xc,%esp
 295:	ff 75 f4             	pushl  -0xc(%ebp)
 298:	e8 50 01 00 00       	call   3ed <close>
 29d:	83 c4 10             	add    $0x10,%esp
  return r;
 2a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2a3:	c9                   	leave  
 2a4:	c3                   	ret    

000002a5 <atoi>:

int
atoi(const char *s)
{
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2b2:	eb 25                	jmp    2d9 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b7:	89 d0                	mov    %edx,%eax
 2b9:	c1 e0 02             	shl    $0x2,%eax
 2bc:	01 d0                	add    %edx,%eax
 2be:	01 c0                	add    %eax,%eax
 2c0:	89 c1                	mov    %eax,%ecx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8d 50 01             	lea    0x1(%eax),%edx
 2c8:	89 55 08             	mov    %edx,0x8(%ebp)
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	0f be c0             	movsbl %al,%eax
 2d1:	01 c8                	add    %ecx,%eax
 2d3:	83 e8 30             	sub    $0x30,%eax
 2d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 2f                	cmp    $0x2f,%al
 2e1:	7e 0a                	jle    2ed <atoi+0x48>
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 39                	cmp    $0x39,%al
 2eb:	7e c7                	jle    2b4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f0:	c9                   	leave  
 2f1:	c3                   	ret    

000002f2 <atoo>:

int
atoo(const char *s)
{
 2f2:	55                   	push   %ebp
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
 2f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
 2ff:	eb 04                	jmp    305 <atoo+0x13>
        s++;
 301:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	0f b6 00             	movzbl (%eax),%eax
 30b:	3c 20                	cmp    $0x20,%al
 30d:	74 f2                	je     301 <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	0f b6 00             	movzbl (%eax),%eax
 315:	3c 2d                	cmp    $0x2d,%al
 317:	75 07                	jne    320 <atoo+0x2e>
 319:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31e:	eb 05                	jmp    325 <atoo+0x33>
 320:	b8 01 00 00 00       	mov    $0x1,%eax
 325:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	3c 2b                	cmp    $0x2b,%al
 330:	74 0a                	je     33c <atoo+0x4a>
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	0f b6 00             	movzbl (%eax),%eax
 338:	3c 2d                	cmp    $0x2d,%al
 33a:	75 27                	jne    363 <atoo+0x71>
        s++;
 33c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
 340:	eb 21                	jmp    363 <atoo+0x71>
        n = n*8 + *s++ - '0';
 342:	8b 45 fc             	mov    -0x4(%ebp),%eax
 345:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	8d 50 01             	lea    0x1(%eax),%edx
 352:	89 55 08             	mov    %edx,0x8(%ebp)
 355:	0f b6 00             	movzbl (%eax),%eax
 358:	0f be c0             	movsbl %al,%eax
 35b:	01 c8                	add    %ecx,%eax
 35d:	83 e8 30             	sub    $0x30,%eax
 360:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	0f b6 00             	movzbl (%eax),%eax
 369:	3c 2f                	cmp    $0x2f,%al
 36b:	7e 0a                	jle    377 <atoo+0x85>
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	0f b6 00             	movzbl (%eax),%eax
 373:	3c 37                	cmp    $0x37,%al
 375:	7e cb                	jle    342 <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
 377:	8b 45 f8             	mov    -0x8(%ebp),%eax
 37a:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 38c:	8b 45 0c             	mov    0xc(%ebp),%eax
 38f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 392:	eb 17                	jmp    3ab <memmove+0x2b>
    *dst++ = *src++;
 394:	8b 45 fc             	mov    -0x4(%ebp),%eax
 397:	8d 50 01             	lea    0x1(%eax),%edx
 39a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 39d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3a0:	8d 4a 01             	lea    0x1(%edx),%ecx
 3a3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3a6:	0f b6 12             	movzbl (%edx),%edx
 3a9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ab:	8b 45 10             	mov    0x10(%ebp),%eax
 3ae:	8d 50 ff             	lea    -0x1(%eax),%edx
 3b1:	89 55 10             	mov    %edx,0x10(%ebp)
 3b4:	85 c0                	test   %eax,%eax
 3b6:	7f dc                	jg     394 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3bb:	c9                   	leave  
 3bc:	c3                   	ret    

000003bd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3bd:	b8 01 00 00 00       	mov    $0x1,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <exit>:
SYSCALL(exit)
 3c5:	b8 02 00 00 00       	mov    $0x2,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <wait>:
SYSCALL(wait)
 3cd:	b8 03 00 00 00       	mov    $0x3,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <pipe>:
SYSCALL(pipe)
 3d5:	b8 04 00 00 00       	mov    $0x4,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <read>:
SYSCALL(read)
 3dd:	b8 05 00 00 00       	mov    $0x5,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <write>:
SYSCALL(write)
 3e5:	b8 10 00 00 00       	mov    $0x10,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <close>:
SYSCALL(close)
 3ed:	b8 15 00 00 00       	mov    $0x15,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <kill>:
SYSCALL(kill)
 3f5:	b8 06 00 00 00       	mov    $0x6,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <exec>:
SYSCALL(exec)
 3fd:	b8 07 00 00 00       	mov    $0x7,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <open>:
SYSCALL(open)
 405:	b8 0f 00 00 00       	mov    $0xf,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <mknod>:
SYSCALL(mknod)
 40d:	b8 11 00 00 00       	mov    $0x11,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <unlink>:
SYSCALL(unlink)
 415:	b8 12 00 00 00       	mov    $0x12,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <fstat>:
SYSCALL(fstat)
 41d:	b8 08 00 00 00       	mov    $0x8,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <link>:
SYSCALL(link)
 425:	b8 13 00 00 00       	mov    $0x13,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <mkdir>:
SYSCALL(mkdir)
 42d:	b8 14 00 00 00       	mov    $0x14,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <chdir>:
SYSCALL(chdir)
 435:	b8 09 00 00 00       	mov    $0x9,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <dup>:
SYSCALL(dup)
 43d:	b8 0a 00 00 00       	mov    $0xa,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <getpid>:
SYSCALL(getpid)
 445:	b8 0b 00 00 00       	mov    $0xb,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <sbrk>:
SYSCALL(sbrk)
 44d:	b8 0c 00 00 00       	mov    $0xc,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <sleep>:
SYSCALL(sleep)
 455:	b8 0d 00 00 00       	mov    $0xd,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <uptime>:
SYSCALL(uptime)
 45d:	b8 0e 00 00 00       	mov    $0xe,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <halt>:
SYSCALL(halt)
 465:	b8 16 00 00 00       	mov    $0x16,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <date>:
SYSCALL(date)
 46d:	b8 17 00 00 00       	mov    $0x17,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <getuid>:
SYSCALL(getuid)
 475:	b8 18 00 00 00       	mov    $0x18,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <getgid>:
SYSCALL(getgid)
 47d:	b8 19 00 00 00       	mov    $0x19,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <getppid>:
SYSCALL(getppid)
 485:	b8 1a 00 00 00       	mov    $0x1a,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <setuid>:
SYSCALL(setuid)
 48d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <setgid>:
SYSCALL(setgid)
 495:	b8 1c 00 00 00       	mov    $0x1c,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <getprocs>:
SYSCALL(getprocs)
 49d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <setpriority>:
SYSCALL(setpriority)
 4a5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <chmod>:
SYSCALL(chmod)
 4ad:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <chown>:
SYSCALL(chown)
 4b5:	b8 20 00 00 00       	mov    $0x20,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <chgrp>:
SYSCALL(chgrp)
 4bd:	b8 21 00 00 00       	mov    $0x21,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c5:	55                   	push   %ebp
 4c6:	89 e5                	mov    %esp,%ebp
 4c8:	83 ec 18             	sub    $0x18,%esp
 4cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ce:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d1:	83 ec 04             	sub    $0x4,%esp
 4d4:	6a 01                	push   $0x1
 4d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d9:	50                   	push   %eax
 4da:	ff 75 08             	pushl  0x8(%ebp)
 4dd:	e8 03 ff ff ff       	call   3e5 <write>
 4e2:	83 c4 10             	add    $0x10,%esp
}
 4e5:	90                   	nop
 4e6:	c9                   	leave  
 4e7:	c3                   	ret    

000004e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e8:	55                   	push   %ebp
 4e9:	89 e5                	mov    %esp,%ebp
 4eb:	53                   	push   %ebx
 4ec:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4f6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4fa:	74 17                	je     513 <printint+0x2b>
 4fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 500:	79 11                	jns    513 <printint+0x2b>
    neg = 1;
 502:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 509:	8b 45 0c             	mov    0xc(%ebp),%eax
 50c:	f7 d8                	neg    %eax
 50e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 511:	eb 06                	jmp    519 <printint+0x31>
  } else {
    x = xx;
 513:	8b 45 0c             	mov    0xc(%ebp),%eax
 516:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 519:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 520:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 523:	8d 41 01             	lea    0x1(%ecx),%eax
 526:	89 45 f4             	mov    %eax,-0xc(%ebp)
 529:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52f:	ba 00 00 00 00       	mov    $0x0,%edx
 534:	f7 f3                	div    %ebx
 536:	89 d0                	mov    %edx,%eax
 538:	0f b6 80 f4 0b 00 00 	movzbl 0xbf4(%eax),%eax
 53f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 543:	8b 5d 10             	mov    0x10(%ebp),%ebx
 546:	8b 45 ec             	mov    -0x14(%ebp),%eax
 549:	ba 00 00 00 00       	mov    $0x0,%edx
 54e:	f7 f3                	div    %ebx
 550:	89 45 ec             	mov    %eax,-0x14(%ebp)
 553:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 557:	75 c7                	jne    520 <printint+0x38>
  if(neg)
 559:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 55d:	74 2d                	je     58c <printint+0xa4>
    buf[i++] = '-';
 55f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 562:	8d 50 01             	lea    0x1(%eax),%edx
 565:	89 55 f4             	mov    %edx,-0xc(%ebp)
 568:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 56d:	eb 1d                	jmp    58c <printint+0xa4>
    putc(fd, buf[i]);
 56f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	01 d0                	add    %edx,%eax
 577:	0f b6 00             	movzbl (%eax),%eax
 57a:	0f be c0             	movsbl %al,%eax
 57d:	83 ec 08             	sub    $0x8,%esp
 580:	50                   	push   %eax
 581:	ff 75 08             	pushl  0x8(%ebp)
 584:	e8 3c ff ff ff       	call   4c5 <putc>
 589:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 58c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 594:	79 d9                	jns    56f <printint+0x87>
    putc(fd, buf[i]);
}
 596:	90                   	nop
 597:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 59a:	c9                   	leave  
 59b:	c3                   	ret    

0000059c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 59c:	55                   	push   %ebp
 59d:	89 e5                	mov    %esp,%ebp
 59f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5a9:	8d 45 0c             	lea    0xc(%ebp),%eax
 5ac:	83 c0 04             	add    $0x4,%eax
 5af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5b9:	e9 59 01 00 00       	jmp    717 <printf+0x17b>
    c = fmt[i] & 0xff;
 5be:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c4:	01 d0                	add    %edx,%eax
 5c6:	0f b6 00             	movzbl (%eax),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	25 ff 00 00 00       	and    $0xff,%eax
 5d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d8:	75 2c                	jne    606 <printf+0x6a>
      if(c == '%'){
 5da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5de:	75 0c                	jne    5ec <printf+0x50>
        state = '%';
 5e0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5e7:	e9 27 01 00 00       	jmp    713 <printf+0x177>
      } else {
        putc(fd, c);
 5ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	83 ec 08             	sub    $0x8,%esp
 5f5:	50                   	push   %eax
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 c7 fe ff ff       	call   4c5 <putc>
 5fe:	83 c4 10             	add    $0x10,%esp
 601:	e9 0d 01 00 00       	jmp    713 <printf+0x177>
      }
    } else if(state == '%'){
 606:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 60a:	0f 85 03 01 00 00    	jne    713 <printf+0x177>
      if(c == 'd'){
 610:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 614:	75 1e                	jne    634 <printf+0x98>
        printint(fd, *ap, 10, 1);
 616:	8b 45 e8             	mov    -0x18(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	6a 01                	push   $0x1
 61d:	6a 0a                	push   $0xa
 61f:	50                   	push   %eax
 620:	ff 75 08             	pushl  0x8(%ebp)
 623:	e8 c0 fe ff ff       	call   4e8 <printint>
 628:	83 c4 10             	add    $0x10,%esp
        ap++;
 62b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62f:	e9 d8 00 00 00       	jmp    70c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 634:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 638:	74 06                	je     640 <printf+0xa4>
 63a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 63e:	75 1e                	jne    65e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 640:	8b 45 e8             	mov    -0x18(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	6a 00                	push   $0x0
 647:	6a 10                	push   $0x10
 649:	50                   	push   %eax
 64a:	ff 75 08             	pushl  0x8(%ebp)
 64d:	e8 96 fe ff ff       	call   4e8 <printint>
 652:	83 c4 10             	add    $0x10,%esp
        ap++;
 655:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 659:	e9 ae 00 00 00       	jmp    70c <printf+0x170>
      } else if(c == 's'){
 65e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 662:	75 43                	jne    6a7 <printf+0x10b>
        s = (char*)*ap;
 664:	8b 45 e8             	mov    -0x18(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 66c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 674:	75 25                	jne    69b <printf+0xff>
          s = "(null)";
 676:	c7 45 f4 82 09 00 00 	movl   $0x982,-0xc(%ebp)
        while(*s != 0){
 67d:	eb 1c                	jmp    69b <printf+0xff>
          putc(fd, *s);
 67f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 682:	0f b6 00             	movzbl (%eax),%eax
 685:	0f be c0             	movsbl %al,%eax
 688:	83 ec 08             	sub    $0x8,%esp
 68b:	50                   	push   %eax
 68c:	ff 75 08             	pushl  0x8(%ebp)
 68f:	e8 31 fe ff ff       	call   4c5 <putc>
 694:	83 c4 10             	add    $0x10,%esp
          s++;
 697:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 69b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69e:	0f b6 00             	movzbl (%eax),%eax
 6a1:	84 c0                	test   %al,%al
 6a3:	75 da                	jne    67f <printf+0xe3>
 6a5:	eb 65                	jmp    70c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6ab:	75 1d                	jne    6ca <printf+0x12e>
        putc(fd, *ap);
 6ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	0f be c0             	movsbl %al,%eax
 6b5:	83 ec 08             	sub    $0x8,%esp
 6b8:	50                   	push   %eax
 6b9:	ff 75 08             	pushl  0x8(%ebp)
 6bc:	e8 04 fe ff ff       	call   4c5 <putc>
 6c1:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c8:	eb 42                	jmp    70c <printf+0x170>
      } else if(c == '%'){
 6ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ce:	75 17                	jne    6e7 <printf+0x14b>
        putc(fd, c);
 6d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	83 ec 08             	sub    $0x8,%esp
 6d9:	50                   	push   %eax
 6da:	ff 75 08             	pushl  0x8(%ebp)
 6dd:	e8 e3 fd ff ff       	call   4c5 <putc>
 6e2:	83 c4 10             	add    $0x10,%esp
 6e5:	eb 25                	jmp    70c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e7:	83 ec 08             	sub    $0x8,%esp
 6ea:	6a 25                	push   $0x25
 6ec:	ff 75 08             	pushl  0x8(%ebp)
 6ef:	e8 d1 fd ff ff       	call   4c5 <putc>
 6f4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fa:	0f be c0             	movsbl %al,%eax
 6fd:	83 ec 08             	sub    $0x8,%esp
 700:	50                   	push   %eax
 701:	ff 75 08             	pushl  0x8(%ebp)
 704:	e8 bc fd ff ff       	call   4c5 <putc>
 709:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 70c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 713:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 717:	8b 55 0c             	mov    0xc(%ebp),%edx
 71a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71d:	01 d0                	add    %edx,%eax
 71f:	0f b6 00             	movzbl (%eax),%eax
 722:	84 c0                	test   %al,%al
 724:	0f 85 94 fe ff ff    	jne    5be <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 72a:	90                   	nop
 72b:	c9                   	leave  
 72c:	c3                   	ret    

0000072d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72d:	55                   	push   %ebp
 72e:	89 e5                	mov    %esp,%ebp
 730:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 733:	8b 45 08             	mov    0x8(%ebp),%eax
 736:	83 e8 08             	sub    $0x8,%eax
 739:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73c:	a1 10 0c 00 00       	mov    0xc10,%eax
 741:	89 45 fc             	mov    %eax,-0x4(%ebp)
 744:	eb 24                	jmp    76a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74e:	77 12                	ja     762 <free+0x35>
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 756:	77 24                	ja     77c <free+0x4f>
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 760:	77 1a                	ja     77c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 770:	76 d4                	jbe    746 <free+0x19>
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77a:	76 ca                	jbe    746 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 77c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77f:	8b 40 04             	mov    0x4(%eax),%eax
 782:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	01 c2                	add    %eax,%edx
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8b 00                	mov    (%eax),%eax
 793:	39 c2                	cmp    %eax,%edx
 795:	75 24                	jne    7bb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 797:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79a:	8b 50 04             	mov    0x4(%eax),%edx
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	01 c2                	add    %eax,%edx
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	8b 10                	mov    (%eax),%edx
 7b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b7:	89 10                	mov    %edx,(%eax)
 7b9:	eb 0a                	jmp    7c5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	8b 10                	mov    (%eax),%edx
 7c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c8:	8b 40 04             	mov    0x4(%eax),%eax
 7cb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	01 d0                	add    %edx,%eax
 7d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7da:	75 20                	jne    7fc <free+0xcf>
    p->s.size += bp->s.size;
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	8b 50 04             	mov    0x4(%eax),%edx
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	8b 40 04             	mov    0x4(%eax),%eax
 7e8:	01 c2                	add    %eax,%edx
 7ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ed:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f3:	8b 10                	mov    (%eax),%edx
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	89 10                	mov    %edx,(%eax)
 7fa:	eb 08                	jmp    804 <free+0xd7>
  } else
    p->s.ptr = bp;
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	8b 55 f8             	mov    -0x8(%ebp),%edx
 802:	89 10                	mov    %edx,(%eax)
  freep = p;
 804:	8b 45 fc             	mov    -0x4(%ebp),%eax
 807:	a3 10 0c 00 00       	mov    %eax,0xc10
}
 80c:	90                   	nop
 80d:	c9                   	leave  
 80e:	c3                   	ret    

0000080f <morecore>:

static Header*
morecore(uint nu)
{
 80f:	55                   	push   %ebp
 810:	89 e5                	mov    %esp,%ebp
 812:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 815:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 81c:	77 07                	ja     825 <morecore+0x16>
    nu = 4096;
 81e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 825:	8b 45 08             	mov    0x8(%ebp),%eax
 828:	c1 e0 03             	shl    $0x3,%eax
 82b:	83 ec 0c             	sub    $0xc,%esp
 82e:	50                   	push   %eax
 82f:	e8 19 fc ff ff       	call   44d <sbrk>
 834:	83 c4 10             	add    $0x10,%esp
 837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 83a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 83e:	75 07                	jne    847 <morecore+0x38>
    return 0;
 840:	b8 00 00 00 00       	mov    $0x0,%eax
 845:	eb 26                	jmp    86d <morecore+0x5e>
  hp = (Header*)p;
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 84d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 850:	8b 55 08             	mov    0x8(%ebp),%edx
 853:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 856:	8b 45 f0             	mov    -0x10(%ebp),%eax
 859:	83 c0 08             	add    $0x8,%eax
 85c:	83 ec 0c             	sub    $0xc,%esp
 85f:	50                   	push   %eax
 860:	e8 c8 fe ff ff       	call   72d <free>
 865:	83 c4 10             	add    $0x10,%esp
  return freep;
 868:	a1 10 0c 00 00       	mov    0xc10,%eax
}
 86d:	c9                   	leave  
 86e:	c3                   	ret    

0000086f <malloc>:

void*
malloc(uint nbytes)
{
 86f:	55                   	push   %ebp
 870:	89 e5                	mov    %esp,%ebp
 872:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 875:	8b 45 08             	mov    0x8(%ebp),%eax
 878:	83 c0 07             	add    $0x7,%eax
 87b:	c1 e8 03             	shr    $0x3,%eax
 87e:	83 c0 01             	add    $0x1,%eax
 881:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 884:	a1 10 0c 00 00       	mov    0xc10,%eax
 889:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 890:	75 23                	jne    8b5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 892:	c7 45 f0 08 0c 00 00 	movl   $0xc08,-0x10(%ebp)
 899:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89c:	a3 10 0c 00 00       	mov    %eax,0xc10
 8a1:	a1 10 0c 00 00       	mov    0xc10,%eax
 8a6:	a3 08 0c 00 00       	mov    %eax,0xc08
    base.s.size = 0;
 8ab:	c7 05 0c 0c 00 00 00 	movl   $0x0,0xc0c
 8b2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	8b 40 04             	mov    0x4(%eax),%eax
 8c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c6:	72 4d                	jb     915 <malloc+0xa6>
      if(p->s.size == nunits)
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	8b 40 04             	mov    0x4(%eax),%eax
 8ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8d1:	75 0c                	jne    8df <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d6:	8b 10                	mov    (%eax),%edx
 8d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8db:	89 10                	mov    %edx,(%eax)
 8dd:	eb 26                	jmp    905 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	8b 40 04             	mov    0x4(%eax),%eax
 8e5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8e8:	89 c2                	mov    %eax,%edx
 8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ed:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f3:	8b 40 04             	mov    0x4(%eax),%eax
 8f6:	c1 e0 03             	shl    $0x3,%eax
 8f9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
 902:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 905:	8b 45 f0             	mov    -0x10(%ebp),%eax
 908:	a3 10 0c 00 00       	mov    %eax,0xc10
      return (void*)(p + 1);
 90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 910:	83 c0 08             	add    $0x8,%eax
 913:	eb 3b                	jmp    950 <malloc+0xe1>
    }
    if(p == freep)
 915:	a1 10 0c 00 00       	mov    0xc10,%eax
 91a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 91d:	75 1e                	jne    93d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 91f:	83 ec 0c             	sub    $0xc,%esp
 922:	ff 75 ec             	pushl  -0x14(%ebp)
 925:	e8 e5 fe ff ff       	call   80f <morecore>
 92a:	83 c4 10             	add    $0x10,%esp
 92d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 930:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 934:	75 07                	jne    93d <malloc+0xce>
        return 0;
 936:	b8 00 00 00 00       	mov    $0x0,%eax
 93b:	eb 13                	jmp    950 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 940:	89 45 f0             	mov    %eax,-0x10(%ebp)
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	8b 00                	mov    (%eax),%eax
 948:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 94b:	e9 6d ff ff ff       	jmp    8bd <malloc+0x4e>
}
 950:	c9                   	leave  
 951:	c3                   	ret    
