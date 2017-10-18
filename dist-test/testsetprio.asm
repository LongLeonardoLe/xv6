
_testsetprio:     file format elf32-i386


Disassembly of section .text:

00000000 <testInvalid>:
#define TPS 100


void
testInvalid(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    int pid, value, rc;

    pid = -1;
   6:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    value = 1;
   d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    printf(1, "%d: setting priority to %d\n", pid, value);
  14:	ff 75 f0             	pushl  -0x10(%ebp)
  17:	ff 75 f4             	pushl  -0xc(%ebp)
  1a:	68 6e 0a 00 00       	push   $0xa6e
  1f:	6a 01                	push   $0x1
  21:	e8 92 06 00 00       	call   6b8 <printf>
  26:	83 c4 10             	add    $0x10,%esp
    rc = setpriority(pid, value);
  29:	83 ec 08             	sub    $0x8,%esp
  2c:	ff 75 f0             	pushl  -0x10(%ebp)
  2f:	ff 75 f4             	pushl  -0xc(%ebp)
  32:	e8 8a 05 00 00       	call   5c1 <setpriority>
  37:	83 c4 10             	add    $0x10,%esp
  3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (rc < 0)
  3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  41:	79 14                	jns    57 <testInvalid+0x57>
        printf(2, "Failed setting priority!\n");
  43:	83 ec 08             	sub    $0x8,%esp
  46:	68 8a 0a 00 00       	push   $0xa8a
  4b:	6a 02                	push   $0x2
  4d:	e8 66 06 00 00       	call   6b8 <printf>
  52:	83 c4 10             	add    $0x10,%esp
  55:	eb 15                	jmp    6c <testInvalid+0x6c>
    else printf(1, "Change priority of %d to %d\n", pid, value);
  57:	ff 75 f0             	pushl  -0x10(%ebp)
  5a:	ff 75 f4             	pushl  -0xc(%ebp)
  5d:	68 a4 0a 00 00       	push   $0xaa4
  62:	6a 01                	push   $0x1
  64:	e8 4f 06 00 00       	call   6b8 <printf>
  69:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);
  6c:	83 ec 0c             	sub    $0xc,%esp
  6f:	68 f4 01 00 00       	push   $0x1f4
  74:	e8 f8 04 00 00       	call   571 <sleep>
  79:	83 c4 10             	add    $0x10,%esp

    pid = 1;
  7c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    value = -1;
  83:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    printf(1, "%d: setting priority to %d\n", pid, value);
  8a:	ff 75 f0             	pushl  -0x10(%ebp)
  8d:	ff 75 f4             	pushl  -0xc(%ebp)
  90:	68 6e 0a 00 00       	push   $0xa6e
  95:	6a 01                	push   $0x1
  97:	e8 1c 06 00 00       	call   6b8 <printf>
  9c:	83 c4 10             	add    $0x10,%esp
    rc = setpriority(pid, value);
  9f:	83 ec 08             	sub    $0x8,%esp
  a2:	ff 75 f0             	pushl  -0x10(%ebp)
  a5:	ff 75 f4             	pushl  -0xc(%ebp)
  a8:	e8 14 05 00 00       	call   5c1 <setpriority>
  ad:	83 c4 10             	add    $0x10,%esp
  b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (rc < 0)
  b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  b7:	79 14                	jns    cd <testInvalid+0xcd>
        printf(2, "Failed setting priority!\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 8a 0a 00 00       	push   $0xa8a
  c1:	6a 02                	push   $0x2
  c3:	e8 f0 05 00 00       	call   6b8 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
  cb:	eb 15                	jmp    e2 <testInvalid+0xe2>
    else printf(1, "Change priority of %d to %d\n", pid, value);
  cd:	ff 75 f0             	pushl  -0x10(%ebp)
  d0:	ff 75 f4             	pushl  -0xc(%ebp)
  d3:	68 a4 0a 00 00       	push   $0xaa4
  d8:	6a 01                	push   $0x1
  da:	e8 d9 05 00 00       	call   6b8 <printf>
  df:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);
  e2:	83 ec 0c             	sub    $0xc,%esp
  e5:	68 f4 01 00 00       	push   $0x1f4
  ea:	e8 82 04 00 00       	call   571 <sleep>
  ef:	83 c4 10             	add    $0x10,%esp

    pid = 1;
  f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    value = 1;
  f9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    printf(1, "%d: setting priority to %d\n", pid, value);
 100:	ff 75 f0             	pushl  -0x10(%ebp)
 103:	ff 75 f4             	pushl  -0xc(%ebp)
 106:	68 6e 0a 00 00       	push   $0xa6e
 10b:	6a 01                	push   $0x1
 10d:	e8 a6 05 00 00       	call   6b8 <printf>
 112:	83 c4 10             	add    $0x10,%esp
    rc = setpriority(pid, value);
 115:	83 ec 08             	sub    $0x8,%esp
 118:	ff 75 f0             	pushl  -0x10(%ebp)
 11b:	ff 75 f4             	pushl  -0xc(%ebp)
 11e:	e8 9e 04 00 00       	call   5c1 <setpriority>
 123:	83 c4 10             	add    $0x10,%esp
 126:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (rc < 0)
 129:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 12d:	79 14                	jns    143 <testInvalid+0x143>
        printf(2, "Failed setting priority!\n");
 12f:	83 ec 08             	sub    $0x8,%esp
 132:	68 8a 0a 00 00       	push   $0xa8a
 137:	6a 02                	push   $0x2
 139:	e8 7a 05 00 00       	call   6b8 <printf>
 13e:	83 c4 10             	add    $0x10,%esp
 141:	eb 15                	jmp    158 <testInvalid+0x158>
    else printf(1, "Change priority of %d to %d\n", pid, value);
 143:	ff 75 f0             	pushl  -0x10(%ebp)
 146:	ff 75 f4             	pushl  -0xc(%ebp)
 149:	68 a4 0a 00 00       	push   $0xaa4
 14e:	6a 01                	push   $0x1
 150:	e8 63 05 00 00       	call   6b8 <printf>
 155:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);
 158:	83 ec 0c             	sub    $0xc,%esp
 15b:	68 f4 01 00 00       	push   $0x1f4
 160:	e8 0c 04 00 00       	call   571 <sleep>
 165:	83 c4 10             	add    $0x10,%esp

    pid = 45;
 168:	c7 45 f4 2d 00 00 00 	movl   $0x2d,-0xc(%ebp)
    value = 1;
 16f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    printf(1, "%d: setting priority to %d\n", pid, value);
 176:	ff 75 f0             	pushl  -0x10(%ebp)
 179:	ff 75 f4             	pushl  -0xc(%ebp)
 17c:	68 6e 0a 00 00       	push   $0xa6e
 181:	6a 01                	push   $0x1
 183:	e8 30 05 00 00       	call   6b8 <printf>
 188:	83 c4 10             	add    $0x10,%esp
    rc = setpriority(pid, value);
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	ff 75 f0             	pushl  -0x10(%ebp)
 191:	ff 75 f4             	pushl  -0xc(%ebp)
 194:	e8 28 04 00 00       	call   5c1 <setpriority>
 199:	83 c4 10             	add    $0x10,%esp
 19c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (rc < 0)
 19f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 1a3:	79 14                	jns    1b9 <testInvalid+0x1b9>
        printf(2, "Failed setting priority!\n");
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	68 8a 0a 00 00       	push   $0xa8a
 1ad:	6a 02                	push   $0x2
 1af:	e8 04 05 00 00       	call   6b8 <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
 1b7:	eb 15                	jmp    1ce <testInvalid+0x1ce>
    else printf(1, "Change priority of %d to %d\n", pid, value);
 1b9:	ff 75 f0             	pushl  -0x10(%ebp)
 1bc:	ff 75 f4             	pushl  -0xc(%ebp)
 1bf:	68 a4 0a 00 00       	push   $0xaa4
 1c4:	6a 01                	push   $0x1
 1c6:	e8 ed 04 00 00       	call   6b8 <printf>
 1cb:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);
 1ce:	83 ec 0c             	sub    $0xc,%esp
 1d1:	68 f4 01 00 00       	push   $0x1f4
 1d6:	e8 96 03 00 00       	call   571 <sleep>
 1db:	83 c4 10             	add    $0x10,%esp
}
 1de:	90                   	nop
 1df:	c9                   	leave  
 1e0:	c3                   	ret    

000001e1 <main>:

int
main(void)
{
 1e1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1e5:	83 e4 f0             	and    $0xfffffff0,%esp
 1e8:	ff 71 fc             	pushl  -0x4(%ecx)
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	51                   	push   %ecx
 1ef:	83 ec 04             	sub    $0x4,%esp
    testInvalid();
 1f2:	e8 09 fe ff ff       	call   0 <testInvalid>
    exit();
 1f7:	e8 e5 02 00 00       	call   4e1 <exit>

000001fc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	57                   	push   %edi
 200:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 201:	8b 4d 08             	mov    0x8(%ebp),%ecx
 204:	8b 55 10             	mov    0x10(%ebp),%edx
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	89 cb                	mov    %ecx,%ebx
 20c:	89 df                	mov    %ebx,%edi
 20e:	89 d1                	mov    %edx,%ecx
 210:	fc                   	cld    
 211:	f3 aa                	rep stos %al,%es:(%edi)
 213:	89 ca                	mov    %ecx,%edx
 215:	89 fb                	mov    %edi,%ebx
 217:	89 5d 08             	mov    %ebx,0x8(%ebp)
 21a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 21d:	90                   	nop
 21e:	5b                   	pop    %ebx
 21f:	5f                   	pop    %edi
 220:	5d                   	pop    %ebp
 221:	c3                   	ret    

00000222 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 22e:	90                   	nop
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	8d 50 01             	lea    0x1(%eax),%edx
 235:	89 55 08             	mov    %edx,0x8(%ebp)
 238:	8b 55 0c             	mov    0xc(%ebp),%edx
 23b:	8d 4a 01             	lea    0x1(%edx),%ecx
 23e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 241:	0f b6 12             	movzbl (%edx),%edx
 244:	88 10                	mov    %dl,(%eax)
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	84 c0                	test   %al,%al
 24b:	75 e2                	jne    22f <strcpy+0xd>
    ;
  return os;
 24d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 255:	eb 08                	jmp    25f <strcmp+0xd>
    p++, q++;
 257:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 25b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	84 c0                	test   %al,%al
 267:	74 10                	je     279 <strcmp+0x27>
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	0f b6 10             	movzbl (%eax),%edx
 26f:	8b 45 0c             	mov    0xc(%ebp),%eax
 272:	0f b6 00             	movzbl (%eax),%eax
 275:	38 c2                	cmp    %al,%dl
 277:	74 de                	je     257 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	0f b6 d0             	movzbl %al,%edx
 282:	8b 45 0c             	mov    0xc(%ebp),%eax
 285:	0f b6 00             	movzbl (%eax),%eax
 288:	0f b6 c0             	movzbl %al,%eax
 28b:	29 c2                	sub    %eax,%edx
 28d:	89 d0                	mov    %edx,%eax
}
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    

00000291 <strlen>:

uint
strlen(char *s)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 297:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 29e:	eb 04                	jmp    2a4 <strlen+0x13>
 2a0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	01 d0                	add    %edx,%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	84 c0                	test   %al,%al
 2b1:	75 ed                	jne    2a0 <strlen+0xf>
    ;
  return n;
 2b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2bb:	8b 45 10             	mov    0x10(%ebp),%eax
 2be:	50                   	push   %eax
 2bf:	ff 75 0c             	pushl  0xc(%ebp)
 2c2:	ff 75 08             	pushl  0x8(%ebp)
 2c5:	e8 32 ff ff ff       	call   1fc <stosb>
 2ca:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d0:	c9                   	leave  
 2d1:	c3                   	ret    

000002d2 <strchr>:

char*
strchr(const char *s, char c)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2db:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2de:	eb 14                	jmp    2f4 <strchr+0x22>
    if(*s == c)
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	0f b6 00             	movzbl (%eax),%eax
 2e6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2e9:	75 05                	jne    2f0 <strchr+0x1e>
      return (char*)s;
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	eb 13                	jmp    303 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2f0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	0f b6 00             	movzbl (%eax),%eax
 2fa:	84 c0                	test   %al,%al
 2fc:	75 e2                	jne    2e0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
 303:	c9                   	leave  
 304:	c3                   	ret    

00000305 <gets>:

char*
gets(char *buf, int max)
{
 305:	55                   	push   %ebp
 306:	89 e5                	mov    %esp,%ebp
 308:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 30b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 312:	eb 42                	jmp    356 <gets+0x51>
    cc = read(0, &c, 1);
 314:	83 ec 04             	sub    $0x4,%esp
 317:	6a 01                	push   $0x1
 319:	8d 45 ef             	lea    -0x11(%ebp),%eax
 31c:	50                   	push   %eax
 31d:	6a 00                	push   $0x0
 31f:	e8 d5 01 00 00       	call   4f9 <read>
 324:	83 c4 10             	add    $0x10,%esp
 327:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 32a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 32e:	7e 33                	jle    363 <gets+0x5e>
      break;
    buf[i++] = c;
 330:	8b 45 f4             	mov    -0xc(%ebp),%eax
 333:	8d 50 01             	lea    0x1(%eax),%edx
 336:	89 55 f4             	mov    %edx,-0xc(%ebp)
 339:	89 c2                	mov    %eax,%edx
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	01 c2                	add    %eax,%edx
 340:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 344:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 346:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34a:	3c 0a                	cmp    $0xa,%al
 34c:	74 16                	je     364 <gets+0x5f>
 34e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 352:	3c 0d                	cmp    $0xd,%al
 354:	74 0e                	je     364 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 356:	8b 45 f4             	mov    -0xc(%ebp),%eax
 359:	83 c0 01             	add    $0x1,%eax
 35c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 35f:	7c b3                	jl     314 <gets+0xf>
 361:	eb 01                	jmp    364 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 363:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 364:	8b 55 f4             	mov    -0xc(%ebp),%edx
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	01 d0                	add    %edx,%eax
 36c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 372:	c9                   	leave  
 373:	c3                   	ret    

00000374 <stat>:

int
stat(char *n, struct stat *st)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37a:	83 ec 08             	sub    $0x8,%esp
 37d:	6a 00                	push   $0x0
 37f:	ff 75 08             	pushl  0x8(%ebp)
 382:	e8 9a 01 00 00       	call   521 <open>
 387:	83 c4 10             	add    $0x10,%esp
 38a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 38d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 391:	79 07                	jns    39a <stat+0x26>
    return -1;
 393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 398:	eb 25                	jmp    3bf <stat+0x4b>
  r = fstat(fd, st);
 39a:	83 ec 08             	sub    $0x8,%esp
 39d:	ff 75 0c             	pushl  0xc(%ebp)
 3a0:	ff 75 f4             	pushl  -0xc(%ebp)
 3a3:	e8 91 01 00 00       	call   539 <fstat>
 3a8:	83 c4 10             	add    $0x10,%esp
 3ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3ae:	83 ec 0c             	sub    $0xc,%esp
 3b1:	ff 75 f4             	pushl  -0xc(%ebp)
 3b4:	e8 50 01 00 00       	call   509 <close>
 3b9:	83 c4 10             	add    $0x10,%esp
  return r;
 3bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3bf:	c9                   	leave  
 3c0:	c3                   	ret    

000003c1 <atoi>:

int
atoi(const char *s)
{
 3c1:	55                   	push   %ebp
 3c2:	89 e5                	mov    %esp,%ebp
 3c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3ce:	eb 25                	jmp    3f5 <atoi+0x34>
    n = n*10 + *s++ - '0';
 3d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d3:	89 d0                	mov    %edx,%eax
 3d5:	c1 e0 02             	shl    $0x2,%eax
 3d8:	01 d0                	add    %edx,%eax
 3da:	01 c0                	add    %eax,%eax
 3dc:	89 c1                	mov    %eax,%ecx
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	8d 50 01             	lea    0x1(%eax),%edx
 3e4:	89 55 08             	mov    %edx,0x8(%ebp)
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	0f be c0             	movsbl %al,%eax
 3ed:	01 c8                	add    %ecx,%eax
 3ef:	83 e8 30             	sub    $0x30,%eax
 3f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	0f b6 00             	movzbl (%eax),%eax
 3fb:	3c 2f                	cmp    $0x2f,%al
 3fd:	7e 0a                	jle    409 <atoi+0x48>
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
 402:	0f b6 00             	movzbl (%eax),%eax
 405:	3c 39                	cmp    $0x39,%al
 407:	7e c7                	jle    3d0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 409:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 40c:	c9                   	leave  
 40d:	c3                   	ret    

0000040e <atoo>:

int
atoo(const char *s)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
 414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
 41b:	eb 04                	jmp    421 <atoo+0x13>
        s++;
 41d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	0f b6 00             	movzbl (%eax),%eax
 427:	3c 20                	cmp    $0x20,%al
 429:	74 f2                	je     41d <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	0f b6 00             	movzbl (%eax),%eax
 431:	3c 2d                	cmp    $0x2d,%al
 433:	75 07                	jne    43c <atoo+0x2e>
 435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 43a:	eb 05                	jmp    441 <atoo+0x33>
 43c:	b8 01 00 00 00       	mov    $0x1,%eax
 441:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	0f b6 00             	movzbl (%eax),%eax
 44a:	3c 2b                	cmp    $0x2b,%al
 44c:	74 0a                	je     458 <atoo+0x4a>
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	0f b6 00             	movzbl (%eax),%eax
 454:	3c 2d                	cmp    $0x2d,%al
 456:	75 27                	jne    47f <atoo+0x71>
        s++;
 458:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
 45c:	eb 21                	jmp    47f <atoo+0x71>
        n = n*8 + *s++ - '0';
 45e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 461:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	8d 50 01             	lea    0x1(%eax),%edx
 46e:	89 55 08             	mov    %edx,0x8(%ebp)
 471:	0f b6 00             	movzbl (%eax),%eax
 474:	0f be c0             	movsbl %al,%eax
 477:	01 c8                	add    %ecx,%eax
 479:	83 e8 30             	sub    $0x30,%eax
 47c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	0f b6 00             	movzbl (%eax),%eax
 485:	3c 2f                	cmp    $0x2f,%al
 487:	7e 0a                	jle    493 <atoo+0x85>
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	0f b6 00             	movzbl (%eax),%eax
 48f:	3c 37                	cmp    $0x37,%al
 491:	7e cb                	jle    45e <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
 493:	8b 45 f8             	mov    -0x8(%ebp),%eax
 496:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 49a:	c9                   	leave  
 49b:	c3                   	ret    

0000049c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 49c:	55                   	push   %ebp
 49d:	89 e5                	mov    %esp,%ebp
 49f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4ae:	eb 17                	jmp    4c7 <memmove+0x2b>
    *dst++ = *src++;
 4b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4b3:	8d 50 01             	lea    0x1(%eax),%edx
 4b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4bc:	8d 4a 01             	lea    0x1(%edx),%ecx
 4bf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4c2:	0f b6 12             	movzbl (%edx),%edx
 4c5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4c7:	8b 45 10             	mov    0x10(%ebp),%eax
 4ca:	8d 50 ff             	lea    -0x1(%eax),%edx
 4cd:	89 55 10             	mov    %edx,0x10(%ebp)
 4d0:	85 c0                	test   %eax,%eax
 4d2:	7f dc                	jg     4b0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d7:	c9                   	leave  
 4d8:	c3                   	ret    

000004d9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4d9:	b8 01 00 00 00       	mov    $0x1,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <exit>:
SYSCALL(exit)
 4e1:	b8 02 00 00 00       	mov    $0x2,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <wait>:
SYSCALL(wait)
 4e9:	b8 03 00 00 00       	mov    $0x3,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <pipe>:
SYSCALL(pipe)
 4f1:	b8 04 00 00 00       	mov    $0x4,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <read>:
SYSCALL(read)
 4f9:	b8 05 00 00 00       	mov    $0x5,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <write>:
SYSCALL(write)
 501:	b8 10 00 00 00       	mov    $0x10,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <close>:
SYSCALL(close)
 509:	b8 15 00 00 00       	mov    $0x15,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <kill>:
SYSCALL(kill)
 511:	b8 06 00 00 00       	mov    $0x6,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <exec>:
SYSCALL(exec)
 519:	b8 07 00 00 00       	mov    $0x7,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <open>:
SYSCALL(open)
 521:	b8 0f 00 00 00       	mov    $0xf,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <mknod>:
SYSCALL(mknod)
 529:	b8 11 00 00 00       	mov    $0x11,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <unlink>:
SYSCALL(unlink)
 531:	b8 12 00 00 00       	mov    $0x12,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <fstat>:
SYSCALL(fstat)
 539:	b8 08 00 00 00       	mov    $0x8,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <link>:
SYSCALL(link)
 541:	b8 13 00 00 00       	mov    $0x13,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <mkdir>:
SYSCALL(mkdir)
 549:	b8 14 00 00 00       	mov    $0x14,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <chdir>:
SYSCALL(chdir)
 551:	b8 09 00 00 00       	mov    $0x9,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <dup>:
SYSCALL(dup)
 559:	b8 0a 00 00 00       	mov    $0xa,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <getpid>:
SYSCALL(getpid)
 561:	b8 0b 00 00 00       	mov    $0xb,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <sbrk>:
SYSCALL(sbrk)
 569:	b8 0c 00 00 00       	mov    $0xc,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <sleep>:
SYSCALL(sleep)
 571:	b8 0d 00 00 00       	mov    $0xd,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <uptime>:
SYSCALL(uptime)
 579:	b8 0e 00 00 00       	mov    $0xe,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <halt>:
SYSCALL(halt)
 581:	b8 16 00 00 00       	mov    $0x16,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <date>:
SYSCALL(date)
 589:	b8 17 00 00 00       	mov    $0x17,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <getuid>:
SYSCALL(getuid)
 591:	b8 18 00 00 00       	mov    $0x18,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <getgid>:
SYSCALL(getgid)
 599:	b8 19 00 00 00       	mov    $0x19,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <getppid>:
SYSCALL(getppid)
 5a1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <setuid>:
SYSCALL(setuid)
 5a9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <setgid>:
SYSCALL(setgid)
 5b1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <getprocs>:
SYSCALL(getprocs)
 5b9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <setpriority>:
SYSCALL(setpriority)
 5c1:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <chmod>:
SYSCALL(chmod)
 5c9:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <chown>:
SYSCALL(chown)
 5d1:	b8 20 00 00 00       	mov    $0x20,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <chgrp>:
SYSCALL(chgrp)
 5d9:	b8 21 00 00 00       	mov    $0x21,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5e1:	55                   	push   %ebp
 5e2:	89 e5                	mov    %esp,%ebp
 5e4:	83 ec 18             	sub    $0x18,%esp
 5e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ea:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5ed:	83 ec 04             	sub    $0x4,%esp
 5f0:	6a 01                	push   $0x1
 5f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5f5:	50                   	push   %eax
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 03 ff ff ff       	call   501 <write>
 5fe:	83 c4 10             	add    $0x10,%esp
}
 601:	90                   	nop
 602:	c9                   	leave  
 603:	c3                   	ret    

00000604 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	53                   	push   %ebx
 608:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 60b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 612:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 616:	74 17                	je     62f <printint+0x2b>
 618:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 61c:	79 11                	jns    62f <printint+0x2b>
    neg = 1;
 61e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 625:	8b 45 0c             	mov    0xc(%ebp),%eax
 628:	f7 d8                	neg    %eax
 62a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 62d:	eb 06                	jmp    635 <printint+0x31>
  } else {
    x = xx;
 62f:	8b 45 0c             	mov    0xc(%ebp),%eax
 632:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 635:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 63c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 63f:	8d 41 01             	lea    0x1(%ecx),%eax
 642:	89 45 f4             	mov    %eax,-0xc(%ebp)
 645:	8b 5d 10             	mov    0x10(%ebp),%ebx
 648:	8b 45 ec             	mov    -0x14(%ebp),%eax
 64b:	ba 00 00 00 00       	mov    $0x0,%edx
 650:	f7 f3                	div    %ebx
 652:	89 d0                	mov    %edx,%eax
 654:	0f b6 80 50 0d 00 00 	movzbl 0xd50(%eax),%eax
 65b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 65f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 662:	8b 45 ec             	mov    -0x14(%ebp),%eax
 665:	ba 00 00 00 00       	mov    $0x0,%edx
 66a:	f7 f3                	div    %ebx
 66c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 66f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 673:	75 c7                	jne    63c <printint+0x38>
  if(neg)
 675:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 679:	74 2d                	je     6a8 <printint+0xa4>
    buf[i++] = '-';
 67b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67e:	8d 50 01             	lea    0x1(%eax),%edx
 681:	89 55 f4             	mov    %edx,-0xc(%ebp)
 684:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 689:	eb 1d                	jmp    6a8 <printint+0xa4>
    putc(fd, buf[i]);
 68b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 68e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 691:	01 d0                	add    %edx,%eax
 693:	0f b6 00             	movzbl (%eax),%eax
 696:	0f be c0             	movsbl %al,%eax
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	50                   	push   %eax
 69d:	ff 75 08             	pushl  0x8(%ebp)
 6a0:	e8 3c ff ff ff       	call   5e1 <putc>
 6a5:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6a8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b0:	79 d9                	jns    68b <printint+0x87>
    putc(fd, buf[i]);
}
 6b2:	90                   	nop
 6b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6b6:	c9                   	leave  
 6b7:	c3                   	ret    

000006b8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6c5:	8d 45 0c             	lea    0xc(%ebp),%eax
 6c8:	83 c0 04             	add    $0x4,%eax
 6cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6d5:	e9 59 01 00 00       	jmp    833 <printf+0x17b>
    c = fmt[i] & 0xff;
 6da:	8b 55 0c             	mov    0xc(%ebp),%edx
 6dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e0:	01 d0                	add    %edx,%eax
 6e2:	0f b6 00             	movzbl (%eax),%eax
 6e5:	0f be c0             	movsbl %al,%eax
 6e8:	25 ff 00 00 00       	and    $0xff,%eax
 6ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6f4:	75 2c                	jne    722 <printf+0x6a>
      if(c == '%'){
 6f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6fa:	75 0c                	jne    708 <printf+0x50>
        state = '%';
 6fc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 703:	e9 27 01 00 00       	jmp    82f <printf+0x177>
      } else {
        putc(fd, c);
 708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70b:	0f be c0             	movsbl %al,%eax
 70e:	83 ec 08             	sub    $0x8,%esp
 711:	50                   	push   %eax
 712:	ff 75 08             	pushl  0x8(%ebp)
 715:	e8 c7 fe ff ff       	call   5e1 <putc>
 71a:	83 c4 10             	add    $0x10,%esp
 71d:	e9 0d 01 00 00       	jmp    82f <printf+0x177>
      }
    } else if(state == '%'){
 722:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 726:	0f 85 03 01 00 00    	jne    82f <printf+0x177>
      if(c == 'd'){
 72c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 730:	75 1e                	jne    750 <printf+0x98>
        printint(fd, *ap, 10, 1);
 732:	8b 45 e8             	mov    -0x18(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	6a 01                	push   $0x1
 739:	6a 0a                	push   $0xa
 73b:	50                   	push   %eax
 73c:	ff 75 08             	pushl  0x8(%ebp)
 73f:	e8 c0 fe ff ff       	call   604 <printint>
 744:	83 c4 10             	add    $0x10,%esp
        ap++;
 747:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74b:	e9 d8 00 00 00       	jmp    828 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 750:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 754:	74 06                	je     75c <printf+0xa4>
 756:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 75a:	75 1e                	jne    77a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 75c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	6a 00                	push   $0x0
 763:	6a 10                	push   $0x10
 765:	50                   	push   %eax
 766:	ff 75 08             	pushl  0x8(%ebp)
 769:	e8 96 fe ff ff       	call   604 <printint>
 76e:	83 c4 10             	add    $0x10,%esp
        ap++;
 771:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 775:	e9 ae 00 00 00       	jmp    828 <printf+0x170>
      } else if(c == 's'){
 77a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 77e:	75 43                	jne    7c3 <printf+0x10b>
        s = (char*)*ap;
 780:	8b 45 e8             	mov    -0x18(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 788:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 78c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 790:	75 25                	jne    7b7 <printf+0xff>
          s = "(null)";
 792:	c7 45 f4 c1 0a 00 00 	movl   $0xac1,-0xc(%ebp)
        while(*s != 0){
 799:	eb 1c                	jmp    7b7 <printf+0xff>
          putc(fd, *s);
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	0f b6 00             	movzbl (%eax),%eax
 7a1:	0f be c0             	movsbl %al,%eax
 7a4:	83 ec 08             	sub    $0x8,%esp
 7a7:	50                   	push   %eax
 7a8:	ff 75 08             	pushl  0x8(%ebp)
 7ab:	e8 31 fe ff ff       	call   5e1 <putc>
 7b0:	83 c4 10             	add    $0x10,%esp
          s++;
 7b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	0f b6 00             	movzbl (%eax),%eax
 7bd:	84 c0                	test   %al,%al
 7bf:	75 da                	jne    79b <printf+0xe3>
 7c1:	eb 65                	jmp    828 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7c3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7c7:	75 1d                	jne    7e6 <printf+0x12e>
        putc(fd, *ap);
 7c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	0f be c0             	movsbl %al,%eax
 7d1:	83 ec 08             	sub    $0x8,%esp
 7d4:	50                   	push   %eax
 7d5:	ff 75 08             	pushl  0x8(%ebp)
 7d8:	e8 04 fe ff ff       	call   5e1 <putc>
 7dd:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e4:	eb 42                	jmp    828 <printf+0x170>
      } else if(c == '%'){
 7e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ea:	75 17                	jne    803 <printf+0x14b>
        putc(fd, c);
 7ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ef:	0f be c0             	movsbl %al,%eax
 7f2:	83 ec 08             	sub    $0x8,%esp
 7f5:	50                   	push   %eax
 7f6:	ff 75 08             	pushl  0x8(%ebp)
 7f9:	e8 e3 fd ff ff       	call   5e1 <putc>
 7fe:	83 c4 10             	add    $0x10,%esp
 801:	eb 25                	jmp    828 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 803:	83 ec 08             	sub    $0x8,%esp
 806:	6a 25                	push   $0x25
 808:	ff 75 08             	pushl  0x8(%ebp)
 80b:	e8 d1 fd ff ff       	call   5e1 <putc>
 810:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 816:	0f be c0             	movsbl %al,%eax
 819:	83 ec 08             	sub    $0x8,%esp
 81c:	50                   	push   %eax
 81d:	ff 75 08             	pushl  0x8(%ebp)
 820:	e8 bc fd ff ff       	call   5e1 <putc>
 825:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 828:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 82f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 833:	8b 55 0c             	mov    0xc(%ebp),%edx
 836:	8b 45 f0             	mov    -0x10(%ebp),%eax
 839:	01 d0                	add    %edx,%eax
 83b:	0f b6 00             	movzbl (%eax),%eax
 83e:	84 c0                	test   %al,%al
 840:	0f 85 94 fe ff ff    	jne    6da <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 846:	90                   	nop
 847:	c9                   	leave  
 848:	c3                   	ret    

00000849 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 849:	55                   	push   %ebp
 84a:	89 e5                	mov    %esp,%ebp
 84c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84f:	8b 45 08             	mov    0x8(%ebp),%eax
 852:	83 e8 08             	sub    $0x8,%eax
 855:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 858:	a1 6c 0d 00 00       	mov    0xd6c,%eax
 85d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 860:	eb 24                	jmp    886 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	8b 00                	mov    (%eax),%eax
 867:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 86a:	77 12                	ja     87e <free+0x35>
 86c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 872:	77 24                	ja     898 <free+0x4f>
 874:	8b 45 fc             	mov    -0x4(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 87c:	77 1a                	ja     898 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	8b 00                	mov    (%eax),%eax
 883:	89 45 fc             	mov    %eax,-0x4(%ebp)
 886:	8b 45 f8             	mov    -0x8(%ebp),%eax
 889:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 88c:	76 d4                	jbe    862 <free+0x19>
 88e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 891:	8b 00                	mov    (%eax),%eax
 893:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 896:	76 ca                	jbe    862 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 898:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89b:	8b 40 04             	mov    0x4(%eax),%eax
 89e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a8:	01 c2                	add    %eax,%edx
 8aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ad:	8b 00                	mov    (%eax),%eax
 8af:	39 c2                	cmp    %eax,%edx
 8b1:	75 24                	jne    8d7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b6:	8b 50 04             	mov    0x4(%eax),%edx
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	8b 00                	mov    (%eax),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	01 c2                	add    %eax,%edx
 8c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cc:	8b 00                	mov    (%eax),%eax
 8ce:	8b 10                	mov    (%eax),%edx
 8d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d3:	89 10                	mov    %edx,(%eax)
 8d5:	eb 0a                	jmp    8e1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8da:	8b 10                	mov    (%eax),%edx
 8dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8df:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e4:	8b 40 04             	mov    0x4(%eax),%eax
 8e7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	01 d0                	add    %edx,%eax
 8f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f6:	75 20                	jne    918 <free+0xcf>
    p->s.size += bp->s.size;
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	8b 50 04             	mov    0x4(%eax),%edx
 8fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 901:	8b 40 04             	mov    0x4(%eax),%eax
 904:	01 c2                	add    %eax,%edx
 906:	8b 45 fc             	mov    -0x4(%ebp),%eax
 909:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 90c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90f:	8b 10                	mov    (%eax),%edx
 911:	8b 45 fc             	mov    -0x4(%ebp),%eax
 914:	89 10                	mov    %edx,(%eax)
 916:	eb 08                	jmp    920 <free+0xd7>
  } else
    p->s.ptr = bp;
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 91e:	89 10                	mov    %edx,(%eax)
  freep = p;
 920:	8b 45 fc             	mov    -0x4(%ebp),%eax
 923:	a3 6c 0d 00 00       	mov    %eax,0xd6c
}
 928:	90                   	nop
 929:	c9                   	leave  
 92a:	c3                   	ret    

0000092b <morecore>:

static Header*
morecore(uint nu)
{
 92b:	55                   	push   %ebp
 92c:	89 e5                	mov    %esp,%ebp
 92e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 931:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 938:	77 07                	ja     941 <morecore+0x16>
    nu = 4096;
 93a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 941:	8b 45 08             	mov    0x8(%ebp),%eax
 944:	c1 e0 03             	shl    $0x3,%eax
 947:	83 ec 0c             	sub    $0xc,%esp
 94a:	50                   	push   %eax
 94b:	e8 19 fc ff ff       	call   569 <sbrk>
 950:	83 c4 10             	add    $0x10,%esp
 953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 956:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 95a:	75 07                	jne    963 <morecore+0x38>
    return 0;
 95c:	b8 00 00 00 00       	mov    $0x0,%eax
 961:	eb 26                	jmp    989 <morecore+0x5e>
  hp = (Header*)p;
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 969:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96c:	8b 55 08             	mov    0x8(%ebp),%edx
 96f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 972:	8b 45 f0             	mov    -0x10(%ebp),%eax
 975:	83 c0 08             	add    $0x8,%eax
 978:	83 ec 0c             	sub    $0xc,%esp
 97b:	50                   	push   %eax
 97c:	e8 c8 fe ff ff       	call   849 <free>
 981:	83 c4 10             	add    $0x10,%esp
  return freep;
 984:	a1 6c 0d 00 00       	mov    0xd6c,%eax
}
 989:	c9                   	leave  
 98a:	c3                   	ret    

0000098b <malloc>:

void*
malloc(uint nbytes)
{
 98b:	55                   	push   %ebp
 98c:	89 e5                	mov    %esp,%ebp
 98e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 991:	8b 45 08             	mov    0x8(%ebp),%eax
 994:	83 c0 07             	add    $0x7,%eax
 997:	c1 e8 03             	shr    $0x3,%eax
 99a:	83 c0 01             	add    $0x1,%eax
 99d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9a0:	a1 6c 0d 00 00       	mov    0xd6c,%eax
 9a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ac:	75 23                	jne    9d1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9ae:	c7 45 f0 64 0d 00 00 	movl   $0xd64,-0x10(%ebp)
 9b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b8:	a3 6c 0d 00 00       	mov    %eax,0xd6c
 9bd:	a1 6c 0d 00 00       	mov    0xd6c,%eax
 9c2:	a3 64 0d 00 00       	mov    %eax,0xd64
    base.s.size = 0;
 9c7:	c7 05 68 0d 00 00 00 	movl   $0x0,0xd68
 9ce:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d4:	8b 00                	mov    (%eax),%eax
 9d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	8b 40 04             	mov    0x4(%eax),%eax
 9df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e2:	72 4d                	jb     a31 <malloc+0xa6>
      if(p->s.size == nunits)
 9e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e7:	8b 40 04             	mov    0x4(%eax),%eax
 9ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ed:	75 0c                	jne    9fb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	8b 10                	mov    (%eax),%edx
 9f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f7:	89 10                	mov    %edx,(%eax)
 9f9:	eb 26                	jmp    a21 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fe:	8b 40 04             	mov    0x4(%eax),%eax
 a01:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a04:	89 c2                	mov    %eax,%edx
 a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a09:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0f:	8b 40 04             	mov    0x4(%eax),%eax
 a12:	c1 e0 03             	shl    $0x3,%eax
 a15:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a1e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a24:	a3 6c 0d 00 00       	mov    %eax,0xd6c
      return (void*)(p + 1);
 a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2c:	83 c0 08             	add    $0x8,%eax
 a2f:	eb 3b                	jmp    a6c <malloc+0xe1>
    }
    if(p == freep)
 a31:	a1 6c 0d 00 00       	mov    0xd6c,%eax
 a36:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a39:	75 1e                	jne    a59 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a3b:	83 ec 0c             	sub    $0xc,%esp
 a3e:	ff 75 ec             	pushl  -0x14(%ebp)
 a41:	e8 e5 fe ff ff       	call   92b <morecore>
 a46:	83 c4 10             	add    $0x10,%esp
 a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a50:	75 07                	jne    a59 <malloc+0xce>
        return 0;
 a52:	b8 00 00 00 00       	mov    $0x0,%eax
 a57:	eb 13                	jmp    a6c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a62:	8b 00                	mov    (%eax),%eax
 a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a67:	e9 6d ff ff ff       	jmp    9d9 <malloc+0x4e>
}
 a6c:	c9                   	leave  
 a6d:	c3                   	ret    
