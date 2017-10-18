
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char* argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 1c             	sub    $0x1c,%esp
  13:	89 cb                	mov    %ecx,%ebx
    int t1, t2;
    int pid;

    argv++;
  15:	83 43 04 04          	addl   $0x4,0x4(%ebx)
    t1 = uptime();
  19:	e8 46 04 00 00       	call   464 <uptime>
  1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pid = fork();
  21:	e8 9e 03 00 00       	call   3c4 <fork>
  26:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (pid < 0) {
  29:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  2d:	79 1b                	jns    4a <main+0x4a>
        printf(2, "Error: fork failed. %s at line %d.\n", __FILE__, __LINE__);
  2f:	6a 0c                	push   $0xc
  31:	68 5c 09 00 00       	push   $0x95c
  36:	68 64 09 00 00       	push   $0x964
  3b:	6a 02                	push   $0x2
  3d:	e8 61 05 00 00       	call   5a3 <printf>
  42:	83 c4 10             	add    $0x10,%esp
        exit();
  45:	e8 82 03 00 00       	call   3cc <exit>
    }
    if (pid == 0) {
  4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  4e:	75 2c                	jne    7c <main+0x7c>
        exec(argv[0], argv);
  50:	8b 43 04             	mov    0x4(%ebx),%eax
  53:	8b 00                	mov    (%eax),%eax
  55:	83 ec 08             	sub    $0x8,%esp
  58:	ff 73 04             	pushl  0x4(%ebx)
  5b:	50                   	push   %eax
  5c:	e8 a3 03 00 00       	call   404 <exec>
  61:	83 c4 10             	add    $0x10,%esp
        printf(2, "Error: exec failed. %s at line %d.\n", __FILE__, __LINE__);
  64:	6a 11                	push   $0x11
  66:	68 5c 09 00 00       	push   $0x95c
  6b:	68 88 09 00 00       	push   $0x988
  70:	6a 02                	push   $0x2
  72:	e8 2c 05 00 00       	call   5a3 <printf>
  77:	83 c4 10             	add    $0x10,%esp
  7a:	eb 66                	jmp    e2 <main+0xe2>
    }
    else {
        wait();
  7c:	e8 53 03 00 00       	call   3d4 <wait>
        t2 = uptime();
  81:	e8 de 03 00 00       	call   464 <uptime>
  86:	89 45 dc             	mov    %eax,-0x24(%ebp)
        printf(1, "%s ran in %d.%d seconds.\n", argv[0], (t2-t1)/100, (t2-t1)%100);
  89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8f:	89 c6                	mov    %eax,%esi
  91:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  96:	89 f0                	mov    %esi,%eax
  98:	f7 ea                	imul   %edx
  9a:	c1 fa 05             	sar    $0x5,%edx
  9d:	89 f0                	mov    %esi,%eax
  9f:	c1 f8 1f             	sar    $0x1f,%eax
  a2:	89 d1                	mov    %edx,%ecx
  a4:	29 c1                	sub    %eax,%ecx
  a6:	6b c1 64             	imul   $0x64,%ecx,%eax
  a9:	29 c6                	sub    %eax,%esi
  ab:	89 f1                	mov    %esi,%ecx
  ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  b0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  b3:	89 c6                	mov    %eax,%esi
  b5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  ba:	89 f0                	mov    %esi,%eax
  bc:	f7 ea                	imul   %edx
  be:	c1 fa 05             	sar    $0x5,%edx
  c1:	89 f0                	mov    %esi,%eax
  c3:	c1 f8 1f             	sar    $0x1f,%eax
  c6:	29 c2                	sub    %eax,%edx
  c8:	8b 43 04             	mov    0x4(%ebx),%eax
  cb:	8b 00                	mov    (%eax),%eax
  cd:	83 ec 0c             	sub    $0xc,%esp
  d0:	51                   	push   %ecx
  d1:	52                   	push   %edx
  d2:	50                   	push   %eax
  d3:	68 ac 09 00 00       	push   $0x9ac
  d8:	6a 01                	push   $0x1
  da:	e8 c4 04 00 00       	call   5a3 <printf>
  df:	83 c4 20             	add    $0x20,%esp
    }
    //return 0;
    exit();
  e2:	e8 e5 02 00 00       	call   3cc <exit>

000000e7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  ea:	57                   	push   %edi
  eb:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ef:	8b 55 10             	mov    0x10(%ebp),%edx
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	89 cb                	mov    %ecx,%ebx
  f7:	89 df                	mov    %ebx,%edi
  f9:	89 d1                	mov    %edx,%ecx
  fb:	fc                   	cld    
  fc:	f3 aa                	rep stos %al,%es:(%edi)
  fe:	89 ca                	mov    %ecx,%edx
 100:	89 fb                	mov    %edi,%ebx
 102:	89 5d 08             	mov    %ebx,0x8(%ebp)
 105:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 108:	90                   	nop
 109:	5b                   	pop    %ebx
 10a:	5f                   	pop    %edi
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    

0000010d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 119:	90                   	nop
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	8d 50 01             	lea    0x1(%eax),%edx
 120:	89 55 08             	mov    %edx,0x8(%ebp)
 123:	8b 55 0c             	mov    0xc(%ebp),%edx
 126:	8d 4a 01             	lea    0x1(%edx),%ecx
 129:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 12c:	0f b6 12             	movzbl (%edx),%edx
 12f:	88 10                	mov    %dl,(%eax)
 131:	0f b6 00             	movzbl (%eax),%eax
 134:	84 c0                	test   %al,%al
 136:	75 e2                	jne    11a <strcpy+0xd>
    ;
  return os;
 138:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13b:	c9                   	leave  
 13c:	c3                   	ret    

0000013d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 140:	eb 08                	jmp    14a <strcmp+0xd>
    p++, q++;
 142:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 146:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 14a:	8b 45 08             	mov    0x8(%ebp),%eax
 14d:	0f b6 00             	movzbl (%eax),%eax
 150:	84 c0                	test   %al,%al
 152:	74 10                	je     164 <strcmp+0x27>
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 10             	movzbl (%eax),%edx
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	0f b6 00             	movzbl (%eax),%eax
 160:	38 c2                	cmp    %al,%dl
 162:	74 de                	je     142 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	0f b6 d0             	movzbl %al,%edx
 16d:	8b 45 0c             	mov    0xc(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	0f b6 c0             	movzbl %al,%eax
 176:	29 c2                	sub    %eax,%edx
 178:	89 d0                	mov    %edx,%eax
}
 17a:	5d                   	pop    %ebp
 17b:	c3                   	ret    

0000017c <strlen>:

uint
strlen(char *s)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 182:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 189:	eb 04                	jmp    18f <strlen+0x13>
 18b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 18f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 192:	8b 45 08             	mov    0x8(%ebp),%eax
 195:	01 d0                	add    %edx,%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	84 c0                	test   %al,%al
 19c:	75 ed                	jne    18b <strlen+0xf>
    ;
  return n;
 19e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a1:	c9                   	leave  
 1a2:	c3                   	ret    

000001a3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1a6:	8b 45 10             	mov    0x10(%ebp),%eax
 1a9:	50                   	push   %eax
 1aa:	ff 75 0c             	pushl  0xc(%ebp)
 1ad:	ff 75 08             	pushl  0x8(%ebp)
 1b0:	e8 32 ff ff ff       	call   e7 <stosb>
 1b5:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <strchr>:

char*
strchr(const char *s, char c)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	83 ec 04             	sub    $0x4,%esp
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1c9:	eb 14                	jmp    1df <strchr+0x22>
    if(*s == c)
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	0f b6 00             	movzbl (%eax),%eax
 1d1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1d4:	75 05                	jne    1db <strchr+0x1e>
      return (char*)s;
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	eb 13                	jmp    1ee <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	0f b6 00             	movzbl (%eax),%eax
 1e5:	84 c0                	test   %al,%al
 1e7:	75 e2                	jne    1cb <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ee:	c9                   	leave  
 1ef:	c3                   	ret    

000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1fd:	eb 42                	jmp    241 <gets+0x51>
    cc = read(0, &c, 1);
 1ff:	83 ec 04             	sub    $0x4,%esp
 202:	6a 01                	push   $0x1
 204:	8d 45 ef             	lea    -0x11(%ebp),%eax
 207:	50                   	push   %eax
 208:	6a 00                	push   $0x0
 20a:	e8 d5 01 00 00       	call   3e4 <read>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 215:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 219:	7e 33                	jle    24e <gets+0x5e>
      break;
    buf[i++] = c;
 21b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21e:	8d 50 01             	lea    0x1(%eax),%edx
 221:	89 55 f4             	mov    %edx,-0xc(%ebp)
 224:	89 c2                	mov    %eax,%edx
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	01 c2                	add    %eax,%edx
 22b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 231:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 235:	3c 0a                	cmp    $0xa,%al
 237:	74 16                	je     24f <gets+0x5f>
 239:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23d:	3c 0d                	cmp    $0xd,%al
 23f:	74 0e                	je     24f <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 241:	8b 45 f4             	mov    -0xc(%ebp),%eax
 244:	83 c0 01             	add    $0x1,%eax
 247:	3b 45 0c             	cmp    0xc(%ebp),%eax
 24a:	7c b3                	jl     1ff <gets+0xf>
 24c:	eb 01                	jmp    24f <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 24e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 24f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	01 d0                	add    %edx,%eax
 257:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 25d:	c9                   	leave  
 25e:	c3                   	ret    

0000025f <stat>:

int
stat(char *n, struct stat *st)
{
 25f:	55                   	push   %ebp
 260:	89 e5                	mov    %esp,%ebp
 262:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 265:	83 ec 08             	sub    $0x8,%esp
 268:	6a 00                	push   $0x0
 26a:	ff 75 08             	pushl  0x8(%ebp)
 26d:	e8 9a 01 00 00       	call   40c <open>
 272:	83 c4 10             	add    $0x10,%esp
 275:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 27c:	79 07                	jns    285 <stat+0x26>
    return -1;
 27e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 283:	eb 25                	jmp    2aa <stat+0x4b>
  r = fstat(fd, st);
 285:	83 ec 08             	sub    $0x8,%esp
 288:	ff 75 0c             	pushl  0xc(%ebp)
 28b:	ff 75 f4             	pushl  -0xc(%ebp)
 28e:	e8 91 01 00 00       	call   424 <fstat>
 293:	83 c4 10             	add    $0x10,%esp
 296:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 299:	83 ec 0c             	sub    $0xc,%esp
 29c:	ff 75 f4             	pushl  -0xc(%ebp)
 29f:	e8 50 01 00 00       	call   3f4 <close>
 2a4:	83 c4 10             	add    $0x10,%esp
  return r;
 2a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <atoi>:

int
atoi(const char *s)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2b9:	eb 25                	jmp    2e0 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2be:	89 d0                	mov    %edx,%eax
 2c0:	c1 e0 02             	shl    $0x2,%eax
 2c3:	01 d0                	add    %edx,%eax
 2c5:	01 c0                	add    %eax,%eax
 2c7:	89 c1                	mov    %eax,%ecx
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	8d 50 01             	lea    0x1(%eax),%edx
 2cf:	89 55 08             	mov    %edx,0x8(%ebp)
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	0f be c0             	movsbl %al,%eax
 2d8:	01 c8                	add    %ecx,%eax
 2da:	83 e8 30             	sub    $0x30,%eax
 2dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	0f b6 00             	movzbl (%eax),%eax
 2e6:	3c 2f                	cmp    $0x2f,%al
 2e8:	7e 0a                	jle    2f4 <atoi+0x48>
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	3c 39                	cmp    $0x39,%al
 2f2:	7e c7                	jle    2bb <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <atoo>:

int
atoo(const char *s)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
 2ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
 306:	eb 04                	jmp    30c <atoo+0x13>
        s++;
 308:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	0f b6 00             	movzbl (%eax),%eax
 312:	3c 20                	cmp    $0x20,%al
 314:	74 f2                	je     308 <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	3c 2d                	cmp    $0x2d,%al
 31e:	75 07                	jne    327 <atoo+0x2e>
 320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 325:	eb 05                	jmp    32c <atoo+0x33>
 327:	b8 01 00 00 00       	mov    $0x1,%eax
 32c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	0f b6 00             	movzbl (%eax),%eax
 335:	3c 2b                	cmp    $0x2b,%al
 337:	74 0a                	je     343 <atoo+0x4a>
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	0f b6 00             	movzbl (%eax),%eax
 33f:	3c 2d                	cmp    $0x2d,%al
 341:	75 27                	jne    36a <atoo+0x71>
        s++;
 343:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
 347:	eb 21                	jmp    36a <atoo+0x71>
        n = n*8 + *s++ - '0';
 349:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	8d 50 01             	lea    0x1(%eax),%edx
 359:	89 55 08             	mov    %edx,0x8(%ebp)
 35c:	0f b6 00             	movzbl (%eax),%eax
 35f:	0f be c0             	movsbl %al,%eax
 362:	01 c8                	add    %ecx,%eax
 364:	83 e8 30             	sub    $0x30,%eax
 367:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	0f b6 00             	movzbl (%eax),%eax
 370:	3c 2f                	cmp    $0x2f,%al
 372:	7e 0a                	jle    37e <atoo+0x85>
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	0f b6 00             	movzbl (%eax),%eax
 37a:	3c 37                	cmp    $0x37,%al
 37c:	7e cb                	jle    349 <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
 37e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 381:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 385:	c9                   	leave  
 386:	c3                   	ret    

00000387 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 387:	55                   	push   %ebp
 388:	89 e5                	mov    %esp,%ebp
 38a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 393:	8b 45 0c             	mov    0xc(%ebp),%eax
 396:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 399:	eb 17                	jmp    3b2 <memmove+0x2b>
    *dst++ = *src++;
 39b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 39e:	8d 50 01             	lea    0x1(%eax),%edx
 3a1:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3a7:	8d 4a 01             	lea    0x1(%edx),%ecx
 3aa:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3ad:	0f b6 12             	movzbl (%edx),%edx
 3b0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3b2:	8b 45 10             	mov    0x10(%ebp),%eax
 3b5:	8d 50 ff             	lea    -0x1(%eax),%edx
 3b8:	89 55 10             	mov    %edx,0x10(%ebp)
 3bb:	85 c0                	test   %eax,%eax
 3bd:	7f dc                	jg     39b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c2:	c9                   	leave  
 3c3:	c3                   	ret    

000003c4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3c4:	b8 01 00 00 00       	mov    $0x1,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <exit>:
SYSCALL(exit)
 3cc:	b8 02 00 00 00       	mov    $0x2,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <wait>:
SYSCALL(wait)
 3d4:	b8 03 00 00 00       	mov    $0x3,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <pipe>:
SYSCALL(pipe)
 3dc:	b8 04 00 00 00       	mov    $0x4,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <read>:
SYSCALL(read)
 3e4:	b8 05 00 00 00       	mov    $0x5,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <write>:
SYSCALL(write)
 3ec:	b8 10 00 00 00       	mov    $0x10,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <close>:
SYSCALL(close)
 3f4:	b8 15 00 00 00       	mov    $0x15,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <kill>:
SYSCALL(kill)
 3fc:	b8 06 00 00 00       	mov    $0x6,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <exec>:
SYSCALL(exec)
 404:	b8 07 00 00 00       	mov    $0x7,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <open>:
SYSCALL(open)
 40c:	b8 0f 00 00 00       	mov    $0xf,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <mknod>:
SYSCALL(mknod)
 414:	b8 11 00 00 00       	mov    $0x11,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <unlink>:
SYSCALL(unlink)
 41c:	b8 12 00 00 00       	mov    $0x12,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <fstat>:
SYSCALL(fstat)
 424:	b8 08 00 00 00       	mov    $0x8,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <link>:
SYSCALL(link)
 42c:	b8 13 00 00 00       	mov    $0x13,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <mkdir>:
SYSCALL(mkdir)
 434:	b8 14 00 00 00       	mov    $0x14,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <chdir>:
SYSCALL(chdir)
 43c:	b8 09 00 00 00       	mov    $0x9,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <dup>:
SYSCALL(dup)
 444:	b8 0a 00 00 00       	mov    $0xa,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <getpid>:
SYSCALL(getpid)
 44c:	b8 0b 00 00 00       	mov    $0xb,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <sbrk>:
SYSCALL(sbrk)
 454:	b8 0c 00 00 00       	mov    $0xc,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <sleep>:
SYSCALL(sleep)
 45c:	b8 0d 00 00 00       	mov    $0xd,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <uptime>:
SYSCALL(uptime)
 464:	b8 0e 00 00 00       	mov    $0xe,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <halt>:
SYSCALL(halt)
 46c:	b8 16 00 00 00       	mov    $0x16,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <date>:
SYSCALL(date)
 474:	b8 17 00 00 00       	mov    $0x17,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <getuid>:
SYSCALL(getuid)
 47c:	b8 18 00 00 00       	mov    $0x18,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <getgid>:
SYSCALL(getgid)
 484:	b8 19 00 00 00       	mov    $0x19,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <getppid>:
SYSCALL(getppid)
 48c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <setuid>:
SYSCALL(setuid)
 494:	b8 1b 00 00 00       	mov    $0x1b,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <setgid>:
SYSCALL(setgid)
 49c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <getprocs>:
SYSCALL(getprocs)
 4a4:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <setpriority>:
SYSCALL(setpriority)
 4ac:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <chmod>:
SYSCALL(chmod)
 4b4:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <chown>:
SYSCALL(chown)
 4bc:	b8 20 00 00 00       	mov    $0x20,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <chgrp>:
SYSCALL(chgrp)
 4c4:	b8 21 00 00 00       	mov    $0x21,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	83 ec 18             	sub    $0x18,%esp
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d8:	83 ec 04             	sub    $0x4,%esp
 4db:	6a 01                	push   $0x1
 4dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e0:	50                   	push   %eax
 4e1:	ff 75 08             	pushl  0x8(%ebp)
 4e4:	e8 03 ff ff ff       	call   3ec <write>
 4e9:	83 c4 10             	add    $0x10,%esp
}
 4ec:	90                   	nop
 4ed:	c9                   	leave  
 4ee:	c3                   	ret    

000004ef <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	53                   	push   %ebx
 4f3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 501:	74 17                	je     51a <printint+0x2b>
 503:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 507:	79 11                	jns    51a <printint+0x2b>
    neg = 1;
 509:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 510:	8b 45 0c             	mov    0xc(%ebp),%eax
 513:	f7 d8                	neg    %eax
 515:	89 45 ec             	mov    %eax,-0x14(%ebp)
 518:	eb 06                	jmp    520 <printint+0x31>
  } else {
    x = xx;
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
 51d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 527:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 52a:	8d 41 01             	lea    0x1(%ecx),%eax
 52d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 530:	8b 5d 10             	mov    0x10(%ebp),%ebx
 533:	8b 45 ec             	mov    -0x14(%ebp),%eax
 536:	ba 00 00 00 00       	mov    $0x0,%edx
 53b:	f7 f3                	div    %ebx
 53d:	89 d0                	mov    %edx,%eax
 53f:	0f b6 80 40 0c 00 00 	movzbl 0xc40(%eax),%eax
 546:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 54a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 550:	ba 00 00 00 00       	mov    $0x0,%edx
 555:	f7 f3                	div    %ebx
 557:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55e:	75 c7                	jne    527 <printint+0x38>
  if(neg)
 560:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 564:	74 2d                	je     593 <printint+0xa4>
    buf[i++] = '-';
 566:	8b 45 f4             	mov    -0xc(%ebp),%eax
 569:	8d 50 01             	lea    0x1(%eax),%edx
 56c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 56f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 574:	eb 1d                	jmp    593 <printint+0xa4>
    putc(fd, buf[i]);
 576:	8d 55 dc             	lea    -0x24(%ebp),%edx
 579:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57c:	01 d0                	add    %edx,%eax
 57e:	0f b6 00             	movzbl (%eax),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	83 ec 08             	sub    $0x8,%esp
 587:	50                   	push   %eax
 588:	ff 75 08             	pushl  0x8(%ebp)
 58b:	e8 3c ff ff ff       	call   4cc <putc>
 590:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 593:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59b:	79 d9                	jns    576 <printint+0x87>
    putc(fd, buf[i]);
}
 59d:	90                   	nop
 59e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a1:	c9                   	leave  
 5a2:	c3                   	ret    

000005a3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a3:	55                   	push   %ebp
 5a4:	89 e5                	mov    %esp,%ebp
 5a6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b0:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b3:	83 c0 04             	add    $0x4,%eax
 5b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c0:	e9 59 01 00 00       	jmp    71e <printf+0x17b>
    c = fmt[i] & 0xff;
 5c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cb:	01 d0                	add    %edx,%eax
 5cd:	0f b6 00             	movzbl (%eax),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	25 ff 00 00 00       	and    $0xff,%eax
 5d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5df:	75 2c                	jne    60d <printf+0x6a>
      if(c == '%'){
 5e1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e5:	75 0c                	jne    5f3 <printf+0x50>
        state = '%';
 5e7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ee:	e9 27 01 00 00       	jmp    71a <printf+0x177>
      } else {
        putc(fd, c);
 5f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f6:	0f be c0             	movsbl %al,%eax
 5f9:	83 ec 08             	sub    $0x8,%esp
 5fc:	50                   	push   %eax
 5fd:	ff 75 08             	pushl  0x8(%ebp)
 600:	e8 c7 fe ff ff       	call   4cc <putc>
 605:	83 c4 10             	add    $0x10,%esp
 608:	e9 0d 01 00 00       	jmp    71a <printf+0x177>
      }
    } else if(state == '%'){
 60d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 611:	0f 85 03 01 00 00    	jne    71a <printf+0x177>
      if(c == 'd'){
 617:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 61b:	75 1e                	jne    63b <printf+0x98>
        printint(fd, *ap, 10, 1);
 61d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	6a 01                	push   $0x1
 624:	6a 0a                	push   $0xa
 626:	50                   	push   %eax
 627:	ff 75 08             	pushl  0x8(%ebp)
 62a:	e8 c0 fe ff ff       	call   4ef <printint>
 62f:	83 c4 10             	add    $0x10,%esp
        ap++;
 632:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 636:	e9 d8 00 00 00       	jmp    713 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 63b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 63f:	74 06                	je     647 <printf+0xa4>
 641:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 645:	75 1e                	jne    665 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 647:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	6a 00                	push   $0x0
 64e:	6a 10                	push   $0x10
 650:	50                   	push   %eax
 651:	ff 75 08             	pushl  0x8(%ebp)
 654:	e8 96 fe ff ff       	call   4ef <printint>
 659:	83 c4 10             	add    $0x10,%esp
        ap++;
 65c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 660:	e9 ae 00 00 00       	jmp    713 <printf+0x170>
      } else if(c == 's'){
 665:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 669:	75 43                	jne    6ae <printf+0x10b>
        s = (char*)*ap;
 66b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 673:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67b:	75 25                	jne    6a2 <printf+0xff>
          s = "(null)";
 67d:	c7 45 f4 c6 09 00 00 	movl   $0x9c6,-0xc(%ebp)
        while(*s != 0){
 684:	eb 1c                	jmp    6a2 <printf+0xff>
          putc(fd, *s);
 686:	8b 45 f4             	mov    -0xc(%ebp),%eax
 689:	0f b6 00             	movzbl (%eax),%eax
 68c:	0f be c0             	movsbl %al,%eax
 68f:	83 ec 08             	sub    $0x8,%esp
 692:	50                   	push   %eax
 693:	ff 75 08             	pushl  0x8(%ebp)
 696:	e8 31 fe ff ff       	call   4cc <putc>
 69b:	83 c4 10             	add    $0x10,%esp
          s++;
 69e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a5:	0f b6 00             	movzbl (%eax),%eax
 6a8:	84 c0                	test   %al,%al
 6aa:	75 da                	jne    686 <printf+0xe3>
 6ac:	eb 65                	jmp    713 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ae:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b2:	75 1d                	jne    6d1 <printf+0x12e>
        putc(fd, *ap);
 6b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	0f be c0             	movsbl %al,%eax
 6bc:	83 ec 08             	sub    $0x8,%esp
 6bf:	50                   	push   %eax
 6c0:	ff 75 08             	pushl  0x8(%ebp)
 6c3:	e8 04 fe ff ff       	call   4cc <putc>
 6c8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cf:	eb 42                	jmp    713 <printf+0x170>
      } else if(c == '%'){
 6d1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d5:	75 17                	jne    6ee <printf+0x14b>
        putc(fd, c);
 6d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6da:	0f be c0             	movsbl %al,%eax
 6dd:	83 ec 08             	sub    $0x8,%esp
 6e0:	50                   	push   %eax
 6e1:	ff 75 08             	pushl  0x8(%ebp)
 6e4:	e8 e3 fd ff ff       	call   4cc <putc>
 6e9:	83 c4 10             	add    $0x10,%esp
 6ec:	eb 25                	jmp    713 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ee:	83 ec 08             	sub    $0x8,%esp
 6f1:	6a 25                	push   $0x25
 6f3:	ff 75 08             	pushl  0x8(%ebp)
 6f6:	e8 d1 fd ff ff       	call   4cc <putc>
 6fb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 701:	0f be c0             	movsbl %al,%eax
 704:	83 ec 08             	sub    $0x8,%esp
 707:	50                   	push   %eax
 708:	ff 75 08             	pushl  0x8(%ebp)
 70b:	e8 bc fd ff ff       	call   4cc <putc>
 710:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 713:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 71e:	8b 55 0c             	mov    0xc(%ebp),%edx
 721:	8b 45 f0             	mov    -0x10(%ebp),%eax
 724:	01 d0                	add    %edx,%eax
 726:	0f b6 00             	movzbl (%eax),%eax
 729:	84 c0                	test   %al,%al
 72b:	0f 85 94 fe ff ff    	jne    5c5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 731:	90                   	nop
 732:	c9                   	leave  
 733:	c3                   	ret    

00000734 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73a:	8b 45 08             	mov    0x8(%ebp),%eax
 73d:	83 e8 08             	sub    $0x8,%eax
 740:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 743:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 748:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74b:	eb 24                	jmp    771 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 755:	77 12                	ja     769 <free+0x35>
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75d:	77 24                	ja     783 <free+0x4f>
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 767:	77 1a                	ja     783 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 777:	76 d4                	jbe    74d <free+0x19>
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 781:	76 ca                	jbe    74d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	01 c2                	add    %eax,%edx
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	39 c2                	cmp    %eax,%edx
 79c:	75 24                	jne    7c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	8b 50 04             	mov    0x4(%eax),%edx
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	01 c2                	add    %eax,%edx
 7ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	89 10                	mov    %edx,(%eax)
 7c0:	eb 0a                	jmp    7cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 10                	mov    (%eax),%edx
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	01 d0                	add    %edx,%eax
 7de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e1:	75 20                	jne    803 <free+0xcf>
    p->s.size += bp->s.size;
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 50 04             	mov    0x4(%eax),%edx
 7e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	01 c2                	add    %eax,%edx
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	89 10                	mov    %edx,(%eax)
 801:	eb 08                	jmp    80b <free+0xd7>
  } else
    p->s.ptr = bp;
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	8b 55 f8             	mov    -0x8(%ebp),%edx
 809:	89 10                	mov    %edx,(%eax)
  freep = p;
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	a3 5c 0c 00 00       	mov    %eax,0xc5c
}
 813:	90                   	nop
 814:	c9                   	leave  
 815:	c3                   	ret    

00000816 <morecore>:

static Header*
morecore(uint nu)
{
 816:	55                   	push   %ebp
 817:	89 e5                	mov    %esp,%ebp
 819:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 81c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 823:	77 07                	ja     82c <morecore+0x16>
    nu = 4096;
 825:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 82c:	8b 45 08             	mov    0x8(%ebp),%eax
 82f:	c1 e0 03             	shl    $0x3,%eax
 832:	83 ec 0c             	sub    $0xc,%esp
 835:	50                   	push   %eax
 836:	e8 19 fc ff ff       	call   454 <sbrk>
 83b:	83 c4 10             	add    $0x10,%esp
 83e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 841:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 845:	75 07                	jne    84e <morecore+0x38>
    return 0;
 847:	b8 00 00 00 00       	mov    $0x0,%eax
 84c:	eb 26                	jmp    874 <morecore+0x5e>
  hp = (Header*)p;
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	8b 55 08             	mov    0x8(%ebp),%edx
 85a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 85d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 860:	83 c0 08             	add    $0x8,%eax
 863:	83 ec 0c             	sub    $0xc,%esp
 866:	50                   	push   %eax
 867:	e8 c8 fe ff ff       	call   734 <free>
 86c:	83 c4 10             	add    $0x10,%esp
  return freep;
 86f:	a1 5c 0c 00 00       	mov    0xc5c,%eax
}
 874:	c9                   	leave  
 875:	c3                   	ret    

00000876 <malloc>:

void*
malloc(uint nbytes)
{
 876:	55                   	push   %ebp
 877:	89 e5                	mov    %esp,%ebp
 879:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87c:	8b 45 08             	mov    0x8(%ebp),%eax
 87f:	83 c0 07             	add    $0x7,%eax
 882:	c1 e8 03             	shr    $0x3,%eax
 885:	83 c0 01             	add    $0x1,%eax
 888:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 88b:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 890:	89 45 f0             	mov    %eax,-0x10(%ebp)
 893:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 897:	75 23                	jne    8bc <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 899:	c7 45 f0 54 0c 00 00 	movl   $0xc54,-0x10(%ebp)
 8a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a3:	a3 5c 0c 00 00       	mov    %eax,0xc5c
 8a8:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 8ad:	a3 54 0c 00 00       	mov    %eax,0xc54
    base.s.size = 0;
 8b2:	c7 05 58 0c 00 00 00 	movl   $0x0,0xc58
 8b9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cd:	72 4d                	jb     91c <malloc+0xa6>
      if(p->s.size == nunits)
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	8b 40 04             	mov    0x4(%eax),%eax
 8d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8d8:	75 0c                	jne    8e6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dd:	8b 10                	mov    (%eax),%edx
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	89 10                	mov    %edx,(%eax)
 8e4:	eb 26                	jmp    90c <malloc+0x96>
      else {
        p->s.size -= nunits;
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	8b 40 04             	mov    0x4(%eax),%eax
 8ec:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ef:	89 c2                	mov    %eax,%edx
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	c1 e0 03             	shl    $0x3,%eax
 900:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	8b 55 ec             	mov    -0x14(%ebp),%edx
 909:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 90c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90f:	a3 5c 0c 00 00       	mov    %eax,0xc5c
      return (void*)(p + 1);
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	83 c0 08             	add    $0x8,%eax
 91a:	eb 3b                	jmp    957 <malloc+0xe1>
    }
    if(p == freep)
 91c:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 921:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 924:	75 1e                	jne    944 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 926:	83 ec 0c             	sub    $0xc,%esp
 929:	ff 75 ec             	pushl  -0x14(%ebp)
 92c:	e8 e5 fe ff ff       	call   816 <morecore>
 931:	83 c4 10             	add    $0x10,%esp
 934:	89 45 f4             	mov    %eax,-0xc(%ebp)
 937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 93b:	75 07                	jne    944 <malloc+0xce>
        return 0;
 93d:	b8 00 00 00 00       	mov    $0x0,%eax
 942:	eb 13                	jmp    957 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 944:	8b 45 f4             	mov    -0xc(%ebp),%eax
 947:	89 45 f0             	mov    %eax,-0x10(%ebp)
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	8b 00                	mov    (%eax),%eax
 94f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 952:	e9 6d ff ff ff       	jmp    8c4 <malloc+0x4e>
}
 957:	c9                   	leave  
 958:	c3                   	ret    
