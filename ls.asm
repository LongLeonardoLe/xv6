
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <print_mode>:
#ifdef CS333_P5
// this is an ugly series of if statements but it works
void
print_mode(struct stat* st)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	0f b7 00             	movzwl (%eax),%eax
   c:	98                   	cwtl   
   d:	83 f8 02             	cmp    $0x2,%eax
  10:	74 1e                	je     30 <print_mode+0x30>
  12:	83 f8 03             	cmp    $0x3,%eax
  15:	74 2d                	je     44 <print_mode+0x44>
  17:	83 f8 01             	cmp    $0x1,%eax
  1a:	75 3c                	jne    58 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  1c:	83 ec 08             	sub    $0x8,%esp
  1f:	68 af 0e 00 00       	push   $0xeaf
  24:	6a 01                	push   $0x1
  26:	e8 ce 0a 00 00       	call   af9 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	eb 3a                	jmp    6a <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 b1 0e 00 00       	push   $0xeb1
  38:	6a 01                	push   $0x1
  3a:	e8 ba 0a 00 00       	call   af9 <printf>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	eb 26                	jmp    6a <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 b3 0e 00 00       	push   $0xeb3
  4c:	6a 01                	push   $0x1
  4e:	e8 a6 0a 00 00       	call   af9 <printf>
  53:	83 c4 10             	add    $0x10,%esp
  56:	eb 12                	jmp    6a <print_mode+0x6a>
    default: printf(1, "?");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 b5 0e 00 00       	push   $0xeb5
  60:	6a 01                	push   $0x1
  62:	e8 92 0a 00 00       	call   af9 <printf>
  67:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  6a:	8b 45 08             	mov    0x8(%ebp),%eax
  6d:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  71:	83 e0 01             	and    $0x1,%eax
  74:	84 c0                	test   %al,%al
  76:	74 14                	je     8c <print_mode+0x8c>
    printf(1, "r");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 b7 0e 00 00       	push   $0xeb7
  80:	6a 01                	push   $0x1
  82:	e8 72 0a 00 00       	call   af9 <printf>
  87:	83 c4 10             	add    $0x10,%esp
  8a:	eb 12                	jmp    9e <print_mode+0x9e>
  else
    printf(1, "-");
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	68 b1 0e 00 00       	push   $0xeb1
  94:	6a 01                	push   $0x1
  96:	e8 5e 0a 00 00       	call   af9 <printf>
  9b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  a5:	83 e0 80             	and    $0xffffff80,%eax
  a8:	84 c0                	test   %al,%al
  aa:	74 14                	je     c0 <print_mode+0xc0>
    printf(1, "w");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 b9 0e 00 00       	push   $0xeb9
  b4:	6a 01                	push   $0x1
  b6:	e8 3e 0a 00 00       	call   af9 <printf>
  bb:	83 c4 10             	add    $0x10,%esp
  be:	eb 12                	jmp    d2 <print_mode+0xd2>
  else
    printf(1, "-");
  c0:	83 ec 08             	sub    $0x8,%esp
  c3:	68 b1 0e 00 00       	push   $0xeb1
  c8:	6a 01                	push   $0x1
  ca:	e8 2a 0a 00 00       	call   af9 <printf>
  cf:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  d9:	c0 e8 06             	shr    $0x6,%al
  dc:	83 e0 01             	and    $0x1,%eax
  df:	0f b6 d0             	movzbl %al,%edx
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  e9:	d0 e8                	shr    %al
  eb:	83 e0 01             	and    $0x1,%eax
  ee:	0f b6 c0             	movzbl %al,%eax
  f1:	21 d0                	and    %edx,%eax
  f3:	85 c0                	test   %eax,%eax
  f5:	74 14                	je     10b <print_mode+0x10b>
    printf(1, "S");
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	68 bb 0e 00 00       	push   $0xebb
  ff:	6a 01                	push   $0x1
 101:	e8 f3 09 00 00       	call   af9 <printf>
 106:	83 c4 10             	add    $0x10,%esp
 109:	eb 34                	jmp    13f <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 112:	83 e0 40             	and    $0x40,%eax
 115:	84 c0                	test   %al,%al
 117:	74 14                	je     12d <print_mode+0x12d>
    printf(1, "x");
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	68 bd 0e 00 00       	push   $0xebd
 121:	6a 01                	push   $0x1
 123:	e8 d1 09 00 00       	call   af9 <printf>
 128:	83 c4 10             	add    $0x10,%esp
 12b:	eb 12                	jmp    13f <print_mode+0x13f>
  else
    printf(1, "-");
 12d:	83 ec 08             	sub    $0x8,%esp
 130:	68 b1 0e 00 00       	push   $0xeb1
 135:	6a 01                	push   $0x1
 137:	e8 bd 09 00 00       	call   af9 <printf>
 13c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 146:	83 e0 20             	and    $0x20,%eax
 149:	84 c0                	test   %al,%al
 14b:	74 14                	je     161 <print_mode+0x161>
    printf(1, "r");
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	68 b7 0e 00 00       	push   $0xeb7
 155:	6a 01                	push   $0x1
 157:	e8 9d 09 00 00       	call   af9 <printf>
 15c:	83 c4 10             	add    $0x10,%esp
 15f:	eb 12                	jmp    173 <print_mode+0x173>
  else
    printf(1, "-");
 161:	83 ec 08             	sub    $0x8,%esp
 164:	68 b1 0e 00 00       	push   $0xeb1
 169:	6a 01                	push   $0x1
 16b:	e8 89 09 00 00       	call   af9 <printf>
 170:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 17a:	83 e0 10             	and    $0x10,%eax
 17d:	84 c0                	test   %al,%al
 17f:	74 14                	je     195 <print_mode+0x195>
    printf(1, "w");
 181:	83 ec 08             	sub    $0x8,%esp
 184:	68 b9 0e 00 00       	push   $0xeb9
 189:	6a 01                	push   $0x1
 18b:	e8 69 09 00 00       	call   af9 <printf>
 190:	83 c4 10             	add    $0x10,%esp
 193:	eb 12                	jmp    1a7 <print_mode+0x1a7>
  else
    printf(1, "-");
 195:	83 ec 08             	sub    $0x8,%esp
 198:	68 b1 0e 00 00       	push   $0xeb1
 19d:	6a 01                	push   $0x1
 19f:	e8 55 09 00 00       	call   af9 <printf>
 1a4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1ae:	83 e0 08             	and    $0x8,%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	74 14                	je     1c9 <print_mode+0x1c9>
    printf(1, "x");
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	68 bd 0e 00 00       	push   $0xebd
 1bd:	6a 01                	push   $0x1
 1bf:	e8 35 09 00 00       	call   af9 <printf>
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	eb 12                	jmp    1db <print_mode+0x1db>
  else
    printf(1, "-");
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	68 b1 0e 00 00       	push   $0xeb1
 1d1:	6a 01                	push   $0x1
 1d3:	e8 21 09 00 00       	call   af9 <printf>
 1d8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1e2:	83 e0 04             	and    $0x4,%eax
 1e5:	84 c0                	test   %al,%al
 1e7:	74 14                	je     1fd <print_mode+0x1fd>
    printf(1, "r");
 1e9:	83 ec 08             	sub    $0x8,%esp
 1ec:	68 b7 0e 00 00       	push   $0xeb7
 1f1:	6a 01                	push   $0x1
 1f3:	e8 01 09 00 00       	call   af9 <printf>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	eb 12                	jmp    20f <print_mode+0x20f>
  else
    printf(1, "-");
 1fd:	83 ec 08             	sub    $0x8,%esp
 200:	68 b1 0e 00 00       	push   $0xeb1
 205:	6a 01                	push   $0x1
 207:	e8 ed 08 00 00       	call   af9 <printf>
 20c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 216:	83 e0 02             	and    $0x2,%eax
 219:	84 c0                	test   %al,%al
 21b:	74 14                	je     231 <print_mode+0x231>
    printf(1, "w");
 21d:	83 ec 08             	sub    $0x8,%esp
 220:	68 b9 0e 00 00       	push   $0xeb9
 225:	6a 01                	push   $0x1
 227:	e8 cd 08 00 00       	call   af9 <printf>
 22c:	83 c4 10             	add    $0x10,%esp
 22f:	eb 12                	jmp    243 <print_mode+0x243>
  else
    printf(1, "-");
 231:	83 ec 08             	sub    $0x8,%esp
 234:	68 b1 0e 00 00       	push   $0xeb1
 239:	6a 01                	push   $0x1
 23b:	e8 b9 08 00 00       	call   af9 <printf>
 240:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 24a:	83 e0 01             	and    $0x1,%eax
 24d:	84 c0                	test   %al,%al
 24f:	74 14                	je     265 <print_mode+0x265>
    printf(1, "x");
 251:	83 ec 08             	sub    $0x8,%esp
 254:	68 bd 0e 00 00       	push   $0xebd
 259:	6a 01                	push   $0x1
 25b:	e8 99 08 00 00       	call   af9 <printf>
 260:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 263:	eb 13                	jmp    278 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 265:	83 ec 08             	sub    $0x8,%esp
 268:	68 b1 0e 00 00       	push   $0xeb1
 26d:	6a 01                	push   $0x1
 26f:	e8 85 08 00 00       	call   af9 <printf>
 274:	83 c4 10             	add    $0x10,%esp

  return;
 277:	90                   	nop
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <fmtname>:
#include "print_mode.c"
#endif

char*
fmtname(char *path)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	53                   	push   %ebx
 27e:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 281:	83 ec 0c             	sub    $0xc,%esp
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 46 04 00 00       	call   6d2 <strlen>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 d0                	add    %edx,%eax
 296:	89 45 f4             	mov    %eax,-0xc(%ebp)
 299:	eb 04                	jmp    29f <fmtname+0x25>
 29b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 29f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a2:	3b 45 08             	cmp    0x8(%ebp),%eax
 2a5:	72 0a                	jb     2b1 <fmtname+0x37>
 2a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3c 2f                	cmp    $0x2f,%al
 2af:	75 ea                	jne    29b <fmtname+0x21>
    ;
  p++;
 2b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
 2b5:	83 ec 0c             	sub    $0xc,%esp
 2b8:	ff 75 f4             	pushl  -0xc(%ebp)
 2bb:	e8 12 04 00 00       	call   6d2 <strlen>
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	83 f8 0d             	cmp    $0xd,%eax
 2c6:	76 05                	jbe    2cd <fmtname+0x53>
    return p;
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	eb 60                	jmp    32d <fmtname+0xb3>
  memmove(buf, p, strlen(p));
 2cd:	83 ec 0c             	sub    $0xc,%esp
 2d0:	ff 75 f4             	pushl  -0xc(%ebp)
 2d3:	e8 fa 03 00 00       	call   6d2 <strlen>
 2d8:	83 c4 10             	add    $0x10,%esp
 2db:	83 ec 04             	sub    $0x4,%esp
 2de:	50                   	push   %eax
 2df:	ff 75 f4             	pushl  -0xc(%ebp)
 2e2:	68 3c 12 00 00       	push   $0x123c
 2e7:	e8 f1 05 00 00       	call   8dd <memmove>
 2ec:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 2ef:	83 ec 0c             	sub    $0xc,%esp
 2f2:	ff 75 f4             	pushl  -0xc(%ebp)
 2f5:	e8 d8 03 00 00       	call   6d2 <strlen>
 2fa:	83 c4 10             	add    $0x10,%esp
 2fd:	ba 0e 00 00 00       	mov    $0xe,%edx
 302:	89 d3                	mov    %edx,%ebx
 304:	29 c3                	sub    %eax,%ebx
 306:	83 ec 0c             	sub    $0xc,%esp
 309:	ff 75 f4             	pushl  -0xc(%ebp)
 30c:	e8 c1 03 00 00       	call   6d2 <strlen>
 311:	83 c4 10             	add    $0x10,%esp
 314:	05 3c 12 00 00       	add    $0x123c,%eax
 319:	83 ec 04             	sub    $0x4,%esp
 31c:	53                   	push   %ebx
 31d:	6a 20                	push   $0x20
 31f:	50                   	push   %eax
 320:	e8 d4 03 00 00       	call   6f9 <memset>
 325:	83 c4 10             	add    $0x10,%esp
  return buf;
 328:	b8 3c 12 00 00       	mov    $0x123c,%eax
}
 32d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <ls>:

void
ls(char *path)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	57                   	push   %edi
 336:	56                   	push   %esi
 337:	53                   	push   %ebx
 338:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
 33e:	83 ec 08             	sub    $0x8,%esp
 341:	6a 00                	push   $0x0
 343:	ff 75 08             	pushl  0x8(%ebp)
 346:	e8 17 06 00 00       	call   962 <open>
 34b:	83 c4 10             	add    $0x10,%esp
 34e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 351:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 355:	79 1a                	jns    371 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
 357:	83 ec 04             	sub    $0x4,%esp
 35a:	ff 75 08             	pushl  0x8(%ebp)
 35d:	68 bf 0e 00 00       	push   $0xebf
 362:	6a 02                	push   $0x2
 364:	e8 90 07 00 00       	call   af9 <printf>
 369:	83 c4 10             	add    $0x10,%esp
    return;
 36c:	e9 33 02 00 00       	jmp    5a4 <ls+0x272>
  }
  
  if(fstat(fd, &st) < 0){
 371:	83 ec 08             	sub    $0x8,%esp
 374:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 37a:	50                   	push   %eax
 37b:	ff 75 e4             	pushl  -0x1c(%ebp)
 37e:	e8 f7 05 00 00       	call   97a <fstat>
 383:	83 c4 10             	add    $0x10,%esp
 386:	85 c0                	test   %eax,%eax
 388:	79 28                	jns    3b2 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 38a:	83 ec 04             	sub    $0x4,%esp
 38d:	ff 75 08             	pushl  0x8(%ebp)
 390:	68 d3 0e 00 00       	push   $0xed3
 395:	6a 02                	push   $0x2
 397:	e8 5d 07 00 00       	call   af9 <printf>
 39c:	83 c4 10             	add    $0x10,%esp
    close(fd);
 39f:	83 ec 0c             	sub    $0xc,%esp
 3a2:	ff 75 e4             	pushl  -0x1c(%ebp)
 3a5:	e8 a0 05 00 00       	call   94a <close>
 3aa:	83 c4 10             	add    $0x10,%esp
    return;
 3ad:	e9 f2 01 00 00       	jmp    5a4 <ls+0x272>
  }
#ifdef CS333_P5
  switch(st.type){
 3b2:	0f b7 85 b4 fd ff ff 	movzwl -0x24c(%ebp),%eax
 3b9:	98                   	cwtl   
 3ba:	83 f8 01             	cmp    $0x1,%eax
 3bd:	74 70                	je     42f <ls+0xfd>
 3bf:	83 f8 02             	cmp    $0x2,%eax
 3c2:	0f 85 ce 01 00 00    	jne    596 <ls+0x264>
  case T_FILE:
    print_mode(&st);
 3c8:	83 ec 0c             	sub    $0xc,%esp
 3cb:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 3d1:	50                   	push   %eax
 3d2:	e8 29 fc ff ff       	call   0 <print_mode>
 3d7:	83 c4 10             	add    $0x10,%esp
    printf(1, "\t%s\t%d\t%d\t%d\t%d\n", fmtname(path), st.uid, st.gid, st.ino, st.size);
 3da:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
 3e0:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 3e6:	8b bd bc fd ff ff    	mov    -0x244(%ebp),%edi
 3ec:	0f b7 85 ca fd ff ff 	movzwl -0x236(%ebp),%eax
 3f3:	0f b7 f0             	movzwl %ax,%esi
 3f6:	0f b7 85 c8 fd ff ff 	movzwl -0x238(%ebp),%eax
 3fd:	0f b7 d8             	movzwl %ax,%ebx
 400:	83 ec 0c             	sub    $0xc,%esp
 403:	ff 75 08             	pushl  0x8(%ebp)
 406:	e8 6f fe ff ff       	call   27a <fmtname>
 40b:	83 c4 10             	add    $0x10,%esp
 40e:	83 ec 04             	sub    $0x4,%esp
 411:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 417:	57                   	push   %edi
 418:	56                   	push   %esi
 419:	53                   	push   %ebx
 41a:	50                   	push   %eax
 41b:	68 e7 0e 00 00       	push   $0xee7
 420:	6a 01                	push   $0x1
 422:	e8 d2 06 00 00       	call   af9 <printf>
 427:	83 c4 20             	add    $0x20,%esp
    break;
 42a:	e9 67 01 00 00       	jmp    596 <ls+0x264>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 42f:	83 ec 0c             	sub    $0xc,%esp
 432:	ff 75 08             	pushl  0x8(%ebp)
 435:	e8 98 02 00 00       	call   6d2 <strlen>
 43a:	83 c4 10             	add    $0x10,%esp
 43d:	83 c0 10             	add    $0x10,%eax
 440:	3d 00 02 00 00       	cmp    $0x200,%eax
 445:	76 17                	jbe    45e <ls+0x12c>
      printf(1, "ls: path too long\n");
 447:	83 ec 08             	sub    $0x8,%esp
 44a:	68 f8 0e 00 00       	push   $0xef8
 44f:	6a 01                	push   $0x1
 451:	e8 a3 06 00 00       	call   af9 <printf>
 456:	83 c4 10             	add    $0x10,%esp
      break;
 459:	e9 38 01 00 00       	jmp    596 <ls+0x264>
    }
    strcpy(buf, path);
 45e:	83 ec 08             	sub    $0x8,%esp
 461:	ff 75 08             	pushl  0x8(%ebp)
 464:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 46a:	50                   	push   %eax
 46b:	e8 f3 01 00 00       	call   663 <strcpy>
 470:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 473:	83 ec 0c             	sub    $0xc,%esp
 476:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 47c:	50                   	push   %eax
 47d:	e8 50 02 00 00       	call   6d2 <strlen>
 482:	83 c4 10             	add    $0x10,%esp
 485:	89 c2                	mov    %eax,%edx
 487:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 48d:	01 d0                	add    %edx,%eax
 48f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 492:	8b 45 e0             	mov    -0x20(%ebp),%eax
 495:	8d 50 01             	lea    0x1(%eax),%edx
 498:	89 55 e0             	mov    %edx,-0x20(%ebp)
 49b:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 49e:	e9 d2 00 00 00       	jmp    575 <ls+0x243>
      if(de.inum == 0)
 4a3:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 4aa:	66 85 c0             	test   %ax,%ax
 4ad:	75 05                	jne    4b4 <ls+0x182>
        continue;
 4af:	e9 c1 00 00 00       	jmp    575 <ls+0x243>
      memmove(p, de.name, DIRSIZ);
 4b4:	83 ec 04             	sub    $0x4,%esp
 4b7:	6a 0e                	push   $0xe
 4b9:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 4bf:	83 c0 02             	add    $0x2,%eax
 4c2:	50                   	push   %eax
 4c3:	ff 75 e0             	pushl  -0x20(%ebp)
 4c6:	e8 12 04 00 00       	call   8dd <memmove>
 4cb:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 4ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4d1:	83 c0 0e             	add    $0xe,%eax
 4d4:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 4d7:	83 ec 08             	sub    $0x8,%esp
 4da:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 4e0:	50                   	push   %eax
 4e1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 4e7:	50                   	push   %eax
 4e8:	e8 c8 02 00 00       	call   7b5 <stat>
 4ed:	83 c4 10             	add    $0x10,%esp
 4f0:	85 c0                	test   %eax,%eax
 4f2:	79 1b                	jns    50f <ls+0x1dd>
        printf(1, "ls: cannot stat %s\n", buf);
 4f4:	83 ec 04             	sub    $0x4,%esp
 4f7:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 4fd:	50                   	push   %eax
 4fe:	68 d3 0e 00 00       	push   $0xed3
 503:	6a 01                	push   $0x1
 505:	e8 ef 05 00 00       	call   af9 <printf>
 50a:	83 c4 10             	add    $0x10,%esp
        continue;
 50d:	eb 66                	jmp    575 <ls+0x243>
      }
      print_mode(&st);
 50f:	83 ec 0c             	sub    $0xc,%esp
 512:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 518:	50                   	push   %eax
 519:	e8 e2 fa ff ff       	call   0 <print_mode>
 51e:	83 c4 10             	add    $0x10,%esp
      printf(1, "\t%s\t%d\t%d\t%d\t%d\n", fmtname(buf), st.uid, st.gid, st.ino, st.size);
 521:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
 527:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 52d:	8b bd bc fd ff ff    	mov    -0x244(%ebp),%edi
 533:	0f b7 85 ca fd ff ff 	movzwl -0x236(%ebp),%eax
 53a:	0f b7 f0             	movzwl %ax,%esi
 53d:	0f b7 85 c8 fd ff ff 	movzwl -0x238(%ebp),%eax
 544:	0f b7 d8             	movzwl %ax,%ebx
 547:	83 ec 0c             	sub    $0xc,%esp
 54a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 550:	50                   	push   %eax
 551:	e8 24 fd ff ff       	call   27a <fmtname>
 556:	83 c4 10             	add    $0x10,%esp
 559:	83 ec 04             	sub    $0x4,%esp
 55c:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 562:	57                   	push   %edi
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
 565:	50                   	push   %eax
 566:	68 e7 0e 00 00       	push   $0xee7
 56b:	6a 01                	push   $0x1
 56d:	e8 87 05 00 00       	call   af9 <printf>
 572:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 575:	83 ec 04             	sub    $0x4,%esp
 578:	6a 10                	push   $0x10
 57a:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 580:	50                   	push   %eax
 581:	ff 75 e4             	pushl  -0x1c(%ebp)
 584:	e8 b1 03 00 00       	call   93a <read>
 589:	83 c4 10             	add    $0x10,%esp
 58c:	83 f8 10             	cmp    $0x10,%eax
 58f:	0f 84 0e ff ff ff    	je     4a3 <ls+0x171>
        continue;
      }
      print_mode(&st);
      printf(1, "\t%s\t%d\t%d\t%d\t%d\n", fmtname(buf), st.uid, st.gid, st.ino, st.size);
    }
    break;
 595:	90                   	nop
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
#endif
  close(fd);
 596:	83 ec 0c             	sub    $0xc,%esp
 599:	ff 75 e4             	pushl  -0x1c(%ebp)
 59c:	e8 a9 03 00 00       	call   94a <close>
 5a1:	83 c4 10             	add    $0x10,%esp
}
 5a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a7:	5b                   	pop    %ebx
 5a8:	5e                   	pop    %esi
 5a9:	5f                   	pop    %edi
 5aa:	5d                   	pop    %ebp
 5ab:	c3                   	ret    

000005ac <main>:

int
main(int argc, char *argv[])
{
 5ac:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 5b0:	83 e4 f0             	and    $0xfffffff0,%esp
 5b3:	ff 71 fc             	pushl  -0x4(%ecx)
 5b6:	55                   	push   %ebp
 5b7:	89 e5                	mov    %esp,%ebp
 5b9:	53                   	push   %ebx
 5ba:	51                   	push   %ecx
 5bb:	83 ec 10             	sub    $0x10,%esp
 5be:	89 cb                	mov    %ecx,%ebx
  int i;

#ifdef CS333_P5
  printf(1, "%s\t\t%s\t\t%s\t%s\t%s\t%s\n", "mode", "name", "uid", "gid", "inode", "size");
 5c0:	68 0b 0f 00 00       	push   $0xf0b
 5c5:	68 10 0f 00 00       	push   $0xf10
 5ca:	68 16 0f 00 00       	push   $0xf16
 5cf:	68 1a 0f 00 00       	push   $0xf1a
 5d4:	68 1e 0f 00 00       	push   $0xf1e
 5d9:	68 23 0f 00 00       	push   $0xf23
 5de:	68 28 0f 00 00       	push   $0xf28
 5e3:	6a 01                	push   $0x1
 5e5:	e8 0f 05 00 00       	call   af9 <printf>
 5ea:	83 c4 20             	add    $0x20,%esp
#endif
  if(argc < 2){
 5ed:	83 3b 01             	cmpl   $0x1,(%ebx)
 5f0:	7f 15                	jg     607 <main+0x5b>
    ls(".");
 5f2:	83 ec 0c             	sub    $0xc,%esp
 5f5:	68 3d 0f 00 00       	push   $0xf3d
 5fa:	e8 33 fd ff ff       	call   332 <ls>
 5ff:	83 c4 10             	add    $0x10,%esp
    exit();
 602:	e8 1b 03 00 00       	call   922 <exit>
  }
  for(i=1; i<argc; i++)
 607:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 60e:	eb 21                	jmp    631 <main+0x85>
    ls(argv[i]);
 610:	8b 45 f4             	mov    -0xc(%ebp),%eax
 613:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 61a:	8b 43 04             	mov    0x4(%ebx),%eax
 61d:	01 d0                	add    %edx,%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	83 ec 0c             	sub    $0xc,%esp
 624:	50                   	push   %eax
 625:	e8 08 fd ff ff       	call   332 <ls>
 62a:	83 c4 10             	add    $0x10,%esp
#endif
  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 62d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 631:	8b 45 f4             	mov    -0xc(%ebp),%eax
 634:	3b 03                	cmp    (%ebx),%eax
 636:	7c d8                	jl     610 <main+0x64>
    ls(argv[i]);
  exit();
 638:	e8 e5 02 00 00       	call   922 <exit>

0000063d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	57                   	push   %edi
 641:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 642:	8b 4d 08             	mov    0x8(%ebp),%ecx
 645:	8b 55 10             	mov    0x10(%ebp),%edx
 648:	8b 45 0c             	mov    0xc(%ebp),%eax
 64b:	89 cb                	mov    %ecx,%ebx
 64d:	89 df                	mov    %ebx,%edi
 64f:	89 d1                	mov    %edx,%ecx
 651:	fc                   	cld    
 652:	f3 aa                	rep stos %al,%es:(%edi)
 654:	89 ca                	mov    %ecx,%edx
 656:	89 fb                	mov    %edi,%ebx
 658:	89 5d 08             	mov    %ebx,0x8(%ebp)
 65b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 65e:	90                   	nop
 65f:	5b                   	pop    %ebx
 660:	5f                   	pop    %edi
 661:	5d                   	pop    %ebp
 662:	c3                   	ret    

00000663 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 663:	55                   	push   %ebp
 664:	89 e5                	mov    %esp,%ebp
 666:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 669:	8b 45 08             	mov    0x8(%ebp),%eax
 66c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 66f:	90                   	nop
 670:	8b 45 08             	mov    0x8(%ebp),%eax
 673:	8d 50 01             	lea    0x1(%eax),%edx
 676:	89 55 08             	mov    %edx,0x8(%ebp)
 679:	8b 55 0c             	mov    0xc(%ebp),%edx
 67c:	8d 4a 01             	lea    0x1(%edx),%ecx
 67f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 682:	0f b6 12             	movzbl (%edx),%edx
 685:	88 10                	mov    %dl,(%eax)
 687:	0f b6 00             	movzbl (%eax),%eax
 68a:	84 c0                	test   %al,%al
 68c:	75 e2                	jne    670 <strcpy+0xd>
    ;
  return os;
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 691:	c9                   	leave  
 692:	c3                   	ret    

00000693 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 693:	55                   	push   %ebp
 694:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 696:	eb 08                	jmp    6a0 <strcmp+0xd>
    p++, q++;
 698:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 69c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 6a0:	8b 45 08             	mov    0x8(%ebp),%eax
 6a3:	0f b6 00             	movzbl (%eax),%eax
 6a6:	84 c0                	test   %al,%al
 6a8:	74 10                	je     6ba <strcmp+0x27>
 6aa:	8b 45 08             	mov    0x8(%ebp),%eax
 6ad:	0f b6 10             	movzbl (%eax),%edx
 6b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b3:	0f b6 00             	movzbl (%eax),%eax
 6b6:	38 c2                	cmp    %al,%dl
 6b8:	74 de                	je     698 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	0f b6 00             	movzbl (%eax),%eax
 6c0:	0f b6 d0             	movzbl %al,%edx
 6c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c6:	0f b6 00             	movzbl (%eax),%eax
 6c9:	0f b6 c0             	movzbl %al,%eax
 6cc:	29 c2                	sub    %eax,%edx
 6ce:	89 d0                	mov    %edx,%eax
}
 6d0:	5d                   	pop    %ebp
 6d1:	c3                   	ret    

000006d2 <strlen>:

uint
strlen(char *s)
{
 6d2:	55                   	push   %ebp
 6d3:	89 e5                	mov    %esp,%ebp
 6d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6df:	eb 04                	jmp    6e5 <strlen+0x13>
 6e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	01 d0                	add    %edx,%eax
 6ed:	0f b6 00             	movzbl (%eax),%eax
 6f0:	84 c0                	test   %al,%al
 6f2:	75 ed                	jne    6e1 <strlen+0xf>
    ;
  return n;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 6f9:	55                   	push   %ebp
 6fa:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 6fc:	8b 45 10             	mov    0x10(%ebp),%eax
 6ff:	50                   	push   %eax
 700:	ff 75 0c             	pushl  0xc(%ebp)
 703:	ff 75 08             	pushl  0x8(%ebp)
 706:	e8 32 ff ff ff       	call   63d <stosb>
 70b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 70e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 711:	c9                   	leave  
 712:	c3                   	ret    

00000713 <strchr>:

char*
strchr(const char *s, char c)
{
 713:	55                   	push   %ebp
 714:	89 e5                	mov    %esp,%ebp
 716:	83 ec 04             	sub    $0x4,%esp
 719:	8b 45 0c             	mov    0xc(%ebp),%eax
 71c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 71f:	eb 14                	jmp    735 <strchr+0x22>
    if(*s == c)
 721:	8b 45 08             	mov    0x8(%ebp),%eax
 724:	0f b6 00             	movzbl (%eax),%eax
 727:	3a 45 fc             	cmp    -0x4(%ebp),%al
 72a:	75 05                	jne    731 <strchr+0x1e>
      return (char*)s;
 72c:	8b 45 08             	mov    0x8(%ebp),%eax
 72f:	eb 13                	jmp    744 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 731:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	0f b6 00             	movzbl (%eax),%eax
 73b:	84 c0                	test   %al,%al
 73d:	75 e2                	jne    721 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 73f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 744:	c9                   	leave  
 745:	c3                   	ret    

00000746 <gets>:

char*
gets(char *buf, int max)
{
 746:	55                   	push   %ebp
 747:	89 e5                	mov    %esp,%ebp
 749:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 74c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 753:	eb 42                	jmp    797 <gets+0x51>
    cc = read(0, &c, 1);
 755:	83 ec 04             	sub    $0x4,%esp
 758:	6a 01                	push   $0x1
 75a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 75d:	50                   	push   %eax
 75e:	6a 00                	push   $0x0
 760:	e8 d5 01 00 00       	call   93a <read>
 765:	83 c4 10             	add    $0x10,%esp
 768:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 76b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76f:	7e 33                	jle    7a4 <gets+0x5e>
      break;
    buf[i++] = c;
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	8d 50 01             	lea    0x1(%eax),%edx
 777:	89 55 f4             	mov    %edx,-0xc(%ebp)
 77a:	89 c2                	mov    %eax,%edx
 77c:	8b 45 08             	mov    0x8(%ebp),%eax
 77f:	01 c2                	add    %eax,%edx
 781:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 785:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 787:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 78b:	3c 0a                	cmp    $0xa,%al
 78d:	74 16                	je     7a5 <gets+0x5f>
 78f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 793:	3c 0d                	cmp    $0xd,%al
 795:	74 0e                	je     7a5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	83 c0 01             	add    $0x1,%eax
 79d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 7a0:	7c b3                	jl     755 <gets+0xf>
 7a2:	eb 01                	jmp    7a5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 7a4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7a8:	8b 45 08             	mov    0x8(%ebp),%eax
 7ab:	01 d0                	add    %edx,%eax
 7ad:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7b3:	c9                   	leave  
 7b4:	c3                   	ret    

000007b5 <stat>:

int
stat(char *n, struct stat *st)
{
 7b5:	55                   	push   %ebp
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7bb:	83 ec 08             	sub    $0x8,%esp
 7be:	6a 00                	push   $0x0
 7c0:	ff 75 08             	pushl  0x8(%ebp)
 7c3:	e8 9a 01 00 00       	call   962 <open>
 7c8:	83 c4 10             	add    $0x10,%esp
 7cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d2:	79 07                	jns    7db <stat+0x26>
    return -1;
 7d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7d9:	eb 25                	jmp    800 <stat+0x4b>
  r = fstat(fd, st);
 7db:	83 ec 08             	sub    $0x8,%esp
 7de:	ff 75 0c             	pushl  0xc(%ebp)
 7e1:	ff 75 f4             	pushl  -0xc(%ebp)
 7e4:	e8 91 01 00 00       	call   97a <fstat>
 7e9:	83 c4 10             	add    $0x10,%esp
 7ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7ef:	83 ec 0c             	sub    $0xc,%esp
 7f2:	ff 75 f4             	pushl  -0xc(%ebp)
 7f5:	e8 50 01 00 00       	call   94a <close>
 7fa:	83 c4 10             	add    $0x10,%esp
  return r;
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 800:	c9                   	leave  
 801:	c3                   	ret    

00000802 <atoi>:

int
atoi(const char *s)
{
 802:	55                   	push   %ebp
 803:	89 e5                	mov    %esp,%ebp
 805:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 808:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 80f:	eb 25                	jmp    836 <atoi+0x34>
    n = n*10 + *s++ - '0';
 811:	8b 55 fc             	mov    -0x4(%ebp),%edx
 814:	89 d0                	mov    %edx,%eax
 816:	c1 e0 02             	shl    $0x2,%eax
 819:	01 d0                	add    %edx,%eax
 81b:	01 c0                	add    %eax,%eax
 81d:	89 c1                	mov    %eax,%ecx
 81f:	8b 45 08             	mov    0x8(%ebp),%eax
 822:	8d 50 01             	lea    0x1(%eax),%edx
 825:	89 55 08             	mov    %edx,0x8(%ebp)
 828:	0f b6 00             	movzbl (%eax),%eax
 82b:	0f be c0             	movsbl %al,%eax
 82e:	01 c8                	add    %ecx,%eax
 830:	83 e8 30             	sub    $0x30,%eax
 833:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 836:	8b 45 08             	mov    0x8(%ebp),%eax
 839:	0f b6 00             	movzbl (%eax),%eax
 83c:	3c 2f                	cmp    $0x2f,%al
 83e:	7e 0a                	jle    84a <atoi+0x48>
 840:	8b 45 08             	mov    0x8(%ebp),%eax
 843:	0f b6 00             	movzbl (%eax),%eax
 846:	3c 39                	cmp    $0x39,%al
 848:	7e c7                	jle    811 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 84d:	c9                   	leave  
 84e:	c3                   	ret    

0000084f <atoo>:

int
atoo(const char *s)
{
 84f:	55                   	push   %ebp
 850:	89 e5                	mov    %esp,%ebp
 852:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
 855:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
 85c:	eb 04                	jmp    862 <atoo+0x13>
        s++;
 85e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
 862:	8b 45 08             	mov    0x8(%ebp),%eax
 865:	0f b6 00             	movzbl (%eax),%eax
 868:	3c 20                	cmp    $0x20,%al
 86a:	74 f2                	je     85e <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
 86c:	8b 45 08             	mov    0x8(%ebp),%eax
 86f:	0f b6 00             	movzbl (%eax),%eax
 872:	3c 2d                	cmp    $0x2d,%al
 874:	75 07                	jne    87d <atoo+0x2e>
 876:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 87b:	eb 05                	jmp    882 <atoo+0x33>
 87d:	b8 01 00 00 00       	mov    $0x1,%eax
 882:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
 885:	8b 45 08             	mov    0x8(%ebp),%eax
 888:	0f b6 00             	movzbl (%eax),%eax
 88b:	3c 2b                	cmp    $0x2b,%al
 88d:	74 0a                	je     899 <atoo+0x4a>
 88f:	8b 45 08             	mov    0x8(%ebp),%eax
 892:	0f b6 00             	movzbl (%eax),%eax
 895:	3c 2d                	cmp    $0x2d,%al
 897:	75 27                	jne    8c0 <atoo+0x71>
        s++;
 899:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
 89d:	eb 21                	jmp    8c0 <atoo+0x71>
        n = n*8 + *s++ - '0';
 89f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
 8ac:	8d 50 01             	lea    0x1(%eax),%edx
 8af:	89 55 08             	mov    %edx,0x8(%ebp)
 8b2:	0f b6 00             	movzbl (%eax),%eax
 8b5:	0f be c0             	movsbl %al,%eax
 8b8:	01 c8                	add    %ecx,%eax
 8ba:	83 e8 30             	sub    $0x30,%eax
 8bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
 8c0:	8b 45 08             	mov    0x8(%ebp),%eax
 8c3:	0f b6 00             	movzbl (%eax),%eax
 8c6:	3c 2f                	cmp    $0x2f,%al
 8c8:	7e 0a                	jle    8d4 <atoo+0x85>
 8ca:	8b 45 08             	mov    0x8(%ebp),%eax
 8cd:	0f b6 00             	movzbl (%eax),%eax
 8d0:	3c 37                	cmp    $0x37,%al
 8d2:	7e cb                	jle    89f <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
 8d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d7:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 8db:	c9                   	leave  
 8dc:	c3                   	ret    

000008dd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 8dd:	55                   	push   %ebp
 8de:	89 e5                	mov    %esp,%ebp
 8e0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 8e3:	8b 45 08             	mov    0x8(%ebp),%eax
 8e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 8e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 8ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 8ef:	eb 17                	jmp    908 <memmove+0x2b>
    *dst++ = *src++;
 8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f4:	8d 50 01             	lea    0x1(%eax),%edx
 8f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 8fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8fd:	8d 4a 01             	lea    0x1(%edx),%ecx
 900:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 903:	0f b6 12             	movzbl (%edx),%edx
 906:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 908:	8b 45 10             	mov    0x10(%ebp),%eax
 90b:	8d 50 ff             	lea    -0x1(%eax),%edx
 90e:	89 55 10             	mov    %edx,0x10(%ebp)
 911:	85 c0                	test   %eax,%eax
 913:	7f dc                	jg     8f1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 915:	8b 45 08             	mov    0x8(%ebp),%eax
}
 918:	c9                   	leave  
 919:	c3                   	ret    

0000091a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 91a:	b8 01 00 00 00       	mov    $0x1,%eax
 91f:	cd 40                	int    $0x40
 921:	c3                   	ret    

00000922 <exit>:
SYSCALL(exit)
 922:	b8 02 00 00 00       	mov    $0x2,%eax
 927:	cd 40                	int    $0x40
 929:	c3                   	ret    

0000092a <wait>:
SYSCALL(wait)
 92a:	b8 03 00 00 00       	mov    $0x3,%eax
 92f:	cd 40                	int    $0x40
 931:	c3                   	ret    

00000932 <pipe>:
SYSCALL(pipe)
 932:	b8 04 00 00 00       	mov    $0x4,%eax
 937:	cd 40                	int    $0x40
 939:	c3                   	ret    

0000093a <read>:
SYSCALL(read)
 93a:	b8 05 00 00 00       	mov    $0x5,%eax
 93f:	cd 40                	int    $0x40
 941:	c3                   	ret    

00000942 <write>:
SYSCALL(write)
 942:	b8 10 00 00 00       	mov    $0x10,%eax
 947:	cd 40                	int    $0x40
 949:	c3                   	ret    

0000094a <close>:
SYSCALL(close)
 94a:	b8 15 00 00 00       	mov    $0x15,%eax
 94f:	cd 40                	int    $0x40
 951:	c3                   	ret    

00000952 <kill>:
SYSCALL(kill)
 952:	b8 06 00 00 00       	mov    $0x6,%eax
 957:	cd 40                	int    $0x40
 959:	c3                   	ret    

0000095a <exec>:
SYSCALL(exec)
 95a:	b8 07 00 00 00       	mov    $0x7,%eax
 95f:	cd 40                	int    $0x40
 961:	c3                   	ret    

00000962 <open>:
SYSCALL(open)
 962:	b8 0f 00 00 00       	mov    $0xf,%eax
 967:	cd 40                	int    $0x40
 969:	c3                   	ret    

0000096a <mknod>:
SYSCALL(mknod)
 96a:	b8 11 00 00 00       	mov    $0x11,%eax
 96f:	cd 40                	int    $0x40
 971:	c3                   	ret    

00000972 <unlink>:
SYSCALL(unlink)
 972:	b8 12 00 00 00       	mov    $0x12,%eax
 977:	cd 40                	int    $0x40
 979:	c3                   	ret    

0000097a <fstat>:
SYSCALL(fstat)
 97a:	b8 08 00 00 00       	mov    $0x8,%eax
 97f:	cd 40                	int    $0x40
 981:	c3                   	ret    

00000982 <link>:
SYSCALL(link)
 982:	b8 13 00 00 00       	mov    $0x13,%eax
 987:	cd 40                	int    $0x40
 989:	c3                   	ret    

0000098a <mkdir>:
SYSCALL(mkdir)
 98a:	b8 14 00 00 00       	mov    $0x14,%eax
 98f:	cd 40                	int    $0x40
 991:	c3                   	ret    

00000992 <chdir>:
SYSCALL(chdir)
 992:	b8 09 00 00 00       	mov    $0x9,%eax
 997:	cd 40                	int    $0x40
 999:	c3                   	ret    

0000099a <dup>:
SYSCALL(dup)
 99a:	b8 0a 00 00 00       	mov    $0xa,%eax
 99f:	cd 40                	int    $0x40
 9a1:	c3                   	ret    

000009a2 <getpid>:
SYSCALL(getpid)
 9a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 9a7:	cd 40                	int    $0x40
 9a9:	c3                   	ret    

000009aa <sbrk>:
SYSCALL(sbrk)
 9aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 9af:	cd 40                	int    $0x40
 9b1:	c3                   	ret    

000009b2 <sleep>:
SYSCALL(sleep)
 9b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 9b7:	cd 40                	int    $0x40
 9b9:	c3                   	ret    

000009ba <uptime>:
SYSCALL(uptime)
 9ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 9bf:	cd 40                	int    $0x40
 9c1:	c3                   	ret    

000009c2 <halt>:
SYSCALL(halt)
 9c2:	b8 16 00 00 00       	mov    $0x16,%eax
 9c7:	cd 40                	int    $0x40
 9c9:	c3                   	ret    

000009ca <date>:
SYSCALL(date)
 9ca:	b8 17 00 00 00       	mov    $0x17,%eax
 9cf:	cd 40                	int    $0x40
 9d1:	c3                   	ret    

000009d2 <getuid>:
SYSCALL(getuid)
 9d2:	b8 18 00 00 00       	mov    $0x18,%eax
 9d7:	cd 40                	int    $0x40
 9d9:	c3                   	ret    

000009da <getgid>:
SYSCALL(getgid)
 9da:	b8 19 00 00 00       	mov    $0x19,%eax
 9df:	cd 40                	int    $0x40
 9e1:	c3                   	ret    

000009e2 <getppid>:
SYSCALL(getppid)
 9e2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 9e7:	cd 40                	int    $0x40
 9e9:	c3                   	ret    

000009ea <setuid>:
SYSCALL(setuid)
 9ea:	b8 1b 00 00 00       	mov    $0x1b,%eax
 9ef:	cd 40                	int    $0x40
 9f1:	c3                   	ret    

000009f2 <setgid>:
SYSCALL(setgid)
 9f2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 9f7:	cd 40                	int    $0x40
 9f9:	c3                   	ret    

000009fa <getprocs>:
SYSCALL(getprocs)
 9fa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 9ff:	cd 40                	int    $0x40
 a01:	c3                   	ret    

00000a02 <setpriority>:
SYSCALL(setpriority)
 a02:	b8 1e 00 00 00       	mov    $0x1e,%eax
 a07:	cd 40                	int    $0x40
 a09:	c3                   	ret    

00000a0a <chmod>:
SYSCALL(chmod)
 a0a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 a0f:	cd 40                	int    $0x40
 a11:	c3                   	ret    

00000a12 <chown>:
SYSCALL(chown)
 a12:	b8 20 00 00 00       	mov    $0x20,%eax
 a17:	cd 40                	int    $0x40
 a19:	c3                   	ret    

00000a1a <chgrp>:
SYSCALL(chgrp)
 a1a:	b8 21 00 00 00       	mov    $0x21,%eax
 a1f:	cd 40                	int    $0x40
 a21:	c3                   	ret    

00000a22 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a22:	55                   	push   %ebp
 a23:	89 e5                	mov    %esp,%ebp
 a25:	83 ec 18             	sub    $0x18,%esp
 a28:	8b 45 0c             	mov    0xc(%ebp),%eax
 a2b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 a2e:	83 ec 04             	sub    $0x4,%esp
 a31:	6a 01                	push   $0x1
 a33:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a36:	50                   	push   %eax
 a37:	ff 75 08             	pushl  0x8(%ebp)
 a3a:	e8 03 ff ff ff       	call   942 <write>
 a3f:	83 c4 10             	add    $0x10,%esp
}
 a42:	90                   	nop
 a43:	c9                   	leave  
 a44:	c3                   	ret    

00000a45 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a45:	55                   	push   %ebp
 a46:	89 e5                	mov    %esp,%ebp
 a48:	53                   	push   %ebx
 a49:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a53:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a57:	74 17                	je     a70 <printint+0x2b>
 a59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 a5d:	79 11                	jns    a70 <printint+0x2b>
    neg = 1;
 a5f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a66:	8b 45 0c             	mov    0xc(%ebp),%eax
 a69:	f7 d8                	neg    %eax
 a6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a6e:	eb 06                	jmp    a76 <printint+0x31>
  } else {
    x = xx;
 a70:	8b 45 0c             	mov    0xc(%ebp),%eax
 a73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a7d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 a80:	8d 41 01             	lea    0x1(%ecx),%eax
 a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a86:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a8c:	ba 00 00 00 00       	mov    $0x0,%edx
 a91:	f7 f3                	div    %ebx
 a93:	89 d0                	mov    %edx,%eax
 a95:	0f b6 80 28 12 00 00 	movzbl 0x1228(%eax),%eax
 a9c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 aa0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa6:	ba 00 00 00 00       	mov    $0x0,%edx
 aab:	f7 f3                	div    %ebx
 aad:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ab0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ab4:	75 c7                	jne    a7d <printint+0x38>
  if(neg)
 ab6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 aba:	74 2d                	je     ae9 <printint+0xa4>
    buf[i++] = '-';
 abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abf:	8d 50 01             	lea    0x1(%eax),%edx
 ac2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 ac5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 aca:	eb 1d                	jmp    ae9 <printint+0xa4>
    putc(fd, buf[i]);
 acc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad2:	01 d0                	add    %edx,%eax
 ad4:	0f b6 00             	movzbl (%eax),%eax
 ad7:	0f be c0             	movsbl %al,%eax
 ada:	83 ec 08             	sub    $0x8,%esp
 add:	50                   	push   %eax
 ade:	ff 75 08             	pushl  0x8(%ebp)
 ae1:	e8 3c ff ff ff       	call   a22 <putc>
 ae6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 ae9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 af1:	79 d9                	jns    acc <printint+0x87>
    putc(fd, buf[i]);
}
 af3:	90                   	nop
 af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 af7:	c9                   	leave  
 af8:	c3                   	ret    

00000af9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 af9:	55                   	push   %ebp
 afa:	89 e5                	mov    %esp,%ebp
 afc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 aff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b06:	8d 45 0c             	lea    0xc(%ebp),%eax
 b09:	83 c0 04             	add    $0x4,%eax
 b0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b16:	e9 59 01 00 00       	jmp    c74 <printf+0x17b>
    c = fmt[i] & 0xff;
 b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
 b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b21:	01 d0                	add    %edx,%eax
 b23:	0f b6 00             	movzbl (%eax),%eax
 b26:	0f be c0             	movsbl %al,%eax
 b29:	25 ff 00 00 00       	and    $0xff,%eax
 b2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 b31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b35:	75 2c                	jne    b63 <printf+0x6a>
      if(c == '%'){
 b37:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b3b:	75 0c                	jne    b49 <printf+0x50>
        state = '%';
 b3d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b44:	e9 27 01 00 00       	jmp    c70 <printf+0x177>
      } else {
        putc(fd, c);
 b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b4c:	0f be c0             	movsbl %al,%eax
 b4f:	83 ec 08             	sub    $0x8,%esp
 b52:	50                   	push   %eax
 b53:	ff 75 08             	pushl  0x8(%ebp)
 b56:	e8 c7 fe ff ff       	call   a22 <putc>
 b5b:	83 c4 10             	add    $0x10,%esp
 b5e:	e9 0d 01 00 00       	jmp    c70 <printf+0x177>
      }
    } else if(state == '%'){
 b63:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b67:	0f 85 03 01 00 00    	jne    c70 <printf+0x177>
      if(c == 'd'){
 b6d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b71:	75 1e                	jne    b91 <printf+0x98>
        printint(fd, *ap, 10, 1);
 b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b76:	8b 00                	mov    (%eax),%eax
 b78:	6a 01                	push   $0x1
 b7a:	6a 0a                	push   $0xa
 b7c:	50                   	push   %eax
 b7d:	ff 75 08             	pushl  0x8(%ebp)
 b80:	e8 c0 fe ff ff       	call   a45 <printint>
 b85:	83 c4 10             	add    $0x10,%esp
        ap++;
 b88:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b8c:	e9 d8 00 00 00       	jmp    c69 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 b91:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b95:	74 06                	je     b9d <printf+0xa4>
 b97:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b9b:	75 1e                	jne    bbb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ba0:	8b 00                	mov    (%eax),%eax
 ba2:	6a 00                	push   $0x0
 ba4:	6a 10                	push   $0x10
 ba6:	50                   	push   %eax
 ba7:	ff 75 08             	pushl  0x8(%ebp)
 baa:	e8 96 fe ff ff       	call   a45 <printint>
 baf:	83 c4 10             	add    $0x10,%esp
        ap++;
 bb2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bb6:	e9 ae 00 00 00       	jmp    c69 <printf+0x170>
      } else if(c == 's'){
 bbb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 bbf:	75 43                	jne    c04 <printf+0x10b>
        s = (char*)*ap;
 bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bc4:	8b 00                	mov    (%eax),%eax
 bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 bc9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 bcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bd1:	75 25                	jne    bf8 <printf+0xff>
          s = "(null)";
 bd3:	c7 45 f4 3f 0f 00 00 	movl   $0xf3f,-0xc(%ebp)
        while(*s != 0){
 bda:	eb 1c                	jmp    bf8 <printf+0xff>
          putc(fd, *s);
 bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bdf:	0f b6 00             	movzbl (%eax),%eax
 be2:	0f be c0             	movsbl %al,%eax
 be5:	83 ec 08             	sub    $0x8,%esp
 be8:	50                   	push   %eax
 be9:	ff 75 08             	pushl  0x8(%ebp)
 bec:	e8 31 fe ff ff       	call   a22 <putc>
 bf1:	83 c4 10             	add    $0x10,%esp
          s++;
 bf4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfb:	0f b6 00             	movzbl (%eax),%eax
 bfe:	84 c0                	test   %al,%al
 c00:	75 da                	jne    bdc <printf+0xe3>
 c02:	eb 65                	jmp    c69 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 c04:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c08:	75 1d                	jne    c27 <printf+0x12e>
        putc(fd, *ap);
 c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c0d:	8b 00                	mov    (%eax),%eax
 c0f:	0f be c0             	movsbl %al,%eax
 c12:	83 ec 08             	sub    $0x8,%esp
 c15:	50                   	push   %eax
 c16:	ff 75 08             	pushl  0x8(%ebp)
 c19:	e8 04 fe ff ff       	call   a22 <putc>
 c1e:	83 c4 10             	add    $0x10,%esp
        ap++;
 c21:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c25:	eb 42                	jmp    c69 <printf+0x170>
      } else if(c == '%'){
 c27:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c2b:	75 17                	jne    c44 <printf+0x14b>
        putc(fd, c);
 c2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c30:	0f be c0             	movsbl %al,%eax
 c33:	83 ec 08             	sub    $0x8,%esp
 c36:	50                   	push   %eax
 c37:	ff 75 08             	pushl  0x8(%ebp)
 c3a:	e8 e3 fd ff ff       	call   a22 <putc>
 c3f:	83 c4 10             	add    $0x10,%esp
 c42:	eb 25                	jmp    c69 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c44:	83 ec 08             	sub    $0x8,%esp
 c47:	6a 25                	push   $0x25
 c49:	ff 75 08             	pushl  0x8(%ebp)
 c4c:	e8 d1 fd ff ff       	call   a22 <putc>
 c51:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c57:	0f be c0             	movsbl %al,%eax
 c5a:	83 ec 08             	sub    $0x8,%esp
 c5d:	50                   	push   %eax
 c5e:	ff 75 08             	pushl  0x8(%ebp)
 c61:	e8 bc fd ff ff       	call   a22 <putc>
 c66:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 c69:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c70:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 c74:	8b 55 0c             	mov    0xc(%ebp),%edx
 c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c7a:	01 d0                	add    %edx,%eax
 c7c:	0f b6 00             	movzbl (%eax),%eax
 c7f:	84 c0                	test   %al,%al
 c81:	0f 85 94 fe ff ff    	jne    b1b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c87:	90                   	nop
 c88:	c9                   	leave  
 c89:	c3                   	ret    

00000c8a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c8a:	55                   	push   %ebp
 c8b:	89 e5                	mov    %esp,%ebp
 c8d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c90:	8b 45 08             	mov    0x8(%ebp),%eax
 c93:	83 e8 08             	sub    $0x8,%eax
 c96:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c99:	a1 54 12 00 00       	mov    0x1254,%eax
 c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ca1:	eb 24                	jmp    cc7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca6:	8b 00                	mov    (%eax),%eax
 ca8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cab:	77 12                	ja     cbf <free+0x35>
 cad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cb3:	77 24                	ja     cd9 <free+0x4f>
 cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb8:	8b 00                	mov    (%eax),%eax
 cba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cbd:	77 1a                	ja     cd9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc2:	8b 00                	mov    (%eax),%eax
 cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 cc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ccd:	76 d4                	jbe    ca3 <free+0x19>
 ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd2:	8b 00                	mov    (%eax),%eax
 cd4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cd7:	76 ca                	jbe    ca3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 cd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cdc:	8b 40 04             	mov    0x4(%eax),%eax
 cdf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ce6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ce9:	01 c2                	add    %eax,%edx
 ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cee:	8b 00                	mov    (%eax),%eax
 cf0:	39 c2                	cmp    %eax,%edx
 cf2:	75 24                	jne    d18 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 cf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf7:	8b 50 04             	mov    0x4(%eax),%edx
 cfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfd:	8b 00                	mov    (%eax),%eax
 cff:	8b 40 04             	mov    0x4(%eax),%eax
 d02:	01 c2                	add    %eax,%edx
 d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d07:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d0d:	8b 00                	mov    (%eax),%eax
 d0f:	8b 10                	mov    (%eax),%edx
 d11:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d14:	89 10                	mov    %edx,(%eax)
 d16:	eb 0a                	jmp    d22 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d1b:	8b 10                	mov    (%eax),%edx
 d1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d20:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d25:	8b 40 04             	mov    0x4(%eax),%eax
 d28:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d32:	01 d0                	add    %edx,%eax
 d34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d37:	75 20                	jne    d59 <free+0xcf>
    p->s.size += bp->s.size;
 d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d3c:	8b 50 04             	mov    0x4(%eax),%edx
 d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d42:	8b 40 04             	mov    0x4(%eax),%eax
 d45:	01 c2                	add    %eax,%edx
 d47:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d4a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d50:	8b 10                	mov    (%eax),%edx
 d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d55:	89 10                	mov    %edx,(%eax)
 d57:	eb 08                	jmp    d61 <free+0xd7>
  } else
    p->s.ptr = bp;
 d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d5c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d5f:	89 10                	mov    %edx,(%eax)
  freep = p;
 d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d64:	a3 54 12 00 00       	mov    %eax,0x1254
}
 d69:	90                   	nop
 d6a:	c9                   	leave  
 d6b:	c3                   	ret    

00000d6c <morecore>:

static Header*
morecore(uint nu)
{
 d6c:	55                   	push   %ebp
 d6d:	89 e5                	mov    %esp,%ebp
 d6f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d72:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d79:	77 07                	ja     d82 <morecore+0x16>
    nu = 4096;
 d7b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d82:	8b 45 08             	mov    0x8(%ebp),%eax
 d85:	c1 e0 03             	shl    $0x3,%eax
 d88:	83 ec 0c             	sub    $0xc,%esp
 d8b:	50                   	push   %eax
 d8c:	e8 19 fc ff ff       	call   9aa <sbrk>
 d91:	83 c4 10             	add    $0x10,%esp
 d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d97:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d9b:	75 07                	jne    da4 <morecore+0x38>
    return 0;
 d9d:	b8 00 00 00 00       	mov    $0x0,%eax
 da2:	eb 26                	jmp    dca <morecore+0x5e>
  hp = (Header*)p;
 da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dad:	8b 55 08             	mov    0x8(%ebp),%edx
 db0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 db6:	83 c0 08             	add    $0x8,%eax
 db9:	83 ec 0c             	sub    $0xc,%esp
 dbc:	50                   	push   %eax
 dbd:	e8 c8 fe ff ff       	call   c8a <free>
 dc2:	83 c4 10             	add    $0x10,%esp
  return freep;
 dc5:	a1 54 12 00 00       	mov    0x1254,%eax
}
 dca:	c9                   	leave  
 dcb:	c3                   	ret    

00000dcc <malloc>:

void*
malloc(uint nbytes)
{
 dcc:	55                   	push   %ebp
 dcd:	89 e5                	mov    %esp,%ebp
 dcf:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 dd2:	8b 45 08             	mov    0x8(%ebp),%eax
 dd5:	83 c0 07             	add    $0x7,%eax
 dd8:	c1 e8 03             	shr    $0x3,%eax
 ddb:	83 c0 01             	add    $0x1,%eax
 dde:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 de1:	a1 54 12 00 00       	mov    0x1254,%eax
 de6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 de9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ded:	75 23                	jne    e12 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 def:	c7 45 f0 4c 12 00 00 	movl   $0x124c,-0x10(%ebp)
 df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 df9:	a3 54 12 00 00       	mov    %eax,0x1254
 dfe:	a1 54 12 00 00       	mov    0x1254,%eax
 e03:	a3 4c 12 00 00       	mov    %eax,0x124c
    base.s.size = 0;
 e08:	c7 05 50 12 00 00 00 	movl   $0x0,0x1250
 e0f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e15:	8b 00                	mov    (%eax),%eax
 e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e1d:	8b 40 04             	mov    0x4(%eax),%eax
 e20:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e23:	72 4d                	jb     e72 <malloc+0xa6>
      if(p->s.size == nunits)
 e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e28:	8b 40 04             	mov    0x4(%eax),%eax
 e2b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e2e:	75 0c                	jne    e3c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e33:	8b 10                	mov    (%eax),%edx
 e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e38:	89 10                	mov    %edx,(%eax)
 e3a:	eb 26                	jmp    e62 <malloc+0x96>
      else {
        p->s.size -= nunits;
 e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e3f:	8b 40 04             	mov    0x4(%eax),%eax
 e42:	2b 45 ec             	sub    -0x14(%ebp),%eax
 e45:	89 c2                	mov    %eax,%edx
 e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e4a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e50:	8b 40 04             	mov    0x4(%eax),%eax
 e53:	c1 e0 03             	shl    $0x3,%eax
 e56:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e5f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e65:	a3 54 12 00 00       	mov    %eax,0x1254
      return (void*)(p + 1);
 e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e6d:	83 c0 08             	add    $0x8,%eax
 e70:	eb 3b                	jmp    ead <malloc+0xe1>
    }
    if(p == freep)
 e72:	a1 54 12 00 00       	mov    0x1254,%eax
 e77:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e7a:	75 1e                	jne    e9a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 e7c:	83 ec 0c             	sub    $0xc,%esp
 e7f:	ff 75 ec             	pushl  -0x14(%ebp)
 e82:	e8 e5 fe ff ff       	call   d6c <morecore>
 e87:	83 c4 10             	add    $0x10,%esp
 e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e91:	75 07                	jne    e9a <malloc+0xce>
        return 0;
 e93:	b8 00 00 00 00       	mov    $0x0,%eax
 e98:	eb 13                	jmp    ead <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ea3:	8b 00                	mov    (%eax),%eax
 ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ea8:	e9 6d ff ff ff       	jmp    e1a <malloc+0x4e>
}
 ead:	c9                   	leave  
 eae:	c3                   	ret    
