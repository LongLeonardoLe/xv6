
_testSched:     file format elf32-i386


Disassembly of section .text:

00000000 <countForever>:
#define PrioCount 7
#define numChildren 10

void
countForever(int i)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    int j, p, rc;
    unsigned long count = 0;
   6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    j = getpid();
   d:	e8 97 04 00 00       	call   4a9 <getpid>
  12:	89 45 ec             	mov    %eax,-0x14(%ebp)
    p = i%PrioCount;
  15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  18:	ba 93 24 49 92       	mov    $0x92492493,%edx
  1d:	89 c8                	mov    %ecx,%eax
  1f:	f7 ea                	imul   %edx
  21:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  24:	c1 f8 02             	sar    $0x2,%eax
  27:	89 c2                	mov    %eax,%edx
  29:	89 c8                	mov    %ecx,%eax
  2b:	c1 f8 1f             	sar    $0x1f,%eax
  2e:	29 c2                	sub    %eax,%edx
  30:	89 d0                	mov    %edx,%eax
  32:	c1 e0 03             	shl    $0x3,%eax
  35:	29 d0                	sub    %edx,%eax
  37:	29 c1                	sub    %eax,%ecx
  39:	89 c8                	mov    %ecx,%eax
  3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    rc = setpriority(j, p);
  3e:	83 ec 08             	sub    $0x8,%esp
  41:	ff 75 f4             	pushl  -0xc(%ebp)
  44:	ff 75 ec             	pushl  -0x14(%ebp)
  47:	e8 bd 04 00 00       	call   509 <setpriority>
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (rc == 0)
  52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  56:	75 17                	jne    6f <countForever+0x6f>
        printf(1, "%d: start prio %d\n", j, p);
  58:	ff 75 f4             	pushl  -0xc(%ebp)
  5b:	ff 75 ec             	pushl  -0x14(%ebp)
  5e:	68 b8 09 00 00       	push   $0x9b8
  63:	6a 01                	push   $0x1
  65:	e8 96 05 00 00       	call   600 <printf>
  6a:	83 c4 10             	add    $0x10,%esp
  6d:	eb 1b                	jmp    8a <countForever+0x8a>
    else {
        printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
  6f:	6a 13                	push   $0x13
  71:	68 cb 09 00 00       	push   $0x9cb
  76:	68 d8 09 00 00       	push   $0x9d8
  7b:	6a 01                	push   $0x1
  7d:	e8 7e 05 00 00       	call   600 <printf>
  82:	83 c4 10             	add    $0x10,%esp
        exit();
  85:	e8 9f 03 00 00       	call   429 <exit>
    }

    while (1) {
        count++;
  8a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
        if ((count & (0x1FFFFFFF)) == 0) {
  8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  91:	25 ff ff ff 1f       	and    $0x1fffffff,%eax
  96:	85 c0                	test   %eax,%eax
  98:	75 f0                	jne    8a <countForever+0x8a>
            p = (p+1) & PrioCount;
  9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9d:	83 c0 01             	add    $0x1,%eax
  a0:	83 e0 07             	and    $0x7,%eax
  a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
            rc = setpriority(j, p);
  a6:	83 ec 08             	sub    $0x8,%esp
  a9:	ff 75 f4             	pushl  -0xc(%ebp)
  ac:	ff 75 ec             	pushl  -0x14(%ebp)
  af:	e8 55 04 00 00       	call   509 <setpriority>
  b4:	83 c4 10             	add    $0x10,%esp
  b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (rc == 0)
  ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  be:	75 17                	jne    d7 <countForever+0xd7>
                printf(1, "%d: start prio %d\n", j, p);
  c0:	ff 75 f4             	pushl  -0xc(%ebp)
  c3:	ff 75 ec             	pushl  -0x14(%ebp)
  c6:	68 b8 09 00 00       	push   $0x9b8
  cb:	6a 01                	push   $0x1
  cd:	e8 2e 05 00 00       	call   600 <printf>
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	eb b3                	jmp    8a <countForever+0x8a>
            else {
                printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
  d7:	6a 1f                	push   $0x1f
  d9:	68 cb 09 00 00       	push   $0x9cb
  de:	68 d8 09 00 00       	push   $0x9d8
  e3:	6a 01                	push   $0x1
  e5:	e8 16 05 00 00       	call   600 <printf>
  ea:	83 c4 10             	add    $0x10,%esp
                exit();
  ed:	e8 37 03 00 00       	call   429 <exit>

000000f2 <main>:
    }
}

int
main(void)
{ 
  f2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f6:	83 e4 f0             	and    $0xfffffff0,%esp
  f9:	ff 71 fc             	pushl  -0x4(%ecx)
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	51                   	push   %ecx
 100:	83 ec 14             	sub    $0x14,%esp
    int i, rc;
    for (i = 0; i < numChildren; i++) {
 103:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 10a:	eb 20                	jmp    12c <main+0x3a>
        rc = fork();
 10c:	e8 10 03 00 00       	call   421 <fork>
 111:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (!rc) {
 114:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 118:	75 0e                	jne    128 <main+0x36>
            countForever(i);
 11a:	83 ec 0c             	sub    $0xc,%esp
 11d:	ff 75 f4             	pushl  -0xc(%ebp)
 120:	e8 db fe ff ff       	call   0 <countForever>
 125:	83 c4 10             	add    $0x10,%esp

int
main(void)
{ 
    int i, rc;
    for (i = 0; i < numChildren; i++) {
 128:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 12c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 130:	7e da                	jle    10c <main+0x1a>
        if (!rc) {
            countForever(i);
        }
    }
    
    countForever(1);
 132:	83 ec 0c             	sub    $0xc,%esp
 135:	6a 01                	push   $0x1
 137:	e8 c4 fe ff ff       	call   0 <countForever>
 13c:	83 c4 10             	add    $0x10,%esp
    exit();
 13f:	e8 e5 02 00 00       	call   429 <exit>

00000144 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	57                   	push   %edi
 148:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 149:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14c:	8b 55 10             	mov    0x10(%ebp),%edx
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	89 cb                	mov    %ecx,%ebx
 154:	89 df                	mov    %ebx,%edi
 156:	89 d1                	mov    %edx,%ecx
 158:	fc                   	cld    
 159:	f3 aa                	rep stos %al,%es:(%edi)
 15b:	89 ca                	mov    %ecx,%edx
 15d:	89 fb                	mov    %edi,%ebx
 15f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 162:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 165:	90                   	nop
 166:	5b                   	pop    %ebx
 167:	5f                   	pop    %edi
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    

0000016a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 176:	90                   	nop
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	8d 50 01             	lea    0x1(%eax),%edx
 17d:	89 55 08             	mov    %edx,0x8(%ebp)
 180:	8b 55 0c             	mov    0xc(%ebp),%edx
 183:	8d 4a 01             	lea    0x1(%edx),%ecx
 186:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 189:	0f b6 12             	movzbl (%edx),%edx
 18c:	88 10                	mov    %dl,(%eax)
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	84 c0                	test   %al,%al
 193:	75 e2                	jne    177 <strcpy+0xd>
    ;
  return os;
 195:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 198:	c9                   	leave  
 199:	c3                   	ret    

0000019a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 19d:	eb 08                	jmp    1a7 <strcmp+0xd>
    p++, q++;
 19f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	84 c0                	test   %al,%al
 1af:	74 10                	je     1c1 <strcmp+0x27>
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	0f b6 10             	movzbl (%eax),%edx
 1b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ba:	0f b6 00             	movzbl (%eax),%eax
 1bd:	38 c2                	cmp    %al,%dl
 1bf:	74 de                	je     19f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	0f b6 d0             	movzbl %al,%edx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	0f b6 00             	movzbl (%eax),%eax
 1d0:	0f b6 c0             	movzbl %al,%eax
 1d3:	29 c2                	sub    %eax,%edx
 1d5:	89 d0                	mov    %edx,%eax
}
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    

000001d9 <strlen>:

uint
strlen(char *s)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e6:	eb 04                	jmp    1ec <strlen+0x13>
 1e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	01 d0                	add    %edx,%eax
 1f4:	0f b6 00             	movzbl (%eax),%eax
 1f7:	84 c0                	test   %al,%al
 1f9:	75 ed                	jne    1e8 <strlen+0xf>
    ;
  return n;
 1fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 203:	8b 45 10             	mov    0x10(%ebp),%eax
 206:	50                   	push   %eax
 207:	ff 75 0c             	pushl  0xc(%ebp)
 20a:	ff 75 08             	pushl  0x8(%ebp)
 20d:	e8 32 ff ff ff       	call   144 <stosb>
 212:	83 c4 0c             	add    $0xc,%esp
  return dst;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <strchr>:

char*
strchr(const char *s, char c)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 04             	sub    $0x4,%esp
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 226:	eb 14                	jmp    23c <strchr+0x22>
    if(*s == c)
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 00             	movzbl (%eax),%eax
 22e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 231:	75 05                	jne    238 <strchr+0x1e>
      return (char*)s;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	eb 13                	jmp    24b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	0f b6 00             	movzbl (%eax),%eax
 242:	84 c0                	test   %al,%al
 244:	75 e2                	jne    228 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 246:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24b:	c9                   	leave  
 24c:	c3                   	ret    

0000024d <gets>:

char*
gets(char *buf, int max)
{
 24d:	55                   	push   %ebp
 24e:	89 e5                	mov    %esp,%ebp
 250:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25a:	eb 42                	jmp    29e <gets+0x51>
    cc = read(0, &c, 1);
 25c:	83 ec 04             	sub    $0x4,%esp
 25f:	6a 01                	push   $0x1
 261:	8d 45 ef             	lea    -0x11(%ebp),%eax
 264:	50                   	push   %eax
 265:	6a 00                	push   $0x0
 267:	e8 d5 01 00 00       	call   441 <read>
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 272:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 276:	7e 33                	jle    2ab <gets+0x5e>
      break;
    buf[i++] = c;
 278:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27b:	8d 50 01             	lea    0x1(%eax),%edx
 27e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 281:	89 c2                	mov    %eax,%edx
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	01 c2                	add    %eax,%edx
 288:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 28c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 28e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 292:	3c 0a                	cmp    $0xa,%al
 294:	74 16                	je     2ac <gets+0x5f>
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	3c 0d                	cmp    $0xd,%al
 29c:	74 0e                	je     2ac <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a1:	83 c0 01             	add    $0x1,%eax
 2a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2a7:	7c b3                	jl     25c <gets+0xf>
 2a9:	eb 01                	jmp    2ac <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2ab:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <stat>:

int
stat(char *n, struct stat *st)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c2:	83 ec 08             	sub    $0x8,%esp
 2c5:	6a 00                	push   $0x0
 2c7:	ff 75 08             	pushl  0x8(%ebp)
 2ca:	e8 9a 01 00 00       	call   469 <open>
 2cf:	83 c4 10             	add    $0x10,%esp
 2d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2d9:	79 07                	jns    2e2 <stat+0x26>
    return -1;
 2db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e0:	eb 25                	jmp    307 <stat+0x4b>
  r = fstat(fd, st);
 2e2:	83 ec 08             	sub    $0x8,%esp
 2e5:	ff 75 0c             	pushl  0xc(%ebp)
 2e8:	ff 75 f4             	pushl  -0xc(%ebp)
 2eb:	e8 91 01 00 00       	call   481 <fstat>
 2f0:	83 c4 10             	add    $0x10,%esp
 2f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2f6:	83 ec 0c             	sub    $0xc,%esp
 2f9:	ff 75 f4             	pushl  -0xc(%ebp)
 2fc:	e8 50 01 00 00       	call   451 <close>
 301:	83 c4 10             	add    $0x10,%esp
  return r;
 304:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 307:	c9                   	leave  
 308:	c3                   	ret    

00000309 <atoi>:

int
atoi(const char *s)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 30f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 316:	eb 25                	jmp    33d <atoi+0x34>
    n = n*10 + *s++ - '0';
 318:	8b 55 fc             	mov    -0x4(%ebp),%edx
 31b:	89 d0                	mov    %edx,%eax
 31d:	c1 e0 02             	shl    $0x2,%eax
 320:	01 d0                	add    %edx,%eax
 322:	01 c0                	add    %eax,%eax
 324:	89 c1                	mov    %eax,%ecx
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	8d 50 01             	lea    0x1(%eax),%edx
 32c:	89 55 08             	mov    %edx,0x8(%ebp)
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	0f be c0             	movsbl %al,%eax
 335:	01 c8                	add    %ecx,%eax
 337:	83 e8 30             	sub    $0x30,%eax
 33a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	0f b6 00             	movzbl (%eax),%eax
 343:	3c 2f                	cmp    $0x2f,%al
 345:	7e 0a                	jle    351 <atoi+0x48>
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	0f b6 00             	movzbl (%eax),%eax
 34d:	3c 39                	cmp    $0x39,%al
 34f:	7e c7                	jle    318 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 351:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 354:	c9                   	leave  
 355:	c3                   	ret    

00000356 <atoo>:

int
atoo(const char *s)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
 35c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
 363:	eb 04                	jmp    369 <atoo+0x13>
        s++;
 365:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	0f b6 00             	movzbl (%eax),%eax
 36f:	3c 20                	cmp    $0x20,%al
 371:	74 f2                	je     365 <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	0f b6 00             	movzbl (%eax),%eax
 379:	3c 2d                	cmp    $0x2d,%al
 37b:	75 07                	jne    384 <atoo+0x2e>
 37d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 382:	eb 05                	jmp    389 <atoo+0x33>
 384:	b8 01 00 00 00       	mov    $0x1,%eax
 389:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	0f b6 00             	movzbl (%eax),%eax
 392:	3c 2b                	cmp    $0x2b,%al
 394:	74 0a                	je     3a0 <atoo+0x4a>
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	3c 2d                	cmp    $0x2d,%al
 39e:	75 27                	jne    3c7 <atoo+0x71>
        s++;
 3a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
 3a4:	eb 21                	jmp    3c7 <atoo+0x71>
        n = n*8 + *s++ - '0';
 3a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
 3b3:	8d 50 01             	lea    0x1(%eax),%edx
 3b6:	89 55 08             	mov    %edx,0x8(%ebp)
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	0f be c0             	movsbl %al,%eax
 3bf:	01 c8                	add    %ecx,%eax
 3c1:	83 e8 30             	sub    $0x30,%eax
 3c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 2f                	cmp    $0x2f,%al
 3cf:	7e 0a                	jle    3db <atoo+0x85>
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	3c 37                	cmp    $0x37,%al
 3d9:	7e cb                	jle    3a6 <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
 3db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3de:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3e2:	c9                   	leave  
 3e3:	c3                   	ret    

000003e4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f6:	eb 17                	jmp    40f <memmove+0x2b>
    *dst++ = *src++;
 3f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fb:	8d 50 01             	lea    0x1(%eax),%edx
 3fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
 401:	8b 55 f8             	mov    -0x8(%ebp),%edx
 404:	8d 4a 01             	lea    0x1(%edx),%ecx
 407:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 40a:	0f b6 12             	movzbl (%edx),%edx
 40d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 40f:	8b 45 10             	mov    0x10(%ebp),%eax
 412:	8d 50 ff             	lea    -0x1(%eax),%edx
 415:	89 55 10             	mov    %edx,0x10(%ebp)
 418:	85 c0                	test   %eax,%eax
 41a:	7f dc                	jg     3f8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41f:	c9                   	leave  
 420:	c3                   	ret    

00000421 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 421:	b8 01 00 00 00       	mov    $0x1,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <exit>:
SYSCALL(exit)
 429:	b8 02 00 00 00       	mov    $0x2,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <wait>:
SYSCALL(wait)
 431:	b8 03 00 00 00       	mov    $0x3,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <pipe>:
SYSCALL(pipe)
 439:	b8 04 00 00 00       	mov    $0x4,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <read>:
SYSCALL(read)
 441:	b8 05 00 00 00       	mov    $0x5,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <write>:
SYSCALL(write)
 449:	b8 10 00 00 00       	mov    $0x10,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <close>:
SYSCALL(close)
 451:	b8 15 00 00 00       	mov    $0x15,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <kill>:
SYSCALL(kill)
 459:	b8 06 00 00 00       	mov    $0x6,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <exec>:
SYSCALL(exec)
 461:	b8 07 00 00 00       	mov    $0x7,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <open>:
SYSCALL(open)
 469:	b8 0f 00 00 00       	mov    $0xf,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <mknod>:
SYSCALL(mknod)
 471:	b8 11 00 00 00       	mov    $0x11,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <unlink>:
SYSCALL(unlink)
 479:	b8 12 00 00 00       	mov    $0x12,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <fstat>:
SYSCALL(fstat)
 481:	b8 08 00 00 00       	mov    $0x8,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <link>:
SYSCALL(link)
 489:	b8 13 00 00 00       	mov    $0x13,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <mkdir>:
SYSCALL(mkdir)
 491:	b8 14 00 00 00       	mov    $0x14,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <chdir>:
SYSCALL(chdir)
 499:	b8 09 00 00 00       	mov    $0x9,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <dup>:
SYSCALL(dup)
 4a1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <getpid>:
SYSCALL(getpid)
 4a9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <sbrk>:
SYSCALL(sbrk)
 4b1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <sleep>:
SYSCALL(sleep)
 4b9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <uptime>:
SYSCALL(uptime)
 4c1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <halt>:
SYSCALL(halt)
 4c9:	b8 16 00 00 00       	mov    $0x16,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <date>:
SYSCALL(date)
 4d1:	b8 17 00 00 00       	mov    $0x17,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <getuid>:
SYSCALL(getuid)
 4d9:	b8 18 00 00 00       	mov    $0x18,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <getgid>:
SYSCALL(getgid)
 4e1:	b8 19 00 00 00       	mov    $0x19,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <getppid>:
SYSCALL(getppid)
 4e9:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <setuid>:
SYSCALL(setuid)
 4f1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <setgid>:
SYSCALL(setgid)
 4f9:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <getprocs>:
SYSCALL(getprocs)
 501:	b8 1d 00 00 00       	mov    $0x1d,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <setpriority>:
SYSCALL(setpriority)
 509:	b8 1e 00 00 00       	mov    $0x1e,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <chmod>:
SYSCALL(chmod)
 511:	b8 1f 00 00 00       	mov    $0x1f,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <chown>:
SYSCALL(chown)
 519:	b8 20 00 00 00       	mov    $0x20,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <chgrp>:
SYSCALL(chgrp)
 521:	b8 21 00 00 00       	mov    $0x21,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 529:	55                   	push   %ebp
 52a:	89 e5                	mov    %esp,%ebp
 52c:	83 ec 18             	sub    $0x18,%esp
 52f:	8b 45 0c             	mov    0xc(%ebp),%eax
 532:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 535:	83 ec 04             	sub    $0x4,%esp
 538:	6a 01                	push   $0x1
 53a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 53d:	50                   	push   %eax
 53e:	ff 75 08             	pushl  0x8(%ebp)
 541:	e8 03 ff ff ff       	call   449 <write>
 546:	83 c4 10             	add    $0x10,%esp
}
 549:	90                   	nop
 54a:	c9                   	leave  
 54b:	c3                   	ret    

0000054c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 54c:	55                   	push   %ebp
 54d:	89 e5                	mov    %esp,%ebp
 54f:	53                   	push   %ebx
 550:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 553:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 55a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 55e:	74 17                	je     577 <printint+0x2b>
 560:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 564:	79 11                	jns    577 <printint+0x2b>
    neg = 1;
 566:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 56d:	8b 45 0c             	mov    0xc(%ebp),%eax
 570:	f7 d8                	neg    %eax
 572:	89 45 ec             	mov    %eax,-0x14(%ebp)
 575:	eb 06                	jmp    57d <printint+0x31>
  } else {
    x = xx;
 577:	8b 45 0c             	mov    0xc(%ebp),%eax
 57a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 57d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 584:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 587:	8d 41 01             	lea    0x1(%ecx),%eax
 58a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 58d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 590:	8b 45 ec             	mov    -0x14(%ebp),%eax
 593:	ba 00 00 00 00       	mov    $0x0,%edx
 598:	f7 f3                	div    %ebx
 59a:	89 d0                	mov    %edx,%eax
 59c:	0f b6 80 88 0c 00 00 	movzbl 0xc88(%eax),%eax
 5a3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ad:	ba 00 00 00 00       	mov    $0x0,%edx
 5b2:	f7 f3                	div    %ebx
 5b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bb:	75 c7                	jne    584 <printint+0x38>
  if(neg)
 5bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c1:	74 2d                	je     5f0 <printint+0xa4>
    buf[i++] = '-';
 5c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c6:	8d 50 01             	lea    0x1(%eax),%edx
 5c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5cc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5d1:	eb 1d                	jmp    5f0 <printint+0xa4>
    putc(fd, buf[i]);
 5d3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d9:	01 d0                	add    %edx,%eax
 5db:	0f b6 00             	movzbl (%eax),%eax
 5de:	0f be c0             	movsbl %al,%eax
 5e1:	83 ec 08             	sub    $0x8,%esp
 5e4:	50                   	push   %eax
 5e5:	ff 75 08             	pushl  0x8(%ebp)
 5e8:	e8 3c ff ff ff       	call   529 <putc>
 5ed:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f8:	79 d9                	jns    5d3 <printint+0x87>
    putc(fd, buf[i]);
}
 5fa:	90                   	nop
 5fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5fe:	c9                   	leave  
 5ff:	c3                   	ret    

00000600 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 606:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 60d:	8d 45 0c             	lea    0xc(%ebp),%eax
 610:	83 c0 04             	add    $0x4,%eax
 613:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 616:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 61d:	e9 59 01 00 00       	jmp    77b <printf+0x17b>
    c = fmt[i] & 0xff;
 622:	8b 55 0c             	mov    0xc(%ebp),%edx
 625:	8b 45 f0             	mov    -0x10(%ebp),%eax
 628:	01 d0                	add    %edx,%eax
 62a:	0f b6 00             	movzbl (%eax),%eax
 62d:	0f be c0             	movsbl %al,%eax
 630:	25 ff 00 00 00       	and    $0xff,%eax
 635:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 638:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 63c:	75 2c                	jne    66a <printf+0x6a>
      if(c == '%'){
 63e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 642:	75 0c                	jne    650 <printf+0x50>
        state = '%';
 644:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 64b:	e9 27 01 00 00       	jmp    777 <printf+0x177>
      } else {
        putc(fd, c);
 650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	83 ec 08             	sub    $0x8,%esp
 659:	50                   	push   %eax
 65a:	ff 75 08             	pushl  0x8(%ebp)
 65d:	e8 c7 fe ff ff       	call   529 <putc>
 662:	83 c4 10             	add    $0x10,%esp
 665:	e9 0d 01 00 00       	jmp    777 <printf+0x177>
      }
    } else if(state == '%'){
 66a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 66e:	0f 85 03 01 00 00    	jne    777 <printf+0x177>
      if(c == 'd'){
 674:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 678:	75 1e                	jne    698 <printf+0x98>
        printint(fd, *ap, 10, 1);
 67a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	6a 01                	push   $0x1
 681:	6a 0a                	push   $0xa
 683:	50                   	push   %eax
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 c0 fe ff ff       	call   54c <printint>
 68c:	83 c4 10             	add    $0x10,%esp
        ap++;
 68f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 693:	e9 d8 00 00 00       	jmp    770 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 698:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 69c:	74 06                	je     6a4 <printf+0xa4>
 69e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6a2:	75 1e                	jne    6c2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	6a 00                	push   $0x0
 6ab:	6a 10                	push   $0x10
 6ad:	50                   	push   %eax
 6ae:	ff 75 08             	pushl  0x8(%ebp)
 6b1:	e8 96 fe ff ff       	call   54c <printint>
 6b6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bd:	e9 ae 00 00 00       	jmp    770 <printf+0x170>
      } else if(c == 's'){
 6c2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6c6:	75 43                	jne    70b <printf+0x10b>
        s = (char*)*ap;
 6c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6cb:	8b 00                	mov    (%eax),%eax
 6cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d8:	75 25                	jne    6ff <printf+0xff>
          s = "(null)";
 6da:	c7 45 f4 fb 09 00 00 	movl   $0x9fb,-0xc(%ebp)
        while(*s != 0){
 6e1:	eb 1c                	jmp    6ff <printf+0xff>
          putc(fd, *s);
 6e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e6:	0f b6 00             	movzbl (%eax),%eax
 6e9:	0f be c0             	movsbl %al,%eax
 6ec:	83 ec 08             	sub    $0x8,%esp
 6ef:	50                   	push   %eax
 6f0:	ff 75 08             	pushl  0x8(%ebp)
 6f3:	e8 31 fe ff ff       	call   529 <putc>
 6f8:	83 c4 10             	add    $0x10,%esp
          s++;
 6fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 702:	0f b6 00             	movzbl (%eax),%eax
 705:	84 c0                	test   %al,%al
 707:	75 da                	jne    6e3 <printf+0xe3>
 709:	eb 65                	jmp    770 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 70b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 70f:	75 1d                	jne    72e <printf+0x12e>
        putc(fd, *ap);
 711:	8b 45 e8             	mov    -0x18(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	0f be c0             	movsbl %al,%eax
 719:	83 ec 08             	sub    $0x8,%esp
 71c:	50                   	push   %eax
 71d:	ff 75 08             	pushl  0x8(%ebp)
 720:	e8 04 fe ff ff       	call   529 <putc>
 725:	83 c4 10             	add    $0x10,%esp
        ap++;
 728:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72c:	eb 42                	jmp    770 <printf+0x170>
      } else if(c == '%'){
 72e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 732:	75 17                	jne    74b <printf+0x14b>
        putc(fd, c);
 734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 737:	0f be c0             	movsbl %al,%eax
 73a:	83 ec 08             	sub    $0x8,%esp
 73d:	50                   	push   %eax
 73e:	ff 75 08             	pushl  0x8(%ebp)
 741:	e8 e3 fd ff ff       	call   529 <putc>
 746:	83 c4 10             	add    $0x10,%esp
 749:	eb 25                	jmp    770 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 74b:	83 ec 08             	sub    $0x8,%esp
 74e:	6a 25                	push   $0x25
 750:	ff 75 08             	pushl  0x8(%ebp)
 753:	e8 d1 fd ff ff       	call   529 <putc>
 758:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 75b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75e:	0f be c0             	movsbl %al,%eax
 761:	83 ec 08             	sub    $0x8,%esp
 764:	50                   	push   %eax
 765:	ff 75 08             	pushl  0x8(%ebp)
 768:	e8 bc fd ff ff       	call   529 <putc>
 76d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 770:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 777:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 77b:	8b 55 0c             	mov    0xc(%ebp),%edx
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	01 d0                	add    %edx,%eax
 783:	0f b6 00             	movzbl (%eax),%eax
 786:	84 c0                	test   %al,%al
 788:	0f 85 94 fe ff ff    	jne    622 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 78e:	90                   	nop
 78f:	c9                   	leave  
 790:	c3                   	ret    

00000791 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 791:	55                   	push   %ebp
 792:	89 e5                	mov    %esp,%ebp
 794:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 797:	8b 45 08             	mov    0x8(%ebp),%eax
 79a:	83 e8 08             	sub    $0x8,%eax
 79d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	a1 a4 0c 00 00       	mov    0xca4,%eax
 7a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a8:	eb 24                	jmp    7ce <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b2:	77 12                	ja     7c6 <free+0x35>
 7b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ba:	77 24                	ja     7e0 <free+0x4f>
 7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c4:	77 1a                	ja     7e0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	8b 00                	mov    (%eax),%eax
 7cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d4:	76 d4                	jbe    7aa <free+0x19>
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	8b 00                	mov    (%eax),%eax
 7db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7de:	76 ca                	jbe    7aa <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f0:	01 c2                	add    %eax,%edx
 7f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	39 c2                	cmp    %eax,%edx
 7f9:	75 24                	jne    81f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	8b 50 04             	mov    0x4(%eax),%edx
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	8b 00                	mov    (%eax),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	01 c2                	add    %eax,%edx
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	8b 10                	mov    (%eax),%edx
 818:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81b:	89 10                	mov    %edx,(%eax)
 81d:	eb 0a                	jmp    829 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 10                	mov    (%eax),%edx
 824:	8b 45 f8             	mov    -0x8(%ebp),%eax
 827:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	8b 40 04             	mov    0x4(%eax),%eax
 82f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	01 d0                	add    %edx,%eax
 83b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 83e:	75 20                	jne    860 <free+0xcf>
    p->s.size += bp->s.size;
 840:	8b 45 fc             	mov    -0x4(%ebp),%eax
 843:	8b 50 04             	mov    0x4(%eax),%edx
 846:	8b 45 f8             	mov    -0x8(%ebp),%eax
 849:	8b 40 04             	mov    0x4(%eax),%eax
 84c:	01 c2                	add    %eax,%edx
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 854:	8b 45 f8             	mov    -0x8(%ebp),%eax
 857:	8b 10                	mov    (%eax),%edx
 859:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85c:	89 10                	mov    %edx,(%eax)
 85e:	eb 08                	jmp    868 <free+0xd7>
  } else
    p->s.ptr = bp;
 860:	8b 45 fc             	mov    -0x4(%ebp),%eax
 863:	8b 55 f8             	mov    -0x8(%ebp),%edx
 866:	89 10                	mov    %edx,(%eax)
  freep = p;
 868:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86b:	a3 a4 0c 00 00       	mov    %eax,0xca4
}
 870:	90                   	nop
 871:	c9                   	leave  
 872:	c3                   	ret    

00000873 <morecore>:

static Header*
morecore(uint nu)
{
 873:	55                   	push   %ebp
 874:	89 e5                	mov    %esp,%ebp
 876:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 879:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 880:	77 07                	ja     889 <morecore+0x16>
    nu = 4096;
 882:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 889:	8b 45 08             	mov    0x8(%ebp),%eax
 88c:	c1 e0 03             	shl    $0x3,%eax
 88f:	83 ec 0c             	sub    $0xc,%esp
 892:	50                   	push   %eax
 893:	e8 19 fc ff ff       	call   4b1 <sbrk>
 898:	83 c4 10             	add    $0x10,%esp
 89b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 89e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8a2:	75 07                	jne    8ab <morecore+0x38>
    return 0;
 8a4:	b8 00 00 00 00       	mov    $0x0,%eax
 8a9:	eb 26                	jmp    8d1 <morecore+0x5e>
  hp = (Header*)p;
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	8b 55 08             	mov    0x8(%ebp),%edx
 8b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	83 c0 08             	add    $0x8,%eax
 8c0:	83 ec 0c             	sub    $0xc,%esp
 8c3:	50                   	push   %eax
 8c4:	e8 c8 fe ff ff       	call   791 <free>
 8c9:	83 c4 10             	add    $0x10,%esp
  return freep;
 8cc:	a1 a4 0c 00 00       	mov    0xca4,%eax
}
 8d1:	c9                   	leave  
 8d2:	c3                   	ret    

000008d3 <malloc>:

void*
malloc(uint nbytes)
{
 8d3:	55                   	push   %ebp
 8d4:	89 e5                	mov    %esp,%ebp
 8d6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d9:	8b 45 08             	mov    0x8(%ebp),%eax
 8dc:	83 c0 07             	add    $0x7,%eax
 8df:	c1 e8 03             	shr    $0x3,%eax
 8e2:	83 c0 01             	add    $0x1,%eax
 8e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8e8:	a1 a4 0c 00 00       	mov    0xca4,%eax
 8ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8f4:	75 23                	jne    919 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8f6:	c7 45 f0 9c 0c 00 00 	movl   $0xc9c,-0x10(%ebp)
 8fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 900:	a3 a4 0c 00 00       	mov    %eax,0xca4
 905:	a1 a4 0c 00 00       	mov    0xca4,%eax
 90a:	a3 9c 0c 00 00       	mov    %eax,0xc9c
    base.s.size = 0;
 90f:	c7 05 a0 0c 00 00 00 	movl   $0x0,0xca0
 916:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 919:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 924:	8b 40 04             	mov    0x4(%eax),%eax
 927:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 92a:	72 4d                	jb     979 <malloc+0xa6>
      if(p->s.size == nunits)
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	8b 40 04             	mov    0x4(%eax),%eax
 932:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 935:	75 0c                	jne    943 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 937:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93a:	8b 10                	mov    (%eax),%edx
 93c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93f:	89 10                	mov    %edx,(%eax)
 941:	eb 26                	jmp    969 <malloc+0x96>
      else {
        p->s.size -= nunits;
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	8b 40 04             	mov    0x4(%eax),%eax
 949:	2b 45 ec             	sub    -0x14(%ebp),%eax
 94c:	89 c2                	mov    %eax,%edx
 94e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 951:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 954:	8b 45 f4             	mov    -0xc(%ebp),%eax
 957:	8b 40 04             	mov    0x4(%eax),%eax
 95a:	c1 e0 03             	shl    $0x3,%eax
 95d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 960:	8b 45 f4             	mov    -0xc(%ebp),%eax
 963:	8b 55 ec             	mov    -0x14(%ebp),%edx
 966:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 969:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96c:	a3 a4 0c 00 00       	mov    %eax,0xca4
      return (void*)(p + 1);
 971:	8b 45 f4             	mov    -0xc(%ebp),%eax
 974:	83 c0 08             	add    $0x8,%eax
 977:	eb 3b                	jmp    9b4 <malloc+0xe1>
    }
    if(p == freep)
 979:	a1 a4 0c 00 00       	mov    0xca4,%eax
 97e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 981:	75 1e                	jne    9a1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 983:	83 ec 0c             	sub    $0xc,%esp
 986:	ff 75 ec             	pushl  -0x14(%ebp)
 989:	e8 e5 fe ff ff       	call   873 <morecore>
 98e:	83 c4 10             	add    $0x10,%esp
 991:	89 45 f4             	mov    %eax,-0xc(%ebp)
 994:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 998:	75 07                	jne    9a1 <malloc+0xce>
        return 0;
 99a:	b8 00 00 00 00       	mov    $0x0,%eax
 99f:	eb 13                	jmp    9b4 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9aa:	8b 00                	mov    (%eax),%eax
 9ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9af:	e9 6d ff ff ff       	jmp    921 <malloc+0x4e>
}
 9b4:	c9                   	leave  
 9b5:	c3                   	ret    
