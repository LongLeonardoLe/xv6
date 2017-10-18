
_testuidgid:     file format elf32-i386


Disassembly of section .text:

00000000 <uidTest>:
#include "types.h"
#include "user.h"
#define TPS 300

static void
uidTest(uint nval) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    uint uid = getuid();
   6:	e8 db 06 00 00       	call   6e6 <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(1, "Current UID is %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 c4 0b 00 00       	push   $0xbc4
  19:	6a 01                	push   $0x1
  1b:	e8 ed 07 00 00       	call   80d <printf>
  20:	83 c4 10             	add    $0x10,%esp
    printf(1, "Setting UID to %d\n", nval);
  23:	83 ec 04             	sub    $0x4,%esp
  26:	ff 75 08             	pushl  0x8(%ebp)
  29:	68 d7 0b 00 00       	push   $0xbd7
  2e:	6a 01                	push   $0x1
  30:	e8 d8 07 00 00       	call   80d <printf>
  35:	83 c4 10             	add    $0x10,%esp
    if (setuid(nval) < 0)
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	ff 75 08             	pushl  0x8(%ebp)
  3e:	e8 bb 06 00 00       	call   6fe <setuid>
  43:	83 c4 10             	add    $0x10,%esp
  46:	85 c0                	test   %eax,%eax
  48:	79 15                	jns    5f <uidTest+0x5f>
        printf(2, "Error. Invalid UID: %d\n", nval);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 08             	pushl  0x8(%ebp)
  50:	68 ea 0b 00 00       	push   $0xbea
  55:	6a 02                	push   $0x2
  57:	e8 b1 07 00 00       	call   80d <printf>
  5c:	83 c4 10             	add    $0x10,%esp
    uid = getuid();
  5f:	e8 82 06 00 00       	call   6e6 <getuid>
  64:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(1, "Current UID is %d\n", uid);
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	ff 75 f4             	pushl  -0xc(%ebp)
  6d:	68 c4 0b 00 00       	push   $0xbc4
  72:	6a 01                	push   $0x1
  74:	e8 94 07 00 00       	call   80d <printf>
  79:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);
  7c:	83 ec 0c             	sub    $0xc,%esp
  7f:	68 dc 05 00 00       	push   $0x5dc
  84:	e8 3d 06 00 00       	call   6c6 <sleep>
  89:	83 c4 10             	add    $0x10,%esp
}
  8c:	90                   	nop
  8d:	c9                   	leave  
  8e:	c3                   	ret    

0000008f <gidTest>:

static void
gidTest(uint nval) {
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	83 ec 18             	sub    $0x18,%esp
    uint gid = getgid();
  95:	e8 54 06 00 00       	call   6ee <getgid>
  9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(1, "Current GID is %d\n", gid);
  9d:	83 ec 04             	sub    $0x4,%esp
  a0:	ff 75 f4             	pushl  -0xc(%ebp)
  a3:	68 02 0c 00 00       	push   $0xc02
  a8:	6a 01                	push   $0x1
  aa:	e8 5e 07 00 00       	call   80d <printf>
  af:	83 c4 10             	add    $0x10,%esp
    printf(1, "Setting GID to %d\n", nval);
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	ff 75 08             	pushl  0x8(%ebp)
  b8:	68 15 0c 00 00       	push   $0xc15
  bd:	6a 01                	push   $0x1
  bf:	e8 49 07 00 00       	call   80d <printf>
  c4:	83 c4 10             	add    $0x10,%esp
    if (setgid(nval) < 0)
  c7:	83 ec 0c             	sub    $0xc,%esp
  ca:	ff 75 08             	pushl  0x8(%ebp)
  cd:	e8 34 06 00 00       	call   706 <setgid>
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	85 c0                	test   %eax,%eax
  d7:	79 15                	jns    ee <gidTest+0x5f>
        printf(2, "Error. Invalid GID: %d\n", nval);
  d9:	83 ec 04             	sub    $0x4,%esp
  dc:	ff 75 08             	pushl  0x8(%ebp)
  df:	68 28 0c 00 00       	push   $0xc28
  e4:	6a 02                	push   $0x2
  e6:	e8 22 07 00 00       	call   80d <printf>
  eb:	83 c4 10             	add    $0x10,%esp
    gid = getgid();
  ee:	e8 fb 05 00 00       	call   6ee <getgid>
  f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(1, "Current GID is %d\n", gid);
  f6:	83 ec 04             	sub    $0x4,%esp
  f9:	ff 75 f4             	pushl  -0xc(%ebp)
  fc:	68 02 0c 00 00       	push   $0xc02
 101:	6a 01                	push   $0x1
 103:	e8 05 07 00 00       	call   80d <printf>
 108:	83 c4 10             	add    $0x10,%esp
    sleep(5 * TPS);
 10b:	83 ec 0c             	sub    $0xc,%esp
 10e:	68 dc 05 00 00       	push   $0x5dc
 113:	e8 ae 05 00 00       	call   6c6 <sleep>
 118:	83 c4 10             	add    $0x10,%esp
}
 11b:	90                   	nop
 11c:	c9                   	leave  
 11d:	c3                   	ret    

0000011e <forkTest>:

static void
forkTest(uint nval) {
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
 121:	53                   	push   %ebx
 122:	83 ec 14             	sub    $0x14,%esp
    uint uid, gid;
    int pid;

    printf(1, "Setting UID to %d and GID to %d before fork(). Value should be inherited\n", nval, nval);
 125:	ff 75 08             	pushl  0x8(%ebp)
 128:	ff 75 08             	pushl  0x8(%ebp)
 12b:	68 40 0c 00 00       	push   $0xc40
 130:	6a 01                	push   $0x1
 132:	e8 d6 06 00 00       	call   80d <printf>
 137:	83 c4 10             	add    $0x10,%esp

    if (setuid(nval) < 0)
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 08             	pushl  0x8(%ebp)
 140:	e8 b9 05 00 00       	call   6fe <setuid>
 145:	83 c4 10             	add    $0x10,%esp
 148:	85 c0                	test   %eax,%eax
 14a:	79 15                	jns    161 <forkTest+0x43>
        printf(2, "Error. Invalid UID: %d\n", nval);
 14c:	83 ec 04             	sub    $0x4,%esp
 14f:	ff 75 08             	pushl  0x8(%ebp)
 152:	68 ea 0b 00 00       	push   $0xbea
 157:	6a 02                	push   $0x2
 159:	e8 af 06 00 00       	call   80d <printf>
 15e:	83 c4 10             	add    $0x10,%esp
    if (setgid(nval) < 0)
 161:	83 ec 0c             	sub    $0xc,%esp
 164:	ff 75 08             	pushl  0x8(%ebp)
 167:	e8 9a 05 00 00       	call   706 <setgid>
 16c:	83 c4 10             	add    $0x10,%esp
 16f:	85 c0                	test   %eax,%eax
 171:	79 15                	jns    188 <forkTest+0x6a>
        printf(2, "Error. Invalid GID: %d\n", nval);
 173:	83 ec 04             	sub    $0x4,%esp
 176:	ff 75 08             	pushl  0x8(%ebp)
 179:	68 28 0c 00 00       	push   $0xc28
 17e:	6a 02                	push   $0x2
 180:	e8 88 06 00 00       	call   80d <printf>
 185:	83 c4 10             	add    $0x10,%esp

    printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getuid());
 188:	e8 59 05 00 00       	call   6e6 <getuid>
 18d:	89 c3                	mov    %eax,%ebx
 18f:	e8 52 05 00 00       	call   6e6 <getuid>
 194:	53                   	push   %ebx
 195:	50                   	push   %eax
 196:	68 8c 0c 00 00       	push   $0xc8c
 19b:	6a 01                	push   $0x1
 19d:	e8 6b 06 00 00       	call   80d <printf>
 1a2:	83 c4 10             	add    $0x10,%esp
    pid = fork();
 1a5:	e8 84 04 00 00       	call   62e <fork>
 1aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (pid == 0) {
 1ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b1:	75 3a                	jne    1ed <forkTest+0xcf>
        uid = getuid();
 1b3:	e8 2e 05 00 00       	call   6e6 <getuid>
 1b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        gid = getgid();
 1bb:	e8 2e 05 00 00       	call   6ee <getgid>
 1c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        printf(1, "Child: UID is: %d, GID is: %d\n", uid, gid);
 1c3:	ff 75 ec             	pushl  -0x14(%ebp)
 1c6:	ff 75 f0             	pushl  -0x10(%ebp)
 1c9:	68 b0 0c 00 00       	push   $0xcb0
 1ce:	6a 01                	push   $0x1
 1d0:	e8 38 06 00 00       	call   80d <printf>
 1d5:	83 c4 10             	add    $0x10,%esp
        sleep(5 * TPS);
 1d8:	83 ec 0c             	sub    $0xc,%esp
 1db:	68 dc 05 00 00       	push   $0x5dc
 1e0:	e8 e1 04 00 00       	call   6c6 <sleep>
 1e5:	83 c4 10             	add    $0x10,%esp
        exit();
 1e8:	e8 49 04 00 00       	call   636 <exit>
    }
    else
        sleep(10 * TPS);
 1ed:	83 ec 0c             	sub    $0xc,%esp
 1f0:	68 b8 0b 00 00       	push   $0xbb8
 1f5:	e8 cc 04 00 00       	call   6c6 <sleep>
 1fa:	83 c4 10             	add    $0x10,%esp
}
 1fd:	90                   	nop
 1fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 201:	c9                   	leave  
 202:	c3                   	ret    

00000203 <invalidTest>:

static void
invalidTest(uint nval) {
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	83 ec 08             	sub    $0x8,%esp
    printf(1, "Setting UID to %d. This test should FAIL\n", nval);
 209:	83 ec 04             	sub    $0x4,%esp
 20c:	ff 75 08             	pushl  0x8(%ebp)
 20f:	68 d0 0c 00 00       	push   $0xcd0
 214:	6a 01                	push   $0x1
 216:	e8 f2 05 00 00       	call   80d <printf>
 21b:	83 c4 10             	add    $0x10,%esp
    if (setuid(nval) < 0)
 21e:	83 ec 0c             	sub    $0xc,%esp
 221:	ff 75 08             	pushl  0x8(%ebp)
 224:	e8 d5 04 00 00       	call   6fe <setuid>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	85 c0                	test   %eax,%eax
 22e:	79 14                	jns    244 <invalidTest+0x41>
        printf(1, "SUCCESS! The setuid system call indicated failure\n");
 230:	83 ec 08             	sub    $0x8,%esp
 233:	68 fc 0c 00 00       	push   $0xcfc
 238:	6a 01                	push   $0x1
 23a:	e8 ce 05 00 00       	call   80d <printf>
 23f:	83 c4 10             	add    $0x10,%esp
 242:	eb 12                	jmp    256 <invalidTest+0x53>
    else
        printf(2, "FAILURE! The setuid system call indicated success\n");
 244:	83 ec 08             	sub    $0x8,%esp
 247:	68 30 0d 00 00       	push   $0xd30
 24c:	6a 02                	push   $0x2
 24e:	e8 ba 05 00 00       	call   80d <printf>
 253:	83 c4 10             	add    $0x10,%esp

    printf(1, "Setting GID to %d. This test should FAIL\n", nval);
 256:	83 ec 04             	sub    $0x4,%esp
 259:	ff 75 08             	pushl  0x8(%ebp)
 25c:	68 64 0d 00 00       	push   $0xd64
 261:	6a 01                	push   $0x1
 263:	e8 a5 05 00 00       	call   80d <printf>
 268:	83 c4 10             	add    $0x10,%esp
    if (setgid(nval) < 0)
 26b:	83 ec 0c             	sub    $0xc,%esp
 26e:	ff 75 08             	pushl  0x8(%ebp)
 271:	e8 90 04 00 00       	call   706 <setgid>
 276:	83 c4 10             	add    $0x10,%esp
 279:	85 c0                	test   %eax,%eax
 27b:	79 14                	jns    291 <invalidTest+0x8e>
        printf(1, "SUCCESS! The setgid system call indicated failure\n");
 27d:	83 ec 08             	sub    $0x8,%esp
 280:	68 90 0d 00 00       	push   $0xd90
 285:	6a 01                	push   $0x1
 287:	e8 81 05 00 00       	call   80d <printf>
 28c:	83 c4 10             	add    $0x10,%esp
    else
        printf(2, "FAILURE! The setgid system call indicated success\n");
}
 28f:	eb 12                	jmp    2a3 <invalidTest+0xa0>

    printf(1, "Setting GID to %d. This test should FAIL\n", nval);
    if (setgid(nval) < 0)
        printf(1, "SUCCESS! The setgid system call indicated failure\n");
    else
        printf(2, "FAILURE! The setgid system call indicated success\n");
 291:	83 ec 08             	sub    $0x8,%esp
 294:	68 c4 0d 00 00       	push   $0xdc4
 299:	6a 02                	push   $0x2
 29b:	e8 6d 05 00 00       	call   80d <printf>
 2a0:	83 c4 10             	add    $0x10,%esp
}
 2a3:	90                   	nop
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <test>:

static int
test(void) {
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 18             	sub    $0x18,%esp
    uint nval, ppid;

    // UID test
    nval = 100;
 2ac:	c7 45 f4 64 00 00 00 	movl   $0x64,-0xc(%ebp)
    uidTest(nval);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	pushl  -0xc(%ebp)
 2b9:	e8 42 fd ff ff       	call   0 <uidTest>
 2be:	83 c4 10             	add    $0x10,%esp

    // GID test
    nval = 200;
 2c1:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%ebp)
    gidTest(nval);
 2c8:	83 ec 0c             	sub    $0xc,%esp
 2cb:	ff 75 f4             	pushl  -0xc(%ebp)
 2ce:	e8 bc fd ff ff       	call   8f <gidTest>
 2d3:	83 c4 10             	add    $0x10,%esp

    // PPID test
    ppid = getppid();
 2d6:	e8 1b 04 00 00       	call   6f6 <getppid>
 2db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1, "My parent process is %d\n", ppid);
 2de:	83 ec 04             	sub    $0x4,%esp
 2e1:	ff 75 f0             	pushl  -0x10(%ebp)
 2e4:	68 f7 0d 00 00       	push   $0xdf7
 2e9:	6a 01                	push   $0x1
 2eb:	e8 1d 05 00 00       	call   80d <printf>
 2f0:	83 c4 10             	add    $0x10,%esp

    // fork test
    nval = 11;
 2f3:	c7 45 f4 0b 00 00 00 	movl   $0xb,-0xc(%ebp)
    forkTest(nval);
 2fa:	83 ec 0c             	sub    $0xc,%esp
 2fd:	ff 75 f4             	pushl  -0xc(%ebp)
 300:	e8 19 fe ff ff       	call   11e <forkTest>
 305:	83 c4 10             	add    $0x10,%esp

    // test the invalid value
    nval = 32800; // 32767 is the max
 308:	c7 45 f4 20 80 00 00 	movl   $0x8020,-0xc(%ebp)
    invalidTest(nval);
 30f:	83 ec 0c             	sub    $0xc,%esp
 312:	ff 75 f4             	pushl  -0xc(%ebp)
 315:	e8 e9 fe ff ff       	call   203 <invalidTest>
 31a:	83 c4 10             	add    $0x10,%esp

    printf(1, "Done!\n");
 31d:	83 ec 08             	sub    $0x8,%esp
 320:	68 10 0e 00 00       	push   $0xe10
 325:	6a 01                	push   $0x1
 327:	e8 e1 04 00 00       	call   80d <printf>
 32c:	83 c4 10             	add    $0x10,%esp
    return 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <main>:

int
main() {
 336:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 33a:	83 e4 f0             	and    $0xfffffff0,%esp
 33d:	ff 71 fc             	pushl  -0x4(%ecx)
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	51                   	push   %ecx
 344:	83 ec 04             	sub    $0x4,%esp
    test();
 347:	e8 5a ff ff ff       	call   2a6 <test>
    exit();
 34c:	e8 e5 02 00 00       	call   636 <exit>

00000351 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
 354:	57                   	push   %edi
 355:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 356:	8b 4d 08             	mov    0x8(%ebp),%ecx
 359:	8b 55 10             	mov    0x10(%ebp),%edx
 35c:	8b 45 0c             	mov    0xc(%ebp),%eax
 35f:	89 cb                	mov    %ecx,%ebx
 361:	89 df                	mov    %ebx,%edi
 363:	89 d1                	mov    %edx,%ecx
 365:	fc                   	cld    
 366:	f3 aa                	rep stos %al,%es:(%edi)
 368:	89 ca                	mov    %ecx,%edx
 36a:	89 fb                	mov    %edi,%ebx
 36c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 36f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 372:	90                   	nop
 373:	5b                   	pop    %ebx
 374:	5f                   	pop    %edi
 375:	5d                   	pop    %ebp
 376:	c3                   	ret    

00000377 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
 37a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 383:	90                   	nop
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	8d 50 01             	lea    0x1(%eax),%edx
 38a:	89 55 08             	mov    %edx,0x8(%ebp)
 38d:	8b 55 0c             	mov    0xc(%ebp),%edx
 390:	8d 4a 01             	lea    0x1(%edx),%ecx
 393:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 396:	0f b6 12             	movzbl (%edx),%edx
 399:	88 10                	mov    %dl,(%eax)
 39b:	0f b6 00             	movzbl (%eax),%eax
 39e:	84 c0                	test   %al,%al
 3a0:	75 e2                	jne    384 <strcpy+0xd>
    ;
  return os;
 3a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a5:	c9                   	leave  
 3a6:	c3                   	ret    

000003a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3aa:	eb 08                	jmp    3b4 <strcmp+0xd>
    p++, q++;
 3ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	0f b6 00             	movzbl (%eax),%eax
 3ba:	84 c0                	test   %al,%al
 3bc:	74 10                	je     3ce <strcmp+0x27>
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
 3c1:	0f b6 10             	movzbl (%eax),%edx
 3c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c7:	0f b6 00             	movzbl (%eax),%eax
 3ca:	38 c2                	cmp    %al,%dl
 3cc:	74 de                	je     3ac <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	0f b6 00             	movzbl (%eax),%eax
 3d4:	0f b6 d0             	movzbl %al,%edx
 3d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	0f b6 c0             	movzbl %al,%eax
 3e0:	29 c2                	sub    %eax,%edx
 3e2:	89 d0                	mov    %edx,%eax
}
 3e4:	5d                   	pop    %ebp
 3e5:	c3                   	ret    

000003e6 <strlen>:

uint
strlen(char *s)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f3:	eb 04                	jmp    3f9 <strlen+0x13>
 3f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	01 d0                	add    %edx,%eax
 401:	0f b6 00             	movzbl (%eax),%eax
 404:	84 c0                	test   %al,%al
 406:	75 ed                	jne    3f5 <strlen+0xf>
    ;
  return n;
 408:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 40b:	c9                   	leave  
 40c:	c3                   	ret    

0000040d <memset>:

void*
memset(void *dst, int c, uint n)
{
 40d:	55                   	push   %ebp
 40e:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 410:	8b 45 10             	mov    0x10(%ebp),%eax
 413:	50                   	push   %eax
 414:	ff 75 0c             	pushl  0xc(%ebp)
 417:	ff 75 08             	pushl  0x8(%ebp)
 41a:	e8 32 ff ff ff       	call   351 <stosb>
 41f:	83 c4 0c             	add    $0xc,%esp
  return dst;
 422:	8b 45 08             	mov    0x8(%ebp),%eax
}
 425:	c9                   	leave  
 426:	c3                   	ret    

00000427 <strchr>:

char*
strchr(const char *s, char c)
{
 427:	55                   	push   %ebp
 428:	89 e5                	mov    %esp,%ebp
 42a:	83 ec 04             	sub    $0x4,%esp
 42d:	8b 45 0c             	mov    0xc(%ebp),%eax
 430:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 433:	eb 14                	jmp    449 <strchr+0x22>
    if(*s == c)
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	0f b6 00             	movzbl (%eax),%eax
 43b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 43e:	75 05                	jne    445 <strchr+0x1e>
      return (char*)s;
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	eb 13                	jmp    458 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 445:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	0f b6 00             	movzbl (%eax),%eax
 44f:	84 c0                	test   %al,%al
 451:	75 e2                	jne    435 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 453:	b8 00 00 00 00       	mov    $0x0,%eax
}
 458:	c9                   	leave  
 459:	c3                   	ret    

0000045a <gets>:

char*
gets(char *buf, int max)
{
 45a:	55                   	push   %ebp
 45b:	89 e5                	mov    %esp,%ebp
 45d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 467:	eb 42                	jmp    4ab <gets+0x51>
    cc = read(0, &c, 1);
 469:	83 ec 04             	sub    $0x4,%esp
 46c:	6a 01                	push   $0x1
 46e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 471:	50                   	push   %eax
 472:	6a 00                	push   $0x0
 474:	e8 d5 01 00 00       	call   64e <read>
 479:	83 c4 10             	add    $0x10,%esp
 47c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 47f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 483:	7e 33                	jle    4b8 <gets+0x5e>
      break;
    buf[i++] = c;
 485:	8b 45 f4             	mov    -0xc(%ebp),%eax
 488:	8d 50 01             	lea    0x1(%eax),%edx
 48b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48e:	89 c2                	mov    %eax,%edx
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	01 c2                	add    %eax,%edx
 495:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 499:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 49b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49f:	3c 0a                	cmp    $0xa,%al
 4a1:	74 16                	je     4b9 <gets+0x5f>
 4a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a7:	3c 0d                	cmp    $0xd,%al
 4a9:	74 0e                	je     4b9 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ae:	83 c0 01             	add    $0x1,%eax
 4b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4b4:	7c b3                	jl     469 <gets+0xf>
 4b6:	eb 01                	jmp    4b9 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4b8:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	01 d0                	add    %edx,%eax
 4c1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c7:	c9                   	leave  
 4c8:	c3                   	ret    

000004c9 <stat>:

int
stat(char *n, struct stat *st)
{
 4c9:	55                   	push   %ebp
 4ca:	89 e5                	mov    %esp,%ebp
 4cc:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4cf:	83 ec 08             	sub    $0x8,%esp
 4d2:	6a 00                	push   $0x0
 4d4:	ff 75 08             	pushl  0x8(%ebp)
 4d7:	e8 9a 01 00 00       	call   676 <open>
 4dc:	83 c4 10             	add    $0x10,%esp
 4df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e6:	79 07                	jns    4ef <stat+0x26>
    return -1;
 4e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4ed:	eb 25                	jmp    514 <stat+0x4b>
  r = fstat(fd, st);
 4ef:	83 ec 08             	sub    $0x8,%esp
 4f2:	ff 75 0c             	pushl  0xc(%ebp)
 4f5:	ff 75 f4             	pushl  -0xc(%ebp)
 4f8:	e8 91 01 00 00       	call   68e <fstat>
 4fd:	83 c4 10             	add    $0x10,%esp
 500:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 503:	83 ec 0c             	sub    $0xc,%esp
 506:	ff 75 f4             	pushl  -0xc(%ebp)
 509:	e8 50 01 00 00       	call   65e <close>
 50e:	83 c4 10             	add    $0x10,%esp
  return r;
 511:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 514:	c9                   	leave  
 515:	c3                   	ret    

00000516 <atoi>:

int
atoi(const char *s)
{
 516:	55                   	push   %ebp
 517:	89 e5                	mov    %esp,%ebp
 519:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 51c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 523:	eb 25                	jmp    54a <atoi+0x34>
    n = n*10 + *s++ - '0';
 525:	8b 55 fc             	mov    -0x4(%ebp),%edx
 528:	89 d0                	mov    %edx,%eax
 52a:	c1 e0 02             	shl    $0x2,%eax
 52d:	01 d0                	add    %edx,%eax
 52f:	01 c0                	add    %eax,%eax
 531:	89 c1                	mov    %eax,%ecx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	8d 50 01             	lea    0x1(%eax),%edx
 539:	89 55 08             	mov    %edx,0x8(%ebp)
 53c:	0f b6 00             	movzbl (%eax),%eax
 53f:	0f be c0             	movsbl %al,%eax
 542:	01 c8                	add    %ecx,%eax
 544:	83 e8 30             	sub    $0x30,%eax
 547:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 54a:	8b 45 08             	mov    0x8(%ebp),%eax
 54d:	0f b6 00             	movzbl (%eax),%eax
 550:	3c 2f                	cmp    $0x2f,%al
 552:	7e 0a                	jle    55e <atoi+0x48>
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	0f b6 00             	movzbl (%eax),%eax
 55a:	3c 39                	cmp    $0x39,%al
 55c:	7e c7                	jle    525 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 55e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 561:	c9                   	leave  
 562:	c3                   	ret    

00000563 <atoo>:

int
atoo(const char *s)
{
 563:	55                   	push   %ebp
 564:	89 e5                	mov    %esp,%ebp
 566:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
 569:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
 570:	eb 04                	jmp    576 <atoo+0x13>
        s++;
 572:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	0f b6 00             	movzbl (%eax),%eax
 57c:	3c 20                	cmp    $0x20,%al
 57e:	74 f2                	je     572 <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	0f b6 00             	movzbl (%eax),%eax
 586:	3c 2d                	cmp    $0x2d,%al
 588:	75 07                	jne    591 <atoo+0x2e>
 58a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 58f:	eb 05                	jmp    596 <atoo+0x33>
 591:	b8 01 00 00 00       	mov    $0x1,%eax
 596:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	0f b6 00             	movzbl (%eax),%eax
 59f:	3c 2b                	cmp    $0x2b,%al
 5a1:	74 0a                	je     5ad <atoo+0x4a>
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	0f b6 00             	movzbl (%eax),%eax
 5a9:	3c 2d                	cmp    $0x2d,%al
 5ab:	75 27                	jne    5d4 <atoo+0x71>
        s++;
 5ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
 5b1:	eb 21                	jmp    5d4 <atoo+0x71>
        n = n*8 + *s++ - '0';
 5b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	8d 50 01             	lea    0x1(%eax),%edx
 5c3:	89 55 08             	mov    %edx,0x8(%ebp)
 5c6:	0f b6 00             	movzbl (%eax),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	01 c8                	add    %ecx,%eax
 5ce:	83 e8 30             	sub    $0x30,%eax
 5d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	0f b6 00             	movzbl (%eax),%eax
 5da:	3c 2f                	cmp    $0x2f,%al
 5dc:	7e 0a                	jle    5e8 <atoo+0x85>
 5de:	8b 45 08             	mov    0x8(%ebp),%eax
 5e1:	0f b6 00             	movzbl (%eax),%eax
 5e4:	3c 37                	cmp    $0x37,%al
 5e6:	7e cb                	jle    5b3 <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
 5e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5eb:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 5ef:	c9                   	leave  
 5f0:	c3                   	ret    

000005f1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5f1:	55                   	push   %ebp
 5f2:	89 e5                	mov    %esp,%ebp
 5f4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 600:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 603:	eb 17                	jmp    61c <memmove+0x2b>
    *dst++ = *src++;
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8d 50 01             	lea    0x1(%eax),%edx
 60b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 60e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 611:	8d 4a 01             	lea    0x1(%edx),%ecx
 614:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 617:	0f b6 12             	movzbl (%edx),%edx
 61a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 61c:	8b 45 10             	mov    0x10(%ebp),%eax
 61f:	8d 50 ff             	lea    -0x1(%eax),%edx
 622:	89 55 10             	mov    %edx,0x10(%ebp)
 625:	85 c0                	test   %eax,%eax
 627:	7f dc                	jg     605 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 629:	8b 45 08             	mov    0x8(%ebp),%eax
}
 62c:	c9                   	leave  
 62d:	c3                   	ret    

0000062e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 62e:	b8 01 00 00 00       	mov    $0x1,%eax
 633:	cd 40                	int    $0x40
 635:	c3                   	ret    

00000636 <exit>:
SYSCALL(exit)
 636:	b8 02 00 00 00       	mov    $0x2,%eax
 63b:	cd 40                	int    $0x40
 63d:	c3                   	ret    

0000063e <wait>:
SYSCALL(wait)
 63e:	b8 03 00 00 00       	mov    $0x3,%eax
 643:	cd 40                	int    $0x40
 645:	c3                   	ret    

00000646 <pipe>:
SYSCALL(pipe)
 646:	b8 04 00 00 00       	mov    $0x4,%eax
 64b:	cd 40                	int    $0x40
 64d:	c3                   	ret    

0000064e <read>:
SYSCALL(read)
 64e:	b8 05 00 00 00       	mov    $0x5,%eax
 653:	cd 40                	int    $0x40
 655:	c3                   	ret    

00000656 <write>:
SYSCALL(write)
 656:	b8 10 00 00 00       	mov    $0x10,%eax
 65b:	cd 40                	int    $0x40
 65d:	c3                   	ret    

0000065e <close>:
SYSCALL(close)
 65e:	b8 15 00 00 00       	mov    $0x15,%eax
 663:	cd 40                	int    $0x40
 665:	c3                   	ret    

00000666 <kill>:
SYSCALL(kill)
 666:	b8 06 00 00 00       	mov    $0x6,%eax
 66b:	cd 40                	int    $0x40
 66d:	c3                   	ret    

0000066e <exec>:
SYSCALL(exec)
 66e:	b8 07 00 00 00       	mov    $0x7,%eax
 673:	cd 40                	int    $0x40
 675:	c3                   	ret    

00000676 <open>:
SYSCALL(open)
 676:	b8 0f 00 00 00       	mov    $0xf,%eax
 67b:	cd 40                	int    $0x40
 67d:	c3                   	ret    

0000067e <mknod>:
SYSCALL(mknod)
 67e:	b8 11 00 00 00       	mov    $0x11,%eax
 683:	cd 40                	int    $0x40
 685:	c3                   	ret    

00000686 <unlink>:
SYSCALL(unlink)
 686:	b8 12 00 00 00       	mov    $0x12,%eax
 68b:	cd 40                	int    $0x40
 68d:	c3                   	ret    

0000068e <fstat>:
SYSCALL(fstat)
 68e:	b8 08 00 00 00       	mov    $0x8,%eax
 693:	cd 40                	int    $0x40
 695:	c3                   	ret    

00000696 <link>:
SYSCALL(link)
 696:	b8 13 00 00 00       	mov    $0x13,%eax
 69b:	cd 40                	int    $0x40
 69d:	c3                   	ret    

0000069e <mkdir>:
SYSCALL(mkdir)
 69e:	b8 14 00 00 00       	mov    $0x14,%eax
 6a3:	cd 40                	int    $0x40
 6a5:	c3                   	ret    

000006a6 <chdir>:
SYSCALL(chdir)
 6a6:	b8 09 00 00 00       	mov    $0x9,%eax
 6ab:	cd 40                	int    $0x40
 6ad:	c3                   	ret    

000006ae <dup>:
SYSCALL(dup)
 6ae:	b8 0a 00 00 00       	mov    $0xa,%eax
 6b3:	cd 40                	int    $0x40
 6b5:	c3                   	ret    

000006b6 <getpid>:
SYSCALL(getpid)
 6b6:	b8 0b 00 00 00       	mov    $0xb,%eax
 6bb:	cd 40                	int    $0x40
 6bd:	c3                   	ret    

000006be <sbrk>:
SYSCALL(sbrk)
 6be:	b8 0c 00 00 00       	mov    $0xc,%eax
 6c3:	cd 40                	int    $0x40
 6c5:	c3                   	ret    

000006c6 <sleep>:
SYSCALL(sleep)
 6c6:	b8 0d 00 00 00       	mov    $0xd,%eax
 6cb:	cd 40                	int    $0x40
 6cd:	c3                   	ret    

000006ce <uptime>:
SYSCALL(uptime)
 6ce:	b8 0e 00 00 00       	mov    $0xe,%eax
 6d3:	cd 40                	int    $0x40
 6d5:	c3                   	ret    

000006d6 <halt>:
SYSCALL(halt)
 6d6:	b8 16 00 00 00       	mov    $0x16,%eax
 6db:	cd 40                	int    $0x40
 6dd:	c3                   	ret    

000006de <date>:
SYSCALL(date)
 6de:	b8 17 00 00 00       	mov    $0x17,%eax
 6e3:	cd 40                	int    $0x40
 6e5:	c3                   	ret    

000006e6 <getuid>:
SYSCALL(getuid)
 6e6:	b8 18 00 00 00       	mov    $0x18,%eax
 6eb:	cd 40                	int    $0x40
 6ed:	c3                   	ret    

000006ee <getgid>:
SYSCALL(getgid)
 6ee:	b8 19 00 00 00       	mov    $0x19,%eax
 6f3:	cd 40                	int    $0x40
 6f5:	c3                   	ret    

000006f6 <getppid>:
SYSCALL(getppid)
 6f6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6fb:	cd 40                	int    $0x40
 6fd:	c3                   	ret    

000006fe <setuid>:
SYSCALL(setuid)
 6fe:	b8 1b 00 00 00       	mov    $0x1b,%eax
 703:	cd 40                	int    $0x40
 705:	c3                   	ret    

00000706 <setgid>:
SYSCALL(setgid)
 706:	b8 1c 00 00 00       	mov    $0x1c,%eax
 70b:	cd 40                	int    $0x40
 70d:	c3                   	ret    

0000070e <getprocs>:
SYSCALL(getprocs)
 70e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 713:	cd 40                	int    $0x40
 715:	c3                   	ret    

00000716 <setpriority>:
SYSCALL(setpriority)
 716:	b8 1e 00 00 00       	mov    $0x1e,%eax
 71b:	cd 40                	int    $0x40
 71d:	c3                   	ret    

0000071e <chmod>:
SYSCALL(chmod)
 71e:	b8 1f 00 00 00       	mov    $0x1f,%eax
 723:	cd 40                	int    $0x40
 725:	c3                   	ret    

00000726 <chown>:
SYSCALL(chown)
 726:	b8 20 00 00 00       	mov    $0x20,%eax
 72b:	cd 40                	int    $0x40
 72d:	c3                   	ret    

0000072e <chgrp>:
SYSCALL(chgrp)
 72e:	b8 21 00 00 00       	mov    $0x21,%eax
 733:	cd 40                	int    $0x40
 735:	c3                   	ret    

00000736 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 736:	55                   	push   %ebp
 737:	89 e5                	mov    %esp,%ebp
 739:	83 ec 18             	sub    $0x18,%esp
 73c:	8b 45 0c             	mov    0xc(%ebp),%eax
 73f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 742:	83 ec 04             	sub    $0x4,%esp
 745:	6a 01                	push   $0x1
 747:	8d 45 f4             	lea    -0xc(%ebp),%eax
 74a:	50                   	push   %eax
 74b:	ff 75 08             	pushl  0x8(%ebp)
 74e:	e8 03 ff ff ff       	call   656 <write>
 753:	83 c4 10             	add    $0x10,%esp
}
 756:	90                   	nop
 757:	c9                   	leave  
 758:	c3                   	ret    

00000759 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	53                   	push   %ebx
 75d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 760:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 767:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 76b:	74 17                	je     784 <printint+0x2b>
 76d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 771:	79 11                	jns    784 <printint+0x2b>
    neg = 1;
 773:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 77a:	8b 45 0c             	mov    0xc(%ebp),%eax
 77d:	f7 d8                	neg    %eax
 77f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 782:	eb 06                	jmp    78a <printint+0x31>
  } else {
    x = xx;
 784:	8b 45 0c             	mov    0xc(%ebp),%eax
 787:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 78a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 791:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 794:	8d 41 01             	lea    0x1(%ecx),%eax
 797:	89 45 f4             	mov    %eax,-0xc(%ebp)
 79a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 79d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a0:	ba 00 00 00 00       	mov    $0x0,%edx
 7a5:	f7 f3                	div    %ebx
 7a7:	89 d0                	mov    %edx,%eax
 7a9:	0f b6 80 2c 11 00 00 	movzbl 0x112c(%eax),%eax
 7b0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ba:	ba 00 00 00 00       	mov    $0x0,%edx
 7bf:	f7 f3                	div    %ebx
 7c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c8:	75 c7                	jne    791 <printint+0x38>
  if(neg)
 7ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ce:	74 2d                	je     7fd <printint+0xa4>
    buf[i++] = '-';
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8d 50 01             	lea    0x1(%eax),%edx
 7d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7d9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7de:	eb 1d                	jmp    7fd <printint+0xa4>
    putc(fd, buf[i]);
 7e0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	01 d0                	add    %edx,%eax
 7e8:	0f b6 00             	movzbl (%eax),%eax
 7eb:	0f be c0             	movsbl %al,%eax
 7ee:	83 ec 08             	sub    $0x8,%esp
 7f1:	50                   	push   %eax
 7f2:	ff 75 08             	pushl  0x8(%ebp)
 7f5:	e8 3c ff ff ff       	call   736 <putc>
 7fa:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7fd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 805:	79 d9                	jns    7e0 <printint+0x87>
    putc(fd, buf[i]);
}
 807:	90                   	nop
 808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 80b:	c9                   	leave  
 80c:	c3                   	ret    

0000080d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 80d:	55                   	push   %ebp
 80e:	89 e5                	mov    %esp,%ebp
 810:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 813:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 81a:	8d 45 0c             	lea    0xc(%ebp),%eax
 81d:	83 c0 04             	add    $0x4,%eax
 820:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 823:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 82a:	e9 59 01 00 00       	jmp    988 <printf+0x17b>
    c = fmt[i] & 0xff;
 82f:	8b 55 0c             	mov    0xc(%ebp),%edx
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	01 d0                	add    %edx,%eax
 837:	0f b6 00             	movzbl (%eax),%eax
 83a:	0f be c0             	movsbl %al,%eax
 83d:	25 ff 00 00 00       	and    $0xff,%eax
 842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 845:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 849:	75 2c                	jne    877 <printf+0x6a>
      if(c == '%'){
 84b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 84f:	75 0c                	jne    85d <printf+0x50>
        state = '%';
 851:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 858:	e9 27 01 00 00       	jmp    984 <printf+0x177>
      } else {
        putc(fd, c);
 85d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 860:	0f be c0             	movsbl %al,%eax
 863:	83 ec 08             	sub    $0x8,%esp
 866:	50                   	push   %eax
 867:	ff 75 08             	pushl  0x8(%ebp)
 86a:	e8 c7 fe ff ff       	call   736 <putc>
 86f:	83 c4 10             	add    $0x10,%esp
 872:	e9 0d 01 00 00       	jmp    984 <printf+0x177>
      }
    } else if(state == '%'){
 877:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 87b:	0f 85 03 01 00 00    	jne    984 <printf+0x177>
      if(c == 'd'){
 881:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 885:	75 1e                	jne    8a5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 887:	8b 45 e8             	mov    -0x18(%ebp),%eax
 88a:	8b 00                	mov    (%eax),%eax
 88c:	6a 01                	push   $0x1
 88e:	6a 0a                	push   $0xa
 890:	50                   	push   %eax
 891:	ff 75 08             	pushl  0x8(%ebp)
 894:	e8 c0 fe ff ff       	call   759 <printint>
 899:	83 c4 10             	add    $0x10,%esp
        ap++;
 89c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8a0:	e9 d8 00 00 00       	jmp    97d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 8a5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8a9:	74 06                	je     8b1 <printf+0xa4>
 8ab:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8af:	75 1e                	jne    8cf <printf+0xc2>
        printint(fd, *ap, 16, 0);
 8b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b4:	8b 00                	mov    (%eax),%eax
 8b6:	6a 00                	push   $0x0
 8b8:	6a 10                	push   $0x10
 8ba:	50                   	push   %eax
 8bb:	ff 75 08             	pushl  0x8(%ebp)
 8be:	e8 96 fe ff ff       	call   759 <printint>
 8c3:	83 c4 10             	add    $0x10,%esp
        ap++;
 8c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8ca:	e9 ae 00 00 00       	jmp    97d <printf+0x170>
      } else if(c == 's'){
 8cf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8d3:	75 43                	jne    918 <printf+0x10b>
        s = (char*)*ap;
 8d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d8:	8b 00                	mov    (%eax),%eax
 8da:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e5:	75 25                	jne    90c <printf+0xff>
          s = "(null)";
 8e7:	c7 45 f4 17 0e 00 00 	movl   $0xe17,-0xc(%ebp)
        while(*s != 0){
 8ee:	eb 1c                	jmp    90c <printf+0xff>
          putc(fd, *s);
 8f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f3:	0f b6 00             	movzbl (%eax),%eax
 8f6:	0f be c0             	movsbl %al,%eax
 8f9:	83 ec 08             	sub    $0x8,%esp
 8fc:	50                   	push   %eax
 8fd:	ff 75 08             	pushl  0x8(%ebp)
 900:	e8 31 fe ff ff       	call   736 <putc>
 905:	83 c4 10             	add    $0x10,%esp
          s++;
 908:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	0f b6 00             	movzbl (%eax),%eax
 912:	84 c0                	test   %al,%al
 914:	75 da                	jne    8f0 <printf+0xe3>
 916:	eb 65                	jmp    97d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 918:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 91c:	75 1d                	jne    93b <printf+0x12e>
        putc(fd, *ap);
 91e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 921:	8b 00                	mov    (%eax),%eax
 923:	0f be c0             	movsbl %al,%eax
 926:	83 ec 08             	sub    $0x8,%esp
 929:	50                   	push   %eax
 92a:	ff 75 08             	pushl  0x8(%ebp)
 92d:	e8 04 fe ff ff       	call   736 <putc>
 932:	83 c4 10             	add    $0x10,%esp
        ap++;
 935:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 939:	eb 42                	jmp    97d <printf+0x170>
      } else if(c == '%'){
 93b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 93f:	75 17                	jne    958 <printf+0x14b>
        putc(fd, c);
 941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 944:	0f be c0             	movsbl %al,%eax
 947:	83 ec 08             	sub    $0x8,%esp
 94a:	50                   	push   %eax
 94b:	ff 75 08             	pushl  0x8(%ebp)
 94e:	e8 e3 fd ff ff       	call   736 <putc>
 953:	83 c4 10             	add    $0x10,%esp
 956:	eb 25                	jmp    97d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 958:	83 ec 08             	sub    $0x8,%esp
 95b:	6a 25                	push   $0x25
 95d:	ff 75 08             	pushl  0x8(%ebp)
 960:	e8 d1 fd ff ff       	call   736 <putc>
 965:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 96b:	0f be c0             	movsbl %al,%eax
 96e:	83 ec 08             	sub    $0x8,%esp
 971:	50                   	push   %eax
 972:	ff 75 08             	pushl  0x8(%ebp)
 975:	e8 bc fd ff ff       	call   736 <putc>
 97a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 97d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 984:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 988:	8b 55 0c             	mov    0xc(%ebp),%edx
 98b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98e:	01 d0                	add    %edx,%eax
 990:	0f b6 00             	movzbl (%eax),%eax
 993:	84 c0                	test   %al,%al
 995:	0f 85 94 fe ff ff    	jne    82f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 99b:	90                   	nop
 99c:	c9                   	leave  
 99d:	c3                   	ret    

0000099e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 99e:	55                   	push   %ebp
 99f:	89 e5                	mov    %esp,%ebp
 9a1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9a4:	8b 45 08             	mov    0x8(%ebp),%eax
 9a7:	83 e8 08             	sub    $0x8,%eax
 9aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ad:	a1 48 11 00 00       	mov    0x1148,%eax
 9b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9b5:	eb 24                	jmp    9db <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ba:	8b 00                	mov    (%eax),%eax
 9bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9bf:	77 12                	ja     9d3 <free+0x35>
 9c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9c7:	77 24                	ja     9ed <free+0x4f>
 9c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cc:	8b 00                	mov    (%eax),%eax
 9ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9d1:	77 1a                	ja     9ed <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d6:	8b 00                	mov    (%eax),%eax
 9d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9e1:	76 d4                	jbe    9b7 <free+0x19>
 9e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e6:	8b 00                	mov    (%eax),%eax
 9e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9eb:	76 ca                	jbe    9b7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f0:	8b 40 04             	mov    0x4(%eax),%eax
 9f3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9fd:	01 c2                	add    %eax,%edx
 9ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a02:	8b 00                	mov    (%eax),%eax
 a04:	39 c2                	cmp    %eax,%edx
 a06:	75 24                	jne    a2c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a08:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0b:	8b 50 04             	mov    0x4(%eax),%edx
 a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a11:	8b 00                	mov    (%eax),%eax
 a13:	8b 40 04             	mov    0x4(%eax),%eax
 a16:	01 c2                	add    %eax,%edx
 a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a21:	8b 00                	mov    (%eax),%eax
 a23:	8b 10                	mov    (%eax),%edx
 a25:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a28:	89 10                	mov    %edx,(%eax)
 a2a:	eb 0a                	jmp    a36 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2f:	8b 10                	mov    (%eax),%edx
 a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a34:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a39:	8b 40 04             	mov    0x4(%eax),%eax
 a3c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a43:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a46:	01 d0                	add    %edx,%eax
 a48:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a4b:	75 20                	jne    a6d <free+0xcf>
    p->s.size += bp->s.size;
 a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a50:	8b 50 04             	mov    0x4(%eax),%edx
 a53:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a56:	8b 40 04             	mov    0x4(%eax),%eax
 a59:	01 c2                	add    %eax,%edx
 a5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a61:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a64:	8b 10                	mov    (%eax),%edx
 a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a69:	89 10                	mov    %edx,(%eax)
 a6b:	eb 08                	jmp    a75 <free+0xd7>
  } else
    p->s.ptr = bp;
 a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a70:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a73:	89 10                	mov    %edx,(%eax)
  freep = p;
 a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a78:	a3 48 11 00 00       	mov    %eax,0x1148
}
 a7d:	90                   	nop
 a7e:	c9                   	leave  
 a7f:	c3                   	ret    

00000a80 <morecore>:

static Header*
morecore(uint nu)
{
 a80:	55                   	push   %ebp
 a81:	89 e5                	mov    %esp,%ebp
 a83:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a86:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a8d:	77 07                	ja     a96 <morecore+0x16>
    nu = 4096;
 a8f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a96:	8b 45 08             	mov    0x8(%ebp),%eax
 a99:	c1 e0 03             	shl    $0x3,%eax
 a9c:	83 ec 0c             	sub    $0xc,%esp
 a9f:	50                   	push   %eax
 aa0:	e8 19 fc ff ff       	call   6be <sbrk>
 aa5:	83 c4 10             	add    $0x10,%esp
 aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 aab:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 aaf:	75 07                	jne    ab8 <morecore+0x38>
    return 0;
 ab1:	b8 00 00 00 00       	mov    $0x0,%eax
 ab6:	eb 26                	jmp    ade <morecore+0x5e>
  hp = (Header*)p;
 ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac1:	8b 55 08             	mov    0x8(%ebp),%edx
 ac4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aca:	83 c0 08             	add    $0x8,%eax
 acd:	83 ec 0c             	sub    $0xc,%esp
 ad0:	50                   	push   %eax
 ad1:	e8 c8 fe ff ff       	call   99e <free>
 ad6:	83 c4 10             	add    $0x10,%esp
  return freep;
 ad9:	a1 48 11 00 00       	mov    0x1148,%eax
}
 ade:	c9                   	leave  
 adf:	c3                   	ret    

00000ae0 <malloc>:

void*
malloc(uint nbytes)
{
 ae0:	55                   	push   %ebp
 ae1:	89 e5                	mov    %esp,%ebp
 ae3:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ae6:	8b 45 08             	mov    0x8(%ebp),%eax
 ae9:	83 c0 07             	add    $0x7,%eax
 aec:	c1 e8 03             	shr    $0x3,%eax
 aef:	83 c0 01             	add    $0x1,%eax
 af2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 af5:	a1 48 11 00 00       	mov    0x1148,%eax
 afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 afd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b01:	75 23                	jne    b26 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b03:	c7 45 f0 40 11 00 00 	movl   $0x1140,-0x10(%ebp)
 b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0d:	a3 48 11 00 00       	mov    %eax,0x1148
 b12:	a1 48 11 00 00       	mov    0x1148,%eax
 b17:	a3 40 11 00 00       	mov    %eax,0x1140
    base.s.size = 0;
 b1c:	c7 05 44 11 00 00 00 	movl   $0x0,0x1144
 b23:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b29:	8b 00                	mov    (%eax),%eax
 b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b31:	8b 40 04             	mov    0x4(%eax),%eax
 b34:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b37:	72 4d                	jb     b86 <malloc+0xa6>
      if(p->s.size == nunits)
 b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3c:	8b 40 04             	mov    0x4(%eax),%eax
 b3f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b42:	75 0c                	jne    b50 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b47:	8b 10                	mov    (%eax),%edx
 b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4c:	89 10                	mov    %edx,(%eax)
 b4e:	eb 26                	jmp    b76 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b53:	8b 40 04             	mov    0x4(%eax),%eax
 b56:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b59:	89 c2                	mov    %eax,%edx
 b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b64:	8b 40 04             	mov    0x4(%eax),%eax
 b67:	c1 e0 03             	shl    $0x3,%eax
 b6a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b70:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b73:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b79:	a3 48 11 00 00       	mov    %eax,0x1148
      return (void*)(p + 1);
 b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b81:	83 c0 08             	add    $0x8,%eax
 b84:	eb 3b                	jmp    bc1 <malloc+0xe1>
    }
    if(p == freep)
 b86:	a1 48 11 00 00       	mov    0x1148,%eax
 b8b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b8e:	75 1e                	jne    bae <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b90:	83 ec 0c             	sub    $0xc,%esp
 b93:	ff 75 ec             	pushl  -0x14(%ebp)
 b96:	e8 e5 fe ff ff       	call   a80 <morecore>
 b9b:	83 c4 10             	add    $0x10,%esp
 b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ba5:	75 07                	jne    bae <malloc+0xce>
        return 0;
 ba7:	b8 00 00 00 00       	mov    $0x0,%eax
 bac:	eb 13                	jmp    bc1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb7:	8b 00                	mov    (%eax),%eax
 bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bbc:	e9 6d ff ff ff       	jmp    b2e <malloc+0x4e>
}
 bc1:	c9                   	leave  
 bc2:	c3                   	ret    
