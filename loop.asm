
_loop:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#define TPS 100

int
main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
    int pid, max = 7;
  11:	c7 45 ec 07 00 00 00 	movl   $0x7,-0x14(%ebp)
    unsigned long x = 0;
  18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    for(int i = 0; i < max; i++) {
  1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  26:	eb 59                	jmp    81 <main+0x81>
        sleep(5*TPS);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	68 f4 01 00 00       	push   $0x1f4
  30:	e8 ef 03 00 00       	call   424 <sleep>
  35:	83 c4 10             	add    $0x10,%esp
        pid = fork();
  38:	e8 4f 03 00 00       	call   38c <fork>
  3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(pid < 0) {
  40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  44:	79 17                	jns    5d <main+0x5d>
            printf(2, "fork failed!\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 21 09 00 00       	push   $0x921
  4e:	6a 02                	push   $0x2
  50:	e8 16 05 00 00       	call   56b <printf>
  55:	83 c4 10             	add    $0x10,%esp
            exit();
  58:	e8 37 03 00 00       	call   394 <exit>
        }

        if(pid == 0) {
  5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  61:	75 1a                	jne    7d <main+0x7d>
            sleep(getpid()*100);
  63:	e8 ac 03 00 00       	call   414 <getpid>
  68:	6b c0 64             	imul   $0x64,%eax,%eax
  6b:	83 ec 0c             	sub    $0xc,%esp
  6e:	50                   	push   %eax
  6f:	e8 b0 03 00 00       	call   424 <sleep>
  74:	83 c4 10             	add    $0x10,%esp
            do {
                x += 1;
  77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            } while (1);
  7b:	eb fa                	jmp    77 <main+0x77>
main()
{
    int pid, max = 7;
    unsigned long x = 0;

    for(int i = 0; i < max; i++) {
  7d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  87:	7c 9f                	jl     28 <main+0x28>
            printf(1, "Child %d exiting\n", getpid());
            exit();
        }
    }

    pid = fork();
  89:	e8 fe 02 00 00       	call   38c <fork>
  8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid == 0) {
  91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  95:	75 13                	jne    aa <main+0xaa>
        sleep(20);
  97:	83 ec 0c             	sub    $0xc,%esp
  9a:	6a 14                	push   $0x14
  9c:	e8 83 03 00 00       	call   424 <sleep>
  a1:	83 c4 10             	add    $0x10,%esp
        do {
            x = x+1;
  a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        } while(1);
  a8:	eb fa                	jmp    a4 <main+0xa4>
    }
    exit();
  aa:	e8 e5 02 00 00       	call   394 <exit>

000000af <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  b2:	57                   	push   %edi
  b3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b7:	8b 55 10             	mov    0x10(%ebp),%edx
  ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  bd:	89 cb                	mov    %ecx,%ebx
  bf:	89 df                	mov    %ebx,%edi
  c1:	89 d1                	mov    %edx,%ecx
  c3:	fc                   	cld    
  c4:	f3 aa                	rep stos %al,%es:(%edi)
  c6:	89 ca                	mov    %ecx,%edx
  c8:	89 fb                	mov    %edi,%ebx
  ca:	89 5d 08             	mov    %ebx,0x8(%ebp)
  cd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  d0:	90                   	nop
  d1:	5b                   	pop    %ebx
  d2:	5f                   	pop    %edi
  d3:	5d                   	pop    %ebp
  d4:	c3                   	ret    

000000d5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  d5:	55                   	push   %ebp
  d6:	89 e5                	mov    %esp,%ebp
  d8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  e1:	90                   	nop
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	8d 50 01             	lea    0x1(%eax),%edx
  e8:	89 55 08             	mov    %edx,0x8(%ebp)
  eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  f1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  f4:	0f b6 12             	movzbl (%edx),%edx
  f7:	88 10                	mov    %dl,(%eax)
  f9:	0f b6 00             	movzbl (%eax),%eax
  fc:	84 c0                	test   %al,%al
  fe:	75 e2                	jne    e2 <strcpy+0xd>
    ;
  return os;
 100:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 103:	c9                   	leave  
 104:	c3                   	ret    

00000105 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 108:	eb 08                	jmp    112 <strcmp+0xd>
    p++, q++;
 10a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	74 10                	je     12c <strcmp+0x27>
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	0f b6 10             	movzbl (%eax),%edx
 122:	8b 45 0c             	mov    0xc(%ebp),%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	38 c2                	cmp    %al,%dl
 12a:	74 de                	je     10a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	0f b6 00             	movzbl (%eax),%eax
 132:	0f b6 d0             	movzbl %al,%edx
 135:	8b 45 0c             	mov    0xc(%ebp),%eax
 138:	0f b6 00             	movzbl (%eax),%eax
 13b:	0f b6 c0             	movzbl %al,%eax
 13e:	29 c2                	sub    %eax,%edx
 140:	89 d0                	mov    %edx,%eax
}
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    

00000144 <strlen>:

uint
strlen(char *s)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 14a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 151:	eb 04                	jmp    157 <strlen+0x13>
 153:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 157:	8b 55 fc             	mov    -0x4(%ebp),%edx
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	01 d0                	add    %edx,%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	84 c0                	test   %al,%al
 164:	75 ed                	jne    153 <strlen+0xf>
    ;
  return n;
 166:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 169:	c9                   	leave  
 16a:	c3                   	ret    

0000016b <memset>:

void*
memset(void *dst, int c, uint n)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 16e:	8b 45 10             	mov    0x10(%ebp),%eax
 171:	50                   	push   %eax
 172:	ff 75 0c             	pushl  0xc(%ebp)
 175:	ff 75 08             	pushl  0x8(%ebp)
 178:	e8 32 ff ff ff       	call   af <stosb>
 17d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 180:	8b 45 08             	mov    0x8(%ebp),%eax
}
 183:	c9                   	leave  
 184:	c3                   	ret    

00000185 <strchr>:

char*
strchr(const char *s, char c)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	8b 45 0c             	mov    0xc(%ebp),%eax
 18e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 191:	eb 14                	jmp    1a7 <strchr+0x22>
    if(*s == c)
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	3a 45 fc             	cmp    -0x4(%ebp),%al
 19c:	75 05                	jne    1a3 <strchr+0x1e>
      return (char*)s;
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	eb 13                	jmp    1b6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	84 c0                	test   %al,%al
 1af:	75 e2                	jne    193 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b6:	c9                   	leave  
 1b7:	c3                   	ret    

000001b8 <gets>:

char*
gets(char *buf, int max)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c5:	eb 42                	jmp    209 <gets+0x51>
    cc = read(0, &c, 1);
 1c7:	83 ec 04             	sub    $0x4,%esp
 1ca:	6a 01                	push   $0x1
 1cc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1cf:	50                   	push   %eax
 1d0:	6a 00                	push   $0x0
 1d2:	e8 d5 01 00 00       	call   3ac <read>
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e1:	7e 33                	jle    216 <gets+0x5e>
      break;
    buf[i++] = c;
 1e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e6:	8d 50 01             	lea    0x1(%eax),%edx
 1e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ec:	89 c2                	mov    %eax,%edx
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	01 c2                	add    %eax,%edx
 1f3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fd:	3c 0a                	cmp    $0xa,%al
 1ff:	74 16                	je     217 <gets+0x5f>
 201:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 205:	3c 0d                	cmp    $0xd,%al
 207:	74 0e                	je     217 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 209:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20c:	83 c0 01             	add    $0x1,%eax
 20f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 212:	7c b3                	jl     1c7 <gets+0xf>
 214:	eb 01                	jmp    217 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 216:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 217:	8b 55 f4             	mov    -0xc(%ebp),%edx
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	01 d0                	add    %edx,%eax
 21f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 222:	8b 45 08             	mov    0x8(%ebp),%eax
}
 225:	c9                   	leave  
 226:	c3                   	ret    

00000227 <stat>:

int
stat(char *n, struct stat *st)
{
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22d:	83 ec 08             	sub    $0x8,%esp
 230:	6a 00                	push   $0x0
 232:	ff 75 08             	pushl  0x8(%ebp)
 235:	e8 9a 01 00 00       	call   3d4 <open>
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 240:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 244:	79 07                	jns    24d <stat+0x26>
    return -1;
 246:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 24b:	eb 25                	jmp    272 <stat+0x4b>
  r = fstat(fd, st);
 24d:	83 ec 08             	sub    $0x8,%esp
 250:	ff 75 0c             	pushl  0xc(%ebp)
 253:	ff 75 f4             	pushl  -0xc(%ebp)
 256:	e8 91 01 00 00       	call   3ec <fstat>
 25b:	83 c4 10             	add    $0x10,%esp
 25e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 261:	83 ec 0c             	sub    $0xc,%esp
 264:	ff 75 f4             	pushl  -0xc(%ebp)
 267:	e8 50 01 00 00       	call   3bc <close>
 26c:	83 c4 10             	add    $0x10,%esp
  return r;
 26f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 272:	c9                   	leave  
 273:	c3                   	ret    

00000274 <atoi>:

int
atoi(const char *s)
{
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 27a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 281:	eb 25                	jmp    2a8 <atoi+0x34>
    n = n*10 + *s++ - '0';
 283:	8b 55 fc             	mov    -0x4(%ebp),%edx
 286:	89 d0                	mov    %edx,%eax
 288:	c1 e0 02             	shl    $0x2,%eax
 28b:	01 d0                	add    %edx,%eax
 28d:	01 c0                	add    %eax,%eax
 28f:	89 c1                	mov    %eax,%ecx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	8d 50 01             	lea    0x1(%eax),%edx
 297:	89 55 08             	mov    %edx,0x8(%ebp)
 29a:	0f b6 00             	movzbl (%eax),%eax
 29d:	0f be c0             	movsbl %al,%eax
 2a0:	01 c8                	add    %ecx,%eax
 2a2:	83 e8 30             	sub    $0x30,%eax
 2a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3c 2f                	cmp    $0x2f,%al
 2b0:	7e 0a                	jle    2bc <atoi+0x48>
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	3c 39                	cmp    $0x39,%al
 2ba:	7e c7                	jle    283 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <atoo>:

int
atoo(const char *s)
{
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
 2c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
 2ce:	eb 04                	jmp    2d4 <atoo+0x13>
        s++;
 2d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	3c 20                	cmp    $0x20,%al
 2dc:	74 f2                	je     2d0 <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	3c 2d                	cmp    $0x2d,%al
 2e6:	75 07                	jne    2ef <atoo+0x2e>
 2e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ed:	eb 05                	jmp    2f4 <atoo+0x33>
 2ef:	b8 01 00 00 00       	mov    $0x1,%eax
 2f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	3c 2b                	cmp    $0x2b,%al
 2ff:	74 0a                	je     30b <atoo+0x4a>
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	0f b6 00             	movzbl (%eax),%eax
 307:	3c 2d                	cmp    $0x2d,%al
 309:	75 27                	jne    332 <atoo+0x71>
        s++;
 30b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
 30f:	eb 21                	jmp    332 <atoo+0x71>
        n = n*8 + *s++ - '0';
 311:	8b 45 fc             	mov    -0x4(%ebp),%eax
 314:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	8d 50 01             	lea    0x1(%eax),%edx
 321:	89 55 08             	mov    %edx,0x8(%ebp)
 324:	0f b6 00             	movzbl (%eax),%eax
 327:	0f be c0             	movsbl %al,%eax
 32a:	01 c8                	add    %ecx,%eax
 32c:	83 e8 30             	sub    $0x30,%eax
 32f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	0f b6 00             	movzbl (%eax),%eax
 338:	3c 2f                	cmp    $0x2f,%al
 33a:	7e 0a                	jle    346 <atoo+0x85>
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	0f b6 00             	movzbl (%eax),%eax
 342:	3c 37                	cmp    $0x37,%al
 344:	7e cb                	jle    311 <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
 346:	8b 45 f8             	mov    -0x8(%ebp),%eax
 349:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 34d:	c9                   	leave  
 34e:	c3                   	ret    

0000034f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 34f:	55                   	push   %ebp
 350:	89 e5                	mov    %esp,%ebp
 352:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 35b:	8b 45 0c             	mov    0xc(%ebp),%eax
 35e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 361:	eb 17                	jmp    37a <memmove+0x2b>
    *dst++ = *src++;
 363:	8b 45 fc             	mov    -0x4(%ebp),%eax
 366:	8d 50 01             	lea    0x1(%eax),%edx
 369:	89 55 fc             	mov    %edx,-0x4(%ebp)
 36c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 36f:	8d 4a 01             	lea    0x1(%edx),%ecx
 372:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 375:	0f b6 12             	movzbl (%edx),%edx
 378:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 37a:	8b 45 10             	mov    0x10(%ebp),%eax
 37d:	8d 50 ff             	lea    -0x1(%eax),%edx
 380:	89 55 10             	mov    %edx,0x10(%ebp)
 383:	85 c0                	test   %eax,%eax
 385:	7f dc                	jg     363 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 387:	8b 45 08             	mov    0x8(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38c:	b8 01 00 00 00       	mov    $0x1,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <exit>:
SYSCALL(exit)
 394:	b8 02 00 00 00       	mov    $0x2,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <wait>:
SYSCALL(wait)
 39c:	b8 03 00 00 00       	mov    $0x3,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <pipe>:
SYSCALL(pipe)
 3a4:	b8 04 00 00 00       	mov    $0x4,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <read>:
SYSCALL(read)
 3ac:	b8 05 00 00 00       	mov    $0x5,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <write>:
SYSCALL(write)
 3b4:	b8 10 00 00 00       	mov    $0x10,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <close>:
SYSCALL(close)
 3bc:	b8 15 00 00 00       	mov    $0x15,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <kill>:
SYSCALL(kill)
 3c4:	b8 06 00 00 00       	mov    $0x6,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <exec>:
SYSCALL(exec)
 3cc:	b8 07 00 00 00       	mov    $0x7,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <open>:
SYSCALL(open)
 3d4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <mknod>:
SYSCALL(mknod)
 3dc:	b8 11 00 00 00       	mov    $0x11,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <unlink>:
SYSCALL(unlink)
 3e4:	b8 12 00 00 00       	mov    $0x12,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <fstat>:
SYSCALL(fstat)
 3ec:	b8 08 00 00 00       	mov    $0x8,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <link>:
SYSCALL(link)
 3f4:	b8 13 00 00 00       	mov    $0x13,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mkdir>:
SYSCALL(mkdir)
 3fc:	b8 14 00 00 00       	mov    $0x14,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <chdir>:
SYSCALL(chdir)
 404:	b8 09 00 00 00       	mov    $0x9,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <dup>:
SYSCALL(dup)
 40c:	b8 0a 00 00 00       	mov    $0xa,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <getpid>:
SYSCALL(getpid)
 414:	b8 0b 00 00 00       	mov    $0xb,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <sbrk>:
SYSCALL(sbrk)
 41c:	b8 0c 00 00 00       	mov    $0xc,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <sleep>:
SYSCALL(sleep)
 424:	b8 0d 00 00 00       	mov    $0xd,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <uptime>:
SYSCALL(uptime)
 42c:	b8 0e 00 00 00       	mov    $0xe,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <halt>:
SYSCALL(halt)
 434:	b8 16 00 00 00       	mov    $0x16,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <date>:
SYSCALL(date)
 43c:	b8 17 00 00 00       	mov    $0x17,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <getuid>:
SYSCALL(getuid)
 444:	b8 18 00 00 00       	mov    $0x18,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <getgid>:
SYSCALL(getgid)
 44c:	b8 19 00 00 00       	mov    $0x19,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <getppid>:
SYSCALL(getppid)
 454:	b8 1a 00 00 00       	mov    $0x1a,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <setuid>:
SYSCALL(setuid)
 45c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <setgid>:
SYSCALL(setgid)
 464:	b8 1c 00 00 00       	mov    $0x1c,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <getprocs>:
SYSCALL(getprocs)
 46c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <setpriority>:
SYSCALL(setpriority)
 474:	b8 1e 00 00 00       	mov    $0x1e,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <chmod>:
SYSCALL(chmod)
 47c:	b8 1f 00 00 00       	mov    $0x1f,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <chown>:
SYSCALL(chown)
 484:	b8 20 00 00 00       	mov    $0x20,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <chgrp>:
SYSCALL(chgrp)
 48c:	b8 21 00 00 00       	mov    $0x21,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 494:	55                   	push   %ebp
 495:	89 e5                	mov    %esp,%ebp
 497:	83 ec 18             	sub    $0x18,%esp
 49a:	8b 45 0c             	mov    0xc(%ebp),%eax
 49d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4a0:	83 ec 04             	sub    $0x4,%esp
 4a3:	6a 01                	push   $0x1
 4a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a8:	50                   	push   %eax
 4a9:	ff 75 08             	pushl  0x8(%ebp)
 4ac:	e8 03 ff ff ff       	call   3b4 <write>
 4b1:	83 c4 10             	add    $0x10,%esp
}
 4b4:	90                   	nop
 4b5:	c9                   	leave  
 4b6:	c3                   	ret    

000004b7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b7:	55                   	push   %ebp
 4b8:	89 e5                	mov    %esp,%ebp
 4ba:	53                   	push   %ebx
 4bb:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c9:	74 17                	je     4e2 <printint+0x2b>
 4cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4cf:	79 11                	jns    4e2 <printint+0x2b>
    neg = 1;
 4d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4db:	f7 d8                	neg    %eax
 4dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e0:	eb 06                	jmp    4e8 <printint+0x31>
  } else {
    x = xx;
 4e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4f2:	8d 41 01             	lea    0x1(%ecx),%eax
 4f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fe:	ba 00 00 00 00       	mov    $0x0,%edx
 503:	f7 f3                	div    %ebx
 505:	89 d0                	mov    %edx,%eax
 507:	0f b6 80 a0 0b 00 00 	movzbl 0xba0(%eax),%eax
 50e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 512:	8b 5d 10             	mov    0x10(%ebp),%ebx
 515:	8b 45 ec             	mov    -0x14(%ebp),%eax
 518:	ba 00 00 00 00       	mov    $0x0,%edx
 51d:	f7 f3                	div    %ebx
 51f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 522:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 526:	75 c7                	jne    4ef <printint+0x38>
  if(neg)
 528:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 52c:	74 2d                	je     55b <printint+0xa4>
    buf[i++] = '-';
 52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 531:	8d 50 01             	lea    0x1(%eax),%edx
 534:	89 55 f4             	mov    %edx,-0xc(%ebp)
 537:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 53c:	eb 1d                	jmp    55b <printint+0xa4>
    putc(fd, buf[i]);
 53e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 541:	8b 45 f4             	mov    -0xc(%ebp),%eax
 544:	01 d0                	add    %edx,%eax
 546:	0f b6 00             	movzbl (%eax),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	83 ec 08             	sub    $0x8,%esp
 54f:	50                   	push   %eax
 550:	ff 75 08             	pushl  0x8(%ebp)
 553:	e8 3c ff ff ff       	call   494 <putc>
 558:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 55b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 55f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 563:	79 d9                	jns    53e <printint+0x87>
    putc(fd, buf[i]);
}
 565:	90                   	nop
 566:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 569:	c9                   	leave  
 56a:	c3                   	ret    

0000056b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 56b:	55                   	push   %ebp
 56c:	89 e5                	mov    %esp,%ebp
 56e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 571:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 578:	8d 45 0c             	lea    0xc(%ebp),%eax
 57b:	83 c0 04             	add    $0x4,%eax
 57e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 581:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 588:	e9 59 01 00 00       	jmp    6e6 <printf+0x17b>
    c = fmt[i] & 0xff;
 58d:	8b 55 0c             	mov    0xc(%ebp),%edx
 590:	8b 45 f0             	mov    -0x10(%ebp),%eax
 593:	01 d0                	add    %edx,%eax
 595:	0f b6 00             	movzbl (%eax),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	25 ff 00 00 00       	and    $0xff,%eax
 5a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a7:	75 2c                	jne    5d5 <printf+0x6a>
      if(c == '%'){
 5a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ad:	75 0c                	jne    5bb <printf+0x50>
        state = '%';
 5af:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5b6:	e9 27 01 00 00       	jmp    6e2 <printf+0x177>
      } else {
        putc(fd, c);
 5bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	83 ec 08             	sub    $0x8,%esp
 5c4:	50                   	push   %eax
 5c5:	ff 75 08             	pushl  0x8(%ebp)
 5c8:	e8 c7 fe ff ff       	call   494 <putc>
 5cd:	83 c4 10             	add    $0x10,%esp
 5d0:	e9 0d 01 00 00       	jmp    6e2 <printf+0x177>
      }
    } else if(state == '%'){
 5d5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d9:	0f 85 03 01 00 00    	jne    6e2 <printf+0x177>
      if(c == 'd'){
 5df:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5e3:	75 1e                	jne    603 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	6a 01                	push   $0x1
 5ec:	6a 0a                	push   $0xa
 5ee:	50                   	push   %eax
 5ef:	ff 75 08             	pushl  0x8(%ebp)
 5f2:	e8 c0 fe ff ff       	call   4b7 <printint>
 5f7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fe:	e9 d8 00 00 00       	jmp    6db <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 603:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 607:	74 06                	je     60f <printf+0xa4>
 609:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 60d:	75 1e                	jne    62d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 60f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 612:	8b 00                	mov    (%eax),%eax
 614:	6a 00                	push   $0x0
 616:	6a 10                	push   $0x10
 618:	50                   	push   %eax
 619:	ff 75 08             	pushl  0x8(%ebp)
 61c:	e8 96 fe ff ff       	call   4b7 <printint>
 621:	83 c4 10             	add    $0x10,%esp
        ap++;
 624:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 628:	e9 ae 00 00 00       	jmp    6db <printf+0x170>
      } else if(c == 's'){
 62d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 631:	75 43                	jne    676 <printf+0x10b>
        s = (char*)*ap;
 633:	8b 45 e8             	mov    -0x18(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 63b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 63f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 643:	75 25                	jne    66a <printf+0xff>
          s = "(null)";
 645:	c7 45 f4 2f 09 00 00 	movl   $0x92f,-0xc(%ebp)
        while(*s != 0){
 64c:	eb 1c                	jmp    66a <printf+0xff>
          putc(fd, *s);
 64e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 651:	0f b6 00             	movzbl (%eax),%eax
 654:	0f be c0             	movsbl %al,%eax
 657:	83 ec 08             	sub    $0x8,%esp
 65a:	50                   	push   %eax
 65b:	ff 75 08             	pushl  0x8(%ebp)
 65e:	e8 31 fe ff ff       	call   494 <putc>
 663:	83 c4 10             	add    $0x10,%esp
          s++;
 666:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 66a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66d:	0f b6 00             	movzbl (%eax),%eax
 670:	84 c0                	test   %al,%al
 672:	75 da                	jne    64e <printf+0xe3>
 674:	eb 65                	jmp    6db <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 676:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 67a:	75 1d                	jne    699 <printf+0x12e>
        putc(fd, *ap);
 67c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	0f be c0             	movsbl %al,%eax
 684:	83 ec 08             	sub    $0x8,%esp
 687:	50                   	push   %eax
 688:	ff 75 08             	pushl  0x8(%ebp)
 68b:	e8 04 fe ff ff       	call   494 <putc>
 690:	83 c4 10             	add    $0x10,%esp
        ap++;
 693:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 697:	eb 42                	jmp    6db <printf+0x170>
      } else if(c == '%'){
 699:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 69d:	75 17                	jne    6b6 <printf+0x14b>
        putc(fd, c);
 69f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a2:	0f be c0             	movsbl %al,%eax
 6a5:	83 ec 08             	sub    $0x8,%esp
 6a8:	50                   	push   %eax
 6a9:	ff 75 08             	pushl  0x8(%ebp)
 6ac:	e8 e3 fd ff ff       	call   494 <putc>
 6b1:	83 c4 10             	add    $0x10,%esp
 6b4:	eb 25                	jmp    6db <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6b6:	83 ec 08             	sub    $0x8,%esp
 6b9:	6a 25                	push   $0x25
 6bb:	ff 75 08             	pushl  0x8(%ebp)
 6be:	e8 d1 fd ff ff       	call   494 <putc>
 6c3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c9:	0f be c0             	movsbl %al,%eax
 6cc:	83 ec 08             	sub    $0x8,%esp
 6cf:	50                   	push   %eax
 6d0:	ff 75 08             	pushl  0x8(%ebp)
 6d3:	e8 bc fd ff ff       	call   494 <putc>
 6d8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6e6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ec:	01 d0                	add    %edx,%eax
 6ee:	0f b6 00             	movzbl (%eax),%eax
 6f1:	84 c0                	test   %al,%al
 6f3:	0f 85 94 fe ff ff    	jne    58d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f9:	90                   	nop
 6fa:	c9                   	leave  
 6fb:	c3                   	ret    

000006fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fc:	55                   	push   %ebp
 6fd:	89 e5                	mov    %esp,%ebp
 6ff:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	83 e8 08             	sub    $0x8,%eax
 708:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70b:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 710:	89 45 fc             	mov    %eax,-0x4(%ebp)
 713:	eb 24                	jmp    739 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71d:	77 12                	ja     731 <free+0x35>
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 725:	77 24                	ja     74b <free+0x4f>
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72f:	77 1a                	ja     74b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	89 45 fc             	mov    %eax,-0x4(%ebp)
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73f:	76 d4                	jbe    715 <free+0x19>
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 749:	76 ca                	jbe    715 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 758:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75b:	01 c2                	add    %eax,%edx
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	39 c2                	cmp    %eax,%edx
 764:	75 24                	jne    78a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 766:	8b 45 f8             	mov    -0x8(%ebp),%eax
 769:	8b 50 04             	mov    0x4(%eax),%edx
 76c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76f:	8b 00                	mov    (%eax),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	01 c2                	add    %eax,%edx
 776:	8b 45 f8             	mov    -0x8(%ebp),%eax
 779:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 00                	mov    (%eax),%eax
 781:	8b 10                	mov    (%eax),%edx
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	89 10                	mov    %edx,(%eax)
 788:	eb 0a                	jmp    794 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	8b 10                	mov    (%eax),%edx
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	01 d0                	add    %edx,%eax
 7a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a9:	75 20                	jne    7cb <free+0xcf>
    p->s.size += bp->s.size;
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 50 04             	mov    0x4(%eax),%edx
 7b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	01 c2                	add    %eax,%edx
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c2:	8b 10                	mov    (%eax),%edx
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	89 10                	mov    %edx,(%eax)
 7c9:	eb 08                	jmp    7d3 <free+0xd7>
  } else
    p->s.ptr = bp;
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7d1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d6:	a3 bc 0b 00 00       	mov    %eax,0xbbc
}
 7db:	90                   	nop
 7dc:	c9                   	leave  
 7dd:	c3                   	ret    

000007de <morecore>:

static Header*
morecore(uint nu)
{
 7de:	55                   	push   %ebp
 7df:	89 e5                	mov    %esp,%ebp
 7e1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7e4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7eb:	77 07                	ja     7f4 <morecore+0x16>
    nu = 4096;
 7ed:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7f4:	8b 45 08             	mov    0x8(%ebp),%eax
 7f7:	c1 e0 03             	shl    $0x3,%eax
 7fa:	83 ec 0c             	sub    $0xc,%esp
 7fd:	50                   	push   %eax
 7fe:	e8 19 fc ff ff       	call   41c <sbrk>
 803:	83 c4 10             	add    $0x10,%esp
 806:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 809:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 80d:	75 07                	jne    816 <morecore+0x38>
    return 0;
 80f:	b8 00 00 00 00       	mov    $0x0,%eax
 814:	eb 26                	jmp    83c <morecore+0x5e>
  hp = (Header*)p;
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 81c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81f:	8b 55 08             	mov    0x8(%ebp),%edx
 822:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 825:	8b 45 f0             	mov    -0x10(%ebp),%eax
 828:	83 c0 08             	add    $0x8,%eax
 82b:	83 ec 0c             	sub    $0xc,%esp
 82e:	50                   	push   %eax
 82f:	e8 c8 fe ff ff       	call   6fc <free>
 834:	83 c4 10             	add    $0x10,%esp
  return freep;
 837:	a1 bc 0b 00 00       	mov    0xbbc,%eax
}
 83c:	c9                   	leave  
 83d:	c3                   	ret    

0000083e <malloc>:

void*
malloc(uint nbytes)
{
 83e:	55                   	push   %ebp
 83f:	89 e5                	mov    %esp,%ebp
 841:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 844:	8b 45 08             	mov    0x8(%ebp),%eax
 847:	83 c0 07             	add    $0x7,%eax
 84a:	c1 e8 03             	shr    $0x3,%eax
 84d:	83 c0 01             	add    $0x1,%eax
 850:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 853:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 858:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85f:	75 23                	jne    884 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 861:	c7 45 f0 b4 0b 00 00 	movl   $0xbb4,-0x10(%ebp)
 868:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86b:	a3 bc 0b 00 00       	mov    %eax,0xbbc
 870:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 875:	a3 b4 0b 00 00       	mov    %eax,0xbb4
    base.s.size = 0;
 87a:	c7 05 b8 0b 00 00 00 	movl   $0x0,0xbb8
 881:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	8b 45 f0             	mov    -0x10(%ebp),%eax
 887:	8b 00                	mov    (%eax),%eax
 889:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 895:	72 4d                	jb     8e4 <malloc+0xa6>
      if(p->s.size == nunits)
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8b 40 04             	mov    0x4(%eax),%eax
 89d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a0:	75 0c                	jne    8ae <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	8b 10                	mov    (%eax),%edx
 8a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8aa:	89 10                	mov    %edx,(%eax)
 8ac:	eb 26                	jmp    8d4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	8b 40 04             	mov    0x4(%eax),%eax
 8b4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8b7:	89 c2                	mov    %eax,%edx
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c2:	8b 40 04             	mov    0x4(%eax),%eax
 8c5:	c1 e0 03             	shl    $0x3,%eax
 8c8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d7:	a3 bc 0b 00 00       	mov    %eax,0xbbc
      return (void*)(p + 1);
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	83 c0 08             	add    $0x8,%eax
 8e2:	eb 3b                	jmp    91f <malloc+0xe1>
    }
    if(p == freep)
 8e4:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 8e9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ec:	75 1e                	jne    90c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8ee:	83 ec 0c             	sub    $0xc,%esp
 8f1:	ff 75 ec             	pushl  -0x14(%ebp)
 8f4:	e8 e5 fe ff ff       	call   7de <morecore>
 8f9:	83 c4 10             	add    $0x10,%esp
 8fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 903:	75 07                	jne    90c <malloc+0xce>
        return 0;
 905:	b8 00 00 00 00       	mov    $0x0,%eax
 90a:	eb 13                	jmp    91f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	8b 00                	mov    (%eax),%eax
 917:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 91a:	e9 6d ff ff ff       	jmp    88c <malloc+0x4e>
}
 91f:	c9                   	leave  
 920:	c3                   	ret    
