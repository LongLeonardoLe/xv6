
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "uproc.h"
#define MAX 16

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 28             	sub    $0x28,%esp
    struct uproc* table = (struct uproc*)malloc(MAX * sizeof(struct uproc));
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 00 06 00 00       	push   $0x600
  1c:	e8 ab 09 00 00       	call   9cc <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int check = getprocs(MAX, table);
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 e0             	pushl  -0x20(%ebp)
  2d:	6a 10                	push   $0x10
  2f:	e8 c6 05 00 00       	call   5fa <getprocs>
  34:	83 c4 10             	add    $0x10,%esp
  37:	89 45 dc             	mov    %eax,-0x24(%ebp)

    if (!table) {
  3a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  3e:	75 17                	jne    57 <main+0x57>
        printf(2, "Error: malloc failed\n");
  40:	83 ec 08             	sub    $0x8,%esp
  43:	68 b0 0a 00 00       	push   $0xab0
  48:	6a 02                	push   $0x2
  4a:	e8 aa 06 00 00       	call   6f9 <printf>
  4f:	83 c4 10             	add    $0x10,%esp
        exit();
  52:	e8 cb 04 00 00       	call   522 <exit>
    }

    if (check <= 0) {
  57:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  5b:	7f 17                	jg     74 <main+0x74>
        printf(2, "No processes found\n");
  5d:	83 ec 08             	sub    $0x8,%esp
  60:	68 c6 0a 00 00       	push   $0xac6
  65:	6a 02                	push   $0x2
  67:	e8 8d 06 00 00       	call   6f9 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
        exit();
  6f:	e8 ae 04 00 00       	call   522 <exit>
    }
    else {
        printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
  74:	83 ec 08             	sub    $0x8,%esp
  77:	68 dc 0a 00 00       	push   $0xadc
  7c:	6a 01                	push   $0x1
  7e:	e8 76 06 00 00       	call   6f9 <printf>
  83:	83 c4 10             	add    $0x10,%esp
        for (int i = 0; i < check; i++) {
  86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8d:	e9 9a 01 00 00       	jmp    22c <main+0x22c>
           printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t", table[i].pid, table[i].name, table[i].uid, table[i].gid, table[i].ppid, table[i].priority);
  92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  95:	89 d0                	mov    %edx,%eax
  97:	01 c0                	add    %eax,%eax
  99:	01 d0                	add    %edx,%eax
  9b:	c1 e0 05             	shl    $0x5,%eax
  9e:	89 c2                	mov    %eax,%edx
  a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a3:	01 d0                	add    %edx,%eax
  a5:	8b 78 5c             	mov    0x5c(%eax),%edi
  a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  ab:	89 d0                	mov    %edx,%eax
  ad:	01 c0                	add    %eax,%eax
  af:	01 d0                	add    %edx,%eax
  b1:	c1 e0 05             	shl    $0x5,%eax
  b4:	89 c2                	mov    %eax,%edx
  b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b9:	01 d0                	add    %edx,%eax
  bb:	8b 70 0c             	mov    0xc(%eax),%esi
  be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  c1:	89 d0                	mov    %edx,%eax
  c3:	01 c0                	add    %eax,%eax
  c5:	01 d0                	add    %edx,%eax
  c7:	c1 e0 05             	shl    $0x5,%eax
  ca:	89 c2                	mov    %eax,%edx
  cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  cf:	01 d0                	add    %edx,%eax
  d1:	8b 58 08             	mov    0x8(%eax),%ebx
  d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  d7:	89 d0                	mov    %edx,%eax
  d9:	01 c0                	add    %eax,%eax
  db:	01 d0                	add    %edx,%eax
  dd:	c1 e0 05             	shl    $0x5,%eax
  e0:	89 c2                	mov    %eax,%edx
  e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e5:	01 d0                	add    %edx,%eax
  e7:	8b 48 04             	mov    0x4(%eax),%ecx
  ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  ed:	89 d0                	mov    %edx,%eax
  ef:	01 c0                	add    %eax,%eax
  f1:	01 d0                	add    %edx,%eax
  f3:	c1 e0 05             	shl    $0x5,%eax
  f6:	89 c2                	mov    %eax,%edx
  f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  fb:	01 d0                	add    %edx,%eax
  fd:	83 c0 3c             	add    $0x3c,%eax
 100:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 103:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 106:	89 d0                	mov    %edx,%eax
 108:	01 c0                	add    %eax,%eax
 10a:	01 d0                	add    %edx,%eax
 10c:	c1 e0 05             	shl    $0x5,%eax
 10f:	89 c2                	mov    %eax,%edx
 111:	8b 45 e0             	mov    -0x20(%ebp),%eax
 114:	01 d0                	add    %edx,%eax
 116:	8b 00                	mov    (%eax),%eax
 118:	57                   	push   %edi
 119:	56                   	push   %esi
 11a:	53                   	push   %ebx
 11b:	51                   	push   %ecx
 11c:	ff 75 d4             	pushl  -0x2c(%ebp)
 11f:	50                   	push   %eax
 120:	68 0f 0b 00 00       	push   $0xb0f
 125:	6a 01                	push   $0x1
 127:	e8 cd 05 00 00       	call   6f9 <printf>
 12c:	83 c4 20             	add    $0x20,%esp
           printf(1, "%d.%d\t", table[i].elapsed_ticks/100, table[i].elapsed_ticks%100);
 12f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 132:	89 d0                	mov    %edx,%eax
 134:	01 c0                	add    %eax,%eax
 136:	01 d0                	add    %edx,%eax
 138:	c1 e0 05             	shl    $0x5,%eax
 13b:	89 c2                	mov    %eax,%edx
 13d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 140:	01 d0                	add    %edx,%eax
 142:	8b 58 10             	mov    0x10(%eax),%ebx
 145:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 14a:	89 d8                	mov    %ebx,%eax
 14c:	f7 e2                	mul    %edx
 14e:	89 d1                	mov    %edx,%ecx
 150:	c1 e9 05             	shr    $0x5,%ecx
 153:	6b c1 64             	imul   $0x64,%ecx,%eax
 156:	29 c3                	sub    %eax,%ebx
 158:	89 d9                	mov    %ebx,%ecx
 15a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 15d:	89 d0                	mov    %edx,%eax
 15f:	01 c0                	add    %eax,%eax
 161:	01 d0                	add    %edx,%eax
 163:	c1 e0 05             	shl    $0x5,%eax
 166:	89 c2                	mov    %eax,%edx
 168:	8b 45 e0             	mov    -0x20(%ebp),%eax
 16b:	01 d0                	add    %edx,%eax
 16d:	8b 40 10             	mov    0x10(%eax),%eax
 170:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 175:	f7 e2                	mul    %edx
 177:	89 d0                	mov    %edx,%eax
 179:	c1 e8 05             	shr    $0x5,%eax
 17c:	51                   	push   %ecx
 17d:	50                   	push   %eax
 17e:	68 22 0b 00 00       	push   $0xb22
 183:	6a 01                	push   $0x1
 185:	e8 6f 05 00 00       	call   6f9 <printf>
 18a:	83 c4 10             	add    $0x10,%esp
           printf(1, "%d.%d\t", table[i].CPU_total_ticks/100, table[i].CPU_total_ticks%100);
 18d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 190:	89 d0                	mov    %edx,%eax
 192:	01 c0                	add    %eax,%eax
 194:	01 d0                	add    %edx,%eax
 196:	c1 e0 05             	shl    $0x5,%eax
 199:	89 c2                	mov    %eax,%edx
 19b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 19e:	01 d0                	add    %edx,%eax
 1a0:	8b 58 14             	mov    0x14(%eax),%ebx
 1a3:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 1a8:	89 d8                	mov    %ebx,%eax
 1aa:	f7 e2                	mul    %edx
 1ac:	89 d1                	mov    %edx,%ecx
 1ae:	c1 e9 05             	shr    $0x5,%ecx
 1b1:	6b c1 64             	imul   $0x64,%ecx,%eax
 1b4:	29 c3                	sub    %eax,%ebx
 1b6:	89 d9                	mov    %ebx,%ecx
 1b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1bb:	89 d0                	mov    %edx,%eax
 1bd:	01 c0                	add    %eax,%eax
 1bf:	01 d0                	add    %edx,%eax
 1c1:	c1 e0 05             	shl    $0x5,%eax
 1c4:	89 c2                	mov    %eax,%edx
 1c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1c9:	01 d0                	add    %edx,%eax
 1cb:	8b 40 14             	mov    0x14(%eax),%eax
 1ce:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 1d3:	f7 e2                	mul    %edx
 1d5:	89 d0                	mov    %edx,%eax
 1d7:	c1 e8 05             	shr    $0x5,%eax
 1da:	51                   	push   %ecx
 1db:	50                   	push   %eax
 1dc:	68 22 0b 00 00       	push   $0xb22
 1e1:	6a 01                	push   $0x1
 1e3:	e8 11 05 00 00       	call   6f9 <printf>
 1e8:	83 c4 10             	add    $0x10,%esp
           printf(1, "%s\t%d\n", table[i].state, table[i].size);
 1eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1ee:	89 d0                	mov    %edx,%eax
 1f0:	01 c0                	add    %eax,%eax
 1f2:	01 d0                	add    %edx,%eax
 1f4:	c1 e0 05             	shl    $0x5,%eax
 1f7:	89 c2                	mov    %eax,%edx
 1f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	8b 48 38             	mov    0x38(%eax),%ecx
 201:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 204:	89 d0                	mov    %edx,%eax
 206:	01 c0                	add    %eax,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	c1 e0 05             	shl    $0x5,%eax
 20d:	89 c2                	mov    %eax,%edx
 20f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 212:	01 d0                	add    %edx,%eax
 214:	83 c0 18             	add    $0x18,%eax
 217:	51                   	push   %ecx
 218:	50                   	push   %eax
 219:	68 29 0b 00 00       	push   $0xb29
 21e:	6a 01                	push   $0x1
 220:	e8 d4 04 00 00       	call   6f9 <printf>
 225:	83 c4 10             	add    $0x10,%esp
        printf(2, "No processes found\n");
        exit();
    }
    else {
        printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
        for (int i = 0; i < check; i++) {
 228:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 22c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 22f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 232:	0f 8c 5a fe ff ff    	jl     92 <main+0x92>
           printf(1, "%d.%d\t", table[i].elapsed_ticks/100, table[i].elapsed_ticks%100);
           printf(1, "%d.%d\t", table[i].CPU_total_ticks/100, table[i].CPU_total_ticks%100);
           printf(1, "%s\t%d\n", table[i].state, table[i].size);
        }
    }
    exit();
 238:	e8 e5 02 00 00       	call   522 <exit>

0000023d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	57                   	push   %edi
 241:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 242:	8b 4d 08             	mov    0x8(%ebp),%ecx
 245:	8b 55 10             	mov    0x10(%ebp),%edx
 248:	8b 45 0c             	mov    0xc(%ebp),%eax
 24b:	89 cb                	mov    %ecx,%ebx
 24d:	89 df                	mov    %ebx,%edi
 24f:	89 d1                	mov    %edx,%ecx
 251:	fc                   	cld    
 252:	f3 aa                	rep stos %al,%es:(%edi)
 254:	89 ca                	mov    %ecx,%edx
 256:	89 fb                	mov    %edi,%ebx
 258:	89 5d 08             	mov    %ebx,0x8(%ebp)
 25b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 25e:	90                   	nop
 25f:	5b                   	pop    %ebx
 260:	5f                   	pop    %edi
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    

00000263 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 263:	55                   	push   %ebp
 264:	89 e5                	mov    %esp,%ebp
 266:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 26f:	90                   	nop
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	8d 50 01             	lea    0x1(%eax),%edx
 276:	89 55 08             	mov    %edx,0x8(%ebp)
 279:	8b 55 0c             	mov    0xc(%ebp),%edx
 27c:	8d 4a 01             	lea    0x1(%edx),%ecx
 27f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 282:	0f b6 12             	movzbl (%edx),%edx
 285:	88 10                	mov    %dl,(%eax)
 287:	0f b6 00             	movzbl (%eax),%eax
 28a:	84 c0                	test   %al,%al
 28c:	75 e2                	jne    270 <strcpy+0xd>
    ;
  return os;
 28e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 296:	eb 08                	jmp    2a0 <strcmp+0xd>
    p++, q++;
 298:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 29c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	84 c0                	test   %al,%al
 2a8:	74 10                	je     2ba <strcmp+0x27>
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	0f b6 10             	movzbl (%eax),%edx
 2b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b3:	0f b6 00             	movzbl (%eax),%eax
 2b6:	38 c2                	cmp    %al,%dl
 2b8:	74 de                	je     298 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	0f b6 00             	movzbl (%eax),%eax
 2c0:	0f b6 d0             	movzbl %al,%edx
 2c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	0f b6 c0             	movzbl %al,%eax
 2cc:	29 c2                	sub    %eax,%edx
 2ce:	89 d0                	mov    %edx,%eax
}
 2d0:	5d                   	pop    %ebp
 2d1:	c3                   	ret    

000002d2 <strlen>:

uint
strlen(char *s)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2df:	eb 04                	jmp    2e5 <strlen+0x13>
 2e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	84 c0                	test   %al,%al
 2f2:	75 ed                	jne    2e1 <strlen+0xf>
    ;
  return n;
 2f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2fc:	8b 45 10             	mov    0x10(%ebp),%eax
 2ff:	50                   	push   %eax
 300:	ff 75 0c             	pushl  0xc(%ebp)
 303:	ff 75 08             	pushl  0x8(%ebp)
 306:	e8 32 ff ff ff       	call   23d <stosb>
 30b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <strchr>:

char*
strchr(const char *s, char c)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 04             	sub    $0x4,%esp
 319:	8b 45 0c             	mov    0xc(%ebp),%eax
 31c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 31f:	eb 14                	jmp    335 <strchr+0x22>
    if(*s == c)
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	0f b6 00             	movzbl (%eax),%eax
 327:	3a 45 fc             	cmp    -0x4(%ebp),%al
 32a:	75 05                	jne    331 <strchr+0x1e>
      return (char*)s;
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	eb 13                	jmp    344 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 331:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	84 c0                	test   %al,%al
 33d:	75 e2                	jne    321 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 33f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 344:	c9                   	leave  
 345:	c3                   	ret    

00000346 <gets>:

char*
gets(char *buf, int max)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 353:	eb 42                	jmp    397 <gets+0x51>
    cc = read(0, &c, 1);
 355:	83 ec 04             	sub    $0x4,%esp
 358:	6a 01                	push   $0x1
 35a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 35d:	50                   	push   %eax
 35e:	6a 00                	push   $0x0
 360:	e8 d5 01 00 00       	call   53a <read>
 365:	83 c4 10             	add    $0x10,%esp
 368:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 36b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 36f:	7e 33                	jle    3a4 <gets+0x5e>
      break;
    buf[i++] = c;
 371:	8b 45 f4             	mov    -0xc(%ebp),%eax
 374:	8d 50 01             	lea    0x1(%eax),%edx
 377:	89 55 f4             	mov    %edx,-0xc(%ebp)
 37a:	89 c2                	mov    %eax,%edx
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	01 c2                	add    %eax,%edx
 381:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 385:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 387:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 38b:	3c 0a                	cmp    $0xa,%al
 38d:	74 16                	je     3a5 <gets+0x5f>
 38f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 393:	3c 0d                	cmp    $0xd,%al
 395:	74 0e                	je     3a5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 397:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39a:	83 c0 01             	add    $0x1,%eax
 39d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3a0:	7c b3                	jl     355 <gets+0xf>
 3a2:	eb 01                	jmp    3a5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3a4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	01 d0                	add    %edx,%eax
 3ad:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <stat>:

int
stat(char *n, struct stat *st)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3bb:	83 ec 08             	sub    $0x8,%esp
 3be:	6a 00                	push   $0x0
 3c0:	ff 75 08             	pushl  0x8(%ebp)
 3c3:	e8 9a 01 00 00       	call   562 <open>
 3c8:	83 c4 10             	add    $0x10,%esp
 3cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3d2:	79 07                	jns    3db <stat+0x26>
    return -1;
 3d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d9:	eb 25                	jmp    400 <stat+0x4b>
  r = fstat(fd, st);
 3db:	83 ec 08             	sub    $0x8,%esp
 3de:	ff 75 0c             	pushl  0xc(%ebp)
 3e1:	ff 75 f4             	pushl  -0xc(%ebp)
 3e4:	e8 91 01 00 00       	call   57a <fstat>
 3e9:	83 c4 10             	add    $0x10,%esp
 3ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3ef:	83 ec 0c             	sub    $0xc,%esp
 3f2:	ff 75 f4             	pushl  -0xc(%ebp)
 3f5:	e8 50 01 00 00       	call   54a <close>
 3fa:	83 c4 10             	add    $0x10,%esp
  return r;
 3fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <atoi>:

int
atoi(const char *s)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
 405:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 408:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 40f:	eb 25                	jmp    436 <atoi+0x34>
    n = n*10 + *s++ - '0';
 411:	8b 55 fc             	mov    -0x4(%ebp),%edx
 414:	89 d0                	mov    %edx,%eax
 416:	c1 e0 02             	shl    $0x2,%eax
 419:	01 d0                	add    %edx,%eax
 41b:	01 c0                	add    %eax,%eax
 41d:	89 c1                	mov    %eax,%ecx
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	8d 50 01             	lea    0x1(%eax),%edx
 425:	89 55 08             	mov    %edx,0x8(%ebp)
 428:	0f b6 00             	movzbl (%eax),%eax
 42b:	0f be c0             	movsbl %al,%eax
 42e:	01 c8                	add    %ecx,%eax
 430:	83 e8 30             	sub    $0x30,%eax
 433:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	3c 2f                	cmp    $0x2f,%al
 43e:	7e 0a                	jle    44a <atoi+0x48>
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	0f b6 00             	movzbl (%eax),%eax
 446:	3c 39                	cmp    $0x39,%al
 448:	7e c7                	jle    411 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 44a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <atoo>:

int
atoo(const char *s)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
 455:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
 45c:	eb 04                	jmp    462 <atoo+0x13>
        s++;
 45e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	0f b6 00             	movzbl (%eax),%eax
 468:	3c 20                	cmp    $0x20,%al
 46a:	74 f2                	je     45e <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
 46f:	0f b6 00             	movzbl (%eax),%eax
 472:	3c 2d                	cmp    $0x2d,%al
 474:	75 07                	jne    47d <atoo+0x2e>
 476:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 47b:	eb 05                	jmp    482 <atoo+0x33>
 47d:	b8 01 00 00 00       	mov    $0x1,%eax
 482:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	0f b6 00             	movzbl (%eax),%eax
 48b:	3c 2b                	cmp    $0x2b,%al
 48d:	74 0a                	je     499 <atoo+0x4a>
 48f:	8b 45 08             	mov    0x8(%ebp),%eax
 492:	0f b6 00             	movzbl (%eax),%eax
 495:	3c 2d                	cmp    $0x2d,%al
 497:	75 27                	jne    4c0 <atoo+0x71>
        s++;
 499:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
 49d:	eb 21                	jmp    4c0 <atoo+0x71>
        n = n*8 + *s++ - '0';
 49f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4a2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	8d 50 01             	lea    0x1(%eax),%edx
 4af:	89 55 08             	mov    %edx,0x8(%ebp)
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	01 c8                	add    %ecx,%eax
 4ba:	83 e8 30             	sub    $0x30,%eax
 4bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	0f b6 00             	movzbl (%eax),%eax
 4c6:	3c 2f                	cmp    $0x2f,%al
 4c8:	7e 0a                	jle    4d4 <atoo+0x85>
 4ca:	8b 45 08             	mov    0x8(%ebp),%eax
 4cd:	0f b6 00             	movzbl (%eax),%eax
 4d0:	3c 37                	cmp    $0x37,%al
 4d2:	7e cb                	jle    49f <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
 4d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4d7:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4db:	c9                   	leave  
 4dc:	c3                   	ret    

000004dd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4dd:	55                   	push   %ebp
 4de:	89 e5                	mov    %esp,%ebp
 4e0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4ef:	eb 17                	jmp    508 <memmove+0x2b>
    *dst++ = *src++;
 4f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4f4:	8d 50 01             	lea    0x1(%eax),%edx
 4f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4fd:	8d 4a 01             	lea    0x1(%edx),%ecx
 500:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 503:	0f b6 12             	movzbl (%edx),%edx
 506:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 508:	8b 45 10             	mov    0x10(%ebp),%eax
 50b:	8d 50 ff             	lea    -0x1(%eax),%edx
 50e:	89 55 10             	mov    %edx,0x10(%ebp)
 511:	85 c0                	test   %eax,%eax
 513:	7f dc                	jg     4f1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 515:	8b 45 08             	mov    0x8(%ebp),%eax
}
 518:	c9                   	leave  
 519:	c3                   	ret    

0000051a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 51a:	b8 01 00 00 00       	mov    $0x1,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <exit>:
SYSCALL(exit)
 522:	b8 02 00 00 00       	mov    $0x2,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <wait>:
SYSCALL(wait)
 52a:	b8 03 00 00 00       	mov    $0x3,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <pipe>:
SYSCALL(pipe)
 532:	b8 04 00 00 00       	mov    $0x4,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <read>:
SYSCALL(read)
 53a:	b8 05 00 00 00       	mov    $0x5,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <write>:
SYSCALL(write)
 542:	b8 10 00 00 00       	mov    $0x10,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <close>:
SYSCALL(close)
 54a:	b8 15 00 00 00       	mov    $0x15,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <kill>:
SYSCALL(kill)
 552:	b8 06 00 00 00       	mov    $0x6,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <exec>:
SYSCALL(exec)
 55a:	b8 07 00 00 00       	mov    $0x7,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <open>:
SYSCALL(open)
 562:	b8 0f 00 00 00       	mov    $0xf,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <mknod>:
SYSCALL(mknod)
 56a:	b8 11 00 00 00       	mov    $0x11,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <unlink>:
SYSCALL(unlink)
 572:	b8 12 00 00 00       	mov    $0x12,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <fstat>:
SYSCALL(fstat)
 57a:	b8 08 00 00 00       	mov    $0x8,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <link>:
SYSCALL(link)
 582:	b8 13 00 00 00       	mov    $0x13,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <mkdir>:
SYSCALL(mkdir)
 58a:	b8 14 00 00 00       	mov    $0x14,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <chdir>:
SYSCALL(chdir)
 592:	b8 09 00 00 00       	mov    $0x9,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <dup>:
SYSCALL(dup)
 59a:	b8 0a 00 00 00       	mov    $0xa,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <getpid>:
SYSCALL(getpid)
 5a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <sbrk>:
SYSCALL(sbrk)
 5aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <sleep>:
SYSCALL(sleep)
 5b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <uptime>:
SYSCALL(uptime)
 5ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <halt>:
SYSCALL(halt)
 5c2:	b8 16 00 00 00       	mov    $0x16,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <date>:
SYSCALL(date)
 5ca:	b8 17 00 00 00       	mov    $0x17,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <getuid>:
SYSCALL(getuid)
 5d2:	b8 18 00 00 00       	mov    $0x18,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <getgid>:
SYSCALL(getgid)
 5da:	b8 19 00 00 00       	mov    $0x19,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <getppid>:
SYSCALL(getppid)
 5e2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <setuid>:
SYSCALL(setuid)
 5ea:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <setgid>:
SYSCALL(setgid)
 5f2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <getprocs>:
SYSCALL(getprocs)
 5fa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <setpriority>:
SYSCALL(setpriority)
 602:	b8 1e 00 00 00       	mov    $0x1e,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <chmod>:
SYSCALL(chmod)
 60a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <chown>:
SYSCALL(chown)
 612:	b8 20 00 00 00       	mov    $0x20,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <chgrp>:
SYSCALL(chgrp)
 61a:	b8 21 00 00 00       	mov    $0x21,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 622:	55                   	push   %ebp
 623:	89 e5                	mov    %esp,%ebp
 625:	83 ec 18             	sub    $0x18,%esp
 628:	8b 45 0c             	mov    0xc(%ebp),%eax
 62b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 62e:	83 ec 04             	sub    $0x4,%esp
 631:	6a 01                	push   $0x1
 633:	8d 45 f4             	lea    -0xc(%ebp),%eax
 636:	50                   	push   %eax
 637:	ff 75 08             	pushl  0x8(%ebp)
 63a:	e8 03 ff ff ff       	call   542 <write>
 63f:	83 c4 10             	add    $0x10,%esp
}
 642:	90                   	nop
 643:	c9                   	leave  
 644:	c3                   	ret    

00000645 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 645:	55                   	push   %ebp
 646:	89 e5                	mov    %esp,%ebp
 648:	53                   	push   %ebx
 649:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 64c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 653:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 657:	74 17                	je     670 <printint+0x2b>
 659:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 65d:	79 11                	jns    670 <printint+0x2b>
    neg = 1;
 65f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 666:	8b 45 0c             	mov    0xc(%ebp),%eax
 669:	f7 d8                	neg    %eax
 66b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 66e:	eb 06                	jmp    676 <printint+0x31>
  } else {
    x = xx;
 670:	8b 45 0c             	mov    0xc(%ebp),%eax
 673:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 676:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 67d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 680:	8d 41 01             	lea    0x1(%ecx),%eax
 683:	89 45 f4             	mov    %eax,-0xc(%ebp)
 686:	8b 5d 10             	mov    0x10(%ebp),%ebx
 689:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68c:	ba 00 00 00 00       	mov    $0x0,%edx
 691:	f7 f3                	div    %ebx
 693:	89 d0                	mov    %edx,%eax
 695:	0f b6 80 ac 0d 00 00 	movzbl 0xdac(%eax),%eax
 69c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a6:	ba 00 00 00 00       	mov    $0x0,%edx
 6ab:	f7 f3                	div    %ebx
 6ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b4:	75 c7                	jne    67d <printint+0x38>
  if(neg)
 6b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ba:	74 2d                	je     6e9 <printint+0xa4>
    buf[i++] = '-';
 6bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bf:	8d 50 01             	lea    0x1(%eax),%edx
 6c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ca:	eb 1d                	jmp    6e9 <printint+0xa4>
    putc(fd, buf[i]);
 6cc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d2:	01 d0                	add    %edx,%eax
 6d4:	0f b6 00             	movzbl (%eax),%eax
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	83 ec 08             	sub    $0x8,%esp
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 3c ff ff ff       	call   622 <putc>
 6e6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6e9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f1:	79 d9                	jns    6cc <printint+0x87>
    putc(fd, buf[i]);
}
 6f3:	90                   	nop
 6f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6f9:	55                   	push   %ebp
 6fa:	89 e5                	mov    %esp,%ebp
 6fc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 706:	8d 45 0c             	lea    0xc(%ebp),%eax
 709:	83 c0 04             	add    $0x4,%eax
 70c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 70f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 716:	e9 59 01 00 00       	jmp    874 <printf+0x17b>
    c = fmt[i] & 0xff;
 71b:	8b 55 0c             	mov    0xc(%ebp),%edx
 71e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 721:	01 d0                	add    %edx,%eax
 723:	0f b6 00             	movzbl (%eax),%eax
 726:	0f be c0             	movsbl %al,%eax
 729:	25 ff 00 00 00       	and    $0xff,%eax
 72e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 731:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 735:	75 2c                	jne    763 <printf+0x6a>
      if(c == '%'){
 737:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73b:	75 0c                	jne    749 <printf+0x50>
        state = '%';
 73d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 744:	e9 27 01 00 00       	jmp    870 <printf+0x177>
      } else {
        putc(fd, c);
 749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	83 ec 08             	sub    $0x8,%esp
 752:	50                   	push   %eax
 753:	ff 75 08             	pushl  0x8(%ebp)
 756:	e8 c7 fe ff ff       	call   622 <putc>
 75b:	83 c4 10             	add    $0x10,%esp
 75e:	e9 0d 01 00 00       	jmp    870 <printf+0x177>
      }
    } else if(state == '%'){
 763:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 767:	0f 85 03 01 00 00    	jne    870 <printf+0x177>
      if(c == 'd'){
 76d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 771:	75 1e                	jne    791 <printf+0x98>
        printint(fd, *ap, 10, 1);
 773:	8b 45 e8             	mov    -0x18(%ebp),%eax
 776:	8b 00                	mov    (%eax),%eax
 778:	6a 01                	push   $0x1
 77a:	6a 0a                	push   $0xa
 77c:	50                   	push   %eax
 77d:	ff 75 08             	pushl  0x8(%ebp)
 780:	e8 c0 fe ff ff       	call   645 <printint>
 785:	83 c4 10             	add    $0x10,%esp
        ap++;
 788:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78c:	e9 d8 00 00 00       	jmp    869 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 791:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 795:	74 06                	je     79d <printf+0xa4>
 797:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 79b:	75 1e                	jne    7bb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 79d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	6a 00                	push   $0x0
 7a4:	6a 10                	push   $0x10
 7a6:	50                   	push   %eax
 7a7:	ff 75 08             	pushl  0x8(%ebp)
 7aa:	e8 96 fe ff ff       	call   645 <printint>
 7af:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7b6:	e9 ae 00 00 00       	jmp    869 <printf+0x170>
      } else if(c == 's'){
 7bb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7bf:	75 43                	jne    804 <printf+0x10b>
        s = (char*)*ap;
 7c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d1:	75 25                	jne    7f8 <printf+0xff>
          s = "(null)";
 7d3:	c7 45 f4 30 0b 00 00 	movl   $0xb30,-0xc(%ebp)
        while(*s != 0){
 7da:	eb 1c                	jmp    7f8 <printf+0xff>
          putc(fd, *s);
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	0f b6 00             	movzbl (%eax),%eax
 7e2:	0f be c0             	movsbl %al,%eax
 7e5:	83 ec 08             	sub    $0x8,%esp
 7e8:	50                   	push   %eax
 7e9:	ff 75 08             	pushl  0x8(%ebp)
 7ec:	e8 31 fe ff ff       	call   622 <putc>
 7f1:	83 c4 10             	add    $0x10,%esp
          s++;
 7f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	0f b6 00             	movzbl (%eax),%eax
 7fe:	84 c0                	test   %al,%al
 800:	75 da                	jne    7dc <printf+0xe3>
 802:	eb 65                	jmp    869 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 804:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 808:	75 1d                	jne    827 <printf+0x12e>
        putc(fd, *ap);
 80a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80d:	8b 00                	mov    (%eax),%eax
 80f:	0f be c0             	movsbl %al,%eax
 812:	83 ec 08             	sub    $0x8,%esp
 815:	50                   	push   %eax
 816:	ff 75 08             	pushl  0x8(%ebp)
 819:	e8 04 fe ff ff       	call   622 <putc>
 81e:	83 c4 10             	add    $0x10,%esp
        ap++;
 821:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 825:	eb 42                	jmp    869 <printf+0x170>
      } else if(c == '%'){
 827:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 82b:	75 17                	jne    844 <printf+0x14b>
        putc(fd, c);
 82d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 830:	0f be c0             	movsbl %al,%eax
 833:	83 ec 08             	sub    $0x8,%esp
 836:	50                   	push   %eax
 837:	ff 75 08             	pushl  0x8(%ebp)
 83a:	e8 e3 fd ff ff       	call   622 <putc>
 83f:	83 c4 10             	add    $0x10,%esp
 842:	eb 25                	jmp    869 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 844:	83 ec 08             	sub    $0x8,%esp
 847:	6a 25                	push   $0x25
 849:	ff 75 08             	pushl  0x8(%ebp)
 84c:	e8 d1 fd ff ff       	call   622 <putc>
 851:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 857:	0f be c0             	movsbl %al,%eax
 85a:	83 ec 08             	sub    $0x8,%esp
 85d:	50                   	push   %eax
 85e:	ff 75 08             	pushl  0x8(%ebp)
 861:	e8 bc fd ff ff       	call   622 <putc>
 866:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 869:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 870:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 874:	8b 55 0c             	mov    0xc(%ebp),%edx
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	01 d0                	add    %edx,%eax
 87c:	0f b6 00             	movzbl (%eax),%eax
 87f:	84 c0                	test   %al,%al
 881:	0f 85 94 fe ff ff    	jne    71b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 887:	90                   	nop
 888:	c9                   	leave  
 889:	c3                   	ret    

0000088a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88a:	55                   	push   %ebp
 88b:	89 e5                	mov    %esp,%ebp
 88d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 890:	8b 45 08             	mov    0x8(%ebp),%eax
 893:	83 e8 08             	sub    $0x8,%eax
 896:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 899:	a1 c8 0d 00 00       	mov    0xdc8,%eax
 89e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a1:	eb 24                	jmp    8c7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a6:	8b 00                	mov    (%eax),%eax
 8a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ab:	77 12                	ja     8bf <free+0x35>
 8ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b3:	77 24                	ja     8d9 <free+0x4f>
 8b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8bd:	77 1a                	ja     8d9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c2:	8b 00                	mov    (%eax),%eax
 8c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8cd:	76 d4                	jbe    8a3 <free+0x19>
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 00                	mov    (%eax),%eax
 8d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d7:	76 ca                	jbe    8a3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dc:	8b 40 04             	mov    0x4(%eax),%eax
 8df:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e9:	01 c2                	add    %eax,%edx
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	39 c2                	cmp    %eax,%edx
 8f2:	75 24                	jne    918 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f7:	8b 50 04             	mov    0x4(%eax),%edx
 8fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fd:	8b 00                	mov    (%eax),%eax
 8ff:	8b 40 04             	mov    0x4(%eax),%eax
 902:	01 c2                	add    %eax,%edx
 904:	8b 45 f8             	mov    -0x8(%ebp),%eax
 907:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	8b 10                	mov    (%eax),%edx
 911:	8b 45 f8             	mov    -0x8(%ebp),%eax
 914:	89 10                	mov    %edx,(%eax)
 916:	eb 0a                	jmp    922 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	8b 10                	mov    (%eax),%edx
 91d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 920:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 922:	8b 45 fc             	mov    -0x4(%ebp),%eax
 925:	8b 40 04             	mov    0x4(%eax),%eax
 928:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	01 d0                	add    %edx,%eax
 934:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 937:	75 20                	jne    959 <free+0xcf>
    p->s.size += bp->s.size;
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 50 04             	mov    0x4(%eax),%edx
 93f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	01 c2                	add    %eax,%edx
 947:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 94d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 950:	8b 10                	mov    (%eax),%edx
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	89 10                	mov    %edx,(%eax)
 957:	eb 08                	jmp    961 <free+0xd7>
  } else
    p->s.ptr = bp;
 959:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 95f:	89 10                	mov    %edx,(%eax)
  freep = p;
 961:	8b 45 fc             	mov    -0x4(%ebp),%eax
 964:	a3 c8 0d 00 00       	mov    %eax,0xdc8
}
 969:	90                   	nop
 96a:	c9                   	leave  
 96b:	c3                   	ret    

0000096c <morecore>:

static Header*
morecore(uint nu)
{
 96c:	55                   	push   %ebp
 96d:	89 e5                	mov    %esp,%ebp
 96f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 972:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 979:	77 07                	ja     982 <morecore+0x16>
    nu = 4096;
 97b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 982:	8b 45 08             	mov    0x8(%ebp),%eax
 985:	c1 e0 03             	shl    $0x3,%eax
 988:	83 ec 0c             	sub    $0xc,%esp
 98b:	50                   	push   %eax
 98c:	e8 19 fc ff ff       	call   5aa <sbrk>
 991:	83 c4 10             	add    $0x10,%esp
 994:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 997:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 99b:	75 07                	jne    9a4 <morecore+0x38>
    return 0;
 99d:	b8 00 00 00 00       	mov    $0x0,%eax
 9a2:	eb 26                	jmp    9ca <morecore+0x5e>
  hp = (Header*)p;
 9a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ad:	8b 55 08             	mov    0x8(%ebp),%edx
 9b0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b6:	83 c0 08             	add    $0x8,%eax
 9b9:	83 ec 0c             	sub    $0xc,%esp
 9bc:	50                   	push   %eax
 9bd:	e8 c8 fe ff ff       	call   88a <free>
 9c2:	83 c4 10             	add    $0x10,%esp
  return freep;
 9c5:	a1 c8 0d 00 00       	mov    0xdc8,%eax
}
 9ca:	c9                   	leave  
 9cb:	c3                   	ret    

000009cc <malloc>:

void*
malloc(uint nbytes)
{
 9cc:	55                   	push   %ebp
 9cd:	89 e5                	mov    %esp,%ebp
 9cf:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d2:	8b 45 08             	mov    0x8(%ebp),%eax
 9d5:	83 c0 07             	add    $0x7,%eax
 9d8:	c1 e8 03             	shr    $0x3,%eax
 9db:	83 c0 01             	add    $0x1,%eax
 9de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9e1:	a1 c8 0d 00 00       	mov    0xdc8,%eax
 9e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ed:	75 23                	jne    a12 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9ef:	c7 45 f0 c0 0d 00 00 	movl   $0xdc0,-0x10(%ebp)
 9f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f9:	a3 c8 0d 00 00       	mov    %eax,0xdc8
 9fe:	a1 c8 0d 00 00       	mov    0xdc8,%eax
 a03:	a3 c0 0d 00 00       	mov    %eax,0xdc0
    base.s.size = 0;
 a08:	c7 05 c4 0d 00 00 00 	movl   $0x0,0xdc4
 a0f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a15:	8b 00                	mov    (%eax),%eax
 a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1d:	8b 40 04             	mov    0x4(%eax),%eax
 a20:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a23:	72 4d                	jb     a72 <malloc+0xa6>
      if(p->s.size == nunits)
 a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a28:	8b 40 04             	mov    0x4(%eax),%eax
 a2b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a2e:	75 0c                	jne    a3c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a33:	8b 10                	mov    (%eax),%edx
 a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a38:	89 10                	mov    %edx,(%eax)
 a3a:	eb 26                	jmp    a62 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3f:	8b 40 04             	mov    0x4(%eax),%eax
 a42:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a45:	89 c2                	mov    %eax,%edx
 a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	8b 40 04             	mov    0x4(%eax),%eax
 a53:	c1 e0 03             	shl    $0x3,%eax
 a56:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a5f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a65:	a3 c8 0d 00 00       	mov    %eax,0xdc8
      return (void*)(p + 1);
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	83 c0 08             	add    $0x8,%eax
 a70:	eb 3b                	jmp    aad <malloc+0xe1>
    }
    if(p == freep)
 a72:	a1 c8 0d 00 00       	mov    0xdc8,%eax
 a77:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a7a:	75 1e                	jne    a9a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a7c:	83 ec 0c             	sub    $0xc,%esp
 a7f:	ff 75 ec             	pushl  -0x14(%ebp)
 a82:	e8 e5 fe ff ff       	call   96c <morecore>
 a87:	83 c4 10             	add    $0x10,%esp
 a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a91:	75 07                	jne    a9a <malloc+0xce>
        return 0;
 a93:	b8 00 00 00 00       	mov    $0x0,%eax
 a98:	eb 13                	jmp    aad <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa3:	8b 00                	mov    (%eax),%eax
 aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 aa8:	e9 6d ff ff ff       	jmp    a1a <malloc+0x4e>
}
 aad:	c9                   	leave  
 aae:	c3                   	ret    
