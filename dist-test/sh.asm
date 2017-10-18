
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 2f 13 00 00       	call   1340 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 fc 18 00 00 	mov    0x18fc(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 d0 18 00 00       	push   $0x18d0
      2c:	e8 48 07 00 00       	call   779 <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 f7 12 00 00       	call   1340 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 19 13 00 00       	call   1378 <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 f4             	mov    -0xc(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 d7 18 00 00       	push   $0x18d7
      71:	6a 02                	push   $0x2
      73:	e8 9f 14 00 00       	call   1517 <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c6 01 00 00       	jmp    246 <runcmd+0x246>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 d3 12 00 00       	call   1368 <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 d2 12 00 00       	call   1380 <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 e7 18 00 00       	push   $0x18e7
      c4:	6a 02                	push   $0x2
      c6:	e8 4c 14 00 00       	call   1517 <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 6d 12 00 00       	call   1340 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5c 01 00 00       	jmp    246 <runcmd+0x246>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      f0:	e8 a4 06 00 00       	call   799 <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 38 12 00 00       	call   1348 <wait>
    runcmd(lcmd->right);
     110:	8b 45 ec             	mov    -0x14(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 1f 01 00 00       	jmp    246 <runcmd+0x246>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 17 12 00 00       	call   1350 <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 f7 18 00 00       	push   $0x18f7
     148:	e8 2c 06 00 00       	call   779 <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 44 06 00 00       	call   799 <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 05 12 00 00       	call   1368 <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 46 12 00 00       	call   13b8 <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 e7 11 00 00       	call   1368 <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 d8 11 00 00       	call   1368 <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 e8             	mov    -0x18(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 ef 05 00 00       	call   799 <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 b0 11 00 00       	call   1368 <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 f1 11 00 00       	call   13b8 <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 92 11 00 00       	call   1368 <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 83 11 00 00       	call   1368 <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 62 11 00 00       	call   1368 <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 53 11 00 00       	call   1368 <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 2b 11 00 00       	call   1348 <wait>
    wait();
     21d:	e8 26 11 00 00       	call   1348 <wait>
    break;
     222:	eb 22                	jmp    246 <runcmd+0x246>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     22a:	e8 6a 05 00 00       	call   799 <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 12                	jne    245 <runcmd+0x245>
      runcmd(bcmd->cmd);
     233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	90                   	nop
  }
  exit();
     246:	e8 f5 10 00 00       	call   1340 <exit>

0000024b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24b:	55                   	push   %ebp
     24c:	89 e5                	mov    %esp,%ebp
     24e:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     251:	83 ec 08             	sub    $0x8,%esp
     254:	68 14 19 00 00       	push   $0x1914
     259:	6a 02                	push   $0x2
     25b:	e8 b7 12 00 00       	call   1517 <printf>
     260:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     263:	8b 45 0c             	mov    0xc(%ebp),%eax
     266:	83 ec 04             	sub    $0x4,%esp
     269:	50                   	push   %eax
     26a:	6a 00                	push   $0x0
     26c:	ff 75 08             	pushl  0x8(%ebp)
     26f:	e8 a3 0e 00 00       	call   1117 <memset>
     274:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     277:	83 ec 08             	sub    $0x8,%esp
     27a:	ff 75 0c             	pushl  0xc(%ebp)
     27d:	ff 75 08             	pushl  0x8(%ebp)
     280:	e8 df 0e 00 00       	call   1164 <gets>
     285:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     288:	8b 45 08             	mov    0x8(%ebp),%eax
     28b:	0f b6 00             	movzbl (%eax),%eax
     28e:	84 c0                	test   %al,%al
     290:	75 07                	jne    299 <getcmd+0x4e>
    return -1;
     292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     297:	eb 05                	jmp    29e <getcmd+0x53>
  return 0;
     299:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29e:	c9                   	leave  
     29f:	c3                   	ret    

000002a0 <strncmp>:
#ifdef USE_BUILTINS
// ***** processing for shell builtins begins here *****

int
strncmp(const char *p, const char *q, uint n)
{
     2a0:	55                   	push   %ebp
     2a1:	89 e5                	mov    %esp,%ebp
    while(n > 0 && *p && *p == *q)
     2a3:	eb 0c                	jmp    2b1 <strncmp+0x11>
      n--, p++, q++;
     2a5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     2a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     2ad:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
// ***** processing for shell builtins begins here *****

int
strncmp(const char *p, const char *q, uint n)
{
    while(n > 0 && *p && *p == *q)
     2b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     2b5:	74 1a                	je     2d1 <strncmp+0x31>
     2b7:	8b 45 08             	mov    0x8(%ebp),%eax
     2ba:	0f b6 00             	movzbl (%eax),%eax
     2bd:	84 c0                	test   %al,%al
     2bf:	74 10                	je     2d1 <strncmp+0x31>
     2c1:	8b 45 08             	mov    0x8(%ebp),%eax
     2c4:	0f b6 10             	movzbl (%eax),%edx
     2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ca:	0f b6 00             	movzbl (%eax),%eax
     2cd:	38 c2                	cmp    %al,%dl
     2cf:	74 d4                	je     2a5 <strncmp+0x5>
      n--, p++, q++;
    if(n == 0)
     2d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     2d5:	75 07                	jne    2de <strncmp+0x3e>
      return 0;
     2d7:	b8 00 00 00 00       	mov    $0x0,%eax
     2dc:	eb 16                	jmp    2f4 <strncmp+0x54>
    return (uchar)*p - (uchar)*q;
     2de:	8b 45 08             	mov    0x8(%ebp),%eax
     2e1:	0f b6 00             	movzbl (%eax),%eax
     2e4:	0f b6 d0             	movzbl %al,%edx
     2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ea:	0f b6 00             	movzbl (%eax),%eax
     2ed:	0f b6 c0             	movzbl %al,%eax
     2f0:	29 c2                	sub    %eax,%edx
     2f2:	89 d0                	mov    %edx,%eax
}
     2f4:	5d                   	pop    %ebp
     2f5:	c3                   	ret    

000002f6 <makeint>:

int
makeint(char *p)
{
     2f6:	55                   	push   %ebp
     2f7:	89 e5                	mov    %esp,%ebp
     2f9:	83 ec 10             	sub    $0x10,%esp
  int val = 0;
     2fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  while ((*p >= '0') && (*p <= '9')) {
     303:	eb 23                	jmp    328 <makeint+0x32>
    val = 10*val + (*p-'0');
     305:	8b 55 fc             	mov    -0x4(%ebp),%edx
     308:	89 d0                	mov    %edx,%eax
     30a:	c1 e0 02             	shl    $0x2,%eax
     30d:	01 d0                	add    %edx,%eax
     30f:	01 c0                	add    %eax,%eax
     311:	89 c2                	mov    %eax,%edx
     313:	8b 45 08             	mov    0x8(%ebp),%eax
     316:	0f b6 00             	movzbl (%eax),%eax
     319:	0f be c0             	movsbl %al,%eax
     31c:	83 e8 30             	sub    $0x30,%eax
     31f:	01 d0                	add    %edx,%eax
     321:	89 45 fc             	mov    %eax,-0x4(%ebp)
    ++p;
     324:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
makeint(char *p)
{
  int val = 0;

  while ((*p >= '0') && (*p <= '9')) {
     328:	8b 45 08             	mov    0x8(%ebp),%eax
     32b:	0f b6 00             	movzbl (%eax),%eax
     32e:	3c 2f                	cmp    $0x2f,%al
     330:	7e 0a                	jle    33c <makeint+0x46>
     332:	8b 45 08             	mov    0x8(%ebp),%eax
     335:	0f b6 00             	movzbl (%eax),%eax
     338:	3c 39                	cmp    $0x39,%al
     33a:	7e c9                	jle    305 <makeint+0xf>
    val = 10*val + (*p-'0');
    ++p;
  }
  return val;
     33c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     33f:	c9                   	leave  
     340:	c3                   	ret    

00000341 <setbuiltin>:

int
setbuiltin(char *p)
{
     341:	55                   	push   %ebp
     342:	89 e5                	mov    %esp,%ebp
     344:	83 ec 18             	sub    $0x18,%esp
  int i;

  p += strlen("_set");
     347:	83 ec 0c             	sub    $0xc,%esp
     34a:	68 17 19 00 00       	push   $0x1917
     34f:	e8 9c 0d 00 00       	call   10f0 <strlen>
     354:	83 c4 10             	add    $0x10,%esp
     357:	01 45 08             	add    %eax,0x8(%ebp)
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     35a:	eb 04                	jmp    360 <setbuiltin+0x1f>
     35c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     360:	83 ec 04             	sub    $0x4,%esp
     363:	6a 01                	push   $0x1
     365:	68 1c 19 00 00       	push   $0x191c
     36a:	ff 75 08             	pushl  0x8(%ebp)
     36d:	e8 2e ff ff ff       	call   2a0 <strncmp>
     372:	83 c4 10             	add    $0x10,%esp
     375:	85 c0                	test   %eax,%eax
     377:	74 e3                	je     35c <setbuiltin+0x1b>
  if (strncmp("uid", p, 3) == 0) {
     379:	83 ec 04             	sub    $0x4,%esp
     37c:	6a 03                	push   $0x3
     37e:	ff 75 08             	pushl  0x8(%ebp)
     381:	68 1e 19 00 00       	push   $0x191e
     386:	e8 15 ff ff ff       	call   2a0 <strncmp>
     38b:	83 c4 10             	add    $0x10,%esp
     38e:	85 c0                	test   %eax,%eax
     390:	75 57                	jne    3e9 <setbuiltin+0xa8>
    p += strlen("uid");
     392:	83 ec 0c             	sub    $0xc,%esp
     395:	68 1e 19 00 00       	push   $0x191e
     39a:	e8 51 0d 00 00       	call   10f0 <strlen>
     39f:	83 c4 10             	add    $0x10,%esp
     3a2:	01 45 08             	add    %eax,0x8(%ebp)
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     3a5:	eb 04                	jmp    3ab <setbuiltin+0x6a>
     3a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3ab:	83 ec 04             	sub    $0x4,%esp
     3ae:	6a 01                	push   $0x1
     3b0:	68 1c 19 00 00       	push   $0x191c
     3b5:	ff 75 08             	pushl  0x8(%ebp)
     3b8:	e8 e3 fe ff ff       	call   2a0 <strncmp>
     3bd:	83 c4 10             	add    $0x10,%esp
     3c0:	85 c0                	test   %eax,%eax
     3c2:	74 e3                	je     3a7 <setbuiltin+0x66>
    i = makeint(p); // ugly
     3c4:	83 ec 0c             	sub    $0xc,%esp
     3c7:	ff 75 08             	pushl  0x8(%ebp)
     3ca:	e8 27 ff ff ff       	call   2f6 <makeint>
     3cf:	83 c4 10             	add    $0x10,%esp
     3d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return (setuid(i));
     3d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d8:	83 ec 0c             	sub    $0xc,%esp
     3db:	50                   	push   %eax
     3dc:	e8 27 10 00 00       	call   1408 <setuid>
     3e1:	83 c4 10             	add    $0x10,%esp
     3e4:	e9 49 01 00 00       	jmp    532 <setbuiltin+0x1f1>
  } else 
  if (strncmp("gid", p, 3) == 0) {
     3e9:	83 ec 04             	sub    $0x4,%esp
     3ec:	6a 03                	push   $0x3
     3ee:	ff 75 08             	pushl  0x8(%ebp)
     3f1:	68 22 19 00 00       	push   $0x1922
     3f6:	e8 a5 fe ff ff       	call   2a0 <strncmp>
     3fb:	83 c4 10             	add    $0x10,%esp
     3fe:	85 c0                	test   %eax,%eax
     400:	75 57                	jne    459 <setbuiltin+0x118>
    p += strlen("gid");
     402:	83 ec 0c             	sub    $0xc,%esp
     405:	68 22 19 00 00       	push   $0x1922
     40a:	e8 e1 0c 00 00       	call   10f0 <strlen>
     40f:	83 c4 10             	add    $0x10,%esp
     412:	01 45 08             	add    %eax,0x8(%ebp)
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     415:	eb 04                	jmp    41b <setbuiltin+0xda>
     417:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     41b:	83 ec 04             	sub    $0x4,%esp
     41e:	6a 01                	push   $0x1
     420:	68 1c 19 00 00       	push   $0x191c
     425:	ff 75 08             	pushl  0x8(%ebp)
     428:	e8 73 fe ff ff       	call   2a0 <strncmp>
     42d:	83 c4 10             	add    $0x10,%esp
     430:	85 c0                	test   %eax,%eax
     432:	74 e3                	je     417 <setbuiltin+0xd6>
    i = makeint(p); // ugly
     434:	83 ec 0c             	sub    $0xc,%esp
     437:	ff 75 08             	pushl  0x8(%ebp)
     43a:	e8 b7 fe ff ff       	call   2f6 <makeint>
     43f:	83 c4 10             	add    $0x10,%esp
     442:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return (setgid(i));
     445:	8b 45 f4             	mov    -0xc(%ebp),%eax
     448:	83 ec 0c             	sub    $0xc,%esp
     44b:	50                   	push   %eax
     44c:	e8 bf 0f 00 00       	call   1410 <setgid>
     451:	83 c4 10             	add    $0x10,%esp
     454:	e9 d9 00 00 00       	jmp    532 <setbuiltin+0x1f1>
  }
  if (strncmp("priority", p, 8) == 0) {
     459:	83 ec 04             	sub    $0x4,%esp
     45c:	6a 08                	push   $0x8
     45e:	ff 75 08             	pushl  0x8(%ebp)
     461:	68 26 19 00 00       	push   $0x1926
     466:	e8 35 fe ff ff       	call   2a0 <strncmp>
     46b:	83 c4 10             	add    $0x10,%esp
     46e:	85 c0                	test   %eax,%eax
     470:	0f 85 a5 00 00 00    	jne    51b <setbuiltin+0x1da>
      p += strlen("priority");
     476:	83 ec 0c             	sub    $0xc,%esp
     479:	68 26 19 00 00       	push   $0x1926
     47e:	e8 6d 0c 00 00       	call   10f0 <strlen>
     483:	83 c4 10             	add    $0x10,%esp
     486:	01 45 08             	add    %eax,0x8(%ebp)
      while (strncmp(p, " ", 1) == 0) p++;
     489:	eb 04                	jmp    48f <setbuiltin+0x14e>
     48b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     48f:	83 ec 04             	sub    $0x4,%esp
     492:	6a 01                	push   $0x1
     494:	68 1c 19 00 00       	push   $0x191c
     499:	ff 75 08             	pushl  0x8(%ebp)
     49c:	e8 ff fd ff ff       	call   2a0 <strncmp>
     4a1:	83 c4 10             	add    $0x10,%esp
     4a4:	85 c0                	test   %eax,%eax
     4a6:	74 e3                	je     48b <setbuiltin+0x14a>
      i = makeint(p);
     4a8:	83 ec 0c             	sub    $0xc,%esp
     4ab:	ff 75 08             	pushl  0x8(%ebp)
     4ae:	e8 43 fe ff ff       	call   2f6 <makeint>
     4b3:	83 c4 10             	add    $0x10,%esp
     4b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      while (strncmp(p, " ", 1) != 0) p++;
     4b9:	eb 04                	jmp    4bf <setbuiltin+0x17e>
     4bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     4bf:	83 ec 04             	sub    $0x4,%esp
     4c2:	6a 01                	push   $0x1
     4c4:	68 1c 19 00 00       	push   $0x191c
     4c9:	ff 75 08             	pushl  0x8(%ebp)
     4cc:	e8 cf fd ff ff       	call   2a0 <strncmp>
     4d1:	83 c4 10             	add    $0x10,%esp
     4d4:	85 c0                	test   %eax,%eax
     4d6:	75 e3                	jne    4bb <setbuiltin+0x17a>
      while (strncmp(p, " ", 1) == 0) p++;
     4d8:	eb 04                	jmp    4de <setbuiltin+0x19d>
     4da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     4de:	83 ec 04             	sub    $0x4,%esp
     4e1:	6a 01                	push   $0x1
     4e3:	68 1c 19 00 00       	push   $0x191c
     4e8:	ff 75 08             	pushl  0x8(%ebp)
     4eb:	e8 b0 fd ff ff       	call   2a0 <strncmp>
     4f0:	83 c4 10             	add    $0x10,%esp
     4f3:	85 c0                	test   %eax,%eax
     4f5:	74 e3                	je     4da <setbuiltin+0x199>
      int j = makeint(p);
     4f7:	83 ec 0c             	sub    $0xc,%esp
     4fa:	ff 75 08             	pushl  0x8(%ebp)
     4fd:	e8 f4 fd ff ff       	call   2f6 <makeint>
     502:	83 c4 10             	add    $0x10,%esp
     505:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return setpriority(i, j);
     508:	83 ec 08             	sub    $0x8,%esp
     50b:	ff 75 f0             	pushl  -0x10(%ebp)
     50e:	ff 75 f4             	pushl  -0xc(%ebp)
     511:	e8 0a 0f 00 00       	call   1420 <setpriority>
     516:	83 c4 10             	add    $0x10,%esp
     519:	eb 17                	jmp    532 <setbuiltin+0x1f1>
  }
  printf(2, "Invalid _set parameter\n");
     51b:	83 ec 08             	sub    $0x8,%esp
     51e:	68 2f 19 00 00       	push   $0x192f
     523:	6a 02                	push   $0x2
     525:	e8 ed 0f 00 00       	call   1517 <printf>
     52a:	83 c4 10             	add    $0x10,%esp
  return -1;
     52d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     532:	c9                   	leave  
     533:	c3                   	ret    

00000534 <getbuiltin>:

int
getbuiltin(char *p)
{
     534:	55                   	push   %ebp
     535:	89 e5                	mov    %esp,%ebp
     537:	83 ec 08             	sub    $0x8,%esp
  p += strlen("_get");
     53a:	83 ec 0c             	sub    $0xc,%esp
     53d:	68 47 19 00 00       	push   $0x1947
     542:	e8 a9 0b 00 00       	call   10f0 <strlen>
     547:	83 c4 10             	add    $0x10,%esp
     54a:	01 45 08             	add    %eax,0x8(%ebp)
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     54d:	eb 04                	jmp    553 <getbuiltin+0x1f>
     54f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     553:	83 ec 04             	sub    $0x4,%esp
     556:	6a 01                	push   $0x1
     558:	68 1c 19 00 00       	push   $0x191c
     55d:	ff 75 08             	pushl  0x8(%ebp)
     560:	e8 3b fd ff ff       	call   2a0 <strncmp>
     565:	83 c4 10             	add    $0x10,%esp
     568:	85 c0                	test   %eax,%eax
     56a:	74 e3                	je     54f <getbuiltin+0x1b>
  if (strncmp("uid", p, 3) == 0) {
     56c:	83 ec 04             	sub    $0x4,%esp
     56f:	6a 03                	push   $0x3
     571:	ff 75 08             	pushl  0x8(%ebp)
     574:	68 1e 19 00 00       	push   $0x191e
     579:	e8 22 fd ff ff       	call   2a0 <strncmp>
     57e:	83 c4 10             	add    $0x10,%esp
     581:	85 c0                	test   %eax,%eax
     583:	75 1f                	jne    5a4 <getbuiltin+0x70>
    printf(2, "%d\n", getuid());
     585:	e8 66 0e 00 00       	call   13f0 <getuid>
     58a:	83 ec 04             	sub    $0x4,%esp
     58d:	50                   	push   %eax
     58e:	68 4c 19 00 00       	push   $0x194c
     593:	6a 02                	push   $0x2
     595:	e8 7d 0f 00 00       	call   1517 <printf>
     59a:	83 c4 10             	add    $0x10,%esp
    return 0;
     59d:	b8 00 00 00 00       	mov    $0x0,%eax
     5a2:	eb 4f                	jmp    5f3 <getbuiltin+0xbf>
  }
  if (strncmp("gid", p, 3) == 0) {
     5a4:	83 ec 04             	sub    $0x4,%esp
     5a7:	6a 03                	push   $0x3
     5a9:	ff 75 08             	pushl  0x8(%ebp)
     5ac:	68 22 19 00 00       	push   $0x1922
     5b1:	e8 ea fc ff ff       	call   2a0 <strncmp>
     5b6:	83 c4 10             	add    $0x10,%esp
     5b9:	85 c0                	test   %eax,%eax
     5bb:	75 1f                	jne    5dc <getbuiltin+0xa8>
    printf(2, "%d\n", getgid());
     5bd:	e8 36 0e 00 00       	call   13f8 <getgid>
     5c2:	83 ec 04             	sub    $0x4,%esp
     5c5:	50                   	push   %eax
     5c6:	68 4c 19 00 00       	push   $0x194c
     5cb:	6a 02                	push   $0x2
     5cd:	e8 45 0f 00 00       	call   1517 <printf>
     5d2:	83 c4 10             	add    $0x10,%esp
    return 0;
     5d5:	b8 00 00 00 00       	mov    $0x0,%eax
     5da:	eb 17                	jmp    5f3 <getbuiltin+0xbf>
  }
  printf(2, "Invalid _get parameter\n");
     5dc:	83 ec 08             	sub    $0x8,%esp
     5df:	68 50 19 00 00       	push   $0x1950
     5e4:	6a 02                	push   $0x2
     5e6:	e8 2c 0f 00 00       	call   1517 <printf>
     5eb:	83 c4 10             	add    $0x10,%esp
  return -1;
     5ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     5f3:	c9                   	leave  
     5f4:	c3                   	ret    

000005f5 <dobuiltin>:
  {"_get", getbuiltin}
};
int FDTcount = sizeof(fdt) / sizeof(fdt[0]); // # entris in FDT

void
dobuiltin(char *cmd) {
     5f5:	55                   	push   %ebp
     5f6:	89 e5                	mov    %esp,%ebp
     5f8:	83 ec 18             	sub    $0x18,%esp
  int i;

  for (i=0; i<FDTcount; i++) 
     5fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     602:	eb 4f                	jmp    653 <dobuiltin+0x5e>
    if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0) 
     604:	8b 45 f4             	mov    -0xc(%ebp),%eax
     607:	8b 04 c5 60 1f 00 00 	mov    0x1f60(,%eax,8),%eax
     60e:	83 ec 0c             	sub    $0xc,%esp
     611:	50                   	push   %eax
     612:	e8 d9 0a 00 00       	call   10f0 <strlen>
     617:	83 c4 10             	add    $0x10,%esp
     61a:	89 c2                	mov    %eax,%edx
     61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     61f:	8b 04 c5 60 1f 00 00 	mov    0x1f60(,%eax,8),%eax
     626:	83 ec 04             	sub    $0x4,%esp
     629:	52                   	push   %edx
     62a:	50                   	push   %eax
     62b:	ff 75 08             	pushl  0x8(%ebp)
     62e:	e8 6d fc ff ff       	call   2a0 <strncmp>
     633:	83 c4 10             	add    $0x10,%esp
     636:	85 c0                	test   %eax,%eax
     638:	75 15                	jne    64f <dobuiltin+0x5a>
     (*fdt[i].name)(cmd);
     63a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     63d:	8b 04 c5 64 1f 00 00 	mov    0x1f64(,%eax,8),%eax
     644:	83 ec 0c             	sub    $0xc,%esp
     647:	ff 75 08             	pushl  0x8(%ebp)
     64a:	ff d0                	call   *%eax
     64c:	83 c4 10             	add    $0x10,%esp

void
dobuiltin(char *cmd) {
  int i;

  for (i=0; i<FDTcount; i++) 
     64f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     653:	a1 70 1f 00 00       	mov    0x1f70,%eax
     658:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     65b:	7c a7                	jl     604 <dobuiltin+0xf>
    if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0) 
     (*fdt[i].name)(cmd);
}
     65d:	90                   	nop
     65e:	c9                   	leave  
     65f:	c3                   	ret    

00000660 <main>:
// ***** processing for shell builtins ends here *****
#endif

int
main(void)
{
     660:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     664:	83 e4 f0             	and    $0xfffffff0,%esp
     667:	ff 71 fc             	pushl  -0x4(%ecx)
     66a:	55                   	push   %ebp
     66b:	89 e5                	mov    %esp,%ebp
     66d:	51                   	push   %ecx
     66e:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     671:	eb 16                	jmp    689 <main+0x29>
    if(fd >= 3){
     673:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     677:	7e 10                	jle    689 <main+0x29>
      close(fd);
     679:	83 ec 0c             	sub    $0xc,%esp
     67c:	ff 75 f4             	pushl  -0xc(%ebp)
     67f:	e8 e4 0c 00 00       	call   1368 <close>
     684:	83 c4 10             	add    $0x10,%esp
      break;
     687:	eb 1b                	jmp    6a4 <main+0x44>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     689:	83 ec 08             	sub    $0x8,%esp
     68c:	6a 02                	push   $0x2
     68e:	68 68 19 00 00       	push   $0x1968
     693:	e8 e8 0c 00 00       	call   1380 <open>
     698:	83 c4 10             	add    $0x10,%esp
     69b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     69e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6a2:	79 cf                	jns    673 <main+0x13>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     6a4:	e9 b1 00 00 00       	jmp    75a <main+0xfa>
// add support for built-ins here. cd is a built-in
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     6a9:	0f b6 05 a0 1f 00 00 	movzbl 0x1fa0,%eax
     6b0:	3c 63                	cmp    $0x63,%al
     6b2:	75 5f                	jne    713 <main+0xb3>
     6b4:	0f b6 05 a1 1f 00 00 	movzbl 0x1fa1,%eax
     6bb:	3c 64                	cmp    $0x64,%al
     6bd:	75 54                	jne    713 <main+0xb3>
     6bf:	0f b6 05 a2 1f 00 00 	movzbl 0x1fa2,%eax
     6c6:	3c 20                	cmp    $0x20,%al
     6c8:	75 49                	jne    713 <main+0xb3>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     6ca:	83 ec 0c             	sub    $0xc,%esp
     6cd:	68 a0 1f 00 00       	push   $0x1fa0
     6d2:	e8 19 0a 00 00       	call   10f0 <strlen>
     6d7:	83 c4 10             	add    $0x10,%esp
     6da:	83 e8 01             	sub    $0x1,%eax
     6dd:	c6 80 a0 1f 00 00 00 	movb   $0x0,0x1fa0(%eax)
      if(chdir(buf+3) < 0)
     6e4:	b8 a3 1f 00 00       	mov    $0x1fa3,%eax
     6e9:	83 ec 0c             	sub    $0xc,%esp
     6ec:	50                   	push   %eax
     6ed:	e8 be 0c 00 00       	call   13b0 <chdir>
     6f2:	83 c4 10             	add    $0x10,%esp
     6f5:	85 c0                	test   %eax,%eax
     6f7:	79 61                	jns    75a <main+0xfa>
        printf(2, "cannot cd %s\n", buf+3);
     6f9:	b8 a3 1f 00 00       	mov    $0x1fa3,%eax
     6fe:	83 ec 04             	sub    $0x4,%esp
     701:	50                   	push   %eax
     702:	68 70 19 00 00       	push   $0x1970
     707:	6a 02                	push   $0x2
     709:	e8 09 0e 00 00       	call   1517 <printf>
     70e:	83 c4 10             	add    $0x10,%esp
      continue;
     711:	eb 47                	jmp    75a <main+0xfa>
    }
#ifdef USE_BUILTINS
    if (buf[0]=='_') {     // assume it is a builtin command
     713:	0f b6 05 a0 1f 00 00 	movzbl 0x1fa0,%eax
     71a:	3c 5f                	cmp    $0x5f,%al
     71c:	75 12                	jne    730 <main+0xd0>
      dobuiltin(buf);
     71e:	83 ec 0c             	sub    $0xc,%esp
     721:	68 a0 1f 00 00       	push   $0x1fa0
     726:	e8 ca fe ff ff       	call   5f5 <dobuiltin>
     72b:	83 c4 10             	add    $0x10,%esp
      continue;
     72e:	eb 2a                	jmp    75a <main+0xfa>
    }
#endif
    if(fork1() == 0)
     730:	e8 64 00 00 00       	call   799 <fork1>
     735:	85 c0                	test   %eax,%eax
     737:	75 1c                	jne    755 <main+0xf5>
      runcmd(parsecmd(buf));
     739:	83 ec 0c             	sub    $0xc,%esp
     73c:	68 a0 1f 00 00       	push   $0x1fa0
     741:	e8 ab 03 00 00       	call   af1 <parsecmd>
     746:	83 c4 10             	add    $0x10,%esp
     749:	83 ec 0c             	sub    $0xc,%esp
     74c:	50                   	push   %eax
     74d:	e8 ae f8 ff ff       	call   0 <runcmd>
     752:	83 c4 10             	add    $0x10,%esp
    wait();
     755:	e8 ee 0b 00 00       	call   1348 <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     75a:	83 ec 08             	sub    $0x8,%esp
     75d:	6a 64                	push   $0x64
     75f:	68 a0 1f 00 00       	push   $0x1fa0
     764:	e8 e2 fa ff ff       	call   24b <getcmd>
     769:	83 c4 10             	add    $0x10,%esp
     76c:	85 c0                	test   %eax,%eax
     76e:	0f 89 35 ff ff ff    	jns    6a9 <main+0x49>
#endif
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     774:	e8 c7 0b 00 00       	call   1340 <exit>

00000779 <panic>:
}

void
panic(char *s)
{
     779:	55                   	push   %ebp
     77a:	89 e5                	mov    %esp,%ebp
     77c:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     77f:	83 ec 04             	sub    $0x4,%esp
     782:	ff 75 08             	pushl  0x8(%ebp)
     785:	68 7e 19 00 00       	push   $0x197e
     78a:	6a 02                	push   $0x2
     78c:	e8 86 0d 00 00       	call   1517 <printf>
     791:	83 c4 10             	add    $0x10,%esp
  exit();
     794:	e8 a7 0b 00 00       	call   1340 <exit>

00000799 <fork1>:
}

int
fork1(void)
{
     799:	55                   	push   %ebp
     79a:	89 e5                	mov    %esp,%ebp
     79c:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  pid = fork();
     79f:	e8 94 0b 00 00       	call   1338 <fork>
     7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     7a7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     7ab:	75 10                	jne    7bd <fork1+0x24>
    panic("fork");
     7ad:	83 ec 0c             	sub    $0xc,%esp
     7b0:	68 82 19 00 00       	push   $0x1982
     7b5:	e8 bf ff ff ff       	call   779 <panic>
     7ba:	83 c4 10             	add    $0x10,%esp
  return pid;
     7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7c0:	c9                   	leave  
     7c1:	c3                   	ret    

000007c2 <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     7c2:	55                   	push   %ebp
     7c3:	89 e5                	mov    %esp,%ebp
     7c5:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7c8:	83 ec 0c             	sub    $0xc,%esp
     7cb:	6a 54                	push   $0x54
     7cd:	e8 18 10 00 00       	call   17ea <malloc>
     7d2:	83 c4 10             	add    $0x10,%esp
     7d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7d8:	83 ec 04             	sub    $0x4,%esp
     7db:	6a 54                	push   $0x54
     7dd:	6a 00                	push   $0x0
     7df:	ff 75 f4             	pushl  -0xc(%ebp)
     7e2:	e8 30 09 00 00       	call   1117 <memset>
     7e7:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7f6:	c9                   	leave  
     7f7:	c3                   	ret    

000007f8 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     7f8:	55                   	push   %ebp
     7f9:	89 e5                	mov    %esp,%ebp
     7fb:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7fe:	83 ec 0c             	sub    $0xc,%esp
     801:	6a 18                	push   $0x18
     803:	e8 e2 0f 00 00       	call   17ea <malloc>
     808:	83 c4 10             	add    $0x10,%esp
     80b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     80e:	83 ec 04             	sub    $0x4,%esp
     811:	6a 18                	push   $0x18
     813:	6a 00                	push   $0x0
     815:	ff 75 f4             	pushl  -0xc(%ebp)
     818:	e8 fa 08 00 00       	call   1117 <memset>
     81d:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     820:	8b 45 f4             	mov    -0xc(%ebp),%eax
     823:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     829:	8b 45 f4             	mov    -0xc(%ebp),%eax
     82c:	8b 55 08             	mov    0x8(%ebp),%edx
     82f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     832:	8b 45 f4             	mov    -0xc(%ebp),%eax
     835:	8b 55 0c             	mov    0xc(%ebp),%edx
     838:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83e:	8b 55 10             	mov    0x10(%ebp),%edx
     841:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     844:	8b 45 f4             	mov    -0xc(%ebp),%eax
     847:	8b 55 14             	mov    0x14(%ebp),%edx
     84a:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     850:	8b 55 18             	mov    0x18(%ebp),%edx
     853:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     856:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     859:	c9                   	leave  
     85a:	c3                   	ret    

0000085b <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     85b:	55                   	push   %ebp
     85c:	89 e5                	mov    %esp,%ebp
     85e:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     861:	83 ec 0c             	sub    $0xc,%esp
     864:	6a 0c                	push   $0xc
     866:	e8 7f 0f 00 00       	call   17ea <malloc>
     86b:	83 c4 10             	add    $0x10,%esp
     86e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     871:	83 ec 04             	sub    $0x4,%esp
     874:	6a 0c                	push   $0xc
     876:	6a 00                	push   $0x0
     878:	ff 75 f4             	pushl  -0xc(%ebp)
     87b:	e8 97 08 00 00       	call   1117 <memset>
     880:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     883:	8b 45 f4             	mov    -0xc(%ebp),%eax
     886:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     88f:	8b 55 08             	mov    0x8(%ebp),%edx
     892:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     895:	8b 45 f4             	mov    -0xc(%ebp),%eax
     898:	8b 55 0c             	mov    0xc(%ebp),%edx
     89b:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     89e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8a1:	c9                   	leave  
     8a2:	c3                   	ret    

000008a3 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     8a3:	55                   	push   %ebp
     8a4:	89 e5                	mov    %esp,%ebp
     8a6:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     8a9:	83 ec 0c             	sub    $0xc,%esp
     8ac:	6a 0c                	push   $0xc
     8ae:	e8 37 0f 00 00       	call   17ea <malloc>
     8b3:	83 c4 10             	add    $0x10,%esp
     8b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     8b9:	83 ec 04             	sub    $0x4,%esp
     8bc:	6a 0c                	push   $0xc
     8be:	6a 00                	push   $0x0
     8c0:	ff 75 f4             	pushl  -0xc(%ebp)
     8c3:	e8 4f 08 00 00       	call   1117 <memset>
     8c8:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     8cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ce:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8d7:	8b 55 08             	mov    0x8(%ebp),%edx
     8da:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8e0:	8b 55 0c             	mov    0xc(%ebp),%edx
     8e3:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8e9:	c9                   	leave  
     8ea:	c3                   	ret    

000008eb <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     8eb:	55                   	push   %ebp
     8ec:	89 e5                	mov    %esp,%ebp
     8ee:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     8f1:	83 ec 0c             	sub    $0xc,%esp
     8f4:	6a 08                	push   $0x8
     8f6:	e8 ef 0e 00 00       	call   17ea <malloc>
     8fb:	83 c4 10             	add    $0x10,%esp
     8fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     901:	83 ec 04             	sub    $0x4,%esp
     904:	6a 08                	push   $0x8
     906:	6a 00                	push   $0x0
     908:	ff 75 f4             	pushl  -0xc(%ebp)
     90b:	e8 07 08 00 00       	call   1117 <memset>
     910:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     913:	8b 45 f4             	mov    -0xc(%ebp),%eax
     916:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     91c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     91f:	8b 55 08             	mov    0x8(%ebp),%edx
     922:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     925:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     928:	c9                   	leave  
     929:	c3                   	ret    

0000092a <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     92a:	55                   	push   %ebp
     92b:	89 e5                	mov    %esp,%ebp
     92d:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;
  
  s = *ps;
     930:	8b 45 08             	mov    0x8(%ebp),%eax
     933:	8b 00                	mov    (%eax),%eax
     935:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     938:	eb 04                	jmp    93e <gettoken+0x14>
    s++;
     93a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     941:	3b 45 0c             	cmp    0xc(%ebp),%eax
     944:	73 1e                	jae    964 <gettoken+0x3a>
     946:	8b 45 f4             	mov    -0xc(%ebp),%eax
     949:	0f b6 00             	movzbl (%eax),%eax
     94c:	0f be c0             	movsbl %al,%eax
     94f:	83 ec 08             	sub    $0x8,%esp
     952:	50                   	push   %eax
     953:	68 74 1f 00 00       	push   $0x1f74
     958:	e8 d4 07 00 00       	call   1131 <strchr>
     95d:	83 c4 10             	add    $0x10,%esp
     960:	85 c0                	test   %eax,%eax
     962:	75 d6                	jne    93a <gettoken+0x10>
    s++;
  if(q)
     964:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     968:	74 08                	je     972 <gettoken+0x48>
    *q = s;
     96a:	8b 45 10             	mov    0x10(%ebp),%eax
     96d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     970:	89 10                	mov    %edx,(%eax)
  ret = *s;
     972:	8b 45 f4             	mov    -0xc(%ebp),%eax
     975:	0f b6 00             	movzbl (%eax),%eax
     978:	0f be c0             	movsbl %al,%eax
     97b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     981:	0f b6 00             	movzbl (%eax),%eax
     984:	0f be c0             	movsbl %al,%eax
     987:	83 f8 29             	cmp    $0x29,%eax
     98a:	7f 14                	jg     9a0 <gettoken+0x76>
     98c:	83 f8 28             	cmp    $0x28,%eax
     98f:	7d 28                	jge    9b9 <gettoken+0x8f>
     991:	85 c0                	test   %eax,%eax
     993:	0f 84 94 00 00 00    	je     a2d <gettoken+0x103>
     999:	83 f8 26             	cmp    $0x26,%eax
     99c:	74 1b                	je     9b9 <gettoken+0x8f>
     99e:	eb 3a                	jmp    9da <gettoken+0xb0>
     9a0:	83 f8 3e             	cmp    $0x3e,%eax
     9a3:	74 1a                	je     9bf <gettoken+0x95>
     9a5:	83 f8 3e             	cmp    $0x3e,%eax
     9a8:	7f 0a                	jg     9b4 <gettoken+0x8a>
     9aa:	83 e8 3b             	sub    $0x3b,%eax
     9ad:	83 f8 01             	cmp    $0x1,%eax
     9b0:	77 28                	ja     9da <gettoken+0xb0>
     9b2:	eb 05                	jmp    9b9 <gettoken+0x8f>
     9b4:	83 f8 7c             	cmp    $0x7c,%eax
     9b7:	75 21                	jne    9da <gettoken+0xb0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     9b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     9bd:	eb 75                	jmp    a34 <gettoken+0x10a>
  case '>':
    s++;
     9bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c6:	0f b6 00             	movzbl (%eax),%eax
     9c9:	3c 3e                	cmp    $0x3e,%al
     9cb:	75 63                	jne    a30 <gettoken+0x106>
      ret = '+';
     9cd:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     9d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     9d8:	eb 56                	jmp    a30 <gettoken+0x106>
  default:
    ret = 'a';
     9da:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     9e1:	eb 04                	jmp    9e7 <gettoken+0xbd>
      s++;
     9e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     9e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
     9ed:	73 44                	jae    a33 <gettoken+0x109>
     9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9f2:	0f b6 00             	movzbl (%eax),%eax
     9f5:	0f be c0             	movsbl %al,%eax
     9f8:	83 ec 08             	sub    $0x8,%esp
     9fb:	50                   	push   %eax
     9fc:	68 74 1f 00 00       	push   $0x1f74
     a01:	e8 2b 07 00 00       	call   1131 <strchr>
     a06:	83 c4 10             	add    $0x10,%esp
     a09:	85 c0                	test   %eax,%eax
     a0b:	75 26                	jne    a33 <gettoken+0x109>
     a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a10:	0f b6 00             	movzbl (%eax),%eax
     a13:	0f be c0             	movsbl %al,%eax
     a16:	83 ec 08             	sub    $0x8,%esp
     a19:	50                   	push   %eax
     a1a:	68 7c 1f 00 00       	push   $0x1f7c
     a1f:	e8 0d 07 00 00       	call   1131 <strchr>
     a24:	83 c4 10             	add    $0x10,%esp
     a27:	85 c0                	test   %eax,%eax
     a29:	74 b8                	je     9e3 <gettoken+0xb9>
      s++;
    break;
     a2b:	eb 06                	jmp    a33 <gettoken+0x109>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     a2d:	90                   	nop
     a2e:	eb 04                	jmp    a34 <gettoken+0x10a>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     a30:	90                   	nop
     a31:	eb 01                	jmp    a34 <gettoken+0x10a>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     a33:	90                   	nop
  }
  if(eq)
     a34:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     a38:	74 0e                	je     a48 <gettoken+0x11e>
    *eq = s;
     a3a:	8b 45 14             	mov    0x14(%ebp),%eax
     a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a40:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     a42:	eb 04                	jmp    a48 <gettoken+0x11e>
    s++;
     a44:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
     a4e:	73 1e                	jae    a6e <gettoken+0x144>
     a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a53:	0f b6 00             	movzbl (%eax),%eax
     a56:	0f be c0             	movsbl %al,%eax
     a59:	83 ec 08             	sub    $0x8,%esp
     a5c:	50                   	push   %eax
     a5d:	68 74 1f 00 00       	push   $0x1f74
     a62:	e8 ca 06 00 00       	call   1131 <strchr>
     a67:	83 c4 10             	add    $0x10,%esp
     a6a:	85 c0                	test   %eax,%eax
     a6c:	75 d6                	jne    a44 <gettoken+0x11a>
    s++;
  *ps = s;
     a6e:	8b 45 08             	mov    0x8(%ebp),%eax
     a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a74:	89 10                	mov    %edx,(%eax)
  return ret;
     a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     a79:	c9                   	leave  
     a7a:	c3                   	ret    

00000a7b <peek>:

int
peek(char **ps, char *es, char *toks)
{
     a7b:	55                   	push   %ebp
     a7c:	89 e5                	mov    %esp,%ebp
     a7e:	83 ec 18             	sub    $0x18,%esp
  char *s;
  
  s = *ps;
     a81:	8b 45 08             	mov    0x8(%ebp),%eax
     a84:	8b 00                	mov    (%eax),%eax
     a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     a89:	eb 04                	jmp    a8f <peek+0x14>
    s++;
     a8b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a92:	3b 45 0c             	cmp    0xc(%ebp),%eax
     a95:	73 1e                	jae    ab5 <peek+0x3a>
     a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a9a:	0f b6 00             	movzbl (%eax),%eax
     a9d:	0f be c0             	movsbl %al,%eax
     aa0:	83 ec 08             	sub    $0x8,%esp
     aa3:	50                   	push   %eax
     aa4:	68 74 1f 00 00       	push   $0x1f74
     aa9:	e8 83 06 00 00       	call   1131 <strchr>
     aae:	83 c4 10             	add    $0x10,%esp
     ab1:	85 c0                	test   %eax,%eax
     ab3:	75 d6                	jne    a8b <peek+0x10>
    s++;
  *ps = s;
     ab5:	8b 45 08             	mov    0x8(%ebp),%eax
     ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     abb:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac0:	0f b6 00             	movzbl (%eax),%eax
     ac3:	84 c0                	test   %al,%al
     ac5:	74 23                	je     aea <peek+0x6f>
     ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aca:	0f b6 00             	movzbl (%eax),%eax
     acd:	0f be c0             	movsbl %al,%eax
     ad0:	83 ec 08             	sub    $0x8,%esp
     ad3:	50                   	push   %eax
     ad4:	ff 75 10             	pushl  0x10(%ebp)
     ad7:	e8 55 06 00 00       	call   1131 <strchr>
     adc:	83 c4 10             	add    $0x10,%esp
     adf:	85 c0                	test   %eax,%eax
     ae1:	74 07                	je     aea <peek+0x6f>
     ae3:	b8 01 00 00 00       	mov    $0x1,%eax
     ae8:	eb 05                	jmp    aef <peek+0x74>
     aea:	b8 00 00 00 00       	mov    $0x0,%eax
}
     aef:	c9                   	leave  
     af0:	c3                   	ret    

00000af1 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     af1:	55                   	push   %ebp
     af2:	89 e5                	mov    %esp,%ebp
     af4:	53                   	push   %ebx
     af5:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     af8:	8b 5d 08             	mov    0x8(%ebp),%ebx
     afb:	8b 45 08             	mov    0x8(%ebp),%eax
     afe:	83 ec 0c             	sub    $0xc,%esp
     b01:	50                   	push   %eax
     b02:	e8 e9 05 00 00       	call   10f0 <strlen>
     b07:	83 c4 10             	add    $0x10,%esp
     b0a:	01 d8                	add    %ebx,%eax
     b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     b0f:	83 ec 08             	sub    $0x8,%esp
     b12:	ff 75 f4             	pushl  -0xc(%ebp)
     b15:	8d 45 08             	lea    0x8(%ebp),%eax
     b18:	50                   	push   %eax
     b19:	e8 61 00 00 00       	call   b7f <parseline>
     b1e:	83 c4 10             	add    $0x10,%esp
     b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     b24:	83 ec 04             	sub    $0x4,%esp
     b27:	68 87 19 00 00       	push   $0x1987
     b2c:	ff 75 f4             	pushl  -0xc(%ebp)
     b2f:	8d 45 08             	lea    0x8(%ebp),%eax
     b32:	50                   	push   %eax
     b33:	e8 43 ff ff ff       	call   a7b <peek>
     b38:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     b3b:	8b 45 08             	mov    0x8(%ebp),%eax
     b3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     b41:	74 26                	je     b69 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     b43:	8b 45 08             	mov    0x8(%ebp),%eax
     b46:	83 ec 04             	sub    $0x4,%esp
     b49:	50                   	push   %eax
     b4a:	68 88 19 00 00       	push   $0x1988
     b4f:	6a 02                	push   $0x2
     b51:	e8 c1 09 00 00       	call   1517 <printf>
     b56:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     b59:	83 ec 0c             	sub    $0xc,%esp
     b5c:	68 97 19 00 00       	push   $0x1997
     b61:	e8 13 fc ff ff       	call   779 <panic>
     b66:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     b69:	83 ec 0c             	sub    $0xc,%esp
     b6c:	ff 75 f0             	pushl  -0x10(%ebp)
     b6f:	e8 eb 03 00 00       	call   f5f <nulterminate>
     b74:	83 c4 10             	add    $0x10,%esp
  return cmd;
     b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b7d:	c9                   	leave  
     b7e:	c3                   	ret    

00000b7f <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     b7f:	55                   	push   %ebp
     b80:	89 e5                	mov    %esp,%ebp
     b82:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     b85:	83 ec 08             	sub    $0x8,%esp
     b88:	ff 75 0c             	pushl  0xc(%ebp)
     b8b:	ff 75 08             	pushl  0x8(%ebp)
     b8e:	e8 99 00 00 00       	call   c2c <parsepipe>
     b93:	83 c4 10             	add    $0x10,%esp
     b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     b99:	eb 23                	jmp    bbe <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     b9b:	6a 00                	push   $0x0
     b9d:	6a 00                	push   $0x0
     b9f:	ff 75 0c             	pushl  0xc(%ebp)
     ba2:	ff 75 08             	pushl  0x8(%ebp)
     ba5:	e8 80 fd ff ff       	call   92a <gettoken>
     baa:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     bad:	83 ec 0c             	sub    $0xc,%esp
     bb0:	ff 75 f4             	pushl  -0xc(%ebp)
     bb3:	e8 33 fd ff ff       	call   8eb <backcmd>
     bb8:	83 c4 10             	add    $0x10,%esp
     bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     bbe:	83 ec 04             	sub    $0x4,%esp
     bc1:	68 9e 19 00 00       	push   $0x199e
     bc6:	ff 75 0c             	pushl  0xc(%ebp)
     bc9:	ff 75 08             	pushl  0x8(%ebp)
     bcc:	e8 aa fe ff ff       	call   a7b <peek>
     bd1:	83 c4 10             	add    $0x10,%esp
     bd4:	85 c0                	test   %eax,%eax
     bd6:	75 c3                	jne    b9b <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     bd8:	83 ec 04             	sub    $0x4,%esp
     bdb:	68 a0 19 00 00       	push   $0x19a0
     be0:	ff 75 0c             	pushl  0xc(%ebp)
     be3:	ff 75 08             	pushl  0x8(%ebp)
     be6:	e8 90 fe ff ff       	call   a7b <peek>
     beb:	83 c4 10             	add    $0x10,%esp
     bee:	85 c0                	test   %eax,%eax
     bf0:	74 35                	je     c27 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     bf2:	6a 00                	push   $0x0
     bf4:	6a 00                	push   $0x0
     bf6:	ff 75 0c             	pushl  0xc(%ebp)
     bf9:	ff 75 08             	pushl  0x8(%ebp)
     bfc:	e8 29 fd ff ff       	call   92a <gettoken>
     c01:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     c04:	83 ec 08             	sub    $0x8,%esp
     c07:	ff 75 0c             	pushl  0xc(%ebp)
     c0a:	ff 75 08             	pushl  0x8(%ebp)
     c0d:	e8 6d ff ff ff       	call   b7f <parseline>
     c12:	83 c4 10             	add    $0x10,%esp
     c15:	83 ec 08             	sub    $0x8,%esp
     c18:	50                   	push   %eax
     c19:	ff 75 f4             	pushl  -0xc(%ebp)
     c1c:	e8 82 fc ff ff       	call   8a3 <listcmd>
     c21:	83 c4 10             	add    $0x10,%esp
     c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     c2a:	c9                   	leave  
     c2b:	c3                   	ret    

00000c2c <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     c2c:	55                   	push   %ebp
     c2d:	89 e5                	mov    %esp,%ebp
     c2f:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     c32:	83 ec 08             	sub    $0x8,%esp
     c35:	ff 75 0c             	pushl  0xc(%ebp)
     c38:	ff 75 08             	pushl  0x8(%ebp)
     c3b:	e8 ec 01 00 00       	call   e2c <parseexec>
     c40:	83 c4 10             	add    $0x10,%esp
     c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     c46:	83 ec 04             	sub    $0x4,%esp
     c49:	68 a2 19 00 00       	push   $0x19a2
     c4e:	ff 75 0c             	pushl  0xc(%ebp)
     c51:	ff 75 08             	pushl  0x8(%ebp)
     c54:	e8 22 fe ff ff       	call   a7b <peek>
     c59:	83 c4 10             	add    $0x10,%esp
     c5c:	85 c0                	test   %eax,%eax
     c5e:	74 35                	je     c95 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     c60:	6a 00                	push   $0x0
     c62:	6a 00                	push   $0x0
     c64:	ff 75 0c             	pushl  0xc(%ebp)
     c67:	ff 75 08             	pushl  0x8(%ebp)
     c6a:	e8 bb fc ff ff       	call   92a <gettoken>
     c6f:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     c72:	83 ec 08             	sub    $0x8,%esp
     c75:	ff 75 0c             	pushl  0xc(%ebp)
     c78:	ff 75 08             	pushl  0x8(%ebp)
     c7b:	e8 ac ff ff ff       	call   c2c <parsepipe>
     c80:	83 c4 10             	add    $0x10,%esp
     c83:	83 ec 08             	sub    $0x8,%esp
     c86:	50                   	push   %eax
     c87:	ff 75 f4             	pushl  -0xc(%ebp)
     c8a:	e8 cc fb ff ff       	call   85b <pipecmd>
     c8f:	83 c4 10             	add    $0x10,%esp
     c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     c98:	c9                   	leave  
     c99:	c3                   	ret    

00000c9a <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     c9a:	55                   	push   %ebp
     c9b:	89 e5                	mov    %esp,%ebp
     c9d:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     ca0:	e9 b6 00 00 00       	jmp    d5b <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     ca5:	6a 00                	push   $0x0
     ca7:	6a 00                	push   $0x0
     ca9:	ff 75 10             	pushl  0x10(%ebp)
     cac:	ff 75 0c             	pushl  0xc(%ebp)
     caf:	e8 76 fc ff ff       	call   92a <gettoken>
     cb4:	83 c4 10             	add    $0x10,%esp
     cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     cba:	8d 45 ec             	lea    -0x14(%ebp),%eax
     cbd:	50                   	push   %eax
     cbe:	8d 45 f0             	lea    -0x10(%ebp),%eax
     cc1:	50                   	push   %eax
     cc2:	ff 75 10             	pushl  0x10(%ebp)
     cc5:	ff 75 0c             	pushl  0xc(%ebp)
     cc8:	e8 5d fc ff ff       	call   92a <gettoken>
     ccd:	83 c4 10             	add    $0x10,%esp
     cd0:	83 f8 61             	cmp    $0x61,%eax
     cd3:	74 10                	je     ce5 <parseredirs+0x4b>
      panic("missing file for redirection");
     cd5:	83 ec 0c             	sub    $0xc,%esp
     cd8:	68 a4 19 00 00       	push   $0x19a4
     cdd:	e8 97 fa ff ff       	call   779 <panic>
     ce2:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ce8:	83 f8 3c             	cmp    $0x3c,%eax
     ceb:	74 0c                	je     cf9 <parseredirs+0x5f>
     ced:	83 f8 3e             	cmp    $0x3e,%eax
     cf0:	74 26                	je     d18 <parseredirs+0x7e>
     cf2:	83 f8 2b             	cmp    $0x2b,%eax
     cf5:	74 43                	je     d3a <parseredirs+0xa0>
     cf7:	eb 62                	jmp    d5b <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     cf9:	8b 55 ec             	mov    -0x14(%ebp),%edx
     cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cff:	83 ec 0c             	sub    $0xc,%esp
     d02:	6a 00                	push   $0x0
     d04:	6a 00                	push   $0x0
     d06:	52                   	push   %edx
     d07:	50                   	push   %eax
     d08:	ff 75 08             	pushl  0x8(%ebp)
     d0b:	e8 e8 fa ff ff       	call   7f8 <redircmd>
     d10:	83 c4 20             	add    $0x20,%esp
     d13:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     d16:	eb 43                	jmp    d5b <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     d18:	8b 55 ec             	mov    -0x14(%ebp),%edx
     d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d1e:	83 ec 0c             	sub    $0xc,%esp
     d21:	6a 01                	push   $0x1
     d23:	68 01 02 00 00       	push   $0x201
     d28:	52                   	push   %edx
     d29:	50                   	push   %eax
     d2a:	ff 75 08             	pushl  0x8(%ebp)
     d2d:	e8 c6 fa ff ff       	call   7f8 <redircmd>
     d32:	83 c4 20             	add    $0x20,%esp
     d35:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     d38:	eb 21                	jmp    d5b <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     d3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
     d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d40:	83 ec 0c             	sub    $0xc,%esp
     d43:	6a 01                	push   $0x1
     d45:	68 01 02 00 00       	push   $0x201
     d4a:	52                   	push   %edx
     d4b:	50                   	push   %eax
     d4c:	ff 75 08             	pushl  0x8(%ebp)
     d4f:	e8 a4 fa ff ff       	call   7f8 <redircmd>
     d54:	83 c4 20             	add    $0x20,%esp
     d57:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     d5a:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     d5b:	83 ec 04             	sub    $0x4,%esp
     d5e:	68 c1 19 00 00       	push   $0x19c1
     d63:	ff 75 10             	pushl  0x10(%ebp)
     d66:	ff 75 0c             	pushl  0xc(%ebp)
     d69:	e8 0d fd ff ff       	call   a7b <peek>
     d6e:	83 c4 10             	add    $0x10,%esp
     d71:	85 c0                	test   %eax,%eax
     d73:	0f 85 2c ff ff ff    	jne    ca5 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     d79:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d7c:	c9                   	leave  
     d7d:	c3                   	ret    

00000d7e <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     d7e:	55                   	push   %ebp
     d7f:	89 e5                	mov    %esp,%ebp
     d81:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     d84:	83 ec 04             	sub    $0x4,%esp
     d87:	68 c4 19 00 00       	push   $0x19c4
     d8c:	ff 75 0c             	pushl  0xc(%ebp)
     d8f:	ff 75 08             	pushl  0x8(%ebp)
     d92:	e8 e4 fc ff ff       	call   a7b <peek>
     d97:	83 c4 10             	add    $0x10,%esp
     d9a:	85 c0                	test   %eax,%eax
     d9c:	75 10                	jne    dae <parseblock+0x30>
    panic("parseblock");
     d9e:	83 ec 0c             	sub    $0xc,%esp
     da1:	68 c6 19 00 00       	push   $0x19c6
     da6:	e8 ce f9 ff ff       	call   779 <panic>
     dab:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     dae:	6a 00                	push   $0x0
     db0:	6a 00                	push   $0x0
     db2:	ff 75 0c             	pushl  0xc(%ebp)
     db5:	ff 75 08             	pushl  0x8(%ebp)
     db8:	e8 6d fb ff ff       	call   92a <gettoken>
     dbd:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     dc0:	83 ec 08             	sub    $0x8,%esp
     dc3:	ff 75 0c             	pushl  0xc(%ebp)
     dc6:	ff 75 08             	pushl  0x8(%ebp)
     dc9:	e8 b1 fd ff ff       	call   b7f <parseline>
     dce:	83 c4 10             	add    $0x10,%esp
     dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     dd4:	83 ec 04             	sub    $0x4,%esp
     dd7:	68 d1 19 00 00       	push   $0x19d1
     ddc:	ff 75 0c             	pushl  0xc(%ebp)
     ddf:	ff 75 08             	pushl  0x8(%ebp)
     de2:	e8 94 fc ff ff       	call   a7b <peek>
     de7:	83 c4 10             	add    $0x10,%esp
     dea:	85 c0                	test   %eax,%eax
     dec:	75 10                	jne    dfe <parseblock+0x80>
    panic("syntax - missing )");
     dee:	83 ec 0c             	sub    $0xc,%esp
     df1:	68 d3 19 00 00       	push   $0x19d3
     df6:	e8 7e f9 ff ff       	call   779 <panic>
     dfb:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     dfe:	6a 00                	push   $0x0
     e00:	6a 00                	push   $0x0
     e02:	ff 75 0c             	pushl  0xc(%ebp)
     e05:	ff 75 08             	pushl  0x8(%ebp)
     e08:	e8 1d fb ff ff       	call   92a <gettoken>
     e0d:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     e10:	83 ec 04             	sub    $0x4,%esp
     e13:	ff 75 0c             	pushl  0xc(%ebp)
     e16:	ff 75 08             	pushl  0x8(%ebp)
     e19:	ff 75 f4             	pushl  -0xc(%ebp)
     e1c:	e8 79 fe ff ff       	call   c9a <parseredirs>
     e21:	83 c4 10             	add    $0x10,%esp
     e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     e2a:	c9                   	leave  
     e2b:	c3                   	ret    

00000e2c <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     e2c:	55                   	push   %ebp
     e2d:	89 e5                	mov    %esp,%ebp
     e2f:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     e32:	83 ec 04             	sub    $0x4,%esp
     e35:	68 c4 19 00 00       	push   $0x19c4
     e3a:	ff 75 0c             	pushl  0xc(%ebp)
     e3d:	ff 75 08             	pushl  0x8(%ebp)
     e40:	e8 36 fc ff ff       	call   a7b <peek>
     e45:	83 c4 10             	add    $0x10,%esp
     e48:	85 c0                	test   %eax,%eax
     e4a:	74 16                	je     e62 <parseexec+0x36>
    return parseblock(ps, es);
     e4c:	83 ec 08             	sub    $0x8,%esp
     e4f:	ff 75 0c             	pushl  0xc(%ebp)
     e52:	ff 75 08             	pushl  0x8(%ebp)
     e55:	e8 24 ff ff ff       	call   d7e <parseblock>
     e5a:	83 c4 10             	add    $0x10,%esp
     e5d:	e9 fb 00 00 00       	jmp    f5d <parseexec+0x131>

  ret = execcmd();
     e62:	e8 5b f9 ff ff       	call   7c2 <execcmd>
     e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e6d:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     e70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     e77:	83 ec 04             	sub    $0x4,%esp
     e7a:	ff 75 0c             	pushl  0xc(%ebp)
     e7d:	ff 75 08             	pushl  0x8(%ebp)
     e80:	ff 75 f0             	pushl  -0x10(%ebp)
     e83:	e8 12 fe ff ff       	call   c9a <parseredirs>
     e88:	83 c4 10             	add    $0x10,%esp
     e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     e8e:	e9 87 00 00 00       	jmp    f1a <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     e93:	8d 45 e0             	lea    -0x20(%ebp),%eax
     e96:	50                   	push   %eax
     e97:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     e9a:	50                   	push   %eax
     e9b:	ff 75 0c             	pushl  0xc(%ebp)
     e9e:	ff 75 08             	pushl  0x8(%ebp)
     ea1:	e8 84 fa ff ff       	call   92a <gettoken>
     ea6:	83 c4 10             	add    $0x10,%esp
     ea9:	89 45 e8             	mov    %eax,-0x18(%ebp)
     eac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     eb0:	0f 84 84 00 00 00    	je     f3a <parseexec+0x10e>
      break;
    if(tok != 'a')
     eb6:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     eba:	74 10                	je     ecc <parseexec+0xa0>
      panic("syntax");
     ebc:	83 ec 0c             	sub    $0xc,%esp
     ebf:	68 97 19 00 00       	push   $0x1997
     ec4:	e8 b0 f8 ff ff       	call   779 <panic>
     ec9:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     ecc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ed5:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     ed9:	8b 55 e0             	mov    -0x20(%ebp),%edx
     edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     edf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     ee2:	83 c1 08             	add    $0x8,%ecx
     ee5:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     ee9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     eed:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ef1:	7e 10                	jle    f03 <parseexec+0xd7>
      panic("too many args");
     ef3:	83 ec 0c             	sub    $0xc,%esp
     ef6:	68 e6 19 00 00       	push   $0x19e6
     efb:	e8 79 f8 ff ff       	call   779 <panic>
     f00:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     f03:	83 ec 04             	sub    $0x4,%esp
     f06:	ff 75 0c             	pushl  0xc(%ebp)
     f09:	ff 75 08             	pushl  0x8(%ebp)
     f0c:	ff 75 f0             	pushl  -0x10(%ebp)
     f0f:	e8 86 fd ff ff       	call   c9a <parseredirs>
     f14:	83 c4 10             	add    $0x10,%esp
     f17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     f1a:	83 ec 04             	sub    $0x4,%esp
     f1d:	68 f4 19 00 00       	push   $0x19f4
     f22:	ff 75 0c             	pushl  0xc(%ebp)
     f25:	ff 75 08             	pushl  0x8(%ebp)
     f28:	e8 4e fb ff ff       	call   a7b <peek>
     f2d:	83 c4 10             	add    $0x10,%esp
     f30:	85 c0                	test   %eax,%eax
     f32:	0f 84 5b ff ff ff    	je     e93 <parseexec+0x67>
     f38:	eb 01                	jmp    f3b <parseexec+0x10f>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     f3a:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f41:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     f48:	00 
  cmd->eargv[argc] = 0;
     f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f4f:	83 c2 08             	add    $0x8,%edx
     f52:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     f59:	00 
  return ret;
     f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f5d:	c9                   	leave  
     f5e:	c3                   	ret    

00000f5f <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     f5f:	55                   	push   %ebp
     f60:	89 e5                	mov    %esp,%ebp
     f62:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     f65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f69:	75 0a                	jne    f75 <nulterminate+0x16>
    return 0;
     f6b:	b8 00 00 00 00       	mov    $0x0,%eax
     f70:	e9 e4 00 00 00       	jmp    1059 <nulterminate+0xfa>
  
  switch(cmd->type){
     f75:	8b 45 08             	mov    0x8(%ebp),%eax
     f78:	8b 00                	mov    (%eax),%eax
     f7a:	83 f8 05             	cmp    $0x5,%eax
     f7d:	0f 87 d3 00 00 00    	ja     1056 <nulterminate+0xf7>
     f83:	8b 04 85 fc 19 00 00 	mov    0x19fc(,%eax,4),%eax
     f8a:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     f8c:	8b 45 08             	mov    0x8(%ebp),%eax
     f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     f92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f99:	eb 14                	jmp    faf <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     fa1:	83 c2 08             	add    $0x8,%edx
     fa4:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     fa8:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     fab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     fb5:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     fb9:	85 c0                	test   %eax,%eax
     fbb:	75 de                	jne    f9b <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     fbd:	e9 94 00 00 00       	jmp    1056 <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     fc2:	8b 45 08             	mov    0x8(%ebp),%eax
     fc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fcb:	8b 40 04             	mov    0x4(%eax),%eax
     fce:	83 ec 0c             	sub    $0xc,%esp
     fd1:	50                   	push   %eax
     fd2:	e8 88 ff ff ff       	call   f5f <nulterminate>
     fd7:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fdd:	8b 40 0c             	mov    0xc(%eax),%eax
     fe0:	c6 00 00             	movb   $0x0,(%eax)
    break;
     fe3:	eb 71                	jmp    1056 <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     fe5:	8b 45 08             	mov    0x8(%ebp),%eax
     fe8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fee:	8b 40 04             	mov    0x4(%eax),%eax
     ff1:	83 ec 0c             	sub    $0xc,%esp
     ff4:	50                   	push   %eax
     ff5:	e8 65 ff ff ff       	call   f5f <nulterminate>
     ffa:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     ffd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1000:	8b 40 08             	mov    0x8(%eax),%eax
    1003:	83 ec 0c             	sub    $0xc,%esp
    1006:	50                   	push   %eax
    1007:	e8 53 ff ff ff       	call   f5f <nulterminate>
    100c:	83 c4 10             	add    $0x10,%esp
    break;
    100f:	eb 45                	jmp    1056 <nulterminate+0xf7>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    1011:	8b 45 08             	mov    0x8(%ebp),%eax
    1014:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
    1017:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    101a:	8b 40 04             	mov    0x4(%eax),%eax
    101d:	83 ec 0c             	sub    $0xc,%esp
    1020:	50                   	push   %eax
    1021:	e8 39 ff ff ff       	call   f5f <nulterminate>
    1026:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
    1029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    102c:	8b 40 08             	mov    0x8(%eax),%eax
    102f:	83 ec 0c             	sub    $0xc,%esp
    1032:	50                   	push   %eax
    1033:	e8 27 ff ff ff       	call   f5f <nulterminate>
    1038:	83 c4 10             	add    $0x10,%esp
    break;
    103b:	eb 19                	jmp    1056 <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    103d:	8b 45 08             	mov    0x8(%ebp),%eax
    1040:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
    1043:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1046:	8b 40 04             	mov    0x4(%eax),%eax
    1049:	83 ec 0c             	sub    $0xc,%esp
    104c:	50                   	push   %eax
    104d:	e8 0d ff ff ff       	call   f5f <nulterminate>
    1052:	83 c4 10             	add    $0x10,%esp
    break;
    1055:	90                   	nop
  }
  return cmd;
    1056:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1059:	c9                   	leave  
    105a:	c3                   	ret    

0000105b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    105b:	55                   	push   %ebp
    105c:	89 e5                	mov    %esp,%ebp
    105e:	57                   	push   %edi
    105f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1060:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1063:	8b 55 10             	mov    0x10(%ebp),%edx
    1066:	8b 45 0c             	mov    0xc(%ebp),%eax
    1069:	89 cb                	mov    %ecx,%ebx
    106b:	89 df                	mov    %ebx,%edi
    106d:	89 d1                	mov    %edx,%ecx
    106f:	fc                   	cld    
    1070:	f3 aa                	rep stos %al,%es:(%edi)
    1072:	89 ca                	mov    %ecx,%edx
    1074:	89 fb                	mov    %edi,%ebx
    1076:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1079:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    107c:	90                   	nop
    107d:	5b                   	pop    %ebx
    107e:	5f                   	pop    %edi
    107f:	5d                   	pop    %ebp
    1080:	c3                   	ret    

00001081 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1081:	55                   	push   %ebp
    1082:	89 e5                	mov    %esp,%ebp
    1084:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1087:	8b 45 08             	mov    0x8(%ebp),%eax
    108a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    108d:	90                   	nop
    108e:	8b 45 08             	mov    0x8(%ebp),%eax
    1091:	8d 50 01             	lea    0x1(%eax),%edx
    1094:	89 55 08             	mov    %edx,0x8(%ebp)
    1097:	8b 55 0c             	mov    0xc(%ebp),%edx
    109a:	8d 4a 01             	lea    0x1(%edx),%ecx
    109d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10a0:	0f b6 12             	movzbl (%edx),%edx
    10a3:	88 10                	mov    %dl,(%eax)
    10a5:	0f b6 00             	movzbl (%eax),%eax
    10a8:	84 c0                	test   %al,%al
    10aa:	75 e2                	jne    108e <strcpy+0xd>
    ;
  return os;
    10ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10af:	c9                   	leave  
    10b0:	c3                   	ret    

000010b1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10b1:	55                   	push   %ebp
    10b2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10b4:	eb 08                	jmp    10be <strcmp+0xd>
    p++, q++;
    10b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10ba:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10be:	8b 45 08             	mov    0x8(%ebp),%eax
    10c1:	0f b6 00             	movzbl (%eax),%eax
    10c4:	84 c0                	test   %al,%al
    10c6:	74 10                	je     10d8 <strcmp+0x27>
    10c8:	8b 45 08             	mov    0x8(%ebp),%eax
    10cb:	0f b6 10             	movzbl (%eax),%edx
    10ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d1:	0f b6 00             	movzbl (%eax),%eax
    10d4:	38 c2                	cmp    %al,%dl
    10d6:	74 de                	je     10b6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10d8:	8b 45 08             	mov    0x8(%ebp),%eax
    10db:	0f b6 00             	movzbl (%eax),%eax
    10de:	0f b6 d0             	movzbl %al,%edx
    10e1:	8b 45 0c             	mov    0xc(%ebp),%eax
    10e4:	0f b6 00             	movzbl (%eax),%eax
    10e7:	0f b6 c0             	movzbl %al,%eax
    10ea:	29 c2                	sub    %eax,%edx
    10ec:	89 d0                	mov    %edx,%eax
}
    10ee:	5d                   	pop    %ebp
    10ef:	c3                   	ret    

000010f0 <strlen>:

uint
strlen(char *s)
{
    10f0:	55                   	push   %ebp
    10f1:	89 e5                	mov    %esp,%ebp
    10f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10fd:	eb 04                	jmp    1103 <strlen+0x13>
    10ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1103:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1106:	8b 45 08             	mov    0x8(%ebp),%eax
    1109:	01 d0                	add    %edx,%eax
    110b:	0f b6 00             	movzbl (%eax),%eax
    110e:	84 c0                	test   %al,%al
    1110:	75 ed                	jne    10ff <strlen+0xf>
    ;
  return n;
    1112:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1115:	c9                   	leave  
    1116:	c3                   	ret    

00001117 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1117:	55                   	push   %ebp
    1118:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    111a:	8b 45 10             	mov    0x10(%ebp),%eax
    111d:	50                   	push   %eax
    111e:	ff 75 0c             	pushl  0xc(%ebp)
    1121:	ff 75 08             	pushl  0x8(%ebp)
    1124:	e8 32 ff ff ff       	call   105b <stosb>
    1129:	83 c4 0c             	add    $0xc,%esp
  return dst;
    112c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    112f:	c9                   	leave  
    1130:	c3                   	ret    

00001131 <strchr>:

char*
strchr(const char *s, char c)
{
    1131:	55                   	push   %ebp
    1132:	89 e5                	mov    %esp,%ebp
    1134:	83 ec 04             	sub    $0x4,%esp
    1137:	8b 45 0c             	mov    0xc(%ebp),%eax
    113a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    113d:	eb 14                	jmp    1153 <strchr+0x22>
    if(*s == c)
    113f:	8b 45 08             	mov    0x8(%ebp),%eax
    1142:	0f b6 00             	movzbl (%eax),%eax
    1145:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1148:	75 05                	jne    114f <strchr+0x1e>
      return (char*)s;
    114a:	8b 45 08             	mov    0x8(%ebp),%eax
    114d:	eb 13                	jmp    1162 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    114f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1153:	8b 45 08             	mov    0x8(%ebp),%eax
    1156:	0f b6 00             	movzbl (%eax),%eax
    1159:	84 c0                	test   %al,%al
    115b:	75 e2                	jne    113f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    115d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1162:	c9                   	leave  
    1163:	c3                   	ret    

00001164 <gets>:

char*
gets(char *buf, int max)
{
    1164:	55                   	push   %ebp
    1165:	89 e5                	mov    %esp,%ebp
    1167:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    116a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1171:	eb 42                	jmp    11b5 <gets+0x51>
    cc = read(0, &c, 1);
    1173:	83 ec 04             	sub    $0x4,%esp
    1176:	6a 01                	push   $0x1
    1178:	8d 45 ef             	lea    -0x11(%ebp),%eax
    117b:	50                   	push   %eax
    117c:	6a 00                	push   $0x0
    117e:	e8 d5 01 00 00       	call   1358 <read>
    1183:	83 c4 10             	add    $0x10,%esp
    1186:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1189:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    118d:	7e 33                	jle    11c2 <gets+0x5e>
      break;
    buf[i++] = c;
    118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1192:	8d 50 01             	lea    0x1(%eax),%edx
    1195:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1198:	89 c2                	mov    %eax,%edx
    119a:	8b 45 08             	mov    0x8(%ebp),%eax
    119d:	01 c2                	add    %eax,%edx
    119f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11a3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11a9:	3c 0a                	cmp    $0xa,%al
    11ab:	74 16                	je     11c3 <gets+0x5f>
    11ad:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11b1:	3c 0d                	cmp    $0xd,%al
    11b3:	74 0e                	je     11c3 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b8:	83 c0 01             	add    $0x1,%eax
    11bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11be:	7c b3                	jl     1173 <gets+0xf>
    11c0:	eb 01                	jmp    11c3 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    11c2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11c6:	8b 45 08             	mov    0x8(%ebp),%eax
    11c9:	01 d0                	add    %edx,%eax
    11cb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11d1:	c9                   	leave  
    11d2:	c3                   	ret    

000011d3 <stat>:

int
stat(char *n, struct stat *st)
{
    11d3:	55                   	push   %ebp
    11d4:	89 e5                	mov    %esp,%ebp
    11d6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11d9:	83 ec 08             	sub    $0x8,%esp
    11dc:	6a 00                	push   $0x0
    11de:	ff 75 08             	pushl  0x8(%ebp)
    11e1:	e8 9a 01 00 00       	call   1380 <open>
    11e6:	83 c4 10             	add    $0x10,%esp
    11e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11f0:	79 07                	jns    11f9 <stat+0x26>
    return -1;
    11f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11f7:	eb 25                	jmp    121e <stat+0x4b>
  r = fstat(fd, st);
    11f9:	83 ec 08             	sub    $0x8,%esp
    11fc:	ff 75 0c             	pushl  0xc(%ebp)
    11ff:	ff 75 f4             	pushl  -0xc(%ebp)
    1202:	e8 91 01 00 00       	call   1398 <fstat>
    1207:	83 c4 10             	add    $0x10,%esp
    120a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    120d:	83 ec 0c             	sub    $0xc,%esp
    1210:	ff 75 f4             	pushl  -0xc(%ebp)
    1213:	e8 50 01 00 00       	call   1368 <close>
    1218:	83 c4 10             	add    $0x10,%esp
  return r;
    121b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    121e:	c9                   	leave  
    121f:	c3                   	ret    

00001220 <atoi>:

int
atoi(const char *s)
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1226:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    122d:	eb 25                	jmp    1254 <atoi+0x34>
    n = n*10 + *s++ - '0';
    122f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1232:	89 d0                	mov    %edx,%eax
    1234:	c1 e0 02             	shl    $0x2,%eax
    1237:	01 d0                	add    %edx,%eax
    1239:	01 c0                	add    %eax,%eax
    123b:	89 c1                	mov    %eax,%ecx
    123d:	8b 45 08             	mov    0x8(%ebp),%eax
    1240:	8d 50 01             	lea    0x1(%eax),%edx
    1243:	89 55 08             	mov    %edx,0x8(%ebp)
    1246:	0f b6 00             	movzbl (%eax),%eax
    1249:	0f be c0             	movsbl %al,%eax
    124c:	01 c8                	add    %ecx,%eax
    124e:	83 e8 30             	sub    $0x30,%eax
    1251:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1254:	8b 45 08             	mov    0x8(%ebp),%eax
    1257:	0f b6 00             	movzbl (%eax),%eax
    125a:	3c 2f                	cmp    $0x2f,%al
    125c:	7e 0a                	jle    1268 <atoi+0x48>
    125e:	8b 45 08             	mov    0x8(%ebp),%eax
    1261:	0f b6 00             	movzbl (%eax),%eax
    1264:	3c 39                	cmp    $0x39,%al
    1266:	7e c7                	jle    122f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1268:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    126b:	c9                   	leave  
    126c:	c3                   	ret    

0000126d <atoo>:

int
atoo(const char *s)
{
    126d:	55                   	push   %ebp
    126e:	89 e5                	mov    %esp,%ebp
    1270:	83 ec 10             	sub    $0x10,%esp
    int n, sign;
    n = 0;
    1273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s == ' ')
    127a:	eb 04                	jmp    1280 <atoo+0x13>
        s++;
    127c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
atoo(const char *s)
{
    int n, sign;
    n = 0;
    while (*s == ' ')
    1280:	8b 45 08             	mov    0x8(%ebp),%eax
    1283:	0f b6 00             	movzbl (%eax),%eax
    1286:	3c 20                	cmp    $0x20,%al
    1288:	74 f2                	je     127c <atoo+0xf>
        s++;
    sign = (*s == '-') ? -1 : 1;
    128a:	8b 45 08             	mov    0x8(%ebp),%eax
    128d:	0f b6 00             	movzbl (%eax),%eax
    1290:	3c 2d                	cmp    $0x2d,%al
    1292:	75 07                	jne    129b <atoo+0x2e>
    1294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1299:	eb 05                	jmp    12a0 <atoo+0x33>
    129b:	b8 01 00 00 00       	mov    $0x1,%eax
    12a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (*s == '+' || *s == '-')
    12a3:	8b 45 08             	mov    0x8(%ebp),%eax
    12a6:	0f b6 00             	movzbl (%eax),%eax
    12a9:	3c 2b                	cmp    $0x2b,%al
    12ab:	74 0a                	je     12b7 <atoo+0x4a>
    12ad:	8b 45 08             	mov    0x8(%ebp),%eax
    12b0:	0f b6 00             	movzbl (%eax),%eax
    12b3:	3c 2d                	cmp    $0x2d,%al
    12b5:	75 27                	jne    12de <atoo+0x71>
        s++;
    12b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while ('0' <= *s && *s <= '7')
    12bb:	eb 21                	jmp    12de <atoo+0x71>
        n = n*8 + *s++ - '0';
    12bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
    12c7:	8b 45 08             	mov    0x8(%ebp),%eax
    12ca:	8d 50 01             	lea    0x1(%eax),%edx
    12cd:	89 55 08             	mov    %edx,0x8(%ebp)
    12d0:	0f b6 00             	movzbl (%eax),%eax
    12d3:	0f be c0             	movsbl %al,%eax
    12d6:	01 c8                	add    %ecx,%eax
    12d8:	83 e8 30             	sub    $0x30,%eax
    12db:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (*s == ' ')
        s++;
    sign = (*s == '-') ? -1 : 1;
    if (*s == '+' || *s == '-')
        s++;
    while ('0' <= *s && *s <= '7')
    12de:	8b 45 08             	mov    0x8(%ebp),%eax
    12e1:	0f b6 00             	movzbl (%eax),%eax
    12e4:	3c 2f                	cmp    $0x2f,%al
    12e6:	7e 0a                	jle    12f2 <atoo+0x85>
    12e8:	8b 45 08             	mov    0x8(%ebp),%eax
    12eb:	0f b6 00             	movzbl (%eax),%eax
    12ee:	3c 37                	cmp    $0x37,%al
    12f0:	7e cb                	jle    12bd <atoo+0x50>
        n = n*8 + *s++ - '0';
    return sign*n;
    12f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12f5:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    12f9:	c9                   	leave  
    12fa:	c3                   	ret    

000012fb <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12fb:	55                   	push   %ebp
    12fc:	89 e5                	mov    %esp,%ebp
    12fe:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1301:	8b 45 08             	mov    0x8(%ebp),%eax
    1304:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1307:	8b 45 0c             	mov    0xc(%ebp),%eax
    130a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    130d:	eb 17                	jmp    1326 <memmove+0x2b>
    *dst++ = *src++;
    130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1312:	8d 50 01             	lea    0x1(%eax),%edx
    1315:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1318:	8b 55 f8             	mov    -0x8(%ebp),%edx
    131b:	8d 4a 01             	lea    0x1(%edx),%ecx
    131e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1321:	0f b6 12             	movzbl (%edx),%edx
    1324:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1326:	8b 45 10             	mov    0x10(%ebp),%eax
    1329:	8d 50 ff             	lea    -0x1(%eax),%edx
    132c:	89 55 10             	mov    %edx,0x10(%ebp)
    132f:	85 c0                	test   %eax,%eax
    1331:	7f dc                	jg     130f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1333:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1336:	c9                   	leave  
    1337:	c3                   	ret    

00001338 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1338:	b8 01 00 00 00       	mov    $0x1,%eax
    133d:	cd 40                	int    $0x40
    133f:	c3                   	ret    

00001340 <exit>:
SYSCALL(exit)
    1340:	b8 02 00 00 00       	mov    $0x2,%eax
    1345:	cd 40                	int    $0x40
    1347:	c3                   	ret    

00001348 <wait>:
SYSCALL(wait)
    1348:	b8 03 00 00 00       	mov    $0x3,%eax
    134d:	cd 40                	int    $0x40
    134f:	c3                   	ret    

00001350 <pipe>:
SYSCALL(pipe)
    1350:	b8 04 00 00 00       	mov    $0x4,%eax
    1355:	cd 40                	int    $0x40
    1357:	c3                   	ret    

00001358 <read>:
SYSCALL(read)
    1358:	b8 05 00 00 00       	mov    $0x5,%eax
    135d:	cd 40                	int    $0x40
    135f:	c3                   	ret    

00001360 <write>:
SYSCALL(write)
    1360:	b8 10 00 00 00       	mov    $0x10,%eax
    1365:	cd 40                	int    $0x40
    1367:	c3                   	ret    

00001368 <close>:
SYSCALL(close)
    1368:	b8 15 00 00 00       	mov    $0x15,%eax
    136d:	cd 40                	int    $0x40
    136f:	c3                   	ret    

00001370 <kill>:
SYSCALL(kill)
    1370:	b8 06 00 00 00       	mov    $0x6,%eax
    1375:	cd 40                	int    $0x40
    1377:	c3                   	ret    

00001378 <exec>:
SYSCALL(exec)
    1378:	b8 07 00 00 00       	mov    $0x7,%eax
    137d:	cd 40                	int    $0x40
    137f:	c3                   	ret    

00001380 <open>:
SYSCALL(open)
    1380:	b8 0f 00 00 00       	mov    $0xf,%eax
    1385:	cd 40                	int    $0x40
    1387:	c3                   	ret    

00001388 <mknod>:
SYSCALL(mknod)
    1388:	b8 11 00 00 00       	mov    $0x11,%eax
    138d:	cd 40                	int    $0x40
    138f:	c3                   	ret    

00001390 <unlink>:
SYSCALL(unlink)
    1390:	b8 12 00 00 00       	mov    $0x12,%eax
    1395:	cd 40                	int    $0x40
    1397:	c3                   	ret    

00001398 <fstat>:
SYSCALL(fstat)
    1398:	b8 08 00 00 00       	mov    $0x8,%eax
    139d:	cd 40                	int    $0x40
    139f:	c3                   	ret    

000013a0 <link>:
SYSCALL(link)
    13a0:	b8 13 00 00 00       	mov    $0x13,%eax
    13a5:	cd 40                	int    $0x40
    13a7:	c3                   	ret    

000013a8 <mkdir>:
SYSCALL(mkdir)
    13a8:	b8 14 00 00 00       	mov    $0x14,%eax
    13ad:	cd 40                	int    $0x40
    13af:	c3                   	ret    

000013b0 <chdir>:
SYSCALL(chdir)
    13b0:	b8 09 00 00 00       	mov    $0x9,%eax
    13b5:	cd 40                	int    $0x40
    13b7:	c3                   	ret    

000013b8 <dup>:
SYSCALL(dup)
    13b8:	b8 0a 00 00 00       	mov    $0xa,%eax
    13bd:	cd 40                	int    $0x40
    13bf:	c3                   	ret    

000013c0 <getpid>:
SYSCALL(getpid)
    13c0:	b8 0b 00 00 00       	mov    $0xb,%eax
    13c5:	cd 40                	int    $0x40
    13c7:	c3                   	ret    

000013c8 <sbrk>:
SYSCALL(sbrk)
    13c8:	b8 0c 00 00 00       	mov    $0xc,%eax
    13cd:	cd 40                	int    $0x40
    13cf:	c3                   	ret    

000013d0 <sleep>:
SYSCALL(sleep)
    13d0:	b8 0d 00 00 00       	mov    $0xd,%eax
    13d5:	cd 40                	int    $0x40
    13d7:	c3                   	ret    

000013d8 <uptime>:
SYSCALL(uptime)
    13d8:	b8 0e 00 00 00       	mov    $0xe,%eax
    13dd:	cd 40                	int    $0x40
    13df:	c3                   	ret    

000013e0 <halt>:
SYSCALL(halt)
    13e0:	b8 16 00 00 00       	mov    $0x16,%eax
    13e5:	cd 40                	int    $0x40
    13e7:	c3                   	ret    

000013e8 <date>:
SYSCALL(date)
    13e8:	b8 17 00 00 00       	mov    $0x17,%eax
    13ed:	cd 40                	int    $0x40
    13ef:	c3                   	ret    

000013f0 <getuid>:
SYSCALL(getuid)
    13f0:	b8 18 00 00 00       	mov    $0x18,%eax
    13f5:	cd 40                	int    $0x40
    13f7:	c3                   	ret    

000013f8 <getgid>:
SYSCALL(getgid)
    13f8:	b8 19 00 00 00       	mov    $0x19,%eax
    13fd:	cd 40                	int    $0x40
    13ff:	c3                   	ret    

00001400 <getppid>:
SYSCALL(getppid)
    1400:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1405:	cd 40                	int    $0x40
    1407:	c3                   	ret    

00001408 <setuid>:
SYSCALL(setuid)
    1408:	b8 1b 00 00 00       	mov    $0x1b,%eax
    140d:	cd 40                	int    $0x40
    140f:	c3                   	ret    

00001410 <setgid>:
SYSCALL(setgid)
    1410:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1415:	cd 40                	int    $0x40
    1417:	c3                   	ret    

00001418 <getprocs>:
SYSCALL(getprocs)
    1418:	b8 1d 00 00 00       	mov    $0x1d,%eax
    141d:	cd 40                	int    $0x40
    141f:	c3                   	ret    

00001420 <setpriority>:
SYSCALL(setpriority)
    1420:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1425:	cd 40                	int    $0x40
    1427:	c3                   	ret    

00001428 <chmod>:
SYSCALL(chmod)
    1428:	b8 1f 00 00 00       	mov    $0x1f,%eax
    142d:	cd 40                	int    $0x40
    142f:	c3                   	ret    

00001430 <chown>:
SYSCALL(chown)
    1430:	b8 20 00 00 00       	mov    $0x20,%eax
    1435:	cd 40                	int    $0x40
    1437:	c3                   	ret    

00001438 <chgrp>:
SYSCALL(chgrp)
    1438:	b8 21 00 00 00       	mov    $0x21,%eax
    143d:	cd 40                	int    $0x40
    143f:	c3                   	ret    

00001440 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1440:	55                   	push   %ebp
    1441:	89 e5                	mov    %esp,%ebp
    1443:	83 ec 18             	sub    $0x18,%esp
    1446:	8b 45 0c             	mov    0xc(%ebp),%eax
    1449:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    144c:	83 ec 04             	sub    $0x4,%esp
    144f:	6a 01                	push   $0x1
    1451:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1454:	50                   	push   %eax
    1455:	ff 75 08             	pushl  0x8(%ebp)
    1458:	e8 03 ff ff ff       	call   1360 <write>
    145d:	83 c4 10             	add    $0x10,%esp
}
    1460:	90                   	nop
    1461:	c9                   	leave  
    1462:	c3                   	ret    

00001463 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1463:	55                   	push   %ebp
    1464:	89 e5                	mov    %esp,%ebp
    1466:	53                   	push   %ebx
    1467:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    146a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1471:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1475:	74 17                	je     148e <printint+0x2b>
    1477:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    147b:	79 11                	jns    148e <printint+0x2b>
    neg = 1;
    147d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1484:	8b 45 0c             	mov    0xc(%ebp),%eax
    1487:	f7 d8                	neg    %eax
    1489:	89 45 ec             	mov    %eax,-0x14(%ebp)
    148c:	eb 06                	jmp    1494 <printint+0x31>
  } else {
    x = xx;
    148e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1491:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1494:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    149b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    149e:	8d 41 01             	lea    0x1(%ecx),%eax
    14a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14aa:	ba 00 00 00 00       	mov    $0x0,%edx
    14af:	f7 f3                	div    %ebx
    14b1:	89 d0                	mov    %edx,%eax
    14b3:	0f b6 80 84 1f 00 00 	movzbl 0x1f84(%eax),%eax
    14ba:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14be:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14c4:	ba 00 00 00 00       	mov    $0x0,%edx
    14c9:	f7 f3                	div    %ebx
    14cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14d2:	75 c7                	jne    149b <printint+0x38>
  if(neg)
    14d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14d8:	74 2d                	je     1507 <printint+0xa4>
    buf[i++] = '-';
    14da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14dd:	8d 50 01             	lea    0x1(%eax),%edx
    14e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14e3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14e8:	eb 1d                	jmp    1507 <printint+0xa4>
    putc(fd, buf[i]);
    14ea:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f0:	01 d0                	add    %edx,%eax
    14f2:	0f b6 00             	movzbl (%eax),%eax
    14f5:	0f be c0             	movsbl %al,%eax
    14f8:	83 ec 08             	sub    $0x8,%esp
    14fb:	50                   	push   %eax
    14fc:	ff 75 08             	pushl  0x8(%ebp)
    14ff:	e8 3c ff ff ff       	call   1440 <putc>
    1504:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1507:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    150b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    150f:	79 d9                	jns    14ea <printint+0x87>
    putc(fd, buf[i]);
}
    1511:	90                   	nop
    1512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1515:	c9                   	leave  
    1516:	c3                   	ret    

00001517 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1517:	55                   	push   %ebp
    1518:	89 e5                	mov    %esp,%ebp
    151a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    151d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1524:	8d 45 0c             	lea    0xc(%ebp),%eax
    1527:	83 c0 04             	add    $0x4,%eax
    152a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    152d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1534:	e9 59 01 00 00       	jmp    1692 <printf+0x17b>
    c = fmt[i] & 0xff;
    1539:	8b 55 0c             	mov    0xc(%ebp),%edx
    153c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    153f:	01 d0                	add    %edx,%eax
    1541:	0f b6 00             	movzbl (%eax),%eax
    1544:	0f be c0             	movsbl %al,%eax
    1547:	25 ff 00 00 00       	and    $0xff,%eax
    154c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    154f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1553:	75 2c                	jne    1581 <printf+0x6a>
      if(c == '%'){
    1555:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1559:	75 0c                	jne    1567 <printf+0x50>
        state = '%';
    155b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1562:	e9 27 01 00 00       	jmp    168e <printf+0x177>
      } else {
        putc(fd, c);
    1567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    156a:	0f be c0             	movsbl %al,%eax
    156d:	83 ec 08             	sub    $0x8,%esp
    1570:	50                   	push   %eax
    1571:	ff 75 08             	pushl  0x8(%ebp)
    1574:	e8 c7 fe ff ff       	call   1440 <putc>
    1579:	83 c4 10             	add    $0x10,%esp
    157c:	e9 0d 01 00 00       	jmp    168e <printf+0x177>
      }
    } else if(state == '%'){
    1581:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1585:	0f 85 03 01 00 00    	jne    168e <printf+0x177>
      if(c == 'd'){
    158b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    158f:	75 1e                	jne    15af <printf+0x98>
        printint(fd, *ap, 10, 1);
    1591:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1594:	8b 00                	mov    (%eax),%eax
    1596:	6a 01                	push   $0x1
    1598:	6a 0a                	push   $0xa
    159a:	50                   	push   %eax
    159b:	ff 75 08             	pushl  0x8(%ebp)
    159e:	e8 c0 fe ff ff       	call   1463 <printint>
    15a3:	83 c4 10             	add    $0x10,%esp
        ap++;
    15a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15aa:	e9 d8 00 00 00       	jmp    1687 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    15af:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15b3:	74 06                	je     15bb <printf+0xa4>
    15b5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15b9:	75 1e                	jne    15d9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    15bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15be:	8b 00                	mov    (%eax),%eax
    15c0:	6a 00                	push   $0x0
    15c2:	6a 10                	push   $0x10
    15c4:	50                   	push   %eax
    15c5:	ff 75 08             	pushl  0x8(%ebp)
    15c8:	e8 96 fe ff ff       	call   1463 <printint>
    15cd:	83 c4 10             	add    $0x10,%esp
        ap++;
    15d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15d4:	e9 ae 00 00 00       	jmp    1687 <printf+0x170>
      } else if(c == 's'){
    15d9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15dd:	75 43                	jne    1622 <printf+0x10b>
        s = (char*)*ap;
    15df:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15e2:	8b 00                	mov    (%eax),%eax
    15e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15ef:	75 25                	jne    1616 <printf+0xff>
          s = "(null)";
    15f1:	c7 45 f4 14 1a 00 00 	movl   $0x1a14,-0xc(%ebp)
        while(*s != 0){
    15f8:	eb 1c                	jmp    1616 <printf+0xff>
          putc(fd, *s);
    15fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15fd:	0f b6 00             	movzbl (%eax),%eax
    1600:	0f be c0             	movsbl %al,%eax
    1603:	83 ec 08             	sub    $0x8,%esp
    1606:	50                   	push   %eax
    1607:	ff 75 08             	pushl  0x8(%ebp)
    160a:	e8 31 fe ff ff       	call   1440 <putc>
    160f:	83 c4 10             	add    $0x10,%esp
          s++;
    1612:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1616:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1619:	0f b6 00             	movzbl (%eax),%eax
    161c:	84 c0                	test   %al,%al
    161e:	75 da                	jne    15fa <printf+0xe3>
    1620:	eb 65                	jmp    1687 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1622:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1626:	75 1d                	jne    1645 <printf+0x12e>
        putc(fd, *ap);
    1628:	8b 45 e8             	mov    -0x18(%ebp),%eax
    162b:	8b 00                	mov    (%eax),%eax
    162d:	0f be c0             	movsbl %al,%eax
    1630:	83 ec 08             	sub    $0x8,%esp
    1633:	50                   	push   %eax
    1634:	ff 75 08             	pushl  0x8(%ebp)
    1637:	e8 04 fe ff ff       	call   1440 <putc>
    163c:	83 c4 10             	add    $0x10,%esp
        ap++;
    163f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1643:	eb 42                	jmp    1687 <printf+0x170>
      } else if(c == '%'){
    1645:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1649:	75 17                	jne    1662 <printf+0x14b>
        putc(fd, c);
    164b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    164e:	0f be c0             	movsbl %al,%eax
    1651:	83 ec 08             	sub    $0x8,%esp
    1654:	50                   	push   %eax
    1655:	ff 75 08             	pushl  0x8(%ebp)
    1658:	e8 e3 fd ff ff       	call   1440 <putc>
    165d:	83 c4 10             	add    $0x10,%esp
    1660:	eb 25                	jmp    1687 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1662:	83 ec 08             	sub    $0x8,%esp
    1665:	6a 25                	push   $0x25
    1667:	ff 75 08             	pushl  0x8(%ebp)
    166a:	e8 d1 fd ff ff       	call   1440 <putc>
    166f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1675:	0f be c0             	movsbl %al,%eax
    1678:	83 ec 08             	sub    $0x8,%esp
    167b:	50                   	push   %eax
    167c:	ff 75 08             	pushl  0x8(%ebp)
    167f:	e8 bc fd ff ff       	call   1440 <putc>
    1684:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1687:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    168e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1692:	8b 55 0c             	mov    0xc(%ebp),%edx
    1695:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1698:	01 d0                	add    %edx,%eax
    169a:	0f b6 00             	movzbl (%eax),%eax
    169d:	84 c0                	test   %al,%al
    169f:	0f 85 94 fe ff ff    	jne    1539 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16a5:	90                   	nop
    16a6:	c9                   	leave  
    16a7:	c3                   	ret    

000016a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16a8:	55                   	push   %ebp
    16a9:	89 e5                	mov    %esp,%ebp
    16ab:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16ae:	8b 45 08             	mov    0x8(%ebp),%eax
    16b1:	83 e8 08             	sub    $0x8,%eax
    16b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16b7:	a1 0c 20 00 00       	mov    0x200c,%eax
    16bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16bf:	eb 24                	jmp    16e5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c4:	8b 00                	mov    (%eax),%eax
    16c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16c9:	77 12                	ja     16dd <free+0x35>
    16cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16d1:	77 24                	ja     16f7 <free+0x4f>
    16d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d6:	8b 00                	mov    (%eax),%eax
    16d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16db:	77 1a                	ja     16f7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e0:	8b 00                	mov    (%eax),%eax
    16e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16eb:	76 d4                	jbe    16c1 <free+0x19>
    16ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f0:	8b 00                	mov    (%eax),%eax
    16f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16f5:	76 ca                	jbe    16c1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    16f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fa:	8b 40 04             	mov    0x4(%eax),%eax
    16fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1704:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1707:	01 c2                	add    %eax,%edx
    1709:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170c:	8b 00                	mov    (%eax),%eax
    170e:	39 c2                	cmp    %eax,%edx
    1710:	75 24                	jne    1736 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1712:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1715:	8b 50 04             	mov    0x4(%eax),%edx
    1718:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171b:	8b 00                	mov    (%eax),%eax
    171d:	8b 40 04             	mov    0x4(%eax),%eax
    1720:	01 c2                	add    %eax,%edx
    1722:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1725:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1728:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172b:	8b 00                	mov    (%eax),%eax
    172d:	8b 10                	mov    (%eax),%edx
    172f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1732:	89 10                	mov    %edx,(%eax)
    1734:	eb 0a                	jmp    1740 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1736:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1739:	8b 10                	mov    (%eax),%edx
    173b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    173e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1740:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1743:	8b 40 04             	mov    0x4(%eax),%eax
    1746:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    174d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1750:	01 d0                	add    %edx,%eax
    1752:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1755:	75 20                	jne    1777 <free+0xcf>
    p->s.size += bp->s.size;
    1757:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175a:	8b 50 04             	mov    0x4(%eax),%edx
    175d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1760:	8b 40 04             	mov    0x4(%eax),%eax
    1763:	01 c2                	add    %eax,%edx
    1765:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1768:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    176b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    176e:	8b 10                	mov    (%eax),%edx
    1770:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1773:	89 10                	mov    %edx,(%eax)
    1775:	eb 08                	jmp    177f <free+0xd7>
  } else
    p->s.ptr = bp;
    1777:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    177d:	89 10                	mov    %edx,(%eax)
  freep = p;
    177f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1782:	a3 0c 20 00 00       	mov    %eax,0x200c
}
    1787:	90                   	nop
    1788:	c9                   	leave  
    1789:	c3                   	ret    

0000178a <morecore>:

static Header*
morecore(uint nu)
{
    178a:	55                   	push   %ebp
    178b:	89 e5                	mov    %esp,%ebp
    178d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1790:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1797:	77 07                	ja     17a0 <morecore+0x16>
    nu = 4096;
    1799:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17a0:	8b 45 08             	mov    0x8(%ebp),%eax
    17a3:	c1 e0 03             	shl    $0x3,%eax
    17a6:	83 ec 0c             	sub    $0xc,%esp
    17a9:	50                   	push   %eax
    17aa:	e8 19 fc ff ff       	call   13c8 <sbrk>
    17af:	83 c4 10             	add    $0x10,%esp
    17b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17b5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17b9:	75 07                	jne    17c2 <morecore+0x38>
    return 0;
    17bb:	b8 00 00 00 00       	mov    $0x0,%eax
    17c0:	eb 26                	jmp    17e8 <morecore+0x5e>
  hp = (Header*)p;
    17c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17cb:	8b 55 08             	mov    0x8(%ebp),%edx
    17ce:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d4:	83 c0 08             	add    $0x8,%eax
    17d7:	83 ec 0c             	sub    $0xc,%esp
    17da:	50                   	push   %eax
    17db:	e8 c8 fe ff ff       	call   16a8 <free>
    17e0:	83 c4 10             	add    $0x10,%esp
  return freep;
    17e3:	a1 0c 20 00 00       	mov    0x200c,%eax
}
    17e8:	c9                   	leave  
    17e9:	c3                   	ret    

000017ea <malloc>:

void*
malloc(uint nbytes)
{
    17ea:	55                   	push   %ebp
    17eb:	89 e5                	mov    %esp,%ebp
    17ed:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17f0:	8b 45 08             	mov    0x8(%ebp),%eax
    17f3:	83 c0 07             	add    $0x7,%eax
    17f6:	c1 e8 03             	shr    $0x3,%eax
    17f9:	83 c0 01             	add    $0x1,%eax
    17fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17ff:	a1 0c 20 00 00       	mov    0x200c,%eax
    1804:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1807:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    180b:	75 23                	jne    1830 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    180d:	c7 45 f0 04 20 00 00 	movl   $0x2004,-0x10(%ebp)
    1814:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1817:	a3 0c 20 00 00       	mov    %eax,0x200c
    181c:	a1 0c 20 00 00       	mov    0x200c,%eax
    1821:	a3 04 20 00 00       	mov    %eax,0x2004
    base.s.size = 0;
    1826:	c7 05 08 20 00 00 00 	movl   $0x0,0x2008
    182d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1830:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1833:	8b 00                	mov    (%eax),%eax
    1835:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1838:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183b:	8b 40 04             	mov    0x4(%eax),%eax
    183e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1841:	72 4d                	jb     1890 <malloc+0xa6>
      if(p->s.size == nunits)
    1843:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1846:	8b 40 04             	mov    0x4(%eax),%eax
    1849:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    184c:	75 0c                	jne    185a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1851:	8b 10                	mov    (%eax),%edx
    1853:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1856:	89 10                	mov    %edx,(%eax)
    1858:	eb 26                	jmp    1880 <malloc+0x96>
      else {
        p->s.size -= nunits;
    185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185d:	8b 40 04             	mov    0x4(%eax),%eax
    1860:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1863:	89 c2                	mov    %eax,%edx
    1865:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1868:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186e:	8b 40 04             	mov    0x4(%eax),%eax
    1871:	c1 e0 03             	shl    $0x3,%eax
    1874:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1877:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    187d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1880:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1883:	a3 0c 20 00 00       	mov    %eax,0x200c
      return (void*)(p + 1);
    1888:	8b 45 f4             	mov    -0xc(%ebp),%eax
    188b:	83 c0 08             	add    $0x8,%eax
    188e:	eb 3b                	jmp    18cb <malloc+0xe1>
    }
    if(p == freep)
    1890:	a1 0c 20 00 00       	mov    0x200c,%eax
    1895:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1898:	75 1e                	jne    18b8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    189a:	83 ec 0c             	sub    $0xc,%esp
    189d:	ff 75 ec             	pushl  -0x14(%ebp)
    18a0:	e8 e5 fe ff ff       	call   178a <morecore>
    18a5:	83 c4 10             	add    $0x10,%esp
    18a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18af:	75 07                	jne    18b8 <malloc+0xce>
        return 0;
    18b1:	b8 00 00 00 00       	mov    $0x0,%eax
    18b6:	eb 13                	jmp    18cb <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c1:	8b 00                	mov    (%eax),%eax
    18c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18c6:	e9 6d ff ff ff       	jmp    1838 <malloc+0x4e>
}
    18cb:	c9                   	leave  
    18cc:	c3                   	ret    
