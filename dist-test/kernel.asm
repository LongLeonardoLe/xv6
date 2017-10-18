
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 90 e6 10 80       	mov    $0x8010e690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 96 3a 10 80       	mov    $0x80103a96,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 7c 9f 10 80       	push   $0x80109f7c
80100042:	68 a0 e6 10 80       	push   $0x8010e6a0
80100047:	e8 1b 66 00 00       	call   80106667 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 25 11 80 a4 	movl   $0x801125a4,0x801125b0
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 25 11 80 a4 	movl   $0x801125a4,0x801125b4
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 d4 e6 10 80 	movl   $0x8010e6d4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 25 11 80       	mov    %eax,0x801125b4
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 a4 25 11 80       	mov    $0x801125a4,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 a0 e6 10 80       	push   $0x8010e6a0
801000c1:	e8 c3 65 00 00       	call   80106689 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 a0 e6 10 80       	push   $0x8010e6a0
8010010c:	e8 df 65 00 00       	call   801066f0 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 e6 10 80       	push   $0x8010e6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 6e 54 00 00       	call   8010559a <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 b0 25 11 80       	mov    0x801125b0,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 a0 e6 10 80       	push   $0x8010e6a0
80100188:	e8 63 65 00 00       	call   801066f0 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 83 9f 10 80       	push   $0x80109f83
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 2d 29 00 00       	call   80102b14 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 94 9f 10 80       	push   $0x80109f94
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 ec 28 00 00       	call   80102b14 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 9b 9f 10 80       	push   $0x80109f9b
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 e6 10 80       	push   $0x8010e6a0
80100255:	e8 2f 64 00 00       	call   80106689 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 b4 25 11 80       	mov    %eax,0x801125b4

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 4a 54 00 00       	call   80105708 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 e6 10 80       	push   $0x8010e6a0
801002c9:	e8 22 64 00 00       	call   801066f0 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 34 d6 10 80       	mov    0x8010d634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 d6 10 80       	push   $0x8010d600
801003e2:	e8 a2 62 00 00       	call   80106689 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 a2 9f 10 80       	push   $0x80109fa2
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec ab 9f 10 80 	movl   $0x80109fab,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 00 d6 10 80       	push   $0x8010d600
8010055b:	e8 90 61 00 00       	call   801066f0 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 34 d6 10 80 00 	movl   $0x0,0x8010d634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 b2 9f 10 80       	push   $0x80109fb2
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 c1 9f 10 80       	push   $0x80109fc1
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 7b 61 00 00       	call   80106742 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 c3 9f 10 80       	push   $0x80109fc3
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 e0 d5 10 80 01 	movl   $0x1,0x8010d5e0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 c7 9f 10 80       	push   $0x80109fc7
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 af 62 00 00       	call   801069ab <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 c6 61 00 00       	call   801068ec <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 e0 d5 10 80       	mov    0x8010d5e0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 4a 7e 00 00       	call   80108605 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 3d 7e 00 00       	call   80108605 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 30 7e 00 00       	call   80108605 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 20 7e 00 00       	call   80108605 <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int doctrl = 0;
80100806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  acquire(&cons.lock);
8010080d:	83 ec 0c             	sub    $0xc,%esp
80100810:	68 00 d6 10 80       	push   $0x8010d600
80100815:	e8 6f 5e 00 00       	call   80106689 <acquire>
8010081a:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
8010081d:	e9 a6 01 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    switch(c){
80100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100825:	83 f8 12             	cmp    $0x12,%eax
80100828:	0f 84 d8 00 00 00    	je     80100906 <consoleintr+0x10d>
8010082e:	83 f8 12             	cmp    $0x12,%eax
80100831:	7f 1c                	jg     8010084f <consoleintr+0x56>
80100833:	83 f8 08             	cmp    $0x8,%eax
80100836:	0f 84 95 00 00 00    	je     801008d1 <consoleintr+0xd8>
8010083c:	83 f8 10             	cmp    $0x10,%eax
8010083f:	74 39                	je     8010087a <consoleintr+0x81>
80100841:	83 f8 06             	cmp    $0x6,%eax
80100844:	0f 84 c8 00 00 00    	je     80100912 <consoleintr+0x119>
8010084a:	e9 e7 00 00 00       	jmp    80100936 <consoleintr+0x13d>
8010084f:	83 f8 15             	cmp    $0x15,%eax
80100852:	74 4f                	je     801008a3 <consoleintr+0xaa>
80100854:	83 f8 15             	cmp    $0x15,%eax
80100857:	7f 0e                	jg     80100867 <consoleintr+0x6e>
80100859:	83 f8 13             	cmp    $0x13,%eax
8010085c:	0f 84 bc 00 00 00    	je     8010091e <consoleintr+0x125>
80100862:	e9 cf 00 00 00       	jmp    80100936 <consoleintr+0x13d>
80100867:	83 f8 1a             	cmp    $0x1a,%eax
8010086a:	0f 84 ba 00 00 00    	je     8010092a <consoleintr+0x131>
80100870:	83 f8 7f             	cmp    $0x7f,%eax
80100873:	74 5c                	je     801008d1 <consoleintr+0xd8>
80100875:	e9 bc 00 00 00       	jmp    80100936 <consoleintr+0x13d>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
8010087a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100881:	e9 42 01 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100886:	a1 48 28 11 80       	mov    0x80112848,%eax
8010088b:	83 e8 01             	sub    $0x1,%eax
8010088e:	a3 48 28 11 80       	mov    %eax,0x80112848
        consputc(BACKSPACE);
80100893:	83 ec 0c             	sub    $0xc,%esp
80100896:	68 00 01 00 00       	push   $0x100
8010089b:	e8 f2 fe ff ff       	call   80100792 <consputc>
801008a0:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008a3:	8b 15 48 28 11 80    	mov    0x80112848,%edx
801008a9:	a1 44 28 11 80       	mov    0x80112844,%eax
801008ae:	39 c2                	cmp    %eax,%edx
801008b0:	0f 84 12 01 00 00    	je     801009c8 <consoleintr+0x1cf>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b6:	a1 48 28 11 80       	mov    0x80112848,%eax
801008bb:	83 e8 01             	sub    $0x1,%eax
801008be:	83 e0 7f             	and    $0x7f,%eax
801008c1:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c8:	3c 0a                	cmp    $0xa,%al
801008ca:	75 ba                	jne    80100886 <consoleintr+0x8d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008cc:	e9 f7 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008d1:	8b 15 48 28 11 80    	mov    0x80112848,%edx
801008d7:	a1 44 28 11 80       	mov    0x80112844,%eax
801008dc:	39 c2                	cmp    %eax,%edx
801008de:	0f 84 e4 00 00 00    	je     801009c8 <consoleintr+0x1cf>
        input.e--;
801008e4:	a1 48 28 11 80       	mov    0x80112848,%eax
801008e9:	83 e8 01             	sub    $0x1,%eax
801008ec:	a3 48 28 11 80       	mov    %eax,0x80112848
        consputc(BACKSPACE);
801008f1:	83 ec 0c             	sub    $0xc,%esp
801008f4:	68 00 01 00 00       	push   $0x100
801008f9:	e8 94 fe ff ff       	call   80100792 <consputc>
801008fe:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100901:	e9 c2 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('R'): 
      doctrl = 1; 
80100906:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
8010090d:	e9 b6 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('F'): // print the number of processes on the free list
      doctrl = 2;
80100912:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%ebp)
      break;
80100919:	e9 aa 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('S'):
      doctrl = 3;
8010091e:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
      break;
80100925:	e9 9e 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('Z'):
      doctrl = 4;
8010092a:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
      break;
80100931:	e9 92 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100936:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010093a:	0f 84 87 00 00 00    	je     801009c7 <consoleintr+0x1ce>
80100940:	8b 15 48 28 11 80    	mov    0x80112848,%edx
80100946:	a1 40 28 11 80       	mov    0x80112840,%eax
8010094b:	29 c2                	sub    %eax,%edx
8010094d:	89 d0                	mov    %edx,%eax
8010094f:	83 f8 7f             	cmp    $0x7f,%eax
80100952:	77 73                	ja     801009c7 <consoleintr+0x1ce>
        c = (c == '\r') ? '\n' : c;
80100954:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
80100958:	74 05                	je     8010095f <consoleintr+0x166>
8010095a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010095d:	eb 05                	jmp    80100964 <consoleintr+0x16b>
8010095f:	b8 0a 00 00 00       	mov    $0xa,%eax
80100964:	89 45 ec             	mov    %eax,-0x14(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100967:	a1 48 28 11 80       	mov    0x80112848,%eax
8010096c:	8d 50 01             	lea    0x1(%eax),%edx
8010096f:	89 15 48 28 11 80    	mov    %edx,0x80112848
80100975:	83 e0 7f             	and    $0x7f,%eax
80100978:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010097b:	88 90 c0 27 11 80    	mov    %dl,-0x7feed840(%eax)
        consputc(c);
80100981:	83 ec 0c             	sub    $0xc,%esp
80100984:	ff 75 ec             	pushl  -0x14(%ebp)
80100987:	e8 06 fe ff ff       	call   80100792 <consputc>
8010098c:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010098f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
80100993:	74 18                	je     801009ad <consoleintr+0x1b4>
80100995:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
80100999:	74 12                	je     801009ad <consoleintr+0x1b4>
8010099b:	a1 48 28 11 80       	mov    0x80112848,%eax
801009a0:	8b 15 40 28 11 80    	mov    0x80112840,%edx
801009a6:	83 ea 80             	sub    $0xffffff80,%edx
801009a9:	39 d0                	cmp    %edx,%eax
801009ab:	75 1a                	jne    801009c7 <consoleintr+0x1ce>
          input.w = input.e;
801009ad:	a1 48 28 11 80       	mov    0x80112848,%eax
801009b2:	a3 44 28 11 80       	mov    %eax,0x80112844
          wakeup(&input.r);
801009b7:	83 ec 0c             	sub    $0xc,%esp
801009ba:	68 40 28 11 80       	push   $0x80112840
801009bf:	e8 44 4d 00 00       	call   80105708 <wakeup>
801009c4:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009c7:	90                   	nop
{
  int c, doprocdump = 0;
  int doctrl = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009c8:	8b 45 08             	mov    0x8(%ebp),%eax
801009cb:	ff d0                	call   *%eax
801009cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
801009d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801009d4:	0f 89 48 fe ff ff    	jns    80100822 <consoleintr+0x29>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009da:	83 ec 0c             	sub    $0xc,%esp
801009dd:	68 00 d6 10 80       	push   $0x8010d600
801009e2:	e8 09 5d 00 00       	call   801066f0 <release>
801009e7:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009ee:	74 05                	je     801009f5 <consoleintr+0x1fc>
    procdump();  // now call procdump() wo. cons.lock held
801009f0:	e8 6e 4f 00 00       	call   80105963 <procdump>
  }
  switch (doctrl) {
801009f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009f8:	83 f8 02             	cmp    $0x2,%eax
801009fb:	74 1f                	je     80100a1c <consoleintr+0x223>
801009fd:	83 f8 02             	cmp    $0x2,%eax
80100a00:	7f 07                	jg     80100a09 <consoleintr+0x210>
80100a02:	83 f8 01             	cmp    $0x1,%eax
80100a05:	74 0e                	je     80100a15 <consoleintr+0x21c>
          break;
      case 4:
          printCtrlZ();
          break;
      default:
          break;
80100a07:	eb 27                	jmp    80100a30 <consoleintr+0x237>
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
  switch (doctrl) {
80100a09:	83 f8 03             	cmp    $0x3,%eax
80100a0c:	74 15                	je     80100a23 <consoleintr+0x22a>
80100a0e:	83 f8 04             	cmp    $0x4,%eax
80100a11:	74 17                	je     80100a2a <consoleintr+0x231>
          break;
      case 4:
          printCtrlZ();
          break;
      default:
          break;
80100a13:	eb 1b                	jmp    80100a30 <consoleintr+0x237>
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
  switch (doctrl) {
      case 1:
          printCtrlR();
80100a15:	e8 4d 54 00 00       	call   80105e67 <printCtrlR>
          break;
80100a1a:	eb 14                	jmp    80100a30 <consoleintr+0x237>
      case 2:
          printCtrlF();
80100a1c:	e8 fc 53 00 00       	call   80105e1d <printCtrlF>
          break;
80100a21:	eb 0d                	jmp    80100a30 <consoleintr+0x237>
      case 3:
          printCtrlS();
80100a23:	e8 73 55 00 00       	call   80105f9b <printCtrlS>
          break;
80100a28:	eb 06                	jmp    80100a30 <consoleintr+0x237>
      case 4:
          printCtrlZ();
80100a2a:	e8 02 56 00 00       	call   80106031 <printCtrlZ>
          break;
80100a2f:	90                   	nop
      default:
          break;
  }
}
80100a30:	90                   	nop
80100a31:	c9                   	leave  
80100a32:	c3                   	ret    

80100a33 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a33:	55                   	push   %ebp
80100a34:	89 e5                	mov    %esp,%ebp
80100a36:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a39:	83 ec 0c             	sub    $0xc,%esp
80100a3c:	ff 75 08             	pushl  0x8(%ebp)
80100a3f:	e8 63 12 00 00       	call   80101ca7 <iunlock>
80100a44:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a47:	8b 45 10             	mov    0x10(%ebp),%eax
80100a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a4d:	83 ec 0c             	sub    $0xc,%esp
80100a50:	68 00 d6 10 80       	push   $0x8010d600
80100a55:	e8 2f 5c 00 00       	call   80106689 <acquire>
80100a5a:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a5d:	e9 ac 00 00 00       	jmp    80100b0e <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a68:	8b 40 24             	mov    0x24(%eax),%eax
80100a6b:	85 c0                	test   %eax,%eax
80100a6d:	74 28                	je     80100a97 <consoleread+0x64>
        release(&cons.lock);
80100a6f:	83 ec 0c             	sub    $0xc,%esp
80100a72:	68 00 d6 10 80       	push   $0x8010d600
80100a77:	e8 74 5c 00 00       	call   801066f0 <release>
80100a7c:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a7f:	83 ec 0c             	sub    $0xc,%esp
80100a82:	ff 75 08             	pushl  0x8(%ebp)
80100a85:	e8 97 10 00 00       	call   80101b21 <ilock>
80100a8a:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a92:	e9 ab 00 00 00       	jmp    80100b42 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a97:	83 ec 08             	sub    $0x8,%esp
80100a9a:	68 00 d6 10 80       	push   $0x8010d600
80100a9f:	68 40 28 11 80       	push   $0x80112840
80100aa4:	e8 f1 4a 00 00       	call   8010559a <sleep>
80100aa9:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aac:	8b 15 40 28 11 80    	mov    0x80112840,%edx
80100ab2:	a1 44 28 11 80       	mov    0x80112844,%eax
80100ab7:	39 c2                	cmp    %eax,%edx
80100ab9:	74 a7                	je     80100a62 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100abb:	a1 40 28 11 80       	mov    0x80112840,%eax
80100ac0:	8d 50 01             	lea    0x1(%eax),%edx
80100ac3:	89 15 40 28 11 80    	mov    %edx,0x80112840
80100ac9:	83 e0 7f             	and    $0x7f,%eax
80100acc:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
80100ad3:	0f be c0             	movsbl %al,%eax
80100ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100ad9:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100add:	75 17                	jne    80100af6 <consoleread+0xc3>
      if(n < target){
80100adf:	8b 45 10             	mov    0x10(%ebp),%eax
80100ae2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100ae5:	73 2f                	jae    80100b16 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100ae7:	a1 40 28 11 80       	mov    0x80112840,%eax
80100aec:	83 e8 01             	sub    $0x1,%eax
80100aef:	a3 40 28 11 80       	mov    %eax,0x80112840
      }
      break;
80100af4:	eb 20                	jmp    80100b16 <consoleread+0xe3>
    }
    *dst++ = c;
80100af6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100af9:	8d 50 01             	lea    0x1(%eax),%edx
80100afc:	89 55 0c             	mov    %edx,0xc(%ebp)
80100aff:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b02:	88 10                	mov    %dl,(%eax)
    --n;
80100b04:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b08:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b0c:	74 0b                	je     80100b19 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b12:	7f 98                	jg     80100aac <consoleread+0x79>
80100b14:	eb 04                	jmp    80100b1a <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100b16:	90                   	nop
80100b17:	eb 01                	jmp    80100b1a <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100b19:	90                   	nop
  }
  release(&cons.lock);
80100b1a:	83 ec 0c             	sub    $0xc,%esp
80100b1d:	68 00 d6 10 80       	push   $0x8010d600
80100b22:	e8 c9 5b 00 00       	call   801066f0 <release>
80100b27:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b2a:	83 ec 0c             	sub    $0xc,%esp
80100b2d:	ff 75 08             	pushl  0x8(%ebp)
80100b30:	e8 ec 0f 00 00       	call   80101b21 <ilock>
80100b35:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b38:	8b 45 10             	mov    0x10(%ebp),%eax
80100b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b3e:	29 c2                	sub    %eax,%edx
80100b40:	89 d0                	mov    %edx,%eax
}
80100b42:	c9                   	leave  
80100b43:	c3                   	ret    

80100b44 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b44:	55                   	push   %ebp
80100b45:	89 e5                	mov    %esp,%ebp
80100b47:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b4a:	83 ec 0c             	sub    $0xc,%esp
80100b4d:	ff 75 08             	pushl  0x8(%ebp)
80100b50:	e8 52 11 00 00       	call   80101ca7 <iunlock>
80100b55:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b58:	83 ec 0c             	sub    $0xc,%esp
80100b5b:	68 00 d6 10 80       	push   $0x8010d600
80100b60:	e8 24 5b 00 00       	call   80106689 <acquire>
80100b65:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b6f:	eb 21                	jmp    80100b92 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b74:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b77:	01 d0                	add    %edx,%eax
80100b79:	0f b6 00             	movzbl (%eax),%eax
80100b7c:	0f be c0             	movsbl %al,%eax
80100b7f:	0f b6 c0             	movzbl %al,%eax
80100b82:	83 ec 0c             	sub    $0xc,%esp
80100b85:	50                   	push   %eax
80100b86:	e8 07 fc ff ff       	call   80100792 <consputc>
80100b8b:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b8e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b95:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b98:	7c d7                	jl     80100b71 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b9a:	83 ec 0c             	sub    $0xc,%esp
80100b9d:	68 00 d6 10 80       	push   $0x8010d600
80100ba2:	e8 49 5b 00 00       	call   801066f0 <release>
80100ba7:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff 75 08             	pushl  0x8(%ebp)
80100bb0:	e8 6c 0f 00 00       	call   80101b21 <ilock>
80100bb5:	83 c4 10             	add    $0x10,%esp

  return n;
80100bb8:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bbb:	c9                   	leave  
80100bbc:	c3                   	ret    

80100bbd <consoleinit>:

void
consoleinit(void)
{
80100bbd:	55                   	push   %ebp
80100bbe:	89 e5                	mov    %esp,%ebp
80100bc0:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bc3:	83 ec 08             	sub    $0x8,%esp
80100bc6:	68 da 9f 10 80       	push   $0x80109fda
80100bcb:	68 00 d6 10 80       	push   $0x8010d600
80100bd0:	e8 92 5a 00 00       	call   80106667 <initlock>
80100bd5:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bd8:	c7 05 0c 32 11 80 44 	movl   $0x80100b44,0x8011320c
80100bdf:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be2:	c7 05 08 32 11 80 33 	movl   $0x80100a33,0x80113208
80100be9:	0a 10 80 
  cons.locking = 1;
80100bec:	c7 05 34 d6 10 80 01 	movl   $0x1,0x8010d634
80100bf3:	00 00 00 

  picenable(IRQ_KBD);
80100bf6:	83 ec 0c             	sub    $0xc,%esp
80100bf9:	6a 01                	push   $0x1
80100bfb:	e8 32 35 00 00       	call   80104132 <picenable>
80100c00:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c03:	83 ec 08             	sub    $0x8,%esp
80100c06:	6a 00                	push   $0x0
80100c08:	6a 01                	push   $0x1
80100c0a:	e8 d2 20 00 00       	call   80102ce1 <ioapicenable>
80100c0f:	83 c4 10             	add    $0x10,%esp
}
80100c12:	90                   	nop
80100c13:	c9                   	leave  
80100c14:	c3                   	ret    

80100c15 <exec>:
#include "stat.h"
#endif

int
exec(char *path, char **argv)
{
80100c15:	55                   	push   %ebp
80100c16:	89 e5                	mov    %esp,%ebp
80100c18:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100c1e:	e8 31 2b 00 00       	call   80103754 <begin_op>
  if((ip = namei(path)) == 0){
80100c23:	83 ec 0c             	sub    $0xc,%esp
80100c26:	ff 75 08             	pushl  0x8(%ebp)
80100c29:	e8 01 1b 00 00       	call   8010272f <namei>
80100c2e:	83 c4 10             	add    $0x10,%esp
80100c31:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c34:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c38:	75 0f                	jne    80100c49 <exec+0x34>
    end_op();
80100c3a:	e8 a1 2b 00 00       	call   801037e0 <end_op>
    return -1;
80100c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c44:	e9 7a 04 00 00       	jmp    801010c3 <exec+0x4ae>
  }
  ilock(ip);
80100c49:	83 ec 0c             	sub    $0xc,%esp
80100c4c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c4f:	e8 cd 0e 00 00       	call   80101b21 <ilock>
80100c54:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c57:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
#ifdef CS333_P5
  struct stat st;
  stati(ip, &st);
80100c5e:	83 ec 08             	sub    $0x8,%esp
80100c61:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
80100c67:	50                   	push   %eax
80100c68:	ff 75 d8             	pushl  -0x28(%ebp)
80100c6b:	e8 01 14 00 00       	call   80102071 <stati>
80100c70:	83 c4 10             	add    $0x10,%esp
  // Check execute permission
  if(st.uid == proc->uid) {
80100c73:	0f b7 85 e4 fe ff ff 	movzwl -0x11c(%ebp),%eax
80100c7a:	0f b7 d0             	movzwl %ax,%edx
80100c7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c83:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80100c89:	39 c2                	cmp    %eax,%edx
80100c8b:	75 12                	jne    80100c9f <exec+0x8a>
    if(st.mode.flags.u_x != 1)
80100c8d:	0f b6 85 e8 fe ff ff 	movzbl -0x118(%ebp),%eax
80100c94:	83 e0 40             	and    $0x40,%eax
80100c97:	84 c0                	test   %al,%al
80100c99:	0f 84 ca 03 00 00    	je     80101069 <exec+0x454>
      goto bad;
  }
  if(st.gid == proc->gid) {
80100c9f:	0f b7 85 e6 fe ff ff 	movzwl -0x11a(%ebp),%eax
80100ca6:	0f b7 d0             	movzwl %ax,%edx
80100ca9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100caf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80100cb5:	39 c2                	cmp    %eax,%edx
80100cb7:	75 12                	jne    80100ccb <exec+0xb6>
    if(st.mode.flags.g_x != 1)
80100cb9:	0f b6 85 e8 fe ff ff 	movzbl -0x118(%ebp),%eax
80100cc0:	83 e0 08             	and    $0x8,%eax
80100cc3:	84 c0                	test   %al,%al
80100cc5:	0f 84 a1 03 00 00    	je     8010106c <exec+0x457>
      goto bad;
  }
  if(st.mode.flags.o_x != 1)
80100ccb:	0f b6 85 e8 fe ff ff 	movzbl -0x118(%ebp),%eax
80100cd2:	83 e0 01             	and    $0x1,%eax
80100cd5:	84 c0                	test   %al,%al
80100cd7:	0f 84 92 03 00 00    	je     8010106f <exec+0x45a>
    goto bad;
#endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100cdd:	6a 34                	push   $0x34
80100cdf:	6a 00                	push   $0x0
80100ce1:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100ce7:	50                   	push   %eax
80100ce8:	ff 75 d8             	pushl  -0x28(%ebp)
80100ceb:	e8 ef 13 00 00       	call   801020df <readi>
80100cf0:	83 c4 10             	add    $0x10,%esp
80100cf3:	83 f8 33             	cmp    $0x33,%eax
80100cf6:	0f 86 76 03 00 00    	jbe    80101072 <exec+0x45d>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100cfc:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100d02:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100d07:	0f 85 68 03 00 00    	jne    80101075 <exec+0x460>
    goto bad;
  if((pgdir = setupkvm()) == 0)
80100d0d:	e8 48 8a 00 00       	call   8010975a <setupkvm>
80100d12:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100d15:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100d19:	0f 84 59 03 00 00    	je     80101078 <exec+0x463>
    goto bad;

  // Load program into memory.
  sz = 0;
80100d1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d26:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100d2d:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100d33:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d36:	e9 ab 00 00 00       	jmp    80100de6 <exec+0x1d1>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d3e:	6a 20                	push   $0x20
80100d40:	50                   	push   %eax
80100d41:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100d47:	50                   	push   %eax
80100d48:	ff 75 d8             	pushl  -0x28(%ebp)
80100d4b:	e8 8f 13 00 00       	call   801020df <readi>
80100d50:	83 c4 10             	add    $0x10,%esp
80100d53:	83 f8 20             	cmp    $0x20,%eax
80100d56:	0f 85 1f 03 00 00    	jne    8010107b <exec+0x466>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100d5c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d62:	83 f8 01             	cmp    $0x1,%eax
80100d65:	75 71                	jne    80100dd8 <exec+0x1c3>
      continue;
    if(ph.memsz < ph.filesz)
80100d67:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100d6d:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d73:	39 c2                	cmp    %eax,%edx
80100d75:	0f 82 03 03 00 00    	jb     8010107e <exec+0x469>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d7b:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100d81:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100d87:	01 d0                	add    %edx,%eax
80100d89:	83 ec 04             	sub    $0x4,%esp
80100d8c:	50                   	push   %eax
80100d8d:	ff 75 e0             	pushl  -0x20(%ebp)
80100d90:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d93:	e8 69 8d 00 00       	call   80109b01 <allocuvm>
80100d98:	83 c4 10             	add    $0x10,%esp
80100d9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100da2:	0f 84 d9 02 00 00    	je     80101081 <exec+0x46c>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100da8:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100dae:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100db4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100dba:	83 ec 0c             	sub    $0xc,%esp
80100dbd:	52                   	push   %edx
80100dbe:	50                   	push   %eax
80100dbf:	ff 75 d8             	pushl  -0x28(%ebp)
80100dc2:	51                   	push   %ecx
80100dc3:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dc6:	e8 5f 8c 00 00       	call   80109a2a <loaduvm>
80100dcb:	83 c4 20             	add    $0x20,%esp
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	0f 88 ae 02 00 00    	js     80101084 <exec+0x46f>
80100dd6:	eb 01                	jmp    80100dd9 <exec+0x1c4>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100dd8:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100ddd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100de0:	83 c0 20             	add    $0x20,%eax
80100de3:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100de6:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100ded:	0f b7 c0             	movzwl %ax,%eax
80100df0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100df3:	0f 8f 42 ff ff ff    	jg     80100d3b <exec+0x126>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100df9:	83 ec 0c             	sub    $0xc,%esp
80100dfc:	ff 75 d8             	pushl  -0x28(%ebp)
80100dff:	e8 05 10 00 00       	call   80101e09 <iunlockput>
80100e04:	83 c4 10             	add    $0x10,%esp
  end_op();
80100e07:	e8 d4 29 00 00       	call   801037e0 <end_op>
  ip = 0;
80100e0c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100e13:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e16:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e20:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e26:	05 00 20 00 00       	add    $0x2000,%eax
80100e2b:	83 ec 04             	sub    $0x4,%esp
80100e2e:	50                   	push   %eax
80100e2f:	ff 75 e0             	pushl  -0x20(%ebp)
80100e32:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e35:	e8 c7 8c 00 00       	call   80109b01 <allocuvm>
80100e3a:	83 c4 10             	add    $0x10,%esp
80100e3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e44:	0f 84 3d 02 00 00    	je     80101087 <exec+0x472>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e4d:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e52:	83 ec 08             	sub    $0x8,%esp
80100e55:	50                   	push   %eax
80100e56:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e59:	e8 c9 8e 00 00       	call   80109d27 <clearpteu>
80100e5e:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e64:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e67:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e6e:	e9 96 00 00 00       	jmp    80100f09 <exec+0x2f4>
    if(argc >= MAXARG)
80100e73:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e77:	0f 87 0d 02 00 00    	ja     8010108a <exec+0x475>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e87:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e8a:	01 d0                	add    %edx,%eax
80100e8c:	8b 00                	mov    (%eax),%eax
80100e8e:	83 ec 0c             	sub    $0xc,%esp
80100e91:	50                   	push   %eax
80100e92:	e8 a2 5c 00 00       	call   80106b39 <strlen>
80100e97:	83 c4 10             	add    $0x10,%esp
80100e9a:	89 c2                	mov    %eax,%edx
80100e9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e9f:	29 d0                	sub    %edx,%eax
80100ea1:	83 e8 01             	sub    $0x1,%eax
80100ea4:	83 e0 fc             	and    $0xfffffffc,%eax
80100ea7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ead:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eb7:	01 d0                	add    %edx,%eax
80100eb9:	8b 00                	mov    (%eax),%eax
80100ebb:	83 ec 0c             	sub    $0xc,%esp
80100ebe:	50                   	push   %eax
80100ebf:	e8 75 5c 00 00       	call   80106b39 <strlen>
80100ec4:	83 c4 10             	add    $0x10,%esp
80100ec7:	83 c0 01             	add    $0x1,%eax
80100eca:	89 c1                	mov    %eax,%ecx
80100ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ecf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ed9:	01 d0                	add    %edx,%eax
80100edb:	8b 00                	mov    (%eax),%eax
80100edd:	51                   	push   %ecx
80100ede:	50                   	push   %eax
80100edf:	ff 75 dc             	pushl  -0x24(%ebp)
80100ee2:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ee5:	e8 f4 8f 00 00       	call   80109ede <copyout>
80100eea:	83 c4 10             	add    $0x10,%esp
80100eed:	85 c0                	test   %eax,%eax
80100eef:	0f 88 98 01 00 00    	js     8010108d <exec+0x478>
      goto bad;
    ustack[3+argc] = sp;
80100ef5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef8:	8d 50 03             	lea    0x3(%eax),%edx
80100efb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100efe:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f05:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f0c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f13:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f16:	01 d0                	add    %edx,%eax
80100f18:	8b 00                	mov    (%eax),%eax
80100f1a:	85 c0                	test   %eax,%eax
80100f1c:	0f 85 51 ff ff ff    	jne    80100e73 <exec+0x25e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f25:	83 c0 03             	add    $0x3,%eax
80100f28:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100f2f:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f33:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100f3a:	ff ff ff 
  ustack[1] = argc;
80100f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f40:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f49:	83 c0 01             	add    $0x1,%eax
80100f4c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f53:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f56:	29 d0                	sub    %edx,%eax
80100f58:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f61:	83 c0 04             	add    $0x4,%eax
80100f64:	c1 e0 02             	shl    $0x2,%eax
80100f67:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f6d:	83 c0 04             	add    $0x4,%eax
80100f70:	c1 e0 02             	shl    $0x2,%eax
80100f73:	50                   	push   %eax
80100f74:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100f7a:	50                   	push   %eax
80100f7b:	ff 75 dc             	pushl  -0x24(%ebp)
80100f7e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f81:	e8 58 8f 00 00       	call   80109ede <copyout>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	0f 88 ff 00 00 00    	js     80101090 <exec+0x47b>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f91:	8b 45 08             	mov    0x8(%ebp),%eax
80100f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f9d:	eb 17                	jmp    80100fb6 <exec+0x3a1>
    if(*s == '/')
80100f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa2:	0f b6 00             	movzbl (%eax),%eax
80100fa5:	3c 2f                	cmp    $0x2f,%al
80100fa7:	75 09                	jne    80100fb2 <exec+0x39d>
      last = s+1;
80100fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fac:	83 c0 01             	add    $0x1,%eax
80100faf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100fb2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb9:	0f b6 00             	movzbl (%eax),%eax
80100fbc:	84 c0                	test   %al,%al
80100fbe:	75 df                	jne    80100f9f <exec+0x38a>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100fc0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fc6:	83 c0 6c             	add    $0x6c,%eax
80100fc9:	83 ec 04             	sub    $0x4,%esp
80100fcc:	6a 10                	push   $0x10
80100fce:	ff 75 f0             	pushl  -0x10(%ebp)
80100fd1:	50                   	push   %eax
80100fd2:	e8 18 5b 00 00       	call   80106aef <safestrcpy>
80100fd7:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100fda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fe0:	8b 40 04             	mov    0x4(%eax),%eax
80100fe3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100fe6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100fef:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ff2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ff8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ffb:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ffd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101003:	8b 40 18             	mov    0x18(%eax),%eax
80101006:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
8010100c:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
8010100f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101015:	8b 40 18             	mov    0x18(%eax),%eax
80101018:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010101b:	89 50 44             	mov    %edx,0x44(%eax)
#ifdef CS333_P5
  if(st.mode.flags.setuid == 1)
8010101e:	0f b6 85 e9 fe ff ff 	movzbl -0x117(%ebp),%eax
80101025:	83 e0 02             	and    $0x2,%eax
80101028:	84 c0                	test   %al,%al
8010102a:	74 16                	je     80101042 <exec+0x42d>
    proc->uid = st.uid;
8010102c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101032:	0f b7 95 e4 fe ff ff 	movzwl -0x11c(%ebp),%edx
80101039:	0f b7 d2             	movzwl %dx,%edx
8010103c:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
#endif
  switchuvm(proc);
80101042:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101048:	83 ec 0c             	sub    $0xc,%esp
8010104b:	50                   	push   %eax
8010104c:	e8 f0 87 00 00       	call   80109841 <switchuvm>
80101051:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 75 d0             	pushl  -0x30(%ebp)
8010105a:	e8 28 8c 00 00       	call   80109c87 <freevm>
8010105f:	83 c4 10             	add    $0x10,%esp
  return 0;
80101062:	b8 00 00 00 00       	mov    $0x0,%eax
80101067:	eb 5a                	jmp    801010c3 <exec+0x4ae>
  struct stat st;
  stati(ip, &st);
  // Check execute permission
  if(st.uid == proc->uid) {
    if(st.mode.flags.u_x != 1)
      goto bad;
80101069:	90                   	nop
8010106a:	eb 25                	jmp    80101091 <exec+0x47c>
  }
  if(st.gid == proc->gid) {
    if(st.mode.flags.g_x != 1)
      goto bad;
8010106c:	90                   	nop
8010106d:	eb 22                	jmp    80101091 <exec+0x47c>
  }
  if(st.mode.flags.o_x != 1)
    goto bad;
8010106f:	90                   	nop
80101070:	eb 1f                	jmp    80101091 <exec+0x47c>
#endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80101072:	90                   	nop
80101073:	eb 1c                	jmp    80101091 <exec+0x47c>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80101075:	90                   	nop
80101076:	eb 19                	jmp    80101091 <exec+0x47c>
  if((pgdir = setupkvm()) == 0)
    goto bad;
80101078:	90                   	nop
80101079:	eb 16                	jmp    80101091 <exec+0x47c>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
8010107b:	90                   	nop
8010107c:	eb 13                	jmp    80101091 <exec+0x47c>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
8010107e:	90                   	nop
8010107f:	eb 10                	jmp    80101091 <exec+0x47c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80101081:	90                   	nop
80101082:	eb 0d                	jmp    80101091 <exec+0x47c>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80101084:	90                   	nop
80101085:	eb 0a                	jmp    80101091 <exec+0x47c>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80101087:	90                   	nop
80101088:	eb 07                	jmp    80101091 <exec+0x47c>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
8010108a:	90                   	nop
8010108b:	eb 04                	jmp    80101091 <exec+0x47c>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
8010108d:	90                   	nop
8010108e:	eb 01                	jmp    80101091 <exec+0x47c>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80101090:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80101091:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101095:	74 0e                	je     801010a5 <exec+0x490>
    freevm(pgdir);
80101097:	83 ec 0c             	sub    $0xc,%esp
8010109a:	ff 75 d4             	pushl  -0x2c(%ebp)
8010109d:	e8 e5 8b 00 00       	call   80109c87 <freevm>
801010a2:	83 c4 10             	add    $0x10,%esp
  if(ip){
801010a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801010a9:	74 13                	je     801010be <exec+0x4a9>
    iunlockput(ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 75 d8             	pushl  -0x28(%ebp)
801010b1:	e8 53 0d 00 00       	call   80101e09 <iunlockput>
801010b6:	83 c4 10             	add    $0x10,%esp
    end_op();
801010b9:	e8 22 27 00 00       	call   801037e0 <end_op>
  }
  return -1;
801010be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010c3:	c9                   	leave  
801010c4:	c3                   	ret    

801010c5 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010c5:	55                   	push   %ebp
801010c6:	89 e5                	mov    %esp,%ebp
801010c8:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
801010cb:	83 ec 08             	sub    $0x8,%esp
801010ce:	68 e2 9f 10 80       	push   $0x80109fe2
801010d3:	68 60 28 11 80       	push   $0x80112860
801010d8:	e8 8a 55 00 00       	call   80106667 <initlock>
801010dd:	83 c4 10             	add    $0x10,%esp
}
801010e0:	90                   	nop
801010e1:	c9                   	leave  
801010e2:	c3                   	ret    

801010e3 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010e3:	55                   	push   %ebp
801010e4:	89 e5                	mov    %esp,%ebp
801010e6:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801010e9:	83 ec 0c             	sub    $0xc,%esp
801010ec:	68 60 28 11 80       	push   $0x80112860
801010f1:	e8 93 55 00 00       	call   80106689 <acquire>
801010f6:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010f9:	c7 45 f4 94 28 11 80 	movl   $0x80112894,-0xc(%ebp)
80101100:	eb 2d                	jmp    8010112f <filealloc+0x4c>
    if(f->ref == 0){
80101102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101105:	8b 40 04             	mov    0x4(%eax),%eax
80101108:	85 c0                	test   %eax,%eax
8010110a:	75 1f                	jne    8010112b <filealloc+0x48>
      f->ref = 1;
8010110c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010110f:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	68 60 28 11 80       	push   $0x80112860
8010111e:	e8 cd 55 00 00       	call   801066f0 <release>
80101123:	83 c4 10             	add    $0x10,%esp
      return f;
80101126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101129:	eb 23                	jmp    8010114e <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010112b:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010112f:	b8 f4 31 11 80       	mov    $0x801131f4,%eax
80101134:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101137:	72 c9                	jb     80101102 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101139:	83 ec 0c             	sub    $0xc,%esp
8010113c:	68 60 28 11 80       	push   $0x80112860
80101141:	e8 aa 55 00 00       	call   801066f0 <release>
80101146:	83 c4 10             	add    $0x10,%esp
  return 0;
80101149:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010114e:	c9                   	leave  
8010114f:	c3                   	ret    

80101150 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101156:	83 ec 0c             	sub    $0xc,%esp
80101159:	68 60 28 11 80       	push   $0x80112860
8010115e:	e8 26 55 00 00       	call   80106689 <acquire>
80101163:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101166:	8b 45 08             	mov    0x8(%ebp),%eax
80101169:	8b 40 04             	mov    0x4(%eax),%eax
8010116c:	85 c0                	test   %eax,%eax
8010116e:	7f 0d                	jg     8010117d <filedup+0x2d>
    panic("filedup");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 e9 9f 10 80       	push   $0x80109fe9
80101178:	e8 e9 f3 ff ff       	call   80100566 <panic>
  f->ref++;
8010117d:	8b 45 08             	mov    0x8(%ebp),%eax
80101180:	8b 40 04             	mov    0x4(%eax),%eax
80101183:	8d 50 01             	lea    0x1(%eax),%edx
80101186:	8b 45 08             	mov    0x8(%ebp),%eax
80101189:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010118c:	83 ec 0c             	sub    $0xc,%esp
8010118f:	68 60 28 11 80       	push   $0x80112860
80101194:	e8 57 55 00 00       	call   801066f0 <release>
80101199:	83 c4 10             	add    $0x10,%esp
  return f;
8010119c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010119f:	c9                   	leave  
801011a0:	c3                   	ret    

801011a1 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011a1:	55                   	push   %ebp
801011a2:	89 e5                	mov    %esp,%ebp
801011a4:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801011a7:	83 ec 0c             	sub    $0xc,%esp
801011aa:	68 60 28 11 80       	push   $0x80112860
801011af:	e8 d5 54 00 00       	call   80106689 <acquire>
801011b4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011b7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ba:	8b 40 04             	mov    0x4(%eax),%eax
801011bd:	85 c0                	test   %eax,%eax
801011bf:	7f 0d                	jg     801011ce <fileclose+0x2d>
    panic("fileclose");
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	68 f1 9f 10 80       	push   $0x80109ff1
801011c9:	e8 98 f3 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
801011ce:	8b 45 08             	mov    0x8(%ebp),%eax
801011d1:	8b 40 04             	mov    0x4(%eax),%eax
801011d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801011d7:	8b 45 08             	mov    0x8(%ebp),%eax
801011da:	89 50 04             	mov    %edx,0x4(%eax)
801011dd:	8b 45 08             	mov    0x8(%ebp),%eax
801011e0:	8b 40 04             	mov    0x4(%eax),%eax
801011e3:	85 c0                	test   %eax,%eax
801011e5:	7e 15                	jle    801011fc <fileclose+0x5b>
    release(&ftable.lock);
801011e7:	83 ec 0c             	sub    $0xc,%esp
801011ea:	68 60 28 11 80       	push   $0x80112860
801011ef:	e8 fc 54 00 00       	call   801066f0 <release>
801011f4:	83 c4 10             	add    $0x10,%esp
801011f7:	e9 8b 00 00 00       	jmp    80101287 <fileclose+0xe6>
    return;
  }
  ff = *f;
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	8b 10                	mov    (%eax),%edx
80101201:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101204:	8b 50 04             	mov    0x4(%eax),%edx
80101207:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010120a:	8b 50 08             	mov    0x8(%eax),%edx
8010120d:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101210:	8b 50 0c             	mov    0xc(%eax),%edx
80101213:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101216:	8b 50 10             	mov    0x10(%eax),%edx
80101219:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010121c:	8b 40 14             	mov    0x14(%eax),%eax
8010121f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101222:	8b 45 08             	mov    0x8(%ebp),%eax
80101225:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010122c:	8b 45 08             	mov    0x8(%ebp),%eax
8010122f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101235:	83 ec 0c             	sub    $0xc,%esp
80101238:	68 60 28 11 80       	push   $0x80112860
8010123d:	e8 ae 54 00 00       	call   801066f0 <release>
80101242:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101245:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101248:	83 f8 01             	cmp    $0x1,%eax
8010124b:	75 19                	jne    80101266 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010124d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101251:	0f be d0             	movsbl %al,%edx
80101254:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101257:	83 ec 08             	sub    $0x8,%esp
8010125a:	52                   	push   %edx
8010125b:	50                   	push   %eax
8010125c:	e8 3a 31 00 00       	call   8010439b <pipeclose>
80101261:	83 c4 10             	add    $0x10,%esp
80101264:	eb 21                	jmp    80101287 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101266:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101269:	83 f8 02             	cmp    $0x2,%eax
8010126c:	75 19                	jne    80101287 <fileclose+0xe6>
    begin_op();
8010126e:	e8 e1 24 00 00       	call   80103754 <begin_op>
    iput(ff.ip);
80101273:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101276:	83 ec 0c             	sub    $0xc,%esp
80101279:	50                   	push   %eax
8010127a:	e8 9a 0a 00 00       	call   80101d19 <iput>
8010127f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101282:	e8 59 25 00 00       	call   801037e0 <end_op>
  }
}
80101287:	c9                   	leave  
80101288:	c3                   	ret    

80101289 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101289:	55                   	push   %ebp
8010128a:	89 e5                	mov    %esp,%ebp
8010128c:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010128f:	8b 45 08             	mov    0x8(%ebp),%eax
80101292:	8b 00                	mov    (%eax),%eax
80101294:	83 f8 02             	cmp    $0x2,%eax
80101297:	75 40                	jne    801012d9 <filestat+0x50>
    ilock(f->ip);
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	8b 40 10             	mov    0x10(%eax),%eax
8010129f:	83 ec 0c             	sub    $0xc,%esp
801012a2:	50                   	push   %eax
801012a3:	e8 79 08 00 00       	call   80101b21 <ilock>
801012a8:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801012ab:	8b 45 08             	mov    0x8(%ebp),%eax
801012ae:	8b 40 10             	mov    0x10(%eax),%eax
801012b1:	83 ec 08             	sub    $0x8,%esp
801012b4:	ff 75 0c             	pushl  0xc(%ebp)
801012b7:	50                   	push   %eax
801012b8:	e8 b4 0d 00 00       	call   80102071 <stati>
801012bd:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801012c0:	8b 45 08             	mov    0x8(%ebp),%eax
801012c3:	8b 40 10             	mov    0x10(%eax),%eax
801012c6:	83 ec 0c             	sub    $0xc,%esp
801012c9:	50                   	push   %eax
801012ca:	e8 d8 09 00 00       	call   80101ca7 <iunlock>
801012cf:	83 c4 10             	add    $0x10,%esp
    return 0;
801012d2:	b8 00 00 00 00       	mov    $0x0,%eax
801012d7:	eb 05                	jmp    801012de <filestat+0x55>
  }
  return -1;
801012d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012de:	c9                   	leave  
801012df:	c3                   	ret    

801012e0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012e6:	8b 45 08             	mov    0x8(%ebp),%eax
801012e9:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801012ed:	84 c0                	test   %al,%al
801012ef:	75 0a                	jne    801012fb <fileread+0x1b>
    return -1;
801012f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f6:	e9 9b 00 00 00       	jmp    80101396 <fileread+0xb6>
  if(f->type == FD_PIPE)
801012fb:	8b 45 08             	mov    0x8(%ebp),%eax
801012fe:	8b 00                	mov    (%eax),%eax
80101300:	83 f8 01             	cmp    $0x1,%eax
80101303:	75 1a                	jne    8010131f <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101305:	8b 45 08             	mov    0x8(%ebp),%eax
80101308:	8b 40 0c             	mov    0xc(%eax),%eax
8010130b:	83 ec 04             	sub    $0x4,%esp
8010130e:	ff 75 10             	pushl  0x10(%ebp)
80101311:	ff 75 0c             	pushl  0xc(%ebp)
80101314:	50                   	push   %eax
80101315:	e8 29 32 00 00       	call   80104543 <piperead>
8010131a:	83 c4 10             	add    $0x10,%esp
8010131d:	eb 77                	jmp    80101396 <fileread+0xb6>
  if(f->type == FD_INODE){
8010131f:	8b 45 08             	mov    0x8(%ebp),%eax
80101322:	8b 00                	mov    (%eax),%eax
80101324:	83 f8 02             	cmp    $0x2,%eax
80101327:	75 60                	jne    80101389 <fileread+0xa9>
    ilock(f->ip);
80101329:	8b 45 08             	mov    0x8(%ebp),%eax
8010132c:	8b 40 10             	mov    0x10(%eax),%eax
8010132f:	83 ec 0c             	sub    $0xc,%esp
80101332:	50                   	push   %eax
80101333:	e8 e9 07 00 00       	call   80101b21 <ilock>
80101338:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010133b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010133e:	8b 45 08             	mov    0x8(%ebp),%eax
80101341:	8b 50 14             	mov    0x14(%eax),%edx
80101344:	8b 45 08             	mov    0x8(%ebp),%eax
80101347:	8b 40 10             	mov    0x10(%eax),%eax
8010134a:	51                   	push   %ecx
8010134b:	52                   	push   %edx
8010134c:	ff 75 0c             	pushl  0xc(%ebp)
8010134f:	50                   	push   %eax
80101350:	e8 8a 0d 00 00       	call   801020df <readi>
80101355:	83 c4 10             	add    $0x10,%esp
80101358:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010135b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010135f:	7e 11                	jle    80101372 <fileread+0x92>
      f->off += r;
80101361:	8b 45 08             	mov    0x8(%ebp),%eax
80101364:	8b 50 14             	mov    0x14(%eax),%edx
80101367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136a:	01 c2                	add    %eax,%edx
8010136c:	8b 45 08             	mov    0x8(%ebp),%eax
8010136f:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101372:	8b 45 08             	mov    0x8(%ebp),%eax
80101375:	8b 40 10             	mov    0x10(%eax),%eax
80101378:	83 ec 0c             	sub    $0xc,%esp
8010137b:	50                   	push   %eax
8010137c:	e8 26 09 00 00       	call   80101ca7 <iunlock>
80101381:	83 c4 10             	add    $0x10,%esp
    return r;
80101384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101387:	eb 0d                	jmp    80101396 <fileread+0xb6>
  }
  panic("fileread");
80101389:	83 ec 0c             	sub    $0xc,%esp
8010138c:	68 fb 9f 10 80       	push   $0x80109ffb
80101391:	e8 d0 f1 ff ff       	call   80100566 <panic>
}
80101396:	c9                   	leave  
80101397:	c3                   	ret    

80101398 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101398:	55                   	push   %ebp
80101399:	89 e5                	mov    %esp,%ebp
8010139b:	53                   	push   %ebx
8010139c:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010139f:	8b 45 08             	mov    0x8(%ebp),%eax
801013a2:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801013a6:	84 c0                	test   %al,%al
801013a8:	75 0a                	jne    801013b4 <filewrite+0x1c>
    return -1;
801013aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013af:	e9 1b 01 00 00       	jmp    801014cf <filewrite+0x137>
  if(f->type == FD_PIPE)
801013b4:	8b 45 08             	mov    0x8(%ebp),%eax
801013b7:	8b 00                	mov    (%eax),%eax
801013b9:	83 f8 01             	cmp    $0x1,%eax
801013bc:	75 1d                	jne    801013db <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801013be:	8b 45 08             	mov    0x8(%ebp),%eax
801013c1:	8b 40 0c             	mov    0xc(%eax),%eax
801013c4:	83 ec 04             	sub    $0x4,%esp
801013c7:	ff 75 10             	pushl  0x10(%ebp)
801013ca:	ff 75 0c             	pushl  0xc(%ebp)
801013cd:	50                   	push   %eax
801013ce:	e8 72 30 00 00       	call   80104445 <pipewrite>
801013d3:	83 c4 10             	add    $0x10,%esp
801013d6:	e9 f4 00 00 00       	jmp    801014cf <filewrite+0x137>
  if(f->type == FD_INODE){
801013db:	8b 45 08             	mov    0x8(%ebp),%eax
801013de:	8b 00                	mov    (%eax),%eax
801013e0:	83 f8 02             	cmp    $0x2,%eax
801013e3:	0f 85 d9 00 00 00    	jne    801014c2 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801013e9:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801013f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801013f7:	e9 a3 00 00 00       	jmp    8010149f <filewrite+0x107>
      int n1 = n - i;
801013fc:	8b 45 10             	mov    0x10(%ebp),%eax
801013ff:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101402:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101405:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101408:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010140b:	7e 06                	jle    80101413 <filewrite+0x7b>
        n1 = max;
8010140d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101410:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101413:	e8 3c 23 00 00       	call   80103754 <begin_op>
      ilock(f->ip);
80101418:	8b 45 08             	mov    0x8(%ebp),%eax
8010141b:	8b 40 10             	mov    0x10(%eax),%eax
8010141e:	83 ec 0c             	sub    $0xc,%esp
80101421:	50                   	push   %eax
80101422:	e8 fa 06 00 00       	call   80101b21 <ilock>
80101427:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010142a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010142d:	8b 45 08             	mov    0x8(%ebp),%eax
80101430:	8b 50 14             	mov    0x14(%eax),%edx
80101433:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101436:	8b 45 0c             	mov    0xc(%ebp),%eax
80101439:	01 c3                	add    %eax,%ebx
8010143b:	8b 45 08             	mov    0x8(%ebp),%eax
8010143e:	8b 40 10             	mov    0x10(%eax),%eax
80101441:	51                   	push   %ecx
80101442:	52                   	push   %edx
80101443:	53                   	push   %ebx
80101444:	50                   	push   %eax
80101445:	e8 ec 0d 00 00       	call   80102236 <writei>
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101450:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101454:	7e 11                	jle    80101467 <filewrite+0xcf>
        f->off += r;
80101456:	8b 45 08             	mov    0x8(%ebp),%eax
80101459:	8b 50 14             	mov    0x14(%eax),%edx
8010145c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010145f:	01 c2                	add    %eax,%edx
80101461:	8b 45 08             	mov    0x8(%ebp),%eax
80101464:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101467:	8b 45 08             	mov    0x8(%ebp),%eax
8010146a:	8b 40 10             	mov    0x10(%eax),%eax
8010146d:	83 ec 0c             	sub    $0xc,%esp
80101470:	50                   	push   %eax
80101471:	e8 31 08 00 00       	call   80101ca7 <iunlock>
80101476:	83 c4 10             	add    $0x10,%esp
      end_op();
80101479:	e8 62 23 00 00       	call   801037e0 <end_op>

      if(r < 0)
8010147e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101482:	78 29                	js     801014ad <filewrite+0x115>
        break;
      if(r != n1)
80101484:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101487:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010148a:	74 0d                	je     80101499 <filewrite+0x101>
        panic("short filewrite");
8010148c:	83 ec 0c             	sub    $0xc,%esp
8010148f:	68 04 a0 10 80       	push   $0x8010a004
80101494:	e8 cd f0 ff ff       	call   80100566 <panic>
      i += r;
80101499:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010149c:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010149f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014a2:	3b 45 10             	cmp    0x10(%ebp),%eax
801014a5:	0f 8c 51 ff ff ff    	jl     801013fc <filewrite+0x64>
801014ab:	eb 01                	jmp    801014ae <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801014ad:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014b1:	3b 45 10             	cmp    0x10(%ebp),%eax
801014b4:	75 05                	jne    801014bb <filewrite+0x123>
801014b6:	8b 45 10             	mov    0x10(%ebp),%eax
801014b9:	eb 14                	jmp    801014cf <filewrite+0x137>
801014bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014c0:	eb 0d                	jmp    801014cf <filewrite+0x137>
  }
  panic("filewrite");
801014c2:	83 ec 0c             	sub    $0xc,%esp
801014c5:	68 14 a0 10 80       	push   $0x8010a014
801014ca:	e8 97 f0 ff ff       	call   80100566 <panic>
}
801014cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014d2:	c9                   	leave  
801014d3:	c3                   	ret    

801014d4 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014d4:	55                   	push   %ebp
801014d5:	89 e5                	mov    %esp,%ebp
801014d7:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801014da:	8b 45 08             	mov    0x8(%ebp),%eax
801014dd:	83 ec 08             	sub    $0x8,%esp
801014e0:	6a 01                	push   $0x1
801014e2:	50                   	push   %eax
801014e3:	e8 ce ec ff ff       	call   801001b6 <bread>
801014e8:	83 c4 10             	add    $0x10,%esp
801014eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801014ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014f1:	83 c0 18             	add    $0x18,%eax
801014f4:	83 ec 04             	sub    $0x4,%esp
801014f7:	6a 1c                	push   $0x1c
801014f9:	50                   	push   %eax
801014fa:	ff 75 0c             	pushl  0xc(%ebp)
801014fd:	e8 a9 54 00 00       	call   801069ab <memmove>
80101502:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101505:	83 ec 0c             	sub    $0xc,%esp
80101508:	ff 75 f4             	pushl  -0xc(%ebp)
8010150b:	e8 1e ed ff ff       	call   8010022e <brelse>
80101510:	83 c4 10             	add    $0x10,%esp
}
80101513:	90                   	nop
80101514:	c9                   	leave  
80101515:	c3                   	ret    

80101516 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101516:	55                   	push   %ebp
80101517:	89 e5                	mov    %esp,%ebp
80101519:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010151c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010151f:	8b 45 08             	mov    0x8(%ebp),%eax
80101522:	83 ec 08             	sub    $0x8,%esp
80101525:	52                   	push   %edx
80101526:	50                   	push   %eax
80101527:	e8 8a ec ff ff       	call   801001b6 <bread>
8010152c:	83 c4 10             	add    $0x10,%esp
8010152f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101535:	83 c0 18             	add    $0x18,%eax
80101538:	83 ec 04             	sub    $0x4,%esp
8010153b:	68 00 02 00 00       	push   $0x200
80101540:	6a 00                	push   $0x0
80101542:	50                   	push   %eax
80101543:	e8 a4 53 00 00       	call   801068ec <memset>
80101548:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010154b:	83 ec 0c             	sub    $0xc,%esp
8010154e:	ff 75 f4             	pushl  -0xc(%ebp)
80101551:	e8 36 24 00 00       	call   8010398c <log_write>
80101556:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101559:	83 ec 0c             	sub    $0xc,%esp
8010155c:	ff 75 f4             	pushl  -0xc(%ebp)
8010155f:	e8 ca ec ff ff       	call   8010022e <brelse>
80101564:	83 c4 10             	add    $0x10,%esp
}
80101567:	90                   	nop
80101568:	c9                   	leave  
80101569:	c3                   	ret    

8010156a <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010156a:	55                   	push   %ebp
8010156b:	89 e5                	mov    %esp,%ebp
8010156d:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101570:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101577:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010157e:	e9 13 01 00 00       	jmp    80101696 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101586:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010158c:	85 c0                	test   %eax,%eax
8010158e:	0f 48 c2             	cmovs  %edx,%eax
80101591:	c1 f8 0c             	sar    $0xc,%eax
80101594:	89 c2                	mov    %eax,%edx
80101596:	a1 78 32 11 80       	mov    0x80113278,%eax
8010159b:	01 d0                	add    %edx,%eax
8010159d:	83 ec 08             	sub    $0x8,%esp
801015a0:	50                   	push   %eax
801015a1:	ff 75 08             	pushl  0x8(%ebp)
801015a4:	e8 0d ec ff ff       	call   801001b6 <bread>
801015a9:	83 c4 10             	add    $0x10,%esp
801015ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015b6:	e9 a6 00 00 00       	jmp    80101661 <balloc+0xf7>
      m = 1 << (bi % 8);
801015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015be:	99                   	cltd   
801015bf:	c1 ea 1d             	shr    $0x1d,%edx
801015c2:	01 d0                	add    %edx,%eax
801015c4:	83 e0 07             	and    $0x7,%eax
801015c7:	29 d0                	sub    %edx,%eax
801015c9:	ba 01 00 00 00       	mov    $0x1,%edx
801015ce:	89 c1                	mov    %eax,%ecx
801015d0:	d3 e2                	shl    %cl,%edx
801015d2:	89 d0                	mov    %edx,%eax
801015d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015da:	8d 50 07             	lea    0x7(%eax),%edx
801015dd:	85 c0                	test   %eax,%eax
801015df:	0f 48 c2             	cmovs  %edx,%eax
801015e2:	c1 f8 03             	sar    $0x3,%eax
801015e5:	89 c2                	mov    %eax,%edx
801015e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015ea:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015ef:	0f b6 c0             	movzbl %al,%eax
801015f2:	23 45 e8             	and    -0x18(%ebp),%eax
801015f5:	85 c0                	test   %eax,%eax
801015f7:	75 64                	jne    8010165d <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801015f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fc:	8d 50 07             	lea    0x7(%eax),%edx
801015ff:	85 c0                	test   %eax,%eax
80101601:	0f 48 c2             	cmovs  %edx,%eax
80101604:	c1 f8 03             	sar    $0x3,%eax
80101607:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010160a:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010160f:	89 d1                	mov    %edx,%ecx
80101611:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101614:	09 ca                	or     %ecx,%edx
80101616:	89 d1                	mov    %edx,%ecx
80101618:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010161b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010161f:	83 ec 0c             	sub    $0xc,%esp
80101622:	ff 75 ec             	pushl  -0x14(%ebp)
80101625:	e8 62 23 00 00       	call   8010398c <log_write>
8010162a:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010162d:	83 ec 0c             	sub    $0xc,%esp
80101630:	ff 75 ec             	pushl  -0x14(%ebp)
80101633:	e8 f6 eb ff ff       	call   8010022e <brelse>
80101638:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010163b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101641:	01 c2                	add    %eax,%edx
80101643:	8b 45 08             	mov    0x8(%ebp),%eax
80101646:	83 ec 08             	sub    $0x8,%esp
80101649:	52                   	push   %edx
8010164a:	50                   	push   %eax
8010164b:	e8 c6 fe ff ff       	call   80101516 <bzero>
80101650:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101653:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101659:	01 d0                	add    %edx,%eax
8010165b:	eb 57                	jmp    801016b4 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010165d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101661:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101668:	7f 17                	jg     80101681 <balloc+0x117>
8010166a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101670:	01 d0                	add    %edx,%eax
80101672:	89 c2                	mov    %eax,%edx
80101674:	a1 60 32 11 80       	mov    0x80113260,%eax
80101679:	39 c2                	cmp    %eax,%edx
8010167b:	0f 82 3a ff ff ff    	jb     801015bb <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101681:	83 ec 0c             	sub    $0xc,%esp
80101684:	ff 75 ec             	pushl  -0x14(%ebp)
80101687:	e8 a2 eb ff ff       	call   8010022e <brelse>
8010168c:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010168f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101696:	8b 15 60 32 11 80    	mov    0x80113260,%edx
8010169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010169f:	39 c2                	cmp    %eax,%edx
801016a1:	0f 87 dc fe ff ff    	ja     80101583 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801016a7:	83 ec 0c             	sub    $0xc,%esp
801016aa:	68 20 a0 10 80       	push   $0x8010a020
801016af:	e8 b2 ee ff ff       	call   80100566 <panic>
}
801016b4:	c9                   	leave  
801016b5:	c3                   	ret    

801016b6 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016b6:	55                   	push   %ebp
801016b7:	89 e5                	mov    %esp,%ebp
801016b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801016bc:	83 ec 08             	sub    $0x8,%esp
801016bf:	68 60 32 11 80       	push   $0x80113260
801016c4:	ff 75 08             	pushl  0x8(%ebp)
801016c7:	e8 08 fe ff ff       	call   801014d4 <readsb>
801016cc:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801016cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801016d2:	c1 e8 0c             	shr    $0xc,%eax
801016d5:	89 c2                	mov    %eax,%edx
801016d7:	a1 78 32 11 80       	mov    0x80113278,%eax
801016dc:	01 c2                	add    %eax,%edx
801016de:	8b 45 08             	mov    0x8(%ebp),%eax
801016e1:	83 ec 08             	sub    $0x8,%esp
801016e4:	52                   	push   %edx
801016e5:	50                   	push   %eax
801016e6:	e8 cb ea ff ff       	call   801001b6 <bread>
801016eb:	83 c4 10             	add    $0x10,%esp
801016ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801016f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801016f4:	25 ff 0f 00 00       	and    $0xfff,%eax
801016f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016ff:	99                   	cltd   
80101700:	c1 ea 1d             	shr    $0x1d,%edx
80101703:	01 d0                	add    %edx,%eax
80101705:	83 e0 07             	and    $0x7,%eax
80101708:	29 d0                	sub    %edx,%eax
8010170a:	ba 01 00 00 00       	mov    $0x1,%edx
8010170f:	89 c1                	mov    %eax,%ecx
80101711:	d3 e2                	shl    %cl,%edx
80101713:	89 d0                	mov    %edx,%eax
80101715:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101718:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171b:	8d 50 07             	lea    0x7(%eax),%edx
8010171e:	85 c0                	test   %eax,%eax
80101720:	0f 48 c2             	cmovs  %edx,%eax
80101723:	c1 f8 03             	sar    $0x3,%eax
80101726:	89 c2                	mov    %eax,%edx
80101728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010172b:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101730:	0f b6 c0             	movzbl %al,%eax
80101733:	23 45 ec             	and    -0x14(%ebp),%eax
80101736:	85 c0                	test   %eax,%eax
80101738:	75 0d                	jne    80101747 <bfree+0x91>
    panic("freeing free block");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 36 a0 10 80       	push   $0x8010a036
80101742:	e8 1f ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
80101747:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174a:	8d 50 07             	lea    0x7(%eax),%edx
8010174d:	85 c0                	test   %eax,%eax
8010174f:	0f 48 c2             	cmovs  %edx,%eax
80101752:	c1 f8 03             	sar    $0x3,%eax
80101755:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101758:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010175d:	89 d1                	mov    %edx,%ecx
8010175f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101762:	f7 d2                	not    %edx
80101764:	21 ca                	and    %ecx,%edx
80101766:	89 d1                	mov    %edx,%ecx
80101768:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010176b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	ff 75 f4             	pushl  -0xc(%ebp)
80101775:	e8 12 22 00 00       	call   8010398c <log_write>
8010177a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010177d:	83 ec 0c             	sub    $0xc,%esp
80101780:	ff 75 f4             	pushl  -0xc(%ebp)
80101783:	e8 a6 ea ff ff       	call   8010022e <brelse>
80101788:	83 c4 10             	add    $0x10,%esp
}
8010178b:	90                   	nop
8010178c:	c9                   	leave  
8010178d:	c3                   	ret    

8010178e <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010178e:	55                   	push   %ebp
8010178f:	89 e5                	mov    %esp,%ebp
80101791:	57                   	push   %edi
80101792:	56                   	push   %esi
80101793:	53                   	push   %ebx
80101794:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101797:	83 ec 08             	sub    $0x8,%esp
8010179a:	68 49 a0 10 80       	push   $0x8010a049
8010179f:	68 80 32 11 80       	push   $0x80113280
801017a4:	e8 be 4e 00 00       	call   80106667 <initlock>
801017a9:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801017ac:	83 ec 08             	sub    $0x8,%esp
801017af:	68 60 32 11 80       	push   $0x80113260
801017b4:	ff 75 08             	pushl  0x8(%ebp)
801017b7:	e8 18 fd ff ff       	call   801014d4 <readsb>
801017bc:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801017bf:	a1 78 32 11 80       	mov    0x80113278,%eax
801017c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017c7:	8b 3d 74 32 11 80    	mov    0x80113274,%edi
801017cd:	8b 35 70 32 11 80    	mov    0x80113270,%esi
801017d3:	8b 1d 6c 32 11 80    	mov    0x8011326c,%ebx
801017d9:	8b 0d 68 32 11 80    	mov    0x80113268,%ecx
801017df:	8b 15 64 32 11 80    	mov    0x80113264,%edx
801017e5:	a1 60 32 11 80       	mov    0x80113260,%eax
801017ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801017ed:	57                   	push   %edi
801017ee:	56                   	push   %esi
801017ef:	53                   	push   %ebx
801017f0:	51                   	push   %ecx
801017f1:	52                   	push   %edx
801017f2:	50                   	push   %eax
801017f3:	68 50 a0 10 80       	push   $0x8010a050
801017f8:	e8 c9 eb ff ff       	call   801003c6 <cprintf>
801017fd:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101800:	90                   	nop
80101801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101804:	5b                   	pop    %ebx
80101805:	5e                   	pop    %esi
80101806:	5f                   	pop    %edi
80101807:	5d                   	pop    %ebp
80101808:	c3                   	ret    

80101809 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101809:	55                   	push   %ebp
8010180a:	89 e5                	mov    %esp,%ebp
8010180c:	83 ec 28             	sub    $0x28,%esp
8010180f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101812:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101816:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010181d:	e9 9e 00 00 00       	jmp    801018c0 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101825:	c1 e8 03             	shr    $0x3,%eax
80101828:	89 c2                	mov    %eax,%edx
8010182a:	a1 74 32 11 80       	mov    0x80113274,%eax
8010182f:	01 d0                	add    %edx,%eax
80101831:	83 ec 08             	sub    $0x8,%esp
80101834:	50                   	push   %eax
80101835:	ff 75 08             	pushl  0x8(%ebp)
80101838:	e8 79 e9 ff ff       	call   801001b6 <bread>
8010183d:	83 c4 10             	add    $0x10,%esp
80101840:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101846:	8d 50 18             	lea    0x18(%eax),%edx
80101849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184c:	83 e0 07             	and    $0x7,%eax
8010184f:	c1 e0 06             	shl    $0x6,%eax
80101852:	01 d0                	add    %edx,%eax
80101854:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101857:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010185a:	0f b7 00             	movzwl (%eax),%eax
8010185d:	66 85 c0             	test   %ax,%ax
80101860:	75 4c                	jne    801018ae <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101862:	83 ec 04             	sub    $0x4,%esp
80101865:	6a 40                	push   $0x40
80101867:	6a 00                	push   $0x0
80101869:	ff 75 ec             	pushl  -0x14(%ebp)
8010186c:	e8 7b 50 00 00       	call   801068ec <memset>
80101871:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101874:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101877:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010187b:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010187e:	83 ec 0c             	sub    $0xc,%esp
80101881:	ff 75 f0             	pushl  -0x10(%ebp)
80101884:	e8 03 21 00 00       	call   8010398c <log_write>
80101889:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	ff 75 f0             	pushl  -0x10(%ebp)
80101892:	e8 97 e9 ff ff       	call   8010022e <brelse>
80101897:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189d:	83 ec 08             	sub    $0x8,%esp
801018a0:	50                   	push   %eax
801018a1:	ff 75 08             	pushl  0x8(%ebp)
801018a4:	e8 20 01 00 00       	call   801019c9 <iget>
801018a9:	83 c4 10             	add    $0x10,%esp
801018ac:	eb 30                	jmp    801018de <ialloc+0xd5>
    }
    brelse(bp);
801018ae:	83 ec 0c             	sub    $0xc,%esp
801018b1:	ff 75 f0             	pushl  -0x10(%ebp)
801018b4:	e8 75 e9 ff ff       	call   8010022e <brelse>
801018b9:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018bc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801018c0:	8b 15 68 32 11 80    	mov    0x80113268,%edx
801018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c9:	39 c2                	cmp    %eax,%edx
801018cb:	0f 87 51 ff ff ff    	ja     80101822 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801018d1:	83 ec 0c             	sub    $0xc,%esp
801018d4:	68 a3 a0 10 80       	push   $0x8010a0a3
801018d9:	e8 88 ec ff ff       	call   80100566 <panic>
}
801018de:	c9                   	leave  
801018df:	c3                   	ret    

801018e0 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018e6:	8b 45 08             	mov    0x8(%ebp),%eax
801018e9:	8b 40 04             	mov    0x4(%eax),%eax
801018ec:	c1 e8 03             	shr    $0x3,%eax
801018ef:	89 c2                	mov    %eax,%edx
801018f1:	a1 74 32 11 80       	mov    0x80113274,%eax
801018f6:	01 c2                	add    %eax,%edx
801018f8:	8b 45 08             	mov    0x8(%ebp),%eax
801018fb:	8b 00                	mov    (%eax),%eax
801018fd:	83 ec 08             	sub    $0x8,%esp
80101900:	52                   	push   %edx
80101901:	50                   	push   %eax
80101902:	e8 af e8 ff ff       	call   801001b6 <bread>
80101907:	83 c4 10             	add    $0x10,%esp
8010190a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010190d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101910:	8d 50 18             	lea    0x18(%eax),%edx
80101913:	8b 45 08             	mov    0x8(%ebp),%eax
80101916:	8b 40 04             	mov    0x4(%eax),%eax
80101919:	83 e0 07             	and    $0x7,%eax
8010191c:	c1 e0 06             	shl    $0x6,%eax
8010191f:	01 d0                	add    %edx,%eax
80101921:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
80101927:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010192b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192e:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101931:	8b 45 08             	mov    0x8(%ebp),%eax
80101934:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101938:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193b:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010193f:	8b 45 08             	mov    0x8(%ebp),%eax
80101942:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101946:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101949:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010194d:	8b 45 08             	mov    0x8(%ebp),%eax
80101950:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101954:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101957:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010195b:	8b 45 08             	mov    0x8(%ebp),%eax
8010195e:	8b 50 18             	mov    0x18(%eax),%edx
80101961:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101964:	89 50 10             	mov    %edx,0x10(%eax)
#ifdef CS333_P5
  dip->uid = ip->uid;
80101967:	8b 45 08             	mov    0x8(%ebp),%eax
8010196a:	0f b7 50 48          	movzwl 0x48(%eax),%edx
8010196e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101971:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->gid = ip->gid;
80101975:	8b 45 08             	mov    0x8(%ebp),%eax
80101978:	0f b7 50 4a          	movzwl 0x4a(%eax),%edx
8010197c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197f:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode.asInt = ip->mode.asInt;
80101983:	8b 45 08             	mov    0x8(%ebp),%eax
80101986:	8b 50 4c             	mov    0x4c(%eax),%edx
80101989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198c:	89 50 0c             	mov    %edx,0xc(%eax)
#endif
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010198f:	8b 45 08             	mov    0x8(%ebp),%eax
80101992:	8d 50 1c             	lea    0x1c(%eax),%edx
80101995:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101998:	83 c0 14             	add    $0x14,%eax
8010199b:	83 ec 04             	sub    $0x4,%esp
8010199e:	6a 2c                	push   $0x2c
801019a0:	52                   	push   %edx
801019a1:	50                   	push   %eax
801019a2:	e8 04 50 00 00       	call   801069ab <memmove>
801019a7:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801019aa:	83 ec 0c             	sub    $0xc,%esp
801019ad:	ff 75 f4             	pushl  -0xc(%ebp)
801019b0:	e8 d7 1f 00 00       	call   8010398c <log_write>
801019b5:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801019b8:	83 ec 0c             	sub    $0xc,%esp
801019bb:	ff 75 f4             	pushl  -0xc(%ebp)
801019be:	e8 6b e8 ff ff       	call   8010022e <brelse>
801019c3:	83 c4 10             	add    $0x10,%esp
}
801019c6:	90                   	nop
801019c7:	c9                   	leave  
801019c8:	c3                   	ret    

801019c9 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019c9:	55                   	push   %ebp
801019ca:	89 e5                	mov    %esp,%ebp
801019cc:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801019cf:	83 ec 0c             	sub    $0xc,%esp
801019d2:	68 80 32 11 80       	push   $0x80113280
801019d7:	e8 ad 4c 00 00       	call   80106689 <acquire>
801019dc:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801019df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019e6:	c7 45 f4 b4 32 11 80 	movl   $0x801132b4,-0xc(%ebp)
801019ed:	eb 7c                	jmp    80101a6b <iget+0xa2>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f2:	8b 40 08             	mov    0x8(%eax),%eax
801019f5:	85 c0                	test   %eax,%eax
801019f7:	7e 58                	jle    80101a51 <iget+0x88>
801019f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019fc:	8b 00                	mov    (%eax),%eax
801019fe:	3b 45 08             	cmp    0x8(%ebp),%eax
80101a01:	75 4e                	jne    80101a51 <iget+0x88>
80101a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a06:	8b 40 04             	mov    0x4(%eax),%eax
80101a09:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101a0c:	75 43                	jne    80101a51 <iget+0x88>
      ip->ref++;
80101a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a11:	8b 40 08             	mov    0x8(%eax),%eax
80101a14:	8d 50 01             	lea    0x1(%eax),%edx
80101a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a1a:	89 50 08             	mov    %edx,0x8(%eax)
#ifdef CS333_P5
      ip->uid = DEFAULT_UID;
80101a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a20:	66 c7 40 48 00 00    	movw   $0x0,0x48(%eax)
      ip->gid = DEFAULT_UID;
80101a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a29:	66 c7 40 4a 00 00    	movw   $0x0,0x4a(%eax)
      ip->mode.asInt = 0755;
80101a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a32:	c7 40 4c ed 01 00 00 	movl   $0x1ed,0x4c(%eax)
#endif
      release(&icache.lock);
80101a39:	83 ec 0c             	sub    $0xc,%esp
80101a3c:	68 80 32 11 80       	push   $0x80113280
80101a41:	e8 aa 4c 00 00       	call   801066f0 <release>
80101a46:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a4c:	e9 94 00 00 00       	jmp    80101ae5 <iget+0x11c>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a55:	75 10                	jne    80101a67 <iget+0x9e>
80101a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5a:	8b 40 08             	mov    0x8(%eax),%eax
80101a5d:	85 c0                	test   %eax,%eax
80101a5f:	75 06                	jne    80101a67 <iget+0x9e>
      empty = ip;
80101a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a64:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a67:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101a6b:	81 7d f4 54 42 11 80 	cmpl   $0x80114254,-0xc(%ebp)
80101a72:	0f 82 77 ff ff ff    	jb     801019ef <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a7c:	75 0d                	jne    80101a8b <iget+0xc2>
    panic("iget: no inodes");
80101a7e:	83 ec 0c             	sub    $0xc,%esp
80101a81:	68 b5 a0 10 80       	push   $0x8010a0b5
80101a86:	e8 db ea ff ff       	call   80100566 <panic>

  ip = empty;
80101a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a94:	8b 55 08             	mov    0x8(%ebp),%edx
80101a97:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101a9f:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aa5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aaf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
#ifdef CS333_P5
  ip->uid = DEFAULT_UID;
80101ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ab9:	66 c7 40 48 00 00    	movw   $0x0,0x48(%eax)
  ip->gid = DEFAULT_UID;
80101abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac2:	66 c7 40 4a 00 00    	movw   $0x0,0x4a(%eax)
  ip->mode.asInt = 0755;
80101ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101acb:	c7 40 4c ed 01 00 00 	movl   $0x1ed,0x4c(%eax)
#endif

  release(&icache.lock);
80101ad2:	83 ec 0c             	sub    $0xc,%esp
80101ad5:	68 80 32 11 80       	push   $0x80113280
80101ada:	e8 11 4c 00 00       	call   801066f0 <release>
80101adf:	83 c4 10             	add    $0x10,%esp

  return ip;
80101ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101ae5:	c9                   	leave  
80101ae6:	c3                   	ret    

80101ae7 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101ae7:	55                   	push   %ebp
80101ae8:	89 e5                	mov    %esp,%ebp
80101aea:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101aed:	83 ec 0c             	sub    $0xc,%esp
80101af0:	68 80 32 11 80       	push   $0x80113280
80101af5:	e8 8f 4b 00 00       	call   80106689 <acquire>
80101afa:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	8b 40 08             	mov    0x8(%eax),%eax
80101b03:	8d 50 01             	lea    0x1(%eax),%edx
80101b06:	8b 45 08             	mov    0x8(%ebp),%eax
80101b09:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b0c:	83 ec 0c             	sub    $0xc,%esp
80101b0f:	68 80 32 11 80       	push   $0x80113280
80101b14:	e8 d7 4b 00 00       	call   801066f0 <release>
80101b19:	83 c4 10             	add    $0x10,%esp
  return ip;
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101b1f:	c9                   	leave  
80101b20:	c3                   	ret    

80101b21 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101b21:	55                   	push   %ebp
80101b22:	89 e5                	mov    %esp,%ebp
80101b24:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101b27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b2b:	74 0a                	je     80101b37 <ilock+0x16>
80101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b30:	8b 40 08             	mov    0x8(%eax),%eax
80101b33:	85 c0                	test   %eax,%eax
80101b35:	7f 0d                	jg     80101b44 <ilock+0x23>
    panic("ilock");
80101b37:	83 ec 0c             	sub    $0xc,%esp
80101b3a:	68 c5 a0 10 80       	push   $0x8010a0c5
80101b3f:	e8 22 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	68 80 32 11 80       	push   $0x80113280
80101b4c:	e8 38 4b 00 00       	call   80106689 <acquire>
80101b51:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101b54:	eb 13                	jmp    80101b69 <ilock+0x48>
    sleep(ip, &icache.lock);
80101b56:	83 ec 08             	sub    $0x8,%esp
80101b59:	68 80 32 11 80       	push   $0x80113280
80101b5e:	ff 75 08             	pushl  0x8(%ebp)
80101b61:	e8 34 3a 00 00       	call   8010559a <sleep>
80101b66:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101b69:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6c:	8b 40 0c             	mov    0xc(%eax),%eax
80101b6f:	83 e0 01             	and    $0x1,%eax
80101b72:	85 c0                	test   %eax,%eax
80101b74:	75 e0                	jne    80101b56 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101b76:	8b 45 08             	mov    0x8(%ebp),%eax
80101b79:	8b 40 0c             	mov    0xc(%eax),%eax
80101b7c:	83 c8 01             	or     $0x1,%eax
80101b7f:	89 c2                	mov    %eax,%edx
80101b81:	8b 45 08             	mov    0x8(%ebp),%eax
80101b84:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101b87:	83 ec 0c             	sub    $0xc,%esp
80101b8a:	68 80 32 11 80       	push   $0x80113280
80101b8f:	e8 5c 4b 00 00       	call   801066f0 <release>
80101b94:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101b97:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9a:	8b 40 0c             	mov    0xc(%eax),%eax
80101b9d:	83 e0 02             	and    $0x2,%eax
80101ba0:	85 c0                	test   %eax,%eax
80101ba2:	0f 85 fc 00 00 00    	jne    80101ca4 <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bab:	8b 40 04             	mov    0x4(%eax),%eax
80101bae:	c1 e8 03             	shr    $0x3,%eax
80101bb1:	89 c2                	mov    %eax,%edx
80101bb3:	a1 74 32 11 80       	mov    0x80113274,%eax
80101bb8:	01 c2                	add    %eax,%edx
80101bba:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbd:	8b 00                	mov    (%eax),%eax
80101bbf:	83 ec 08             	sub    $0x8,%esp
80101bc2:	52                   	push   %edx
80101bc3:	50                   	push   %eax
80101bc4:	e8 ed e5 ff ff       	call   801001b6 <bread>
80101bc9:	83 c4 10             	add    $0x10,%esp
80101bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bd2:	8d 50 18             	lea    0x18(%eax),%edx
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	8b 40 04             	mov    0x4(%eax),%eax
80101bdb:	83 e0 07             	and    $0x7,%eax
80101bde:	c1 e0 06             	shl    $0x6,%eax
80101be1:	01 d0                	add    %edx,%eax
80101be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be9:	0f b7 10             	movzwl (%eax),%edx
80101bec:	8b 45 08             	mov    0x8(%ebp),%eax
80101bef:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf6:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfd:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c04:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101c08:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0b:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c12:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101c16:	8b 45 08             	mov    0x8(%ebp),%eax
80101c19:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c20:	8b 50 10             	mov    0x10(%eax),%edx
80101c23:	8b 45 08             	mov    0x8(%ebp),%eax
80101c26:	89 50 18             	mov    %edx,0x18(%eax)
#ifdef CS333_P5
    ip->uid = dip->uid;
80101c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c2c:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101c30:	8b 45 08             	mov    0x8(%ebp),%eax
80101c33:	66 89 50 48          	mov    %dx,0x48(%eax)
    ip->gid = dip->gid;
80101c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c3a:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c41:	66 89 50 4a          	mov    %dx,0x4a(%eax)
    ip->mode.asInt = dip->mode.asInt;
80101c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c48:	8b 50 0c             	mov    0xc(%eax),%edx
80101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4e:	89 50 4c             	mov    %edx,0x4c(%eax)
#endif
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c54:	8d 50 14             	lea    0x14(%eax),%edx
80101c57:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5a:	83 c0 1c             	add    $0x1c,%eax
80101c5d:	83 ec 04             	sub    $0x4,%esp
80101c60:	6a 2c                	push   $0x2c
80101c62:	52                   	push   %edx
80101c63:	50                   	push   %eax
80101c64:	e8 42 4d 00 00       	call   801069ab <memmove>
80101c69:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101c6c:	83 ec 0c             	sub    $0xc,%esp
80101c6f:	ff 75 f4             	pushl  -0xc(%ebp)
80101c72:	e8 b7 e5 ff ff       	call   8010022e <brelse>
80101c77:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7d:	8b 40 0c             	mov    0xc(%eax),%eax
80101c80:	83 c8 02             	or     $0x2,%eax
80101c83:	89 c2                	mov    %eax,%edx
80101c85:	8b 45 08             	mov    0x8(%ebp),%eax
80101c88:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101c8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101c92:	66 85 c0             	test   %ax,%ax
80101c95:	75 0d                	jne    80101ca4 <ilock+0x183>
      panic("ilock: no type");
80101c97:	83 ec 0c             	sub    $0xc,%esp
80101c9a:	68 cb a0 10 80       	push   $0x8010a0cb
80101c9f:	e8 c2 e8 ff ff       	call   80100566 <panic>
  }
}
80101ca4:	90                   	nop
80101ca5:	c9                   	leave  
80101ca6:	c3                   	ret    

80101ca7 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ca7:	55                   	push   %ebp
80101ca8:	89 e5                	mov    %esp,%ebp
80101caa:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101cad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101cb1:	74 17                	je     80101cca <iunlock+0x23>
80101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb6:	8b 40 0c             	mov    0xc(%eax),%eax
80101cb9:	83 e0 01             	and    $0x1,%eax
80101cbc:	85 c0                	test   %eax,%eax
80101cbe:	74 0a                	je     80101cca <iunlock+0x23>
80101cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc3:	8b 40 08             	mov    0x8(%eax),%eax
80101cc6:	85 c0                	test   %eax,%eax
80101cc8:	7f 0d                	jg     80101cd7 <iunlock+0x30>
    panic("iunlock");
80101cca:	83 ec 0c             	sub    $0xc,%esp
80101ccd:	68 da a0 10 80       	push   $0x8010a0da
80101cd2:	e8 8f e8 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101cd7:	83 ec 0c             	sub    $0xc,%esp
80101cda:	68 80 32 11 80       	push   $0x80113280
80101cdf:	e8 a5 49 00 00       	call   80106689 <acquire>
80101ce4:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cea:	8b 40 0c             	mov    0xc(%eax),%eax
80101ced:	83 e0 fe             	and    $0xfffffffe,%eax
80101cf0:	89 c2                	mov    %eax,%edx
80101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf5:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101cf8:	83 ec 0c             	sub    $0xc,%esp
80101cfb:	ff 75 08             	pushl  0x8(%ebp)
80101cfe:	e8 05 3a 00 00       	call   80105708 <wakeup>
80101d03:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101d06:	83 ec 0c             	sub    $0xc,%esp
80101d09:	68 80 32 11 80       	push   $0x80113280
80101d0e:	e8 dd 49 00 00       	call   801066f0 <release>
80101d13:	83 c4 10             	add    $0x10,%esp
}
80101d16:	90                   	nop
80101d17:	c9                   	leave  
80101d18:	c3                   	ret    

80101d19 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101d19:	55                   	push   %ebp
80101d1a:	89 e5                	mov    %esp,%ebp
80101d1c:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	68 80 32 11 80       	push   $0x80113280
80101d27:	e8 5d 49 00 00       	call   80106689 <acquire>
80101d2c:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101d2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d32:	8b 40 08             	mov    0x8(%eax),%eax
80101d35:	83 f8 01             	cmp    $0x1,%eax
80101d38:	0f 85 a9 00 00 00    	jne    80101de7 <iput+0xce>
80101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d41:	8b 40 0c             	mov    0xc(%eax),%eax
80101d44:	83 e0 02             	and    $0x2,%eax
80101d47:	85 c0                	test   %eax,%eax
80101d49:	0f 84 98 00 00 00    	je     80101de7 <iput+0xce>
80101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d52:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101d56:	66 85 c0             	test   %ax,%ax
80101d59:	0f 85 88 00 00 00    	jne    80101de7 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d62:	8b 40 0c             	mov    0xc(%eax),%eax
80101d65:	83 e0 01             	and    $0x1,%eax
80101d68:	85 c0                	test   %eax,%eax
80101d6a:	74 0d                	je     80101d79 <iput+0x60>
      panic("iput busy");
80101d6c:	83 ec 0c             	sub    $0xc,%esp
80101d6f:	68 e2 a0 10 80       	push   $0x8010a0e2
80101d74:	e8 ed e7 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101d79:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7c:	8b 40 0c             	mov    0xc(%eax),%eax
80101d7f:	83 c8 01             	or     $0x1,%eax
80101d82:	89 c2                	mov    %eax,%edx
80101d84:	8b 45 08             	mov    0x8(%ebp),%eax
80101d87:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101d8a:	83 ec 0c             	sub    $0xc,%esp
80101d8d:	68 80 32 11 80       	push   $0x80113280
80101d92:	e8 59 49 00 00       	call   801066f0 <release>
80101d97:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101d9a:	83 ec 0c             	sub    $0xc,%esp
80101d9d:	ff 75 08             	pushl  0x8(%ebp)
80101da0:	e8 a8 01 00 00       	call   80101f4d <itrunc>
80101da5:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101da8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dab:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101db1:	83 ec 0c             	sub    $0xc,%esp
80101db4:	ff 75 08             	pushl  0x8(%ebp)
80101db7:	e8 24 fb ff ff       	call   801018e0 <iupdate>
80101dbc:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
80101dc2:	68 80 32 11 80       	push   $0x80113280
80101dc7:	e8 bd 48 00 00       	call   80106689 <acquire>
80101dcc:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101dcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101dd9:	83 ec 0c             	sub    $0xc,%esp
80101ddc:	ff 75 08             	pushl  0x8(%ebp)
80101ddf:	e8 24 39 00 00       	call   80105708 <wakeup>
80101de4:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101de7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dea:	8b 40 08             	mov    0x8(%eax),%eax
80101ded:	8d 50 ff             	lea    -0x1(%eax),%edx
80101df0:	8b 45 08             	mov    0x8(%ebp),%eax
80101df3:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	68 80 32 11 80       	push   $0x80113280
80101dfe:	e8 ed 48 00 00       	call   801066f0 <release>
80101e03:	83 c4 10             	add    $0x10,%esp
}
80101e06:	90                   	nop
80101e07:	c9                   	leave  
80101e08:	c3                   	ret    

80101e09 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101e09:	55                   	push   %ebp
80101e0a:	89 e5                	mov    %esp,%ebp
80101e0c:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101e0f:	83 ec 0c             	sub    $0xc,%esp
80101e12:	ff 75 08             	pushl  0x8(%ebp)
80101e15:	e8 8d fe ff ff       	call   80101ca7 <iunlock>
80101e1a:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101e1d:	83 ec 0c             	sub    $0xc,%esp
80101e20:	ff 75 08             	pushl  0x8(%ebp)
80101e23:	e8 f1 fe ff ff       	call   80101d19 <iput>
80101e28:	83 c4 10             	add    $0x10,%esp
}
80101e2b:	90                   	nop
80101e2c:	c9                   	leave  
80101e2d:	c3                   	ret    

80101e2e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101e2e:	55                   	push   %ebp
80101e2f:	89 e5                	mov    %esp,%ebp
80101e31:	53                   	push   %ebx
80101e32:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101e35:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101e39:	77 42                	ja     80101e7d <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e41:	83 c2 04             	add    $0x4,%edx
80101e44:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e4f:	75 24                	jne    80101e75 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e51:	8b 45 08             	mov    0x8(%ebp),%eax
80101e54:	8b 00                	mov    (%eax),%eax
80101e56:	83 ec 0c             	sub    $0xc,%esp
80101e59:	50                   	push   %eax
80101e5a:	e8 0b f7 ff ff       	call   8010156a <balloc>
80101e5f:	83 c4 10             	add    $0x10,%esp
80101e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e65:	8b 45 08             	mov    0x8(%ebp),%eax
80101e68:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e6b:	8d 4a 04             	lea    0x4(%edx),%ecx
80101e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e71:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e78:	e9 cb 00 00 00       	jmp    80101f48 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101e7d:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101e81:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101e85:	0f 87 b0 00 00 00    	ja     80101f3b <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8e:	8b 40 44             	mov    0x44(%eax),%eax
80101e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e98:	75 1d                	jne    80101eb7 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9d:	8b 00                	mov    (%eax),%eax
80101e9f:	83 ec 0c             	sub    $0xc,%esp
80101ea2:	50                   	push   %eax
80101ea3:	e8 c2 f6 ff ff       	call   8010156a <balloc>
80101ea8:	83 c4 10             	add    $0x10,%esp
80101eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101eae:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101eb4:	89 50 44             	mov    %edx,0x44(%eax)
    bp = bread(ip->dev, addr);
80101eb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eba:	8b 00                	mov    (%eax),%eax
80101ebc:	83 ec 08             	sub    $0x8,%esp
80101ebf:	ff 75 f4             	pushl  -0xc(%ebp)
80101ec2:	50                   	push   %eax
80101ec3:	e8 ee e2 ff ff       	call   801001b6 <bread>
80101ec8:	83 c4 10             	add    $0x10,%esp
80101ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ed1:	83 c0 18             	add    $0x18,%eax
80101ed4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ee4:	01 d0                	add    %edx,%eax
80101ee6:	8b 00                	mov    (%eax),%eax
80101ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101eef:	75 37                	jne    80101f28 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ef4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101efe:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101f01:	8b 45 08             	mov    0x8(%ebp),%eax
80101f04:	8b 00                	mov    (%eax),%eax
80101f06:	83 ec 0c             	sub    $0xc,%esp
80101f09:	50                   	push   %eax
80101f0a:	e8 5b f6 ff ff       	call   8010156a <balloc>
80101f0f:	83 c4 10             	add    $0x10,%esp
80101f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f18:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101f1a:	83 ec 0c             	sub    $0xc,%esp
80101f1d:	ff 75 f0             	pushl  -0x10(%ebp)
80101f20:	e8 67 1a 00 00       	call   8010398c <log_write>
80101f25:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101f28:	83 ec 0c             	sub    $0xc,%esp
80101f2b:	ff 75 f0             	pushl  -0x10(%ebp)
80101f2e:	e8 fb e2 ff ff       	call   8010022e <brelse>
80101f33:	83 c4 10             	add    $0x10,%esp
    return addr;
80101f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f39:	eb 0d                	jmp    80101f48 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101f3b:	83 ec 0c             	sub    $0xc,%esp
80101f3e:	68 ec a0 10 80       	push   $0x8010a0ec
80101f43:	e8 1e e6 ff ff       	call   80100566 <panic>
}
80101f48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f4b:	c9                   	leave  
80101f4c:	c3                   	ret    

80101f4d <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101f4d:	55                   	push   %ebp
80101f4e:	89 e5                	mov    %esp,%ebp
80101f50:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f5a:	eb 45                	jmp    80101fa1 <itrunc+0x54>
    if(ip->addrs[i]){
80101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f62:	83 c2 04             	add    $0x4,%edx
80101f65:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101f69:	85 c0                	test   %eax,%eax
80101f6b:	74 30                	je     80101f9d <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f73:	83 c2 04             	add    $0x4,%edx
80101f76:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101f7a:	8b 55 08             	mov    0x8(%ebp),%edx
80101f7d:	8b 12                	mov    (%edx),%edx
80101f7f:	83 ec 08             	sub    $0x8,%esp
80101f82:	50                   	push   %eax
80101f83:	52                   	push   %edx
80101f84:	e8 2d f7 ff ff       	call   801016b6 <bfree>
80101f89:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f92:	83 c2 04             	add    $0x4,%edx
80101f95:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101f9c:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f9d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101fa1:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101fa5:	7e b5                	jle    80101f5c <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101faa:	8b 40 44             	mov    0x44(%eax),%eax
80101fad:	85 c0                	test   %eax,%eax
80101faf:	0f 84 a1 00 00 00    	je     80102056 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101fb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb8:	8b 50 44             	mov    0x44(%eax),%edx
80101fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbe:	8b 00                	mov    (%eax),%eax
80101fc0:	83 ec 08             	sub    $0x8,%esp
80101fc3:	52                   	push   %edx
80101fc4:	50                   	push   %eax
80101fc5:	e8 ec e1 ff ff       	call   801001b6 <bread>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd3:	83 c0 18             	add    $0x18,%eax
80101fd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101fd9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101fe0:	eb 3c                	jmp    8010201e <itrunc+0xd1>
      if(a[j])
80101fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fef:	01 d0                	add    %edx,%eax
80101ff1:	8b 00                	mov    (%eax),%eax
80101ff3:	85 c0                	test   %eax,%eax
80101ff5:	74 23                	je     8010201a <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ffa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80102001:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102004:	01 d0                	add    %edx,%eax
80102006:	8b 00                	mov    (%eax),%eax
80102008:	8b 55 08             	mov    0x8(%ebp),%edx
8010200b:	8b 12                	mov    (%edx),%edx
8010200d:	83 ec 08             	sub    $0x8,%esp
80102010:	50                   	push   %eax
80102011:	52                   	push   %edx
80102012:	e8 9f f6 ff ff       	call   801016b6 <bfree>
80102017:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010201a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010201e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102021:	83 f8 7f             	cmp    $0x7f,%eax
80102024:	76 bc                	jbe    80101fe2 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80102026:	83 ec 0c             	sub    $0xc,%esp
80102029:	ff 75 ec             	pushl  -0x14(%ebp)
8010202c:	e8 fd e1 ff ff       	call   8010022e <brelse>
80102031:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102034:	8b 45 08             	mov    0x8(%ebp),%eax
80102037:	8b 40 44             	mov    0x44(%eax),%eax
8010203a:	8b 55 08             	mov    0x8(%ebp),%edx
8010203d:	8b 12                	mov    (%edx),%edx
8010203f:	83 ec 08             	sub    $0x8,%esp
80102042:	50                   	push   %eax
80102043:	52                   	push   %edx
80102044:	e8 6d f6 ff ff       	call   801016b6 <bfree>
80102049:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
  }

  ip->size = 0;
80102056:	8b 45 08             	mov    0x8(%ebp),%eax
80102059:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80102060:	83 ec 0c             	sub    $0xc,%esp
80102063:	ff 75 08             	pushl  0x8(%ebp)
80102066:	e8 75 f8 ff ff       	call   801018e0 <iupdate>
8010206b:	83 c4 10             	add    $0x10,%esp
}
8010206e:	90                   	nop
8010206f:	c9                   	leave  
80102070:	c3                   	ret    

80102071 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80102071:	55                   	push   %ebp
80102072:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80102074:	8b 45 08             	mov    0x8(%ebp),%eax
80102077:	8b 00                	mov    (%eax),%eax
80102079:	89 c2                	mov    %eax,%edx
8010207b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207e:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102081:	8b 45 08             	mov    0x8(%ebp),%eax
80102084:	8b 50 04             	mov    0x4(%eax),%edx
80102087:	8b 45 0c             	mov    0xc(%ebp),%eax
8010208a:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
8010208d:	8b 45 08             	mov    0x8(%ebp),%eax
80102090:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80102094:	8b 45 0c             	mov    0xc(%ebp),%eax
80102097:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
8010209a:	8b 45 08             	mov    0x8(%ebp),%eax
8010209d:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801020a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801020a4:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8b 50 18             	mov    0x18(%eax),%edx
801020ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801020b1:	89 50 10             	mov    %edx,0x10(%eax)
#ifdef CS333_P5
  st->uid = ip->uid;
801020b4:	8b 45 08             	mov    0x8(%ebp),%eax
801020b7:	0f b7 50 48          	movzwl 0x48(%eax),%edx
801020bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801020be:	66 89 50 14          	mov    %dx,0x14(%eax)
  st->gid = ip->gid;
801020c2:	8b 45 08             	mov    0x8(%ebp),%eax
801020c5:	0f b7 50 4a          	movzwl 0x4a(%eax),%edx
801020c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801020cc:	66 89 50 16          	mov    %dx,0x16(%eax)
  st->mode.asInt = ip->mode.asInt;
801020d0:	8b 45 08             	mov    0x8(%ebp),%eax
801020d3:	8b 50 4c             	mov    0x4c(%eax),%edx
801020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801020d9:	89 50 18             	mov    %edx,0x18(%eax)
#endif
}
801020dc:	90                   	nop
801020dd:	5d                   	pop    %ebp
801020de:	c3                   	ret    

801020df <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801020df:	55                   	push   %ebp
801020e0:	89 e5                	mov    %esp,%ebp
801020e2:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020e5:	8b 45 08             	mov    0x8(%ebp),%eax
801020e8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020ec:	66 83 f8 03          	cmp    $0x3,%ax
801020f0:	75 5c                	jne    8010214e <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801020f2:	8b 45 08             	mov    0x8(%ebp),%eax
801020f5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020f9:	66 85 c0             	test   %ax,%ax
801020fc:	78 20                	js     8010211e <readi+0x3f>
801020fe:	8b 45 08             	mov    0x8(%ebp),%eax
80102101:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102105:	66 83 f8 09          	cmp    $0x9,%ax
80102109:	7f 13                	jg     8010211e <readi+0x3f>
8010210b:	8b 45 08             	mov    0x8(%ebp),%eax
8010210e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102112:	98                   	cwtl   
80102113:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
8010211a:	85 c0                	test   %eax,%eax
8010211c:	75 0a                	jne    80102128 <readi+0x49>
      return -1;
8010211e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102123:	e9 0c 01 00 00       	jmp    80102234 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010212f:	98                   	cwtl   
80102130:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
80102137:	8b 55 14             	mov    0x14(%ebp),%edx
8010213a:	83 ec 04             	sub    $0x4,%esp
8010213d:	52                   	push   %edx
8010213e:	ff 75 0c             	pushl  0xc(%ebp)
80102141:	ff 75 08             	pushl  0x8(%ebp)
80102144:	ff d0                	call   *%eax
80102146:	83 c4 10             	add    $0x10,%esp
80102149:	e9 e6 00 00 00       	jmp    80102234 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
8010214e:	8b 45 08             	mov    0x8(%ebp),%eax
80102151:	8b 40 18             	mov    0x18(%eax),%eax
80102154:	3b 45 10             	cmp    0x10(%ebp),%eax
80102157:	72 0d                	jb     80102166 <readi+0x87>
80102159:	8b 55 10             	mov    0x10(%ebp),%edx
8010215c:	8b 45 14             	mov    0x14(%ebp),%eax
8010215f:	01 d0                	add    %edx,%eax
80102161:	3b 45 10             	cmp    0x10(%ebp),%eax
80102164:	73 0a                	jae    80102170 <readi+0x91>
    return -1;
80102166:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010216b:	e9 c4 00 00 00       	jmp    80102234 <readi+0x155>
  if(off + n > ip->size)
80102170:	8b 55 10             	mov    0x10(%ebp),%edx
80102173:	8b 45 14             	mov    0x14(%ebp),%eax
80102176:	01 c2                	add    %eax,%edx
80102178:	8b 45 08             	mov    0x8(%ebp),%eax
8010217b:	8b 40 18             	mov    0x18(%eax),%eax
8010217e:	39 c2                	cmp    %eax,%edx
80102180:	76 0c                	jbe    8010218e <readi+0xaf>
    n = ip->size - off;
80102182:	8b 45 08             	mov    0x8(%ebp),%eax
80102185:	8b 40 18             	mov    0x18(%eax),%eax
80102188:	2b 45 10             	sub    0x10(%ebp),%eax
8010218b:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010218e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102195:	e9 8b 00 00 00       	jmp    80102225 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010219a:	8b 45 10             	mov    0x10(%ebp),%eax
8010219d:	c1 e8 09             	shr    $0x9,%eax
801021a0:	83 ec 08             	sub    $0x8,%esp
801021a3:	50                   	push   %eax
801021a4:	ff 75 08             	pushl  0x8(%ebp)
801021a7:	e8 82 fc ff ff       	call   80101e2e <bmap>
801021ac:	83 c4 10             	add    $0x10,%esp
801021af:	89 c2                	mov    %eax,%edx
801021b1:	8b 45 08             	mov    0x8(%ebp),%eax
801021b4:	8b 00                	mov    (%eax),%eax
801021b6:	83 ec 08             	sub    $0x8,%esp
801021b9:	52                   	push   %edx
801021ba:	50                   	push   %eax
801021bb:	e8 f6 df ff ff       	call   801001b6 <bread>
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021c6:	8b 45 10             	mov    0x10(%ebp),%eax
801021c9:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ce:	ba 00 02 00 00       	mov    $0x200,%edx
801021d3:	29 c2                	sub    %eax,%edx
801021d5:	8b 45 14             	mov    0x14(%ebp),%eax
801021d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021db:	39 c2                	cmp    %eax,%edx
801021dd:	0f 46 c2             	cmovbe %edx,%eax
801021e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801021e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021e6:	8d 50 18             	lea    0x18(%eax),%edx
801021e9:	8b 45 10             	mov    0x10(%ebp),%eax
801021ec:	25 ff 01 00 00       	and    $0x1ff,%eax
801021f1:	01 d0                	add    %edx,%eax
801021f3:	83 ec 04             	sub    $0x4,%esp
801021f6:	ff 75 ec             	pushl  -0x14(%ebp)
801021f9:	50                   	push   %eax
801021fa:	ff 75 0c             	pushl  0xc(%ebp)
801021fd:	e8 a9 47 00 00       	call   801069ab <memmove>
80102202:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	ff 75 f0             	pushl  -0x10(%ebp)
8010220b:	e8 1e e0 ff ff       	call   8010022e <brelse>
80102210:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102213:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102216:	01 45 f4             	add    %eax,-0xc(%ebp)
80102219:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010221c:	01 45 10             	add    %eax,0x10(%ebp)
8010221f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102222:	01 45 0c             	add    %eax,0xc(%ebp)
80102225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102228:	3b 45 14             	cmp    0x14(%ebp),%eax
8010222b:	0f 82 69 ff ff ff    	jb     8010219a <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102231:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102234:	c9                   	leave  
80102235:	c3                   	ret    

80102236 <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102236:	55                   	push   %ebp
80102237:	89 e5                	mov    %esp,%ebp
80102239:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010223c:	8b 45 08             	mov    0x8(%ebp),%eax
8010223f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102243:	66 83 f8 03          	cmp    $0x3,%ax
80102247:	75 5c                	jne    801022a5 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102249:	8b 45 08             	mov    0x8(%ebp),%eax
8010224c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102250:	66 85 c0             	test   %ax,%ax
80102253:	78 20                	js     80102275 <writei+0x3f>
80102255:	8b 45 08             	mov    0x8(%ebp),%eax
80102258:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010225c:	66 83 f8 09          	cmp    $0x9,%ax
80102260:	7f 13                	jg     80102275 <writei+0x3f>
80102262:	8b 45 08             	mov    0x8(%ebp),%eax
80102265:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102269:	98                   	cwtl   
8010226a:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
80102271:	85 c0                	test   %eax,%eax
80102273:	75 0a                	jne    8010227f <writei+0x49>
      return -1;
80102275:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010227a:	e9 3d 01 00 00       	jmp    801023bc <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010227f:	8b 45 08             	mov    0x8(%ebp),%eax
80102282:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102286:	98                   	cwtl   
80102287:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
8010228e:	8b 55 14             	mov    0x14(%ebp),%edx
80102291:	83 ec 04             	sub    $0x4,%esp
80102294:	52                   	push   %edx
80102295:	ff 75 0c             	pushl  0xc(%ebp)
80102298:	ff 75 08             	pushl  0x8(%ebp)
8010229b:	ff d0                	call   *%eax
8010229d:	83 c4 10             	add    $0x10,%esp
801022a0:	e9 17 01 00 00       	jmp    801023bc <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801022a5:	8b 45 08             	mov    0x8(%ebp),%eax
801022a8:	8b 40 18             	mov    0x18(%eax),%eax
801022ab:	3b 45 10             	cmp    0x10(%ebp),%eax
801022ae:	72 0d                	jb     801022bd <writei+0x87>
801022b0:	8b 55 10             	mov    0x10(%ebp),%edx
801022b3:	8b 45 14             	mov    0x14(%ebp),%eax
801022b6:	01 d0                	add    %edx,%eax
801022b8:	3b 45 10             	cmp    0x10(%ebp),%eax
801022bb:	73 0a                	jae    801022c7 <writei+0x91>
    return -1;
801022bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022c2:	e9 f5 00 00 00       	jmp    801023bc <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801022c7:	8b 55 10             	mov    0x10(%ebp),%edx
801022ca:	8b 45 14             	mov    0x14(%ebp),%eax
801022cd:	01 d0                	add    %edx,%eax
801022cf:	3d 00 14 01 00       	cmp    $0x11400,%eax
801022d4:	76 0a                	jbe    801022e0 <writei+0xaa>
    return -1;
801022d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022db:	e9 dc 00 00 00       	jmp    801023bc <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022e7:	e9 99 00 00 00       	jmp    80102385 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022ec:	8b 45 10             	mov    0x10(%ebp),%eax
801022ef:	c1 e8 09             	shr    $0x9,%eax
801022f2:	83 ec 08             	sub    $0x8,%esp
801022f5:	50                   	push   %eax
801022f6:	ff 75 08             	pushl  0x8(%ebp)
801022f9:	e8 30 fb ff ff       	call   80101e2e <bmap>
801022fe:	83 c4 10             	add    $0x10,%esp
80102301:	89 c2                	mov    %eax,%edx
80102303:	8b 45 08             	mov    0x8(%ebp),%eax
80102306:	8b 00                	mov    (%eax),%eax
80102308:	83 ec 08             	sub    $0x8,%esp
8010230b:	52                   	push   %edx
8010230c:	50                   	push   %eax
8010230d:	e8 a4 de ff ff       	call   801001b6 <bread>
80102312:	83 c4 10             	add    $0x10,%esp
80102315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102318:	8b 45 10             	mov    0x10(%ebp),%eax
8010231b:	25 ff 01 00 00       	and    $0x1ff,%eax
80102320:	ba 00 02 00 00       	mov    $0x200,%edx
80102325:	29 c2                	sub    %eax,%edx
80102327:	8b 45 14             	mov    0x14(%ebp),%eax
8010232a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010232d:	39 c2                	cmp    %eax,%edx
8010232f:	0f 46 c2             	cmovbe %edx,%eax
80102332:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102335:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102338:	8d 50 18             	lea    0x18(%eax),%edx
8010233b:	8b 45 10             	mov    0x10(%ebp),%eax
8010233e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102343:	01 d0                	add    %edx,%eax
80102345:	83 ec 04             	sub    $0x4,%esp
80102348:	ff 75 ec             	pushl  -0x14(%ebp)
8010234b:	ff 75 0c             	pushl  0xc(%ebp)
8010234e:	50                   	push   %eax
8010234f:	e8 57 46 00 00       	call   801069ab <memmove>
80102354:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	ff 75 f0             	pushl  -0x10(%ebp)
8010235d:	e8 2a 16 00 00       	call   8010398c <log_write>
80102362:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102365:	83 ec 0c             	sub    $0xc,%esp
80102368:	ff 75 f0             	pushl  -0x10(%ebp)
8010236b:	e8 be de ff ff       	call   8010022e <brelse>
80102370:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102373:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102376:	01 45 f4             	add    %eax,-0xc(%ebp)
80102379:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010237c:	01 45 10             	add    %eax,0x10(%ebp)
8010237f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102382:	01 45 0c             	add    %eax,0xc(%ebp)
80102385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102388:	3b 45 14             	cmp    0x14(%ebp),%eax
8010238b:	0f 82 5b ff ff ff    	jb     801022ec <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102391:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102395:	74 22                	je     801023b9 <writei+0x183>
80102397:	8b 45 08             	mov    0x8(%ebp),%eax
8010239a:	8b 40 18             	mov    0x18(%eax),%eax
8010239d:	3b 45 10             	cmp    0x10(%ebp),%eax
801023a0:	73 17                	jae    801023b9 <writei+0x183>
    ip->size = off;
801023a2:	8b 45 08             	mov    0x8(%ebp),%eax
801023a5:	8b 55 10             	mov    0x10(%ebp),%edx
801023a8:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801023ab:	83 ec 0c             	sub    $0xc,%esp
801023ae:	ff 75 08             	pushl  0x8(%ebp)
801023b1:	e8 2a f5 ff ff       	call   801018e0 <iupdate>
801023b6:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801023b9:	8b 45 14             	mov    0x14(%ebp),%eax
}
801023bc:	c9                   	leave  
801023bd:	c3                   	ret    

801023be <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
801023be:	55                   	push   %ebp
801023bf:	89 e5                	mov    %esp,%ebp
801023c1:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801023c4:	83 ec 04             	sub    $0x4,%esp
801023c7:	6a 0e                	push   $0xe
801023c9:	ff 75 0c             	pushl  0xc(%ebp)
801023cc:	ff 75 08             	pushl  0x8(%ebp)
801023cf:	e8 6d 46 00 00       	call   80106a41 <strncmp>
801023d4:	83 c4 10             	add    $0x10,%esp
}
801023d7:	c9                   	leave  
801023d8:	c3                   	ret    

801023d9 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801023d9:	55                   	push   %ebp
801023da:	89 e5                	mov    %esp,%ebp
801023dc:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801023df:	8b 45 08             	mov    0x8(%ebp),%eax
801023e2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023e6:	66 83 f8 01          	cmp    $0x1,%ax
801023ea:	74 0d                	je     801023f9 <dirlookup+0x20>
    panic("dirlookup not DIR");
801023ec:	83 ec 0c             	sub    $0xc,%esp
801023ef:	68 ff a0 10 80       	push   $0x8010a0ff
801023f4:	e8 6d e1 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801023f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102400:	eb 7b                	jmp    8010247d <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102402:	6a 10                	push   $0x10
80102404:	ff 75 f4             	pushl  -0xc(%ebp)
80102407:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010240a:	50                   	push   %eax
8010240b:	ff 75 08             	pushl  0x8(%ebp)
8010240e:	e8 cc fc ff ff       	call   801020df <readi>
80102413:	83 c4 10             	add    $0x10,%esp
80102416:	83 f8 10             	cmp    $0x10,%eax
80102419:	74 0d                	je     80102428 <dirlookup+0x4f>
      panic("dirlink read");
8010241b:	83 ec 0c             	sub    $0xc,%esp
8010241e:	68 11 a1 10 80       	push   $0x8010a111
80102423:	e8 3e e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102428:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010242c:	66 85 c0             	test   %ax,%ax
8010242f:	74 47                	je     80102478 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102431:	83 ec 08             	sub    $0x8,%esp
80102434:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102437:	83 c0 02             	add    $0x2,%eax
8010243a:	50                   	push   %eax
8010243b:	ff 75 0c             	pushl  0xc(%ebp)
8010243e:	e8 7b ff ff ff       	call   801023be <namecmp>
80102443:	83 c4 10             	add    $0x10,%esp
80102446:	85 c0                	test   %eax,%eax
80102448:	75 2f                	jne    80102479 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
8010244a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010244e:	74 08                	je     80102458 <dirlookup+0x7f>
        *poff = off;
80102450:	8b 45 10             	mov    0x10(%ebp),%eax
80102453:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102456:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102458:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010245c:	0f b7 c0             	movzwl %ax,%eax
8010245f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102462:	8b 45 08             	mov    0x8(%ebp),%eax
80102465:	8b 00                	mov    (%eax),%eax
80102467:	83 ec 08             	sub    $0x8,%esp
8010246a:	ff 75 f0             	pushl  -0x10(%ebp)
8010246d:	50                   	push   %eax
8010246e:	e8 56 f5 ff ff       	call   801019c9 <iget>
80102473:	83 c4 10             	add    $0x10,%esp
80102476:	eb 19                	jmp    80102491 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102478:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102479:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010247d:	8b 45 08             	mov    0x8(%ebp),%eax
80102480:	8b 40 18             	mov    0x18(%eax),%eax
80102483:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102486:	0f 87 76 ff ff ff    	ja     80102402 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010248c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102491:	c9                   	leave  
80102492:	c3                   	ret    

80102493 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102493:	55                   	push   %ebp
80102494:	89 e5                	mov    %esp,%ebp
80102496:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102499:	83 ec 04             	sub    $0x4,%esp
8010249c:	6a 00                	push   $0x0
8010249e:	ff 75 0c             	pushl  0xc(%ebp)
801024a1:	ff 75 08             	pushl  0x8(%ebp)
801024a4:	e8 30 ff ff ff       	call   801023d9 <dirlookup>
801024a9:	83 c4 10             	add    $0x10,%esp
801024ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024b3:	74 18                	je     801024cd <dirlink+0x3a>
    iput(ip);
801024b5:	83 ec 0c             	sub    $0xc,%esp
801024b8:	ff 75 f0             	pushl  -0x10(%ebp)
801024bb:	e8 59 f8 ff ff       	call   80101d19 <iput>
801024c0:	83 c4 10             	add    $0x10,%esp
    return -1;
801024c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024c8:	e9 9c 00 00 00       	jmp    80102569 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801024d4:	eb 39                	jmp    8010250f <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024d9:	6a 10                	push   $0x10
801024db:	50                   	push   %eax
801024dc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024df:	50                   	push   %eax
801024e0:	ff 75 08             	pushl  0x8(%ebp)
801024e3:	e8 f7 fb ff ff       	call   801020df <readi>
801024e8:	83 c4 10             	add    $0x10,%esp
801024eb:	83 f8 10             	cmp    $0x10,%eax
801024ee:	74 0d                	je     801024fd <dirlink+0x6a>
      panic("dirlink read");
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	68 11 a1 10 80       	push   $0x8010a111
801024f8:	e8 69 e0 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801024fd:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102501:	66 85 c0             	test   %ax,%ax
80102504:	74 18                	je     8010251e <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102506:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102509:	83 c0 10             	add    $0x10,%eax
8010250c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010250f:	8b 45 08             	mov    0x8(%ebp),%eax
80102512:	8b 50 18             	mov    0x18(%eax),%edx
80102515:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102518:	39 c2                	cmp    %eax,%edx
8010251a:	77 ba                	ja     801024d6 <dirlink+0x43>
8010251c:	eb 01                	jmp    8010251f <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
8010251e:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010251f:	83 ec 04             	sub    $0x4,%esp
80102522:	6a 0e                	push   $0xe
80102524:	ff 75 0c             	pushl  0xc(%ebp)
80102527:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010252a:	83 c0 02             	add    $0x2,%eax
8010252d:	50                   	push   %eax
8010252e:	e8 64 45 00 00       	call   80106a97 <strncpy>
80102533:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102536:	8b 45 10             	mov    0x10(%ebp),%eax
80102539:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102540:	6a 10                	push   $0x10
80102542:	50                   	push   %eax
80102543:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102546:	50                   	push   %eax
80102547:	ff 75 08             	pushl  0x8(%ebp)
8010254a:	e8 e7 fc ff ff       	call   80102236 <writei>
8010254f:	83 c4 10             	add    $0x10,%esp
80102552:	83 f8 10             	cmp    $0x10,%eax
80102555:	74 0d                	je     80102564 <dirlink+0xd1>
    panic("dirlink");
80102557:	83 ec 0c             	sub    $0xc,%esp
8010255a:	68 1e a1 10 80       	push   $0x8010a11e
8010255f:	e8 02 e0 ff ff       	call   80100566 <panic>
  
  return 0;
80102564:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102569:	c9                   	leave  
8010256a:	c3                   	ret    

8010256b <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010256b:	55                   	push   %ebp
8010256c:	89 e5                	mov    %esp,%ebp
8010256e:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102571:	eb 04                	jmp    80102577 <skipelem+0xc>
    path++;
80102573:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102577:	8b 45 08             	mov    0x8(%ebp),%eax
8010257a:	0f b6 00             	movzbl (%eax),%eax
8010257d:	3c 2f                	cmp    $0x2f,%al
8010257f:	74 f2                	je     80102573 <skipelem+0x8>
    path++;
  if(*path == 0)
80102581:	8b 45 08             	mov    0x8(%ebp),%eax
80102584:	0f b6 00             	movzbl (%eax),%eax
80102587:	84 c0                	test   %al,%al
80102589:	75 07                	jne    80102592 <skipelem+0x27>
    return 0;
8010258b:	b8 00 00 00 00       	mov    $0x0,%eax
80102590:	eb 7b                	jmp    8010260d <skipelem+0xa2>
  s = path;
80102592:	8b 45 08             	mov    0x8(%ebp),%eax
80102595:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102598:	eb 04                	jmp    8010259e <skipelem+0x33>
    path++;
8010259a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010259e:	8b 45 08             	mov    0x8(%ebp),%eax
801025a1:	0f b6 00             	movzbl (%eax),%eax
801025a4:	3c 2f                	cmp    $0x2f,%al
801025a6:	74 0a                	je     801025b2 <skipelem+0x47>
801025a8:	8b 45 08             	mov    0x8(%ebp),%eax
801025ab:	0f b6 00             	movzbl (%eax),%eax
801025ae:	84 c0                	test   %al,%al
801025b0:	75 e8                	jne    8010259a <skipelem+0x2f>
    path++;
  len = path - s;
801025b2:	8b 55 08             	mov    0x8(%ebp),%edx
801025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025b8:	29 c2                	sub    %eax,%edx
801025ba:	89 d0                	mov    %edx,%eax
801025bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801025bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801025c3:	7e 15                	jle    801025da <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801025c5:	83 ec 04             	sub    $0x4,%esp
801025c8:	6a 0e                	push   $0xe
801025ca:	ff 75 f4             	pushl  -0xc(%ebp)
801025cd:	ff 75 0c             	pushl  0xc(%ebp)
801025d0:	e8 d6 43 00 00       	call   801069ab <memmove>
801025d5:	83 c4 10             	add    $0x10,%esp
801025d8:	eb 26                	jmp    80102600 <skipelem+0x95>
  else {
    memmove(name, s, len);
801025da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025dd:	83 ec 04             	sub    $0x4,%esp
801025e0:	50                   	push   %eax
801025e1:	ff 75 f4             	pushl  -0xc(%ebp)
801025e4:	ff 75 0c             	pushl  0xc(%ebp)
801025e7:	e8 bf 43 00 00       	call   801069ab <memmove>
801025ec:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801025ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
801025f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801025f5:	01 d0                	add    %edx,%eax
801025f7:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801025fa:	eb 04                	jmp    80102600 <skipelem+0x95>
    path++;
801025fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102600:	8b 45 08             	mov    0x8(%ebp),%eax
80102603:	0f b6 00             	movzbl (%eax),%eax
80102606:	3c 2f                	cmp    $0x2f,%al
80102608:	74 f2                	je     801025fc <skipelem+0x91>
    path++;
  return path;
8010260a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010260d:	c9                   	leave  
8010260e:	c3                   	ret    

8010260f <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010260f:	55                   	push   %ebp
80102610:	89 e5                	mov    %esp,%ebp
80102612:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102615:	8b 45 08             	mov    0x8(%ebp),%eax
80102618:	0f b6 00             	movzbl (%eax),%eax
8010261b:	3c 2f                	cmp    $0x2f,%al
8010261d:	75 17                	jne    80102636 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
8010261f:	83 ec 08             	sub    $0x8,%esp
80102622:	6a 01                	push   $0x1
80102624:	6a 01                	push   $0x1
80102626:	e8 9e f3 ff ff       	call   801019c9 <iget>
8010262b:	83 c4 10             	add    $0x10,%esp
8010262e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102631:	e9 bb 00 00 00       	jmp    801026f1 <namex+0xe2>
  else
    ip = idup(proc->cwd);
80102636:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010263c:	8b 40 68             	mov    0x68(%eax),%eax
8010263f:	83 ec 0c             	sub    $0xc,%esp
80102642:	50                   	push   %eax
80102643:	e8 9f f4 ff ff       	call   80101ae7 <idup>
80102648:	83 c4 10             	add    $0x10,%esp
8010264b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010264e:	e9 9e 00 00 00       	jmp    801026f1 <namex+0xe2>
    ilock(ip);
80102653:	83 ec 0c             	sub    $0xc,%esp
80102656:	ff 75 f4             	pushl  -0xc(%ebp)
80102659:	e8 c3 f4 ff ff       	call   80101b21 <ilock>
8010265e:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102664:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102668:	66 83 f8 01          	cmp    $0x1,%ax
8010266c:	74 18                	je     80102686 <namex+0x77>
      iunlockput(ip);
8010266e:	83 ec 0c             	sub    $0xc,%esp
80102671:	ff 75 f4             	pushl  -0xc(%ebp)
80102674:	e8 90 f7 ff ff       	call   80101e09 <iunlockput>
80102679:	83 c4 10             	add    $0x10,%esp
      return 0;
8010267c:	b8 00 00 00 00       	mov    $0x0,%eax
80102681:	e9 a7 00 00 00       	jmp    8010272d <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102686:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010268a:	74 20                	je     801026ac <namex+0x9d>
8010268c:	8b 45 08             	mov    0x8(%ebp),%eax
8010268f:	0f b6 00             	movzbl (%eax),%eax
80102692:	84 c0                	test   %al,%al
80102694:	75 16                	jne    801026ac <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	ff 75 f4             	pushl  -0xc(%ebp)
8010269c:	e8 06 f6 ff ff       	call   80101ca7 <iunlock>
801026a1:	83 c4 10             	add    $0x10,%esp
      return ip;
801026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026a7:	e9 81 00 00 00       	jmp    8010272d <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801026ac:	83 ec 04             	sub    $0x4,%esp
801026af:	6a 00                	push   $0x0
801026b1:	ff 75 10             	pushl  0x10(%ebp)
801026b4:	ff 75 f4             	pushl  -0xc(%ebp)
801026b7:	e8 1d fd ff ff       	call   801023d9 <dirlookup>
801026bc:	83 c4 10             	add    $0x10,%esp
801026bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801026c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801026c6:	75 15                	jne    801026dd <namex+0xce>
      iunlockput(ip);
801026c8:	83 ec 0c             	sub    $0xc,%esp
801026cb:	ff 75 f4             	pushl  -0xc(%ebp)
801026ce:	e8 36 f7 ff ff       	call   80101e09 <iunlockput>
801026d3:	83 c4 10             	add    $0x10,%esp
      return 0;
801026d6:	b8 00 00 00 00       	mov    $0x0,%eax
801026db:	eb 50                	jmp    8010272d <namex+0x11e>
    }
    iunlockput(ip);
801026dd:	83 ec 0c             	sub    $0xc,%esp
801026e0:	ff 75 f4             	pushl  -0xc(%ebp)
801026e3:	e8 21 f7 ff ff       	call   80101e09 <iunlockput>
801026e8:	83 c4 10             	add    $0x10,%esp
    ip = next;
801026eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801026f1:	83 ec 08             	sub    $0x8,%esp
801026f4:	ff 75 10             	pushl  0x10(%ebp)
801026f7:	ff 75 08             	pushl  0x8(%ebp)
801026fa:	e8 6c fe ff ff       	call   8010256b <skipelem>
801026ff:	83 c4 10             	add    $0x10,%esp
80102702:	89 45 08             	mov    %eax,0x8(%ebp)
80102705:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102709:	0f 85 44 ff ff ff    	jne    80102653 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010270f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102713:	74 15                	je     8010272a <namex+0x11b>
    iput(ip);
80102715:	83 ec 0c             	sub    $0xc,%esp
80102718:	ff 75 f4             	pushl  -0xc(%ebp)
8010271b:	e8 f9 f5 ff ff       	call   80101d19 <iput>
80102720:	83 c4 10             	add    $0x10,%esp
    return 0;
80102723:	b8 00 00 00 00       	mov    $0x0,%eax
80102728:	eb 03                	jmp    8010272d <namex+0x11e>
  }
  return ip;
8010272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010272d:	c9                   	leave  
8010272e:	c3                   	ret    

8010272f <namei>:

struct inode*
namei(char *path)
{
8010272f:	55                   	push   %ebp
80102730:	89 e5                	mov    %esp,%ebp
80102732:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102735:	83 ec 04             	sub    $0x4,%esp
80102738:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010273b:	50                   	push   %eax
8010273c:	6a 00                	push   $0x0
8010273e:	ff 75 08             	pushl  0x8(%ebp)
80102741:	e8 c9 fe ff ff       	call   8010260f <namex>
80102746:	83 c4 10             	add    $0x10,%esp
}
80102749:	c9                   	leave  
8010274a:	c3                   	ret    

8010274b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010274b:	55                   	push   %ebp
8010274c:	89 e5                	mov    %esp,%ebp
8010274e:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102751:	83 ec 04             	sub    $0x4,%esp
80102754:	ff 75 0c             	pushl  0xc(%ebp)
80102757:	6a 01                	push   $0x1
80102759:	ff 75 08             	pushl  0x8(%ebp)
8010275c:	e8 ae fe ff ff       	call   8010260f <namex>
80102761:	83 c4 10             	add    $0x10,%esp
}
80102764:	c9                   	leave  
80102765:	c3                   	ret    

80102766 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102766:	55                   	push   %ebp
80102767:	89 e5                	mov    %esp,%ebp
80102769:	83 ec 14             	sub    $0x14,%esp
8010276c:	8b 45 08             	mov    0x8(%ebp),%eax
8010276f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102773:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102777:	89 c2                	mov    %eax,%edx
80102779:	ec                   	in     (%dx),%al
8010277a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010277d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102781:	c9                   	leave  
80102782:	c3                   	ret    

80102783 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102783:	55                   	push   %ebp
80102784:	89 e5                	mov    %esp,%ebp
80102786:	57                   	push   %edi
80102787:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102788:	8b 55 08             	mov    0x8(%ebp),%edx
8010278b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010278e:	8b 45 10             	mov    0x10(%ebp),%eax
80102791:	89 cb                	mov    %ecx,%ebx
80102793:	89 df                	mov    %ebx,%edi
80102795:	89 c1                	mov    %eax,%ecx
80102797:	fc                   	cld    
80102798:	f3 6d                	rep insl (%dx),%es:(%edi)
8010279a:	89 c8                	mov    %ecx,%eax
8010279c:	89 fb                	mov    %edi,%ebx
8010279e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801027a1:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801027a4:	90                   	nop
801027a5:	5b                   	pop    %ebx
801027a6:	5f                   	pop    %edi
801027a7:	5d                   	pop    %ebp
801027a8:	c3                   	ret    

801027a9 <outb>:

static inline void
outb(ushort port, uchar data)
{
801027a9:	55                   	push   %ebp
801027aa:	89 e5                	mov    %esp,%ebp
801027ac:	83 ec 08             	sub    $0x8,%esp
801027af:	8b 55 08             	mov    0x8(%ebp),%edx
801027b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801027b5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801027b9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027bc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801027c0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801027c4:	ee                   	out    %al,(%dx)
}
801027c5:	90                   	nop
801027c6:	c9                   	leave  
801027c7:	c3                   	ret    

801027c8 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801027c8:	55                   	push   %ebp
801027c9:	89 e5                	mov    %esp,%ebp
801027cb:	56                   	push   %esi
801027cc:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801027cd:	8b 55 08             	mov    0x8(%ebp),%edx
801027d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027d3:	8b 45 10             	mov    0x10(%ebp),%eax
801027d6:	89 cb                	mov    %ecx,%ebx
801027d8:	89 de                	mov    %ebx,%esi
801027da:	89 c1                	mov    %eax,%ecx
801027dc:	fc                   	cld    
801027dd:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801027df:	89 c8                	mov    %ecx,%eax
801027e1:	89 f3                	mov    %esi,%ebx
801027e3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801027e6:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801027e9:	90                   	nop
801027ea:	5b                   	pop    %ebx
801027eb:	5e                   	pop    %esi
801027ec:	5d                   	pop    %ebp
801027ed:	c3                   	ret    

801027ee <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801027ee:	55                   	push   %ebp
801027ef:	89 e5                	mov    %esp,%ebp
801027f1:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801027f4:	90                   	nop
801027f5:	68 f7 01 00 00       	push   $0x1f7
801027fa:	e8 67 ff ff ff       	call   80102766 <inb>
801027ff:	83 c4 04             	add    $0x4,%esp
80102802:	0f b6 c0             	movzbl %al,%eax
80102805:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102808:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010280b:	25 c0 00 00 00       	and    $0xc0,%eax
80102810:	83 f8 40             	cmp    $0x40,%eax
80102813:	75 e0                	jne    801027f5 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102819:	74 11                	je     8010282c <idewait+0x3e>
8010281b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010281e:	83 e0 21             	and    $0x21,%eax
80102821:	85 c0                	test   %eax,%eax
80102823:	74 07                	je     8010282c <idewait+0x3e>
    return -1;
80102825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010282a:	eb 05                	jmp    80102831 <idewait+0x43>
  return 0;
8010282c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102831:	c9                   	leave  
80102832:	c3                   	ret    

80102833 <ideinit>:

void
ideinit(void)
{
80102833:	55                   	push   %ebp
80102834:	89 e5                	mov    %esp,%ebp
80102836:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102839:	83 ec 08             	sub    $0x8,%esp
8010283c:	68 26 a1 10 80       	push   $0x8010a126
80102841:	68 40 d6 10 80       	push   $0x8010d640
80102846:	e8 1c 3e 00 00       	call   80106667 <initlock>
8010284b:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
8010284e:	83 ec 0c             	sub    $0xc,%esp
80102851:	6a 0e                	push   $0xe
80102853:	e8 da 18 00 00       	call   80104132 <picenable>
80102858:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010285b:	a1 80 49 11 80       	mov    0x80114980,%eax
80102860:	83 e8 01             	sub    $0x1,%eax
80102863:	83 ec 08             	sub    $0x8,%esp
80102866:	50                   	push   %eax
80102867:	6a 0e                	push   $0xe
80102869:	e8 73 04 00 00       	call   80102ce1 <ioapicenable>
8010286e:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102871:	83 ec 0c             	sub    $0xc,%esp
80102874:	6a 00                	push   $0x0
80102876:	e8 73 ff ff ff       	call   801027ee <idewait>
8010287b:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010287e:	83 ec 08             	sub    $0x8,%esp
80102881:	68 f0 00 00 00       	push   $0xf0
80102886:	68 f6 01 00 00       	push   $0x1f6
8010288b:	e8 19 ff ff ff       	call   801027a9 <outb>
80102890:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102893:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010289a:	eb 24                	jmp    801028c0 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010289c:	83 ec 0c             	sub    $0xc,%esp
8010289f:	68 f7 01 00 00       	push   $0x1f7
801028a4:	e8 bd fe ff ff       	call   80102766 <inb>
801028a9:	83 c4 10             	add    $0x10,%esp
801028ac:	84 c0                	test   %al,%al
801028ae:	74 0c                	je     801028bc <ideinit+0x89>
      havedisk1 = 1;
801028b0:	c7 05 78 d6 10 80 01 	movl   $0x1,0x8010d678
801028b7:	00 00 00 
      break;
801028ba:	eb 0d                	jmp    801028c9 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801028bc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801028c0:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801028c7:	7e d3                	jle    8010289c <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801028c9:	83 ec 08             	sub    $0x8,%esp
801028cc:	68 e0 00 00 00       	push   $0xe0
801028d1:	68 f6 01 00 00       	push   $0x1f6
801028d6:	e8 ce fe ff ff       	call   801027a9 <outb>
801028db:	83 c4 10             	add    $0x10,%esp
}
801028de:	90                   	nop
801028df:	c9                   	leave  
801028e0:	c3                   	ret    

801028e1 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801028e1:	55                   	push   %ebp
801028e2:	89 e5                	mov    %esp,%ebp
801028e4:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801028e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801028eb:	75 0d                	jne    801028fa <idestart+0x19>
    panic("idestart");
801028ed:	83 ec 0c             	sub    $0xc,%esp
801028f0:	68 2a a1 10 80       	push   $0x8010a12a
801028f5:	e8 6c dc ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801028fa:	8b 45 08             	mov    0x8(%ebp),%eax
801028fd:	8b 40 08             	mov    0x8(%eax),%eax
80102900:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102905:	76 0d                	jbe    80102914 <idestart+0x33>
    panic("incorrect blockno");
80102907:	83 ec 0c             	sub    $0xc,%esp
8010290a:	68 33 a1 10 80       	push   $0x8010a133
8010290f:	e8 52 dc ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102914:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010291b:	8b 45 08             	mov    0x8(%ebp),%eax
8010291e:	8b 50 08             	mov    0x8(%eax),%edx
80102921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102924:	0f af c2             	imul   %edx,%eax
80102927:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
8010292a:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010292e:	7e 0d                	jle    8010293d <idestart+0x5c>
80102930:	83 ec 0c             	sub    $0xc,%esp
80102933:	68 2a a1 10 80       	push   $0x8010a12a
80102938:	e8 29 dc ff ff       	call   80100566 <panic>
  
  idewait(0);
8010293d:	83 ec 0c             	sub    $0xc,%esp
80102940:	6a 00                	push   $0x0
80102942:	e8 a7 fe ff ff       	call   801027ee <idewait>
80102947:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
8010294a:	83 ec 08             	sub    $0x8,%esp
8010294d:	6a 00                	push   $0x0
8010294f:	68 f6 03 00 00       	push   $0x3f6
80102954:	e8 50 fe ff ff       	call   801027a9 <outb>
80102959:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
8010295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295f:	0f b6 c0             	movzbl %al,%eax
80102962:	83 ec 08             	sub    $0x8,%esp
80102965:	50                   	push   %eax
80102966:	68 f2 01 00 00       	push   $0x1f2
8010296b:	e8 39 fe ff ff       	call   801027a9 <outb>
80102970:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102976:	0f b6 c0             	movzbl %al,%eax
80102979:	83 ec 08             	sub    $0x8,%esp
8010297c:	50                   	push   %eax
8010297d:	68 f3 01 00 00       	push   $0x1f3
80102982:	e8 22 fe ff ff       	call   801027a9 <outb>
80102987:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
8010298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010298d:	c1 f8 08             	sar    $0x8,%eax
80102990:	0f b6 c0             	movzbl %al,%eax
80102993:	83 ec 08             	sub    $0x8,%esp
80102996:	50                   	push   %eax
80102997:	68 f4 01 00 00       	push   $0x1f4
8010299c:	e8 08 fe ff ff       	call   801027a9 <outb>
801029a1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801029a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029a7:	c1 f8 10             	sar    $0x10,%eax
801029aa:	0f b6 c0             	movzbl %al,%eax
801029ad:	83 ec 08             	sub    $0x8,%esp
801029b0:	50                   	push   %eax
801029b1:	68 f5 01 00 00       	push   $0x1f5
801029b6:	e8 ee fd ff ff       	call   801027a9 <outb>
801029bb:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801029be:	8b 45 08             	mov    0x8(%ebp),%eax
801029c1:	8b 40 04             	mov    0x4(%eax),%eax
801029c4:	83 e0 01             	and    $0x1,%eax
801029c7:	c1 e0 04             	shl    $0x4,%eax
801029ca:	89 c2                	mov    %eax,%edx
801029cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029cf:	c1 f8 18             	sar    $0x18,%eax
801029d2:	83 e0 0f             	and    $0xf,%eax
801029d5:	09 d0                	or     %edx,%eax
801029d7:	83 c8 e0             	or     $0xffffffe0,%eax
801029da:	0f b6 c0             	movzbl %al,%eax
801029dd:	83 ec 08             	sub    $0x8,%esp
801029e0:	50                   	push   %eax
801029e1:	68 f6 01 00 00       	push   $0x1f6
801029e6:	e8 be fd ff ff       	call   801027a9 <outb>
801029eb:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801029ee:	8b 45 08             	mov    0x8(%ebp),%eax
801029f1:	8b 00                	mov    (%eax),%eax
801029f3:	83 e0 04             	and    $0x4,%eax
801029f6:	85 c0                	test   %eax,%eax
801029f8:	74 30                	je     80102a2a <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801029fa:	83 ec 08             	sub    $0x8,%esp
801029fd:	6a 30                	push   $0x30
801029ff:	68 f7 01 00 00       	push   $0x1f7
80102a04:	e8 a0 fd ff ff       	call   801027a9 <outb>
80102a09:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0f:	83 c0 18             	add    $0x18,%eax
80102a12:	83 ec 04             	sub    $0x4,%esp
80102a15:	68 80 00 00 00       	push   $0x80
80102a1a:	50                   	push   %eax
80102a1b:	68 f0 01 00 00       	push   $0x1f0
80102a20:	e8 a3 fd ff ff       	call   801027c8 <outsl>
80102a25:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102a28:	eb 12                	jmp    80102a3c <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102a2a:	83 ec 08             	sub    $0x8,%esp
80102a2d:	6a 20                	push   $0x20
80102a2f:	68 f7 01 00 00       	push   $0x1f7
80102a34:	e8 70 fd ff ff       	call   801027a9 <outb>
80102a39:	83 c4 10             	add    $0x10,%esp
  }
}
80102a3c:	90                   	nop
80102a3d:	c9                   	leave  
80102a3e:	c3                   	ret    

80102a3f <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102a3f:	55                   	push   %ebp
80102a40:	89 e5                	mov    %esp,%ebp
80102a42:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102a45:	83 ec 0c             	sub    $0xc,%esp
80102a48:	68 40 d6 10 80       	push   $0x8010d640
80102a4d:	e8 37 3c 00 00       	call   80106689 <acquire>
80102a52:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102a55:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102a61:	75 15                	jne    80102a78 <ideintr+0x39>
    release(&idelock);
80102a63:	83 ec 0c             	sub    $0xc,%esp
80102a66:	68 40 d6 10 80       	push   $0x8010d640
80102a6b:	e8 80 3c 00 00       	call   801066f0 <release>
80102a70:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102a73:	e9 9a 00 00 00       	jmp    80102b12 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a7b:	8b 40 14             	mov    0x14(%eax),%eax
80102a7e:	a3 74 d6 10 80       	mov    %eax,0x8010d674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a86:	8b 00                	mov    (%eax),%eax
80102a88:	83 e0 04             	and    $0x4,%eax
80102a8b:	85 c0                	test   %eax,%eax
80102a8d:	75 2d                	jne    80102abc <ideintr+0x7d>
80102a8f:	83 ec 0c             	sub    $0xc,%esp
80102a92:	6a 01                	push   $0x1
80102a94:	e8 55 fd ff ff       	call   801027ee <idewait>
80102a99:	83 c4 10             	add    $0x10,%esp
80102a9c:	85 c0                	test   %eax,%eax
80102a9e:	78 1c                	js     80102abc <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa3:	83 c0 18             	add    $0x18,%eax
80102aa6:	83 ec 04             	sub    $0x4,%esp
80102aa9:	68 80 00 00 00       	push   $0x80
80102aae:	50                   	push   %eax
80102aaf:	68 f0 01 00 00       	push   $0x1f0
80102ab4:	e8 ca fc ff ff       	call   80102783 <insl>
80102ab9:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102abf:	8b 00                	mov    (%eax),%eax
80102ac1:	83 c8 02             	or     $0x2,%eax
80102ac4:	89 c2                	mov    %eax,%edx
80102ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac9:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ace:	8b 00                	mov    (%eax),%eax
80102ad0:	83 e0 fb             	and    $0xfffffffb,%eax
80102ad3:	89 c2                	mov    %eax,%edx
80102ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad8:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102ada:	83 ec 0c             	sub    $0xc,%esp
80102add:	ff 75 f4             	pushl  -0xc(%ebp)
80102ae0:	e8 23 2c 00 00       	call   80105708 <wakeup>
80102ae5:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102ae8:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102aed:	85 c0                	test   %eax,%eax
80102aef:	74 11                	je     80102b02 <ideintr+0xc3>
    idestart(idequeue);
80102af1:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102af6:	83 ec 0c             	sub    $0xc,%esp
80102af9:	50                   	push   %eax
80102afa:	e8 e2 fd ff ff       	call   801028e1 <idestart>
80102aff:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102b02:	83 ec 0c             	sub    $0xc,%esp
80102b05:	68 40 d6 10 80       	push   $0x8010d640
80102b0a:	e8 e1 3b 00 00       	call   801066f0 <release>
80102b0f:	83 c4 10             	add    $0x10,%esp
}
80102b12:	c9                   	leave  
80102b13:	c3                   	ret    

80102b14 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102b14:	55                   	push   %ebp
80102b15:	89 e5                	mov    %esp,%ebp
80102b17:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80102b1d:	8b 00                	mov    (%eax),%eax
80102b1f:	83 e0 01             	and    $0x1,%eax
80102b22:	85 c0                	test   %eax,%eax
80102b24:	75 0d                	jne    80102b33 <iderw+0x1f>
    panic("iderw: buf not busy");
80102b26:	83 ec 0c             	sub    $0xc,%esp
80102b29:	68 45 a1 10 80       	push   $0x8010a145
80102b2e:	e8 33 da ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102b33:	8b 45 08             	mov    0x8(%ebp),%eax
80102b36:	8b 00                	mov    (%eax),%eax
80102b38:	83 e0 06             	and    $0x6,%eax
80102b3b:	83 f8 02             	cmp    $0x2,%eax
80102b3e:	75 0d                	jne    80102b4d <iderw+0x39>
    panic("iderw: nothing to do");
80102b40:	83 ec 0c             	sub    $0xc,%esp
80102b43:	68 59 a1 10 80       	push   $0x8010a159
80102b48:	e8 19 da ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b50:	8b 40 04             	mov    0x4(%eax),%eax
80102b53:	85 c0                	test   %eax,%eax
80102b55:	74 16                	je     80102b6d <iderw+0x59>
80102b57:	a1 78 d6 10 80       	mov    0x8010d678,%eax
80102b5c:	85 c0                	test   %eax,%eax
80102b5e:	75 0d                	jne    80102b6d <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102b60:	83 ec 0c             	sub    $0xc,%esp
80102b63:	68 6e a1 10 80       	push   $0x8010a16e
80102b68:	e8 f9 d9 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102b6d:	83 ec 0c             	sub    $0xc,%esp
80102b70:	68 40 d6 10 80       	push   $0x8010d640
80102b75:	e8 0f 3b 00 00       	call   80106689 <acquire>
80102b7a:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b80:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b87:	c7 45 f4 74 d6 10 80 	movl   $0x8010d674,-0xc(%ebp)
80102b8e:	eb 0b                	jmp    80102b9b <iderw+0x87>
80102b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b93:	8b 00                	mov    (%eax),%eax
80102b95:	83 c0 14             	add    $0x14,%eax
80102b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9e:	8b 00                	mov    (%eax),%eax
80102ba0:	85 c0                	test   %eax,%eax
80102ba2:	75 ec                	jne    80102b90 <iderw+0x7c>
    ;
  *pp = b;
80102ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba7:	8b 55 08             	mov    0x8(%ebp),%edx
80102baa:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102bac:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102bb1:	3b 45 08             	cmp    0x8(%ebp),%eax
80102bb4:	75 23                	jne    80102bd9 <iderw+0xc5>
    idestart(b);
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	ff 75 08             	pushl  0x8(%ebp)
80102bbc:	e8 20 fd ff ff       	call   801028e1 <idestart>
80102bc1:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102bc4:	eb 13                	jmp    80102bd9 <iderw+0xc5>
    sleep(b, &idelock);
80102bc6:	83 ec 08             	sub    $0x8,%esp
80102bc9:	68 40 d6 10 80       	push   $0x8010d640
80102bce:	ff 75 08             	pushl  0x8(%ebp)
80102bd1:	e8 c4 29 00 00       	call   8010559a <sleep>
80102bd6:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102bd9:	8b 45 08             	mov    0x8(%ebp),%eax
80102bdc:	8b 00                	mov    (%eax),%eax
80102bde:	83 e0 06             	and    $0x6,%eax
80102be1:	83 f8 02             	cmp    $0x2,%eax
80102be4:	75 e0                	jne    80102bc6 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	68 40 d6 10 80       	push   $0x8010d640
80102bee:	e8 fd 3a 00 00       	call   801066f0 <release>
80102bf3:	83 c4 10             	add    $0x10,%esp
}
80102bf6:	90                   	nop
80102bf7:	c9                   	leave  
80102bf8:	c3                   	ret    

80102bf9 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102bf9:	55                   	push   %ebp
80102bfa:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102bfc:	a1 54 42 11 80       	mov    0x80114254,%eax
80102c01:	8b 55 08             	mov    0x8(%ebp),%edx
80102c04:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102c06:	a1 54 42 11 80       	mov    0x80114254,%eax
80102c0b:	8b 40 10             	mov    0x10(%eax),%eax
}
80102c0e:	5d                   	pop    %ebp
80102c0f:	c3                   	ret    

80102c10 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102c13:	a1 54 42 11 80       	mov    0x80114254,%eax
80102c18:	8b 55 08             	mov    0x8(%ebp),%edx
80102c1b:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102c1d:	a1 54 42 11 80       	mov    0x80114254,%eax
80102c22:	8b 55 0c             	mov    0xc(%ebp),%edx
80102c25:	89 50 10             	mov    %edx,0x10(%eax)
}
80102c28:	90                   	nop
80102c29:	5d                   	pop    %ebp
80102c2a:	c3                   	ret    

80102c2b <ioapicinit>:

void
ioapicinit(void)
{
80102c2b:	55                   	push   %ebp
80102c2c:	89 e5                	mov    %esp,%ebp
80102c2e:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102c31:	a1 84 43 11 80       	mov    0x80114384,%eax
80102c36:	85 c0                	test   %eax,%eax
80102c38:	0f 84 a0 00 00 00    	je     80102cde <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102c3e:	c7 05 54 42 11 80 00 	movl   $0xfec00000,0x80114254
80102c45:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102c48:	6a 01                	push   $0x1
80102c4a:	e8 aa ff ff ff       	call   80102bf9 <ioapicread>
80102c4f:	83 c4 04             	add    $0x4,%esp
80102c52:	c1 e8 10             	shr    $0x10,%eax
80102c55:	25 ff 00 00 00       	and    $0xff,%eax
80102c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102c5d:	6a 00                	push   $0x0
80102c5f:	e8 95 ff ff ff       	call   80102bf9 <ioapicread>
80102c64:	83 c4 04             	add    $0x4,%esp
80102c67:	c1 e8 18             	shr    $0x18,%eax
80102c6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102c6d:	0f b6 05 80 43 11 80 	movzbl 0x80114380,%eax
80102c74:	0f b6 c0             	movzbl %al,%eax
80102c77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102c7a:	74 10                	je     80102c8c <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c7c:	83 ec 0c             	sub    $0xc,%esp
80102c7f:	68 8c a1 10 80       	push   $0x8010a18c
80102c84:	e8 3d d7 ff ff       	call   801003c6 <cprintf>
80102c89:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c93:	eb 3f                	jmp    80102cd4 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c98:	83 c0 20             	add    $0x20,%eax
80102c9b:	0d 00 00 01 00       	or     $0x10000,%eax
80102ca0:	89 c2                	mov    %eax,%edx
80102ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ca5:	83 c0 08             	add    $0x8,%eax
80102ca8:	01 c0                	add    %eax,%eax
80102caa:	83 ec 08             	sub    $0x8,%esp
80102cad:	52                   	push   %edx
80102cae:	50                   	push   %eax
80102caf:	e8 5c ff ff ff       	call   80102c10 <ioapicwrite>
80102cb4:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cba:	83 c0 08             	add    $0x8,%eax
80102cbd:	01 c0                	add    %eax,%eax
80102cbf:	83 c0 01             	add    $0x1,%eax
80102cc2:	83 ec 08             	sub    $0x8,%esp
80102cc5:	6a 00                	push   $0x0
80102cc7:	50                   	push   %eax
80102cc8:	e8 43 ff ff ff       	call   80102c10 <ioapicwrite>
80102ccd:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102cd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cd7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102cda:	7e b9                	jle    80102c95 <ioapicinit+0x6a>
80102cdc:	eb 01                	jmp    80102cdf <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102cde:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102cdf:	c9                   	leave  
80102ce0:	c3                   	ret    

80102ce1 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ce1:	55                   	push   %ebp
80102ce2:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102ce4:	a1 84 43 11 80       	mov    0x80114384,%eax
80102ce9:	85 c0                	test   %eax,%eax
80102ceb:	74 39                	je     80102d26 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ced:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf0:	83 c0 20             	add    $0x20,%eax
80102cf3:	89 c2                	mov    %eax,%edx
80102cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf8:	83 c0 08             	add    $0x8,%eax
80102cfb:	01 c0                	add    %eax,%eax
80102cfd:	52                   	push   %edx
80102cfe:	50                   	push   %eax
80102cff:	e8 0c ff ff ff       	call   80102c10 <ioapicwrite>
80102d04:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d07:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d0a:	c1 e0 18             	shl    $0x18,%eax
80102d0d:	89 c2                	mov    %eax,%edx
80102d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d12:	83 c0 08             	add    $0x8,%eax
80102d15:	01 c0                	add    %eax,%eax
80102d17:	83 c0 01             	add    $0x1,%eax
80102d1a:	52                   	push   %edx
80102d1b:	50                   	push   %eax
80102d1c:	e8 ef fe ff ff       	call   80102c10 <ioapicwrite>
80102d21:	83 c4 08             	add    $0x8,%esp
80102d24:	eb 01                	jmp    80102d27 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102d26:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102d27:	c9                   	leave  
80102d28:	c3                   	ret    

80102d29 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102d29:	55                   	push   %ebp
80102d2a:	89 e5                	mov    %esp,%ebp
80102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80102d2f:	05 00 00 00 80       	add    $0x80000000,%eax
80102d34:	5d                   	pop    %ebp
80102d35:	c3                   	ret    

80102d36 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102d36:	55                   	push   %ebp
80102d37:	89 e5                	mov    %esp,%ebp
80102d39:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102d3c:	83 ec 08             	sub    $0x8,%esp
80102d3f:	68 be a1 10 80       	push   $0x8010a1be
80102d44:	68 60 42 11 80       	push   $0x80114260
80102d49:	e8 19 39 00 00       	call   80106667 <initlock>
80102d4e:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102d51:	c7 05 94 42 11 80 00 	movl   $0x0,0x80114294
80102d58:	00 00 00 
  freerange(vstart, vend);
80102d5b:	83 ec 08             	sub    $0x8,%esp
80102d5e:	ff 75 0c             	pushl  0xc(%ebp)
80102d61:	ff 75 08             	pushl  0x8(%ebp)
80102d64:	e8 2a 00 00 00       	call   80102d93 <freerange>
80102d69:	83 c4 10             	add    $0x10,%esp
}
80102d6c:	90                   	nop
80102d6d:	c9                   	leave  
80102d6e:	c3                   	ret    

80102d6f <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102d6f:	55                   	push   %ebp
80102d70:	89 e5                	mov    %esp,%ebp
80102d72:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102d75:	83 ec 08             	sub    $0x8,%esp
80102d78:	ff 75 0c             	pushl  0xc(%ebp)
80102d7b:	ff 75 08             	pushl  0x8(%ebp)
80102d7e:	e8 10 00 00 00       	call   80102d93 <freerange>
80102d83:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102d86:	c7 05 94 42 11 80 01 	movl   $0x1,0x80114294
80102d8d:	00 00 00 
}
80102d90:	90                   	nop
80102d91:	c9                   	leave  
80102d92:	c3                   	ret    

80102d93 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102d93:	55                   	push   %ebp
80102d94:	89 e5                	mov    %esp,%ebp
80102d96:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102d99:	8b 45 08             	mov    0x8(%ebp),%eax
80102d9c:	05 ff 0f 00 00       	add    $0xfff,%eax
80102da1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102da9:	eb 15                	jmp    80102dc0 <freerange+0x2d>
    kfree(p);
80102dab:	83 ec 0c             	sub    $0xc,%esp
80102dae:	ff 75 f4             	pushl  -0xc(%ebp)
80102db1:	e8 1a 00 00 00       	call   80102dd0 <kfree>
80102db6:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102db9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dc3:	05 00 10 00 00       	add    $0x1000,%eax
80102dc8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102dcb:	76 de                	jbe    80102dab <freerange+0x18>
    kfree(p);
}
80102dcd:	90                   	nop
80102dce:	c9                   	leave  
80102dcf:	c3                   	ret    

80102dd0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80102dd9:	25 ff 0f 00 00       	and    $0xfff,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	75 1b                	jne    80102dfd <kfree+0x2d>
80102de2:	81 7d 08 7c 79 11 80 	cmpl   $0x8011797c,0x8(%ebp)
80102de9:	72 12                	jb     80102dfd <kfree+0x2d>
80102deb:	ff 75 08             	pushl  0x8(%ebp)
80102dee:	e8 36 ff ff ff       	call   80102d29 <v2p>
80102df3:	83 c4 04             	add    $0x4,%esp
80102df6:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102dfb:	76 0d                	jbe    80102e0a <kfree+0x3a>
    panic("kfree");
80102dfd:	83 ec 0c             	sub    $0xc,%esp
80102e00:	68 c3 a1 10 80       	push   $0x8010a1c3
80102e05:	e8 5c d7 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102e0a:	83 ec 04             	sub    $0x4,%esp
80102e0d:	68 00 10 00 00       	push   $0x1000
80102e12:	6a 01                	push   $0x1
80102e14:	ff 75 08             	pushl  0x8(%ebp)
80102e17:	e8 d0 3a 00 00       	call   801068ec <memset>
80102e1c:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102e1f:	a1 94 42 11 80       	mov    0x80114294,%eax
80102e24:	85 c0                	test   %eax,%eax
80102e26:	74 10                	je     80102e38 <kfree+0x68>
    acquire(&kmem.lock);
80102e28:	83 ec 0c             	sub    $0xc,%esp
80102e2b:	68 60 42 11 80       	push   $0x80114260
80102e30:	e8 54 38 00 00       	call   80106689 <acquire>
80102e35:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102e38:	8b 45 08             	mov    0x8(%ebp),%eax
80102e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102e3e:	8b 15 98 42 11 80    	mov    0x80114298,%edx
80102e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e47:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e4c:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80102e51:	a1 94 42 11 80       	mov    0x80114294,%eax
80102e56:	85 c0                	test   %eax,%eax
80102e58:	74 10                	je     80102e6a <kfree+0x9a>
    release(&kmem.lock);
80102e5a:	83 ec 0c             	sub    $0xc,%esp
80102e5d:	68 60 42 11 80       	push   $0x80114260
80102e62:	e8 89 38 00 00       	call   801066f0 <release>
80102e67:	83 c4 10             	add    $0x10,%esp
}
80102e6a:	90                   	nop
80102e6b:	c9                   	leave  
80102e6c:	c3                   	ret    

80102e6d <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102e6d:	55                   	push   %ebp
80102e6e:	89 e5                	mov    %esp,%ebp
80102e70:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102e73:	a1 94 42 11 80       	mov    0x80114294,%eax
80102e78:	85 c0                	test   %eax,%eax
80102e7a:	74 10                	je     80102e8c <kalloc+0x1f>
    acquire(&kmem.lock);
80102e7c:	83 ec 0c             	sub    $0xc,%esp
80102e7f:	68 60 42 11 80       	push   $0x80114260
80102e84:	e8 00 38 00 00       	call   80106689 <acquire>
80102e89:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102e8c:	a1 98 42 11 80       	mov    0x80114298,%eax
80102e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102e98:	74 0a                	je     80102ea4 <kalloc+0x37>
    kmem.freelist = r->next;
80102e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e9d:	8b 00                	mov    (%eax),%eax
80102e9f:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80102ea4:	a1 94 42 11 80       	mov    0x80114294,%eax
80102ea9:	85 c0                	test   %eax,%eax
80102eab:	74 10                	je     80102ebd <kalloc+0x50>
    release(&kmem.lock);
80102ead:	83 ec 0c             	sub    $0xc,%esp
80102eb0:	68 60 42 11 80       	push   $0x80114260
80102eb5:	e8 36 38 00 00       	call   801066f0 <release>
80102eba:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102ec0:	c9                   	leave  
80102ec1:	c3                   	ret    

80102ec2 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102ec2:	55                   	push   %ebp
80102ec3:	89 e5                	mov    %esp,%ebp
80102ec5:	83 ec 14             	sub    $0x14,%esp
80102ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80102ecb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ecf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ed3:	89 c2                	mov    %eax,%edx
80102ed5:	ec                   	in     (%dx),%al
80102ed6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ed9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102edd:	c9                   	leave  
80102ede:	c3                   	ret    

80102edf <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102edf:	55                   	push   %ebp
80102ee0:	89 e5                	mov    %esp,%ebp
80102ee2:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102ee5:	6a 64                	push   $0x64
80102ee7:	e8 d6 ff ff ff       	call   80102ec2 <inb>
80102eec:	83 c4 04             	add    $0x4,%esp
80102eef:	0f b6 c0             	movzbl %al,%eax
80102ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ef8:	83 e0 01             	and    $0x1,%eax
80102efb:	85 c0                	test   %eax,%eax
80102efd:	75 0a                	jne    80102f09 <kbdgetc+0x2a>
    return -1;
80102eff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f04:	e9 23 01 00 00       	jmp    8010302c <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102f09:	6a 60                	push   $0x60
80102f0b:	e8 b2 ff ff ff       	call   80102ec2 <inb>
80102f10:	83 c4 04             	add    $0x4,%esp
80102f13:	0f b6 c0             	movzbl %al,%eax
80102f16:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102f19:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102f20:	75 17                	jne    80102f39 <kbdgetc+0x5a>
    shift |= E0ESC;
80102f22:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80102f27:	83 c8 40             	or     $0x40,%eax
80102f2a:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
80102f2f:	b8 00 00 00 00       	mov    $0x0,%eax
80102f34:	e9 f3 00 00 00       	jmp    8010302c <kbdgetc+0x14d>
  } else if(data & 0x80){
80102f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f3c:	25 80 00 00 00       	and    $0x80,%eax
80102f41:	85 c0                	test   %eax,%eax
80102f43:	74 45                	je     80102f8a <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102f45:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80102f4a:	83 e0 40             	and    $0x40,%eax
80102f4d:	85 c0                	test   %eax,%eax
80102f4f:	75 08                	jne    80102f59 <kbdgetc+0x7a>
80102f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f54:	83 e0 7f             	and    $0x7f,%eax
80102f57:	eb 03                	jmp    80102f5c <kbdgetc+0x7d>
80102f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f62:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102f67:	0f b6 00             	movzbl (%eax),%eax
80102f6a:	83 c8 40             	or     $0x40,%eax
80102f6d:	0f b6 c0             	movzbl %al,%eax
80102f70:	f7 d0                	not    %eax
80102f72:	89 c2                	mov    %eax,%edx
80102f74:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80102f79:	21 d0                	and    %edx,%eax
80102f7b:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
80102f80:	b8 00 00 00 00       	mov    $0x0,%eax
80102f85:	e9 a2 00 00 00       	jmp    8010302c <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102f8a:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80102f8f:	83 e0 40             	and    $0x40,%eax
80102f92:	85 c0                	test   %eax,%eax
80102f94:	74 14                	je     80102faa <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f96:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102f9d:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80102fa2:	83 e0 bf             	and    $0xffffffbf,%eax
80102fa5:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  }

  shift |= shiftcode[data];
80102faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fad:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102fb2:	0f b6 00             	movzbl (%eax),%eax
80102fb5:	0f b6 d0             	movzbl %al,%edx
80102fb8:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80102fbd:	09 d0                	or     %edx,%eax
80102fbf:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  shift ^= togglecode[data];
80102fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fc7:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102fcc:	0f b6 00             	movzbl (%eax),%eax
80102fcf:	0f b6 d0             	movzbl %al,%edx
80102fd2:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80102fd7:	31 d0                	xor    %edx,%eax
80102fd9:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  c = charcode[shift & (CTL | SHIFT)][data];
80102fde:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80102fe3:	83 e0 03             	and    $0x3,%eax
80102fe6:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ff0:	01 d0                	add    %edx,%eax
80102ff2:	0f b6 00             	movzbl (%eax),%eax
80102ff5:	0f b6 c0             	movzbl %al,%eax
80102ff8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102ffb:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103000:	83 e0 08             	and    $0x8,%eax
80103003:	85 c0                	test   %eax,%eax
80103005:	74 22                	je     80103029 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80103007:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
8010300b:	76 0c                	jbe    80103019 <kbdgetc+0x13a>
8010300d:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80103011:	77 06                	ja     80103019 <kbdgetc+0x13a>
      c += 'A' - 'a';
80103013:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80103017:	eb 10                	jmp    80103029 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80103019:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
8010301d:	76 0a                	jbe    80103029 <kbdgetc+0x14a>
8010301f:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80103023:	77 04                	ja     80103029 <kbdgetc+0x14a>
      c += 'a' - 'A';
80103025:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80103029:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010302c:	c9                   	leave  
8010302d:	c3                   	ret    

8010302e <kbdintr>:

void
kbdintr(void)
{
8010302e:	55                   	push   %ebp
8010302f:	89 e5                	mov    %esp,%ebp
80103031:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80103034:	83 ec 0c             	sub    $0xc,%esp
80103037:	68 df 2e 10 80       	push   $0x80102edf
8010303c:	e8 b8 d7 ff ff       	call   801007f9 <consoleintr>
80103041:	83 c4 10             	add    $0x10,%esp
}
80103044:	90                   	nop
80103045:	c9                   	leave  
80103046:	c3                   	ret    

80103047 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103047:	55                   	push   %ebp
80103048:	89 e5                	mov    %esp,%ebp
8010304a:	83 ec 14             	sub    $0x14,%esp
8010304d:	8b 45 08             	mov    0x8(%ebp),%eax
80103050:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103054:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103058:	89 c2                	mov    %eax,%edx
8010305a:	ec                   	in     (%dx),%al
8010305b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010305e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103062:	c9                   	leave  
80103063:	c3                   	ret    

80103064 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103064:	55                   	push   %ebp
80103065:	89 e5                	mov    %esp,%ebp
80103067:	83 ec 08             	sub    $0x8,%esp
8010306a:	8b 55 08             	mov    0x8(%ebp),%edx
8010306d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103070:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103074:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103077:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010307b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010307f:	ee                   	out    %al,(%dx)
}
80103080:	90                   	nop
80103081:	c9                   	leave  
80103082:	c3                   	ret    

80103083 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103083:	55                   	push   %ebp
80103084:	89 e5                	mov    %esp,%ebp
80103086:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103089:	9c                   	pushf  
8010308a:	58                   	pop    %eax
8010308b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010308e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103091:	c9                   	leave  
80103092:	c3                   	ret    

80103093 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80103093:	55                   	push   %ebp
80103094:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103096:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010309b:	8b 55 08             	mov    0x8(%ebp),%edx
8010309e:	c1 e2 02             	shl    $0x2,%edx
801030a1:	01 c2                	add    %eax,%edx
801030a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801030a6:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801030a8:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801030ad:	83 c0 20             	add    $0x20,%eax
801030b0:	8b 00                	mov    (%eax),%eax
}
801030b2:	90                   	nop
801030b3:	5d                   	pop    %ebp
801030b4:	c3                   	ret    

801030b5 <lapicinit>:

void
lapicinit(void)
{
801030b5:	55                   	push   %ebp
801030b6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
801030b8:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801030bd:	85 c0                	test   %eax,%eax
801030bf:	0f 84 0b 01 00 00    	je     801031d0 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801030c5:	68 3f 01 00 00       	push   $0x13f
801030ca:	6a 3c                	push   $0x3c
801030cc:	e8 c2 ff ff ff       	call   80103093 <lapicw>
801030d1:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801030d4:	6a 0b                	push   $0xb
801030d6:	68 f8 00 00 00       	push   $0xf8
801030db:	e8 b3 ff ff ff       	call   80103093 <lapicw>
801030e0:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801030e3:	68 20 00 02 00       	push   $0x20020
801030e8:	68 c8 00 00 00       	push   $0xc8
801030ed:	e8 a1 ff ff ff       	call   80103093 <lapicw>
801030f2:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
801030f5:	68 80 96 98 00       	push   $0x989680
801030fa:	68 e0 00 00 00       	push   $0xe0
801030ff:	e8 8f ff ff ff       	call   80103093 <lapicw>
80103104:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103107:	68 00 00 01 00       	push   $0x10000
8010310c:	68 d4 00 00 00       	push   $0xd4
80103111:	e8 7d ff ff ff       	call   80103093 <lapicw>
80103116:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80103119:	68 00 00 01 00       	push   $0x10000
8010311e:	68 d8 00 00 00       	push   $0xd8
80103123:	e8 6b ff ff ff       	call   80103093 <lapicw>
80103128:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010312b:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103130:	83 c0 30             	add    $0x30,%eax
80103133:	8b 00                	mov    (%eax),%eax
80103135:	c1 e8 10             	shr    $0x10,%eax
80103138:	0f b6 c0             	movzbl %al,%eax
8010313b:	83 f8 03             	cmp    $0x3,%eax
8010313e:	76 12                	jbe    80103152 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80103140:	68 00 00 01 00       	push   $0x10000
80103145:	68 d0 00 00 00       	push   $0xd0
8010314a:	e8 44 ff ff ff       	call   80103093 <lapicw>
8010314f:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103152:	6a 33                	push   $0x33
80103154:	68 dc 00 00 00       	push   $0xdc
80103159:	e8 35 ff ff ff       	call   80103093 <lapicw>
8010315e:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103161:	6a 00                	push   $0x0
80103163:	68 a0 00 00 00       	push   $0xa0
80103168:	e8 26 ff ff ff       	call   80103093 <lapicw>
8010316d:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103170:	6a 00                	push   $0x0
80103172:	68 a0 00 00 00       	push   $0xa0
80103177:	e8 17 ff ff ff       	call   80103093 <lapicw>
8010317c:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
8010317f:	6a 00                	push   $0x0
80103181:	6a 2c                	push   $0x2c
80103183:	e8 0b ff ff ff       	call   80103093 <lapicw>
80103188:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010318b:	6a 00                	push   $0x0
8010318d:	68 c4 00 00 00       	push   $0xc4
80103192:	e8 fc fe ff ff       	call   80103093 <lapicw>
80103197:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010319a:	68 00 85 08 00       	push   $0x88500
8010319f:	68 c0 00 00 00       	push   $0xc0
801031a4:	e8 ea fe ff ff       	call   80103093 <lapicw>
801031a9:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801031ac:	90                   	nop
801031ad:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801031b2:	05 00 03 00 00       	add    $0x300,%eax
801031b7:	8b 00                	mov    (%eax),%eax
801031b9:	25 00 10 00 00       	and    $0x1000,%eax
801031be:	85 c0                	test   %eax,%eax
801031c0:	75 eb                	jne    801031ad <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801031c2:	6a 00                	push   $0x0
801031c4:	6a 20                	push   $0x20
801031c6:	e8 c8 fe ff ff       	call   80103093 <lapicw>
801031cb:	83 c4 08             	add    $0x8,%esp
801031ce:	eb 01                	jmp    801031d1 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
801031d0:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801031d1:	c9                   	leave  
801031d2:	c3                   	ret    

801031d3 <cpunum>:

int
cpunum(void)
{
801031d3:	55                   	push   %ebp
801031d4:	89 e5                	mov    %esp,%ebp
801031d6:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801031d9:	e8 a5 fe ff ff       	call   80103083 <readeflags>
801031de:	25 00 02 00 00       	and    $0x200,%eax
801031e3:	85 c0                	test   %eax,%eax
801031e5:	74 26                	je     8010320d <cpunum+0x3a>
    static int n;
    if(n++ == 0)
801031e7:	a1 80 d6 10 80       	mov    0x8010d680,%eax
801031ec:	8d 50 01             	lea    0x1(%eax),%edx
801031ef:	89 15 80 d6 10 80    	mov    %edx,0x8010d680
801031f5:	85 c0                	test   %eax,%eax
801031f7:	75 14                	jne    8010320d <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
801031f9:	8b 45 04             	mov    0x4(%ebp),%eax
801031fc:	83 ec 08             	sub    $0x8,%esp
801031ff:	50                   	push   %eax
80103200:	68 cc a1 10 80       	push   $0x8010a1cc
80103205:	e8 bc d1 ff ff       	call   801003c6 <cprintf>
8010320a:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
8010320d:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103212:	85 c0                	test   %eax,%eax
80103214:	74 0f                	je     80103225 <cpunum+0x52>
    return lapic[ID]>>24;
80103216:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010321b:	83 c0 20             	add    $0x20,%eax
8010321e:	8b 00                	mov    (%eax),%eax
80103220:	c1 e8 18             	shr    $0x18,%eax
80103223:	eb 05                	jmp    8010322a <cpunum+0x57>
  return 0;
80103225:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010322a:	c9                   	leave  
8010322b:	c3                   	ret    

8010322c <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010322c:	55                   	push   %ebp
8010322d:	89 e5                	mov    %esp,%ebp
  if(lapic)
8010322f:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103234:	85 c0                	test   %eax,%eax
80103236:	74 0c                	je     80103244 <lapiceoi+0x18>
    lapicw(EOI, 0);
80103238:	6a 00                	push   $0x0
8010323a:	6a 2c                	push   $0x2c
8010323c:	e8 52 fe ff ff       	call   80103093 <lapicw>
80103241:	83 c4 08             	add    $0x8,%esp
}
80103244:	90                   	nop
80103245:	c9                   	leave  
80103246:	c3                   	ret    

80103247 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103247:	55                   	push   %ebp
80103248:	89 e5                	mov    %esp,%ebp
}
8010324a:	90                   	nop
8010324b:	5d                   	pop    %ebp
8010324c:	c3                   	ret    

8010324d <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010324d:	55                   	push   %ebp
8010324e:	89 e5                	mov    %esp,%ebp
80103250:	83 ec 14             	sub    $0x14,%esp
80103253:	8b 45 08             	mov    0x8(%ebp),%eax
80103256:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103259:	6a 0f                	push   $0xf
8010325b:	6a 70                	push   $0x70
8010325d:	e8 02 fe ff ff       	call   80103064 <outb>
80103262:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103265:	6a 0a                	push   $0xa
80103267:	6a 71                	push   $0x71
80103269:	e8 f6 fd ff ff       	call   80103064 <outb>
8010326e:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103271:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103278:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010327b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103280:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103283:	83 c0 02             	add    $0x2,%eax
80103286:	8b 55 0c             	mov    0xc(%ebp),%edx
80103289:	c1 ea 04             	shr    $0x4,%edx
8010328c:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010328f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103293:	c1 e0 18             	shl    $0x18,%eax
80103296:	50                   	push   %eax
80103297:	68 c4 00 00 00       	push   $0xc4
8010329c:	e8 f2 fd ff ff       	call   80103093 <lapicw>
801032a1:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801032a4:	68 00 c5 00 00       	push   $0xc500
801032a9:	68 c0 00 00 00       	push   $0xc0
801032ae:	e8 e0 fd ff ff       	call   80103093 <lapicw>
801032b3:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801032b6:	68 c8 00 00 00       	push   $0xc8
801032bb:	e8 87 ff ff ff       	call   80103247 <microdelay>
801032c0:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801032c3:	68 00 85 00 00       	push   $0x8500
801032c8:	68 c0 00 00 00       	push   $0xc0
801032cd:	e8 c1 fd ff ff       	call   80103093 <lapicw>
801032d2:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801032d5:	6a 64                	push   $0x64
801032d7:	e8 6b ff ff ff       	call   80103247 <microdelay>
801032dc:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801032df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801032e6:	eb 3d                	jmp    80103325 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
801032e8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801032ec:	c1 e0 18             	shl    $0x18,%eax
801032ef:	50                   	push   %eax
801032f0:	68 c4 00 00 00       	push   $0xc4
801032f5:	e8 99 fd ff ff       	call   80103093 <lapicw>
801032fa:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801032fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103300:	c1 e8 0c             	shr    $0xc,%eax
80103303:	80 cc 06             	or     $0x6,%ah
80103306:	50                   	push   %eax
80103307:	68 c0 00 00 00       	push   $0xc0
8010330c:	e8 82 fd ff ff       	call   80103093 <lapicw>
80103311:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103314:	68 c8 00 00 00       	push   $0xc8
80103319:	e8 29 ff ff ff       	call   80103247 <microdelay>
8010331e:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103321:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103325:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103329:	7e bd                	jle    801032e8 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010332b:	90                   	nop
8010332c:	c9                   	leave  
8010332d:	c3                   	ret    

8010332e <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010332e:	55                   	push   %ebp
8010332f:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103331:	8b 45 08             	mov    0x8(%ebp),%eax
80103334:	0f b6 c0             	movzbl %al,%eax
80103337:	50                   	push   %eax
80103338:	6a 70                	push   $0x70
8010333a:	e8 25 fd ff ff       	call   80103064 <outb>
8010333f:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103342:	68 c8 00 00 00       	push   $0xc8
80103347:	e8 fb fe ff ff       	call   80103247 <microdelay>
8010334c:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010334f:	6a 71                	push   $0x71
80103351:	e8 f1 fc ff ff       	call   80103047 <inb>
80103356:	83 c4 04             	add    $0x4,%esp
80103359:	0f b6 c0             	movzbl %al,%eax
}
8010335c:	c9                   	leave  
8010335d:	c3                   	ret    

8010335e <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010335e:	55                   	push   %ebp
8010335f:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103361:	6a 00                	push   $0x0
80103363:	e8 c6 ff ff ff       	call   8010332e <cmos_read>
80103368:	83 c4 04             	add    $0x4,%esp
8010336b:	89 c2                	mov    %eax,%edx
8010336d:	8b 45 08             	mov    0x8(%ebp),%eax
80103370:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103372:	6a 02                	push   $0x2
80103374:	e8 b5 ff ff ff       	call   8010332e <cmos_read>
80103379:	83 c4 04             	add    $0x4,%esp
8010337c:	89 c2                	mov    %eax,%edx
8010337e:	8b 45 08             	mov    0x8(%ebp),%eax
80103381:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103384:	6a 04                	push   $0x4
80103386:	e8 a3 ff ff ff       	call   8010332e <cmos_read>
8010338b:	83 c4 04             	add    $0x4,%esp
8010338e:	89 c2                	mov    %eax,%edx
80103390:	8b 45 08             	mov    0x8(%ebp),%eax
80103393:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103396:	6a 07                	push   $0x7
80103398:	e8 91 ff ff ff       	call   8010332e <cmos_read>
8010339d:	83 c4 04             	add    $0x4,%esp
801033a0:	89 c2                	mov    %eax,%edx
801033a2:	8b 45 08             	mov    0x8(%ebp),%eax
801033a5:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801033a8:	6a 08                	push   $0x8
801033aa:	e8 7f ff ff ff       	call   8010332e <cmos_read>
801033af:	83 c4 04             	add    $0x4,%esp
801033b2:	89 c2                	mov    %eax,%edx
801033b4:	8b 45 08             	mov    0x8(%ebp),%eax
801033b7:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801033ba:	6a 09                	push   $0x9
801033bc:	e8 6d ff ff ff       	call   8010332e <cmos_read>
801033c1:	83 c4 04             	add    $0x4,%esp
801033c4:	89 c2                	mov    %eax,%edx
801033c6:	8b 45 08             	mov    0x8(%ebp),%eax
801033c9:	89 50 14             	mov    %edx,0x14(%eax)
}
801033cc:	90                   	nop
801033cd:	c9                   	leave  
801033ce:	c3                   	ret    

801033cf <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801033cf:	55                   	push   %ebp
801033d0:	89 e5                	mov    %esp,%ebp
801033d2:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801033d5:	6a 0b                	push   $0xb
801033d7:	e8 52 ff ff ff       	call   8010332e <cmos_read>
801033dc:	83 c4 04             	add    $0x4,%esp
801033df:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033e5:	83 e0 04             	and    $0x4,%eax
801033e8:	85 c0                	test   %eax,%eax
801033ea:	0f 94 c0             	sete   %al
801033ed:	0f b6 c0             	movzbl %al,%eax
801033f0:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801033f3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801033f6:	50                   	push   %eax
801033f7:	e8 62 ff ff ff       	call   8010335e <fill_rtcdate>
801033fc:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801033ff:	6a 0a                	push   $0xa
80103401:	e8 28 ff ff ff       	call   8010332e <cmos_read>
80103406:	83 c4 04             	add    $0x4,%esp
80103409:	25 80 00 00 00       	and    $0x80,%eax
8010340e:	85 c0                	test   %eax,%eax
80103410:	75 27                	jne    80103439 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103412:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103415:	50                   	push   %eax
80103416:	e8 43 ff ff ff       	call   8010335e <fill_rtcdate>
8010341b:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010341e:	83 ec 04             	sub    $0x4,%esp
80103421:	6a 18                	push   $0x18
80103423:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103426:	50                   	push   %eax
80103427:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010342a:	50                   	push   %eax
8010342b:	e8 23 35 00 00       	call   80106953 <memcmp>
80103430:	83 c4 10             	add    $0x10,%esp
80103433:	85 c0                	test   %eax,%eax
80103435:	74 05                	je     8010343c <cmostime+0x6d>
80103437:	eb ba                	jmp    801033f3 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103439:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010343a:	eb b7                	jmp    801033f3 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010343c:	90                   	nop
  }

  // convert
  if (bcd) {
8010343d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103441:	0f 84 b4 00 00 00    	je     801034fb <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103447:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010344a:	c1 e8 04             	shr    $0x4,%eax
8010344d:	89 c2                	mov    %eax,%edx
8010344f:	89 d0                	mov    %edx,%eax
80103451:	c1 e0 02             	shl    $0x2,%eax
80103454:	01 d0                	add    %edx,%eax
80103456:	01 c0                	add    %eax,%eax
80103458:	89 c2                	mov    %eax,%edx
8010345a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010345d:	83 e0 0f             	and    $0xf,%eax
80103460:	01 d0                	add    %edx,%eax
80103462:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103465:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103468:	c1 e8 04             	shr    $0x4,%eax
8010346b:	89 c2                	mov    %eax,%edx
8010346d:	89 d0                	mov    %edx,%eax
8010346f:	c1 e0 02             	shl    $0x2,%eax
80103472:	01 d0                	add    %edx,%eax
80103474:	01 c0                	add    %eax,%eax
80103476:	89 c2                	mov    %eax,%edx
80103478:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010347b:	83 e0 0f             	and    $0xf,%eax
8010347e:	01 d0                	add    %edx,%eax
80103480:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103483:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103486:	c1 e8 04             	shr    $0x4,%eax
80103489:	89 c2                	mov    %eax,%edx
8010348b:	89 d0                	mov    %edx,%eax
8010348d:	c1 e0 02             	shl    $0x2,%eax
80103490:	01 d0                	add    %edx,%eax
80103492:	01 c0                	add    %eax,%eax
80103494:	89 c2                	mov    %eax,%edx
80103496:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103499:	83 e0 0f             	and    $0xf,%eax
8010349c:	01 d0                	add    %edx,%eax
8010349e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801034a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034a4:	c1 e8 04             	shr    $0x4,%eax
801034a7:	89 c2                	mov    %eax,%edx
801034a9:	89 d0                	mov    %edx,%eax
801034ab:	c1 e0 02             	shl    $0x2,%eax
801034ae:	01 d0                	add    %edx,%eax
801034b0:	01 c0                	add    %eax,%eax
801034b2:	89 c2                	mov    %eax,%edx
801034b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034b7:	83 e0 0f             	and    $0xf,%eax
801034ba:	01 d0                	add    %edx,%eax
801034bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801034bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801034c2:	c1 e8 04             	shr    $0x4,%eax
801034c5:	89 c2                	mov    %eax,%edx
801034c7:	89 d0                	mov    %edx,%eax
801034c9:	c1 e0 02             	shl    $0x2,%eax
801034cc:	01 d0                	add    %edx,%eax
801034ce:	01 c0                	add    %eax,%eax
801034d0:	89 c2                	mov    %eax,%edx
801034d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801034d5:	83 e0 0f             	and    $0xf,%eax
801034d8:	01 d0                	add    %edx,%eax
801034da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801034dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034e0:	c1 e8 04             	shr    $0x4,%eax
801034e3:	89 c2                	mov    %eax,%edx
801034e5:	89 d0                	mov    %edx,%eax
801034e7:	c1 e0 02             	shl    $0x2,%eax
801034ea:	01 d0                	add    %edx,%eax
801034ec:	01 c0                	add    %eax,%eax
801034ee:	89 c2                	mov    %eax,%edx
801034f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034f3:	83 e0 0f             	and    $0xf,%eax
801034f6:	01 d0                	add    %edx,%eax
801034f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801034fb:	8b 45 08             	mov    0x8(%ebp),%eax
801034fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103501:	89 10                	mov    %edx,(%eax)
80103503:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103506:	89 50 04             	mov    %edx,0x4(%eax)
80103509:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010350c:	89 50 08             	mov    %edx,0x8(%eax)
8010350f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103512:	89 50 0c             	mov    %edx,0xc(%eax)
80103515:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103518:	89 50 10             	mov    %edx,0x10(%eax)
8010351b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010351e:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103521:	8b 45 08             	mov    0x8(%ebp),%eax
80103524:	8b 40 14             	mov    0x14(%eax),%eax
80103527:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010352d:	8b 45 08             	mov    0x8(%ebp),%eax
80103530:	89 50 14             	mov    %edx,0x14(%eax)
}
80103533:	90                   	nop
80103534:	c9                   	leave  
80103535:	c3                   	ret    

80103536 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103536:	55                   	push   %ebp
80103537:	89 e5                	mov    %esp,%ebp
80103539:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010353c:	83 ec 08             	sub    $0x8,%esp
8010353f:	68 f8 a1 10 80       	push   $0x8010a1f8
80103544:	68 a0 42 11 80       	push   $0x801142a0
80103549:	e8 19 31 00 00       	call   80106667 <initlock>
8010354e:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103551:	83 ec 08             	sub    $0x8,%esp
80103554:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103557:	50                   	push   %eax
80103558:	ff 75 08             	pushl  0x8(%ebp)
8010355b:	e8 74 df ff ff       	call   801014d4 <readsb>
80103560:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103563:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103566:	a3 d4 42 11 80       	mov    %eax,0x801142d4
  log.size = sb.nlog;
8010356b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010356e:	a3 d8 42 11 80       	mov    %eax,0x801142d8
  log.dev = dev;
80103573:	8b 45 08             	mov    0x8(%ebp),%eax
80103576:	a3 e4 42 11 80       	mov    %eax,0x801142e4
  recover_from_log();
8010357b:	e8 b2 01 00 00       	call   80103732 <recover_from_log>
}
80103580:	90                   	nop
80103581:	c9                   	leave  
80103582:	c3                   	ret    

80103583 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103583:	55                   	push   %ebp
80103584:	89 e5                	mov    %esp,%ebp
80103586:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103589:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103590:	e9 95 00 00 00       	jmp    8010362a <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103595:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
8010359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010359e:	01 d0                	add    %edx,%eax
801035a0:	83 c0 01             	add    $0x1,%eax
801035a3:	89 c2                	mov    %eax,%edx
801035a5:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801035aa:	83 ec 08             	sub    $0x8,%esp
801035ad:	52                   	push   %edx
801035ae:	50                   	push   %eax
801035af:	e8 02 cc ff ff       	call   801001b6 <bread>
801035b4:	83 c4 10             	add    $0x10,%esp
801035b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035bd:	83 c0 10             	add    $0x10,%eax
801035c0:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
801035c7:	89 c2                	mov    %eax,%edx
801035c9:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801035ce:	83 ec 08             	sub    $0x8,%esp
801035d1:	52                   	push   %edx
801035d2:	50                   	push   %eax
801035d3:	e8 de cb ff ff       	call   801001b6 <bread>
801035d8:	83 c4 10             	add    $0x10,%esp
801035db:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801035de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035e1:	8d 50 18             	lea    0x18(%eax),%edx
801035e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035e7:	83 c0 18             	add    $0x18,%eax
801035ea:	83 ec 04             	sub    $0x4,%esp
801035ed:	68 00 02 00 00       	push   $0x200
801035f2:	52                   	push   %edx
801035f3:	50                   	push   %eax
801035f4:	e8 b2 33 00 00       	call   801069ab <memmove>
801035f9:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801035fc:	83 ec 0c             	sub    $0xc,%esp
801035ff:	ff 75 ec             	pushl  -0x14(%ebp)
80103602:	e8 e8 cb ff ff       	call   801001ef <bwrite>
80103607:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010360a:	83 ec 0c             	sub    $0xc,%esp
8010360d:	ff 75 f0             	pushl  -0x10(%ebp)
80103610:	e8 19 cc ff ff       	call   8010022e <brelse>
80103615:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103618:	83 ec 0c             	sub    $0xc,%esp
8010361b:	ff 75 ec             	pushl  -0x14(%ebp)
8010361e:	e8 0b cc ff ff       	call   8010022e <brelse>
80103623:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103626:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010362a:	a1 e8 42 11 80       	mov    0x801142e8,%eax
8010362f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103632:	0f 8f 5d ff ff ff    	jg     80103595 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103638:	90                   	nop
80103639:	c9                   	leave  
8010363a:	c3                   	ret    

8010363b <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010363b:	55                   	push   %ebp
8010363c:	89 e5                	mov    %esp,%ebp
8010363e:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103641:	a1 d4 42 11 80       	mov    0x801142d4,%eax
80103646:	89 c2                	mov    %eax,%edx
80103648:	a1 e4 42 11 80       	mov    0x801142e4,%eax
8010364d:	83 ec 08             	sub    $0x8,%esp
80103650:	52                   	push   %edx
80103651:	50                   	push   %eax
80103652:	e8 5f cb ff ff       	call   801001b6 <bread>
80103657:	83 c4 10             	add    $0x10,%esp
8010365a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010365d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103660:	83 c0 18             	add    $0x18,%eax
80103663:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103666:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103669:	8b 00                	mov    (%eax),%eax
8010366b:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  for (i = 0; i < log.lh.n; i++) {
80103670:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103677:	eb 1b                	jmp    80103694 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103679:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010367c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010367f:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103683:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103686:	83 c2 10             	add    $0x10,%edx
80103689:	89 04 95 ac 42 11 80 	mov    %eax,-0x7feebd54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103690:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103694:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103699:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010369c:	7f db                	jg     80103679 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010369e:	83 ec 0c             	sub    $0xc,%esp
801036a1:	ff 75 f0             	pushl  -0x10(%ebp)
801036a4:	e8 85 cb ff ff       	call   8010022e <brelse>
801036a9:	83 c4 10             	add    $0x10,%esp
}
801036ac:	90                   	nop
801036ad:	c9                   	leave  
801036ae:	c3                   	ret    

801036af <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801036af:	55                   	push   %ebp
801036b0:	89 e5                	mov    %esp,%ebp
801036b2:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801036b5:	a1 d4 42 11 80       	mov    0x801142d4,%eax
801036ba:	89 c2                	mov    %eax,%edx
801036bc:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801036c1:	83 ec 08             	sub    $0x8,%esp
801036c4:	52                   	push   %edx
801036c5:	50                   	push   %eax
801036c6:	e8 eb ca ff ff       	call   801001b6 <bread>
801036cb:	83 c4 10             	add    $0x10,%esp
801036ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801036d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d4:	83 c0 18             	add    $0x18,%eax
801036d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801036da:	8b 15 e8 42 11 80    	mov    0x801142e8,%edx
801036e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036e3:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801036e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036ec:	eb 1b                	jmp    80103709 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036f1:	83 c0 10             	add    $0x10,%eax
801036f4:	8b 0c 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%ecx
801036fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103701:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103705:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103709:	a1 e8 42 11 80       	mov    0x801142e8,%eax
8010370e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103711:	7f db                	jg     801036ee <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103713:	83 ec 0c             	sub    $0xc,%esp
80103716:	ff 75 f0             	pushl  -0x10(%ebp)
80103719:	e8 d1 ca ff ff       	call   801001ef <bwrite>
8010371e:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103721:	83 ec 0c             	sub    $0xc,%esp
80103724:	ff 75 f0             	pushl  -0x10(%ebp)
80103727:	e8 02 cb ff ff       	call   8010022e <brelse>
8010372c:	83 c4 10             	add    $0x10,%esp
}
8010372f:	90                   	nop
80103730:	c9                   	leave  
80103731:	c3                   	ret    

80103732 <recover_from_log>:

static void
recover_from_log(void)
{
80103732:	55                   	push   %ebp
80103733:	89 e5                	mov    %esp,%ebp
80103735:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103738:	e8 fe fe ff ff       	call   8010363b <read_head>
  install_trans(); // if committed, copy from log to disk
8010373d:	e8 41 fe ff ff       	call   80103583 <install_trans>
  log.lh.n = 0;
80103742:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103749:	00 00 00 
  write_head(); // clear the log
8010374c:	e8 5e ff ff ff       	call   801036af <write_head>
}
80103751:	90                   	nop
80103752:	c9                   	leave  
80103753:	c3                   	ret    

80103754 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103754:	55                   	push   %ebp
80103755:	89 e5                	mov    %esp,%ebp
80103757:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010375a:	83 ec 0c             	sub    $0xc,%esp
8010375d:	68 a0 42 11 80       	push   $0x801142a0
80103762:	e8 22 2f 00 00       	call   80106689 <acquire>
80103767:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010376a:	a1 e0 42 11 80       	mov    0x801142e0,%eax
8010376f:	85 c0                	test   %eax,%eax
80103771:	74 17                	je     8010378a <begin_op+0x36>
      sleep(&log, &log.lock);
80103773:	83 ec 08             	sub    $0x8,%esp
80103776:	68 a0 42 11 80       	push   $0x801142a0
8010377b:	68 a0 42 11 80       	push   $0x801142a0
80103780:	e8 15 1e 00 00       	call   8010559a <sleep>
80103785:	83 c4 10             	add    $0x10,%esp
80103788:	eb e0                	jmp    8010376a <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010378a:	8b 0d e8 42 11 80    	mov    0x801142e8,%ecx
80103790:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103795:	8d 50 01             	lea    0x1(%eax),%edx
80103798:	89 d0                	mov    %edx,%eax
8010379a:	c1 e0 02             	shl    $0x2,%eax
8010379d:	01 d0                	add    %edx,%eax
8010379f:	01 c0                	add    %eax,%eax
801037a1:	01 c8                	add    %ecx,%eax
801037a3:	83 f8 1e             	cmp    $0x1e,%eax
801037a6:	7e 17                	jle    801037bf <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801037a8:	83 ec 08             	sub    $0x8,%esp
801037ab:	68 a0 42 11 80       	push   $0x801142a0
801037b0:	68 a0 42 11 80       	push   $0x801142a0
801037b5:	e8 e0 1d 00 00       	call   8010559a <sleep>
801037ba:	83 c4 10             	add    $0x10,%esp
801037bd:	eb ab                	jmp    8010376a <begin_op+0x16>
    } else {
      log.outstanding += 1;
801037bf:	a1 dc 42 11 80       	mov    0x801142dc,%eax
801037c4:	83 c0 01             	add    $0x1,%eax
801037c7:	a3 dc 42 11 80       	mov    %eax,0x801142dc
      release(&log.lock);
801037cc:	83 ec 0c             	sub    $0xc,%esp
801037cf:	68 a0 42 11 80       	push   $0x801142a0
801037d4:	e8 17 2f 00 00       	call   801066f0 <release>
801037d9:	83 c4 10             	add    $0x10,%esp
      break;
801037dc:	90                   	nop
    }
  }
}
801037dd:	90                   	nop
801037de:	c9                   	leave  
801037df:	c3                   	ret    

801037e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801037e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801037ed:	83 ec 0c             	sub    $0xc,%esp
801037f0:	68 a0 42 11 80       	push   $0x801142a0
801037f5:	e8 8f 2e 00 00       	call   80106689 <acquire>
801037fa:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801037fd:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103802:	83 e8 01             	sub    $0x1,%eax
80103805:	a3 dc 42 11 80       	mov    %eax,0x801142dc
  if(log.committing)
8010380a:	a1 e0 42 11 80       	mov    0x801142e0,%eax
8010380f:	85 c0                	test   %eax,%eax
80103811:	74 0d                	je     80103820 <end_op+0x40>
    panic("log.committing");
80103813:	83 ec 0c             	sub    $0xc,%esp
80103816:	68 fc a1 10 80       	push   $0x8010a1fc
8010381b:	e8 46 cd ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103820:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103825:	85 c0                	test   %eax,%eax
80103827:	75 13                	jne    8010383c <end_op+0x5c>
    do_commit = 1;
80103829:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103830:	c7 05 e0 42 11 80 01 	movl   $0x1,0x801142e0
80103837:	00 00 00 
8010383a:	eb 10                	jmp    8010384c <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010383c:	83 ec 0c             	sub    $0xc,%esp
8010383f:	68 a0 42 11 80       	push   $0x801142a0
80103844:	e8 bf 1e 00 00       	call   80105708 <wakeup>
80103849:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010384c:	83 ec 0c             	sub    $0xc,%esp
8010384f:	68 a0 42 11 80       	push   $0x801142a0
80103854:	e8 97 2e 00 00       	call   801066f0 <release>
80103859:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010385c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103860:	74 3f                	je     801038a1 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103862:	e8 f5 00 00 00       	call   8010395c <commit>
    acquire(&log.lock);
80103867:	83 ec 0c             	sub    $0xc,%esp
8010386a:	68 a0 42 11 80       	push   $0x801142a0
8010386f:	e8 15 2e 00 00       	call   80106689 <acquire>
80103874:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103877:	c7 05 e0 42 11 80 00 	movl   $0x0,0x801142e0
8010387e:	00 00 00 
    wakeup(&log);
80103881:	83 ec 0c             	sub    $0xc,%esp
80103884:	68 a0 42 11 80       	push   $0x801142a0
80103889:	e8 7a 1e 00 00       	call   80105708 <wakeup>
8010388e:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103891:	83 ec 0c             	sub    $0xc,%esp
80103894:	68 a0 42 11 80       	push   $0x801142a0
80103899:	e8 52 2e 00 00       	call   801066f0 <release>
8010389e:	83 c4 10             	add    $0x10,%esp
  }
}
801038a1:	90                   	nop
801038a2:	c9                   	leave  
801038a3:	c3                   	ret    

801038a4 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801038a4:	55                   	push   %ebp
801038a5:	89 e5                	mov    %esp,%ebp
801038a7:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801038aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038b1:	e9 95 00 00 00       	jmp    8010394b <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801038b6:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
801038bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038bf:	01 d0                	add    %edx,%eax
801038c1:	83 c0 01             	add    $0x1,%eax
801038c4:	89 c2                	mov    %eax,%edx
801038c6:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801038cb:	83 ec 08             	sub    $0x8,%esp
801038ce:	52                   	push   %edx
801038cf:	50                   	push   %eax
801038d0:	e8 e1 c8 ff ff       	call   801001b6 <bread>
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801038db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038de:	83 c0 10             	add    $0x10,%eax
801038e1:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
801038e8:	89 c2                	mov    %eax,%edx
801038ea:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801038ef:	83 ec 08             	sub    $0x8,%esp
801038f2:	52                   	push   %edx
801038f3:	50                   	push   %eax
801038f4:	e8 bd c8 ff ff       	call   801001b6 <bread>
801038f9:	83 c4 10             	add    $0x10,%esp
801038fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801038ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103902:	8d 50 18             	lea    0x18(%eax),%edx
80103905:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103908:	83 c0 18             	add    $0x18,%eax
8010390b:	83 ec 04             	sub    $0x4,%esp
8010390e:	68 00 02 00 00       	push   $0x200
80103913:	52                   	push   %edx
80103914:	50                   	push   %eax
80103915:	e8 91 30 00 00       	call   801069ab <memmove>
8010391a:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010391d:	83 ec 0c             	sub    $0xc,%esp
80103920:	ff 75 f0             	pushl  -0x10(%ebp)
80103923:	e8 c7 c8 ff ff       	call   801001ef <bwrite>
80103928:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
8010392b:	83 ec 0c             	sub    $0xc,%esp
8010392e:	ff 75 ec             	pushl  -0x14(%ebp)
80103931:	e8 f8 c8 ff ff       	call   8010022e <brelse>
80103936:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103939:	83 ec 0c             	sub    $0xc,%esp
8010393c:	ff 75 f0             	pushl  -0x10(%ebp)
8010393f:	e8 ea c8 ff ff       	call   8010022e <brelse>
80103944:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103947:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010394b:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103950:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103953:	0f 8f 5d ff ff ff    	jg     801038b6 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103959:	90                   	nop
8010395a:	c9                   	leave  
8010395b:	c3                   	ret    

8010395c <commit>:

static void
commit()
{
8010395c:	55                   	push   %ebp
8010395d:	89 e5                	mov    %esp,%ebp
8010395f:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103962:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103967:	85 c0                	test   %eax,%eax
80103969:	7e 1e                	jle    80103989 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010396b:	e8 34 ff ff ff       	call   801038a4 <write_log>
    write_head();    // Write header to disk -- the real commit
80103970:	e8 3a fd ff ff       	call   801036af <write_head>
    install_trans(); // Now install writes to home locations
80103975:	e8 09 fc ff ff       	call   80103583 <install_trans>
    log.lh.n = 0; 
8010397a:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103981:	00 00 00 
    write_head();    // Erase the transaction from the log
80103984:	e8 26 fd ff ff       	call   801036af <write_head>
  }
}
80103989:	90                   	nop
8010398a:	c9                   	leave  
8010398b:	c3                   	ret    

8010398c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010398c:	55                   	push   %ebp
8010398d:	89 e5                	mov    %esp,%ebp
8010398f:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103992:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103997:	83 f8 1d             	cmp    $0x1d,%eax
8010399a:	7f 12                	jg     801039ae <log_write+0x22>
8010399c:	a1 e8 42 11 80       	mov    0x801142e8,%eax
801039a1:	8b 15 d8 42 11 80    	mov    0x801142d8,%edx
801039a7:	83 ea 01             	sub    $0x1,%edx
801039aa:	39 d0                	cmp    %edx,%eax
801039ac:	7c 0d                	jl     801039bb <log_write+0x2f>
    panic("too big a transaction");
801039ae:	83 ec 0c             	sub    $0xc,%esp
801039b1:	68 0b a2 10 80       	push   $0x8010a20b
801039b6:	e8 ab cb ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
801039bb:	a1 dc 42 11 80       	mov    0x801142dc,%eax
801039c0:	85 c0                	test   %eax,%eax
801039c2:	7f 0d                	jg     801039d1 <log_write+0x45>
    panic("log_write outside of trans");
801039c4:	83 ec 0c             	sub    $0xc,%esp
801039c7:	68 21 a2 10 80       	push   $0x8010a221
801039cc:	e8 95 cb ff ff       	call   80100566 <panic>

  acquire(&log.lock);
801039d1:	83 ec 0c             	sub    $0xc,%esp
801039d4:	68 a0 42 11 80       	push   $0x801142a0
801039d9:	e8 ab 2c 00 00       	call   80106689 <acquire>
801039de:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801039e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039e8:	eb 1d                	jmp    80103a07 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801039ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ed:	83 c0 10             	add    $0x10,%eax
801039f0:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
801039f7:	89 c2                	mov    %eax,%edx
801039f9:	8b 45 08             	mov    0x8(%ebp),%eax
801039fc:	8b 40 08             	mov    0x8(%eax),%eax
801039ff:	39 c2                	cmp    %eax,%edx
80103a01:	74 10                	je     80103a13 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103a03:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a07:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103a0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a0f:	7f d9                	jg     801039ea <log_write+0x5e>
80103a11:	eb 01                	jmp    80103a14 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103a13:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103a14:	8b 45 08             	mov    0x8(%ebp),%eax
80103a17:	8b 40 08             	mov    0x8(%eax),%eax
80103a1a:	89 c2                	mov    %eax,%edx
80103a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a1f:	83 c0 10             	add    $0x10,%eax
80103a22:	89 14 85 ac 42 11 80 	mov    %edx,-0x7feebd54(,%eax,4)
  if (i == log.lh.n)
80103a29:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103a2e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a31:	75 0d                	jne    80103a40 <log_write+0xb4>
    log.lh.n++;
80103a33:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103a38:	83 c0 01             	add    $0x1,%eax
80103a3b:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  b->flags |= B_DIRTY; // prevent eviction
80103a40:	8b 45 08             	mov    0x8(%ebp),%eax
80103a43:	8b 00                	mov    (%eax),%eax
80103a45:	83 c8 04             	or     $0x4,%eax
80103a48:	89 c2                	mov    %eax,%edx
80103a4a:	8b 45 08             	mov    0x8(%ebp),%eax
80103a4d:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103a4f:	83 ec 0c             	sub    $0xc,%esp
80103a52:	68 a0 42 11 80       	push   $0x801142a0
80103a57:	e8 94 2c 00 00       	call   801066f0 <release>
80103a5c:	83 c4 10             	add    $0x10,%esp
}
80103a5f:	90                   	nop
80103a60:	c9                   	leave  
80103a61:	c3                   	ret    

80103a62 <v2p>:
80103a62:	55                   	push   %ebp
80103a63:	89 e5                	mov    %esp,%ebp
80103a65:	8b 45 08             	mov    0x8(%ebp),%eax
80103a68:	05 00 00 00 80       	add    $0x80000000,%eax
80103a6d:	5d                   	pop    %ebp
80103a6e:	c3                   	ret    

80103a6f <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103a6f:	55                   	push   %ebp
80103a70:	89 e5                	mov    %esp,%ebp
80103a72:	8b 45 08             	mov    0x8(%ebp),%eax
80103a75:	05 00 00 00 80       	add    $0x80000000,%eax
80103a7a:	5d                   	pop    %ebp
80103a7b:	c3                   	ret    

80103a7c <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103a7c:	55                   	push   %ebp
80103a7d:	89 e5                	mov    %esp,%ebp
80103a7f:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103a82:	8b 55 08             	mov    0x8(%ebp),%edx
80103a85:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a88:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a8b:	f0 87 02             	lock xchg %eax,(%edx)
80103a8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103a91:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a94:	c9                   	leave  
80103a95:	c3                   	ret    

80103a96 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103a96:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103a9a:	83 e4 f0             	and    $0xfffffff0,%esp
80103a9d:	ff 71 fc             	pushl  -0x4(%ecx)
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	51                   	push   %ecx
80103aa4:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103aa7:	83 ec 08             	sub    $0x8,%esp
80103aaa:	68 00 00 40 80       	push   $0x80400000
80103aaf:	68 7c 79 11 80       	push   $0x8011797c
80103ab4:	e8 7d f2 ff ff       	call   80102d36 <kinit1>
80103ab9:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103abc:	e8 4b 5d 00 00       	call   8010980c <kvmalloc>
  mpinit();        // collect info about this machine
80103ac1:	e8 43 04 00 00       	call   80103f09 <mpinit>
  lapicinit();
80103ac6:	e8 ea f5 ff ff       	call   801030b5 <lapicinit>
  seginit();       // set up segments
80103acb:	e8 e5 56 00 00       	call   801091b5 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103ad0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ad6:	0f b6 00             	movzbl (%eax),%eax
80103ad9:	0f b6 c0             	movzbl %al,%eax
80103adc:	83 ec 08             	sub    $0x8,%esp
80103adf:	50                   	push   %eax
80103ae0:	68 3c a2 10 80       	push   $0x8010a23c
80103ae5:	e8 dc c8 ff ff       	call   801003c6 <cprintf>
80103aea:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103aed:	e8 6d 06 00 00       	call   8010415f <picinit>
  ioapicinit();    // another interrupt controller
80103af2:	e8 34 f1 ff ff       	call   80102c2b <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103af7:	e8 c1 d0 ff ff       	call   80100bbd <consoleinit>
  uartinit();      // serial port
80103afc:	e8 10 4a 00 00       	call   80108511 <uartinit>
  pinit();         // process table
80103b01:	e8 5d 0b 00 00       	call   80104663 <pinit>
  tvinit();        // trap vectors
80103b06:	e8 02 46 00 00       	call   8010810d <tvinit>
  binit();         // buffer cache
80103b0b:	e8 24 c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103b10:	e8 b0 d5 ff ff       	call   801010c5 <fileinit>
  ideinit();       // disk
80103b15:	e8 19 ed ff ff       	call   80102833 <ideinit>
  if(!ismp)
80103b1a:	a1 84 43 11 80       	mov    0x80114384,%eax
80103b1f:	85 c0                	test   %eax,%eax
80103b21:	75 05                	jne    80103b28 <main+0x92>
    timerinit();   // uniprocessor timer
80103b23:	e8 36 45 00 00       	call   8010805e <timerinit>
  startothers();   // start other processors
80103b28:	e8 7f 00 00 00       	call   80103bac <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103b2d:	83 ec 08             	sub    $0x8,%esp
80103b30:	68 00 00 00 8e       	push   $0x8e000000
80103b35:	68 00 00 40 80       	push   $0x80400000
80103b3a:	e8 30 f2 ff ff       	call   80102d6f <kinit2>
80103b3f:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103b42:	e8 e5 0c 00 00       	call   8010482c <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103b47:	e8 1a 00 00 00       	call   80103b66 <mpmain>

80103b4c <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103b4c:	55                   	push   %ebp
80103b4d:	89 e5                	mov    %esp,%ebp
80103b4f:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103b52:	e8 cd 5c 00 00       	call   80109824 <switchkvm>
  seginit();
80103b57:	e8 59 56 00 00       	call   801091b5 <seginit>
  lapicinit();
80103b5c:	e8 54 f5 ff ff       	call   801030b5 <lapicinit>
  mpmain();
80103b61:	e8 00 00 00 00       	call   80103b66 <mpmain>

80103b66 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103b66:	55                   	push   %ebp
80103b67:	89 e5                	mov    %esp,%ebp
80103b69:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103b6c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b72:	0f b6 00             	movzbl (%eax),%eax
80103b75:	0f b6 c0             	movzbl %al,%eax
80103b78:	83 ec 08             	sub    $0x8,%esp
80103b7b:	50                   	push   %eax
80103b7c:	68 53 a2 10 80       	push   $0x8010a253
80103b81:	e8 40 c8 ff ff       	call   801003c6 <cprintf>
80103b86:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103b89:	e8 e0 46 00 00       	call   8010826e <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103b8e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b94:	05 a8 00 00 00       	add    $0xa8,%eax
80103b99:	83 ec 08             	sub    $0x8,%esp
80103b9c:	6a 01                	push   $0x1
80103b9e:	50                   	push   %eax
80103b9f:	e8 d8 fe ff ff       	call   80103a7c <xchg>
80103ba4:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103ba7:	e8 43 16 00 00       	call   801051ef <scheduler>

80103bac <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103bac:	55                   	push   %ebp
80103bad:	89 e5                	mov    %esp,%ebp
80103baf:	53                   	push   %ebx
80103bb0:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103bb3:	68 00 70 00 00       	push   $0x7000
80103bb8:	e8 b2 fe ff ff       	call   80103a6f <p2v>
80103bbd:	83 c4 04             	add    $0x4,%esp
80103bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103bc3:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103bc8:	83 ec 04             	sub    $0x4,%esp
80103bcb:	50                   	push   %eax
80103bcc:	68 4c d5 10 80       	push   $0x8010d54c
80103bd1:	ff 75 f0             	pushl  -0x10(%ebp)
80103bd4:	e8 d2 2d 00 00       	call   801069ab <memmove>
80103bd9:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103bdc:	c7 45 f4 a0 43 11 80 	movl   $0x801143a0,-0xc(%ebp)
80103be3:	e9 90 00 00 00       	jmp    80103c78 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103be8:	e8 e6 f5 ff ff       	call   801031d3 <cpunum>
80103bed:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103bf3:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103bf8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103bfb:	74 73                	je     80103c70 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103bfd:	e8 6b f2 ff ff       	call   80102e6d <kalloc>
80103c02:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c08:	83 e8 04             	sub    $0x4,%eax
80103c0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103c0e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103c14:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c19:	83 e8 08             	sub    $0x8,%eax
80103c1c:	c7 00 4c 3b 10 80    	movl   $0x80103b4c,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c25:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103c28:	83 ec 0c             	sub    $0xc,%esp
80103c2b:	68 00 c0 10 80       	push   $0x8010c000
80103c30:	e8 2d fe ff ff       	call   80103a62 <v2p>
80103c35:	83 c4 10             	add    $0x10,%esp
80103c38:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103c3a:	83 ec 0c             	sub    $0xc,%esp
80103c3d:	ff 75 f0             	pushl  -0x10(%ebp)
80103c40:	e8 1d fe ff ff       	call   80103a62 <v2p>
80103c45:	83 c4 10             	add    $0x10,%esp
80103c48:	89 c2                	mov    %eax,%edx
80103c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c4d:	0f b6 00             	movzbl (%eax),%eax
80103c50:	0f b6 c0             	movzbl %al,%eax
80103c53:	83 ec 08             	sub    $0x8,%esp
80103c56:	52                   	push   %edx
80103c57:	50                   	push   %eax
80103c58:	e8 f0 f5 ff ff       	call   8010324d <lapicstartap>
80103c5d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103c60:	90                   	nop
80103c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c64:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103c6a:	85 c0                	test   %eax,%eax
80103c6c:	74 f3                	je     80103c61 <startothers+0xb5>
80103c6e:	eb 01                	jmp    80103c71 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103c70:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103c71:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103c78:	a1 80 49 11 80       	mov    0x80114980,%eax
80103c7d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c83:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103c88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103c8b:	0f 87 57 ff ff ff    	ja     80103be8 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103c91:	90                   	nop
80103c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c95:	c9                   	leave  
80103c96:	c3                   	ret    

80103c97 <p2v>:
80103c97:	55                   	push   %ebp
80103c98:	89 e5                	mov    %esp,%ebp
80103c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103c9d:	05 00 00 00 80       	add    $0x80000000,%eax
80103ca2:	5d                   	pop    %ebp
80103ca3:	c3                   	ret    

80103ca4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103ca4:	55                   	push   %ebp
80103ca5:	89 e5                	mov    %esp,%ebp
80103ca7:	83 ec 14             	sub    $0x14,%esp
80103caa:	8b 45 08             	mov    0x8(%ebp),%eax
80103cad:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cb1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103cb5:	89 c2                	mov    %eax,%edx
80103cb7:	ec                   	in     (%dx),%al
80103cb8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103cbb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103cbf:	c9                   	leave  
80103cc0:	c3                   	ret    

80103cc1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103cc1:	55                   	push   %ebp
80103cc2:	89 e5                	mov    %esp,%ebp
80103cc4:	83 ec 08             	sub    $0x8,%esp
80103cc7:	8b 55 08             	mov    0x8(%ebp),%edx
80103cca:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ccd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103cd1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cd4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103cd8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103cdc:	ee                   	out    %al,(%dx)
}
80103cdd:	90                   	nop
80103cde:	c9                   	leave  
80103cdf:	c3                   	ret    

80103ce0 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103ce3:	a1 84 d6 10 80       	mov    0x8010d684,%eax
80103ce8:	89 c2                	mov    %eax,%edx
80103cea:	b8 a0 43 11 80       	mov    $0x801143a0,%eax
80103cef:	29 c2                	sub    %eax,%edx
80103cf1:	89 d0                	mov    %edx,%eax
80103cf3:	c1 f8 02             	sar    $0x2,%eax
80103cf6:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103cfc:	5d                   	pop    %ebp
80103cfd:	c3                   	ret    

80103cfe <sum>:

static uchar
sum(uchar *addr, int len)
{
80103cfe:	55                   	push   %ebp
80103cff:	89 e5                	mov    %esp,%ebp
80103d01:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103d04:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103d12:	eb 15                	jmp    80103d29 <sum+0x2b>
    sum += addr[i];
80103d14:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103d17:	8b 45 08             	mov    0x8(%ebp),%eax
80103d1a:	01 d0                	add    %edx,%eax
80103d1c:	0f b6 00             	movzbl (%eax),%eax
80103d1f:	0f b6 c0             	movzbl %al,%eax
80103d22:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103d25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103d29:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103d2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103d2f:	7c e3                	jl     80103d14 <sum+0x16>
    sum += addr[i];
  return sum;
80103d31:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103d34:	c9                   	leave  
80103d35:	c3                   	ret    

80103d36 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103d36:	55                   	push   %ebp
80103d37:	89 e5                	mov    %esp,%ebp
80103d39:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103d3c:	ff 75 08             	pushl  0x8(%ebp)
80103d3f:	e8 53 ff ff ff       	call   80103c97 <p2v>
80103d44:	83 c4 04             	add    $0x4,%esp
80103d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d50:	01 d0                	add    %edx,%eax
80103d52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d5b:	eb 36                	jmp    80103d93 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103d5d:	83 ec 04             	sub    $0x4,%esp
80103d60:	6a 04                	push   $0x4
80103d62:	68 64 a2 10 80       	push   $0x8010a264
80103d67:	ff 75 f4             	pushl  -0xc(%ebp)
80103d6a:	e8 e4 2b 00 00       	call   80106953 <memcmp>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	85 c0                	test   %eax,%eax
80103d74:	75 19                	jne    80103d8f <mpsearch1+0x59>
80103d76:	83 ec 08             	sub    $0x8,%esp
80103d79:	6a 10                	push   $0x10
80103d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80103d7e:	e8 7b ff ff ff       	call   80103cfe <sum>
80103d83:	83 c4 10             	add    $0x10,%esp
80103d86:	84 c0                	test   %al,%al
80103d88:	75 05                	jne    80103d8f <mpsearch1+0x59>
      return (struct mp*)p;
80103d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d8d:	eb 11                	jmp    80103da0 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103d8f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d96:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d99:	72 c2                	jb     80103d5d <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103da0:	c9                   	leave  
80103da1:	c3                   	ret    

80103da2 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103da2:	55                   	push   %ebp
80103da3:	89 e5                	mov    %esp,%ebp
80103da5:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103da8:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db2:	83 c0 0f             	add    $0xf,%eax
80103db5:	0f b6 00             	movzbl (%eax),%eax
80103db8:	0f b6 c0             	movzbl %al,%eax
80103dbb:	c1 e0 08             	shl    $0x8,%eax
80103dbe:	89 c2                	mov    %eax,%edx
80103dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dc3:	83 c0 0e             	add    $0xe,%eax
80103dc6:	0f b6 00             	movzbl (%eax),%eax
80103dc9:	0f b6 c0             	movzbl %al,%eax
80103dcc:	09 d0                	or     %edx,%eax
80103dce:	c1 e0 04             	shl    $0x4,%eax
80103dd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103dd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103dd8:	74 21                	je     80103dfb <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103dda:	83 ec 08             	sub    $0x8,%esp
80103ddd:	68 00 04 00 00       	push   $0x400
80103de2:	ff 75 f0             	pushl  -0x10(%ebp)
80103de5:	e8 4c ff ff ff       	call   80103d36 <mpsearch1>
80103dea:	83 c4 10             	add    $0x10,%esp
80103ded:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103df0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103df4:	74 51                	je     80103e47 <mpsearch+0xa5>
      return mp;
80103df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103df9:	eb 61                	jmp    80103e5c <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dfe:	83 c0 14             	add    $0x14,%eax
80103e01:	0f b6 00             	movzbl (%eax),%eax
80103e04:	0f b6 c0             	movzbl %al,%eax
80103e07:	c1 e0 08             	shl    $0x8,%eax
80103e0a:	89 c2                	mov    %eax,%edx
80103e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e0f:	83 c0 13             	add    $0x13,%eax
80103e12:	0f b6 00             	movzbl (%eax),%eax
80103e15:	0f b6 c0             	movzbl %al,%eax
80103e18:	09 d0                	or     %edx,%eax
80103e1a:	c1 e0 0a             	shl    $0xa,%eax
80103e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e23:	2d 00 04 00 00       	sub    $0x400,%eax
80103e28:	83 ec 08             	sub    $0x8,%esp
80103e2b:	68 00 04 00 00       	push   $0x400
80103e30:	50                   	push   %eax
80103e31:	e8 00 ff ff ff       	call   80103d36 <mpsearch1>
80103e36:	83 c4 10             	add    $0x10,%esp
80103e39:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103e40:	74 05                	je     80103e47 <mpsearch+0xa5>
      return mp;
80103e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e45:	eb 15                	jmp    80103e5c <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103e47:	83 ec 08             	sub    $0x8,%esp
80103e4a:	68 00 00 01 00       	push   $0x10000
80103e4f:	68 00 00 0f 00       	push   $0xf0000
80103e54:	e8 dd fe ff ff       	call   80103d36 <mpsearch1>
80103e59:	83 c4 10             	add    $0x10,%esp
}
80103e5c:	c9                   	leave  
80103e5d:	c3                   	ret    

80103e5e <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103e5e:	55                   	push   %ebp
80103e5f:	89 e5                	mov    %esp,%ebp
80103e61:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103e64:	e8 39 ff ff ff       	call   80103da2 <mpsearch>
80103e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e70:	74 0a                	je     80103e7c <mpconfig+0x1e>
80103e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e75:	8b 40 04             	mov    0x4(%eax),%eax
80103e78:	85 c0                	test   %eax,%eax
80103e7a:	75 0a                	jne    80103e86 <mpconfig+0x28>
    return 0;
80103e7c:	b8 00 00 00 00       	mov    $0x0,%eax
80103e81:	e9 81 00 00 00       	jmp    80103f07 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e89:	8b 40 04             	mov    0x4(%eax),%eax
80103e8c:	83 ec 0c             	sub    $0xc,%esp
80103e8f:	50                   	push   %eax
80103e90:	e8 02 fe ff ff       	call   80103c97 <p2v>
80103e95:	83 c4 10             	add    $0x10,%esp
80103e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103e9b:	83 ec 04             	sub    $0x4,%esp
80103e9e:	6a 04                	push   $0x4
80103ea0:	68 69 a2 10 80       	push   $0x8010a269
80103ea5:	ff 75 f0             	pushl  -0x10(%ebp)
80103ea8:	e8 a6 2a 00 00       	call   80106953 <memcmp>
80103ead:	83 c4 10             	add    $0x10,%esp
80103eb0:	85 c0                	test   %eax,%eax
80103eb2:	74 07                	je     80103ebb <mpconfig+0x5d>
    return 0;
80103eb4:	b8 00 00 00 00       	mov    $0x0,%eax
80103eb9:	eb 4c                	jmp    80103f07 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ebe:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103ec2:	3c 01                	cmp    $0x1,%al
80103ec4:	74 12                	je     80103ed8 <mpconfig+0x7a>
80103ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ec9:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103ecd:	3c 04                	cmp    $0x4,%al
80103ecf:	74 07                	je     80103ed8 <mpconfig+0x7a>
    return 0;
80103ed1:	b8 00 00 00 00       	mov    $0x0,%eax
80103ed6:	eb 2f                	jmp    80103f07 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103edb:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103edf:	0f b7 c0             	movzwl %ax,%eax
80103ee2:	83 ec 08             	sub    $0x8,%esp
80103ee5:	50                   	push   %eax
80103ee6:	ff 75 f0             	pushl  -0x10(%ebp)
80103ee9:	e8 10 fe ff ff       	call   80103cfe <sum>
80103eee:	83 c4 10             	add    $0x10,%esp
80103ef1:	84 c0                	test   %al,%al
80103ef3:	74 07                	je     80103efc <mpconfig+0x9e>
    return 0;
80103ef5:	b8 00 00 00 00       	mov    $0x0,%eax
80103efa:	eb 0b                	jmp    80103f07 <mpconfig+0xa9>
  *pmp = mp;
80103efc:	8b 45 08             	mov    0x8(%ebp),%eax
80103eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f02:	89 10                	mov    %edx,(%eax)
  return conf;
80103f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103f07:	c9                   	leave  
80103f08:	c3                   	ret    

80103f09 <mpinit>:

void
mpinit(void)
{
80103f09:	55                   	push   %ebp
80103f0a:	89 e5                	mov    %esp,%ebp
80103f0c:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103f0f:	c7 05 84 d6 10 80 a0 	movl   $0x801143a0,0x8010d684
80103f16:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103f19:	83 ec 0c             	sub    $0xc,%esp
80103f1c:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103f1f:	50                   	push   %eax
80103f20:	e8 39 ff ff ff       	call   80103e5e <mpconfig>
80103f25:	83 c4 10             	add    $0x10,%esp
80103f28:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103f2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f2f:	0f 84 96 01 00 00    	je     801040cb <mpinit+0x1c2>
    return;
  ismp = 1;
80103f35:	c7 05 84 43 11 80 01 	movl   $0x1,0x80114384
80103f3c:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f42:	8b 40 24             	mov    0x24(%eax),%eax
80103f45:	a3 9c 42 11 80       	mov    %eax,0x8011429c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f4d:	83 c0 2c             	add    $0x2c,%eax
80103f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f56:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103f5a:	0f b7 d0             	movzwl %ax,%edx
80103f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f60:	01 d0                	add    %edx,%eax
80103f62:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f65:	e9 f2 00 00 00       	jmp    8010405c <mpinit+0x153>
    switch(*p){
80103f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f6d:	0f b6 00             	movzbl (%eax),%eax
80103f70:	0f b6 c0             	movzbl %al,%eax
80103f73:	83 f8 04             	cmp    $0x4,%eax
80103f76:	0f 87 bc 00 00 00    	ja     80104038 <mpinit+0x12f>
80103f7c:	8b 04 85 ac a2 10 80 	mov    -0x7fef5d54(,%eax,4),%eax
80103f83:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f88:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103f8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103f8e:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f92:	0f b6 d0             	movzbl %al,%edx
80103f95:	a1 80 49 11 80       	mov    0x80114980,%eax
80103f9a:	39 c2                	cmp    %eax,%edx
80103f9c:	74 2b                	je     80103fc9 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103fa1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103fa5:	0f b6 d0             	movzbl %al,%edx
80103fa8:	a1 80 49 11 80       	mov    0x80114980,%eax
80103fad:	83 ec 04             	sub    $0x4,%esp
80103fb0:	52                   	push   %edx
80103fb1:	50                   	push   %eax
80103fb2:	68 6e a2 10 80       	push   $0x8010a26e
80103fb7:	e8 0a c4 ff ff       	call   801003c6 <cprintf>
80103fbc:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103fbf:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
80103fc6:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103fcc:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103fd0:	0f b6 c0             	movzbl %al,%eax
80103fd3:	83 e0 02             	and    $0x2,%eax
80103fd6:	85 c0                	test   %eax,%eax
80103fd8:	74 15                	je     80103fef <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103fda:	a1 80 49 11 80       	mov    0x80114980,%eax
80103fdf:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103fe5:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103fea:	a3 84 d6 10 80       	mov    %eax,0x8010d684
      cpus[ncpu].id = ncpu;
80103fef:	a1 80 49 11 80       	mov    0x80114980,%eax
80103ff4:	8b 15 80 49 11 80    	mov    0x80114980,%edx
80103ffa:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104000:	05 a0 43 11 80       	add    $0x801143a0,%eax
80104005:	88 10                	mov    %dl,(%eax)
      ncpu++;
80104007:	a1 80 49 11 80       	mov    0x80114980,%eax
8010400c:	83 c0 01             	add    $0x1,%eax
8010400f:	a3 80 49 11 80       	mov    %eax,0x80114980
      p += sizeof(struct mpproc);
80104014:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80104018:	eb 42                	jmp    8010405c <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010401a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80104020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104023:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104027:	a2 80 43 11 80       	mov    %al,0x80114380
      p += sizeof(struct mpioapic);
8010402c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104030:	eb 2a                	jmp    8010405c <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104032:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104036:	eb 24                	jmp    8010405c <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80104038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403b:	0f b6 00             	movzbl (%eax),%eax
8010403e:	0f b6 c0             	movzbl %al,%eax
80104041:	83 ec 08             	sub    $0x8,%esp
80104044:	50                   	push   %eax
80104045:	68 8c a2 10 80       	push   $0x8010a28c
8010404a:	e8 77 c3 ff ff       	call   801003c6 <cprintf>
8010404f:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80104052:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
80104059:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010405c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104062:	0f 82 02 ff ff ff    	jb     80103f6a <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80104068:	a1 84 43 11 80       	mov    0x80114384,%eax
8010406d:	85 c0                	test   %eax,%eax
8010406f:	75 1d                	jne    8010408e <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80104071:	c7 05 80 49 11 80 01 	movl   $0x1,0x80114980
80104078:	00 00 00 
    lapic = 0;
8010407b:	c7 05 9c 42 11 80 00 	movl   $0x0,0x8011429c
80104082:	00 00 00 
    ioapicid = 0;
80104085:	c6 05 80 43 11 80 00 	movb   $0x0,0x80114380
    return;
8010408c:	eb 3e                	jmp    801040cc <mpinit+0x1c3>
  }

  if(mp->imcrp){
8010408e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104091:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104095:	84 c0                	test   %al,%al
80104097:	74 33                	je     801040cc <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80104099:	83 ec 08             	sub    $0x8,%esp
8010409c:	6a 70                	push   $0x70
8010409e:	6a 22                	push   $0x22
801040a0:	e8 1c fc ff ff       	call   80103cc1 <outb>
801040a5:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	6a 23                	push   $0x23
801040ad:	e8 f2 fb ff ff       	call   80103ca4 <inb>
801040b2:	83 c4 10             	add    $0x10,%esp
801040b5:	83 c8 01             	or     $0x1,%eax
801040b8:	0f b6 c0             	movzbl %al,%eax
801040bb:	83 ec 08             	sub    $0x8,%esp
801040be:	50                   	push   %eax
801040bf:	6a 23                	push   $0x23
801040c1:	e8 fb fb ff ff       	call   80103cc1 <outb>
801040c6:	83 c4 10             	add    $0x10,%esp
801040c9:	eb 01                	jmp    801040cc <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
801040cb:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801040cc:	c9                   	leave  
801040cd:	c3                   	ret    

801040ce <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801040ce:	55                   	push   %ebp
801040cf:	89 e5                	mov    %esp,%ebp
801040d1:	83 ec 08             	sub    $0x8,%esp
801040d4:	8b 55 08             	mov    0x8(%ebp),%edx
801040d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801040da:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801040de:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801040e1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801040e5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801040e9:	ee                   	out    %al,(%dx)
}
801040ea:	90                   	nop
801040eb:	c9                   	leave  
801040ec:	c3                   	ret    

801040ed <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
801040ed:	55                   	push   %ebp
801040ee:	89 e5                	mov    %esp,%ebp
801040f0:	83 ec 04             	sub    $0x4,%esp
801040f3:	8b 45 08             	mov    0x8(%ebp),%eax
801040f6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
801040fa:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801040fe:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80104104:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104108:	0f b6 c0             	movzbl %al,%eax
8010410b:	50                   	push   %eax
8010410c:	6a 21                	push   $0x21
8010410e:	e8 bb ff ff ff       	call   801040ce <outb>
80104113:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80104116:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010411a:	66 c1 e8 08          	shr    $0x8,%ax
8010411e:	0f b6 c0             	movzbl %al,%eax
80104121:	50                   	push   %eax
80104122:	68 a1 00 00 00       	push   $0xa1
80104127:	e8 a2 ff ff ff       	call   801040ce <outb>
8010412c:	83 c4 08             	add    $0x8,%esp
}
8010412f:	90                   	nop
80104130:	c9                   	leave  
80104131:	c3                   	ret    

80104132 <picenable>:

void
picenable(int irq)
{
80104132:	55                   	push   %ebp
80104133:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80104135:	8b 45 08             	mov    0x8(%ebp),%eax
80104138:	ba 01 00 00 00       	mov    $0x1,%edx
8010413d:	89 c1                	mov    %eax,%ecx
8010413f:	d3 e2                	shl    %cl,%edx
80104141:	89 d0                	mov    %edx,%eax
80104143:	f7 d0                	not    %eax
80104145:	89 c2                	mov    %eax,%edx
80104147:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010414e:	21 d0                	and    %edx,%eax
80104150:	0f b7 c0             	movzwl %ax,%eax
80104153:	50                   	push   %eax
80104154:	e8 94 ff ff ff       	call   801040ed <picsetmask>
80104159:	83 c4 04             	add    $0x4,%esp
}
8010415c:	90                   	nop
8010415d:	c9                   	leave  
8010415e:	c3                   	ret    

8010415f <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
8010415f:	55                   	push   %ebp
80104160:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104162:	68 ff 00 00 00       	push   $0xff
80104167:	6a 21                	push   $0x21
80104169:	e8 60 ff ff ff       	call   801040ce <outb>
8010416e:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104171:	68 ff 00 00 00       	push   $0xff
80104176:	68 a1 00 00 00       	push   $0xa1
8010417b:	e8 4e ff ff ff       	call   801040ce <outb>
80104180:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104183:	6a 11                	push   $0x11
80104185:	6a 20                	push   $0x20
80104187:	e8 42 ff ff ff       	call   801040ce <outb>
8010418c:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
8010418f:	6a 20                	push   $0x20
80104191:	6a 21                	push   $0x21
80104193:	e8 36 ff ff ff       	call   801040ce <outb>
80104198:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010419b:	6a 04                	push   $0x4
8010419d:	6a 21                	push   $0x21
8010419f:	e8 2a ff ff ff       	call   801040ce <outb>
801041a4:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801041a7:	6a 03                	push   $0x3
801041a9:	6a 21                	push   $0x21
801041ab:	e8 1e ff ff ff       	call   801040ce <outb>
801041b0:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801041b3:	6a 11                	push   $0x11
801041b5:	68 a0 00 00 00       	push   $0xa0
801041ba:	e8 0f ff ff ff       	call   801040ce <outb>
801041bf:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
801041c2:	6a 28                	push   $0x28
801041c4:	68 a1 00 00 00       	push   $0xa1
801041c9:	e8 00 ff ff ff       	call   801040ce <outb>
801041ce:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801041d1:	6a 02                	push   $0x2
801041d3:	68 a1 00 00 00       	push   $0xa1
801041d8:	e8 f1 fe ff ff       	call   801040ce <outb>
801041dd:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
801041e0:	6a 03                	push   $0x3
801041e2:	68 a1 00 00 00       	push   $0xa1
801041e7:	e8 e2 fe ff ff       	call   801040ce <outb>
801041ec:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
801041ef:	6a 68                	push   $0x68
801041f1:	6a 20                	push   $0x20
801041f3:	e8 d6 fe ff ff       	call   801040ce <outb>
801041f8:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
801041fb:	6a 0a                	push   $0xa
801041fd:	6a 20                	push   $0x20
801041ff:	e8 ca fe ff ff       	call   801040ce <outb>
80104204:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104207:	6a 68                	push   $0x68
80104209:	68 a0 00 00 00       	push   $0xa0
8010420e:	e8 bb fe ff ff       	call   801040ce <outb>
80104213:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104216:	6a 0a                	push   $0xa
80104218:	68 a0 00 00 00       	push   $0xa0
8010421d:	e8 ac fe ff ff       	call   801040ce <outb>
80104222:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104225:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010422c:	66 83 f8 ff          	cmp    $0xffff,%ax
80104230:	74 13                	je     80104245 <picinit+0xe6>
    picsetmask(irqmask);
80104232:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104239:	0f b7 c0             	movzwl %ax,%eax
8010423c:	50                   	push   %eax
8010423d:	e8 ab fe ff ff       	call   801040ed <picsetmask>
80104242:	83 c4 04             	add    $0x4,%esp
}
80104245:	90                   	nop
80104246:	c9                   	leave  
80104247:	c3                   	ret    

80104248 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104248:	55                   	push   %ebp
80104249:	89 e5                	mov    %esp,%ebp
8010424b:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010424e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104255:	8b 45 0c             	mov    0xc(%ebp),%eax
80104258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010425e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104261:	8b 10                	mov    (%eax),%edx
80104263:	8b 45 08             	mov    0x8(%ebp),%eax
80104266:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104268:	e8 76 ce ff ff       	call   801010e3 <filealloc>
8010426d:	89 c2                	mov    %eax,%edx
8010426f:	8b 45 08             	mov    0x8(%ebp),%eax
80104272:	89 10                	mov    %edx,(%eax)
80104274:	8b 45 08             	mov    0x8(%ebp),%eax
80104277:	8b 00                	mov    (%eax),%eax
80104279:	85 c0                	test   %eax,%eax
8010427b:	0f 84 cb 00 00 00    	je     8010434c <pipealloc+0x104>
80104281:	e8 5d ce ff ff       	call   801010e3 <filealloc>
80104286:	89 c2                	mov    %eax,%edx
80104288:	8b 45 0c             	mov    0xc(%ebp),%eax
8010428b:	89 10                	mov    %edx,(%eax)
8010428d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104290:	8b 00                	mov    (%eax),%eax
80104292:	85 c0                	test   %eax,%eax
80104294:	0f 84 b2 00 00 00    	je     8010434c <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010429a:	e8 ce eb ff ff       	call   80102e6d <kalloc>
8010429f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042a6:	0f 84 9f 00 00 00    	je     8010434b <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801042ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042af:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801042b6:	00 00 00 
  p->writeopen = 1;
801042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bc:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801042c3:	00 00 00 
  p->nwrite = 0;
801042c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c9:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801042d0:	00 00 00 
  p->nread = 0;
801042d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d6:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801042dd:	00 00 00 
  initlock(&p->lock, "pipe");
801042e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e3:	83 ec 08             	sub    $0x8,%esp
801042e6:	68 c0 a2 10 80       	push   $0x8010a2c0
801042eb:	50                   	push   %eax
801042ec:	e8 76 23 00 00       	call   80106667 <initlock>
801042f1:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801042f4:	8b 45 08             	mov    0x8(%ebp),%eax
801042f7:	8b 00                	mov    (%eax),%eax
801042f9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801042ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104302:	8b 00                	mov    (%eax),%eax
80104304:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104308:	8b 45 08             	mov    0x8(%ebp),%eax
8010430b:	8b 00                	mov    (%eax),%eax
8010430d:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104311:	8b 45 08             	mov    0x8(%ebp),%eax
80104314:	8b 00                	mov    (%eax),%eax
80104316:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104319:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010431c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010431f:	8b 00                	mov    (%eax),%eax
80104321:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104327:	8b 45 0c             	mov    0xc(%ebp),%eax
8010432a:	8b 00                	mov    (%eax),%eax
8010432c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104330:	8b 45 0c             	mov    0xc(%ebp),%eax
80104333:	8b 00                	mov    (%eax),%eax
80104335:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010433c:	8b 00                	mov    (%eax),%eax
8010433e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104341:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104344:	b8 00 00 00 00       	mov    $0x0,%eax
80104349:	eb 4e                	jmp    80104399 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
8010434b:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
8010434c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104350:	74 0e                	je     80104360 <pipealloc+0x118>
    kfree((char*)p);
80104352:	83 ec 0c             	sub    $0xc,%esp
80104355:	ff 75 f4             	pushl  -0xc(%ebp)
80104358:	e8 73 ea ff ff       	call   80102dd0 <kfree>
8010435d:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104360:	8b 45 08             	mov    0x8(%ebp),%eax
80104363:	8b 00                	mov    (%eax),%eax
80104365:	85 c0                	test   %eax,%eax
80104367:	74 11                	je     8010437a <pipealloc+0x132>
    fileclose(*f0);
80104369:	8b 45 08             	mov    0x8(%ebp),%eax
8010436c:	8b 00                	mov    (%eax),%eax
8010436e:	83 ec 0c             	sub    $0xc,%esp
80104371:	50                   	push   %eax
80104372:	e8 2a ce ff ff       	call   801011a1 <fileclose>
80104377:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010437a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010437d:	8b 00                	mov    (%eax),%eax
8010437f:	85 c0                	test   %eax,%eax
80104381:	74 11                	je     80104394 <pipealloc+0x14c>
    fileclose(*f1);
80104383:	8b 45 0c             	mov    0xc(%ebp),%eax
80104386:	8b 00                	mov    (%eax),%eax
80104388:	83 ec 0c             	sub    $0xc,%esp
8010438b:	50                   	push   %eax
8010438c:	e8 10 ce ff ff       	call   801011a1 <fileclose>
80104391:	83 c4 10             	add    $0x10,%esp
  return -1;
80104394:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104399:	c9                   	leave  
8010439a:	c3                   	ret    

8010439b <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010439b:	55                   	push   %ebp
8010439c:	89 e5                	mov    %esp,%ebp
8010439e:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801043a1:	8b 45 08             	mov    0x8(%ebp),%eax
801043a4:	83 ec 0c             	sub    $0xc,%esp
801043a7:	50                   	push   %eax
801043a8:	e8 dc 22 00 00       	call   80106689 <acquire>
801043ad:	83 c4 10             	add    $0x10,%esp
  if(writable){
801043b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801043b4:	74 23                	je     801043d9 <pipeclose+0x3e>
    p->writeopen = 0;
801043b6:	8b 45 08             	mov    0x8(%ebp),%eax
801043b9:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801043c0:	00 00 00 
    wakeup(&p->nread);
801043c3:	8b 45 08             	mov    0x8(%ebp),%eax
801043c6:	05 34 02 00 00       	add    $0x234,%eax
801043cb:	83 ec 0c             	sub    $0xc,%esp
801043ce:	50                   	push   %eax
801043cf:	e8 34 13 00 00       	call   80105708 <wakeup>
801043d4:	83 c4 10             	add    $0x10,%esp
801043d7:	eb 21                	jmp    801043fa <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801043d9:	8b 45 08             	mov    0x8(%ebp),%eax
801043dc:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801043e3:	00 00 00 
    wakeup(&p->nwrite);
801043e6:	8b 45 08             	mov    0x8(%ebp),%eax
801043e9:	05 38 02 00 00       	add    $0x238,%eax
801043ee:	83 ec 0c             	sub    $0xc,%esp
801043f1:	50                   	push   %eax
801043f2:	e8 11 13 00 00       	call   80105708 <wakeup>
801043f7:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801043fa:	8b 45 08             	mov    0x8(%ebp),%eax
801043fd:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104403:	85 c0                	test   %eax,%eax
80104405:	75 2c                	jne    80104433 <pipeclose+0x98>
80104407:	8b 45 08             	mov    0x8(%ebp),%eax
8010440a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104410:	85 c0                	test   %eax,%eax
80104412:	75 1f                	jne    80104433 <pipeclose+0x98>
    release(&p->lock);
80104414:	8b 45 08             	mov    0x8(%ebp),%eax
80104417:	83 ec 0c             	sub    $0xc,%esp
8010441a:	50                   	push   %eax
8010441b:	e8 d0 22 00 00       	call   801066f0 <release>
80104420:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104423:	83 ec 0c             	sub    $0xc,%esp
80104426:	ff 75 08             	pushl  0x8(%ebp)
80104429:	e8 a2 e9 ff ff       	call   80102dd0 <kfree>
8010442e:	83 c4 10             	add    $0x10,%esp
80104431:	eb 0f                	jmp    80104442 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104433:	8b 45 08             	mov    0x8(%ebp),%eax
80104436:	83 ec 0c             	sub    $0xc,%esp
80104439:	50                   	push   %eax
8010443a:	e8 b1 22 00 00       	call   801066f0 <release>
8010443f:	83 c4 10             	add    $0x10,%esp
}
80104442:	90                   	nop
80104443:	c9                   	leave  
80104444:	c3                   	ret    

80104445 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80104445:	55                   	push   %ebp
80104446:	89 e5                	mov    %esp,%ebp
80104448:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010444b:	8b 45 08             	mov    0x8(%ebp),%eax
8010444e:	83 ec 0c             	sub    $0xc,%esp
80104451:	50                   	push   %eax
80104452:	e8 32 22 00 00       	call   80106689 <acquire>
80104457:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010445a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104461:	e9 ad 00 00 00       	jmp    80104513 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104466:	8b 45 08             	mov    0x8(%ebp),%eax
80104469:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010446f:	85 c0                	test   %eax,%eax
80104471:	74 0d                	je     80104480 <pipewrite+0x3b>
80104473:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104479:	8b 40 24             	mov    0x24(%eax),%eax
8010447c:	85 c0                	test   %eax,%eax
8010447e:	74 19                	je     80104499 <pipewrite+0x54>
        release(&p->lock);
80104480:	8b 45 08             	mov    0x8(%ebp),%eax
80104483:	83 ec 0c             	sub    $0xc,%esp
80104486:	50                   	push   %eax
80104487:	e8 64 22 00 00       	call   801066f0 <release>
8010448c:	83 c4 10             	add    $0x10,%esp
        return -1;
8010448f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104494:	e9 a8 00 00 00       	jmp    80104541 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104499:	8b 45 08             	mov    0x8(%ebp),%eax
8010449c:	05 34 02 00 00       	add    $0x234,%eax
801044a1:	83 ec 0c             	sub    $0xc,%esp
801044a4:	50                   	push   %eax
801044a5:	e8 5e 12 00 00       	call   80105708 <wakeup>
801044aa:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801044ad:	8b 45 08             	mov    0x8(%ebp),%eax
801044b0:	8b 55 08             	mov    0x8(%ebp),%edx
801044b3:	81 c2 38 02 00 00    	add    $0x238,%edx
801044b9:	83 ec 08             	sub    $0x8,%esp
801044bc:	50                   	push   %eax
801044bd:	52                   	push   %edx
801044be:	e8 d7 10 00 00       	call   8010559a <sleep>
801044c3:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801044c6:	8b 45 08             	mov    0x8(%ebp),%eax
801044c9:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801044cf:	8b 45 08             	mov    0x8(%ebp),%eax
801044d2:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801044d8:	05 00 02 00 00       	add    $0x200,%eax
801044dd:	39 c2                	cmp    %eax,%edx
801044df:	74 85                	je     80104466 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801044e1:	8b 45 08             	mov    0x8(%ebp),%eax
801044e4:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801044ea:	8d 48 01             	lea    0x1(%eax),%ecx
801044ed:	8b 55 08             	mov    0x8(%ebp),%edx
801044f0:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801044f6:	25 ff 01 00 00       	and    $0x1ff,%eax
801044fb:	89 c1                	mov    %eax,%ecx
801044fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104500:	8b 45 0c             	mov    0xc(%ebp),%eax
80104503:	01 d0                	add    %edx,%eax
80104505:	0f b6 10             	movzbl (%eax),%edx
80104508:	8b 45 08             	mov    0x8(%ebp),%eax
8010450b:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010450f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104516:	3b 45 10             	cmp    0x10(%ebp),%eax
80104519:	7c ab                	jl     801044c6 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010451b:	8b 45 08             	mov    0x8(%ebp),%eax
8010451e:	05 34 02 00 00       	add    $0x234,%eax
80104523:	83 ec 0c             	sub    $0xc,%esp
80104526:	50                   	push   %eax
80104527:	e8 dc 11 00 00       	call   80105708 <wakeup>
8010452c:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010452f:	8b 45 08             	mov    0x8(%ebp),%eax
80104532:	83 ec 0c             	sub    $0xc,%esp
80104535:	50                   	push   %eax
80104536:	e8 b5 21 00 00       	call   801066f0 <release>
8010453b:	83 c4 10             	add    $0x10,%esp
  return n;
8010453e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104541:	c9                   	leave  
80104542:	c3                   	ret    

80104543 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104543:	55                   	push   %ebp
80104544:	89 e5                	mov    %esp,%ebp
80104546:	53                   	push   %ebx
80104547:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010454a:	8b 45 08             	mov    0x8(%ebp),%eax
8010454d:	83 ec 0c             	sub    $0xc,%esp
80104550:	50                   	push   %eax
80104551:	e8 33 21 00 00       	call   80106689 <acquire>
80104556:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104559:	eb 3f                	jmp    8010459a <piperead+0x57>
    if(proc->killed){
8010455b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104561:	8b 40 24             	mov    0x24(%eax),%eax
80104564:	85 c0                	test   %eax,%eax
80104566:	74 19                	je     80104581 <piperead+0x3e>
      release(&p->lock);
80104568:	8b 45 08             	mov    0x8(%ebp),%eax
8010456b:	83 ec 0c             	sub    $0xc,%esp
8010456e:	50                   	push   %eax
8010456f:	e8 7c 21 00 00       	call   801066f0 <release>
80104574:	83 c4 10             	add    $0x10,%esp
      return -1;
80104577:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010457c:	e9 bf 00 00 00       	jmp    80104640 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104581:	8b 45 08             	mov    0x8(%ebp),%eax
80104584:	8b 55 08             	mov    0x8(%ebp),%edx
80104587:	81 c2 34 02 00 00    	add    $0x234,%edx
8010458d:	83 ec 08             	sub    $0x8,%esp
80104590:	50                   	push   %eax
80104591:	52                   	push   %edx
80104592:	e8 03 10 00 00       	call   8010559a <sleep>
80104597:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010459a:	8b 45 08             	mov    0x8(%ebp),%eax
8010459d:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801045a3:	8b 45 08             	mov    0x8(%ebp),%eax
801045a6:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801045ac:	39 c2                	cmp    %eax,%edx
801045ae:	75 0d                	jne    801045bd <piperead+0x7a>
801045b0:	8b 45 08             	mov    0x8(%ebp),%eax
801045b3:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801045b9:	85 c0                	test   %eax,%eax
801045bb:	75 9e                	jne    8010455b <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801045bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801045c4:	eb 49                	jmp    8010460f <piperead+0xcc>
    if(p->nread == p->nwrite)
801045c6:	8b 45 08             	mov    0x8(%ebp),%eax
801045c9:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801045cf:	8b 45 08             	mov    0x8(%ebp),%eax
801045d2:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801045d8:	39 c2                	cmp    %eax,%edx
801045da:	74 3d                	je     80104619 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801045dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045df:	8b 45 0c             	mov    0xc(%ebp),%eax
801045e2:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801045e5:	8b 45 08             	mov    0x8(%ebp),%eax
801045e8:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801045ee:	8d 48 01             	lea    0x1(%eax),%ecx
801045f1:	8b 55 08             	mov    0x8(%ebp),%edx
801045f4:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801045fa:	25 ff 01 00 00       	and    $0x1ff,%eax
801045ff:	89 c2                	mov    %eax,%edx
80104601:	8b 45 08             	mov    0x8(%ebp),%eax
80104604:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104609:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010460b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010460f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104612:	3b 45 10             	cmp    0x10(%ebp),%eax
80104615:	7c af                	jl     801045c6 <piperead+0x83>
80104617:	eb 01                	jmp    8010461a <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104619:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010461a:	8b 45 08             	mov    0x8(%ebp),%eax
8010461d:	05 38 02 00 00       	add    $0x238,%eax
80104622:	83 ec 0c             	sub    $0xc,%esp
80104625:	50                   	push   %eax
80104626:	e8 dd 10 00 00       	call   80105708 <wakeup>
8010462b:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010462e:	8b 45 08             	mov    0x8(%ebp),%eax
80104631:	83 ec 0c             	sub    $0xc,%esp
80104634:	50                   	push   %eax
80104635:	e8 b6 20 00 00       	call   801066f0 <release>
8010463a:	83 c4 10             	add    $0x10,%esp
  return i;
8010463d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104643:	c9                   	leave  
80104644:	c3                   	ret    

80104645 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
80104645:	55                   	push   %ebp
80104646:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
80104648:	f4                   	hlt    
}
80104649:	90                   	nop
8010464a:	5d                   	pop    %ebp
8010464b:	c3                   	ret    

8010464c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010464c:	55                   	push   %ebp
8010464d:	89 e5                	mov    %esp,%ebp
8010464f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104652:	9c                   	pushf  
80104653:	58                   	pop    %eax
80104654:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104657:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010465a:	c9                   	leave  
8010465b:	c3                   	ret    

8010465c <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010465c:	55                   	push   %ebp
8010465d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010465f:	fb                   	sti    
}
80104660:	90                   	nop
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret    

80104663 <pinit>:
static struct proc* findByPID(struct proc*, int);
static void promote();

void
pinit(void)
{
80104663:	55                   	push   %ebp
80104664:	89 e5                	mov    %esp,%ebp
80104666:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104669:	83 ec 08             	sub    $0x8,%esp
8010466c:	68 c8 a2 10 80       	push   $0x8010a2c8
80104671:	68 a0 49 11 80       	push   $0x801149a0
80104676:	e8 ec 1f 00 00       	call   80106667 <initlock>
8010467b:	83 c4 10             	add    $0x10,%esp
}
8010467e:	90                   	nop
8010467f:	c9                   	leave  
80104680:	c3                   	ret    

80104681 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104681:	55                   	push   %ebp
80104682:	89 e5                	mov    %esp,%ebp
80104684:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104687:	83 ec 0c             	sub    $0xc,%esp
8010468a:	68 a0 49 11 80       	push   $0x801149a0
8010468f:	e8 f5 1f 00 00       	call   80106689 <acquire>
80104694:	83 c4 10             	add    $0x10,%esp
  /*for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      if(p->state == UNUSED)
          goto found;*/
  p = ptable.pLists.free;
80104697:	a1 f4 70 11 80       	mov    0x801170f4,%eax
8010469c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p)
8010469f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046a3:	75 1a                	jne    801046bf <allocproc+0x3e>
      goto found;
  release(&ptable.lock);
801046a5:	83 ec 0c             	sub    $0xc,%esp
801046a8:	68 a0 49 11 80       	push   $0x801149a0
801046ad:	e8 3e 20 00 00       	call   801066f0 <release>
801046b2:	83 c4 10             	add    $0x10,%esp
  return 0;
801046b5:	b8 00 00 00 00       	mov    $0x0,%eax
801046ba:	e9 6b 01 00 00       	jmp    8010482a <allocproc+0x1a9>
  /*for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      if(p->state == UNUSED)
          goto found;*/
  p = ptable.pLists.free;
  if (p)
      goto found;
801046bf:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  // from free to embryo
  if (removeFromStateList(&ptable.pLists.free, p, UNUSED) < 0)
801046c0:	83 ec 04             	sub    $0x4,%esp
801046c3:	6a 00                	push   $0x0
801046c5:	ff 75 f4             	pushl  -0xc(%ebp)
801046c8:	68 f4 70 11 80       	push   $0x801170f4
801046cd:	e8 9d 1a 00 00       	call   8010616f <removeFromStateList>
801046d2:	83 c4 10             	add    $0x10,%esp
801046d5:	85 c0                	test   %eax,%eax
801046d7:	79 0d                	jns    801046e6 <allocproc+0x65>
      panic("The process is not in the free list - allocproc() routine");
801046d9:	83 ec 0c             	sub    $0xc,%esp
801046dc:	68 d0 a2 10 80       	push   $0x8010a2d0
801046e1:	e8 80 be ff ff       	call   80100566 <panic>
  p->state = EMBRYO;
801046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e9:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  addProcToBegin(&ptable.pLists.embryo, p);
801046f0:	83 ec 08             	sub    $0x8,%esp
801046f3:	ff 75 f4             	pushl  -0xc(%ebp)
801046f6:	68 04 71 11 80       	push   $0x80117104
801046fb:	e8 b6 1b 00 00       	call   801062b6 <addProcToBegin>
80104700:	83 c4 10             	add    $0x10,%esp
  p->pid = nextpid++;
80104703:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104708:	8d 50 01             	lea    0x1(%eax),%edx
8010470b:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104711:	89 c2                	mov    %eax,%edx
80104713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104716:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104719:	83 ec 0c             	sub    $0xc,%esp
8010471c:	68 a0 49 11 80       	push   $0x801149a0
80104721:	e8 ca 1f 00 00       	call   801066f0 <release>
80104726:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104729:	e8 3f e7 ff ff       	call   80102e6d <kalloc>
8010472e:	89 c2                	mov    %eax,%edx
80104730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104733:	89 50 08             	mov    %edx,0x8(%eax)
80104736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104739:	8b 40 08             	mov    0x8(%eax),%eax
8010473c:	85 c0                	test   %eax,%eax
8010473e:	75 4d                	jne    8010478d <allocproc+0x10c>
    // from embryo to free
    if (removeFromStateList(&ptable.pLists.embryo, p, EMBRYO) < 0)
80104740:	83 ec 04             	sub    $0x4,%esp
80104743:	6a 01                	push   $0x1
80104745:	ff 75 f4             	pushl  -0xc(%ebp)
80104748:	68 04 71 11 80       	push   $0x80117104
8010474d:	e8 1d 1a 00 00       	call   8010616f <removeFromStateList>
80104752:	83 c4 10             	add    $0x10,%esp
80104755:	85 c0                	test   %eax,%eax
80104757:	79 0d                	jns    80104766 <allocproc+0xe5>
      panic("The process is not in the embryo list - allocproc() routine");
80104759:	83 ec 0c             	sub    $0xc,%esp
8010475c:	68 0c a3 10 80       	push   $0x8010a30c
80104761:	e8 00 be ff ff       	call   80100566 <panic>
    p->state = UNUSED;
80104766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104769:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    addProcToBegin(&ptable.pLists.free, p);
80104770:	83 ec 08             	sub    $0x8,%esp
80104773:	ff 75 f4             	pushl  -0xc(%ebp)
80104776:	68 f4 70 11 80       	push   $0x801170f4
8010477b:	e8 36 1b 00 00       	call   801062b6 <addProcToBegin>
80104780:	83 c4 10             	add    $0x10,%esp
    return 0;
80104783:	b8 00 00 00 00       	mov    $0x0,%eax
80104788:	e9 9d 00 00 00       	jmp    8010482a <allocproc+0x1a9>
  }
  sp = p->kstack + KSTACKSIZE;
8010478d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104790:	8b 40 08             	mov    0x8(%eax),%eax
80104793:	05 00 10 00 00       	add    $0x1000,%eax
80104798:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010479b:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010479f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047a5:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801047a8:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801047ac:	ba bb 80 10 80       	mov    $0x801080bb,%edx
801047b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047b4:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801047b6:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801047ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047c0:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801047c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c6:	8b 40 1c             	mov    0x1c(%eax),%eax
801047c9:	83 ec 04             	sub    $0x4,%esp
801047cc:	6a 14                	push   $0x14
801047ce:	6a 00                	push   $0x0
801047d0:	50                   	push   %eax
801047d1:	e8 16 21 00 00       	call   801068ec <memset>
801047d6:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801047d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047dc:	8b 40 1c             	mov    0x1c(%eax),%eax
801047df:	ba 54 55 10 80       	mov    $0x80105554,%edx
801047e4:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks;
801047e7:	8b 15 20 79 11 80    	mov    0x80117920,%edx
801047ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f0:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0;
801047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f6:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
801047fd:	00 00 00 
  p->cpu_ticks_in = 0;
80104800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104803:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010480a:	00 00 00 
  p->priority = 0;
8010480d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104810:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104817:	00 00 00 
  p->budget = BUDGET;
8010481a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481d:	c7 80 98 00 00 00 c8 	movl   $0xc8,0x98(%eax)
80104824:	00 00 00 

  return p;
80104827:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010482a:	c9                   	leave  
8010482b:	c3                   	ret    

8010482c <userinit>:

// Set up first user process.
void
userinit(void)
{
8010482c:	55                   	push   %ebp
8010482d:	89 e5                	mov    %esp,%ebp
8010482f:	83 ec 18             	sub    $0x18,%esp
  struct proc* tmp;
  ptable.pLists.free = 0;
80104832:	c7 05 f4 70 11 80 00 	movl   $0x0,0x801170f4
80104839:	00 00 00 
  for(tmp = ptable.proc; tmp < &ptable.proc[NPROC]; tmp++)
8010483c:	c7 45 f4 d4 49 11 80 	movl   $0x801149d4,-0xc(%ebp)
80104843:	eb 1a                	jmp    8010485f <userinit+0x33>
    addProcToBegin(&ptable.pLists.free, tmp);
80104845:	83 ec 08             	sub    $0x8,%esp
80104848:	ff 75 f4             	pushl  -0xc(%ebp)
8010484b:	68 f4 70 11 80       	push   $0x801170f4
80104850:	e8 61 1a 00 00       	call   801062b6 <addProcToBegin>
80104855:	83 c4 10             	add    $0x10,%esp
void
userinit(void)
{
  struct proc* tmp;
  ptable.pLists.free = 0;
  for(tmp = ptable.proc; tmp < &ptable.proc[NPROC]; tmp++)
80104858:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
8010485f:	81 7d f4 d4 70 11 80 	cmpl   $0x801170d4,-0xc(%ebp)
80104866:	72 dd                	jb     80104845 <userinit+0x19>
    addProcToBegin(&ptable.pLists.free, tmp);
  ptable.pLists.embryo = 0;
80104868:	c7 05 04 71 11 80 00 	movl   $0x0,0x80117104
8010486f:	00 00 00 
  ptable.pLists.sleep = 0;
80104872:	c7 05 f8 70 11 80 00 	movl   $0x0,0x801170f8
80104879:	00 00 00 
  ptable.pLists.zombie = 0;
8010487c:	c7 05 fc 70 11 80 00 	movl   $0x0,0x801170fc
80104883:	00 00 00 
  ptable.pLists.running = 0;
80104886:	c7 05 00 71 11 80 00 	movl   $0x0,0x80117100
8010488d:	00 00 00 
  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
80104890:	a1 20 79 11 80       	mov    0x80117920,%eax
80104895:	05 f4 01 00 00       	add    $0x1f4,%eax
8010489a:	a3 08 71 11 80       	mov    %eax,0x80117108
  for (int i = 0; i <= MAX; i++) {
8010489f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801048a6:	eb 17                	jmp    801048bf <userinit+0x93>
    ptable.pLists.ready[i] = 0;
801048a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048ab:	05 cc 09 00 00       	add    $0x9cc,%eax
801048b0:	c7 04 85 a4 49 11 80 	movl   $0x0,-0x7feeb65c(,%eax,4)
801048b7:	00 00 00 00 
  ptable.pLists.embryo = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.running = 0;
  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
  for (int i = 0; i <= MAX; i++) {
801048bb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048bf:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
801048c3:	7e e3                	jle    801048a8 <userinit+0x7c>
  }

  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801048c5:	e8 b7 fd ff ff       	call   80104681 <allocproc>
801048ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  initproc = p;
801048cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048d0:	a3 88 d6 10 80       	mov    %eax,0x8010d688
  if((p->pgdir = setupkvm()) == 0)
801048d5:	e8 80 4e 00 00       	call   8010975a <setupkvm>
801048da:	89 c2                	mov    %eax,%edx
801048dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048df:	89 50 04             	mov    %edx,0x4(%eax)
801048e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048e5:	8b 40 04             	mov    0x4(%eax),%eax
801048e8:	85 c0                	test   %eax,%eax
801048ea:	75 0d                	jne    801048f9 <userinit+0xcd>
    panic("userinit: out of memory?");
801048ec:	83 ec 0c             	sub    $0xc,%esp
801048ef:	68 48 a3 10 80       	push   $0x8010a348
801048f4:	e8 6d bc ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801048f9:	ba 2c 00 00 00       	mov    $0x2c,%edx
801048fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104901:	8b 40 04             	mov    0x4(%eax),%eax
80104904:	83 ec 04             	sub    $0x4,%esp
80104907:	52                   	push   %edx
80104908:	68 20 d5 10 80       	push   $0x8010d520
8010490d:	50                   	push   %eax
8010490e:	e8 a1 50 00 00       	call   801099b4 <inituvm>
80104913:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104916:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104919:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010491f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104922:	8b 40 18             	mov    0x18(%eax),%eax
80104925:	83 ec 04             	sub    $0x4,%esp
80104928:	6a 4c                	push   $0x4c
8010492a:	6a 00                	push   $0x0
8010492c:	50                   	push   %eax
8010492d:	e8 ba 1f 00 00       	call   801068ec <memset>
80104932:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104935:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104938:	8b 40 18             	mov    0x18(%eax),%eax
8010493b:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104941:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104944:	8b 40 18             	mov    0x18(%eax),%eax
80104947:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010494d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104950:	8b 40 18             	mov    0x18(%eax),%eax
80104953:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104956:	8b 52 18             	mov    0x18(%edx),%edx
80104959:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010495d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104961:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104964:	8b 40 18             	mov    0x18(%eax),%eax
80104967:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010496a:	8b 52 18             	mov    0x18(%edx),%edx
8010496d:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104971:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104975:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104978:	8b 40 18             	mov    0x18(%eax),%eax
8010497b:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104982:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104985:	8b 40 18             	mov    0x18(%eax),%eax
80104988:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010498f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104992:	8b 40 18             	mov    0x18(%eax),%eax
80104995:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010499c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010499f:	83 c0 6c             	add    $0x6c,%eax
801049a2:	83 ec 04             	sub    $0x4,%esp
801049a5:	6a 10                	push   $0x10
801049a7:	68 61 a3 10 80       	push   $0x8010a361
801049ac:	50                   	push   %eax
801049ad:	e8 3d 21 00 00       	call   80106aef <safestrcpy>
801049b2:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801049b5:	83 ec 0c             	sub    $0xc,%esp
801049b8:	68 6a a3 10 80       	push   $0x8010a36a
801049bd:	e8 6d dd ff ff       	call   8010272f <namei>
801049c2:	83 c4 10             	add    $0x10,%esp
801049c5:	89 c2                	mov    %eax,%edx
801049c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ca:	89 50 68             	mov    %edx,0x68(%eax)

  p->uid = UID;
801049cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049d0:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
801049d7:	00 00 00 
  p->gid = GID;
801049da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049dd:	c7 80 84 00 00 00 01 	movl   $0x1,0x84(%eax)
801049e4:	00 00 00 
  // from embryo to ready
  if (removeFromStateList(&ptable.pLists.embryo, p, EMBRYO) < 0)
801049e7:	83 ec 04             	sub    $0x4,%esp
801049ea:	6a 01                	push   $0x1
801049ec:	ff 75 ec             	pushl  -0x14(%ebp)
801049ef:	68 04 71 11 80       	push   $0x80117104
801049f4:	e8 76 17 00 00       	call   8010616f <removeFromStateList>
801049f9:	83 c4 10             	add    $0x10,%esp
801049fc:	85 c0                	test   %eax,%eax
801049fe:	79 0d                	jns    80104a0d <userinit+0x1e1>
      panic("The process is not in the embryo list - userinit() routine");
80104a00:	83 ec 0c             	sub    $0xc,%esp
80104a03:	68 6c a3 10 80       	push   $0x8010a36c
80104a08:	e8 59 bb ff ff       	call   80100566 <panic>
  p->state = RUNNABLE;
80104a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a10:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  addProcToLast(&ptable.pLists.ready[p->priority], p);
80104a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a1a:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104a20:	05 cc 09 00 00       	add    $0x9cc,%eax
80104a25:	c1 e0 02             	shl    $0x2,%eax
80104a28:	05 a0 49 11 80       	add    $0x801149a0,%eax
80104a2d:	83 c0 04             	add    $0x4,%eax
80104a30:	83 ec 08             	sub    $0x8,%esp
80104a33:	ff 75 ec             	pushl  -0x14(%ebp)
80104a36:	50                   	push   %eax
80104a37:	e8 fb 17 00 00       	call   80106237 <addProcToLast>
80104a3c:	83 c4 10             	add    $0x10,%esp
}
80104a3f:	90                   	nop
80104a40:	c9                   	leave  
80104a41:	c3                   	ret    

80104a42 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104a42:	55                   	push   %ebp
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104a48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a4e:	8b 00                	mov    (%eax),%eax
80104a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104a53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a57:	7e 31                	jle    80104a8a <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104a59:	8b 55 08             	mov    0x8(%ebp),%edx
80104a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a5f:	01 c2                	add    %eax,%edx
80104a61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a67:	8b 40 04             	mov    0x4(%eax),%eax
80104a6a:	83 ec 04             	sub    $0x4,%esp
80104a6d:	52                   	push   %edx
80104a6e:	ff 75 f4             	pushl  -0xc(%ebp)
80104a71:	50                   	push   %eax
80104a72:	e8 8a 50 00 00       	call   80109b01 <allocuvm>
80104a77:	83 c4 10             	add    $0x10,%esp
80104a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a81:	75 3e                	jne    80104ac1 <growproc+0x7f>
      return -1;
80104a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a88:	eb 59                	jmp    80104ae3 <growproc+0xa1>
  } else if(n < 0){
80104a8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a8e:	79 31                	jns    80104ac1 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104a90:	8b 55 08             	mov    0x8(%ebp),%edx
80104a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a96:	01 c2                	add    %eax,%edx
80104a98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a9e:	8b 40 04             	mov    0x4(%eax),%eax
80104aa1:	83 ec 04             	sub    $0x4,%esp
80104aa4:	52                   	push   %edx
80104aa5:	ff 75 f4             	pushl  -0xc(%ebp)
80104aa8:	50                   	push   %eax
80104aa9:	e8 1c 51 00 00       	call   80109bca <deallocuvm>
80104aae:	83 c4 10             	add    $0x10,%esp
80104ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ab4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104ab8:	75 07                	jne    80104ac1 <growproc+0x7f>
      return -1;
80104aba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104abf:	eb 22                	jmp    80104ae3 <growproc+0xa1>
  }
  proc->sz = sz;
80104ac1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aca:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104acc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad2:	83 ec 0c             	sub    $0xc,%esp
80104ad5:	50                   	push   %eax
80104ad6:	e8 66 4d 00 00       	call   80109841 <switchuvm>
80104adb:	83 c4 10             	add    $0x10,%esp
  return 0;
80104ade:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ae3:	c9                   	leave  
80104ae4:	c3                   	ret    

80104ae5 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104ae5:	55                   	push   %ebp
80104ae6:	89 e5                	mov    %esp,%ebp
80104ae8:	57                   	push   %edi
80104ae9:	56                   	push   %esi
80104aea:	53                   	push   %ebx
80104aeb:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104aee:	e8 8e fb ff ff       	call   80104681 <allocproc>
80104af3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104af6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104afa:	75 0a                	jne    80104b06 <fork+0x21>
    return -1;
80104afc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b01:	e9 19 02 00 00       	jmp    80104d1f <fork+0x23a>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104b06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b0c:	8b 10                	mov    (%eax),%edx
80104b0e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b14:	8b 40 04             	mov    0x4(%eax),%eax
80104b17:	83 ec 08             	sub    $0x8,%esp
80104b1a:	52                   	push   %edx
80104b1b:	50                   	push   %eax
80104b1c:	e8 47 52 00 00       	call   80109d68 <copyuvm>
80104b21:	83 c4 10             	add    $0x10,%esp
80104b24:	89 c2                	mov    %eax,%edx
80104b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b29:	89 50 04             	mov    %edx,0x4(%eax)
80104b2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b2f:	8b 40 04             	mov    0x4(%eax),%eax
80104b32:	85 c0                	test   %eax,%eax
80104b34:	75 69                	jne    80104b9f <fork+0xba>
    kfree(np->kstack);
80104b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b39:	8b 40 08             	mov    0x8(%eax),%eax
80104b3c:	83 ec 0c             	sub    $0xc,%esp
80104b3f:	50                   	push   %eax
80104b40:	e8 8b e2 ff ff       	call   80102dd0 <kfree>
80104b45:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    // from embryo to free
    if (removeFromStateList(&ptable.pLists.embryo, np, EMBRYO) < 0)
80104b52:	83 ec 04             	sub    $0x4,%esp
80104b55:	6a 01                	push   $0x1
80104b57:	ff 75 e0             	pushl  -0x20(%ebp)
80104b5a:	68 04 71 11 80       	push   $0x80117104
80104b5f:	e8 0b 16 00 00       	call   8010616f <removeFromStateList>
80104b64:	83 c4 10             	add    $0x10,%esp
80104b67:	85 c0                	test   %eax,%eax
80104b69:	79 0d                	jns    80104b78 <fork+0x93>
      panic("The process is not in the embryo list - fork() routine");
80104b6b:	83 ec 0c             	sub    $0xc,%esp
80104b6e:	68 a8 a3 10 80       	push   $0x8010a3a8
80104b73:	e8 ee b9 ff ff       	call   80100566 <panic>
    np->state = UNUSED;
80104b78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b7b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    addProcToBegin(&ptable.pLists.free, np);
80104b82:	83 ec 08             	sub    $0x8,%esp
80104b85:	ff 75 e0             	pushl  -0x20(%ebp)
80104b88:	68 f4 70 11 80       	push   $0x801170f4
80104b8d:	e8 24 17 00 00       	call   801062b6 <addProcToBegin>
80104b92:	83 c4 10             	add    $0x10,%esp
    return -1;
80104b95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b9a:	e9 80 01 00 00       	jmp    80104d1f <fork+0x23a>
  }
  np->sz = proc->sz;
80104b9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba5:	8b 10                	mov    (%eax),%edx
80104ba7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104baa:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104bac:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bb6:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bbc:	8b 50 18             	mov    0x18(%eax),%edx
80104bbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bc5:	8b 40 18             	mov    0x18(%eax),%eax
80104bc8:	89 c3                	mov    %eax,%ebx
80104bca:	b8 13 00 00 00       	mov    $0x13,%eax
80104bcf:	89 d7                	mov    %edx,%edi
80104bd1:	89 de                	mov    %ebx,%esi
80104bd3:	89 c1                	mov    %eax,%ecx
80104bd5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  
  // Copy uid and gid
  np->uid = proc->uid;
80104bd7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bdd:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104be3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104be6:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;
80104bec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104bf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bfb:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c04:	8b 40 18             	mov    0x18(%eax),%eax
80104c07:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104c0e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104c15:	eb 43                	jmp    80104c5a <fork+0x175>
    if(proc->ofile[i])
80104c17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c20:	83 c2 08             	add    $0x8,%edx
80104c23:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c27:	85 c0                	test   %eax,%eax
80104c29:	74 2b                	je     80104c56 <fork+0x171>
      np->ofile[i] = filedup(proc->ofile[i]);
80104c2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c34:	83 c2 08             	add    $0x8,%edx
80104c37:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c3b:	83 ec 0c             	sub    $0xc,%esp
80104c3e:	50                   	push   %eax
80104c3f:	e8 0c c5 ff ff       	call   80101150 <filedup>
80104c44:	83 c4 10             	add    $0x10,%esp
80104c47:	89 c1                	mov    %eax,%ecx
80104c49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c4f:	83 c2 08             	add    $0x8,%edx
80104c52:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np->gid = proc->gid;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104c56:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104c5a:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104c5e:	7e b7                	jle    80104c17 <fork+0x132>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104c60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c66:	8b 40 68             	mov    0x68(%eax),%eax
80104c69:	83 ec 0c             	sub    $0xc,%esp
80104c6c:	50                   	push   %eax
80104c6d:	e8 75 ce ff ff       	call   80101ae7 <idup>
80104c72:	83 c4 10             	add    $0x10,%esp
80104c75:	89 c2                	mov    %eax,%edx
80104c77:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c7a:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104c7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c83:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c89:	83 c0 6c             	add    $0x6c,%eax
80104c8c:	83 ec 04             	sub    $0x4,%esp
80104c8f:	6a 10                	push   $0x10
80104c91:	52                   	push   %edx
80104c92:	50                   	push   %eax
80104c93:	e8 57 1e 00 00       	call   80106aef <safestrcpy>
80104c98:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c9e:	8b 40 10             	mov    0x10(%eax),%eax
80104ca1:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104ca4:	83 ec 0c             	sub    $0xc,%esp
80104ca7:	68 a0 49 11 80       	push   $0x801149a0
80104cac:	e8 d8 19 00 00       	call   80106689 <acquire>
80104cb1:	83 c4 10             	add    $0x10,%esp
  if (removeFromStateList(&ptable.pLists.embryo, np, EMBRYO) < 0)
80104cb4:	83 ec 04             	sub    $0x4,%esp
80104cb7:	6a 01                	push   $0x1
80104cb9:	ff 75 e0             	pushl  -0x20(%ebp)
80104cbc:	68 04 71 11 80       	push   $0x80117104
80104cc1:	e8 a9 14 00 00       	call   8010616f <removeFromStateList>
80104cc6:	83 c4 10             	add    $0x10,%esp
80104cc9:	85 c0                	test   %eax,%eax
80104ccb:	79 0d                	jns    80104cda <fork+0x1f5>
    panic("The process is not in the embryo list - fork() routine");
80104ccd:	83 ec 0c             	sub    $0xc,%esp
80104cd0:	68 a8 a3 10 80       	push   $0x8010a3a8
80104cd5:	e8 8c b8 ff ff       	call   80100566 <panic>
  np->state = RUNNABLE;
80104cda:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cdd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  addProcToLast(&ptable.pLists.ready[np->priority], np);
80104ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ce7:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104ced:	05 cc 09 00 00       	add    $0x9cc,%eax
80104cf2:	c1 e0 02             	shl    $0x2,%eax
80104cf5:	05 a0 49 11 80       	add    $0x801149a0,%eax
80104cfa:	83 c0 04             	add    $0x4,%eax
80104cfd:	83 ec 08             	sub    $0x8,%esp
80104d00:	ff 75 e0             	pushl  -0x20(%ebp)
80104d03:	50                   	push   %eax
80104d04:	e8 2e 15 00 00       	call   80106237 <addProcToLast>
80104d09:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104d0c:	83 ec 0c             	sub    $0xc,%esp
80104d0f:	68 a0 49 11 80       	push   $0x801149a0
80104d14:	e8 d7 19 00 00       	call   801066f0 <release>
80104d19:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104d1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d22:	5b                   	pop    %ebx
80104d23:	5e                   	pop    %esi
80104d24:	5f                   	pop    %edi
80104d25:	5d                   	pop    %ebp
80104d26:	c3                   	ret    

80104d27 <exit>:
  panic("zombie exit");
}
#else
void
exit(void)
{
80104d27:	55                   	push   %ebp
80104d28:	89 e5                	mov    %esp,%ebp
80104d2a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104d2d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d34:	a1 88 d6 10 80       	mov    0x8010d688,%eax
80104d39:	39 c2                	cmp    %eax,%edx
80104d3b:	75 0d                	jne    80104d4a <exit+0x23>
    panic("init exiting");
80104d3d:	83 ec 0c             	sub    $0xc,%esp
80104d40:	68 df a3 10 80       	push   $0x8010a3df
80104d45:	e8 1c b8 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104d4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104d51:	eb 48                	jmp    80104d9b <exit+0x74>
    if(proc->ofile[fd]){
80104d53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d59:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d5c:	83 c2 08             	add    $0x8,%edx
80104d5f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104d63:	85 c0                	test   %eax,%eax
80104d65:	74 30                	je     80104d97 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104d67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d70:	83 c2 08             	add    $0x8,%edx
80104d73:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104d77:	83 ec 0c             	sub    $0xc,%esp
80104d7a:	50                   	push   %eax
80104d7b:	e8 21 c4 ff ff       	call   801011a1 <fileclose>
80104d80:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104d83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d89:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d8c:	83 c2 08             	add    $0x8,%edx
80104d8f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104d96:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104d97:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104d9b:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104d9f:	7e b2                	jle    80104d53 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104da1:	e8 ae e9 ff ff       	call   80103754 <begin_op>
  iput(proc->cwd);
80104da6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dac:	8b 40 68             	mov    0x68(%eax),%eax
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	50                   	push   %eax
80104db3:	e8 61 cf ff ff       	call   80101d19 <iput>
80104db8:	83 c4 10             	add    $0x10,%esp
  end_op();
80104dbb:	e8 20 ea ff ff       	call   801037e0 <end_op>
  proc->cwd = 0;
80104dc0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc6:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104dcd:	83 ec 0c             	sub    $0xc,%esp
80104dd0:	68 a0 49 11 80       	push   $0x801149a0
80104dd5:	e8 af 18 00 00       	call   80106689 <acquire>
80104dda:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104ddd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de3:	8b 40 14             	mov    0x14(%eax),%eax
80104de6:	83 ec 0c             	sub    $0xc,%esp
80104de9:	50                   	push   %eax
80104dea:	e8 91 08 00 00       	call   80105680 <wakeup1>
80104def:	83 c4 10             	add    $0x10,%esp

  for (p = ptable.pLists.running; p; p = p->next) {
80104df2:	a1 00 71 11 80       	mov    0x80117100,%eax
80104df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104dfa:	eb 28                	jmp    80104e24 <exit+0xfd>
      if (p->parent == proc) {
80104dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dff:	8b 50 14             	mov    0x14(%eax),%edx
80104e02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e08:	39 c2                	cmp    %eax,%edx
80104e0a:	75 0c                	jne    80104e18 <exit+0xf1>
          p->parent = initproc;
80104e0c:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
80104e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e15:	89 50 14             	mov    %edx,0x14(%eax)
  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  for (p = ptable.pLists.running; p; p = p->next) {
80104e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e1b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104e24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e28:	75 d2                	jne    80104dfc <exit+0xd5>
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (int i = 0; i <= MAX; i++) {
80104e2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104e31:	eb 46                	jmp    80104e79 <exit+0x152>
    for (p = ptable.pLists.ready[i]; p; p = p->next) {
80104e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e36:	05 cc 09 00 00       	add    $0x9cc,%eax
80104e3b:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
80104e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104e45:	eb 28                	jmp    80104e6f <exit+0x148>
      if (p->parent == proc) {
80104e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e4a:	8b 50 14             	mov    0x14(%eax),%edx
80104e4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e53:	39 c2                	cmp    %eax,%edx
80104e55:	75 0c                	jne    80104e63 <exit+0x13c>
        p->parent = initproc;
80104e57:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
80104e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e60:	89 50 14             	mov    %edx,0x14(%eax)
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (int i = 0; i <= MAX; i++) {
    for (p = ptable.pLists.ready[i]; p; p = p->next) {
80104e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e66:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e73:	75 d2                	jne    80104e47 <exit+0x120>
  for (p = ptable.pLists.running; p; p = p->next) {
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (int i = 0; i <= MAX; i++) {
80104e75:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104e79:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80104e7d:	7e b4                	jle    80104e33 <exit+0x10c>
      if (p->parent == proc) {
        p->parent = initproc;
      }
    }
  }
  for (p = ptable.pLists.embryo; p; p = p->next) {
80104e7f:	a1 04 71 11 80       	mov    0x80117104,%eax
80104e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104e87:	eb 28                	jmp    80104eb1 <exit+0x18a>
      if (p->parent == proc) {
80104e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8c:	8b 50 14             	mov    0x14(%eax),%edx
80104e8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e95:	39 c2                	cmp    %eax,%edx
80104e97:	75 0c                	jne    80104ea5 <exit+0x17e>
          p->parent = initproc;
80104e99:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
80104e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea2:	89 50 14             	mov    %edx,0x14(%eax)
      if (p->parent == proc) {
        p->parent = initproc;
      }
    }
  }
  for (p = ptable.pLists.embryo; p; p = p->next) {
80104ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104eb5:	75 d2                	jne    80104e89 <exit+0x162>
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (p = ptable.pLists.sleep; p; p = p->next) {
80104eb7:	a1 f8 70 11 80       	mov    0x801170f8,%eax
80104ebc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ebf:	eb 28                	jmp    80104ee9 <exit+0x1c2>
      if (p->parent == proc) {
80104ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec4:	8b 50 14             	mov    0x14(%eax),%edx
80104ec7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ecd:	39 c2                	cmp    %eax,%edx
80104ecf:	75 0c                	jne    80104edd <exit+0x1b6>
          p->parent = initproc;
80104ed1:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
80104ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eda:	89 50 14             	mov    %edx,0x14(%eax)
  for (p = ptable.pLists.embryo; p; p = p->next) {
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (p = ptable.pLists.sleep; p; p = p->next) {
80104edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ee9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104eed:	75 d2                	jne    80104ec1 <exit+0x19a>
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (p = ptable.pLists.zombie; p; p = p->next) {
80104eef:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80104ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ef7:	eb 39                	jmp    80104f32 <exit+0x20b>
      if (p->parent == proc) {
80104ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104efc:	8b 50 14             	mov    0x14(%eax),%edx
80104eff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f05:	39 c2                	cmp    %eax,%edx
80104f07:	75 1d                	jne    80104f26 <exit+0x1ff>
          p->parent = initproc;
80104f09:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
80104f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f12:	89 50 14             	mov    %edx,0x14(%eax)
          wakeup1(initproc);
80104f15:	a1 88 d6 10 80       	mov    0x8010d688,%eax
80104f1a:	83 ec 0c             	sub    $0xc,%esp
80104f1d:	50                   	push   %eax
80104f1e:	e8 5d 07 00 00       	call   80105680 <wakeup1>
80104f23:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.pLists.sleep; p; p = p->next) {
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (p = ptable.pLists.zombie; p; p = p->next) {
80104f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f29:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f36:	75 c1                	jne    80104ef9 <exit+0x1d2>
          wakeup1(initproc);
      }
  }

  // Jump into the scheduler, never to return.
  if (removeFromStateList(&ptable.pLists.running, proc, RUNNING) < 0)
80104f38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f3e:	83 ec 04             	sub    $0x4,%esp
80104f41:	6a 04                	push   $0x4
80104f43:	50                   	push   %eax
80104f44:	68 00 71 11 80       	push   $0x80117100
80104f49:	e8 21 12 00 00       	call   8010616f <removeFromStateList>
80104f4e:	83 c4 10             	add    $0x10,%esp
80104f51:	85 c0                	test   %eax,%eax
80104f53:	79 0d                	jns    80104f62 <exit+0x23b>
    panic("The proc is not in the running list - exit() routine");
80104f55:	83 ec 0c             	sub    $0xc,%esp
80104f58:	68 ec a3 10 80       	push   $0x8010a3ec
80104f5d:	e8 04 b6 ff ff       	call   80100566 <panic>
  proc->state = ZOMBIE;  
80104f62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f68:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  addProcToBegin(&ptable.pLists.zombie, proc);
80104f6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f75:	83 ec 08             	sub    $0x8,%esp
80104f78:	50                   	push   %eax
80104f79:	68 fc 70 11 80       	push   $0x801170fc
80104f7e:	e8 33 13 00 00       	call   801062b6 <addProcToBegin>
80104f83:	83 c4 10             	add    $0x10,%esp
  sched();
80104f86:	e8 e6 03 00 00       	call   80105371 <sched>
  panic("zombie exit");
80104f8b:	83 ec 0c             	sub    $0xc,%esp
80104f8e:	68 21 a4 10 80       	push   $0x8010a421
80104f93:	e8 ce b5 ff ff       	call   80100566 <panic>

80104f98 <wait>:
  }
}
#else
int
wait(void)
{
80104f98:	55                   	push   %ebp
80104f99:	89 e5                	mov    %esp,%ebp
80104f9b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104f9e:	83 ec 0c             	sub    $0xc,%esp
80104fa1:	68 a0 49 11 80       	push   $0x801149a0
80104fa6:	e8 de 16 00 00       	call   80106689 <acquire>
80104fab:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104fae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.pLists.zombie; p; p = p->next){
80104fb5:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80104fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104fbd:	e9 df 00 00 00       	jmp    801050a1 <wait+0x109>
      if(p->parent != proc)
80104fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc5:	8b 50 14             	mov    0x14(%eax),%edx
80104fc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fce:	39 c2                	cmp    %eax,%edx
80104fd0:	74 11                	je     80104fe3 <wait+0x4b>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.pLists.zombie; p; p = p->next){
80104fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104fde:	e9 be 00 00 00       	jmp    801050a1 <wait+0x109>
      if(p->parent != proc)
        continue;
      havekids = 1;
80104fe3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      pid = p->pid;
80104fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fed:	8b 40 10             	mov    0x10(%eax),%eax
80104ff0:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(p->kstack);
80104ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff6:	8b 40 08             	mov    0x8(%eax),%eax
80104ff9:	83 ec 0c             	sub    $0xc,%esp
80104ffc:	50                   	push   %eax
80104ffd:	e8 ce dd ff ff       	call   80102dd0 <kfree>
80105002:	83 c4 10             	add    $0x10,%esp
      p->kstack = 0;
80105005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105008:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      freevm(p->pgdir);
8010500f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105012:	8b 40 04             	mov    0x4(%eax),%eax
80105015:	83 ec 0c             	sub    $0xc,%esp
80105018:	50                   	push   %eax
80105019:	e8 69 4c 00 00       	call   80109c87 <freevm>
8010501e:	83 c4 10             	add    $0x10,%esp
      if (removeFromStateList(&ptable.pLists.zombie, p, ZOMBIE) < 0)
80105021:	83 ec 04             	sub    $0x4,%esp
80105024:	6a 05                	push   $0x5
80105026:	ff 75 f4             	pushl  -0xc(%ebp)
80105029:	68 fc 70 11 80       	push   $0x801170fc
8010502e:	e8 3c 11 00 00       	call   8010616f <removeFromStateList>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	79 0d                	jns    80105047 <wait+0xaf>
        panic("Cannot remove the proc from the zombie list - wait() routine");
8010503a:	83 ec 0c             	sub    $0xc,%esp
8010503d:	68 30 a4 10 80       	push   $0x8010a430
80105042:	e8 1f b5 ff ff       	call   80100566 <panic>
      p->state = UNUSED;
80105047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010504a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
      addProcToBegin(&ptable.pLists.free, p);
80105051:	83 ec 08             	sub    $0x8,%esp
80105054:	ff 75 f4             	pushl  -0xc(%ebp)
80105057:	68 f4 70 11 80       	push   $0x801170f4
8010505c:	e8 55 12 00 00       	call   801062b6 <addProcToBegin>
80105061:	83 c4 10             	add    $0x10,%esp
      p->pid = 0;
80105064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105067:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
      p->parent = 0;
8010506e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105071:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
      p->name[0] = 0;
80105078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
      p->killed = 0;
8010507f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105082:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
      release(&ptable.lock);
80105089:	83 ec 0c             	sub    $0xc,%esp
8010508c:	68 a0 49 11 80       	push   $0x801149a0
80105091:	e8 5a 16 00 00       	call   801066f0 <release>
80105096:	83 c4 10             	add    $0x10,%esp
      return pid;
80105099:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010509c:	e9 4c 01 00 00       	jmp    801051ed <wait+0x255>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.pLists.zombie; p; p = p->next){
801050a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050a5:	0f 85 17 ff ff ff    	jne    80104fc2 <wait+0x2a>
      p->name[0] = 0;
      p->killed = 0;
      release(&ptable.lock);
      return pid;
    }
    for(int i = 0; i <= MAX; i++) {
801050ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801050b2:	eb 48                	jmp    801050fc <wait+0x164>
      for(p = ptable.pLists.ready[i]; p; p = p->next) {
801050b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050b7:	05 cc 09 00 00       	add    $0x9cc,%eax
801050bc:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
801050c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050c6:	eb 2a                	jmp    801050f2 <wait+0x15a>
        if(p->parent != proc)
801050c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050cb:	8b 50 14             	mov    0x14(%eax),%edx
801050ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050d4:	39 c2                	cmp    %eax,%edx
801050d6:	74 0e                	je     801050e6 <wait+0x14e>
      p->killed = 0;
      release(&ptable.lock);
      return pid;
    }
    for(int i = 0; i <= MAX; i++) {
      for(p = ptable.pLists.ready[i]; p; p = p->next) {
801050d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050db:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801050e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801050e4:	eb 0c                	jmp    801050f2 <wait+0x15a>
        if(p->parent != proc)
          continue;
        havekids = 1;
801050e6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        goto out;
801050ed:	e9 b5 00 00 00       	jmp    801051a7 <wait+0x20f>
      p->killed = 0;
      release(&ptable.lock);
      return pid;
    }
    for(int i = 0; i <= MAX; i++) {
      for(p = ptable.pLists.ready[i]; p; p = p->next) {
801050f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050f6:	75 d0                	jne    801050c8 <wait+0x130>
      p->name[0] = 0;
      p->killed = 0;
      release(&ptable.lock);
      return pid;
    }
    for(int i = 0; i <= MAX; i++) {
801050f8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801050fc:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80105100:	7e b2                	jle    801050b4 <wait+0x11c>
          continue;
        havekids = 1;
        goto out;
      }
    }
    for(p = ptable.pLists.running; p; p = p->next) {
80105102:	a1 00 71 11 80       	mov    0x80117100,%eax
80105107:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010510a:	eb 27                	jmp    80105133 <wait+0x19b>
      if(p->parent != proc)
8010510c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010510f:	8b 50 14             	mov    0x14(%eax),%edx
80105112:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105118:	39 c2                	cmp    %eax,%edx
8010511a:	74 0e                	je     8010512a <wait+0x192>
          continue;
        havekids = 1;
        goto out;
      }
    }
    for(p = ptable.pLists.running; p; p = p->next) {
8010511c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010511f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105128:	eb 09                	jmp    80105133 <wait+0x19b>
      if(p->parent != proc)
        continue;
      havekids = 1;
8010512a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      goto out;
80105131:	eb 74                	jmp    801051a7 <wait+0x20f>
          continue;
        havekids = 1;
        goto out;
      }
    }
    for(p = ptable.pLists.running; p; p = p->next) {
80105133:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105137:	75 d3                	jne    8010510c <wait+0x174>
      if(p->parent != proc)
        continue;
      havekids = 1;
      goto out;
    }
    for(p = ptable.pLists.sleep; p; p = p->next) {
80105139:	a1 f8 70 11 80       	mov    0x801170f8,%eax
8010513e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105141:	eb 27                	jmp    8010516a <wait+0x1d2>
      if(p->parent != proc)
80105143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105146:	8b 50 14             	mov    0x14(%eax),%edx
80105149:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514f:	39 c2                	cmp    %eax,%edx
80105151:	74 0e                	je     80105161 <wait+0x1c9>
      if(p->parent != proc)
        continue;
      havekids = 1;
      goto out;
    }
    for(p = ptable.pLists.sleep; p; p = p->next) {
80105153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105156:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010515c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010515f:	eb 09                	jmp    8010516a <wait+0x1d2>
      if(p->parent != proc)
        continue;
      havekids = 1;
80105161:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      goto out;
80105168:	eb 3d                	jmp    801051a7 <wait+0x20f>
      if(p->parent != proc)
        continue;
      havekids = 1;
      goto out;
    }
    for(p = ptable.pLists.sleep; p; p = p->next) {
8010516a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010516e:	75 d3                	jne    80105143 <wait+0x1ab>
      if(p->parent != proc)
        continue;
      havekids = 1;
      goto out;
    }
    for(p = ptable.pLists.embryo; p; p = p->next) {
80105170:	a1 04 71 11 80       	mov    0x80117104,%eax
80105175:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105178:	eb 27                	jmp    801051a1 <wait+0x209>
      if(p->parent != proc)
8010517a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010517d:	8b 50 14             	mov    0x14(%eax),%edx
80105180:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105186:	39 c2                	cmp    %eax,%edx
80105188:	74 0e                	je     80105198 <wait+0x200>
      if(p->parent != proc)
        continue;
      havekids = 1;
      goto out;
    }
    for(p = ptable.pLists.embryo; p; p = p->next) {
8010518a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010518d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105193:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105196:	eb 09                	jmp    801051a1 <wait+0x209>
      if(p->parent != proc)
        continue;
      havekids = 1;
80105198:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      goto out;
8010519f:	eb 06                	jmp    801051a7 <wait+0x20f>
      if(p->parent != proc)
        continue;
      havekids = 1;
      goto out;
    }
    for(p = ptable.pLists.embryo; p; p = p->next) {
801051a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051a5:	75 d3                	jne    8010517a <wait+0x1e2>
      havekids = 1;
      goto out;
    }
out:
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801051a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801051ab:	74 0d                	je     801051ba <wait+0x222>
801051ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051b3:	8b 40 24             	mov    0x24(%eax),%eax
801051b6:	85 c0                	test   %eax,%eax
801051b8:	74 17                	je     801051d1 <wait+0x239>
      release(&ptable.lock);
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	68 a0 49 11 80       	push   $0x801149a0
801051c2:	e8 29 15 00 00       	call   801066f0 <release>
801051c7:	83 c4 10             	add    $0x10,%esp
      return -1;
801051ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051cf:	eb 1c                	jmp    801051ed <wait+0x255>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801051d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051d7:	83 ec 08             	sub    $0x8,%esp
801051da:	68 a0 49 11 80       	push   $0x801149a0
801051df:	50                   	push   %eax
801051e0:	e8 b5 03 00 00       	call   8010559a <sleep>
801051e5:	83 c4 10             	add    $0x10,%esp
  }
801051e8:	e9 c1 fd ff ff       	jmp    80104fae <wait+0x16>
}
801051ed:	c9                   	leave  
801051ee:	c3                   	ret    

801051ef <scheduler>:
}

#else
void
scheduler(void)
{
801051ef:	55                   	push   %ebp
801051f0:	89 e5                	mov    %esp,%ebp
801051f2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
801051f5:	e8 62 f4 ff ff       	call   8010465c <sti>

    idle = 1;  // assume idle unless we schedule a process
801051fa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    acquire(&ptable.lock);
80105201:	83 ec 0c             	sub    $0xc,%esp
80105204:	68 a0 49 11 80       	push   $0x801149a0
80105209:	e8 7b 14 00 00       	call   80106689 <acquire>
8010520e:	83 c4 10             	add    $0x10,%esp
    //for (int j = 0; j < 99999; j++){}
    if (ticks >= ptable.PromoteAtTime) {
80105211:	8b 15 08 71 11 80    	mov    0x80117108,%edx
80105217:	a1 20 79 11 80       	mov    0x80117920,%eax
8010521c:	39 c2                	cmp    %eax,%edx
8010521e:	77 14                	ja     80105234 <scheduler+0x45>
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
80105220:	a1 20 79 11 80       	mov    0x80117920,%eax
80105225:	05 f4 01 00 00       	add    $0x1f4,%eax
8010522a:	a3 08 71 11 80       	mov    %eax,0x80117108
      promote();
8010522f:	e8 b3 12 00 00       	call   801064e7 <promote>
    }

    for (int i = 0; i <= MAX; i++) {
80105234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010523b:	e9 fe 00 00 00       	jmp    8010533e <scheduler+0x14f>
      p = ptable.pLists.ready[i];
80105240:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105243:	05 cc 09 00 00       	add    $0x9cc,%eax
80105248:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
8010524f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if (p) {
80105252:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105256:	0f 84 de 00 00 00    	je     8010533a <scheduler+0x14b>
        idle = 0;  // not idle this timeslice
8010525c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        proc = p;
80105263:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105266:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4

        switchuvm(p);
8010526c:	83 ec 0c             	sub    $0xc,%esp
8010526f:	ff 75 ec             	pushl  -0x14(%ebp)
80105272:	e8 ca 45 00 00       	call   80109841 <switchuvm>
80105277:	83 c4 10             	add    $0x10,%esp
        if (removeFromStateList(&ptable.pLists.ready[p->priority], p, RUNNABLE) < 0)
8010527a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010527d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105283:	05 cc 09 00 00       	add    $0x9cc,%eax
80105288:	c1 e0 02             	shl    $0x2,%eax
8010528b:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105290:	83 c0 04             	add    $0x4,%eax
80105293:	83 ec 04             	sub    $0x4,%esp
80105296:	6a 03                	push   $0x3
80105298:	ff 75 ec             	pushl  -0x14(%ebp)
8010529b:	50                   	push   %eax
8010529c:	e8 ce 0e 00 00       	call   8010616f <removeFromStateList>
801052a1:	83 c4 10             	add    $0x10,%esp
801052a4:	85 c0                	test   %eax,%eax
801052a6:	79 0d                	jns    801052b5 <scheduler+0xc6>
          panic("Cannot remove the proc from the ready list - scheduler() routine");
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	68 70 a4 10 80       	push   $0x8010a470
801052b0:	e8 b1 b2 ff ff       	call   80100566 <panic>
        p->state = RUNNING;
801052b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052b8:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
        addProcToBegin(&ptable.pLists.running, p);
801052bf:	83 ec 08             	sub    $0x8,%esp
801052c2:	ff 75 ec             	pushl  -0x14(%ebp)
801052c5:	68 00 71 11 80       	push   $0x80117100
801052ca:	e8 e7 0f 00 00       	call   801062b6 <addProcToBegin>
801052cf:	83 c4 10             	add    $0x10,%esp
        p->cpu_ticks_in = ticks;
801052d2:	8b 15 20 79 11 80    	mov    0x80117920,%edx
801052d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052db:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
        swtch(&cpu->scheduler, proc->context);
801052e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052e7:	8b 40 1c             	mov    0x1c(%eax),%eax
801052ea:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052f1:	83 c2 04             	add    $0x4,%edx
801052f4:	83 ec 08             	sub    $0x8,%esp
801052f7:	50                   	push   %eax
801052f8:	52                   	push   %edx
801052f9:	e8 62 18 00 00       	call   80106b60 <swtch>
801052fe:	83 c4 10             	add    $0x10,%esp
        switchkvm();
80105301:	e8 1e 45 00 00       	call   80109824 <switchkvm>

        p->cpu_ticks_total += (ticks - p->cpu_ticks_in);
80105306:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105309:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
8010530f:	8b 0d 20 79 11 80    	mov    0x80117920,%ecx
80105315:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105318:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010531e:	29 c1                	sub    %eax,%ecx
80105320:	89 c8                	mov    %ecx,%eax
80105322:	01 c2                	add    %eax,%edx
80105324:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105327:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
        proc = 0;
8010532d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80105334:	00 00 00 00 
        break;
80105338:	eb 0e                	jmp    80105348 <scheduler+0x159>
    if (ticks >= ptable.PromoteAtTime) {
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
      promote();
    }

    for (int i = 0; i <= MAX; i++) {
8010533a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010533e:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
80105342:	0f 8e f8 fe ff ff    	jle    80105240 <scheduler+0x51>
      }
    }
      // Process is done running for now.
      // It should have changed its p->state before coming back.

    release(&ptable.lock);
80105348:	83 ec 0c             	sub    $0xc,%esp
8010534b:	68 a0 49 11 80       	push   $0x801149a0
80105350:	e8 9b 13 00 00       	call   801066f0 <release>
80105355:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
80105358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010535c:	0f 84 93 fe ff ff    	je     801051f5 <scheduler+0x6>
      sti();
80105362:	e8 f5 f2 ff ff       	call   8010465c <sti>
      hlt();
80105367:	e8 d9 f2 ff ff       	call   80104645 <hlt>
    }
  }
8010536c:	e9 84 fe ff ff       	jmp    801051f5 <scheduler+0x6>

80105371 <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
80105371:	55                   	push   %ebp
80105372:	89 e5                	mov    %esp,%ebp
80105374:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80105377:	83 ec 0c             	sub    $0xc,%esp
8010537a:	68 a0 49 11 80       	push   $0x801149a0
8010537f:	e8 38 14 00 00       	call   801067bc <holding>
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	85 c0                	test   %eax,%eax
80105389:	75 0d                	jne    80105398 <sched+0x27>
    panic("sched ptable.lock");
8010538b:	83 ec 0c             	sub    $0xc,%esp
8010538e:	68 b1 a4 10 80       	push   $0x8010a4b1
80105393:	e8 ce b1 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105398:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010539e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801053a4:	83 f8 01             	cmp    $0x1,%eax
801053a7:	74 0d                	je     801053b6 <sched+0x45>
    panic("sched locks");
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	68 c3 a4 10 80       	push   $0x8010a4c3
801053b1:	e8 b0 b1 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
801053b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053bc:	8b 40 0c             	mov    0xc(%eax),%eax
801053bf:	83 f8 04             	cmp    $0x4,%eax
801053c2:	75 0d                	jne    801053d1 <sched+0x60>
    panic("sched running");
801053c4:	83 ec 0c             	sub    $0xc,%esp
801053c7:	68 cf a4 10 80       	push   $0x8010a4cf
801053cc:	e8 95 b1 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
801053d1:	e8 76 f2 ff ff       	call   8010464c <readeflags>
801053d6:	25 00 02 00 00       	and    $0x200,%eax
801053db:	85 c0                	test   %eax,%eax
801053dd:	74 0d                	je     801053ec <sched+0x7b>
    panic("sched interruptible");
801053df:	83 ec 0c             	sub    $0xc,%esp
801053e2:	68 dd a4 10 80       	push   $0x8010a4dd
801053e7:	e8 7a b1 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
801053ec:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053f2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801053f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_in = ticks;
801053fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105401:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105407:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
  swtch(&proc->context, cpu->scheduler);
8010540d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105413:	8b 40 04             	mov    0x4(%eax),%eax
80105416:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010541d:	83 c2 1c             	add    $0x1c,%edx
80105420:	83 ec 08             	sub    $0x8,%esp
80105423:	50                   	push   %eax
80105424:	52                   	push   %edx
80105425:	e8 36 17 00 00       	call   80106b60 <swtch>
8010542a:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
8010542d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105433:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105436:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010543c:	90                   	nop
8010543d:	c9                   	leave  
8010543e:	c3                   	ret    

8010543f <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010543f:	55                   	push   %ebp
80105440:	89 e5                	mov    %esp,%ebp
80105442:	53                   	push   %ebx
80105443:	83 ec 04             	sub    $0x4,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105446:	83 ec 0c             	sub    $0xc,%esp
80105449:	68 a0 49 11 80       	push   $0x801149a0
8010544e:	e8 36 12 00 00       	call   80106689 <acquire>
80105453:	83 c4 10             	add    $0x10,%esp
  if (removeFromStateList(&ptable.pLists.running, proc, RUNNING) < 0)
80105456:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010545c:	83 ec 04             	sub    $0x4,%esp
8010545f:	6a 04                	push   $0x4
80105461:	50                   	push   %eax
80105462:	68 00 71 11 80       	push   $0x80117100
80105467:	e8 03 0d 00 00       	call   8010616f <removeFromStateList>
8010546c:	83 c4 10             	add    $0x10,%esp
8010546f:	85 c0                	test   %eax,%eax
80105471:	79 0d                	jns    80105480 <yield+0x41>
    panic("The proc is not in the running list - yield() routine");
80105473:	83 ec 0c             	sub    $0xc,%esp
80105476:	68 f4 a4 10 80       	push   $0x8010a4f4
8010547b:	e8 e6 b0 ff ff       	call   80100566 <panic>
  proc->state = RUNNABLE;
80105480:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105486:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
8010548d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105493:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010549a:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
801054a0:	89 d3                	mov    %edx,%ebx
801054a2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054a9:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
801054af:	8b 15 20 79 11 80    	mov    0x80117920,%edx
801054b5:	29 d1                	sub    %edx,%ecx
801054b7:	89 ca                	mov    %ecx,%edx
801054b9:	01 da                	add    %ebx,%edx
801054bb:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  if (proc->budget <= 0) {
801054c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c7:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801054cd:	85 c0                	test   %eax,%eax
801054cf:	7f 36                	jg     80105507 <yield+0xc8>
    if (proc->priority < MAX)
801054d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054d7:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801054dd:	83 f8 06             	cmp    $0x6,%eax
801054e0:	7f 15                	jg     801054f7 <yield+0xb8>
      proc->priority++;
801054e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e8:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
801054ee:	83 c2 01             	add    $0x1,%edx
801054f1:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    proc->budget = BUDGET;
801054f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054fd:	c7 80 98 00 00 00 c8 	movl   $0xc8,0x98(%eax)
80105504:	00 00 00 
  }
  addProcToLast(&ptable.pLists.ready[proc->priority], proc);
80105507:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010550d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105514:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
8010551a:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80105520:	c1 e2 02             	shl    $0x2,%edx
80105523:	81 c2 a0 49 11 80    	add    $0x801149a0,%edx
80105529:	83 c2 04             	add    $0x4,%edx
8010552c:	83 ec 08             	sub    $0x8,%esp
8010552f:	50                   	push   %eax
80105530:	52                   	push   %edx
80105531:	e8 01 0d 00 00       	call   80106237 <addProcToLast>
80105536:	83 c4 10             	add    $0x10,%esp
  sched();
80105539:	e8 33 fe ff ff       	call   80105371 <sched>
  release(&ptable.lock);
8010553e:	83 ec 0c             	sub    $0xc,%esp
80105541:	68 a0 49 11 80       	push   $0x801149a0
80105546:	e8 a5 11 00 00       	call   801066f0 <release>
8010554b:	83 c4 10             	add    $0x10,%esp
}
8010554e:	90                   	nop
8010554f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105552:	c9                   	leave  
80105553:	c3                   	ret    

80105554 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105554:	55                   	push   %ebp
80105555:	89 e5                	mov    %esp,%ebp
80105557:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010555a:	83 ec 0c             	sub    $0xc,%esp
8010555d:	68 a0 49 11 80       	push   $0x801149a0
80105562:	e8 89 11 00 00       	call   801066f0 <release>
80105567:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010556a:	a1 20 d0 10 80       	mov    0x8010d020,%eax
8010556f:	85 c0                	test   %eax,%eax
80105571:	74 24                	je     80105597 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105573:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
8010557a:	00 00 00 
    iinit(ROOTDEV);
8010557d:	83 ec 0c             	sub    $0xc,%esp
80105580:	6a 01                	push   $0x1
80105582:	e8 07 c2 ff ff       	call   8010178e <iinit>
80105587:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
8010558a:	83 ec 0c             	sub    $0xc,%esp
8010558d:	6a 01                	push   $0x1
8010558f:	e8 a2 df ff ff       	call   80103536 <initlog>
80105594:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105597:	90                   	nop
80105598:	c9                   	leave  
80105599:	c3                   	ret    

8010559a <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
8010559a:	55                   	push   %ebp
8010559b:	89 e5                	mov    %esp,%ebp
8010559d:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
801055a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a6:	85 c0                	test   %eax,%eax
801055a8:	75 0d                	jne    801055b7 <sleep+0x1d>
    panic("sleep");
801055aa:	83 ec 0c             	sub    $0xc,%esp
801055ad:	68 2a a5 10 80       	push   $0x8010a52a
801055b2:	e8 af af ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
801055b7:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
801055be:	74 24                	je     801055e4 <sleep+0x4a>
    acquire(&ptable.lock);
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	68 a0 49 11 80       	push   $0x801149a0
801055c8:	e8 bc 10 00 00       	call   80106689 <acquire>
801055cd:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
801055d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801055d4:	74 0e                	je     801055e4 <sleep+0x4a>
801055d6:	83 ec 0c             	sub    $0xc,%esp
801055d9:	ff 75 0c             	pushl  0xc(%ebp)
801055dc:	e8 0f 11 00 00       	call   801066f0 <release>
801055e1:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
801055e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055ea:	8b 55 08             	mov    0x8(%ebp),%edx
801055ed:	89 50 20             	mov    %edx,0x20(%eax)
  if (removeFromStateList(&ptable.pLists.running, proc, RUNNING) < 0)
801055f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055f6:	83 ec 04             	sub    $0x4,%esp
801055f9:	6a 04                	push   $0x4
801055fb:	50                   	push   %eax
801055fc:	68 00 71 11 80       	push   $0x80117100
80105601:	e8 69 0b 00 00       	call   8010616f <removeFromStateList>
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	85 c0                	test   %eax,%eax
8010560b:	79 0d                	jns    8010561a <sleep+0x80>
    panic("The proc is not in the running list - sleep() routine");
8010560d:	83 ec 0c             	sub    $0xc,%esp
80105610:	68 30 a5 10 80       	push   $0x8010a530
80105615:	e8 4c af ff ff       	call   80100566 <panic>
  proc->state = SLEEPING;
8010561a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105620:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  addProcToBegin(&ptable.pLists.sleep, proc);
80105627:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562d:	83 ec 08             	sub    $0x8,%esp
80105630:	50                   	push   %eax
80105631:	68 f8 70 11 80       	push   $0x801170f8
80105636:	e8 7b 0c 00 00       	call   801062b6 <addProcToBegin>
8010563b:	83 c4 10             	add    $0x10,%esp
  sched();
8010563e:	e8 2e fd ff ff       	call   80105371 <sched>

  // Tidy up.
  proc->chan = 0;
80105643:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105649:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80105650:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
80105657:	74 24                	je     8010567d <sleep+0xe3>
    release(&ptable.lock);
80105659:	83 ec 0c             	sub    $0xc,%esp
8010565c:	68 a0 49 11 80       	push   $0x801149a0
80105661:	e8 8a 10 00 00       	call   801066f0 <release>
80105666:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
80105669:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010566d:	74 0e                	je     8010567d <sleep+0xe3>
8010566f:	83 ec 0c             	sub    $0xc,%esp
80105672:	ff 75 0c             	pushl  0xc(%ebp)
80105675:	e8 0f 10 00 00       	call   80106689 <acquire>
8010567a:	83 c4 10             	add    $0x10,%esp
  }
}
8010567d:	90                   	nop
8010567e:	c9                   	leave  
8010567f:	c3                   	ret    

80105680 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = ptable.pLists.sleep;
80105686:	a1 f8 70 11 80       	mov    0x801170f8,%eax
8010568b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while (p) {
8010568e:	eb 6f                	jmp    801056ff <wakeup1+0x7f>
    if (p->chan == chan) {
80105690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105693:	8b 40 20             	mov    0x20(%eax),%eax
80105696:	3b 45 08             	cmp    0x8(%ebp),%eax
80105699:	75 58                	jne    801056f3 <wakeup1+0x73>
      if (removeFromStateList(&ptable.pLists.sleep, p, SLEEPING) < 0)
8010569b:	83 ec 04             	sub    $0x4,%esp
8010569e:	6a 02                	push   $0x2
801056a0:	ff 75 f4             	pushl  -0xc(%ebp)
801056a3:	68 f8 70 11 80       	push   $0x801170f8
801056a8:	e8 c2 0a 00 00       	call   8010616f <removeFromStateList>
801056ad:	83 c4 10             	add    $0x10,%esp
801056b0:	85 c0                	test   %eax,%eax
801056b2:	79 0d                	jns    801056c1 <wakeup1+0x41>
        panic("Cannot remove the proc from the sleep list - wakeup1() routine");
801056b4:	83 ec 0c             	sub    $0xc,%esp
801056b7:	68 68 a5 10 80       	push   $0x8010a568
801056bc:	e8 a5 ae ff ff       	call   80100566 <panic>
      p->state = RUNNABLE;
801056c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      addProcToLast(&ptable.pLists.ready[p->priority], p);
801056cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ce:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801056d4:	05 cc 09 00 00       	add    $0x9cc,%eax
801056d9:	c1 e0 02             	shl    $0x2,%eax
801056dc:	05 a0 49 11 80       	add    $0x801149a0,%eax
801056e1:	83 c0 04             	add    $0x4,%eax
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	ff 75 f4             	pushl  -0xc(%ebp)
801056ea:	50                   	push   %eax
801056eb:	e8 47 0b 00 00       	call   80106237 <addProcToLast>
801056f0:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
801056f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801056fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
static void
wakeup1(void *chan)
{
  struct proc *p = ptable.pLists.sleep;

  while (p) {
801056ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105703:	75 8b                	jne    80105690 <wakeup1+0x10>
      p->state = RUNNABLE;
      addProcToLast(&ptable.pLists.ready[p->priority], p);
    }
    p = p->next;
  }
}
80105705:	90                   	nop
80105706:	c9                   	leave  
80105707:	c3                   	ret    

80105708 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105708:	55                   	push   %ebp
80105709:	89 e5                	mov    %esp,%ebp
8010570b:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010570e:	83 ec 0c             	sub    $0xc,%esp
80105711:	68 a0 49 11 80       	push   $0x801149a0
80105716:	e8 6e 0f 00 00       	call   80106689 <acquire>
8010571b:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010571e:	83 ec 0c             	sub    $0xc,%esp
80105721:	ff 75 08             	pushl  0x8(%ebp)
80105724:	e8 57 ff ff ff       	call   80105680 <wakeup1>
80105729:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010572c:	83 ec 0c             	sub    $0xc,%esp
8010572f:	68 a0 49 11 80       	push   $0x801149a0
80105734:	e8 b7 0f 00 00       	call   801066f0 <release>
80105739:	83 c4 10             	add    $0x10,%esp
}
8010573c:	90                   	nop
8010573d:	c9                   	leave  
8010573e:	c3                   	ret    

8010573f <kill>:
  return -1;
}
#else
int
kill(int pid)
{
8010573f:	55                   	push   %ebp
80105740:	89 e5                	mov    %esp,%ebp
80105742:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80105745:	83 ec 0c             	sub    $0xc,%esp
80105748:	68 a0 49 11 80       	push   $0x801149a0
8010574d:	e8 37 0f 00 00       	call   80106689 <acquire>
80105752:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.pLists.sleep; p; p = p->next){
80105755:	a1 f8 70 11 80       	mov    0x801170f8,%eax
8010575a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010575d:	e9 95 00 00 00       	jmp    801057f7 <kill+0xb8>
    if(p->pid == pid){
80105762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105765:	8b 50 10             	mov    0x10(%eax),%edx
80105768:	8b 45 08             	mov    0x8(%ebp),%eax
8010576b:	39 c2                	cmp    %eax,%edx
8010576d:	75 7c                	jne    801057eb <kill+0xac>
      p->killed = 1;
8010576f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105772:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (removeFromStateList(&ptable.pLists.sleep, p, SLEEPING) < 0)
80105779:	83 ec 04             	sub    $0x4,%esp
8010577c:	6a 02                	push   $0x2
8010577e:	ff 75 f4             	pushl  -0xc(%ebp)
80105781:	68 f8 70 11 80       	push   $0x801170f8
80105786:	e8 e4 09 00 00       	call   8010616f <removeFromStateList>
8010578b:	83 c4 10             	add    $0x10,%esp
8010578e:	85 c0                	test   %eax,%eax
80105790:	79 0d                	jns    8010579f <kill+0x60>
        panic("Cannot remove the proc from the sleep list - kill() routine");
80105792:	83 ec 0c             	sub    $0xc,%esp
80105795:	68 a8 a5 10 80       	push   $0x8010a5a8
8010579a:	e8 c7 ad ff ff       	call   80100566 <panic>
      p->state = RUNNABLE;
8010579f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      addProcToLast(&ptable.pLists.ready[p->priority], p);
801057a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ac:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801057b2:	05 cc 09 00 00       	add    $0x9cc,%eax
801057b7:	c1 e0 02             	shl    $0x2,%eax
801057ba:	05 a0 49 11 80       	add    $0x801149a0,%eax
801057bf:	83 c0 04             	add    $0x4,%eax
801057c2:	83 ec 08             	sub    $0x8,%esp
801057c5:	ff 75 f4             	pushl  -0xc(%ebp)
801057c8:	50                   	push   %eax
801057c9:	e8 69 0a 00 00       	call   80106237 <addProcToLast>
801057ce:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
801057d1:	83 ec 0c             	sub    $0xc,%esp
801057d4:	68 a0 49 11 80       	push   $0x801149a0
801057d9:	e8 12 0f 00 00       	call   801066f0 <release>
801057de:	83 c4 10             	add    $0x10,%esp
      return 0;
801057e1:	b8 00 00 00 00       	mov    $0x0,%eax
801057e6:	e9 76 01 00 00       	jmp    80105961 <kill+0x222>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.pLists.sleep; p; p = p->next){
801057eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ee:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801057f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057fb:	0f 85 61 ff ff ff    	jne    80105762 <kill+0x23>
      addProcToLast(&ptable.pLists.ready[p->priority], p);
      release(&ptable.lock);
      return 0;
    }
  }
  for(p = ptable.pLists.running; p; p = p->next) {
80105801:	a1 00 71 11 80       	mov    0x80117100,%eax
80105806:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105809:	eb 3d                	jmp    80105848 <kill+0x109>
    if(p->pid == pid) {
8010580b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580e:	8b 50 10             	mov    0x10(%eax),%edx
80105811:	8b 45 08             	mov    0x8(%ebp),%eax
80105814:	39 c2                	cmp    %eax,%edx
80105816:	75 24                	jne    8010583c <kill+0xfd>
      p->killed = 1;
80105818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010581b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
80105822:	83 ec 0c             	sub    $0xc,%esp
80105825:	68 a0 49 11 80       	push   $0x801149a0
8010582a:	e8 c1 0e 00 00       	call   801066f0 <release>
8010582f:	83 c4 10             	add    $0x10,%esp
      return 0;
80105832:	b8 00 00 00 00       	mov    $0x0,%eax
80105837:	e9 25 01 00 00       	jmp    80105961 <kill+0x222>
      addProcToLast(&ptable.pLists.ready[p->priority], p);
      release(&ptable.lock);
      return 0;
    }
  }
  for(p = ptable.pLists.running; p; p = p->next) {
8010583c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010583f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105845:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105848:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010584c:	75 bd                	jne    8010580b <kill+0xcc>
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
  }
  for(int i = 0; i <= MAX; i++) {
8010584e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105855:	eb 5b                	jmp    801058b2 <kill+0x173>
    for(p = ptable.pLists.ready[i]; p; p = p->next) {
80105857:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010585a:	05 cc 09 00 00       	add    $0x9cc,%eax
8010585f:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
80105866:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105869:	eb 3d                	jmp    801058a8 <kill+0x169>
      if(p->pid == pid) {
8010586b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586e:	8b 50 10             	mov    0x10(%eax),%edx
80105871:	8b 45 08             	mov    0x8(%ebp),%eax
80105874:	39 c2                	cmp    %eax,%edx
80105876:	75 24                	jne    8010589c <kill+0x15d>
        p->killed = 1;
80105878:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010587b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        release(&ptable.lock);
80105882:	83 ec 0c             	sub    $0xc,%esp
80105885:	68 a0 49 11 80       	push   $0x801149a0
8010588a:	e8 61 0e 00 00       	call   801066f0 <release>
8010588f:	83 c4 10             	add    $0x10,%esp
        return 0;
80105892:	b8 00 00 00 00       	mov    $0x0,%eax
80105897:	e9 c5 00 00 00       	jmp    80105961 <kill+0x222>
      release(&ptable.lock);
      return 0;
    }
  }
  for(int i = 0; i <= MAX; i++) {
    for(p = ptable.pLists.ready[i]; p; p = p->next) {
8010589c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058ac:	75 bd                	jne    8010586b <kill+0x12c>
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
  }
  for(int i = 0; i <= MAX; i++) {
801058ae:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801058b2:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
801058b6:	7e 9f                	jle    80105857 <kill+0x118>
        release(&ptable.lock);
        return 0;
      }
    }
  }
  for(p = ptable.pLists.embryo; p; p = p->next) {
801058b8:	a1 04 71 11 80       	mov    0x80117104,%eax
801058bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058c0:	eb 3a                	jmp    801058fc <kill+0x1bd>
    if(p->pid == pid) {
801058c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c5:	8b 50 10             	mov    0x10(%eax),%edx
801058c8:	8b 45 08             	mov    0x8(%ebp),%eax
801058cb:	39 c2                	cmp    %eax,%edx
801058cd:	75 21                	jne    801058f0 <kill+0x1b1>
      p->killed = 1;
801058cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
801058d9:	83 ec 0c             	sub    $0xc,%esp
801058dc:	68 a0 49 11 80       	push   $0x801149a0
801058e1:	e8 0a 0e 00 00       	call   801066f0 <release>
801058e6:	83 c4 10             	add    $0x10,%esp
      return 0;
801058e9:	b8 00 00 00 00       	mov    $0x0,%eax
801058ee:	eb 71                	jmp    80105961 <kill+0x222>
        release(&ptable.lock);
        return 0;
      }
    }
  }
  for(p = ptable.pLists.embryo; p; p = p->next) {
801058f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105900:	75 c0                	jne    801058c2 <kill+0x183>
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
  }
  for(p = ptable.pLists.zombie; p; p = p->next) {
80105902:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80105907:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010590a:	eb 3a                	jmp    80105946 <kill+0x207>
    if(p->pid == pid) {
8010590c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010590f:	8b 50 10             	mov    0x10(%eax),%edx
80105912:	8b 45 08             	mov    0x8(%ebp),%eax
80105915:	39 c2                	cmp    %eax,%edx
80105917:	75 21                	jne    8010593a <kill+0x1fb>
      p->killed = 1;
80105919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
80105923:	83 ec 0c             	sub    $0xc,%esp
80105926:	68 a0 49 11 80       	push   $0x801149a0
8010592b:	e8 c0 0d 00 00       	call   801066f0 <release>
80105930:	83 c4 10             	add    $0x10,%esp
      return 0;
80105933:	b8 00 00 00 00       	mov    $0x0,%eax
80105938:	eb 27                	jmp    80105961 <kill+0x222>
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
  }
  for(p = ptable.pLists.zombie; p; p = p->next) {
8010593a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105943:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010594a:	75 c0                	jne    8010590c <kill+0x1cd>
      release(&ptable.lock);
      return 0;
    }
  }

  release(&ptable.lock);
8010594c:	83 ec 0c             	sub    $0xc,%esp
8010594f:	68 a0 49 11 80       	push   $0x801149a0
80105954:	e8 97 0d 00 00       	call   801066f0 <release>
80105959:	83 c4 10             	add    $0x10,%esp
  return -1;
8010595c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105961:	c9                   	leave  
80105962:	c3                   	ret    

80105963 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105963:	55                   	push   %ebp
80105964:	89 e5                	mov    %esp,%ebp
80105966:	56                   	push   %esi
80105967:	53                   	push   %ebx
80105968:	83 ec 50             	sub    $0x50,%esp
  uint pc[10];
  uint seconds, partial_seconds;
  uint cpu_seconds, cpu_partial_seconds;
  uint ppid;

  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\tPCs\n");
8010596b:	83 ec 0c             	sub    $0xc,%esp
8010596e:	68 10 a6 10 80       	push   $0x8010a610
80105973:	e8 4e aa ff ff       	call   801003c6 <cprintf>
80105978:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010597b:	c7 45 f0 d4 49 11 80 	movl   $0x801149d4,-0x10(%ebp)
80105982:	e9 03 02 00 00       	jmp    80105b8a <procdump+0x227>
    if(p->state == UNUSED)
80105987:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010598a:	8b 40 0c             	mov    0xc(%eax),%eax
8010598d:	85 c0                	test   %eax,%eax
8010598f:	0f 84 ed 01 00 00    	je     80105b82 <procdump+0x21f>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105995:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105998:	8b 40 0c             	mov    0xc(%eax),%eax
8010599b:	83 f8 05             	cmp    $0x5,%eax
8010599e:	77 23                	ja     801059c3 <procdump+0x60>
801059a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059a3:	8b 40 0c             	mov    0xc(%eax),%eax
801059a6:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801059ad:	85 c0                	test   %eax,%eax
801059af:	74 12                	je     801059c3 <procdump+0x60>
      state = states[p->state];
801059b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b4:	8b 40 0c             	mov    0xc(%eax),%eax
801059b7:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801059be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801059c1:	eb 07                	jmp    801059ca <procdump+0x67>
    else
      state = "???";
801059c3:	c7 45 ec 48 a6 10 80 	movl   $0x8010a648,-0x14(%ebp)
    seconds = (ticks - p->start_ticks)/100;
801059ca:	8b 15 20 79 11 80    	mov    0x80117920,%edx
801059d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d3:	8b 40 7c             	mov    0x7c(%eax),%eax
801059d6:	29 c2                	sub    %eax,%edx
801059d8:	89 d0                	mov    %edx,%eax
801059da:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801059df:	f7 e2                	mul    %edx
801059e1:	89 d0                	mov    %edx,%eax
801059e3:	c1 e8 05             	shr    $0x5,%eax
801059e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    partial_seconds = (ticks - p->start_ticks)%100;
801059e9:	8b 15 20 79 11 80    	mov    0x80117920,%edx
801059ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f2:	8b 40 7c             	mov    0x7c(%eax),%eax
801059f5:	89 d1                	mov    %edx,%ecx
801059f7:	29 c1                	sub    %eax,%ecx
801059f9:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801059fe:	89 c8                	mov    %ecx,%eax
80105a00:	f7 e2                	mul    %edx
80105a02:	89 d0                	mov    %edx,%eax
80105a04:	c1 e8 05             	shr    $0x5,%eax
80105a07:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a0d:	6b c0 64             	imul   $0x64,%eax,%eax
80105a10:	29 c1                	sub    %eax,%ecx
80105a12:	89 c8                	mov    %ecx,%eax
80105a14:	89 45 e0             	mov    %eax,-0x20(%ebp)
    cpu_seconds = p->cpu_ticks_total/100;
80105a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1a:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105a20:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105a25:	f7 e2                	mul    %edx
80105a27:	89 d0                	mov    %edx,%eax
80105a29:	c1 e8 05             	shr    $0x5,%eax
80105a2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    cpu_partial_seconds = p->cpu_ticks_total%100;
80105a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a32:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80105a38:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105a3d:	89 c8                	mov    %ecx,%eax
80105a3f:	f7 e2                	mul    %edx
80105a41:	89 d0                	mov    %edx,%eax
80105a43:	c1 e8 05             	shr    $0x5,%eax
80105a46:	89 45 d8             	mov    %eax,-0x28(%ebp)
80105a49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a4c:	6b c0 64             	imul   $0x64,%eax,%eax
80105a4f:	29 c1                	sub    %eax,%ecx
80105a51:	89 c8                	mov    %ecx,%eax
80105a53:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if(!p->parent)
80105a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a59:	8b 40 14             	mov    0x14(%eax),%eax
80105a5c:	85 c0                	test   %eax,%eax
80105a5e:	75 0b                	jne    80105a6b <procdump+0x108>
      ppid = p->pid;
80105a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a63:	8b 40 10             	mov    0x10(%eax),%eax
80105a66:	89 45 e8             	mov    %eax,-0x18(%ebp)
80105a69:	eb 0c                	jmp    80105a77 <procdump+0x114>
    else
      ppid = p->parent->pid;
80105a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6e:	8b 40 14             	mov    0x14(%eax),%eax
80105a71:	8b 40 10             	mov    0x10(%eax),%eax
80105a74:	89 45 e8             	mov    %eax,-0x18(%ebp)
    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.", p->pid, p->name, p->uid, p->gid, ppid, p->priority, seconds);
80105a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a7a:	8b 98 94 00 00 00    	mov    0x94(%eax),%ebx
80105a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a83:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a8c:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a95:	8d 70 6c             	lea    0x6c(%eax),%esi
80105a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a9b:	8b 40 10             	mov    0x10(%eax),%eax
80105a9e:	ff 75 e4             	pushl  -0x1c(%ebp)
80105aa1:	53                   	push   %ebx
80105aa2:	ff 75 e8             	pushl  -0x18(%ebp)
80105aa5:	51                   	push   %ecx
80105aa6:	52                   	push   %edx
80105aa7:	56                   	push   %esi
80105aa8:	50                   	push   %eax
80105aa9:	68 4c a6 10 80       	push   $0x8010a64c
80105aae:	e8 13 a9 ff ff       	call   801003c6 <cprintf>
80105ab3:	83 c4 20             	add    $0x20,%esp
    if(partial_seconds < 10)
80105ab6:	83 7d e0 09          	cmpl   $0x9,-0x20(%ebp)
80105aba:	77 10                	ja     80105acc <procdump+0x169>
      cprintf("0");
80105abc:	83 ec 0c             	sub    $0xc,%esp
80105abf:	68 62 a6 10 80       	push   $0x8010a662
80105ac4:	e8 fd a8 ff ff       	call   801003c6 <cprintf>
80105ac9:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t%d.", partial_seconds, cpu_seconds);
80105acc:	83 ec 04             	sub    $0x4,%esp
80105acf:	ff 75 dc             	pushl  -0x24(%ebp)
80105ad2:	ff 75 e0             	pushl  -0x20(%ebp)
80105ad5:	68 64 a6 10 80       	push   $0x8010a664
80105ada:	e8 e7 a8 ff ff       	call   801003c6 <cprintf>
80105adf:	83 c4 10             	add    $0x10,%esp
    if(cpu_partial_seconds < 10)
80105ae2:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
80105ae6:	77 10                	ja     80105af8 <procdump+0x195>
      cprintf("0");
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	68 62 a6 10 80       	push   $0x8010a662
80105af0:	e8 d1 a8 ff ff       	call   801003c6 <cprintf>
80105af5:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t%s\t%d\t", cpu_partial_seconds, state, p->sz);
80105af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afb:	8b 00                	mov    (%eax),%eax
80105afd:	50                   	push   %eax
80105afe:	ff 75 ec             	pushl  -0x14(%ebp)
80105b01:	ff 75 d8             	pushl  -0x28(%ebp)
80105b04:	68 6b a6 10 80       	push   $0x8010a66b
80105b09:	e8 b8 a8 ff ff       	call   801003c6 <cprintf>
80105b0e:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING) {
80105b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b14:	8b 40 0c             	mov    0xc(%eax),%eax
80105b17:	83 f8 02             	cmp    $0x2,%eax
80105b1a:	75 54                	jne    80105b70 <procdump+0x20d>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1f:	8b 40 1c             	mov    0x1c(%eax),%eax
80105b22:	8b 40 0c             	mov    0xc(%eax),%eax
80105b25:	83 c0 08             	add    $0x8,%eax
80105b28:	89 c2                	mov    %eax,%edx
80105b2a:	83 ec 08             	sub    $0x8,%esp
80105b2d:	8d 45 b0             	lea    -0x50(%ebp),%eax
80105b30:	50                   	push   %eax
80105b31:	52                   	push   %edx
80105b32:	e8 0b 0c 00 00       	call   80106742 <getcallerpcs>
80105b37:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 10 && pc[i] != 0; i++)
80105b3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105b41:	eb 1c                	jmp    80105b5f <procdump+0x1fc>
        cprintf("%p", pc[i]);
80105b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b46:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
80105b4a:	83 ec 08             	sub    $0x8,%esp
80105b4d:	50                   	push   %eax
80105b4e:	68 75 a6 10 80       	push   $0x8010a675
80105b53:	e8 6e a8 ff ff       	call   801003c6 <cprintf>
80105b58:	83 c4 10             	add    $0x10,%esp
    if(cpu_partial_seconds < 10)
      cprintf("0");
    cprintf("%d\t%s\t%d\t", cpu_partial_seconds, state, p->sz);
    if(p->state == SLEEPING) {
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i = 0; i < 10 && pc[i] != 0; i++)
80105b5b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105b5f:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105b63:	7f 0b                	jg     80105b70 <procdump+0x20d>
80105b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b68:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
80105b6c:	85 c0                	test   %eax,%eax
80105b6e:	75 d3                	jne    80105b43 <procdump+0x1e0>
        cprintf("%p", pc[i]);
    }
    cprintf("\n");
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	68 78 a6 10 80       	push   $0x8010a678
80105b78:	e8 49 a8 ff ff       	call   801003c6 <cprintf>
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	eb 01                	jmp    80105b83 <procdump+0x220>
  uint ppid;

  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\tPCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->state == UNUSED)
      continue;
80105b82:	90                   	nop
  uint seconds, partial_seconds;
  uint cpu_seconds, cpu_partial_seconds;
  uint ppid;

  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\tPCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105b83:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105b8a:	81 7d f0 d4 70 11 80 	cmpl   $0x801170d4,-0x10(%ebp)
80105b91:	0f 82 f0 fd ff ff    	jb     80105987 <procdump+0x24>
      for(i = 0; i < 10 && pc[i] != 0; i++)
        cprintf("%p", pc[i]);
    }
    cprintf("\n");
  }
}
80105b97:	90                   	nop
80105b98:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b9b:	5b                   	pop    %ebx
80105b9c:	5e                   	pop    %esi
80105b9d:	5d                   	pop    %ebp
80105b9e:	c3                   	ret    

80105b9f <getprocs>:

int
getprocs(uint max, struct uproc* table)
{
80105b9f:	55                   	push   %ebp
80105ba0:	89 e5                	mov    %esp,%ebp
80105ba2:	83 ec 18             	sub    $0x18,%esp
    int i;
    struct proc* p;
    acquire(&ptable.lock);
80105ba5:	83 ec 0c             	sub    $0xc,%esp
80105ba8:	68 a0 49 11 80       	push   $0x801149a0
80105bad:	e8 d7 0a 00 00       	call   80106689 <acquire>
80105bb2:	83 c4 10             	add    $0x10,%esp
    for(i = 0, p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105bb5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105bbc:	c7 45 f0 d4 49 11 80 	movl   $0x801149d4,-0x10(%ebp)
80105bc3:	e9 2b 02 00 00       	jmp    80105df3 <getprocs+0x254>
        if (p->state != UNUSED) {
80105bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bcb:	8b 40 0c             	mov    0xc(%eax),%eax
80105bce:	85 c0                	test   %eax,%eax
80105bd0:	0f 84 16 02 00 00    	je     80105dec <getprocs+0x24d>
            table[i].pid = p->pid;
80105bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bd9:	89 d0                	mov    %edx,%eax
80105bdb:	01 c0                	add    %eax,%eax
80105bdd:	01 d0                	add    %edx,%eax
80105bdf:	c1 e0 05             	shl    $0x5,%eax
80105be2:	89 c2                	mov    %eax,%edx
80105be4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105be7:	01 c2                	add    %eax,%edx
80105be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bec:	8b 40 10             	mov    0x10(%eax),%eax
80105bef:	89 02                	mov    %eax,(%edx)
            table[i].uid = p->uid;
80105bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bf4:	89 d0                	mov    %edx,%eax
80105bf6:	01 c0                	add    %eax,%eax
80105bf8:	01 d0                	add    %edx,%eax
80105bfa:	c1 e0 05             	shl    $0x5,%eax
80105bfd:	89 c2                	mov    %eax,%edx
80105bff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c02:	01 c2                	add    %eax,%edx
80105c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c07:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105c0d:	89 42 04             	mov    %eax,0x4(%edx)
            table[i].gid = p->gid;
80105c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c13:	89 d0                	mov    %edx,%eax
80105c15:	01 c0                	add    %eax,%eax
80105c17:	01 d0                	add    %edx,%eax
80105c19:	c1 e0 05             	shl    $0x5,%eax
80105c1c:	89 c2                	mov    %eax,%edx
80105c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c21:	01 c2                	add    %eax,%edx
80105c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c26:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105c2c:	89 42 08             	mov    %eax,0x8(%edx)
            if (!p->parent)
80105c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c32:	8b 40 14             	mov    0x14(%eax),%eax
80105c35:	85 c0                	test   %eax,%eax
80105c37:	75 1e                	jne    80105c57 <getprocs+0xb8>
                table[i].ppid = p->pid;
80105c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c3c:	89 d0                	mov    %edx,%eax
80105c3e:	01 c0                	add    %eax,%eax
80105c40:	01 d0                	add    %edx,%eax
80105c42:	c1 e0 05             	shl    $0x5,%eax
80105c45:	89 c2                	mov    %eax,%edx
80105c47:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c4a:	01 c2                	add    %eax,%edx
80105c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c4f:	8b 40 10             	mov    0x10(%eax),%eax
80105c52:	89 42 0c             	mov    %eax,0xc(%edx)
80105c55:	eb 1f                	jmp    80105c76 <getprocs+0xd7>
            else table[i].ppid = p->parent->pid;
80105c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c5a:	89 d0                	mov    %edx,%eax
80105c5c:	01 c0                	add    %eax,%eax
80105c5e:	01 d0                	add    %edx,%eax
80105c60:	c1 e0 05             	shl    $0x5,%eax
80105c63:	89 c2                	mov    %eax,%edx
80105c65:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c68:	01 c2                	add    %eax,%edx
80105c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c6d:	8b 40 14             	mov    0x14(%eax),%eax
80105c70:	8b 40 10             	mov    0x10(%eax),%eax
80105c73:	89 42 0c             	mov    %eax,0xc(%edx)
            table[i].priority = p->priority;
80105c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c79:	89 d0                	mov    %edx,%eax
80105c7b:	01 c0                	add    %eax,%eax
80105c7d:	01 d0                	add    %edx,%eax
80105c7f:	c1 e0 05             	shl    $0x5,%eax
80105c82:	89 c2                	mov    %eax,%edx
80105c84:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c87:	01 c2                	add    %eax,%edx
80105c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c92:	89 42 5c             	mov    %eax,0x5c(%edx)
            table[i].elapsed_ticks = ticks - p->start_ticks;
80105c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c98:	89 d0                	mov    %edx,%eax
80105c9a:	01 c0                	add    %eax,%eax
80105c9c:	01 d0                	add    %edx,%eax
80105c9e:	c1 e0 05             	shl    $0x5,%eax
80105ca1:	89 c2                	mov    %eax,%edx
80105ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ca6:	01 c2                	add    %eax,%edx
80105ca8:	8b 0d 20 79 11 80    	mov    0x80117920,%ecx
80105cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb1:	8b 40 7c             	mov    0x7c(%eax),%eax
80105cb4:	29 c1                	sub    %eax,%ecx
80105cb6:	89 c8                	mov    %ecx,%eax
80105cb8:	89 42 10             	mov    %eax,0x10(%edx)
            table[i].CPU_total_ticks = p->cpu_ticks_total;
80105cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cbe:	89 d0                	mov    %edx,%eax
80105cc0:	01 c0                	add    %eax,%eax
80105cc2:	01 d0                	add    %edx,%eax
80105cc4:	c1 e0 05             	shl    $0x5,%eax
80105cc7:	89 c2                	mov    %eax,%edx
80105cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ccc:	01 c2                	add    %eax,%edx
80105cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd1:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105cd7:	89 42 14             	mov    %eax,0x14(%edx)
            table[i].size = p->sz;
80105cda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cdd:	89 d0                	mov    %edx,%eax
80105cdf:	01 c0                	add    %eax,%eax
80105ce1:	01 d0                	add    %edx,%eax
80105ce3:	c1 e0 05             	shl    $0x5,%eax
80105ce6:	89 c2                	mov    %eax,%edx
80105ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ceb:	01 c2                	add    %eax,%edx
80105ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf0:	8b 00                	mov    (%eax),%eax
80105cf2:	89 42 38             	mov    %eax,0x38(%edx)
            safestrcpy(table[i].name, p->name, sizeof(p->name));
80105cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf8:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105cfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cfe:	89 d0                	mov    %edx,%eax
80105d00:	01 c0                	add    %eax,%eax
80105d02:	01 d0                	add    %edx,%eax
80105d04:	c1 e0 05             	shl    $0x5,%eax
80105d07:	89 c2                	mov    %eax,%edx
80105d09:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d0c:	01 d0                	add    %edx,%eax
80105d0e:	83 c0 3c             	add    $0x3c,%eax
80105d11:	83 ec 04             	sub    $0x4,%esp
80105d14:	6a 10                	push   $0x10
80105d16:	51                   	push   %ecx
80105d17:	50                   	push   %eax
80105d18:	e8 d2 0d 00 00       	call   80106aef <safestrcpy>
80105d1d:	83 c4 10             	add    $0x10,%esp
            switch (p->state) {
80105d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d23:	8b 40 0c             	mov    0xc(%eax),%eax
80105d26:	83 f8 05             	cmp    $0x5,%eax
80105d29:	0f 87 b9 00 00 00    	ja     80105de8 <getprocs+0x249>
80105d2f:	8b 04 85 80 a6 10 80 	mov    -0x7fef5980(,%eax,4),%eax
80105d36:	ff e0                	jmp    *%eax
                case UNUSED:
                    break;
                case EMBRYO:
                    break;
                case SLEEPING:
                    safestrcpy(table[i].state, "sleep", STRMAX);
80105d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d3b:	89 d0                	mov    %edx,%eax
80105d3d:	01 c0                	add    %eax,%eax
80105d3f:	01 d0                	add    %edx,%eax
80105d41:	c1 e0 05             	shl    $0x5,%eax
80105d44:	89 c2                	mov    %eax,%edx
80105d46:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d49:	01 d0                	add    %edx,%eax
80105d4b:	83 c0 18             	add    $0x18,%eax
80105d4e:	83 ec 04             	sub    $0x4,%esp
80105d51:	6a 20                	push   $0x20
80105d53:	68 2a a5 10 80       	push   $0x8010a52a
80105d58:	50                   	push   %eax
80105d59:	e8 91 0d 00 00       	call   80106aef <safestrcpy>
80105d5e:	83 c4 10             	add    $0x10,%esp
                    break;
80105d61:	e9 82 00 00 00       	jmp    80105de8 <getprocs+0x249>
                case RUNNABLE:
                    safestrcpy(table[i].state, "runble", STRMAX);
80105d66:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d69:	89 d0                	mov    %edx,%eax
80105d6b:	01 c0                	add    %eax,%eax
80105d6d:	01 d0                	add    %edx,%eax
80105d6f:	c1 e0 05             	shl    $0x5,%eax
80105d72:	89 c2                	mov    %eax,%edx
80105d74:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d77:	01 d0                	add    %edx,%eax
80105d79:	83 c0 18             	add    $0x18,%eax
80105d7c:	83 ec 04             	sub    $0x4,%esp
80105d7f:	6a 20                	push   $0x20
80105d81:	68 f9 a5 10 80       	push   $0x8010a5f9
80105d86:	50                   	push   %eax
80105d87:	e8 63 0d 00 00       	call   80106aef <safestrcpy>
80105d8c:	83 c4 10             	add    $0x10,%esp
                    break;
80105d8f:	eb 57                	jmp    80105de8 <getprocs+0x249>
                case RUNNING:
                    safestrcpy(table[i].state, "run", STRMAX);
80105d91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d94:	89 d0                	mov    %edx,%eax
80105d96:	01 c0                	add    %eax,%eax
80105d98:	01 d0                	add    %edx,%eax
80105d9a:	c1 e0 05             	shl    $0x5,%eax
80105d9d:	89 c2                	mov    %eax,%edx
80105d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105da2:	01 d0                	add    %edx,%eax
80105da4:	83 c0 18             	add    $0x18,%eax
80105da7:	83 ec 04             	sub    $0x4,%esp
80105daa:	6a 20                	push   $0x20
80105dac:	68 7a a6 10 80       	push   $0x8010a67a
80105db1:	50                   	push   %eax
80105db2:	e8 38 0d 00 00       	call   80106aef <safestrcpy>
80105db7:	83 c4 10             	add    $0x10,%esp
                    break;
80105dba:	eb 2c                	jmp    80105de8 <getprocs+0x249>
                case ZOMBIE:
                    safestrcpy(table[i].state, "zombie", STRMAX);
80105dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dbf:	89 d0                	mov    %edx,%eax
80105dc1:	01 c0                	add    %eax,%eax
80105dc3:	01 d0                	add    %edx,%eax
80105dc5:	c1 e0 05             	shl    $0x5,%eax
80105dc8:	89 c2                	mov    %eax,%edx
80105dca:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dcd:	01 d0                	add    %edx,%eax
80105dcf:	83 c0 18             	add    $0x18,%eax
80105dd2:	83 ec 04             	sub    $0x4,%esp
80105dd5:	6a 20                	push   $0x20
80105dd7:	68 07 a6 10 80       	push   $0x8010a607
80105ddc:	50                   	push   %eax
80105ddd:	e8 0d 0d 00 00       	call   80106aef <safestrcpy>
80105de2:	83 c4 10             	add    $0x10,%esp
                    break;
80105de5:	eb 01                	jmp    80105de8 <getprocs+0x249>
            table[i].CPU_total_ticks = p->cpu_ticks_total;
            table[i].size = p->sz;
            safestrcpy(table[i].name, p->name, sizeof(p->name));
            switch (p->state) {
                case UNUSED:
                    break;
80105de7:	90                   	nop
                    break;
                case ZOMBIE:
                    safestrcpy(table[i].state, "zombie", STRMAX);
                    break;
            }
            i++;
80105de8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(uint max, struct uproc* table)
{
    int i;
    struct proc* p;
    acquire(&ptable.lock);
    for(i = 0, p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105dec:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105df3:	81 7d f0 d4 70 11 80 	cmpl   $0x801170d4,-0x10(%ebp)
80105dfa:	73 0c                	jae    80105e08 <getprocs+0x269>
80105dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dff:	3b 45 08             	cmp    0x8(%ebp),%eax
80105e02:	0f 82 c0 fd ff ff    	jb     80105bc8 <getprocs+0x29>
                    break;
            }
            i++;
        }
    }
    release(&ptable.lock);
80105e08:	83 ec 0c             	sub    $0xc,%esp
80105e0b:	68 a0 49 11 80       	push   $0x801149a0
80105e10:	e8 db 08 00 00       	call   801066f0 <release>
80105e15:	83 c4 10             	add    $0x10,%esp
    return i;
80105e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e1b:	c9                   	leave  
80105e1c:	c3                   	ret    

80105e1d <printCtrlF>:

// print the ctrl-f content
void
printCtrlF(void)
{
80105e1d:	55                   	push   %ebp
80105e1e:	89 e5                	mov    %esp,%ebp
80105e20:	83 ec 18             	sub    $0x18,%esp
    struct proc* cur = ptable.pLists.free;
80105e23:	a1 f4 70 11 80       	mov    0x801170f4,%eax
80105e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int count = 0;
80105e2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while (cur) {
80105e32:	eb 10                	jmp    80105e44 <printCtrlF+0x27>
        count++;
80105e34:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
        cur = cur->next;
80105e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
printCtrlF(void)
{
    struct proc* cur = ptable.pLists.free;
    int count = 0;
    while (cur) {
80105e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e48:	75 ea                	jne    80105e34 <printCtrlF+0x17>
        count++;
        cur = cur->next;
    }
    cprintf("%s%d%s\n", "Free List Size: ", count, " processes");
80105e4a:	68 98 a6 10 80       	push   $0x8010a698
80105e4f:	ff 75 f0             	pushl  -0x10(%ebp)
80105e52:	68 a3 a6 10 80       	push   $0x8010a6a3
80105e57:	68 b4 a6 10 80       	push   $0x8010a6b4
80105e5c:	e8 65 a5 ff ff       	call   801003c6 <cprintf>
80105e61:	83 c4 10             	add    $0x10,%esp
}
80105e64:	90                   	nop
80105e65:	c9                   	leave  
80105e66:	c3                   	ret    

80105e67 <printCtrlR>:

// print the ctrl-r content
void
printCtrlR(void)
{
80105e67:	55                   	push   %ebp
80105e68:	89 e5                	mov    %esp,%ebp
80105e6a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n", "Ready List Processes:");
80105e6d:	83 ec 08             	sub    $0x8,%esp
80105e70:	68 bc a6 10 80       	push   $0x8010a6bc
80105e75:	68 d2 a6 10 80       	push   $0x8010a6d2
80105e7a:	e8 47 a5 ff ff       	call   801003c6 <cprintf>
80105e7f:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i <= MAX; i++) {
80105e82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105e89:	e9 f0 00 00 00       	jmp    80105f7e <printCtrlR+0x117>
        struct proc* cur = ptable.pLists.ready[i];
80105e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e91:	05 cc 09 00 00       	add    $0x9cc,%eax
80105e96:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
80105e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        cprintf("%d%s", i, ": ");
80105ea0:	83 ec 04             	sub    $0x4,%esp
80105ea3:	68 d6 a6 10 80       	push   $0x8010a6d6
80105ea8:	ff 75 f4             	pushl  -0xc(%ebp)
80105eab:	68 d9 a6 10 80       	push   $0x8010a6d9
80105eb0:	e8 11 a5 ff ff       	call   801003c6 <cprintf>
80105eb5:	83 c4 10             	add    $0x10,%esp
        if (cur) {
80105eb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ebc:	74 3e                	je     80105efc <printCtrlR+0x95>
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->budget, ")");
80105ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec1:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eca:	8b 40 10             	mov    0x10(%eax),%eax
80105ecd:	83 ec 08             	sub    $0x8,%esp
80105ed0:	68 de a6 10 80       	push   $0x8010a6de
80105ed5:	52                   	push   %edx
80105ed6:	68 e0 a6 10 80       	push   $0x8010a6e0
80105edb:	50                   	push   %eax
80105edc:	68 e3 a6 10 80       	push   $0x8010a6e3
80105ee1:	68 e5 a6 10 80       	push   $0x8010a6e5
80105ee6:	e8 db a4 ff ff       	call   801003c6 <cprintf>
80105eeb:	83 c4 20             	add    $0x20,%esp
            cur = cur->next;
80105eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105efa:	eb 68                	jmp    80105f64 <printCtrlR+0xfd>
        }
        else cprintf("%s", "Empty");
80105efc:	83 ec 08             	sub    $0x8,%esp
80105eff:	68 f0 a6 10 80       	push   $0x8010a6f0
80105f04:	68 f6 a6 10 80       	push   $0x8010a6f6
80105f09:	e8 b8 a4 ff ff       	call   801003c6 <cprintf>
80105f0e:	83 c4 10             	add    $0x10,%esp
        while (cur) {
80105f11:	eb 51                	jmp    80105f64 <printCtrlR+0xfd>
            cprintf("%s", " -> ");
80105f13:	83 ec 08             	sub    $0x8,%esp
80105f16:	68 f9 a6 10 80       	push   $0x8010a6f9
80105f1b:	68 f6 a6 10 80       	push   $0x8010a6f6
80105f20:	e8 a1 a4 ff ff       	call   801003c6 <cprintf>
80105f25:	83 c4 10             	add    $0x10,%esp
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->budget, ")");
80105f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f2b:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f34:	8b 40 10             	mov    0x10(%eax),%eax
80105f37:	83 ec 08             	sub    $0x8,%esp
80105f3a:	68 de a6 10 80       	push   $0x8010a6de
80105f3f:	52                   	push   %edx
80105f40:	68 e0 a6 10 80       	push   $0x8010a6e0
80105f45:	50                   	push   %eax
80105f46:	68 e3 a6 10 80       	push   $0x8010a6e3
80105f4b:	68 e5 a6 10 80       	push   $0x8010a6e5
80105f50:	e8 71 a4 ff ff       	call   801003c6 <cprintf>
80105f55:	83 c4 20             	add    $0x20,%esp
            cur = cur->next;
80105f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f5b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f61:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (cur) {
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->budget, ")");
            cur = cur->next;
        }
        else cprintf("%s", "Empty");
        while (cur) {
80105f64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f68:	75 a9                	jne    80105f13 <printCtrlR+0xac>
            cprintf("%s", " -> ");
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->budget, ")");
            cur = cur->next;
        }
        cprintf("\n");
80105f6a:	83 ec 0c             	sub    $0xc,%esp
80105f6d:	68 78 a6 10 80       	push   $0x8010a678
80105f72:	e8 4f a4 ff ff       	call   801003c6 <cprintf>
80105f77:	83 c4 10             	add    $0x10,%esp
// print the ctrl-r content
void
printCtrlR(void)
{
    cprintf("%s\n", "Ready List Processes:");
    for (int i = 0; i <= MAX; i++) {
80105f7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105f7e:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80105f82:	0f 8e 06 ff ff ff    	jle    80105e8e <printCtrlR+0x27>
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->budget, ")");
            cur = cur->next;
        }
        cprintf("\n");
    }
    cprintf("\n");
80105f88:	83 ec 0c             	sub    $0xc,%esp
80105f8b:	68 78 a6 10 80       	push   $0x8010a678
80105f90:	e8 31 a4 ff ff       	call   801003c6 <cprintf>
80105f95:	83 c4 10             	add    $0x10,%esp
}
80105f98:	90                   	nop
80105f99:	c9                   	leave  
80105f9a:	c3                   	ret    

80105f9b <printCtrlS>:

void
printCtrlS(void)
{
80105f9b:	55                   	push   %ebp
80105f9c:	89 e5                	mov    %esp,%ebp
80105f9e:	83 ec 18             	sub    $0x18,%esp
    struct proc* cur = ptable.pLists.sleep;
80105fa1:	a1 f8 70 11 80       	mov    0x801170f8,%eax
80105fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!cur) {
80105fa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fad:	75 17                	jne    80105fc6 <printCtrlS+0x2b>
        cprintf("%s", "Sleep List is empty");
80105faf:	83 ec 08             	sub    $0x8,%esp
80105fb2:	68 fe a6 10 80       	push   $0x8010a6fe
80105fb7:	68 f6 a6 10 80       	push   $0x8010a6f6
80105fbc:	e8 05 a4 ff ff       	call   801003c6 <cprintf>
80105fc1:	83 c4 10             	add    $0x10,%esp
80105fc4:	eb 52                	jmp    80106018 <printCtrlS+0x7d>
    }
    else {
        cprintf("%s\n%d", "Sleep List Processes:", cur->pid);
80105fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc9:	8b 40 10             	mov    0x10(%eax),%eax
80105fcc:	83 ec 04             	sub    $0x4,%esp
80105fcf:	50                   	push   %eax
80105fd0:	68 12 a7 10 80       	push   $0x8010a712
80105fd5:	68 28 a7 10 80       	push   $0x8010a728
80105fda:	e8 e7 a3 ff ff       	call   801003c6 <cprintf>
80105fdf:	83 c4 10             	add    $0x10,%esp
        cur = cur->next;
80105fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    while (cur) {
80105fee:	eb 28                	jmp    80106018 <printCtrlS+0x7d>
        cprintf("%s%d", " -> ", cur->pid);
80105ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff3:	8b 40 10             	mov    0x10(%eax),%eax
80105ff6:	83 ec 04             	sub    $0x4,%esp
80105ff9:	50                   	push   %eax
80105ffa:	68 f9 a6 10 80       	push   $0x8010a6f9
80105fff:	68 2e a7 10 80       	push   $0x8010a72e
80106004:	e8 bd a3 ff ff       	call   801003c6 <cprintf>
80106009:	83 c4 10             	add    $0x10,%esp
        cur = cur->next;
8010600c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106015:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    else {
        cprintf("%s\n%d", "Sleep List Processes:", cur->pid);
        cur = cur->next;
    }
    while (cur) {
80106018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010601c:	75 d2                	jne    80105ff0 <printCtrlS+0x55>
        cprintf("%s%d", " -> ", cur->pid);
        cur = cur->next;
    }
    cprintf("\n");
8010601e:	83 ec 0c             	sub    $0xc,%esp
80106021:	68 78 a6 10 80       	push   $0x8010a678
80106026:	e8 9b a3 ff ff       	call   801003c6 <cprintf>
8010602b:	83 c4 10             	add    $0x10,%esp
}
8010602e:	90                   	nop
8010602f:	c9                   	leave  
80106030:	c3                   	ret    

80106031 <printCtrlZ>:

void
printCtrlZ(void)
{
80106031:	55                   	push   %ebp
80106032:	89 e5                	mov    %esp,%ebp
80106034:	83 ec 18             	sub    $0x18,%esp
    struct proc* cur = ptable.pLists.zombie;
80106037:	a1 fc 70 11 80       	mov    0x801170fc,%eax
8010603c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!cur) {
8010603f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106043:	75 1a                	jne    8010605f <printCtrlZ+0x2e>
        cprintf("%s", "Zombie List is empty");
80106045:	83 ec 08             	sub    $0x8,%esp
80106048:	68 33 a7 10 80       	push   $0x8010a733
8010604d:	68 f6 a6 10 80       	push   $0x8010a6f6
80106052:	e8 6f a3 ff ff       	call   801003c6 <cprintf>
80106057:	83 c4 10             	add    $0x10,%esp
8010605a:	e9 f7 00 00 00       	jmp    80106156 <printCtrlZ+0x125>
    }
    else {
        cprintf("%s\n", "Zombie List Processes:");
8010605f:	83 ec 08             	sub    $0x8,%esp
80106062:	68 48 a7 10 80       	push   $0x8010a748
80106067:	68 d2 a6 10 80       	push   $0x8010a6d2
8010606c:	e8 55 a3 ff ff       	call   801003c6 <cprintf>
80106071:	83 c4 10             	add    $0x10,%esp
        if (!cur->parent)
80106074:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106077:	8b 40 14             	mov    0x14(%eax),%eax
8010607a:	85 c0                	test   %eax,%eax
8010607c:	75 2a                	jne    801060a8 <printCtrlZ+0x77>
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", 0, ")");
8010607e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106081:	8b 40 10             	mov    0x10(%eax),%eax
80106084:	83 ec 08             	sub    $0x8,%esp
80106087:	68 de a6 10 80       	push   $0x8010a6de
8010608c:	6a 00                	push   $0x0
8010608e:	68 e0 a6 10 80       	push   $0x8010a6e0
80106093:	50                   	push   %eax
80106094:	68 e3 a6 10 80       	push   $0x8010a6e3
80106099:	68 e5 a6 10 80       	push   $0x8010a6e5
8010609e:	e8 23 a3 ff ff       	call   801003c6 <cprintf>
801060a3:	83 c4 20             	add    $0x20,%esp
801060a6:	eb 30                	jmp    801060d8 <printCtrlZ+0xa7>
        else cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->parent->pid, ")");
801060a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ab:	8b 40 14             	mov    0x14(%eax),%eax
801060ae:	8b 50 10             	mov    0x10(%eax),%edx
801060b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b4:	8b 40 10             	mov    0x10(%eax),%eax
801060b7:	83 ec 08             	sub    $0x8,%esp
801060ba:	68 de a6 10 80       	push   $0x8010a6de
801060bf:	52                   	push   %edx
801060c0:	68 e0 a6 10 80       	push   $0x8010a6e0
801060c5:	50                   	push   %eax
801060c6:	68 e3 a6 10 80       	push   $0x8010a6e3
801060cb:	68 e5 a6 10 80       	push   $0x8010a6e5
801060d0:	e8 f1 a2 ff ff       	call   801003c6 <cprintf>
801060d5:	83 c4 20             	add    $0x20,%esp
        cur = cur->next;
801060d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060db:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    while (cur) {
801060e4:	eb 70                	jmp    80106156 <printCtrlZ+0x125>
        if (!cur->parent)
801060e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e9:	8b 40 14             	mov    0x14(%eax),%eax
801060ec:	85 c0                	test   %eax,%eax
801060ee:	75 2a                	jne    8010611a <printCtrlZ+0xe9>
            cprintf("%s%d%s%d%s", " -> (", cur->pid, ", ", 0, ")");
801060f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f3:	8b 40 10             	mov    0x10(%eax),%eax
801060f6:	83 ec 08             	sub    $0x8,%esp
801060f9:	68 de a6 10 80       	push   $0x8010a6de
801060fe:	6a 00                	push   $0x0
80106100:	68 e0 a6 10 80       	push   $0x8010a6e0
80106105:	50                   	push   %eax
80106106:	68 5f a7 10 80       	push   $0x8010a75f
8010610b:	68 e5 a6 10 80       	push   $0x8010a6e5
80106110:	e8 b1 a2 ff ff       	call   801003c6 <cprintf>
80106115:	83 c4 20             	add    $0x20,%esp
80106118:	eb 30                	jmp    8010614a <printCtrlZ+0x119>
        else cprintf("%s%d%s%d%s", " -> (", cur->pid, ", ", cur->parent->pid, ")");
8010611a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010611d:	8b 40 14             	mov    0x14(%eax),%eax
80106120:	8b 50 10             	mov    0x10(%eax),%edx
80106123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106126:	8b 40 10             	mov    0x10(%eax),%eax
80106129:	83 ec 08             	sub    $0x8,%esp
8010612c:	68 de a6 10 80       	push   $0x8010a6de
80106131:	52                   	push   %edx
80106132:	68 e0 a6 10 80       	push   $0x8010a6e0
80106137:	50                   	push   %eax
80106138:	68 5f a7 10 80       	push   $0x8010a75f
8010613d:	68 e5 a6 10 80       	push   $0x8010a6e5
80106142:	e8 7f a2 ff ff       	call   801003c6 <cprintf>
80106147:	83 c4 20             	add    $0x20,%esp
        cur = cur->next;
8010614a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010614d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106153:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (!cur->parent)
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", 0, ")");
        else cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->parent->pid, ")");
        cur = cur->next;
    }
    while (cur) {
80106156:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010615a:	75 8a                	jne    801060e6 <printCtrlZ+0xb5>
        if (!cur->parent)
            cprintf("%s%d%s%d%s", " -> (", cur->pid, ", ", 0, ")");
        else cprintf("%s%d%s%d%s", " -> (", cur->pid, ", ", cur->parent->pid, ")");
        cur = cur->next;
    }
    cprintf("\n");
8010615c:	83 ec 0c             	sub    $0xc,%esp
8010615f:	68 78 a6 10 80       	push   $0x8010a678
80106164:	e8 5d a2 ff ff       	call   801003c6 <cprintf>
80106169:	83 c4 10             	add    $0x10,%esp
}
8010616c:	90                   	nop
8010616d:	c9                   	leave  
8010616e:	c3                   	ret    

8010616f <removeFromStateList>:

static int
removeFromStateList(struct proc** sList, struct proc* p, int state)
{
8010616f:	55                   	push   %ebp
80106170:	89 e5                	mov    %esp,%ebp
80106172:	83 ec 10             	sub    $0x10,%esp
    if (p->state != state)
80106175:	8b 45 0c             	mov    0xc(%ebp),%eax
80106178:	8b 50 0c             	mov    0xc(%eax),%edx
8010617b:	8b 45 10             	mov    0x10(%ebp),%eax
8010617e:	39 c2                	cmp    %eax,%edx
80106180:	74 0a                	je     8010618c <removeFromStateList+0x1d>
        return -1;
80106182:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106187:	e9 a9 00 00 00       	jmp    80106235 <removeFromStateList+0xc6>
    if (!*sList)
8010618c:	8b 45 08             	mov    0x8(%ebp),%eax
8010618f:	8b 00                	mov    (%eax),%eax
80106191:	85 c0                	test   %eax,%eax
80106193:	75 0a                	jne    8010619f <removeFromStateList+0x30>
        return -1;
80106195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619a:	e9 96 00 00 00       	jmp    80106235 <removeFromStateList+0xc6>
    if (p == *sList) {
8010619f:	8b 45 08             	mov    0x8(%ebp),%eax
801061a2:	8b 00                	mov    (%eax),%eax
801061a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801061a7:	75 24                	jne    801061cd <removeFromStateList+0x5e>
        *sList = (*sList)->next;
801061a9:	8b 45 08             	mov    0x8(%ebp),%eax
801061ac:	8b 00                	mov    (%eax),%eax
801061ae:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801061b4:	8b 45 08             	mov    0x8(%ebp),%eax
801061b7:	89 10                	mov    %edx,(%eax)
        p->next = 0;
801061b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801061bc:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801061c3:	00 00 00 
        return 0;
801061c6:	b8 00 00 00 00       	mov    $0x0,%eax
801061cb:	eb 68                	jmp    80106235 <removeFromStateList+0xc6>
    }
    struct proc *cur = *sList;
801061cd:	8b 45 08             	mov    0x8(%ebp),%eax
801061d0:	8b 00                	mov    (%eax),%eax
801061d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (cur->next) {
801061d5:	eb 4c                	jmp    80106223 <removeFromStateList+0xb4>
        if (p == cur->next) {
801061d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061da:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801061e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801061e3:	75 32                	jne    80106217 <removeFromStateList+0xa8>
            struct proc* tmp = cur->next;
801061e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061e8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801061ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
            cur->next = tmp->next;
801061f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801061f4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801061fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061fd:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
            tmp->next = 0;
80106203:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106206:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010620d:	00 00 00 
            return 0;
80106210:	b8 00 00 00 00       	mov    $0x0,%eax
80106215:	eb 1e                	jmp    80106235 <removeFromStateList+0xc6>
        }
        cur = cur->next;
80106217:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010621a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106220:	89 45 fc             	mov    %eax,-0x4(%ebp)
        *sList = (*sList)->next;
        p->next = 0;
        return 0;
    }
    struct proc *cur = *sList;
    while (cur->next) {
80106223:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106226:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010622c:	85 c0                	test   %eax,%eax
8010622e:	75 a7                	jne    801061d7 <removeFromStateList+0x68>
            tmp->next = 0;
            return 0;
        }
        cur = cur->next;
    }
    return -1;
80106230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106235:	c9                   	leave  
80106236:	c3                   	ret    

80106237 <addProcToLast>:

static void
addProcToLast(struct proc** sList, struct proc* p)
{
80106237:	55                   	push   %ebp
80106238:	89 e5                	mov    %esp,%ebp
8010623a:	83 ec 10             	sub    $0x10,%esp
    if (!(*sList)) {
8010623d:	8b 45 08             	mov    0x8(%ebp),%eax
80106240:	8b 00                	mov    (%eax),%eax
80106242:	85 c0                	test   %eax,%eax
80106244:	75 19                	jne    8010625f <addProcToLast+0x28>
        *sList = p;
80106246:	8b 45 08             	mov    0x8(%ebp),%eax
80106249:	8b 55 0c             	mov    0xc(%ebp),%edx
8010624c:	89 10                	mov    %edx,(%eax)
        (*sList)->next = 0;
8010624e:	8b 45 08             	mov    0x8(%ebp),%eax
80106251:	8b 00                	mov    (%eax),%eax
80106253:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010625a:	00 00 00 
        return;
8010625d:	eb 55                	jmp    801062b4 <addProcToLast+0x7d>
    }
    struct proc* cur = *sList;
8010625f:	8b 45 08             	mov    0x8(%ebp),%eax
80106262:	8b 00                	mov    (%eax),%eax
80106264:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (cur->next) {
80106267:	eb 1c                	jmp    80106285 <addProcToLast+0x4e>
        if (cur->pid == p->pid)
80106269:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010626c:	8b 50 10             	mov    0x10(%eax),%edx
8010626f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106272:	8b 40 10             	mov    0x10(%eax),%eax
80106275:	39 c2                	cmp    %eax,%edx
80106277:	74 3a                	je     801062b3 <addProcToLast+0x7c>
            return;
        cur = cur->next;
80106279:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010627c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106282:	89 45 fc             	mov    %eax,-0x4(%ebp)
        *sList = p;
        (*sList)->next = 0;
        return;
    }
    struct proc* cur = *sList;
    while (cur->next) {
80106285:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106288:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010628e:	85 c0                	test   %eax,%eax
80106290:	75 d7                	jne    80106269 <addProcToLast+0x32>
        if (cur->pid == p->pid)
            return;
        cur = cur->next;
    }
    cur->next = p;
80106292:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106295:	8b 55 0c             	mov    0xc(%ebp),%edx
80106298:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    cur->next->next = 0;
8010629e:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062a1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801062a7:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801062ae:	00 00 00 
801062b1:	eb 01                	jmp    801062b4 <addProcToLast+0x7d>
        return;
    }
    struct proc* cur = *sList;
    while (cur->next) {
        if (cur->pid == p->pid)
            return;
801062b3:	90                   	nop
        cur = cur->next;
    }
    cur->next = p;
    cur->next->next = 0;
}
801062b4:	c9                   	leave  
801062b5:	c3                   	ret    

801062b6 <addProcToBegin>:

static void
addProcToBegin(struct proc** sList, struct proc* p)
{
801062b6:	55                   	push   %ebp
801062b7:	89 e5                	mov    %esp,%ebp
    p->next = *sList;
801062b9:	8b 45 08             	mov    0x8(%ebp),%eax
801062bc:	8b 10                	mov    (%eax),%edx
801062be:	8b 45 0c             	mov    0xc(%ebp),%eax
801062c1:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    *sList = p;
801062c7:	8b 45 08             	mov    0x8(%ebp),%eax
801062ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801062cd:	89 10                	mov    %edx,(%eax)
}
801062cf:	90                   	nop
801062d0:	5d                   	pop    %ebp
801062d1:	c3                   	ret    

801062d2 <findByPID>:

static struct proc*
findByPID(struct proc* sList, int pid)
{
801062d2:	55                   	push   %ebp
801062d3:	89 e5                	mov    %esp,%ebp
801062d5:	83 ec 10             	sub    $0x10,%esp
    if (!sList)
801062d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801062dc:	75 07                	jne    801062e5 <findByPID+0x13>
        return 0;
801062de:	b8 00 00 00 00       	mov    $0x0,%eax
801062e3:	eb 31                	jmp    80106316 <findByPID+0x44>
    else {
        struct proc* p;
        for (p = sList; p; p = p->next) {
801062e5:	8b 45 08             	mov    0x8(%ebp),%eax
801062e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801062eb:	eb 1e                	jmp    8010630b <findByPID+0x39>
            if (p->pid == pid)
801062ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062f0:	8b 50 10             	mov    0x10(%eax),%edx
801062f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801062f6:	39 c2                	cmp    %eax,%edx
801062f8:	75 05                	jne    801062ff <findByPID+0x2d>
                return p;
801062fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062fd:	eb 17                	jmp    80106316 <findByPID+0x44>
{
    if (!sList)
        return 0;
    else {
        struct proc* p;
        for (p = sList; p; p = p->next) {
801062ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106302:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106308:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010630b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010630f:	75 dc                	jne    801062ed <findByPID+0x1b>
            if (p->pid == pid)
                return p;
        }
        return 0;
80106311:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
80106316:	c9                   	leave  
80106317:	c3                   	ret    

80106318 <setpriority>:

int
setpriority(int pid, int value)
{
80106318:	55                   	push   %ebp
80106319:	89 e5                	mov    %esp,%ebp
8010631b:	83 ec 18             	sub    $0x18,%esp
    if (pid < 0 || value < 0 || value > MAX)
8010631e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106322:	78 0c                	js     80106330 <setpriority+0x18>
80106324:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106328:	78 06                	js     80106330 <setpriority+0x18>
8010632a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
8010632e:	7e 0a                	jle    8010633a <setpriority+0x22>
        return -1;
80106330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106335:	e9 ab 01 00 00       	jmp    801064e5 <setpriority+0x1cd>
    acquire(&ptable.lock);
8010633a:	83 ec 0c             	sub    $0xc,%esp
8010633d:	68 a0 49 11 80       	push   $0x801149a0
80106342:	e8 42 03 00 00       	call   80106689 <acquire>
80106347:	83 c4 10             	add    $0x10,%esp
    struct proc* p;
    for (int i = 0; i <= MAX; i++) {
8010634a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106351:	e9 d4 00 00 00       	jmp    8010642a <setpriority+0x112>
        p = findByPID(ptable.pLists.ready[i], pid);
80106356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106359:	05 cc 09 00 00       	add    $0x9cc,%eax
8010635e:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
80106365:	83 ec 08             	sub    $0x8,%esp
80106368:	ff 75 08             	pushl  0x8(%ebp)
8010636b:	50                   	push   %eax
8010636c:	e8 61 ff ff ff       	call   801062d2 <findByPID>
80106371:	83 c4 10             	add    $0x10,%esp
80106374:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p) {
80106377:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010637b:	0f 84 a5 00 00 00    	je     80106426 <setpriority+0x10e>
            if (p->priority != value) {
80106381:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106384:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010638a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010638d:	74 7d                	je     8010640c <setpriority+0xf4>
                p->priority = value;
8010638f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106392:	8b 55 0c             	mov    0xc(%ebp),%edx
80106395:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                p->budget = BUDGET;
8010639b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010639e:	c7 80 98 00 00 00 c8 	movl   $0xc8,0x98(%eax)
801063a5:	00 00 00 
                if (removeFromStateList(&ptable.pLists.ready[i], p, p->state) < 0)
801063a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ab:	8b 40 0c             	mov    0xc(%eax),%eax
801063ae:	89 c2                	mov    %eax,%edx
801063b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b3:	05 cc 09 00 00       	add    $0x9cc,%eax
801063b8:	c1 e0 02             	shl    $0x2,%eax
801063bb:	05 a0 49 11 80       	add    $0x801149a0,%eax
801063c0:	83 c0 04             	add    $0x4,%eax
801063c3:	83 ec 04             	sub    $0x4,%esp
801063c6:	52                   	push   %edx
801063c7:	ff 75 f0             	pushl  -0x10(%ebp)
801063ca:	50                   	push   %eax
801063cb:	e8 9f fd ff ff       	call   8010616f <removeFromStateList>
801063d0:	83 c4 10             	add    $0x10,%esp
801063d3:	85 c0                	test   %eax,%eax
801063d5:	79 0d                	jns    801063e4 <setpriority+0xcc>
                    panic("Cannot remove from ready list - setpriority");
801063d7:	83 ec 0c             	sub    $0xc,%esp
801063da:	68 68 a7 10 80       	push   $0x8010a768
801063df:	e8 82 a1 ff ff       	call   80100566 <panic>
                addProcToLast(&ptable.pLists.ready[p->priority], p);
801063e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063e7:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801063ed:	05 cc 09 00 00       	add    $0x9cc,%eax
801063f2:	c1 e0 02             	shl    $0x2,%eax
801063f5:	05 a0 49 11 80       	add    $0x801149a0,%eax
801063fa:	83 c0 04             	add    $0x4,%eax
801063fd:	83 ec 08             	sub    $0x8,%esp
80106400:	ff 75 f0             	pushl  -0x10(%ebp)
80106403:	50                   	push   %eax
80106404:	e8 2e fe ff ff       	call   80106237 <addProcToLast>
80106409:	83 c4 10             	add    $0x10,%esp
            }
            release(&ptable.lock);
8010640c:	83 ec 0c             	sub    $0xc,%esp
8010640f:	68 a0 49 11 80       	push   $0x801149a0
80106414:	e8 d7 02 00 00       	call   801066f0 <release>
80106419:	83 c4 10             	add    $0x10,%esp
            return 0;
8010641c:	b8 00 00 00 00       	mov    $0x0,%eax
80106421:	e9 bf 00 00 00       	jmp    801064e5 <setpriority+0x1cd>
{
    if (pid < 0 || value < 0 || value > MAX)
        return -1;
    acquire(&ptable.lock);
    struct proc* p;
    for (int i = 0; i <= MAX; i++) {
80106426:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010642a:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010642e:	0f 8e 22 ff ff ff    	jle    80106356 <setpriority+0x3e>
            }
            release(&ptable.lock);
            return 0;
        }
    }
    p = findByPID(ptable.pLists.sleep, pid);
80106434:	a1 f8 70 11 80       	mov    0x801170f8,%eax
80106439:	83 ec 08             	sub    $0x8,%esp
8010643c:	ff 75 08             	pushl  0x8(%ebp)
8010643f:	50                   	push   %eax
80106440:	e8 8d fe ff ff       	call   801062d2 <findByPID>
80106445:	83 c4 10             	add    $0x10,%esp
80106448:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (p) {
8010644b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010644f:	74 31                	je     80106482 <setpriority+0x16a>
        if (p->priority != value)
80106451:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106454:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010645a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010645d:	74 0c                	je     8010646b <setpriority+0x153>
            p->priority = value;
8010645f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106462:	8b 55 0c             	mov    0xc(%ebp),%edx
80106465:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        release(&ptable.lock);
8010646b:	83 ec 0c             	sub    $0xc,%esp
8010646e:	68 a0 49 11 80       	push   $0x801149a0
80106473:	e8 78 02 00 00       	call   801066f0 <release>
80106478:	83 c4 10             	add    $0x10,%esp
        return 0;
8010647b:	b8 00 00 00 00       	mov    $0x0,%eax
80106480:	eb 63                	jmp    801064e5 <setpriority+0x1cd>
    }
    p = findByPID(ptable.pLists.running, pid);
80106482:	a1 00 71 11 80       	mov    0x80117100,%eax
80106487:	83 ec 08             	sub    $0x8,%esp
8010648a:	ff 75 08             	pushl  0x8(%ebp)
8010648d:	50                   	push   %eax
8010648e:	e8 3f fe ff ff       	call   801062d2 <findByPID>
80106493:	83 c4 10             	add    $0x10,%esp
80106496:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (p) {
80106499:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010649d:	74 31                	je     801064d0 <setpriority+0x1b8>
        if (p->priority != value)
8010649f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064a2:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801064ab:	74 0c                	je     801064b9 <setpriority+0x1a1>
            p->priority = value;
801064ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801064b3:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        release(&ptable.lock);
801064b9:	83 ec 0c             	sub    $0xc,%esp
801064bc:	68 a0 49 11 80       	push   $0x801149a0
801064c1:	e8 2a 02 00 00       	call   801066f0 <release>
801064c6:	83 c4 10             	add    $0x10,%esp
        return 0;
801064c9:	b8 00 00 00 00       	mov    $0x0,%eax
801064ce:	eb 15                	jmp    801064e5 <setpriority+0x1cd>
    }
    release(&ptable.lock);
801064d0:	83 ec 0c             	sub    $0xc,%esp
801064d3:	68 a0 49 11 80       	push   $0x801149a0
801064d8:	e8 13 02 00 00       	call   801066f0 <release>
801064dd:	83 c4 10             	add    $0x10,%esp
    return -1;
801064e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064e5:	c9                   	leave  
801064e6:	c3                   	ret    

801064e7 <promote>:

static void
promote()
{
801064e7:	55                   	push   %ebp
801064e8:	89 e5                	mov    %esp,%ebp
801064ea:	83 ec 18             	sub    $0x18,%esp
    struct proc* cur;

    // ready list
    for (int i = 1; i <= MAX; i++) {
801064ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
801064f4:	e9 ad 00 00 00       	jmp    801065a6 <promote+0xbf>
        for (cur = ptable.pLists.ready[i]; cur;) {
801064f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fc:	05 cc 09 00 00       	add    $0x9cc,%eax
80106501:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
80106508:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010650b:	e9 88 00 00 00       	jmp    80106598 <promote+0xb1>
            struct proc* tmp = cur->next;
80106510:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106513:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106519:	89 45 ec             	mov    %eax,-0x14(%ebp)
            /*if (cur->priority > 0){
                cur->priority -= 1;
            }*/
            cur->priority -= 1;
8010651c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010651f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106525:	8d 50 ff             	lea    -0x1(%eax),%edx
80106528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010652b:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            if (removeFromStateList(&ptable.pLists.ready[i], cur, cur->state) < 0)
80106531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106534:	8b 40 0c             	mov    0xc(%eax),%eax
80106537:	89 c2                	mov    %eax,%edx
80106539:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010653c:	05 cc 09 00 00       	add    $0x9cc,%eax
80106541:	c1 e0 02             	shl    $0x2,%eax
80106544:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106549:	83 c0 04             	add    $0x4,%eax
8010654c:	52                   	push   %edx
8010654d:	ff 75 f4             	pushl  -0xc(%ebp)
80106550:	50                   	push   %eax
80106551:	e8 19 fc ff ff       	call   8010616f <removeFromStateList>
80106556:	83 c4 0c             	add    $0xc,%esp
80106559:	85 c0                	test   %eax,%eax
8010655b:	79 0d                	jns    8010656a <promote+0x83>
                panic("Cannot remove proc from ready list - promote");
8010655d:	83 ec 0c             	sub    $0xc,%esp
80106560:	68 94 a7 10 80       	push   $0x8010a794
80106565:	e8 fc 9f ff ff       	call   80100566 <panic>
            addProcToLast(&ptable.pLists.ready[cur->priority], cur);
8010656a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010656d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106573:	05 cc 09 00 00       	add    $0x9cc,%eax
80106578:	c1 e0 02             	shl    $0x2,%eax
8010657b:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106580:	83 c0 04             	add    $0x4,%eax
80106583:	83 ec 08             	sub    $0x8,%esp
80106586:	ff 75 f4             	pushl  -0xc(%ebp)
80106589:	50                   	push   %eax
8010658a:	e8 a8 fc ff ff       	call   80106237 <addProcToLast>
8010658f:	83 c4 10             	add    $0x10,%esp
            cur = tmp;
80106592:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106595:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
    struct proc* cur;

    // ready list
    for (int i = 1; i <= MAX; i++) {
        for (cur = ptable.pLists.ready[i]; cur;) {
80106598:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010659c:	0f 85 6e ff ff ff    	jne    80106510 <promote+0x29>
promote()
{
    struct proc* cur;

    // ready list
    for (int i = 1; i <= MAX; i++) {
801065a2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801065a6:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
801065aa:	0f 8e 49 ff ff ff    	jle    801064f9 <promote+0x12>
            cur = tmp;
        }
    }

    // sleep list
    for (cur = ptable.pLists.sleep; cur; cur = cur->next) {
801065b0:	a1 f8 70 11 80       	mov    0x801170f8,%eax
801065b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065b8:	eb 2e                	jmp    801065e8 <promote+0x101>
        if (cur->priority > 0)
801065ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065bd:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801065c3:	85 c0                	test   %eax,%eax
801065c5:	7e 15                	jle    801065dc <promote+0xf5>
            cur->priority -= 1;
801065c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ca:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801065d0:	8d 50 ff             	lea    -0x1(%eax),%edx
801065d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d6:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            cur = tmp;
        }
    }

    // sleep list
    for (cur = ptable.pLists.sleep; cur; cur = cur->next) {
801065dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065df:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065ec:	75 cc                	jne    801065ba <promote+0xd3>
        if (cur->priority > 0)
            cur->priority -= 1;
    }

    // running list
    for (cur = ptable.pLists.running; cur; cur = cur->next) {
801065ee:	a1 00 71 11 80       	mov    0x80117100,%eax
801065f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065f6:	eb 2e                	jmp    80106626 <promote+0x13f>
        if (cur->priority > 0)
801065f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065fb:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106601:	85 c0                	test   %eax,%eax
80106603:	7e 15                	jle    8010661a <promote+0x133>
            cur->priority -= 1;
80106605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106608:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010660e:	8d 50 ff             	lea    -0x1(%eax),%edx
80106611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106614:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        if (cur->priority > 0)
            cur->priority -= 1;
    }

    // running list
    for (cur = ptable.pLists.running; cur; cur = cur->next) {
8010661a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106623:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010662a:	75 cc                	jne    801065f8 <promote+0x111>
        if (cur->priority > 0)
            cur->priority -= 1;
    }
}
8010662c:	90                   	nop
8010662d:	c9                   	leave  
8010662e:	c3                   	ret    

8010662f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010662f:	55                   	push   %ebp
80106630:	89 e5                	mov    %esp,%ebp
80106632:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106635:	9c                   	pushf  
80106636:	58                   	pop    %eax
80106637:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010663a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010663d:	c9                   	leave  
8010663e:	c3                   	ret    

8010663f <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010663f:	55                   	push   %ebp
80106640:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106642:	fa                   	cli    
}
80106643:	90                   	nop
80106644:	5d                   	pop    %ebp
80106645:	c3                   	ret    

80106646 <sti>:

static inline void
sti(void)
{
80106646:	55                   	push   %ebp
80106647:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80106649:	fb                   	sti    
}
8010664a:	90                   	nop
8010664b:	5d                   	pop    %ebp
8010664c:	c3                   	ret    

8010664d <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010664d:	55                   	push   %ebp
8010664e:	89 e5                	mov    %esp,%ebp
80106650:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106653:	8b 55 08             	mov    0x8(%ebp),%edx
80106656:	8b 45 0c             	mov    0xc(%ebp),%eax
80106659:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010665c:	f0 87 02             	lock xchg %eax,(%edx)
8010665f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106662:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106665:	c9                   	leave  
80106666:	c3                   	ret    

80106667 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106667:	55                   	push   %ebp
80106668:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010666a:	8b 45 08             	mov    0x8(%ebp),%eax
8010666d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106670:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80106673:	8b 45 08             	mov    0x8(%ebp),%eax
80106676:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010667c:	8b 45 08             	mov    0x8(%ebp),%eax
8010667f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106686:	90                   	nop
80106687:	5d                   	pop    %ebp
80106688:	c3                   	ret    

80106689 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106689:	55                   	push   %ebp
8010668a:	89 e5                	mov    %esp,%ebp
8010668c:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010668f:	e8 52 01 00 00       	call   801067e6 <pushcli>
  if(holding(lk))
80106694:	8b 45 08             	mov    0x8(%ebp),%eax
80106697:	83 ec 0c             	sub    $0xc,%esp
8010669a:	50                   	push   %eax
8010669b:	e8 1c 01 00 00       	call   801067bc <holding>
801066a0:	83 c4 10             	add    $0x10,%esp
801066a3:	85 c0                	test   %eax,%eax
801066a5:	74 0d                	je     801066b4 <acquire+0x2b>
    panic("acquire");
801066a7:	83 ec 0c             	sub    $0xc,%esp
801066aa:	68 c1 a7 10 80       	push   $0x8010a7c1
801066af:	e8 b2 9e ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801066b4:	90                   	nop
801066b5:	8b 45 08             	mov    0x8(%ebp),%eax
801066b8:	83 ec 08             	sub    $0x8,%esp
801066bb:	6a 01                	push   $0x1
801066bd:	50                   	push   %eax
801066be:	e8 8a ff ff ff       	call   8010664d <xchg>
801066c3:	83 c4 10             	add    $0x10,%esp
801066c6:	85 c0                	test   %eax,%eax
801066c8:	75 eb                	jne    801066b5 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801066ca:	8b 45 08             	mov    0x8(%ebp),%eax
801066cd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801066d4:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801066d7:	8b 45 08             	mov    0x8(%ebp),%eax
801066da:	83 c0 0c             	add    $0xc,%eax
801066dd:	83 ec 08             	sub    $0x8,%esp
801066e0:	50                   	push   %eax
801066e1:	8d 45 08             	lea    0x8(%ebp),%eax
801066e4:	50                   	push   %eax
801066e5:	e8 58 00 00 00       	call   80106742 <getcallerpcs>
801066ea:	83 c4 10             	add    $0x10,%esp
}
801066ed:	90                   	nop
801066ee:	c9                   	leave  
801066ef:	c3                   	ret    

801066f0 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801066f6:	83 ec 0c             	sub    $0xc,%esp
801066f9:	ff 75 08             	pushl  0x8(%ebp)
801066fc:	e8 bb 00 00 00       	call   801067bc <holding>
80106701:	83 c4 10             	add    $0x10,%esp
80106704:	85 c0                	test   %eax,%eax
80106706:	75 0d                	jne    80106715 <release+0x25>
    panic("release");
80106708:	83 ec 0c             	sub    $0xc,%esp
8010670b:	68 c9 a7 10 80       	push   $0x8010a7c9
80106710:	e8 51 9e ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80106715:	8b 45 08             	mov    0x8(%ebp),%eax
80106718:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010671f:	8b 45 08             	mov    0x8(%ebp),%eax
80106722:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80106729:	8b 45 08             	mov    0x8(%ebp),%eax
8010672c:	83 ec 08             	sub    $0x8,%esp
8010672f:	6a 00                	push   $0x0
80106731:	50                   	push   %eax
80106732:	e8 16 ff ff ff       	call   8010664d <xchg>
80106737:	83 c4 10             	add    $0x10,%esp

  popcli();
8010673a:	e8 ec 00 00 00       	call   8010682b <popcli>
}
8010673f:	90                   	nop
80106740:	c9                   	leave  
80106741:	c3                   	ret    

80106742 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106742:	55                   	push   %ebp
80106743:	89 e5                	mov    %esp,%ebp
80106745:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80106748:	8b 45 08             	mov    0x8(%ebp),%eax
8010674b:	83 e8 08             	sub    $0x8,%eax
8010674e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106751:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80106758:	eb 38                	jmp    80106792 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010675a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010675e:	74 53                	je     801067b3 <getcallerpcs+0x71>
80106760:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80106767:	76 4a                	jbe    801067b3 <getcallerpcs+0x71>
80106769:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010676d:	74 44                	je     801067b3 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010676f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106772:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106779:	8b 45 0c             	mov    0xc(%ebp),%eax
8010677c:	01 c2                	add    %eax,%edx
8010677e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106781:	8b 40 04             	mov    0x4(%eax),%eax
80106784:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106786:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106789:	8b 00                	mov    (%eax),%eax
8010678b:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010678e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106792:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106796:	7e c2                	jle    8010675a <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106798:	eb 19                	jmp    801067b3 <getcallerpcs+0x71>
    pcs[i] = 0;
8010679a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010679d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801067a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801067a7:	01 d0                	add    %edx,%eax
801067a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801067af:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801067b3:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801067b7:	7e e1                	jle    8010679a <getcallerpcs+0x58>
    pcs[i] = 0;
}
801067b9:	90                   	nop
801067ba:	c9                   	leave  
801067bb:	c3                   	ret    

801067bc <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801067bc:	55                   	push   %ebp
801067bd:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801067bf:	8b 45 08             	mov    0x8(%ebp),%eax
801067c2:	8b 00                	mov    (%eax),%eax
801067c4:	85 c0                	test   %eax,%eax
801067c6:	74 17                	je     801067df <holding+0x23>
801067c8:	8b 45 08             	mov    0x8(%ebp),%eax
801067cb:	8b 50 08             	mov    0x8(%eax),%edx
801067ce:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801067d4:	39 c2                	cmp    %eax,%edx
801067d6:	75 07                	jne    801067df <holding+0x23>
801067d8:	b8 01 00 00 00       	mov    $0x1,%eax
801067dd:	eb 05                	jmp    801067e4 <holding+0x28>
801067df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067e4:	5d                   	pop    %ebp
801067e5:	c3                   	ret    

801067e6 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801067e6:	55                   	push   %ebp
801067e7:	89 e5                	mov    %esp,%ebp
801067e9:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801067ec:	e8 3e fe ff ff       	call   8010662f <readeflags>
801067f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801067f4:	e8 46 fe ff ff       	call   8010663f <cli>
  if(cpu->ncli++ == 0)
801067f9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106800:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80106806:	8d 48 01             	lea    0x1(%eax),%ecx
80106809:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
8010680f:	85 c0                	test   %eax,%eax
80106811:	75 15                	jne    80106828 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80106813:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106819:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010681c:	81 e2 00 02 00 00    	and    $0x200,%edx
80106822:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106828:	90                   	nop
80106829:	c9                   	leave  
8010682a:	c3                   	ret    

8010682b <popcli>:

void
popcli(void)
{
8010682b:	55                   	push   %ebp
8010682c:	89 e5                	mov    %esp,%ebp
8010682e:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106831:	e8 f9 fd ff ff       	call   8010662f <readeflags>
80106836:	25 00 02 00 00       	and    $0x200,%eax
8010683b:	85 c0                	test   %eax,%eax
8010683d:	74 0d                	je     8010684c <popcli+0x21>
    panic("popcli - interruptible");
8010683f:	83 ec 0c             	sub    $0xc,%esp
80106842:	68 d1 a7 10 80       	push   $0x8010a7d1
80106847:	e8 1a 9d ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
8010684c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106852:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106858:	83 ea 01             	sub    $0x1,%edx
8010685b:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106861:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106867:	85 c0                	test   %eax,%eax
80106869:	79 0d                	jns    80106878 <popcli+0x4d>
    panic("popcli");
8010686b:	83 ec 0c             	sub    $0xc,%esp
8010686e:	68 e8 a7 10 80       	push   $0x8010a7e8
80106873:	e8 ee 9c ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106878:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010687e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106884:	85 c0                	test   %eax,%eax
80106886:	75 15                	jne    8010689d <popcli+0x72>
80106888:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010688e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106894:	85 c0                	test   %eax,%eax
80106896:	74 05                	je     8010689d <popcli+0x72>
    sti();
80106898:	e8 a9 fd ff ff       	call   80106646 <sti>
}
8010689d:	90                   	nop
8010689e:	c9                   	leave  
8010689f:	c3                   	ret    

801068a0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	57                   	push   %edi
801068a4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801068a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801068a8:	8b 55 10             	mov    0x10(%ebp),%edx
801068ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801068ae:	89 cb                	mov    %ecx,%ebx
801068b0:	89 df                	mov    %ebx,%edi
801068b2:	89 d1                	mov    %edx,%ecx
801068b4:	fc                   	cld    
801068b5:	f3 aa                	rep stos %al,%es:(%edi)
801068b7:	89 ca                	mov    %ecx,%edx
801068b9:	89 fb                	mov    %edi,%ebx
801068bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
801068be:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801068c1:	90                   	nop
801068c2:	5b                   	pop    %ebx
801068c3:	5f                   	pop    %edi
801068c4:	5d                   	pop    %ebp
801068c5:	c3                   	ret    

801068c6 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801068c6:	55                   	push   %ebp
801068c7:	89 e5                	mov    %esp,%ebp
801068c9:	57                   	push   %edi
801068ca:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801068cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801068ce:	8b 55 10             	mov    0x10(%ebp),%edx
801068d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801068d4:	89 cb                	mov    %ecx,%ebx
801068d6:	89 df                	mov    %ebx,%edi
801068d8:	89 d1                	mov    %edx,%ecx
801068da:	fc                   	cld    
801068db:	f3 ab                	rep stos %eax,%es:(%edi)
801068dd:	89 ca                	mov    %ecx,%edx
801068df:	89 fb                	mov    %edi,%ebx
801068e1:	89 5d 08             	mov    %ebx,0x8(%ebp)
801068e4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801068e7:	90                   	nop
801068e8:	5b                   	pop    %ebx
801068e9:	5f                   	pop    %edi
801068ea:	5d                   	pop    %ebp
801068eb:	c3                   	ret    

801068ec <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801068ec:	55                   	push   %ebp
801068ed:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801068ef:	8b 45 08             	mov    0x8(%ebp),%eax
801068f2:	83 e0 03             	and    $0x3,%eax
801068f5:	85 c0                	test   %eax,%eax
801068f7:	75 43                	jne    8010693c <memset+0x50>
801068f9:	8b 45 10             	mov    0x10(%ebp),%eax
801068fc:	83 e0 03             	and    $0x3,%eax
801068ff:	85 c0                	test   %eax,%eax
80106901:	75 39                	jne    8010693c <memset+0x50>
    c &= 0xFF;
80106903:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010690a:	8b 45 10             	mov    0x10(%ebp),%eax
8010690d:	c1 e8 02             	shr    $0x2,%eax
80106910:	89 c1                	mov    %eax,%ecx
80106912:	8b 45 0c             	mov    0xc(%ebp),%eax
80106915:	c1 e0 18             	shl    $0x18,%eax
80106918:	89 c2                	mov    %eax,%edx
8010691a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010691d:	c1 e0 10             	shl    $0x10,%eax
80106920:	09 c2                	or     %eax,%edx
80106922:	8b 45 0c             	mov    0xc(%ebp),%eax
80106925:	c1 e0 08             	shl    $0x8,%eax
80106928:	09 d0                	or     %edx,%eax
8010692a:	0b 45 0c             	or     0xc(%ebp),%eax
8010692d:	51                   	push   %ecx
8010692e:	50                   	push   %eax
8010692f:	ff 75 08             	pushl  0x8(%ebp)
80106932:	e8 8f ff ff ff       	call   801068c6 <stosl>
80106937:	83 c4 0c             	add    $0xc,%esp
8010693a:	eb 12                	jmp    8010694e <memset+0x62>
  } else
    stosb(dst, c, n);
8010693c:	8b 45 10             	mov    0x10(%ebp),%eax
8010693f:	50                   	push   %eax
80106940:	ff 75 0c             	pushl  0xc(%ebp)
80106943:	ff 75 08             	pushl  0x8(%ebp)
80106946:	e8 55 ff ff ff       	call   801068a0 <stosb>
8010694b:	83 c4 0c             	add    $0xc,%esp
  return dst;
8010694e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106951:	c9                   	leave  
80106952:	c3                   	ret    

80106953 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106953:	55                   	push   %ebp
80106954:	89 e5                	mov    %esp,%ebp
80106956:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106959:	8b 45 08             	mov    0x8(%ebp),%eax
8010695c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010695f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106962:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106965:	eb 30                	jmp    80106997 <memcmp+0x44>
    if(*s1 != *s2)
80106967:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010696a:	0f b6 10             	movzbl (%eax),%edx
8010696d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106970:	0f b6 00             	movzbl (%eax),%eax
80106973:	38 c2                	cmp    %al,%dl
80106975:	74 18                	je     8010698f <memcmp+0x3c>
      return *s1 - *s2;
80106977:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010697a:	0f b6 00             	movzbl (%eax),%eax
8010697d:	0f b6 d0             	movzbl %al,%edx
80106980:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106983:	0f b6 00             	movzbl (%eax),%eax
80106986:	0f b6 c0             	movzbl %al,%eax
80106989:	29 c2                	sub    %eax,%edx
8010698b:	89 d0                	mov    %edx,%eax
8010698d:	eb 1a                	jmp    801069a9 <memcmp+0x56>
    s1++, s2++;
8010698f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106993:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106997:	8b 45 10             	mov    0x10(%ebp),%eax
8010699a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010699d:	89 55 10             	mov    %edx,0x10(%ebp)
801069a0:	85 c0                	test   %eax,%eax
801069a2:	75 c3                	jne    80106967 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801069a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069a9:	c9                   	leave  
801069aa:	c3                   	ret    

801069ab <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801069ab:	55                   	push   %ebp
801069ac:	89 e5                	mov    %esp,%ebp
801069ae:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801069b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801069b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801069b7:	8b 45 08             	mov    0x8(%ebp),%eax
801069ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801069bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801069c3:	73 54                	jae    80106a19 <memmove+0x6e>
801069c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069c8:	8b 45 10             	mov    0x10(%ebp),%eax
801069cb:	01 d0                	add    %edx,%eax
801069cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801069d0:	76 47                	jbe    80106a19 <memmove+0x6e>
    s += n;
801069d2:	8b 45 10             	mov    0x10(%ebp),%eax
801069d5:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801069d8:	8b 45 10             	mov    0x10(%ebp),%eax
801069db:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801069de:	eb 13                	jmp    801069f3 <memmove+0x48>
      *--d = *--s;
801069e0:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801069e4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801069e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069eb:	0f b6 10             	movzbl (%eax),%edx
801069ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069f1:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801069f3:	8b 45 10             	mov    0x10(%ebp),%eax
801069f6:	8d 50 ff             	lea    -0x1(%eax),%edx
801069f9:	89 55 10             	mov    %edx,0x10(%ebp)
801069fc:	85 c0                	test   %eax,%eax
801069fe:	75 e0                	jne    801069e0 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106a00:	eb 24                	jmp    80106a26 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106a02:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106a05:	8d 50 01             	lea    0x1(%eax),%edx
80106a08:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106a0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a0e:	8d 4a 01             	lea    0x1(%edx),%ecx
80106a11:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106a14:	0f b6 12             	movzbl (%edx),%edx
80106a17:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106a19:	8b 45 10             	mov    0x10(%ebp),%eax
80106a1c:	8d 50 ff             	lea    -0x1(%eax),%edx
80106a1f:	89 55 10             	mov    %edx,0x10(%ebp)
80106a22:	85 c0                	test   %eax,%eax
80106a24:	75 dc                	jne    80106a02 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106a26:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106a29:	c9                   	leave  
80106a2a:	c3                   	ret    

80106a2b <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106a2b:	55                   	push   %ebp
80106a2c:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106a2e:	ff 75 10             	pushl  0x10(%ebp)
80106a31:	ff 75 0c             	pushl  0xc(%ebp)
80106a34:	ff 75 08             	pushl  0x8(%ebp)
80106a37:	e8 6f ff ff ff       	call   801069ab <memmove>
80106a3c:	83 c4 0c             	add    $0xc,%esp
}
80106a3f:	c9                   	leave  
80106a40:	c3                   	ret    

80106a41 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106a41:	55                   	push   %ebp
80106a42:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106a44:	eb 0c                	jmp    80106a52 <strncmp+0x11>
    n--, p++, q++;
80106a46:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106a4a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106a4e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106a52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106a56:	74 1a                	je     80106a72 <strncmp+0x31>
80106a58:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5b:	0f b6 00             	movzbl (%eax),%eax
80106a5e:	84 c0                	test   %al,%al
80106a60:	74 10                	je     80106a72 <strncmp+0x31>
80106a62:	8b 45 08             	mov    0x8(%ebp),%eax
80106a65:	0f b6 10             	movzbl (%eax),%edx
80106a68:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a6b:	0f b6 00             	movzbl (%eax),%eax
80106a6e:	38 c2                	cmp    %al,%dl
80106a70:	74 d4                	je     80106a46 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106a72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106a76:	75 07                	jne    80106a7f <strncmp+0x3e>
    return 0;
80106a78:	b8 00 00 00 00       	mov    $0x0,%eax
80106a7d:	eb 16                	jmp    80106a95 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a82:	0f b6 00             	movzbl (%eax),%eax
80106a85:	0f b6 d0             	movzbl %al,%edx
80106a88:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a8b:	0f b6 00             	movzbl (%eax),%eax
80106a8e:	0f b6 c0             	movzbl %al,%eax
80106a91:	29 c2                	sub    %eax,%edx
80106a93:	89 d0                	mov    %edx,%eax
}
80106a95:	5d                   	pop    %ebp
80106a96:	c3                   	ret    

80106a97 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106a97:	55                   	push   %ebp
80106a98:	89 e5                	mov    %esp,%ebp
80106a9a:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106a9d:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106aa3:	90                   	nop
80106aa4:	8b 45 10             	mov    0x10(%ebp),%eax
80106aa7:	8d 50 ff             	lea    -0x1(%eax),%edx
80106aaa:	89 55 10             	mov    %edx,0x10(%ebp)
80106aad:	85 c0                	test   %eax,%eax
80106aaf:	7e 2c                	jle    80106add <strncpy+0x46>
80106ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab4:	8d 50 01             	lea    0x1(%eax),%edx
80106ab7:	89 55 08             	mov    %edx,0x8(%ebp)
80106aba:	8b 55 0c             	mov    0xc(%ebp),%edx
80106abd:	8d 4a 01             	lea    0x1(%edx),%ecx
80106ac0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106ac3:	0f b6 12             	movzbl (%edx),%edx
80106ac6:	88 10                	mov    %dl,(%eax)
80106ac8:	0f b6 00             	movzbl (%eax),%eax
80106acb:	84 c0                	test   %al,%al
80106acd:	75 d5                	jne    80106aa4 <strncpy+0xd>
    ;
  while(n-- > 0)
80106acf:	eb 0c                	jmp    80106add <strncpy+0x46>
    *s++ = 0;
80106ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad4:	8d 50 01             	lea    0x1(%eax),%edx
80106ad7:	89 55 08             	mov    %edx,0x8(%ebp)
80106ada:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106add:	8b 45 10             	mov    0x10(%ebp),%eax
80106ae0:	8d 50 ff             	lea    -0x1(%eax),%edx
80106ae3:	89 55 10             	mov    %edx,0x10(%ebp)
80106ae6:	85 c0                	test   %eax,%eax
80106ae8:	7f e7                	jg     80106ad1 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106aea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106aed:	c9                   	leave  
80106aee:	c3                   	ret    

80106aef <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106aef:	55                   	push   %ebp
80106af0:	89 e5                	mov    %esp,%ebp
80106af2:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106af5:	8b 45 08             	mov    0x8(%ebp),%eax
80106af8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106afb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106aff:	7f 05                	jg     80106b06 <safestrcpy+0x17>
    return os;
80106b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b04:	eb 31                	jmp    80106b37 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106b06:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106b0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106b0e:	7e 1e                	jle    80106b2e <safestrcpy+0x3f>
80106b10:	8b 45 08             	mov    0x8(%ebp),%eax
80106b13:	8d 50 01             	lea    0x1(%eax),%edx
80106b16:	89 55 08             	mov    %edx,0x8(%ebp)
80106b19:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b1c:	8d 4a 01             	lea    0x1(%edx),%ecx
80106b1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106b22:	0f b6 12             	movzbl (%edx),%edx
80106b25:	88 10                	mov    %dl,(%eax)
80106b27:	0f b6 00             	movzbl (%eax),%eax
80106b2a:	84 c0                	test   %al,%al
80106b2c:	75 d8                	jne    80106b06 <safestrcpy+0x17>
    ;
  *s = 0;
80106b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80106b31:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106b37:	c9                   	leave  
80106b38:	c3                   	ret    

80106b39 <strlen>:

int
strlen(const char *s)
{
80106b39:	55                   	push   %ebp
80106b3a:	89 e5                	mov    %esp,%ebp
80106b3c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106b3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106b46:	eb 04                	jmp    80106b4c <strlen+0x13>
80106b48:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106b4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b52:	01 d0                	add    %edx,%eax
80106b54:	0f b6 00             	movzbl (%eax),%eax
80106b57:	84 c0                	test   %al,%al
80106b59:	75 ed                	jne    80106b48 <strlen+0xf>
    ;
  return n;
80106b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106b5e:	c9                   	leave  
80106b5f:	c3                   	ret    

80106b60 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106b60:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106b64:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106b68:	55                   	push   %ebp
  pushl %ebx
80106b69:	53                   	push   %ebx
  pushl %esi
80106b6a:	56                   	push   %esi
  pushl %edi
80106b6b:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106b6c:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106b6e:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106b70:	5f                   	pop    %edi
  popl %esi
80106b71:	5e                   	pop    %esi
  popl %ebx
80106b72:	5b                   	pop    %ebx
  popl %ebp
80106b73:	5d                   	pop    %ebp
  ret
80106b74:	c3                   	ret    

80106b75 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106b75:	55                   	push   %ebp
80106b76:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106b78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b7e:	8b 00                	mov    (%eax),%eax
80106b80:	3b 45 08             	cmp    0x8(%ebp),%eax
80106b83:	76 12                	jbe    80106b97 <fetchint+0x22>
80106b85:	8b 45 08             	mov    0x8(%ebp),%eax
80106b88:	8d 50 04             	lea    0x4(%eax),%edx
80106b8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b91:	8b 00                	mov    (%eax),%eax
80106b93:	39 c2                	cmp    %eax,%edx
80106b95:	76 07                	jbe    80106b9e <fetchint+0x29>
    return -1;
80106b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b9c:	eb 0f                	jmp    80106bad <fetchint+0x38>
  *ip = *(int*)(addr);
80106b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80106ba1:	8b 10                	mov    (%eax),%edx
80106ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ba6:	89 10                	mov    %edx,(%eax)
  return 0;
80106ba8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bad:	5d                   	pop    %ebp
80106bae:	c3                   	ret    

80106baf <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106baf:	55                   	push   %ebp
80106bb0:	89 e5                	mov    %esp,%ebp
80106bb2:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106bb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bbb:	8b 00                	mov    (%eax),%eax
80106bbd:	3b 45 08             	cmp    0x8(%ebp),%eax
80106bc0:	77 07                	ja     80106bc9 <fetchstr+0x1a>
    return -1;
80106bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc7:	eb 46                	jmp    80106c0f <fetchstr+0x60>
  *pp = (char*)addr;
80106bc9:	8b 55 08             	mov    0x8(%ebp),%edx
80106bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bcf:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106bd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bd7:	8b 00                	mov    (%eax),%eax
80106bd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bdf:	8b 00                	mov    (%eax),%eax
80106be1:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106be4:	eb 1c                	jmp    80106c02 <fetchstr+0x53>
    if(*s == 0)
80106be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106be9:	0f b6 00             	movzbl (%eax),%eax
80106bec:	84 c0                	test   %al,%al
80106bee:	75 0e                	jne    80106bfe <fetchstr+0x4f>
      return s - *pp;
80106bf0:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bf6:	8b 00                	mov    (%eax),%eax
80106bf8:	29 c2                	sub    %eax,%edx
80106bfa:	89 d0                	mov    %edx,%eax
80106bfc:	eb 11                	jmp    80106c0f <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106bfe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c05:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106c08:	72 dc                	jb     80106be6 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106c0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c0f:	c9                   	leave  
80106c10:	c3                   	ret    

80106c11 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106c11:	55                   	push   %ebp
80106c12:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106c14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c1a:	8b 40 18             	mov    0x18(%eax),%eax
80106c1d:	8b 40 44             	mov    0x44(%eax),%eax
80106c20:	8b 55 08             	mov    0x8(%ebp),%edx
80106c23:	c1 e2 02             	shl    $0x2,%edx
80106c26:	01 d0                	add    %edx,%eax
80106c28:	83 c0 04             	add    $0x4,%eax
80106c2b:	ff 75 0c             	pushl  0xc(%ebp)
80106c2e:	50                   	push   %eax
80106c2f:	e8 41 ff ff ff       	call   80106b75 <fetchint>
80106c34:	83 c4 08             	add    $0x8,%esp
}
80106c37:	c9                   	leave  
80106c38:	c3                   	ret    

80106c39 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106c39:	55                   	push   %ebp
80106c3a:	89 e5                	mov    %esp,%ebp
80106c3c:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106c3f:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106c42:	50                   	push   %eax
80106c43:	ff 75 08             	pushl  0x8(%ebp)
80106c46:	e8 c6 ff ff ff       	call   80106c11 <argint>
80106c4b:	83 c4 08             	add    $0x8,%esp
80106c4e:	85 c0                	test   %eax,%eax
80106c50:	79 07                	jns    80106c59 <argptr+0x20>
    return -1;
80106c52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c57:	eb 3b                	jmp    80106c94 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106c59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c5f:	8b 00                	mov    (%eax),%eax
80106c61:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c64:	39 d0                	cmp    %edx,%eax
80106c66:	76 16                	jbe    80106c7e <argptr+0x45>
80106c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c6b:	89 c2                	mov    %eax,%edx
80106c6d:	8b 45 10             	mov    0x10(%ebp),%eax
80106c70:	01 c2                	add    %eax,%edx
80106c72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c78:	8b 00                	mov    (%eax),%eax
80106c7a:	39 c2                	cmp    %eax,%edx
80106c7c:	76 07                	jbe    80106c85 <argptr+0x4c>
    return -1;
80106c7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c83:	eb 0f                	jmp    80106c94 <argptr+0x5b>
  *pp = (char*)i;
80106c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c88:	89 c2                	mov    %eax,%edx
80106c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c8d:	89 10                	mov    %edx,(%eax)
  return 0;
80106c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c94:	c9                   	leave  
80106c95:	c3                   	ret    

80106c96 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106c96:	55                   	push   %ebp
80106c97:	89 e5                	mov    %esp,%ebp
80106c99:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106c9c:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106c9f:	50                   	push   %eax
80106ca0:	ff 75 08             	pushl  0x8(%ebp)
80106ca3:	e8 69 ff ff ff       	call   80106c11 <argint>
80106ca8:	83 c4 08             	add    $0x8,%esp
80106cab:	85 c0                	test   %eax,%eax
80106cad:	79 07                	jns    80106cb6 <argstr+0x20>
    return -1;
80106caf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cb4:	eb 0f                	jmp    80106cc5 <argstr+0x2f>
  return fetchstr(addr, pp);
80106cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106cb9:	ff 75 0c             	pushl  0xc(%ebp)
80106cbc:	50                   	push   %eax
80106cbd:	e8 ed fe ff ff       	call   80106baf <fetchstr>
80106cc2:	83 c4 08             	add    $0x8,%esp
}
80106cc5:	c9                   	leave  
80106cc6:	c3                   	ret    

80106cc7 <syscall>:
};
#endif

void
syscall(void)
{
80106cc7:	55                   	push   %ebp
80106cc8:	89 e5                	mov    %esp,%ebp
80106cca:	53                   	push   %ebx
80106ccb:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106cce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cd4:	8b 40 18             	mov    0x18(%eax),%eax
80106cd7:	8b 40 1c             	mov    0x1c(%eax),%eax
80106cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ce1:	7e 30                	jle    80106d13 <syscall+0x4c>
80106ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ce6:	83 f8 21             	cmp    $0x21,%eax
80106ce9:	77 28                	ja     80106d13 <syscall+0x4c>
80106ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cee:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106cf5:	85 c0                	test   %eax,%eax
80106cf7:	74 1a                	je     80106d13 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106cf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cff:	8b 58 18             	mov    0x18(%eax),%ebx
80106d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d05:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106d0c:	ff d0                	call   *%eax
80106d0e:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106d11:	eb 34                	jmp    80106d47 <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106d13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d19:	8d 50 6c             	lea    0x6c(%eax),%edx
80106d1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106d22:	8b 40 10             	mov    0x10(%eax),%eax
80106d25:	ff 75 f4             	pushl  -0xc(%ebp)
80106d28:	52                   	push   %edx
80106d29:	50                   	push   %eax
80106d2a:	68 ef a7 10 80       	push   $0x8010a7ef
80106d2f:	e8 92 96 ff ff       	call   801003c6 <cprintf>
80106d34:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106d37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d3d:	8b 40 18             	mov    0x18(%eax),%eax
80106d40:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106d47:	90                   	nop
80106d48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106d4b:	c9                   	leave  
80106d4c:	c3                   	ret    

80106d4d <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106d4d:	55                   	push   %ebp
80106d4e:	89 e5                	mov    %esp,%ebp
80106d50:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106d53:	83 ec 08             	sub    $0x8,%esp
80106d56:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d59:	50                   	push   %eax
80106d5a:	ff 75 08             	pushl  0x8(%ebp)
80106d5d:	e8 af fe ff ff       	call   80106c11 <argint>
80106d62:	83 c4 10             	add    $0x10,%esp
80106d65:	85 c0                	test   %eax,%eax
80106d67:	79 07                	jns    80106d70 <argfd+0x23>
    return -1;
80106d69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d6e:	eb 50                	jmp    80106dc0 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d73:	85 c0                	test   %eax,%eax
80106d75:	78 21                	js     80106d98 <argfd+0x4b>
80106d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d7a:	83 f8 0f             	cmp    $0xf,%eax
80106d7d:	7f 19                	jg     80106d98 <argfd+0x4b>
80106d7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d85:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d88:	83 c2 08             	add    $0x8,%edx
80106d8b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106d96:	75 07                	jne    80106d9f <argfd+0x52>
    return -1;
80106d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d9d:	eb 21                	jmp    80106dc0 <argfd+0x73>
  if(pfd)
80106d9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106da3:	74 08                	je     80106dad <argfd+0x60>
    *pfd = fd;
80106da5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106da8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dab:	89 10                	mov    %edx,(%eax)
  if(pf)
80106dad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106db1:	74 08                	je     80106dbb <argfd+0x6e>
    *pf = f;
80106db3:	8b 45 10             	mov    0x10(%ebp),%eax
80106db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106db9:	89 10                	mov    %edx,(%eax)
  return 0;
80106dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106dc0:	c9                   	leave  
80106dc1:	c3                   	ret    

80106dc2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106dc2:	55                   	push   %ebp
80106dc3:	89 e5                	mov    %esp,%ebp
80106dc5:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106dc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106dcf:	eb 30                	jmp    80106e01 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106dd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106dda:	83 c2 08             	add    $0x8,%edx
80106ddd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106de1:	85 c0                	test   %eax,%eax
80106de3:	75 18                	jne    80106dfd <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106de5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106deb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106dee:	8d 4a 08             	lea    0x8(%edx),%ecx
80106df1:	8b 55 08             	mov    0x8(%ebp),%edx
80106df4:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dfb:	eb 0f                	jmp    80106e0c <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106dfd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106e01:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106e05:	7e ca                	jle    80106dd1 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e0c:	c9                   	leave  
80106e0d:	c3                   	ret    

80106e0e <sys_dup>:

int
sys_dup(void)
{
80106e0e:	55                   	push   %ebp
80106e0f:	89 e5                	mov    %esp,%ebp
80106e11:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106e14:	83 ec 04             	sub    $0x4,%esp
80106e17:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e1a:	50                   	push   %eax
80106e1b:	6a 00                	push   $0x0
80106e1d:	6a 00                	push   $0x0
80106e1f:	e8 29 ff ff ff       	call   80106d4d <argfd>
80106e24:	83 c4 10             	add    $0x10,%esp
80106e27:	85 c0                	test   %eax,%eax
80106e29:	79 07                	jns    80106e32 <sys_dup+0x24>
    return -1;
80106e2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e30:	eb 31                	jmp    80106e63 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e35:	83 ec 0c             	sub    $0xc,%esp
80106e38:	50                   	push   %eax
80106e39:	e8 84 ff ff ff       	call   80106dc2 <fdalloc>
80106e3e:	83 c4 10             	add    $0x10,%esp
80106e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e48:	79 07                	jns    80106e51 <sys_dup+0x43>
    return -1;
80106e4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e4f:	eb 12                	jmp    80106e63 <sys_dup+0x55>
  filedup(f);
80106e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e54:	83 ec 0c             	sub    $0xc,%esp
80106e57:	50                   	push   %eax
80106e58:	e8 f3 a2 ff ff       	call   80101150 <filedup>
80106e5d:	83 c4 10             	add    $0x10,%esp
  return fd;
80106e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106e63:	c9                   	leave  
80106e64:	c3                   	ret    

80106e65 <sys_read>:

int
sys_read(void)
{
80106e65:	55                   	push   %ebp
80106e66:	89 e5                	mov    %esp,%ebp
80106e68:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106e6b:	83 ec 04             	sub    $0x4,%esp
80106e6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e71:	50                   	push   %eax
80106e72:	6a 00                	push   $0x0
80106e74:	6a 00                	push   $0x0
80106e76:	e8 d2 fe ff ff       	call   80106d4d <argfd>
80106e7b:	83 c4 10             	add    $0x10,%esp
80106e7e:	85 c0                	test   %eax,%eax
80106e80:	78 2e                	js     80106eb0 <sys_read+0x4b>
80106e82:	83 ec 08             	sub    $0x8,%esp
80106e85:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e88:	50                   	push   %eax
80106e89:	6a 02                	push   $0x2
80106e8b:	e8 81 fd ff ff       	call   80106c11 <argint>
80106e90:	83 c4 10             	add    $0x10,%esp
80106e93:	85 c0                	test   %eax,%eax
80106e95:	78 19                	js     80106eb0 <sys_read+0x4b>
80106e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e9a:	83 ec 04             	sub    $0x4,%esp
80106e9d:	50                   	push   %eax
80106e9e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ea1:	50                   	push   %eax
80106ea2:	6a 01                	push   $0x1
80106ea4:	e8 90 fd ff ff       	call   80106c39 <argptr>
80106ea9:	83 c4 10             	add    $0x10,%esp
80106eac:	85 c0                	test   %eax,%eax
80106eae:	79 07                	jns    80106eb7 <sys_read+0x52>
    return -1;
80106eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eb5:	eb 17                	jmp    80106ece <sys_read+0x69>
  return fileread(f, p, n);
80106eb7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106eba:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ec0:	83 ec 04             	sub    $0x4,%esp
80106ec3:	51                   	push   %ecx
80106ec4:	52                   	push   %edx
80106ec5:	50                   	push   %eax
80106ec6:	e8 15 a4 ff ff       	call   801012e0 <fileread>
80106ecb:	83 c4 10             	add    $0x10,%esp
}
80106ece:	c9                   	leave  
80106ecf:	c3                   	ret    

80106ed0 <sys_write>:

int
sys_write(void)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106ed6:	83 ec 04             	sub    $0x4,%esp
80106ed9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106edc:	50                   	push   %eax
80106edd:	6a 00                	push   $0x0
80106edf:	6a 00                	push   $0x0
80106ee1:	e8 67 fe ff ff       	call   80106d4d <argfd>
80106ee6:	83 c4 10             	add    $0x10,%esp
80106ee9:	85 c0                	test   %eax,%eax
80106eeb:	78 2e                	js     80106f1b <sys_write+0x4b>
80106eed:	83 ec 08             	sub    $0x8,%esp
80106ef0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ef3:	50                   	push   %eax
80106ef4:	6a 02                	push   $0x2
80106ef6:	e8 16 fd ff ff       	call   80106c11 <argint>
80106efb:	83 c4 10             	add    $0x10,%esp
80106efe:	85 c0                	test   %eax,%eax
80106f00:	78 19                	js     80106f1b <sys_write+0x4b>
80106f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f05:	83 ec 04             	sub    $0x4,%esp
80106f08:	50                   	push   %eax
80106f09:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106f0c:	50                   	push   %eax
80106f0d:	6a 01                	push   $0x1
80106f0f:	e8 25 fd ff ff       	call   80106c39 <argptr>
80106f14:	83 c4 10             	add    $0x10,%esp
80106f17:	85 c0                	test   %eax,%eax
80106f19:	79 07                	jns    80106f22 <sys_write+0x52>
    return -1;
80106f1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f20:	eb 17                	jmp    80106f39 <sys_write+0x69>
  return filewrite(f, p, n);
80106f22:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106f25:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f2b:	83 ec 04             	sub    $0x4,%esp
80106f2e:	51                   	push   %ecx
80106f2f:	52                   	push   %edx
80106f30:	50                   	push   %eax
80106f31:	e8 62 a4 ff ff       	call   80101398 <filewrite>
80106f36:	83 c4 10             	add    $0x10,%esp
}
80106f39:	c9                   	leave  
80106f3a:	c3                   	ret    

80106f3b <sys_close>:

int
sys_close(void)
{
80106f3b:	55                   	push   %ebp
80106f3c:	89 e5                	mov    %esp,%ebp
80106f3e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106f41:	83 ec 04             	sub    $0x4,%esp
80106f44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f47:	50                   	push   %eax
80106f48:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f4b:	50                   	push   %eax
80106f4c:	6a 00                	push   $0x0
80106f4e:	e8 fa fd ff ff       	call   80106d4d <argfd>
80106f53:	83 c4 10             	add    $0x10,%esp
80106f56:	85 c0                	test   %eax,%eax
80106f58:	79 07                	jns    80106f61 <sys_close+0x26>
    return -1;
80106f5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f5f:	eb 28                	jmp    80106f89 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106f61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f6a:	83 c2 08             	add    $0x8,%edx
80106f6d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106f74:	00 
  fileclose(f);
80106f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f78:	83 ec 0c             	sub    $0xc,%esp
80106f7b:	50                   	push   %eax
80106f7c:	e8 20 a2 ff ff       	call   801011a1 <fileclose>
80106f81:	83 c4 10             	add    $0x10,%esp
  return 0;
80106f84:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106f89:	c9                   	leave  
80106f8a:	c3                   	ret    

80106f8b <sys_fstat>:

int
sys_fstat(void)
{
80106f8b:	55                   	push   %ebp
80106f8c:	89 e5                	mov    %esp,%ebp
80106f8e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106f91:	83 ec 04             	sub    $0x4,%esp
80106f94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f97:	50                   	push   %eax
80106f98:	6a 00                	push   $0x0
80106f9a:	6a 00                	push   $0x0
80106f9c:	e8 ac fd ff ff       	call   80106d4d <argfd>
80106fa1:	83 c4 10             	add    $0x10,%esp
80106fa4:	85 c0                	test   %eax,%eax
80106fa6:	78 17                	js     80106fbf <sys_fstat+0x34>
80106fa8:	83 ec 04             	sub    $0x4,%esp
80106fab:	6a 1c                	push   $0x1c
80106fad:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fb0:	50                   	push   %eax
80106fb1:	6a 01                	push   $0x1
80106fb3:	e8 81 fc ff ff       	call   80106c39 <argptr>
80106fb8:	83 c4 10             	add    $0x10,%esp
80106fbb:	85 c0                	test   %eax,%eax
80106fbd:	79 07                	jns    80106fc6 <sys_fstat+0x3b>
    return -1;
80106fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fc4:	eb 13                	jmp    80106fd9 <sys_fstat+0x4e>
  return filestat(f, st);
80106fc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fcc:	83 ec 08             	sub    $0x8,%esp
80106fcf:	52                   	push   %edx
80106fd0:	50                   	push   %eax
80106fd1:	e8 b3 a2 ff ff       	call   80101289 <filestat>
80106fd6:	83 c4 10             	add    $0x10,%esp
}
80106fd9:	c9                   	leave  
80106fda:	c3                   	ret    

80106fdb <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106fdb:	55                   	push   %ebp
80106fdc:	89 e5                	mov    %esp,%ebp
80106fde:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106fe1:	83 ec 08             	sub    $0x8,%esp
80106fe4:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106fe7:	50                   	push   %eax
80106fe8:	6a 00                	push   $0x0
80106fea:	e8 a7 fc ff ff       	call   80106c96 <argstr>
80106fef:	83 c4 10             	add    $0x10,%esp
80106ff2:	85 c0                	test   %eax,%eax
80106ff4:	78 15                	js     8010700b <sys_link+0x30>
80106ff6:	83 ec 08             	sub    $0x8,%esp
80106ff9:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106ffc:	50                   	push   %eax
80106ffd:	6a 01                	push   $0x1
80106fff:	e8 92 fc ff ff       	call   80106c96 <argstr>
80107004:	83 c4 10             	add    $0x10,%esp
80107007:	85 c0                	test   %eax,%eax
80107009:	79 0a                	jns    80107015 <sys_link+0x3a>
    return -1;
8010700b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107010:	e9 68 01 00 00       	jmp    8010717d <sys_link+0x1a2>

  begin_op();
80107015:	e8 3a c7 ff ff       	call   80103754 <begin_op>
  if((ip = namei(old)) == 0){
8010701a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010701d:	83 ec 0c             	sub    $0xc,%esp
80107020:	50                   	push   %eax
80107021:	e8 09 b7 ff ff       	call   8010272f <namei>
80107026:	83 c4 10             	add    $0x10,%esp
80107029:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010702c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107030:	75 0f                	jne    80107041 <sys_link+0x66>
    end_op();
80107032:	e8 a9 c7 ff ff       	call   801037e0 <end_op>
    return -1;
80107037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010703c:	e9 3c 01 00 00       	jmp    8010717d <sys_link+0x1a2>
  }

  ilock(ip);
80107041:	83 ec 0c             	sub    $0xc,%esp
80107044:	ff 75 f4             	pushl  -0xc(%ebp)
80107047:	e8 d5 aa ff ff       	call   80101b21 <ilock>
8010704c:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010704f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107052:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107056:	66 83 f8 01          	cmp    $0x1,%ax
8010705a:	75 1d                	jne    80107079 <sys_link+0x9e>
    iunlockput(ip);
8010705c:	83 ec 0c             	sub    $0xc,%esp
8010705f:	ff 75 f4             	pushl  -0xc(%ebp)
80107062:	e8 a2 ad ff ff       	call   80101e09 <iunlockput>
80107067:	83 c4 10             	add    $0x10,%esp
    end_op();
8010706a:	e8 71 c7 ff ff       	call   801037e0 <end_op>
    return -1;
8010706f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107074:	e9 04 01 00 00       	jmp    8010717d <sys_link+0x1a2>
  }

  ip->nlink++;
80107079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010707c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107080:	83 c0 01             	add    $0x1,%eax
80107083:	89 c2                	mov    %eax,%edx
80107085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107088:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010708c:	83 ec 0c             	sub    $0xc,%esp
8010708f:	ff 75 f4             	pushl  -0xc(%ebp)
80107092:	e8 49 a8 ff ff       	call   801018e0 <iupdate>
80107097:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
8010709a:	83 ec 0c             	sub    $0xc,%esp
8010709d:	ff 75 f4             	pushl  -0xc(%ebp)
801070a0:	e8 02 ac ff ff       	call   80101ca7 <iunlock>
801070a5:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801070a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801070ab:	83 ec 08             	sub    $0x8,%esp
801070ae:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801070b1:	52                   	push   %edx
801070b2:	50                   	push   %eax
801070b3:	e8 93 b6 ff ff       	call   8010274b <nameiparent>
801070b8:	83 c4 10             	add    $0x10,%esp
801070bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801070be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801070c2:	74 71                	je     80107135 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801070c4:	83 ec 0c             	sub    $0xc,%esp
801070c7:	ff 75 f0             	pushl  -0x10(%ebp)
801070ca:	e8 52 aa ff ff       	call   80101b21 <ilock>
801070cf:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801070d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070d5:	8b 10                	mov    (%eax),%edx
801070d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070da:	8b 00                	mov    (%eax),%eax
801070dc:	39 c2                	cmp    %eax,%edx
801070de:	75 1d                	jne    801070fd <sys_link+0x122>
801070e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070e3:	8b 40 04             	mov    0x4(%eax),%eax
801070e6:	83 ec 04             	sub    $0x4,%esp
801070e9:	50                   	push   %eax
801070ea:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801070ed:	50                   	push   %eax
801070ee:	ff 75 f0             	pushl  -0x10(%ebp)
801070f1:	e8 9d b3 ff ff       	call   80102493 <dirlink>
801070f6:	83 c4 10             	add    $0x10,%esp
801070f9:	85 c0                	test   %eax,%eax
801070fb:	79 10                	jns    8010710d <sys_link+0x132>
    iunlockput(dp);
801070fd:	83 ec 0c             	sub    $0xc,%esp
80107100:	ff 75 f0             	pushl  -0x10(%ebp)
80107103:	e8 01 ad ff ff       	call   80101e09 <iunlockput>
80107108:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010710b:	eb 29                	jmp    80107136 <sys_link+0x15b>
  }
  iunlockput(dp);
8010710d:	83 ec 0c             	sub    $0xc,%esp
80107110:	ff 75 f0             	pushl  -0x10(%ebp)
80107113:	e8 f1 ac ff ff       	call   80101e09 <iunlockput>
80107118:	83 c4 10             	add    $0x10,%esp
  iput(ip);
8010711b:	83 ec 0c             	sub    $0xc,%esp
8010711e:	ff 75 f4             	pushl  -0xc(%ebp)
80107121:	e8 f3 ab ff ff       	call   80101d19 <iput>
80107126:	83 c4 10             	add    $0x10,%esp

  end_op();
80107129:	e8 b2 c6 ff ff       	call   801037e0 <end_op>

  return 0;
8010712e:	b8 00 00 00 00       	mov    $0x0,%eax
80107133:	eb 48                	jmp    8010717d <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80107135:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80107136:	83 ec 0c             	sub    $0xc,%esp
80107139:	ff 75 f4             	pushl  -0xc(%ebp)
8010713c:	e8 e0 a9 ff ff       	call   80101b21 <ilock>
80107141:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80107144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107147:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010714b:	83 e8 01             	sub    $0x1,%eax
8010714e:	89 c2                	mov    %eax,%edx
80107150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107153:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107157:	83 ec 0c             	sub    $0xc,%esp
8010715a:	ff 75 f4             	pushl  -0xc(%ebp)
8010715d:	e8 7e a7 ff ff       	call   801018e0 <iupdate>
80107162:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107165:	83 ec 0c             	sub    $0xc,%esp
80107168:	ff 75 f4             	pushl  -0xc(%ebp)
8010716b:	e8 99 ac ff ff       	call   80101e09 <iunlockput>
80107170:	83 c4 10             	add    $0x10,%esp
  end_op();
80107173:	e8 68 c6 ff ff       	call   801037e0 <end_op>
  return -1;
80107178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010717d:	c9                   	leave  
8010717e:	c3                   	ret    

8010717f <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010717f:	55                   	push   %ebp
80107180:	89 e5                	mov    %esp,%ebp
80107182:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107185:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010718c:	eb 40                	jmp    801071ce <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010718e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107191:	6a 10                	push   $0x10
80107193:	50                   	push   %eax
80107194:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107197:	50                   	push   %eax
80107198:	ff 75 08             	pushl  0x8(%ebp)
8010719b:	e8 3f af ff ff       	call   801020df <readi>
801071a0:	83 c4 10             	add    $0x10,%esp
801071a3:	83 f8 10             	cmp    $0x10,%eax
801071a6:	74 0d                	je     801071b5 <isdirempty+0x36>
      panic("isdirempty: readi");
801071a8:	83 ec 0c             	sub    $0xc,%esp
801071ab:	68 0b a8 10 80       	push   $0x8010a80b
801071b0:	e8 b1 93 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
801071b5:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801071b9:	66 85 c0             	test   %ax,%ax
801071bc:	74 07                	je     801071c5 <isdirempty+0x46>
      return 0;
801071be:	b8 00 00 00 00       	mov    $0x0,%eax
801071c3:	eb 1b                	jmp    801071e0 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801071c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c8:	83 c0 10             	add    $0x10,%eax
801071cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801071ce:	8b 45 08             	mov    0x8(%ebp),%eax
801071d1:	8b 50 18             	mov    0x18(%eax),%edx
801071d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d7:	39 c2                	cmp    %eax,%edx
801071d9:	77 b3                	ja     8010718e <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801071db:	b8 01 00 00 00       	mov    $0x1,%eax
}
801071e0:	c9                   	leave  
801071e1:	c3                   	ret    

801071e2 <sys_unlink>:

int
sys_unlink(void)
{
801071e2:	55                   	push   %ebp
801071e3:	89 e5                	mov    %esp,%ebp
801071e5:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801071e8:	83 ec 08             	sub    $0x8,%esp
801071eb:	8d 45 cc             	lea    -0x34(%ebp),%eax
801071ee:	50                   	push   %eax
801071ef:	6a 00                	push   $0x0
801071f1:	e8 a0 fa ff ff       	call   80106c96 <argstr>
801071f6:	83 c4 10             	add    $0x10,%esp
801071f9:	85 c0                	test   %eax,%eax
801071fb:	79 0a                	jns    80107207 <sys_unlink+0x25>
    return -1;
801071fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107202:	e9 bc 01 00 00       	jmp    801073c3 <sys_unlink+0x1e1>

  begin_op();
80107207:	e8 48 c5 ff ff       	call   80103754 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010720c:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010720f:	83 ec 08             	sub    $0x8,%esp
80107212:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80107215:	52                   	push   %edx
80107216:	50                   	push   %eax
80107217:	e8 2f b5 ff ff       	call   8010274b <nameiparent>
8010721c:	83 c4 10             	add    $0x10,%esp
8010721f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107226:	75 0f                	jne    80107237 <sys_unlink+0x55>
    end_op();
80107228:	e8 b3 c5 ff ff       	call   801037e0 <end_op>
    return -1;
8010722d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107232:	e9 8c 01 00 00       	jmp    801073c3 <sys_unlink+0x1e1>
  }

  ilock(dp);
80107237:	83 ec 0c             	sub    $0xc,%esp
8010723a:	ff 75 f4             	pushl  -0xc(%ebp)
8010723d:	e8 df a8 ff ff       	call   80101b21 <ilock>
80107242:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80107245:	83 ec 08             	sub    $0x8,%esp
80107248:	68 1d a8 10 80       	push   $0x8010a81d
8010724d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107250:	50                   	push   %eax
80107251:	e8 68 b1 ff ff       	call   801023be <namecmp>
80107256:	83 c4 10             	add    $0x10,%esp
80107259:	85 c0                	test   %eax,%eax
8010725b:	0f 84 4a 01 00 00    	je     801073ab <sys_unlink+0x1c9>
80107261:	83 ec 08             	sub    $0x8,%esp
80107264:	68 1f a8 10 80       	push   $0x8010a81f
80107269:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010726c:	50                   	push   %eax
8010726d:	e8 4c b1 ff ff       	call   801023be <namecmp>
80107272:	83 c4 10             	add    $0x10,%esp
80107275:	85 c0                	test   %eax,%eax
80107277:	0f 84 2e 01 00 00    	je     801073ab <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010727d:	83 ec 04             	sub    $0x4,%esp
80107280:	8d 45 c8             	lea    -0x38(%ebp),%eax
80107283:	50                   	push   %eax
80107284:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107287:	50                   	push   %eax
80107288:	ff 75 f4             	pushl  -0xc(%ebp)
8010728b:	e8 49 b1 ff ff       	call   801023d9 <dirlookup>
80107290:	83 c4 10             	add    $0x10,%esp
80107293:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107296:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010729a:	0f 84 0a 01 00 00    	je     801073aa <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
801072a0:	83 ec 0c             	sub    $0xc,%esp
801072a3:	ff 75 f0             	pushl  -0x10(%ebp)
801072a6:	e8 76 a8 ff ff       	call   80101b21 <ilock>
801072ab:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801072ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072b1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801072b5:	66 85 c0             	test   %ax,%ax
801072b8:	7f 0d                	jg     801072c7 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801072ba:	83 ec 0c             	sub    $0xc,%esp
801072bd:	68 22 a8 10 80       	push   $0x8010a822
801072c2:	e8 9f 92 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801072c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072ca:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801072ce:	66 83 f8 01          	cmp    $0x1,%ax
801072d2:	75 25                	jne    801072f9 <sys_unlink+0x117>
801072d4:	83 ec 0c             	sub    $0xc,%esp
801072d7:	ff 75 f0             	pushl  -0x10(%ebp)
801072da:	e8 a0 fe ff ff       	call   8010717f <isdirempty>
801072df:	83 c4 10             	add    $0x10,%esp
801072e2:	85 c0                	test   %eax,%eax
801072e4:	75 13                	jne    801072f9 <sys_unlink+0x117>
    iunlockput(ip);
801072e6:	83 ec 0c             	sub    $0xc,%esp
801072e9:	ff 75 f0             	pushl  -0x10(%ebp)
801072ec:	e8 18 ab ff ff       	call   80101e09 <iunlockput>
801072f1:	83 c4 10             	add    $0x10,%esp
    goto bad;
801072f4:	e9 b2 00 00 00       	jmp    801073ab <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801072f9:	83 ec 04             	sub    $0x4,%esp
801072fc:	6a 10                	push   $0x10
801072fe:	6a 00                	push   $0x0
80107300:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107303:	50                   	push   %eax
80107304:	e8 e3 f5 ff ff       	call   801068ec <memset>
80107309:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010730c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010730f:	6a 10                	push   $0x10
80107311:	50                   	push   %eax
80107312:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107315:	50                   	push   %eax
80107316:	ff 75 f4             	pushl  -0xc(%ebp)
80107319:	e8 18 af ff ff       	call   80102236 <writei>
8010731e:	83 c4 10             	add    $0x10,%esp
80107321:	83 f8 10             	cmp    $0x10,%eax
80107324:	74 0d                	je     80107333 <sys_unlink+0x151>
    panic("unlink: writei");
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	68 34 a8 10 80       	push   $0x8010a834
8010732e:	e8 33 92 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80107333:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107336:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010733a:	66 83 f8 01          	cmp    $0x1,%ax
8010733e:	75 21                	jne    80107361 <sys_unlink+0x17f>
    dp->nlink--;
80107340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107343:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107347:	83 e8 01             	sub    $0x1,%eax
8010734a:	89 c2                	mov    %eax,%edx
8010734c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010734f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107353:	83 ec 0c             	sub    $0xc,%esp
80107356:	ff 75 f4             	pushl  -0xc(%ebp)
80107359:	e8 82 a5 ff ff       	call   801018e0 <iupdate>
8010735e:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80107361:	83 ec 0c             	sub    $0xc,%esp
80107364:	ff 75 f4             	pushl  -0xc(%ebp)
80107367:	e8 9d aa ff ff       	call   80101e09 <iunlockput>
8010736c:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010736f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107372:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107376:	83 e8 01             	sub    $0x1,%eax
80107379:	89 c2                	mov    %eax,%edx
8010737b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010737e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107382:	83 ec 0c             	sub    $0xc,%esp
80107385:	ff 75 f0             	pushl  -0x10(%ebp)
80107388:	e8 53 a5 ff ff       	call   801018e0 <iupdate>
8010738d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107390:	83 ec 0c             	sub    $0xc,%esp
80107393:	ff 75 f0             	pushl  -0x10(%ebp)
80107396:	e8 6e aa ff ff       	call   80101e09 <iunlockput>
8010739b:	83 c4 10             	add    $0x10,%esp

  end_op();
8010739e:	e8 3d c4 ff ff       	call   801037e0 <end_op>

  return 0;
801073a3:	b8 00 00 00 00       	mov    $0x0,%eax
801073a8:	eb 19                	jmp    801073c3 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801073aa:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
801073ab:	83 ec 0c             	sub    $0xc,%esp
801073ae:	ff 75 f4             	pushl  -0xc(%ebp)
801073b1:	e8 53 aa ff ff       	call   80101e09 <iunlockput>
801073b6:	83 c4 10             	add    $0x10,%esp
  end_op();
801073b9:	e8 22 c4 ff ff       	call   801037e0 <end_op>
  return -1;
801073be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073c3:	c9                   	leave  
801073c4:	c3                   	ret    

801073c5 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801073c5:	55                   	push   %ebp
801073c6:	89 e5                	mov    %esp,%ebp
801073c8:	83 ec 38             	sub    $0x38,%esp
801073cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073ce:	8b 55 10             	mov    0x10(%ebp),%edx
801073d1:	8b 45 14             	mov    0x14(%ebp),%eax
801073d4:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801073d8:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801073dc:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801073e0:	83 ec 08             	sub    $0x8,%esp
801073e3:	8d 45 de             	lea    -0x22(%ebp),%eax
801073e6:	50                   	push   %eax
801073e7:	ff 75 08             	pushl  0x8(%ebp)
801073ea:	e8 5c b3 ff ff       	call   8010274b <nameiparent>
801073ef:	83 c4 10             	add    $0x10,%esp
801073f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073f9:	75 0a                	jne    80107405 <create+0x40>
    return 0;
801073fb:	b8 00 00 00 00       	mov    $0x0,%eax
80107400:	e9 90 01 00 00       	jmp    80107595 <create+0x1d0>
  ilock(dp);
80107405:	83 ec 0c             	sub    $0xc,%esp
80107408:	ff 75 f4             	pushl  -0xc(%ebp)
8010740b:	e8 11 a7 ff ff       	call   80101b21 <ilock>
80107410:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80107413:	83 ec 04             	sub    $0x4,%esp
80107416:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107419:	50                   	push   %eax
8010741a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010741d:	50                   	push   %eax
8010741e:	ff 75 f4             	pushl  -0xc(%ebp)
80107421:	e8 b3 af ff ff       	call   801023d9 <dirlookup>
80107426:	83 c4 10             	add    $0x10,%esp
80107429:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010742c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107430:	74 50                	je     80107482 <create+0xbd>
    iunlockput(dp);
80107432:	83 ec 0c             	sub    $0xc,%esp
80107435:	ff 75 f4             	pushl  -0xc(%ebp)
80107438:	e8 cc a9 ff ff       	call   80101e09 <iunlockput>
8010743d:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80107440:	83 ec 0c             	sub    $0xc,%esp
80107443:	ff 75 f0             	pushl  -0x10(%ebp)
80107446:	e8 d6 a6 ff ff       	call   80101b21 <ilock>
8010744b:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010744e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80107453:	75 15                	jne    8010746a <create+0xa5>
80107455:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107458:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010745c:	66 83 f8 02          	cmp    $0x2,%ax
80107460:	75 08                	jne    8010746a <create+0xa5>
      return ip;
80107462:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107465:	e9 2b 01 00 00       	jmp    80107595 <create+0x1d0>
    iunlockput(ip);
8010746a:	83 ec 0c             	sub    $0xc,%esp
8010746d:	ff 75 f0             	pushl  -0x10(%ebp)
80107470:	e8 94 a9 ff ff       	call   80101e09 <iunlockput>
80107475:	83 c4 10             	add    $0x10,%esp
    return 0;
80107478:	b8 00 00 00 00       	mov    $0x0,%eax
8010747d:	e9 13 01 00 00       	jmp    80107595 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107482:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80107486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107489:	8b 00                	mov    (%eax),%eax
8010748b:	83 ec 08             	sub    $0x8,%esp
8010748e:	52                   	push   %edx
8010748f:	50                   	push   %eax
80107490:	e8 74 a3 ff ff       	call   80101809 <ialloc>
80107495:	83 c4 10             	add    $0x10,%esp
80107498:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010749b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010749f:	75 0d                	jne    801074ae <create+0xe9>
    panic("create: ialloc");
801074a1:	83 ec 0c             	sub    $0xc,%esp
801074a4:	68 43 a8 10 80       	push   $0x8010a843
801074a9:	e8 b8 90 ff ff       	call   80100566 <panic>

  ilock(ip);
801074ae:	83 ec 0c             	sub    $0xc,%esp
801074b1:	ff 75 f0             	pushl  -0x10(%ebp)
801074b4:	e8 68 a6 ff ff       	call   80101b21 <ilock>
801074b9:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801074bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074bf:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801074c3:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801074c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074ca:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801074ce:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801074d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074d5:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801074db:	83 ec 0c             	sub    $0xc,%esp
801074de:	ff 75 f0             	pushl  -0x10(%ebp)
801074e1:	e8 fa a3 ff ff       	call   801018e0 <iupdate>
801074e6:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801074e9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801074ee:	75 6a                	jne    8010755a <create+0x195>
    dp->nlink++;  // for ".."
801074f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801074f7:	83 c0 01             	add    $0x1,%eax
801074fa:	89 c2                	mov    %eax,%edx
801074fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ff:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107503:	83 ec 0c             	sub    $0xc,%esp
80107506:	ff 75 f4             	pushl  -0xc(%ebp)
80107509:	e8 d2 a3 ff ff       	call   801018e0 <iupdate>
8010750e:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107511:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107514:	8b 40 04             	mov    0x4(%eax),%eax
80107517:	83 ec 04             	sub    $0x4,%esp
8010751a:	50                   	push   %eax
8010751b:	68 1d a8 10 80       	push   $0x8010a81d
80107520:	ff 75 f0             	pushl  -0x10(%ebp)
80107523:	e8 6b af ff ff       	call   80102493 <dirlink>
80107528:	83 c4 10             	add    $0x10,%esp
8010752b:	85 c0                	test   %eax,%eax
8010752d:	78 1e                	js     8010754d <create+0x188>
8010752f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107532:	8b 40 04             	mov    0x4(%eax),%eax
80107535:	83 ec 04             	sub    $0x4,%esp
80107538:	50                   	push   %eax
80107539:	68 1f a8 10 80       	push   $0x8010a81f
8010753e:	ff 75 f0             	pushl  -0x10(%ebp)
80107541:	e8 4d af ff ff       	call   80102493 <dirlink>
80107546:	83 c4 10             	add    $0x10,%esp
80107549:	85 c0                	test   %eax,%eax
8010754b:	79 0d                	jns    8010755a <create+0x195>
      panic("create dots");
8010754d:	83 ec 0c             	sub    $0xc,%esp
80107550:	68 52 a8 10 80       	push   $0x8010a852
80107555:	e8 0c 90 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010755a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010755d:	8b 40 04             	mov    0x4(%eax),%eax
80107560:	83 ec 04             	sub    $0x4,%esp
80107563:	50                   	push   %eax
80107564:	8d 45 de             	lea    -0x22(%ebp),%eax
80107567:	50                   	push   %eax
80107568:	ff 75 f4             	pushl  -0xc(%ebp)
8010756b:	e8 23 af ff ff       	call   80102493 <dirlink>
80107570:	83 c4 10             	add    $0x10,%esp
80107573:	85 c0                	test   %eax,%eax
80107575:	79 0d                	jns    80107584 <create+0x1bf>
    panic("create: dirlink");
80107577:	83 ec 0c             	sub    $0xc,%esp
8010757a:	68 5e a8 10 80       	push   $0x8010a85e
8010757f:	e8 e2 8f ff ff       	call   80100566 <panic>

  iunlockput(dp);
80107584:	83 ec 0c             	sub    $0xc,%esp
80107587:	ff 75 f4             	pushl  -0xc(%ebp)
8010758a:	e8 7a a8 ff ff       	call   80101e09 <iunlockput>
8010758f:	83 c4 10             	add    $0x10,%esp

  return ip;
80107592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107595:	c9                   	leave  
80107596:	c3                   	ret    

80107597 <sys_open>:

int
sys_open(void)
{
80107597:	55                   	push   %ebp
80107598:	89 e5                	mov    %esp,%ebp
8010759a:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010759d:	83 ec 08             	sub    $0x8,%esp
801075a0:	8d 45 e8             	lea    -0x18(%ebp),%eax
801075a3:	50                   	push   %eax
801075a4:	6a 00                	push   $0x0
801075a6:	e8 eb f6 ff ff       	call   80106c96 <argstr>
801075ab:	83 c4 10             	add    $0x10,%esp
801075ae:	85 c0                	test   %eax,%eax
801075b0:	78 15                	js     801075c7 <sys_open+0x30>
801075b2:	83 ec 08             	sub    $0x8,%esp
801075b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801075b8:	50                   	push   %eax
801075b9:	6a 01                	push   $0x1
801075bb:	e8 51 f6 ff ff       	call   80106c11 <argint>
801075c0:	83 c4 10             	add    $0x10,%esp
801075c3:	85 c0                	test   %eax,%eax
801075c5:	79 0a                	jns    801075d1 <sys_open+0x3a>
    return -1;
801075c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075cc:	e9 61 01 00 00       	jmp    80107732 <sys_open+0x19b>

  begin_op();
801075d1:	e8 7e c1 ff ff       	call   80103754 <begin_op>

  if(omode & O_CREATE){
801075d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075d9:	25 00 02 00 00       	and    $0x200,%eax
801075de:	85 c0                	test   %eax,%eax
801075e0:	74 2a                	je     8010760c <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801075e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801075e5:	6a 00                	push   $0x0
801075e7:	6a 00                	push   $0x0
801075e9:	6a 02                	push   $0x2
801075eb:	50                   	push   %eax
801075ec:	e8 d4 fd ff ff       	call   801073c5 <create>
801075f1:	83 c4 10             	add    $0x10,%esp
801075f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801075f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801075fb:	75 75                	jne    80107672 <sys_open+0xdb>
      end_op();
801075fd:	e8 de c1 ff ff       	call   801037e0 <end_op>
      return -1;
80107602:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107607:	e9 26 01 00 00       	jmp    80107732 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010760c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010760f:	83 ec 0c             	sub    $0xc,%esp
80107612:	50                   	push   %eax
80107613:	e8 17 b1 ff ff       	call   8010272f <namei>
80107618:	83 c4 10             	add    $0x10,%esp
8010761b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010761e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107622:	75 0f                	jne    80107633 <sys_open+0x9c>
      end_op();
80107624:	e8 b7 c1 ff ff       	call   801037e0 <end_op>
      return -1;
80107629:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010762e:	e9 ff 00 00 00       	jmp    80107732 <sys_open+0x19b>
    }
    ilock(ip);
80107633:	83 ec 0c             	sub    $0xc,%esp
80107636:	ff 75 f4             	pushl  -0xc(%ebp)
80107639:	e8 e3 a4 ff ff       	call   80101b21 <ilock>
8010763e:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80107641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107644:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107648:	66 83 f8 01          	cmp    $0x1,%ax
8010764c:	75 24                	jne    80107672 <sys_open+0xdb>
8010764e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107651:	85 c0                	test   %eax,%eax
80107653:	74 1d                	je     80107672 <sys_open+0xdb>
      iunlockput(ip);
80107655:	83 ec 0c             	sub    $0xc,%esp
80107658:	ff 75 f4             	pushl  -0xc(%ebp)
8010765b:	e8 a9 a7 ff ff       	call   80101e09 <iunlockput>
80107660:	83 c4 10             	add    $0x10,%esp
      end_op();
80107663:	e8 78 c1 ff ff       	call   801037e0 <end_op>
      return -1;
80107668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010766d:	e9 c0 00 00 00       	jmp    80107732 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107672:	e8 6c 9a ff ff       	call   801010e3 <filealloc>
80107677:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010767a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010767e:	74 17                	je     80107697 <sys_open+0x100>
80107680:	83 ec 0c             	sub    $0xc,%esp
80107683:	ff 75 f0             	pushl  -0x10(%ebp)
80107686:	e8 37 f7 ff ff       	call   80106dc2 <fdalloc>
8010768b:	83 c4 10             	add    $0x10,%esp
8010768e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107691:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107695:	79 2e                	jns    801076c5 <sys_open+0x12e>
    if(f)
80107697:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010769b:	74 0e                	je     801076ab <sys_open+0x114>
      fileclose(f);
8010769d:	83 ec 0c             	sub    $0xc,%esp
801076a0:	ff 75 f0             	pushl  -0x10(%ebp)
801076a3:	e8 f9 9a ff ff       	call   801011a1 <fileclose>
801076a8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801076ab:	83 ec 0c             	sub    $0xc,%esp
801076ae:	ff 75 f4             	pushl  -0xc(%ebp)
801076b1:	e8 53 a7 ff ff       	call   80101e09 <iunlockput>
801076b6:	83 c4 10             	add    $0x10,%esp
    end_op();
801076b9:	e8 22 c1 ff ff       	call   801037e0 <end_op>
    return -1;
801076be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076c3:	eb 6d                	jmp    80107732 <sys_open+0x19b>
  }
  iunlock(ip);
801076c5:	83 ec 0c             	sub    $0xc,%esp
801076c8:	ff 75 f4             	pushl  -0xc(%ebp)
801076cb:	e8 d7 a5 ff ff       	call   80101ca7 <iunlock>
801076d0:	83 c4 10             	add    $0x10,%esp
  end_op();
801076d3:	e8 08 c1 ff ff       	call   801037e0 <end_op>

  f->type = FD_INODE;
801076d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801076e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801076e7:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801076ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076ed:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801076f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076f7:	83 e0 01             	and    $0x1,%eax
801076fa:	85 c0                	test   %eax,%eax
801076fc:	0f 94 c0             	sete   %al
801076ff:	89 c2                	mov    %eax,%edx
80107701:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107704:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010770a:	83 e0 01             	and    $0x1,%eax
8010770d:	85 c0                	test   %eax,%eax
8010770f:	75 0a                	jne    8010771b <sys_open+0x184>
80107711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107714:	83 e0 02             	and    $0x2,%eax
80107717:	85 c0                	test   %eax,%eax
80107719:	74 07                	je     80107722 <sys_open+0x18b>
8010771b:	b8 01 00 00 00       	mov    $0x1,%eax
80107720:	eb 05                	jmp    80107727 <sys_open+0x190>
80107722:	b8 00 00 00 00       	mov    $0x0,%eax
80107727:	89 c2                	mov    %eax,%edx
80107729:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010772c:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010772f:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80107732:	c9                   	leave  
80107733:	c3                   	ret    

80107734 <sys_mkdir>:

int
sys_mkdir(void)
{
80107734:	55                   	push   %ebp
80107735:	89 e5                	mov    %esp,%ebp
80107737:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010773a:	e8 15 c0 ff ff       	call   80103754 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010773f:	83 ec 08             	sub    $0x8,%esp
80107742:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107745:	50                   	push   %eax
80107746:	6a 00                	push   $0x0
80107748:	e8 49 f5 ff ff       	call   80106c96 <argstr>
8010774d:	83 c4 10             	add    $0x10,%esp
80107750:	85 c0                	test   %eax,%eax
80107752:	78 1b                	js     8010776f <sys_mkdir+0x3b>
80107754:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107757:	6a 00                	push   $0x0
80107759:	6a 00                	push   $0x0
8010775b:	6a 01                	push   $0x1
8010775d:	50                   	push   %eax
8010775e:	e8 62 fc ff ff       	call   801073c5 <create>
80107763:	83 c4 10             	add    $0x10,%esp
80107766:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010776d:	75 0c                	jne    8010777b <sys_mkdir+0x47>
    end_op();
8010776f:	e8 6c c0 ff ff       	call   801037e0 <end_op>
    return -1;
80107774:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107779:	eb 18                	jmp    80107793 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010777b:	83 ec 0c             	sub    $0xc,%esp
8010777e:	ff 75 f4             	pushl  -0xc(%ebp)
80107781:	e8 83 a6 ff ff       	call   80101e09 <iunlockput>
80107786:	83 c4 10             	add    $0x10,%esp
  end_op();
80107789:	e8 52 c0 ff ff       	call   801037e0 <end_op>
  return 0;
8010778e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107793:	c9                   	leave  
80107794:	c3                   	ret    

80107795 <sys_mknod>:

int
sys_mknod(void)
{
80107795:	55                   	push   %ebp
80107796:	89 e5                	mov    %esp,%ebp
80107798:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010779b:	e8 b4 bf ff ff       	call   80103754 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801077a0:	83 ec 08             	sub    $0x8,%esp
801077a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801077a6:	50                   	push   %eax
801077a7:	6a 00                	push   $0x0
801077a9:	e8 e8 f4 ff ff       	call   80106c96 <argstr>
801077ae:	83 c4 10             	add    $0x10,%esp
801077b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077b8:	78 4f                	js     80107809 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801077ba:	83 ec 08             	sub    $0x8,%esp
801077bd:	8d 45 e8             	lea    -0x18(%ebp),%eax
801077c0:	50                   	push   %eax
801077c1:	6a 01                	push   $0x1
801077c3:	e8 49 f4 ff ff       	call   80106c11 <argint>
801077c8:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801077cb:	85 c0                	test   %eax,%eax
801077cd:	78 3a                	js     80107809 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801077cf:	83 ec 08             	sub    $0x8,%esp
801077d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801077d5:	50                   	push   %eax
801077d6:	6a 02                	push   $0x2
801077d8:	e8 34 f4 ff ff       	call   80106c11 <argint>
801077dd:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801077e0:	85 c0                	test   %eax,%eax
801077e2:	78 25                	js     80107809 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801077e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077e7:	0f bf c8             	movswl %ax,%ecx
801077ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
801077ed:	0f bf d0             	movswl %ax,%edx
801077f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801077f3:	51                   	push   %ecx
801077f4:	52                   	push   %edx
801077f5:	6a 03                	push   $0x3
801077f7:	50                   	push   %eax
801077f8:	e8 c8 fb ff ff       	call   801073c5 <create>
801077fd:	83 c4 10             	add    $0x10,%esp
80107800:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107803:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107807:	75 0c                	jne    80107815 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107809:	e8 d2 bf ff ff       	call   801037e0 <end_op>
    return -1;
8010780e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107813:	eb 18                	jmp    8010782d <sys_mknod+0x98>
  }
  iunlockput(ip);
80107815:	83 ec 0c             	sub    $0xc,%esp
80107818:	ff 75 f0             	pushl  -0x10(%ebp)
8010781b:	e8 e9 a5 ff ff       	call   80101e09 <iunlockput>
80107820:	83 c4 10             	add    $0x10,%esp
  end_op();
80107823:	e8 b8 bf ff ff       	call   801037e0 <end_op>
  return 0;
80107828:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010782d:	c9                   	leave  
8010782e:	c3                   	ret    

8010782f <sys_chdir>:

int
sys_chdir(void)
{
8010782f:	55                   	push   %ebp
80107830:	89 e5                	mov    %esp,%ebp
80107832:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107835:	e8 1a bf ff ff       	call   80103754 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010783a:	83 ec 08             	sub    $0x8,%esp
8010783d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107840:	50                   	push   %eax
80107841:	6a 00                	push   $0x0
80107843:	e8 4e f4 ff ff       	call   80106c96 <argstr>
80107848:	83 c4 10             	add    $0x10,%esp
8010784b:	85 c0                	test   %eax,%eax
8010784d:	78 18                	js     80107867 <sys_chdir+0x38>
8010784f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107852:	83 ec 0c             	sub    $0xc,%esp
80107855:	50                   	push   %eax
80107856:	e8 d4 ae ff ff       	call   8010272f <namei>
8010785b:	83 c4 10             	add    $0x10,%esp
8010785e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107865:	75 0c                	jne    80107873 <sys_chdir+0x44>
    end_op();
80107867:	e8 74 bf ff ff       	call   801037e0 <end_op>
    return -1;
8010786c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107871:	eb 6e                	jmp    801078e1 <sys_chdir+0xb2>
  }
  ilock(ip);
80107873:	83 ec 0c             	sub    $0xc,%esp
80107876:	ff 75 f4             	pushl  -0xc(%ebp)
80107879:	e8 a3 a2 ff ff       	call   80101b21 <ilock>
8010787e:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107884:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107888:	66 83 f8 01          	cmp    $0x1,%ax
8010788c:	74 1a                	je     801078a8 <sys_chdir+0x79>
    iunlockput(ip);
8010788e:	83 ec 0c             	sub    $0xc,%esp
80107891:	ff 75 f4             	pushl  -0xc(%ebp)
80107894:	e8 70 a5 ff ff       	call   80101e09 <iunlockput>
80107899:	83 c4 10             	add    $0x10,%esp
    end_op();
8010789c:	e8 3f bf ff ff       	call   801037e0 <end_op>
    return -1;
801078a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078a6:	eb 39                	jmp    801078e1 <sys_chdir+0xb2>
  }
  iunlock(ip);
801078a8:	83 ec 0c             	sub    $0xc,%esp
801078ab:	ff 75 f4             	pushl  -0xc(%ebp)
801078ae:	e8 f4 a3 ff ff       	call   80101ca7 <iunlock>
801078b3:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801078b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078bc:	8b 40 68             	mov    0x68(%eax),%eax
801078bf:	83 ec 0c             	sub    $0xc,%esp
801078c2:	50                   	push   %eax
801078c3:	e8 51 a4 ff ff       	call   80101d19 <iput>
801078c8:	83 c4 10             	add    $0x10,%esp
  end_op();
801078cb:	e8 10 bf ff ff       	call   801037e0 <end_op>
  proc->cwd = ip;
801078d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801078d9:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801078dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801078e1:	c9                   	leave  
801078e2:	c3                   	ret    

801078e3 <sys_exec>:

int
sys_exec(void)
{
801078e3:	55                   	push   %ebp
801078e4:	89 e5                	mov    %esp,%ebp
801078e6:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801078ec:	83 ec 08             	sub    $0x8,%esp
801078ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
801078f2:	50                   	push   %eax
801078f3:	6a 00                	push   $0x0
801078f5:	e8 9c f3 ff ff       	call   80106c96 <argstr>
801078fa:	83 c4 10             	add    $0x10,%esp
801078fd:	85 c0                	test   %eax,%eax
801078ff:	78 18                	js     80107919 <sys_exec+0x36>
80107901:	83 ec 08             	sub    $0x8,%esp
80107904:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010790a:	50                   	push   %eax
8010790b:	6a 01                	push   $0x1
8010790d:	e8 ff f2 ff ff       	call   80106c11 <argint>
80107912:	83 c4 10             	add    $0x10,%esp
80107915:	85 c0                	test   %eax,%eax
80107917:	79 0a                	jns    80107923 <sys_exec+0x40>
    return -1;
80107919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010791e:	e9 c6 00 00 00       	jmp    801079e9 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107923:	83 ec 04             	sub    $0x4,%esp
80107926:	68 80 00 00 00       	push   $0x80
8010792b:	6a 00                	push   $0x0
8010792d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107933:	50                   	push   %eax
80107934:	e8 b3 ef ff ff       	call   801068ec <memset>
80107939:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010793c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107946:	83 f8 1f             	cmp    $0x1f,%eax
80107949:	76 0a                	jbe    80107955 <sys_exec+0x72>
      return -1;
8010794b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107950:	e9 94 00 00 00       	jmp    801079e9 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107958:	c1 e0 02             	shl    $0x2,%eax
8010795b:	89 c2                	mov    %eax,%edx
8010795d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107963:	01 c2                	add    %eax,%edx
80107965:	83 ec 08             	sub    $0x8,%esp
80107968:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010796e:	50                   	push   %eax
8010796f:	52                   	push   %edx
80107970:	e8 00 f2 ff ff       	call   80106b75 <fetchint>
80107975:	83 c4 10             	add    $0x10,%esp
80107978:	85 c0                	test   %eax,%eax
8010797a:	79 07                	jns    80107983 <sys_exec+0xa0>
      return -1;
8010797c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107981:	eb 66                	jmp    801079e9 <sys_exec+0x106>
    if(uarg == 0){
80107983:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107989:	85 c0                	test   %eax,%eax
8010798b:	75 27                	jne    801079b4 <sys_exec+0xd1>
      argv[i] = 0;
8010798d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107990:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107997:	00 00 00 00 
      break;
8010799b:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010799c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010799f:	83 ec 08             	sub    $0x8,%esp
801079a2:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801079a8:	52                   	push   %edx
801079a9:	50                   	push   %eax
801079aa:	e8 66 92 ff ff       	call   80100c15 <exec>
801079af:	83 c4 10             	add    $0x10,%esp
801079b2:	eb 35                	jmp    801079e9 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801079b4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801079ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801079bd:	c1 e2 02             	shl    $0x2,%edx
801079c0:	01 c2                	add    %eax,%edx
801079c2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801079c8:	83 ec 08             	sub    $0x8,%esp
801079cb:	52                   	push   %edx
801079cc:	50                   	push   %eax
801079cd:	e8 dd f1 ff ff       	call   80106baf <fetchstr>
801079d2:	83 c4 10             	add    $0x10,%esp
801079d5:	85 c0                	test   %eax,%eax
801079d7:	79 07                	jns    801079e0 <sys_exec+0xfd>
      return -1;
801079d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079de:	eb 09                	jmp    801079e9 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801079e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801079e4:	e9 5a ff ff ff       	jmp    80107943 <sys_exec+0x60>
  return exec(path, argv);
}
801079e9:	c9                   	leave  
801079ea:	c3                   	ret    

801079eb <sys_pipe>:

int
sys_pipe(void)
{
801079eb:	55                   	push   %ebp
801079ec:	89 e5                	mov    %esp,%ebp
801079ee:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801079f1:	83 ec 04             	sub    $0x4,%esp
801079f4:	6a 08                	push   $0x8
801079f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801079f9:	50                   	push   %eax
801079fa:	6a 00                	push   $0x0
801079fc:	e8 38 f2 ff ff       	call   80106c39 <argptr>
80107a01:	83 c4 10             	add    $0x10,%esp
80107a04:	85 c0                	test   %eax,%eax
80107a06:	79 0a                	jns    80107a12 <sys_pipe+0x27>
    return -1;
80107a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a0d:	e9 af 00 00 00       	jmp    80107ac1 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107a12:	83 ec 08             	sub    $0x8,%esp
80107a15:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107a18:	50                   	push   %eax
80107a19:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107a1c:	50                   	push   %eax
80107a1d:	e8 26 c8 ff ff       	call   80104248 <pipealloc>
80107a22:	83 c4 10             	add    $0x10,%esp
80107a25:	85 c0                	test   %eax,%eax
80107a27:	79 0a                	jns    80107a33 <sys_pipe+0x48>
    return -1;
80107a29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a2e:	e9 8e 00 00 00       	jmp    80107ac1 <sys_pipe+0xd6>
  fd0 = -1;
80107a33:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107a3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107a3d:	83 ec 0c             	sub    $0xc,%esp
80107a40:	50                   	push   %eax
80107a41:	e8 7c f3 ff ff       	call   80106dc2 <fdalloc>
80107a46:	83 c4 10             	add    $0x10,%esp
80107a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a50:	78 18                	js     80107a6a <sys_pipe+0x7f>
80107a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a55:	83 ec 0c             	sub    $0xc,%esp
80107a58:	50                   	push   %eax
80107a59:	e8 64 f3 ff ff       	call   80106dc2 <fdalloc>
80107a5e:	83 c4 10             	add    $0x10,%esp
80107a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a68:	79 3f                	jns    80107aa9 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107a6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a6e:	78 14                	js     80107a84 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107a70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a79:	83 c2 08             	add    $0x8,%edx
80107a7c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107a83:	00 
    fileclose(rf);
80107a84:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107a87:	83 ec 0c             	sub    $0xc,%esp
80107a8a:	50                   	push   %eax
80107a8b:	e8 11 97 ff ff       	call   801011a1 <fileclose>
80107a90:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a96:	83 ec 0c             	sub    $0xc,%esp
80107a99:	50                   	push   %eax
80107a9a:	e8 02 97 ff ff       	call   801011a1 <fileclose>
80107a9f:	83 c4 10             	add    $0x10,%esp
    return -1;
80107aa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107aa7:	eb 18                	jmp    80107ac1 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107aaf:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ab4:	8d 50 04             	lea    0x4(%eax),%edx
80107ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107aba:	89 02                	mov    %eax,(%edx)
  return 0;
80107abc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ac1:	c9                   	leave  
80107ac2:	c3                   	ret    

80107ac3 <sys_chmod>:

#ifdef CS333_P5
int
sys_chmod(void)
{
80107ac3:	55                   	push   %ebp
80107ac4:	89 e5                	mov    %esp,%ebp
80107ac6:	83 ec 18             	sub    $0x18,%esp
    char *pathname;
    int mode;
    if(argstr(0, &pathname) < 0 || argint(1, &mode) < 0)
80107ac9:	83 ec 08             	sub    $0x8,%esp
80107acc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107acf:	50                   	push   %eax
80107ad0:	6a 00                	push   $0x0
80107ad2:	e8 bf f1 ff ff       	call   80106c96 <argstr>
80107ad7:	83 c4 10             	add    $0x10,%esp
80107ada:	85 c0                	test   %eax,%eax
80107adc:	78 15                	js     80107af3 <sys_chmod+0x30>
80107ade:	83 ec 08             	sub    $0x8,%esp
80107ae1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107ae4:	50                   	push   %eax
80107ae5:	6a 01                	push   $0x1
80107ae7:	e8 25 f1 ff ff       	call   80106c11 <argint>
80107aec:	83 c4 10             	add    $0x10,%esp
80107aef:	85 c0                	test   %eax,%eax
80107af1:	79 0a                	jns    80107afd <sys_chmod+0x3a>
        return -1;
80107af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107af8:	e9 80 00 00 00       	jmp    80107b7d <sys_chmod+0xba>

    if(mode > 1777 || mode < 0000)
80107afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b00:	3d f1 06 00 00       	cmp    $0x6f1,%eax
80107b05:	7f 07                	jg     80107b0e <sys_chmod+0x4b>
80107b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b0a:	85 c0                	test   %eax,%eax
80107b0c:	79 07                	jns    80107b15 <sys_chmod+0x52>
        return -1;
80107b0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b13:	eb 68                	jmp    80107b7d <sys_chmod+0xba>

    // Check valid mode
    struct inode *ip;
    begin_op();
80107b15:	e8 3a bc ff ff       	call   80103754 <begin_op>
    if((ip = namei(pathname)) == 0) {
80107b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b1d:	83 ec 0c             	sub    $0xc,%esp
80107b20:	50                   	push   %eax
80107b21:	e8 09 ac ff ff       	call   8010272f <namei>
80107b26:	83 c4 10             	add    $0x10,%esp
80107b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b30:	75 0c                	jne    80107b3e <sys_chmod+0x7b>
        end_op();
80107b32:	e8 a9 bc ff ff       	call   801037e0 <end_op>
        return -1;
80107b37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b3c:	eb 3f                	jmp    80107b7d <sys_chmod+0xba>
    }

    ilock(ip);
80107b3e:	83 ec 0c             	sub    $0xc,%esp
80107b41:	ff 75 f4             	pushl  -0xc(%ebp)
80107b44:	e8 d8 9f ff ff       	call   80101b21 <ilock>
80107b49:	83 c4 10             	add    $0x10,%esp
    ip->mode.asInt = mode;
80107b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b4f:	89 c2                	mov    %eax,%edx
80107b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b54:	89 50 4c             	mov    %edx,0x4c(%eax)
    iupdate(ip);
80107b57:	83 ec 0c             	sub    $0xc,%esp
80107b5a:	ff 75 f4             	pushl  -0xc(%ebp)
80107b5d:	e8 7e 9d ff ff       	call   801018e0 <iupdate>
80107b62:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107b65:	83 ec 0c             	sub    $0xc,%esp
80107b68:	ff 75 f4             	pushl  -0xc(%ebp)
80107b6b:	e8 99 a2 ff ff       	call   80101e09 <iunlockput>
80107b70:	83 c4 10             	add    $0x10,%esp
    end_op();
80107b73:	e8 68 bc ff ff       	call   801037e0 <end_op>
    return 0;
80107b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b7d:	c9                   	leave  
80107b7e:	c3                   	ret    

80107b7f <sys_chown>:

int
sys_chown(void)
{
80107b7f:	55                   	push   %ebp
80107b80:	89 e5                	mov    %esp,%ebp
80107b82:	83 ec 18             	sub    $0x18,%esp
    char *pathname;
    int owner;
    if(argstr(0, &pathname) < 0 || argint(1, &owner) < 0)
80107b85:	83 ec 08             	sub    $0x8,%esp
80107b88:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b8b:	50                   	push   %eax
80107b8c:	6a 00                	push   $0x0
80107b8e:	e8 03 f1 ff ff       	call   80106c96 <argstr>
80107b93:	83 c4 10             	add    $0x10,%esp
80107b96:	85 c0                	test   %eax,%eax
80107b98:	78 15                	js     80107baf <sys_chown+0x30>
80107b9a:	83 ec 08             	sub    $0x8,%esp
80107b9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107ba0:	50                   	push   %eax
80107ba1:	6a 01                	push   $0x1
80107ba3:	e8 69 f0 ff ff       	call   80106c11 <argint>
80107ba8:	83 c4 10             	add    $0x10,%esp
80107bab:	85 c0                	test   %eax,%eax
80107bad:	79 0a                	jns    80107bb9 <sys_chown+0x3a>
        return -1;
80107baf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bb4:	e9 81 00 00 00       	jmp    80107c3a <sys_chown+0xbb>
    if(owner > 32767 || owner < 0)
80107bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bbc:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107bc1:	7f 07                	jg     80107bca <sys_chown+0x4b>
80107bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bc6:	85 c0                	test   %eax,%eax
80107bc8:	79 07                	jns    80107bd1 <sys_chown+0x52>
        return -1;
80107bca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bcf:	eb 69                	jmp    80107c3a <sys_chown+0xbb>

    struct inode *ip;
    begin_op();
80107bd1:	e8 7e bb ff ff       	call   80103754 <begin_op>
    if((ip = namei(pathname)) == 0) {
80107bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bd9:	83 ec 0c             	sub    $0xc,%esp
80107bdc:	50                   	push   %eax
80107bdd:	e8 4d ab ff ff       	call   8010272f <namei>
80107be2:	83 c4 10             	add    $0x10,%esp
80107be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107bec:	75 0c                	jne    80107bfa <sys_chown+0x7b>
        end_op();
80107bee:	e8 ed bb ff ff       	call   801037e0 <end_op>
        return -1;
80107bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bf8:	eb 40                	jmp    80107c3a <sys_chown+0xbb>
    }
    ilock(ip);
80107bfa:	83 ec 0c             	sub    $0xc,%esp
80107bfd:	ff 75 f4             	pushl  -0xc(%ebp)
80107c00:	e8 1c 9f ff ff       	call   80101b21 <ilock>
80107c05:	83 c4 10             	add    $0x10,%esp
    ip->uid = owner;    // change UID
80107c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c0b:	89 c2                	mov    %eax,%edx
80107c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c10:	66 89 50 48          	mov    %dx,0x48(%eax)
    iupdate(ip);
80107c14:	83 ec 0c             	sub    $0xc,%esp
80107c17:	ff 75 f4             	pushl  -0xc(%ebp)
80107c1a:	e8 c1 9c ff ff       	call   801018e0 <iupdate>
80107c1f:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107c22:	83 ec 0c             	sub    $0xc,%esp
80107c25:	ff 75 f4             	pushl  -0xc(%ebp)
80107c28:	e8 dc a1 ff ff       	call   80101e09 <iunlockput>
80107c2d:	83 c4 10             	add    $0x10,%esp
    end_op();
80107c30:	e8 ab bb ff ff       	call   801037e0 <end_op>
    return 0;
80107c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c3a:	c9                   	leave  
80107c3b:	c3                   	ret    

80107c3c <sys_chgrp>:

int
sys_chgrp(void)
{
80107c3c:	55                   	push   %ebp
80107c3d:	89 e5                	mov    %esp,%ebp
80107c3f:	83 ec 18             	sub    $0x18,%esp
    char *pathname;
    int group;
    if(argstr(0, &pathname) < 0 || argint(1, &group) < 0)
80107c42:	83 ec 08             	sub    $0x8,%esp
80107c45:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107c48:	50                   	push   %eax
80107c49:	6a 00                	push   $0x0
80107c4b:	e8 46 f0 ff ff       	call   80106c96 <argstr>
80107c50:	83 c4 10             	add    $0x10,%esp
80107c53:	85 c0                	test   %eax,%eax
80107c55:	78 15                	js     80107c6c <sys_chgrp+0x30>
80107c57:	83 ec 08             	sub    $0x8,%esp
80107c5a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107c5d:	50                   	push   %eax
80107c5e:	6a 01                	push   $0x1
80107c60:	e8 ac ef ff ff       	call   80106c11 <argint>
80107c65:	83 c4 10             	add    $0x10,%esp
80107c68:	85 c0                	test   %eax,%eax
80107c6a:	79 0a                	jns    80107c76 <sys_chgrp+0x3a>
        return -1;
80107c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c71:	e9 81 00 00 00       	jmp    80107cf7 <sys_chgrp+0xbb>
    if(group > 32767 || group < 0)
80107c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c79:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107c7e:	7f 07                	jg     80107c87 <sys_chgrp+0x4b>
80107c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c83:	85 c0                	test   %eax,%eax
80107c85:	79 07                	jns    80107c8e <sys_chgrp+0x52>
        return -1;
80107c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c8c:	eb 69                	jmp    80107cf7 <sys_chgrp+0xbb>
    begin_op();
80107c8e:	e8 c1 ba ff ff       	call   80103754 <begin_op>
    struct inode *ip;
    if((ip = namei(pathname)) == 0) {
80107c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c96:	83 ec 0c             	sub    $0xc,%esp
80107c99:	50                   	push   %eax
80107c9a:	e8 90 aa ff ff       	call   8010272f <namei>
80107c9f:	83 c4 10             	add    $0x10,%esp
80107ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ca5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ca9:	75 0c                	jne    80107cb7 <sys_chgrp+0x7b>
        end_op();
80107cab:	e8 30 bb ff ff       	call   801037e0 <end_op>
        return -1;
80107cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cb5:	eb 40                	jmp    80107cf7 <sys_chgrp+0xbb>
    }
    ilock(ip);
80107cb7:	83 ec 0c             	sub    $0xc,%esp
80107cba:	ff 75 f4             	pushl  -0xc(%ebp)
80107cbd:	e8 5f 9e ff ff       	call   80101b21 <ilock>
80107cc2:	83 c4 10             	add    $0x10,%esp
    ip->gid = group;    // change GID 
80107cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cc8:	89 c2                	mov    %eax,%edx
80107cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccd:	66 89 50 4a          	mov    %dx,0x4a(%eax)
    iupdate(ip);
80107cd1:	83 ec 0c             	sub    $0xc,%esp
80107cd4:	ff 75 f4             	pushl  -0xc(%ebp)
80107cd7:	e8 04 9c ff ff       	call   801018e0 <iupdate>
80107cdc:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107cdf:	83 ec 0c             	sub    $0xc,%esp
80107ce2:	ff 75 f4             	pushl  -0xc(%ebp)
80107ce5:	e8 1f a1 ff ff       	call   80101e09 <iunlockput>
80107cea:	83 c4 10             	add    $0x10,%esp
    end_op();
80107ced:	e8 ee ba ff ff       	call   801037e0 <end_op>
    return 0;
80107cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cf7:	c9                   	leave  
80107cf8:	c3                   	ret    

80107cf9 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107cf9:	55                   	push   %ebp
80107cfa:	89 e5                	mov    %esp,%ebp
80107cfc:	83 ec 08             	sub    $0x8,%esp
80107cff:	8b 55 08             	mov    0x8(%ebp),%edx
80107d02:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d05:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107d09:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107d0d:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107d11:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107d15:	66 ef                	out    %ax,(%dx)
}
80107d17:	90                   	nop
80107d18:	c9                   	leave  
80107d19:	c3                   	ret    

80107d1a <sys_fork>:
#include "uproc.h"
#endif

int
sys_fork(void)
{
80107d1a:	55                   	push   %ebp
80107d1b:	89 e5                	mov    %esp,%ebp
80107d1d:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107d20:	e8 c0 cd ff ff       	call   80104ae5 <fork>
}
80107d25:	c9                   	leave  
80107d26:	c3                   	ret    

80107d27 <sys_exit>:

int
sys_exit(void)
{
80107d27:	55                   	push   %ebp
80107d28:	89 e5                	mov    %esp,%ebp
80107d2a:	83 ec 08             	sub    $0x8,%esp
  exit();
80107d2d:	e8 f5 cf ff ff       	call   80104d27 <exit>
  return 0;  // not reached
80107d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d37:	c9                   	leave  
80107d38:	c3                   	ret    

80107d39 <sys_wait>:

int
sys_wait(void)
{
80107d39:	55                   	push   %ebp
80107d3a:	89 e5                	mov    %esp,%ebp
80107d3c:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107d3f:	e8 54 d2 ff ff       	call   80104f98 <wait>
}
80107d44:	c9                   	leave  
80107d45:	c3                   	ret    

80107d46 <sys_kill>:

int
sys_kill(void)
{
80107d46:	55                   	push   %ebp
80107d47:	89 e5                	mov    %esp,%ebp
80107d49:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107d4c:	83 ec 08             	sub    $0x8,%esp
80107d4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d52:	50                   	push   %eax
80107d53:	6a 00                	push   $0x0
80107d55:	e8 b7 ee ff ff       	call   80106c11 <argint>
80107d5a:	83 c4 10             	add    $0x10,%esp
80107d5d:	85 c0                	test   %eax,%eax
80107d5f:	79 07                	jns    80107d68 <sys_kill+0x22>
    return -1;
80107d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d66:	eb 0f                	jmp    80107d77 <sys_kill+0x31>
  return kill(pid);
80107d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6b:	83 ec 0c             	sub    $0xc,%esp
80107d6e:	50                   	push   %eax
80107d6f:	e8 cb d9 ff ff       	call   8010573f <kill>
80107d74:	83 c4 10             	add    $0x10,%esp
}
80107d77:	c9                   	leave  
80107d78:	c3                   	ret    

80107d79 <sys_getpid>:

int
sys_getpid(void)
{
80107d79:	55                   	push   %ebp
80107d7a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107d7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d82:	8b 40 10             	mov    0x10(%eax),%eax
}
80107d85:	5d                   	pop    %ebp
80107d86:	c3                   	ret    

80107d87 <sys_sbrk>:

int
sys_sbrk(void)
{
80107d87:	55                   	push   %ebp
80107d88:	89 e5                	mov    %esp,%ebp
80107d8a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107d8d:	83 ec 08             	sub    $0x8,%esp
80107d90:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d93:	50                   	push   %eax
80107d94:	6a 00                	push   $0x0
80107d96:	e8 76 ee ff ff       	call   80106c11 <argint>
80107d9b:	83 c4 10             	add    $0x10,%esp
80107d9e:	85 c0                	test   %eax,%eax
80107da0:	79 07                	jns    80107da9 <sys_sbrk+0x22>
    return -1;
80107da2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107da7:	eb 28                	jmp    80107dd1 <sys_sbrk+0x4a>
  addr = proc->sz;
80107da9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107daf:	8b 00                	mov    (%eax),%eax
80107db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107db7:	83 ec 0c             	sub    $0xc,%esp
80107dba:	50                   	push   %eax
80107dbb:	e8 82 cc ff ff       	call   80104a42 <growproc>
80107dc0:	83 c4 10             	add    $0x10,%esp
80107dc3:	85 c0                	test   %eax,%eax
80107dc5:	79 07                	jns    80107dce <sys_sbrk+0x47>
    return -1;
80107dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dcc:	eb 03                	jmp    80107dd1 <sys_sbrk+0x4a>
  return addr;
80107dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107dd1:	c9                   	leave  
80107dd2:	c3                   	ret    

80107dd3 <sys_sleep>:

int
sys_sleep(void)
{
80107dd3:	55                   	push   %ebp
80107dd4:	89 e5                	mov    %esp,%ebp
80107dd6:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107dd9:	83 ec 08             	sub    $0x8,%esp
80107ddc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ddf:	50                   	push   %eax
80107de0:	6a 00                	push   $0x0
80107de2:	e8 2a ee ff ff       	call   80106c11 <argint>
80107de7:	83 c4 10             	add    $0x10,%esp
80107dea:	85 c0                	test   %eax,%eax
80107dec:	79 07                	jns    80107df5 <sys_sleep+0x22>
    return -1;
80107dee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107df3:	eb 44                	jmp    80107e39 <sys_sleep+0x66>
  ticks0 = ticks;
80107df5:	a1 20 79 11 80       	mov    0x80117920,%eax
80107dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107dfd:	eb 26                	jmp    80107e25 <sys_sleep+0x52>
    if(proc->killed){
80107dff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e05:	8b 40 24             	mov    0x24(%eax),%eax
80107e08:	85 c0                	test   %eax,%eax
80107e0a:	74 07                	je     80107e13 <sys_sleep+0x40>
      return -1;
80107e0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e11:	eb 26                	jmp    80107e39 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107e13:	83 ec 08             	sub    $0x8,%esp
80107e16:	6a 00                	push   $0x0
80107e18:	68 20 79 11 80       	push   $0x80117920
80107e1d:	e8 78 d7 ff ff       	call   8010559a <sleep>
80107e22:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107e25:	a1 20 79 11 80       	mov    0x80117920,%eax
80107e2a:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107e2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107e30:	39 d0                	cmp    %edx,%eax
80107e32:	72 cb                	jb     80107dff <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107e34:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e39:	c9                   	leave  
80107e3a:	c3                   	ret    

80107e3b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107e3b:	55                   	push   %ebp
80107e3c:	89 e5                	mov    %esp,%ebp
80107e3e:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107e41:	a1 20 79 11 80       	mov    0x80117920,%eax
80107e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107e4c:	c9                   	leave  
80107e4d:	c3                   	ret    

80107e4e <sys_halt>:

//Turn off the computer
int sys_halt(void){
80107e4e:	55                   	push   %ebp
80107e4f:	89 e5                	mov    %esp,%ebp
80107e51:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107e54:	83 ec 0c             	sub    $0xc,%esp
80107e57:	68 6e a8 10 80       	push   $0x8010a86e
80107e5c:	e8 65 85 ff ff       	call   801003c6 <cprintf>
80107e61:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
80107e64:	83 ec 08             	sub    $0x8,%esp
80107e67:	68 00 20 00 00       	push   $0x2000
80107e6c:	68 04 06 00 00       	push   $0x604
80107e71:	e8 83 fe ff ff       	call   80107cf9 <outw>
80107e76:	83 c4 10             	add    $0x10,%esp
  return 0;
80107e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e7e:	c9                   	leave  
80107e7f:	c3                   	ret    

80107e80 <sys_date>:

int
sys_date(void) {
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	83 ec 18             	sub    $0x18,%esp
    struct rtcdate *d;
    if (argptr(0, (void*)&d, sizeof(*d)) < 0)
80107e86:	83 ec 04             	sub    $0x4,%esp
80107e89:	6a 18                	push   $0x18
80107e8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107e8e:	50                   	push   %eax
80107e8f:	6a 00                	push   $0x0
80107e91:	e8 a3 ed ff ff       	call   80106c39 <argptr>
80107e96:	83 c4 10             	add    $0x10,%esp
80107e99:	85 c0                	test   %eax,%eax
80107e9b:	79 07                	jns    80107ea4 <sys_date+0x24>
        return -1;
80107e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ea2:	eb 14                	jmp    80107eb8 <sys_date+0x38>
    cmostime(d);
80107ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea7:	83 ec 0c             	sub    $0xc,%esp
80107eaa:	50                   	push   %eax
80107eab:	e8 1f b5 ff ff       	call   801033cf <cmostime>
80107eb0:	83 c4 10             	add    $0x10,%esp
    return 0;
80107eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107eb8:	c9                   	leave  
80107eb9:	c3                   	ret    

80107eba <sys_getuid>:

uint
sys_getuid(void) {
80107eba:	55                   	push   %ebp
80107ebb:	89 e5                	mov    %esp,%ebp
    return proc->uid;
80107ebd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ec3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107ec9:	5d                   	pop    %ebp
80107eca:	c3                   	ret    

80107ecb <sys_getgid>:

uint
sys_getgid(void) {
80107ecb:	55                   	push   %ebp
80107ecc:	89 e5                	mov    %esp,%ebp
    return proc->gid;
80107ece:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ed4:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107eda:	5d                   	pop    %ebp
80107edb:	c3                   	ret    

80107edc <sys_getppid>:

uint
sys_getppid(void) {
80107edc:	55                   	push   %ebp
80107edd:	89 e5                	mov    %esp,%ebp
    if (!proc->parent)
80107edf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ee5:	8b 40 14             	mov    0x14(%eax),%eax
80107ee8:	85 c0                	test   %eax,%eax
80107eea:	75 0b                	jne    80107ef7 <sys_getppid+0x1b>
        return proc->pid;
80107eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ef2:	8b 40 10             	mov    0x10(%eax),%eax
80107ef5:	eb 0c                	jmp    80107f03 <sys_getppid+0x27>
    return proc->parent->pid;
80107ef7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107efd:	8b 40 14             	mov    0x14(%eax),%eax
80107f00:	8b 40 10             	mov    0x10(%eax),%eax
}
80107f03:	5d                   	pop    %ebp
80107f04:	c3                   	ret    

80107f05 <sys_setuid>:

int
sys_setuid(void) {
80107f05:	55                   	push   %ebp
80107f06:	89 e5                	mov    %esp,%ebp
80107f08:	83 ec 18             	sub    $0x18,%esp
    int uid;
    if (argint(0, &uid) < 0)
80107f0b:	83 ec 08             	sub    $0x8,%esp
80107f0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f11:	50                   	push   %eax
80107f12:	6a 00                	push   $0x0
80107f14:	e8 f8 ec ff ff       	call   80106c11 <argint>
80107f19:	83 c4 10             	add    $0x10,%esp
80107f1c:	85 c0                	test   %eax,%eax
80107f1e:	79 07                	jns    80107f27 <sys_setuid+0x22>
        return -1;
80107f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f25:	eb 2c                	jmp    80107f53 <sys_setuid+0x4e>
    if (uid >= 0 && uid <= 32767) {
80107f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2a:	85 c0                	test   %eax,%eax
80107f2c:	78 20                	js     80107f4e <sys_setuid+0x49>
80107f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f31:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107f36:	7f 16                	jg     80107f4e <sys_setuid+0x49>
        proc->uid = uid;
80107f38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f41:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
        return 0;
80107f47:	b8 00 00 00 00       	mov    $0x0,%eax
80107f4c:	eb 05                	jmp    80107f53 <sys_setuid+0x4e>
    }
    return -1;
80107f4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f53:	c9                   	leave  
80107f54:	c3                   	ret    

80107f55 <sys_setgid>:

int
sys_setgid(void) {
80107f55:	55                   	push   %ebp
80107f56:	89 e5                	mov    %esp,%ebp
80107f58:	83 ec 18             	sub    $0x18,%esp
    int gid;
    if (argint(0, &gid) < 0)
80107f5b:	83 ec 08             	sub    $0x8,%esp
80107f5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f61:	50                   	push   %eax
80107f62:	6a 00                	push   $0x0
80107f64:	e8 a8 ec ff ff       	call   80106c11 <argint>
80107f69:	83 c4 10             	add    $0x10,%esp
80107f6c:	85 c0                	test   %eax,%eax
80107f6e:	79 07                	jns    80107f77 <sys_setgid+0x22>
        return -1;
80107f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f75:	eb 2c                	jmp    80107fa3 <sys_setgid+0x4e>
    if (gid >= 0 && gid <= 32767) {
80107f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7a:	85 c0                	test   %eax,%eax
80107f7c:	78 20                	js     80107f9e <sys_setgid+0x49>
80107f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f81:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107f86:	7f 16                	jg     80107f9e <sys_setgid+0x49>
        proc->gid = gid;
80107f88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f91:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
        return 0;
80107f97:	b8 00 00 00 00       	mov    $0x0,%eax
80107f9c:	eb 05                	jmp    80107fa3 <sys_setgid+0x4e>
    }
    return -1;
80107f9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107fa3:	c9                   	leave  
80107fa4:	c3                   	ret    

80107fa5 <sys_getprocs>:

int
sys_getprocs(void){
80107fa5:	55                   	push   %ebp
80107fa6:	89 e5                	mov    %esp,%ebp
80107fa8:	83 ec 18             	sub    $0x18,%esp
    int max;
    struct uproc* table;
    if (argint(0, &max) < 0 || argptr(1, (void*)&table, sizeof(*table)) < 0)
80107fab:	83 ec 08             	sub    $0x8,%esp
80107fae:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107fb1:	50                   	push   %eax
80107fb2:	6a 00                	push   $0x0
80107fb4:	e8 58 ec ff ff       	call   80106c11 <argint>
80107fb9:	83 c4 10             	add    $0x10,%esp
80107fbc:	85 c0                	test   %eax,%eax
80107fbe:	78 17                	js     80107fd7 <sys_getprocs+0x32>
80107fc0:	83 ec 04             	sub    $0x4,%esp
80107fc3:	6a 60                	push   $0x60
80107fc5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107fc8:	50                   	push   %eax
80107fc9:	6a 01                	push   $0x1
80107fcb:	e8 69 ec ff ff       	call   80106c39 <argptr>
80107fd0:	83 c4 10             	add    $0x10,%esp
80107fd3:	85 c0                	test   %eax,%eax
80107fd5:	79 07                	jns    80107fde <sys_getprocs+0x39>
        return -1;
80107fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fdc:	eb 13                	jmp    80107ff1 <sys_getprocs+0x4c>
    return getprocs(max, table);
80107fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fe1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107fe4:	83 ec 08             	sub    $0x8,%esp
80107fe7:	50                   	push   %eax
80107fe8:	52                   	push   %edx
80107fe9:	e8 b1 db ff ff       	call   80105b9f <getprocs>
80107fee:	83 c4 10             	add    $0x10,%esp
}
80107ff1:	c9                   	leave  
80107ff2:	c3                   	ret    

80107ff3 <sys_setpriority>:

int
sys_setpriority(void) {
80107ff3:	55                   	push   %ebp
80107ff4:	89 e5                	mov    %esp,%ebp
80107ff6:	83 ec 18             	sub    $0x18,%esp
    int pid;
    int value;
    if (argint(0, &pid) < 0 || argint(1, &value) < 0)
80107ff9:	83 ec 08             	sub    $0x8,%esp
80107ffc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107fff:	50                   	push   %eax
80108000:	6a 00                	push   $0x0
80108002:	e8 0a ec ff ff       	call   80106c11 <argint>
80108007:	83 c4 10             	add    $0x10,%esp
8010800a:	85 c0                	test   %eax,%eax
8010800c:	78 15                	js     80108023 <sys_setpriority+0x30>
8010800e:	83 ec 08             	sub    $0x8,%esp
80108011:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108014:	50                   	push   %eax
80108015:	6a 01                	push   $0x1
80108017:	e8 f5 eb ff ff       	call   80106c11 <argint>
8010801c:	83 c4 10             	add    $0x10,%esp
8010801f:	85 c0                	test   %eax,%eax
80108021:	79 07                	jns    8010802a <sys_setpriority+0x37>
        return -1;
80108023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108028:	eb 13                	jmp    8010803d <sys_setpriority+0x4a>
    return setpriority(pid, value);
8010802a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010802d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108030:	83 ec 08             	sub    $0x8,%esp
80108033:	52                   	push   %edx
80108034:	50                   	push   %eax
80108035:	e8 de e2 ff ff       	call   80106318 <setpriority>
8010803a:	83 c4 10             	add    $0x10,%esp
}
8010803d:	c9                   	leave  
8010803e:	c3                   	ret    

8010803f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010803f:	55                   	push   %ebp
80108040:	89 e5                	mov    %esp,%ebp
80108042:	83 ec 08             	sub    $0x8,%esp
80108045:	8b 55 08             	mov    0x8(%ebp),%edx
80108048:	8b 45 0c             	mov    0xc(%ebp),%eax
8010804b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010804f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108052:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108056:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010805a:	ee                   	out    %al,(%dx)
}
8010805b:	90                   	nop
8010805c:	c9                   	leave  
8010805d:	c3                   	ret    

8010805e <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010805e:	55                   	push   %ebp
8010805f:	89 e5                	mov    %esp,%ebp
80108061:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80108064:	6a 34                	push   $0x34
80108066:	6a 43                	push   $0x43
80108068:	e8 d2 ff ff ff       	call   8010803f <outb>
8010806d:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80108070:	68 9c 00 00 00       	push   $0x9c
80108075:	6a 40                	push   $0x40
80108077:	e8 c3 ff ff ff       	call   8010803f <outb>
8010807c:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010807f:	6a 2e                	push   $0x2e
80108081:	6a 40                	push   $0x40
80108083:	e8 b7 ff ff ff       	call   8010803f <outb>
80108088:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010808b:	83 ec 0c             	sub    $0xc,%esp
8010808e:	6a 00                	push   $0x0
80108090:	e8 9d c0 ff ff       	call   80104132 <picenable>
80108095:	83 c4 10             	add    $0x10,%esp
}
80108098:	90                   	nop
80108099:	c9                   	leave  
8010809a:	c3                   	ret    

8010809b <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010809b:	1e                   	push   %ds
  pushl %es
8010809c:	06                   	push   %es
  pushl %fs
8010809d:	0f a0                	push   %fs
  pushl %gs
8010809f:	0f a8                	push   %gs
  pushal
801080a1:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801080a2:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801080a6:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801080a8:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801080aa:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801080ae:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801080b0:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801080b2:	54                   	push   %esp
  call trap
801080b3:	e8 ce 01 00 00       	call   80108286 <trap>
  addl $4, %esp
801080b8:	83 c4 04             	add    $0x4,%esp

801080bb <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801080bb:	61                   	popa   
  popl %gs
801080bc:	0f a9                	pop    %gs
  popl %fs
801080be:	0f a1                	pop    %fs
  popl %es
801080c0:	07                   	pop    %es
  popl %ds
801080c1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801080c2:	83 c4 08             	add    $0x8,%esp
  iret
801080c5:	cf                   	iret   

801080c6 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
801080c6:	55                   	push   %ebp
801080c7:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
801080c9:	8b 45 08             	mov    0x8(%ebp),%eax
801080cc:	f0 ff 00             	lock incl (%eax)
}
801080cf:	90                   	nop
801080d0:	5d                   	pop    %ebp
801080d1:	c3                   	ret    

801080d2 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801080d2:	55                   	push   %ebp
801080d3:	89 e5                	mov    %esp,%ebp
801080d5:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801080d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801080db:	83 e8 01             	sub    $0x1,%eax
801080de:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801080e2:	8b 45 08             	mov    0x8(%ebp),%eax
801080e5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801080e9:	8b 45 08             	mov    0x8(%ebp),%eax
801080ec:	c1 e8 10             	shr    $0x10,%eax
801080ef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801080f3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801080f6:	0f 01 18             	lidtl  (%eax)
}
801080f9:	90                   	nop
801080fa:	c9                   	leave  
801080fb:	c3                   	ret    

801080fc <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801080fc:	55                   	push   %ebp
801080fd:	89 e5                	mov    %esp,%ebp
801080ff:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108102:	0f 20 d0             	mov    %cr2,%eax
80108105:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80108108:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010810b:	c9                   	leave  
8010810c:	c3                   	ret    

8010810d <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
8010810d:	55                   	push   %ebp
8010810e:	89 e5                	mov    %esp,%ebp
80108110:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80108113:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010811a:	e9 c3 00 00 00       	jmp    801081e2 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010811f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108122:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
80108129:	89 c2                	mov    %eax,%edx
8010812b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010812e:	66 89 14 c5 20 71 11 	mov    %dx,-0x7fee8ee0(,%eax,8)
80108135:	80 
80108136:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108139:	66 c7 04 c5 22 71 11 	movw   $0x8,-0x7fee8ede(,%eax,8)
80108140:	80 08 00 
80108143:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108146:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
8010814d:	80 
8010814e:	83 e2 e0             	and    $0xffffffe0,%edx
80108151:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
80108158:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010815b:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
80108162:	80 
80108163:	83 e2 1f             	and    $0x1f,%edx
80108166:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
8010816d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108170:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
80108177:	80 
80108178:	83 e2 f0             	and    $0xfffffff0,%edx
8010817b:	83 ca 0e             	or     $0xe,%edx
8010817e:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
80108185:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108188:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
8010818f:	80 
80108190:	83 e2 ef             	and    $0xffffffef,%edx
80108193:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
8010819a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010819d:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801081a4:	80 
801081a5:	83 e2 9f             	and    $0xffffff9f,%edx
801081a8:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801081af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801081b2:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801081b9:	80 
801081ba:	83 ca 80             	or     $0xffffff80,%edx
801081bd:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801081c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801081c7:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
801081ce:	c1 e8 10             	shr    $0x10,%eax
801081d1:	89 c2                	mov    %eax,%edx
801081d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801081d6:	66 89 14 c5 26 71 11 	mov    %dx,-0x7fee8eda(,%eax,8)
801081dd:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801081de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801081e2:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
801081e9:	0f 8e 30 ff ff ff    	jle    8010811f <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801081ef:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
801081f4:	66 a3 20 73 11 80    	mov    %ax,0x80117320
801081fa:	66 c7 05 22 73 11 80 	movw   $0x8,0x80117322
80108201:	08 00 
80108203:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
8010820a:	83 e0 e0             	and    $0xffffffe0,%eax
8010820d:	a2 24 73 11 80       	mov    %al,0x80117324
80108212:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
80108219:	83 e0 1f             	and    $0x1f,%eax
8010821c:	a2 24 73 11 80       	mov    %al,0x80117324
80108221:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108228:	83 c8 0f             	or     $0xf,%eax
8010822b:	a2 25 73 11 80       	mov    %al,0x80117325
80108230:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108237:	83 e0 ef             	and    $0xffffffef,%eax
8010823a:	a2 25 73 11 80       	mov    %al,0x80117325
8010823f:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108246:	83 c8 60             	or     $0x60,%eax
80108249:	a2 25 73 11 80       	mov    %al,0x80117325
8010824e:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108255:	83 c8 80             	or     $0xffffff80,%eax
80108258:	a2 25 73 11 80       	mov    %al,0x80117325
8010825d:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
80108262:	c1 e8 10             	shr    $0x10,%eax
80108265:	66 a3 26 73 11 80    	mov    %ax,0x80117326
  
}
8010826b:	90                   	nop
8010826c:	c9                   	leave  
8010826d:	c3                   	ret    

8010826e <idtinit>:

void
idtinit(void)
{
8010826e:	55                   	push   %ebp
8010826f:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80108271:	68 00 08 00 00       	push   $0x800
80108276:	68 20 71 11 80       	push   $0x80117120
8010827b:	e8 52 fe ff ff       	call   801080d2 <lidt>
80108280:	83 c4 08             	add    $0x8,%esp
}
80108283:	90                   	nop
80108284:	c9                   	leave  
80108285:	c3                   	ret    

80108286 <trap>:

void
trap(struct trapframe *tf)
{
80108286:	55                   	push   %ebp
80108287:	89 e5                	mov    %esp,%ebp
80108289:	57                   	push   %edi
8010828a:	56                   	push   %esi
8010828b:	53                   	push   %ebx
8010828c:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010828f:	8b 45 08             	mov    0x8(%ebp),%eax
80108292:	8b 40 30             	mov    0x30(%eax),%eax
80108295:	83 f8 40             	cmp    $0x40,%eax
80108298:	75 3e                	jne    801082d8 <trap+0x52>
    if(proc->killed)
8010829a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801082a0:	8b 40 24             	mov    0x24(%eax),%eax
801082a3:	85 c0                	test   %eax,%eax
801082a5:	74 05                	je     801082ac <trap+0x26>
      exit();
801082a7:	e8 7b ca ff ff       	call   80104d27 <exit>
    proc->tf = tf;
801082ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801082b2:	8b 55 08             	mov    0x8(%ebp),%edx
801082b5:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801082b8:	e8 0a ea ff ff       	call   80106cc7 <syscall>
    if(proc->killed)
801082bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801082c3:	8b 40 24             	mov    0x24(%eax),%eax
801082c6:	85 c0                	test   %eax,%eax
801082c8:	0f 84 fe 01 00 00    	je     801084cc <trap+0x246>
      exit();
801082ce:	e8 54 ca ff ff       	call   80104d27 <exit>
    return;
801082d3:	e9 f4 01 00 00       	jmp    801084cc <trap+0x246>
  }

  switch(tf->trapno){
801082d8:	8b 45 08             	mov    0x8(%ebp),%eax
801082db:	8b 40 30             	mov    0x30(%eax),%eax
801082de:	83 e8 20             	sub    $0x20,%eax
801082e1:	83 f8 1f             	cmp    $0x1f,%eax
801082e4:	0f 87 a3 00 00 00    	ja     8010838d <trap+0x107>
801082ea:	8b 04 85 24 a9 10 80 	mov    -0x7fef56dc(,%eax,4),%eax
801082f1:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
801082f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082f9:	0f b6 00             	movzbl (%eax),%eax
801082fc:	84 c0                	test   %al,%al
801082fe:	75 20                	jne    80108320 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80108300:	83 ec 0c             	sub    $0xc,%esp
80108303:	68 20 79 11 80       	push   $0x80117920
80108308:	e8 b9 fd ff ff       	call   801080c6 <atom_inc>
8010830d:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80108310:	83 ec 0c             	sub    $0xc,%esp
80108313:	68 20 79 11 80       	push   $0x80117920
80108318:	e8 eb d3 ff ff       	call   80105708 <wakeup>
8010831d:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80108320:	e8 07 af ff ff       	call   8010322c <lapiceoi>
    break;
80108325:	e9 1c 01 00 00       	jmp    80108446 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010832a:	e8 10 a7 ff ff       	call   80102a3f <ideintr>
    lapiceoi();
8010832f:	e8 f8 ae ff ff       	call   8010322c <lapiceoi>
    break;
80108334:	e9 0d 01 00 00       	jmp    80108446 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80108339:	e8 f0 ac ff ff       	call   8010302e <kbdintr>
    lapiceoi();
8010833e:	e8 e9 ae ff ff       	call   8010322c <lapiceoi>
    break;
80108343:	e9 fe 00 00 00       	jmp    80108446 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80108348:	e8 60 03 00 00       	call   801086ad <uartintr>
    lapiceoi();
8010834d:	e8 da ae ff ff       	call   8010322c <lapiceoi>
    break;
80108352:	e9 ef 00 00 00       	jmp    80108446 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108357:	8b 45 08             	mov    0x8(%ebp),%eax
8010835a:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010835d:	8b 45 08             	mov    0x8(%ebp),%eax
80108360:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108364:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80108367:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010836d:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108370:	0f b6 c0             	movzbl %al,%eax
80108373:	51                   	push   %ecx
80108374:	52                   	push   %edx
80108375:	50                   	push   %eax
80108376:	68 84 a8 10 80       	push   $0x8010a884
8010837b:	e8 46 80 ff ff       	call   801003c6 <cprintf>
80108380:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80108383:	e8 a4 ae ff ff       	call   8010322c <lapiceoi>
    break;
80108388:	e9 b9 00 00 00       	jmp    80108446 <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010838d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108393:	85 c0                	test   %eax,%eax
80108395:	74 11                	je     801083a8 <trap+0x122>
80108397:	8b 45 08             	mov    0x8(%ebp),%eax
8010839a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010839e:	0f b7 c0             	movzwl %ax,%eax
801083a1:	83 e0 03             	and    $0x3,%eax
801083a4:	85 c0                	test   %eax,%eax
801083a6:	75 40                	jne    801083e8 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801083a8:	e8 4f fd ff ff       	call   801080fc <rcr2>
801083ad:	89 c3                	mov    %eax,%ebx
801083af:	8b 45 08             	mov    0x8(%ebp),%eax
801083b2:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801083b5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083bb:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801083be:	0f b6 d0             	movzbl %al,%edx
801083c1:	8b 45 08             	mov    0x8(%ebp),%eax
801083c4:	8b 40 30             	mov    0x30(%eax),%eax
801083c7:	83 ec 0c             	sub    $0xc,%esp
801083ca:	53                   	push   %ebx
801083cb:	51                   	push   %ecx
801083cc:	52                   	push   %edx
801083cd:	50                   	push   %eax
801083ce:	68 a8 a8 10 80       	push   $0x8010a8a8
801083d3:	e8 ee 7f ff ff       	call   801003c6 <cprintf>
801083d8:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801083db:	83 ec 0c             	sub    $0xc,%esp
801083de:	68 da a8 10 80       	push   $0x8010a8da
801083e3:	e8 7e 81 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083e8:	e8 0f fd ff ff       	call   801080fc <rcr2>
801083ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801083f0:	8b 45 08             	mov    0x8(%ebp),%eax
801083f3:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801083f6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083fc:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083ff:	0f b6 d8             	movzbl %al,%ebx
80108402:	8b 45 08             	mov    0x8(%ebp),%eax
80108405:	8b 48 34             	mov    0x34(%eax),%ecx
80108408:	8b 45 08             	mov    0x8(%ebp),%eax
8010840b:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010840e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108414:	8d 78 6c             	lea    0x6c(%eax),%edi
80108417:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010841d:	8b 40 10             	mov    0x10(%eax),%eax
80108420:	ff 75 e4             	pushl  -0x1c(%ebp)
80108423:	56                   	push   %esi
80108424:	53                   	push   %ebx
80108425:	51                   	push   %ecx
80108426:	52                   	push   %edx
80108427:	57                   	push   %edi
80108428:	50                   	push   %eax
80108429:	68 e0 a8 10 80       	push   $0x8010a8e0
8010842e:	e8 93 7f ff ff       	call   801003c6 <cprintf>
80108433:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80108436:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010843c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80108443:	eb 01                	jmp    80108446 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80108445:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80108446:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010844c:	85 c0                	test   %eax,%eax
8010844e:	74 24                	je     80108474 <trap+0x1ee>
80108450:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108456:	8b 40 24             	mov    0x24(%eax),%eax
80108459:	85 c0                	test   %eax,%eax
8010845b:	74 17                	je     80108474 <trap+0x1ee>
8010845d:	8b 45 08             	mov    0x8(%ebp),%eax
80108460:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108464:	0f b7 c0             	movzwl %ax,%eax
80108467:	83 e0 03             	and    $0x3,%eax
8010846a:	83 f8 03             	cmp    $0x3,%eax
8010846d:	75 05                	jne    80108474 <trap+0x1ee>
    exit();
8010846f:	e8 b3 c8 ff ff       	call   80104d27 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80108474:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010847a:	85 c0                	test   %eax,%eax
8010847c:	74 1e                	je     8010849c <trap+0x216>
8010847e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108484:	8b 40 0c             	mov    0xc(%eax),%eax
80108487:	83 f8 04             	cmp    $0x4,%eax
8010848a:	75 10                	jne    8010849c <trap+0x216>
8010848c:	8b 45 08             	mov    0x8(%ebp),%eax
8010848f:	8b 40 30             	mov    0x30(%eax),%eax
80108492:	83 f8 20             	cmp    $0x20,%eax
80108495:	75 05                	jne    8010849c <trap+0x216>
    yield();
80108497:	e8 a3 cf ff ff       	call   8010543f <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010849c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801084a2:	85 c0                	test   %eax,%eax
801084a4:	74 27                	je     801084cd <trap+0x247>
801084a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801084ac:	8b 40 24             	mov    0x24(%eax),%eax
801084af:	85 c0                	test   %eax,%eax
801084b1:	74 1a                	je     801084cd <trap+0x247>
801084b3:	8b 45 08             	mov    0x8(%ebp),%eax
801084b6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801084ba:	0f b7 c0             	movzwl %ax,%eax
801084bd:	83 e0 03             	and    $0x3,%eax
801084c0:	83 f8 03             	cmp    $0x3,%eax
801084c3:	75 08                	jne    801084cd <trap+0x247>
    exit();
801084c5:	e8 5d c8 ff ff       	call   80104d27 <exit>
801084ca:	eb 01                	jmp    801084cd <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801084cc:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801084cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084d0:	5b                   	pop    %ebx
801084d1:	5e                   	pop    %esi
801084d2:	5f                   	pop    %edi
801084d3:	5d                   	pop    %ebp
801084d4:	c3                   	ret    

801084d5 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801084d5:	55                   	push   %ebp
801084d6:	89 e5                	mov    %esp,%ebp
801084d8:	83 ec 14             	sub    $0x14,%esp
801084db:	8b 45 08             	mov    0x8(%ebp),%eax
801084de:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801084e2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801084e6:	89 c2                	mov    %eax,%edx
801084e8:	ec                   	in     (%dx),%al
801084e9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801084ec:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801084f0:	c9                   	leave  
801084f1:	c3                   	ret    

801084f2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801084f2:	55                   	push   %ebp
801084f3:	89 e5                	mov    %esp,%ebp
801084f5:	83 ec 08             	sub    $0x8,%esp
801084f8:	8b 55 08             	mov    0x8(%ebp),%edx
801084fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801084fe:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80108502:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108505:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108509:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010850d:	ee                   	out    %al,(%dx)
}
8010850e:	90                   	nop
8010850f:	c9                   	leave  
80108510:	c3                   	ret    

80108511 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80108511:	55                   	push   %ebp
80108512:	89 e5                	mov    %esp,%ebp
80108514:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80108517:	6a 00                	push   $0x0
80108519:	68 fa 03 00 00       	push   $0x3fa
8010851e:	e8 cf ff ff ff       	call   801084f2 <outb>
80108523:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80108526:	68 80 00 00 00       	push   $0x80
8010852b:	68 fb 03 00 00       	push   $0x3fb
80108530:	e8 bd ff ff ff       	call   801084f2 <outb>
80108535:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80108538:	6a 0c                	push   $0xc
8010853a:	68 f8 03 00 00       	push   $0x3f8
8010853f:	e8 ae ff ff ff       	call   801084f2 <outb>
80108544:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80108547:	6a 00                	push   $0x0
80108549:	68 f9 03 00 00       	push   $0x3f9
8010854e:	e8 9f ff ff ff       	call   801084f2 <outb>
80108553:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108556:	6a 03                	push   $0x3
80108558:	68 fb 03 00 00       	push   $0x3fb
8010855d:	e8 90 ff ff ff       	call   801084f2 <outb>
80108562:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80108565:	6a 00                	push   $0x0
80108567:	68 fc 03 00 00       	push   $0x3fc
8010856c:	e8 81 ff ff ff       	call   801084f2 <outb>
80108571:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80108574:	6a 01                	push   $0x1
80108576:	68 f9 03 00 00       	push   $0x3f9
8010857b:	e8 72 ff ff ff       	call   801084f2 <outb>
80108580:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80108583:	68 fd 03 00 00       	push   $0x3fd
80108588:	e8 48 ff ff ff       	call   801084d5 <inb>
8010858d:	83 c4 04             	add    $0x4,%esp
80108590:	3c ff                	cmp    $0xff,%al
80108592:	74 6e                	je     80108602 <uartinit+0xf1>
    return;
  uart = 1;
80108594:	c7 05 8c d6 10 80 01 	movl   $0x1,0x8010d68c
8010859b:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010859e:	68 fa 03 00 00       	push   $0x3fa
801085a3:	e8 2d ff ff ff       	call   801084d5 <inb>
801085a8:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801085ab:	68 f8 03 00 00       	push   $0x3f8
801085b0:	e8 20 ff ff ff       	call   801084d5 <inb>
801085b5:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801085b8:	83 ec 0c             	sub    $0xc,%esp
801085bb:	6a 04                	push   $0x4
801085bd:	e8 70 bb ff ff       	call   80104132 <picenable>
801085c2:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801085c5:	83 ec 08             	sub    $0x8,%esp
801085c8:	6a 00                	push   $0x0
801085ca:	6a 04                	push   $0x4
801085cc:	e8 10 a7 ff ff       	call   80102ce1 <ioapicenable>
801085d1:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801085d4:	c7 45 f4 a4 a9 10 80 	movl   $0x8010a9a4,-0xc(%ebp)
801085db:	eb 19                	jmp    801085f6 <uartinit+0xe5>
    uartputc(*p);
801085dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e0:	0f b6 00             	movzbl (%eax),%eax
801085e3:	0f be c0             	movsbl %al,%eax
801085e6:	83 ec 0c             	sub    $0xc,%esp
801085e9:	50                   	push   %eax
801085ea:	e8 16 00 00 00       	call   80108605 <uartputc>
801085ef:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801085f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801085f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f9:	0f b6 00             	movzbl (%eax),%eax
801085fc:	84 c0                	test   %al,%al
801085fe:	75 dd                	jne    801085dd <uartinit+0xcc>
80108600:	eb 01                	jmp    80108603 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80108602:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80108603:	c9                   	leave  
80108604:	c3                   	ret    

80108605 <uartputc>:

void
uartputc(int c)
{
80108605:	55                   	push   %ebp
80108606:	89 e5                	mov    %esp,%ebp
80108608:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010860b:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
80108610:	85 c0                	test   %eax,%eax
80108612:	74 53                	je     80108667 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108614:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010861b:	eb 11                	jmp    8010862e <uartputc+0x29>
    microdelay(10);
8010861d:	83 ec 0c             	sub    $0xc,%esp
80108620:	6a 0a                	push   $0xa
80108622:	e8 20 ac ff ff       	call   80103247 <microdelay>
80108627:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010862a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010862e:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108632:	7f 1a                	jg     8010864e <uartputc+0x49>
80108634:	83 ec 0c             	sub    $0xc,%esp
80108637:	68 fd 03 00 00       	push   $0x3fd
8010863c:	e8 94 fe ff ff       	call   801084d5 <inb>
80108641:	83 c4 10             	add    $0x10,%esp
80108644:	0f b6 c0             	movzbl %al,%eax
80108647:	83 e0 20             	and    $0x20,%eax
8010864a:	85 c0                	test   %eax,%eax
8010864c:	74 cf                	je     8010861d <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010864e:	8b 45 08             	mov    0x8(%ebp),%eax
80108651:	0f b6 c0             	movzbl %al,%eax
80108654:	83 ec 08             	sub    $0x8,%esp
80108657:	50                   	push   %eax
80108658:	68 f8 03 00 00       	push   $0x3f8
8010865d:	e8 90 fe ff ff       	call   801084f2 <outb>
80108662:	83 c4 10             	add    $0x10,%esp
80108665:	eb 01                	jmp    80108668 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108667:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80108668:	c9                   	leave  
80108669:	c3                   	ret    

8010866a <uartgetc>:

static int
uartgetc(void)
{
8010866a:	55                   	push   %ebp
8010866b:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010866d:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
80108672:	85 c0                	test   %eax,%eax
80108674:	75 07                	jne    8010867d <uartgetc+0x13>
    return -1;
80108676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010867b:	eb 2e                	jmp    801086ab <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010867d:	68 fd 03 00 00       	push   $0x3fd
80108682:	e8 4e fe ff ff       	call   801084d5 <inb>
80108687:	83 c4 04             	add    $0x4,%esp
8010868a:	0f b6 c0             	movzbl %al,%eax
8010868d:	83 e0 01             	and    $0x1,%eax
80108690:	85 c0                	test   %eax,%eax
80108692:	75 07                	jne    8010869b <uartgetc+0x31>
    return -1;
80108694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108699:	eb 10                	jmp    801086ab <uartgetc+0x41>
  return inb(COM1+0);
8010869b:	68 f8 03 00 00       	push   $0x3f8
801086a0:	e8 30 fe ff ff       	call   801084d5 <inb>
801086a5:	83 c4 04             	add    $0x4,%esp
801086a8:	0f b6 c0             	movzbl %al,%eax
}
801086ab:	c9                   	leave  
801086ac:	c3                   	ret    

801086ad <uartintr>:

void
uartintr(void)
{
801086ad:	55                   	push   %ebp
801086ae:	89 e5                	mov    %esp,%ebp
801086b0:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801086b3:	83 ec 0c             	sub    $0xc,%esp
801086b6:	68 6a 86 10 80       	push   $0x8010866a
801086bb:	e8 39 81 ff ff       	call   801007f9 <consoleintr>
801086c0:	83 c4 10             	add    $0x10,%esp
}
801086c3:	90                   	nop
801086c4:	c9                   	leave  
801086c5:	c3                   	ret    

801086c6 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801086c6:	6a 00                	push   $0x0
  pushl $0
801086c8:	6a 00                	push   $0x0
  jmp alltraps
801086ca:	e9 cc f9 ff ff       	jmp    8010809b <alltraps>

801086cf <vector1>:
.globl vector1
vector1:
  pushl $0
801086cf:	6a 00                	push   $0x0
  pushl $1
801086d1:	6a 01                	push   $0x1
  jmp alltraps
801086d3:	e9 c3 f9 ff ff       	jmp    8010809b <alltraps>

801086d8 <vector2>:
.globl vector2
vector2:
  pushl $0
801086d8:	6a 00                	push   $0x0
  pushl $2
801086da:	6a 02                	push   $0x2
  jmp alltraps
801086dc:	e9 ba f9 ff ff       	jmp    8010809b <alltraps>

801086e1 <vector3>:
.globl vector3
vector3:
  pushl $0
801086e1:	6a 00                	push   $0x0
  pushl $3
801086e3:	6a 03                	push   $0x3
  jmp alltraps
801086e5:	e9 b1 f9 ff ff       	jmp    8010809b <alltraps>

801086ea <vector4>:
.globl vector4
vector4:
  pushl $0
801086ea:	6a 00                	push   $0x0
  pushl $4
801086ec:	6a 04                	push   $0x4
  jmp alltraps
801086ee:	e9 a8 f9 ff ff       	jmp    8010809b <alltraps>

801086f3 <vector5>:
.globl vector5
vector5:
  pushl $0
801086f3:	6a 00                	push   $0x0
  pushl $5
801086f5:	6a 05                	push   $0x5
  jmp alltraps
801086f7:	e9 9f f9 ff ff       	jmp    8010809b <alltraps>

801086fc <vector6>:
.globl vector6
vector6:
  pushl $0
801086fc:	6a 00                	push   $0x0
  pushl $6
801086fe:	6a 06                	push   $0x6
  jmp alltraps
80108700:	e9 96 f9 ff ff       	jmp    8010809b <alltraps>

80108705 <vector7>:
.globl vector7
vector7:
  pushl $0
80108705:	6a 00                	push   $0x0
  pushl $7
80108707:	6a 07                	push   $0x7
  jmp alltraps
80108709:	e9 8d f9 ff ff       	jmp    8010809b <alltraps>

8010870e <vector8>:
.globl vector8
vector8:
  pushl $8
8010870e:	6a 08                	push   $0x8
  jmp alltraps
80108710:	e9 86 f9 ff ff       	jmp    8010809b <alltraps>

80108715 <vector9>:
.globl vector9
vector9:
  pushl $0
80108715:	6a 00                	push   $0x0
  pushl $9
80108717:	6a 09                	push   $0x9
  jmp alltraps
80108719:	e9 7d f9 ff ff       	jmp    8010809b <alltraps>

8010871e <vector10>:
.globl vector10
vector10:
  pushl $10
8010871e:	6a 0a                	push   $0xa
  jmp alltraps
80108720:	e9 76 f9 ff ff       	jmp    8010809b <alltraps>

80108725 <vector11>:
.globl vector11
vector11:
  pushl $11
80108725:	6a 0b                	push   $0xb
  jmp alltraps
80108727:	e9 6f f9 ff ff       	jmp    8010809b <alltraps>

8010872c <vector12>:
.globl vector12
vector12:
  pushl $12
8010872c:	6a 0c                	push   $0xc
  jmp alltraps
8010872e:	e9 68 f9 ff ff       	jmp    8010809b <alltraps>

80108733 <vector13>:
.globl vector13
vector13:
  pushl $13
80108733:	6a 0d                	push   $0xd
  jmp alltraps
80108735:	e9 61 f9 ff ff       	jmp    8010809b <alltraps>

8010873a <vector14>:
.globl vector14
vector14:
  pushl $14
8010873a:	6a 0e                	push   $0xe
  jmp alltraps
8010873c:	e9 5a f9 ff ff       	jmp    8010809b <alltraps>

80108741 <vector15>:
.globl vector15
vector15:
  pushl $0
80108741:	6a 00                	push   $0x0
  pushl $15
80108743:	6a 0f                	push   $0xf
  jmp alltraps
80108745:	e9 51 f9 ff ff       	jmp    8010809b <alltraps>

8010874a <vector16>:
.globl vector16
vector16:
  pushl $0
8010874a:	6a 00                	push   $0x0
  pushl $16
8010874c:	6a 10                	push   $0x10
  jmp alltraps
8010874e:	e9 48 f9 ff ff       	jmp    8010809b <alltraps>

80108753 <vector17>:
.globl vector17
vector17:
  pushl $17
80108753:	6a 11                	push   $0x11
  jmp alltraps
80108755:	e9 41 f9 ff ff       	jmp    8010809b <alltraps>

8010875a <vector18>:
.globl vector18
vector18:
  pushl $0
8010875a:	6a 00                	push   $0x0
  pushl $18
8010875c:	6a 12                	push   $0x12
  jmp alltraps
8010875e:	e9 38 f9 ff ff       	jmp    8010809b <alltraps>

80108763 <vector19>:
.globl vector19
vector19:
  pushl $0
80108763:	6a 00                	push   $0x0
  pushl $19
80108765:	6a 13                	push   $0x13
  jmp alltraps
80108767:	e9 2f f9 ff ff       	jmp    8010809b <alltraps>

8010876c <vector20>:
.globl vector20
vector20:
  pushl $0
8010876c:	6a 00                	push   $0x0
  pushl $20
8010876e:	6a 14                	push   $0x14
  jmp alltraps
80108770:	e9 26 f9 ff ff       	jmp    8010809b <alltraps>

80108775 <vector21>:
.globl vector21
vector21:
  pushl $0
80108775:	6a 00                	push   $0x0
  pushl $21
80108777:	6a 15                	push   $0x15
  jmp alltraps
80108779:	e9 1d f9 ff ff       	jmp    8010809b <alltraps>

8010877e <vector22>:
.globl vector22
vector22:
  pushl $0
8010877e:	6a 00                	push   $0x0
  pushl $22
80108780:	6a 16                	push   $0x16
  jmp alltraps
80108782:	e9 14 f9 ff ff       	jmp    8010809b <alltraps>

80108787 <vector23>:
.globl vector23
vector23:
  pushl $0
80108787:	6a 00                	push   $0x0
  pushl $23
80108789:	6a 17                	push   $0x17
  jmp alltraps
8010878b:	e9 0b f9 ff ff       	jmp    8010809b <alltraps>

80108790 <vector24>:
.globl vector24
vector24:
  pushl $0
80108790:	6a 00                	push   $0x0
  pushl $24
80108792:	6a 18                	push   $0x18
  jmp alltraps
80108794:	e9 02 f9 ff ff       	jmp    8010809b <alltraps>

80108799 <vector25>:
.globl vector25
vector25:
  pushl $0
80108799:	6a 00                	push   $0x0
  pushl $25
8010879b:	6a 19                	push   $0x19
  jmp alltraps
8010879d:	e9 f9 f8 ff ff       	jmp    8010809b <alltraps>

801087a2 <vector26>:
.globl vector26
vector26:
  pushl $0
801087a2:	6a 00                	push   $0x0
  pushl $26
801087a4:	6a 1a                	push   $0x1a
  jmp alltraps
801087a6:	e9 f0 f8 ff ff       	jmp    8010809b <alltraps>

801087ab <vector27>:
.globl vector27
vector27:
  pushl $0
801087ab:	6a 00                	push   $0x0
  pushl $27
801087ad:	6a 1b                	push   $0x1b
  jmp alltraps
801087af:	e9 e7 f8 ff ff       	jmp    8010809b <alltraps>

801087b4 <vector28>:
.globl vector28
vector28:
  pushl $0
801087b4:	6a 00                	push   $0x0
  pushl $28
801087b6:	6a 1c                	push   $0x1c
  jmp alltraps
801087b8:	e9 de f8 ff ff       	jmp    8010809b <alltraps>

801087bd <vector29>:
.globl vector29
vector29:
  pushl $0
801087bd:	6a 00                	push   $0x0
  pushl $29
801087bf:	6a 1d                	push   $0x1d
  jmp alltraps
801087c1:	e9 d5 f8 ff ff       	jmp    8010809b <alltraps>

801087c6 <vector30>:
.globl vector30
vector30:
  pushl $0
801087c6:	6a 00                	push   $0x0
  pushl $30
801087c8:	6a 1e                	push   $0x1e
  jmp alltraps
801087ca:	e9 cc f8 ff ff       	jmp    8010809b <alltraps>

801087cf <vector31>:
.globl vector31
vector31:
  pushl $0
801087cf:	6a 00                	push   $0x0
  pushl $31
801087d1:	6a 1f                	push   $0x1f
  jmp alltraps
801087d3:	e9 c3 f8 ff ff       	jmp    8010809b <alltraps>

801087d8 <vector32>:
.globl vector32
vector32:
  pushl $0
801087d8:	6a 00                	push   $0x0
  pushl $32
801087da:	6a 20                	push   $0x20
  jmp alltraps
801087dc:	e9 ba f8 ff ff       	jmp    8010809b <alltraps>

801087e1 <vector33>:
.globl vector33
vector33:
  pushl $0
801087e1:	6a 00                	push   $0x0
  pushl $33
801087e3:	6a 21                	push   $0x21
  jmp alltraps
801087e5:	e9 b1 f8 ff ff       	jmp    8010809b <alltraps>

801087ea <vector34>:
.globl vector34
vector34:
  pushl $0
801087ea:	6a 00                	push   $0x0
  pushl $34
801087ec:	6a 22                	push   $0x22
  jmp alltraps
801087ee:	e9 a8 f8 ff ff       	jmp    8010809b <alltraps>

801087f3 <vector35>:
.globl vector35
vector35:
  pushl $0
801087f3:	6a 00                	push   $0x0
  pushl $35
801087f5:	6a 23                	push   $0x23
  jmp alltraps
801087f7:	e9 9f f8 ff ff       	jmp    8010809b <alltraps>

801087fc <vector36>:
.globl vector36
vector36:
  pushl $0
801087fc:	6a 00                	push   $0x0
  pushl $36
801087fe:	6a 24                	push   $0x24
  jmp alltraps
80108800:	e9 96 f8 ff ff       	jmp    8010809b <alltraps>

80108805 <vector37>:
.globl vector37
vector37:
  pushl $0
80108805:	6a 00                	push   $0x0
  pushl $37
80108807:	6a 25                	push   $0x25
  jmp alltraps
80108809:	e9 8d f8 ff ff       	jmp    8010809b <alltraps>

8010880e <vector38>:
.globl vector38
vector38:
  pushl $0
8010880e:	6a 00                	push   $0x0
  pushl $38
80108810:	6a 26                	push   $0x26
  jmp alltraps
80108812:	e9 84 f8 ff ff       	jmp    8010809b <alltraps>

80108817 <vector39>:
.globl vector39
vector39:
  pushl $0
80108817:	6a 00                	push   $0x0
  pushl $39
80108819:	6a 27                	push   $0x27
  jmp alltraps
8010881b:	e9 7b f8 ff ff       	jmp    8010809b <alltraps>

80108820 <vector40>:
.globl vector40
vector40:
  pushl $0
80108820:	6a 00                	push   $0x0
  pushl $40
80108822:	6a 28                	push   $0x28
  jmp alltraps
80108824:	e9 72 f8 ff ff       	jmp    8010809b <alltraps>

80108829 <vector41>:
.globl vector41
vector41:
  pushl $0
80108829:	6a 00                	push   $0x0
  pushl $41
8010882b:	6a 29                	push   $0x29
  jmp alltraps
8010882d:	e9 69 f8 ff ff       	jmp    8010809b <alltraps>

80108832 <vector42>:
.globl vector42
vector42:
  pushl $0
80108832:	6a 00                	push   $0x0
  pushl $42
80108834:	6a 2a                	push   $0x2a
  jmp alltraps
80108836:	e9 60 f8 ff ff       	jmp    8010809b <alltraps>

8010883b <vector43>:
.globl vector43
vector43:
  pushl $0
8010883b:	6a 00                	push   $0x0
  pushl $43
8010883d:	6a 2b                	push   $0x2b
  jmp alltraps
8010883f:	e9 57 f8 ff ff       	jmp    8010809b <alltraps>

80108844 <vector44>:
.globl vector44
vector44:
  pushl $0
80108844:	6a 00                	push   $0x0
  pushl $44
80108846:	6a 2c                	push   $0x2c
  jmp alltraps
80108848:	e9 4e f8 ff ff       	jmp    8010809b <alltraps>

8010884d <vector45>:
.globl vector45
vector45:
  pushl $0
8010884d:	6a 00                	push   $0x0
  pushl $45
8010884f:	6a 2d                	push   $0x2d
  jmp alltraps
80108851:	e9 45 f8 ff ff       	jmp    8010809b <alltraps>

80108856 <vector46>:
.globl vector46
vector46:
  pushl $0
80108856:	6a 00                	push   $0x0
  pushl $46
80108858:	6a 2e                	push   $0x2e
  jmp alltraps
8010885a:	e9 3c f8 ff ff       	jmp    8010809b <alltraps>

8010885f <vector47>:
.globl vector47
vector47:
  pushl $0
8010885f:	6a 00                	push   $0x0
  pushl $47
80108861:	6a 2f                	push   $0x2f
  jmp alltraps
80108863:	e9 33 f8 ff ff       	jmp    8010809b <alltraps>

80108868 <vector48>:
.globl vector48
vector48:
  pushl $0
80108868:	6a 00                	push   $0x0
  pushl $48
8010886a:	6a 30                	push   $0x30
  jmp alltraps
8010886c:	e9 2a f8 ff ff       	jmp    8010809b <alltraps>

80108871 <vector49>:
.globl vector49
vector49:
  pushl $0
80108871:	6a 00                	push   $0x0
  pushl $49
80108873:	6a 31                	push   $0x31
  jmp alltraps
80108875:	e9 21 f8 ff ff       	jmp    8010809b <alltraps>

8010887a <vector50>:
.globl vector50
vector50:
  pushl $0
8010887a:	6a 00                	push   $0x0
  pushl $50
8010887c:	6a 32                	push   $0x32
  jmp alltraps
8010887e:	e9 18 f8 ff ff       	jmp    8010809b <alltraps>

80108883 <vector51>:
.globl vector51
vector51:
  pushl $0
80108883:	6a 00                	push   $0x0
  pushl $51
80108885:	6a 33                	push   $0x33
  jmp alltraps
80108887:	e9 0f f8 ff ff       	jmp    8010809b <alltraps>

8010888c <vector52>:
.globl vector52
vector52:
  pushl $0
8010888c:	6a 00                	push   $0x0
  pushl $52
8010888e:	6a 34                	push   $0x34
  jmp alltraps
80108890:	e9 06 f8 ff ff       	jmp    8010809b <alltraps>

80108895 <vector53>:
.globl vector53
vector53:
  pushl $0
80108895:	6a 00                	push   $0x0
  pushl $53
80108897:	6a 35                	push   $0x35
  jmp alltraps
80108899:	e9 fd f7 ff ff       	jmp    8010809b <alltraps>

8010889e <vector54>:
.globl vector54
vector54:
  pushl $0
8010889e:	6a 00                	push   $0x0
  pushl $54
801088a0:	6a 36                	push   $0x36
  jmp alltraps
801088a2:	e9 f4 f7 ff ff       	jmp    8010809b <alltraps>

801088a7 <vector55>:
.globl vector55
vector55:
  pushl $0
801088a7:	6a 00                	push   $0x0
  pushl $55
801088a9:	6a 37                	push   $0x37
  jmp alltraps
801088ab:	e9 eb f7 ff ff       	jmp    8010809b <alltraps>

801088b0 <vector56>:
.globl vector56
vector56:
  pushl $0
801088b0:	6a 00                	push   $0x0
  pushl $56
801088b2:	6a 38                	push   $0x38
  jmp alltraps
801088b4:	e9 e2 f7 ff ff       	jmp    8010809b <alltraps>

801088b9 <vector57>:
.globl vector57
vector57:
  pushl $0
801088b9:	6a 00                	push   $0x0
  pushl $57
801088bb:	6a 39                	push   $0x39
  jmp alltraps
801088bd:	e9 d9 f7 ff ff       	jmp    8010809b <alltraps>

801088c2 <vector58>:
.globl vector58
vector58:
  pushl $0
801088c2:	6a 00                	push   $0x0
  pushl $58
801088c4:	6a 3a                	push   $0x3a
  jmp alltraps
801088c6:	e9 d0 f7 ff ff       	jmp    8010809b <alltraps>

801088cb <vector59>:
.globl vector59
vector59:
  pushl $0
801088cb:	6a 00                	push   $0x0
  pushl $59
801088cd:	6a 3b                	push   $0x3b
  jmp alltraps
801088cf:	e9 c7 f7 ff ff       	jmp    8010809b <alltraps>

801088d4 <vector60>:
.globl vector60
vector60:
  pushl $0
801088d4:	6a 00                	push   $0x0
  pushl $60
801088d6:	6a 3c                	push   $0x3c
  jmp alltraps
801088d8:	e9 be f7 ff ff       	jmp    8010809b <alltraps>

801088dd <vector61>:
.globl vector61
vector61:
  pushl $0
801088dd:	6a 00                	push   $0x0
  pushl $61
801088df:	6a 3d                	push   $0x3d
  jmp alltraps
801088e1:	e9 b5 f7 ff ff       	jmp    8010809b <alltraps>

801088e6 <vector62>:
.globl vector62
vector62:
  pushl $0
801088e6:	6a 00                	push   $0x0
  pushl $62
801088e8:	6a 3e                	push   $0x3e
  jmp alltraps
801088ea:	e9 ac f7 ff ff       	jmp    8010809b <alltraps>

801088ef <vector63>:
.globl vector63
vector63:
  pushl $0
801088ef:	6a 00                	push   $0x0
  pushl $63
801088f1:	6a 3f                	push   $0x3f
  jmp alltraps
801088f3:	e9 a3 f7 ff ff       	jmp    8010809b <alltraps>

801088f8 <vector64>:
.globl vector64
vector64:
  pushl $0
801088f8:	6a 00                	push   $0x0
  pushl $64
801088fa:	6a 40                	push   $0x40
  jmp alltraps
801088fc:	e9 9a f7 ff ff       	jmp    8010809b <alltraps>

80108901 <vector65>:
.globl vector65
vector65:
  pushl $0
80108901:	6a 00                	push   $0x0
  pushl $65
80108903:	6a 41                	push   $0x41
  jmp alltraps
80108905:	e9 91 f7 ff ff       	jmp    8010809b <alltraps>

8010890a <vector66>:
.globl vector66
vector66:
  pushl $0
8010890a:	6a 00                	push   $0x0
  pushl $66
8010890c:	6a 42                	push   $0x42
  jmp alltraps
8010890e:	e9 88 f7 ff ff       	jmp    8010809b <alltraps>

80108913 <vector67>:
.globl vector67
vector67:
  pushl $0
80108913:	6a 00                	push   $0x0
  pushl $67
80108915:	6a 43                	push   $0x43
  jmp alltraps
80108917:	e9 7f f7 ff ff       	jmp    8010809b <alltraps>

8010891c <vector68>:
.globl vector68
vector68:
  pushl $0
8010891c:	6a 00                	push   $0x0
  pushl $68
8010891e:	6a 44                	push   $0x44
  jmp alltraps
80108920:	e9 76 f7 ff ff       	jmp    8010809b <alltraps>

80108925 <vector69>:
.globl vector69
vector69:
  pushl $0
80108925:	6a 00                	push   $0x0
  pushl $69
80108927:	6a 45                	push   $0x45
  jmp alltraps
80108929:	e9 6d f7 ff ff       	jmp    8010809b <alltraps>

8010892e <vector70>:
.globl vector70
vector70:
  pushl $0
8010892e:	6a 00                	push   $0x0
  pushl $70
80108930:	6a 46                	push   $0x46
  jmp alltraps
80108932:	e9 64 f7 ff ff       	jmp    8010809b <alltraps>

80108937 <vector71>:
.globl vector71
vector71:
  pushl $0
80108937:	6a 00                	push   $0x0
  pushl $71
80108939:	6a 47                	push   $0x47
  jmp alltraps
8010893b:	e9 5b f7 ff ff       	jmp    8010809b <alltraps>

80108940 <vector72>:
.globl vector72
vector72:
  pushl $0
80108940:	6a 00                	push   $0x0
  pushl $72
80108942:	6a 48                	push   $0x48
  jmp alltraps
80108944:	e9 52 f7 ff ff       	jmp    8010809b <alltraps>

80108949 <vector73>:
.globl vector73
vector73:
  pushl $0
80108949:	6a 00                	push   $0x0
  pushl $73
8010894b:	6a 49                	push   $0x49
  jmp alltraps
8010894d:	e9 49 f7 ff ff       	jmp    8010809b <alltraps>

80108952 <vector74>:
.globl vector74
vector74:
  pushl $0
80108952:	6a 00                	push   $0x0
  pushl $74
80108954:	6a 4a                	push   $0x4a
  jmp alltraps
80108956:	e9 40 f7 ff ff       	jmp    8010809b <alltraps>

8010895b <vector75>:
.globl vector75
vector75:
  pushl $0
8010895b:	6a 00                	push   $0x0
  pushl $75
8010895d:	6a 4b                	push   $0x4b
  jmp alltraps
8010895f:	e9 37 f7 ff ff       	jmp    8010809b <alltraps>

80108964 <vector76>:
.globl vector76
vector76:
  pushl $0
80108964:	6a 00                	push   $0x0
  pushl $76
80108966:	6a 4c                	push   $0x4c
  jmp alltraps
80108968:	e9 2e f7 ff ff       	jmp    8010809b <alltraps>

8010896d <vector77>:
.globl vector77
vector77:
  pushl $0
8010896d:	6a 00                	push   $0x0
  pushl $77
8010896f:	6a 4d                	push   $0x4d
  jmp alltraps
80108971:	e9 25 f7 ff ff       	jmp    8010809b <alltraps>

80108976 <vector78>:
.globl vector78
vector78:
  pushl $0
80108976:	6a 00                	push   $0x0
  pushl $78
80108978:	6a 4e                	push   $0x4e
  jmp alltraps
8010897a:	e9 1c f7 ff ff       	jmp    8010809b <alltraps>

8010897f <vector79>:
.globl vector79
vector79:
  pushl $0
8010897f:	6a 00                	push   $0x0
  pushl $79
80108981:	6a 4f                	push   $0x4f
  jmp alltraps
80108983:	e9 13 f7 ff ff       	jmp    8010809b <alltraps>

80108988 <vector80>:
.globl vector80
vector80:
  pushl $0
80108988:	6a 00                	push   $0x0
  pushl $80
8010898a:	6a 50                	push   $0x50
  jmp alltraps
8010898c:	e9 0a f7 ff ff       	jmp    8010809b <alltraps>

80108991 <vector81>:
.globl vector81
vector81:
  pushl $0
80108991:	6a 00                	push   $0x0
  pushl $81
80108993:	6a 51                	push   $0x51
  jmp alltraps
80108995:	e9 01 f7 ff ff       	jmp    8010809b <alltraps>

8010899a <vector82>:
.globl vector82
vector82:
  pushl $0
8010899a:	6a 00                	push   $0x0
  pushl $82
8010899c:	6a 52                	push   $0x52
  jmp alltraps
8010899e:	e9 f8 f6 ff ff       	jmp    8010809b <alltraps>

801089a3 <vector83>:
.globl vector83
vector83:
  pushl $0
801089a3:	6a 00                	push   $0x0
  pushl $83
801089a5:	6a 53                	push   $0x53
  jmp alltraps
801089a7:	e9 ef f6 ff ff       	jmp    8010809b <alltraps>

801089ac <vector84>:
.globl vector84
vector84:
  pushl $0
801089ac:	6a 00                	push   $0x0
  pushl $84
801089ae:	6a 54                	push   $0x54
  jmp alltraps
801089b0:	e9 e6 f6 ff ff       	jmp    8010809b <alltraps>

801089b5 <vector85>:
.globl vector85
vector85:
  pushl $0
801089b5:	6a 00                	push   $0x0
  pushl $85
801089b7:	6a 55                	push   $0x55
  jmp alltraps
801089b9:	e9 dd f6 ff ff       	jmp    8010809b <alltraps>

801089be <vector86>:
.globl vector86
vector86:
  pushl $0
801089be:	6a 00                	push   $0x0
  pushl $86
801089c0:	6a 56                	push   $0x56
  jmp alltraps
801089c2:	e9 d4 f6 ff ff       	jmp    8010809b <alltraps>

801089c7 <vector87>:
.globl vector87
vector87:
  pushl $0
801089c7:	6a 00                	push   $0x0
  pushl $87
801089c9:	6a 57                	push   $0x57
  jmp alltraps
801089cb:	e9 cb f6 ff ff       	jmp    8010809b <alltraps>

801089d0 <vector88>:
.globl vector88
vector88:
  pushl $0
801089d0:	6a 00                	push   $0x0
  pushl $88
801089d2:	6a 58                	push   $0x58
  jmp alltraps
801089d4:	e9 c2 f6 ff ff       	jmp    8010809b <alltraps>

801089d9 <vector89>:
.globl vector89
vector89:
  pushl $0
801089d9:	6a 00                	push   $0x0
  pushl $89
801089db:	6a 59                	push   $0x59
  jmp alltraps
801089dd:	e9 b9 f6 ff ff       	jmp    8010809b <alltraps>

801089e2 <vector90>:
.globl vector90
vector90:
  pushl $0
801089e2:	6a 00                	push   $0x0
  pushl $90
801089e4:	6a 5a                	push   $0x5a
  jmp alltraps
801089e6:	e9 b0 f6 ff ff       	jmp    8010809b <alltraps>

801089eb <vector91>:
.globl vector91
vector91:
  pushl $0
801089eb:	6a 00                	push   $0x0
  pushl $91
801089ed:	6a 5b                	push   $0x5b
  jmp alltraps
801089ef:	e9 a7 f6 ff ff       	jmp    8010809b <alltraps>

801089f4 <vector92>:
.globl vector92
vector92:
  pushl $0
801089f4:	6a 00                	push   $0x0
  pushl $92
801089f6:	6a 5c                	push   $0x5c
  jmp alltraps
801089f8:	e9 9e f6 ff ff       	jmp    8010809b <alltraps>

801089fd <vector93>:
.globl vector93
vector93:
  pushl $0
801089fd:	6a 00                	push   $0x0
  pushl $93
801089ff:	6a 5d                	push   $0x5d
  jmp alltraps
80108a01:	e9 95 f6 ff ff       	jmp    8010809b <alltraps>

80108a06 <vector94>:
.globl vector94
vector94:
  pushl $0
80108a06:	6a 00                	push   $0x0
  pushl $94
80108a08:	6a 5e                	push   $0x5e
  jmp alltraps
80108a0a:	e9 8c f6 ff ff       	jmp    8010809b <alltraps>

80108a0f <vector95>:
.globl vector95
vector95:
  pushl $0
80108a0f:	6a 00                	push   $0x0
  pushl $95
80108a11:	6a 5f                	push   $0x5f
  jmp alltraps
80108a13:	e9 83 f6 ff ff       	jmp    8010809b <alltraps>

80108a18 <vector96>:
.globl vector96
vector96:
  pushl $0
80108a18:	6a 00                	push   $0x0
  pushl $96
80108a1a:	6a 60                	push   $0x60
  jmp alltraps
80108a1c:	e9 7a f6 ff ff       	jmp    8010809b <alltraps>

80108a21 <vector97>:
.globl vector97
vector97:
  pushl $0
80108a21:	6a 00                	push   $0x0
  pushl $97
80108a23:	6a 61                	push   $0x61
  jmp alltraps
80108a25:	e9 71 f6 ff ff       	jmp    8010809b <alltraps>

80108a2a <vector98>:
.globl vector98
vector98:
  pushl $0
80108a2a:	6a 00                	push   $0x0
  pushl $98
80108a2c:	6a 62                	push   $0x62
  jmp alltraps
80108a2e:	e9 68 f6 ff ff       	jmp    8010809b <alltraps>

80108a33 <vector99>:
.globl vector99
vector99:
  pushl $0
80108a33:	6a 00                	push   $0x0
  pushl $99
80108a35:	6a 63                	push   $0x63
  jmp alltraps
80108a37:	e9 5f f6 ff ff       	jmp    8010809b <alltraps>

80108a3c <vector100>:
.globl vector100
vector100:
  pushl $0
80108a3c:	6a 00                	push   $0x0
  pushl $100
80108a3e:	6a 64                	push   $0x64
  jmp alltraps
80108a40:	e9 56 f6 ff ff       	jmp    8010809b <alltraps>

80108a45 <vector101>:
.globl vector101
vector101:
  pushl $0
80108a45:	6a 00                	push   $0x0
  pushl $101
80108a47:	6a 65                	push   $0x65
  jmp alltraps
80108a49:	e9 4d f6 ff ff       	jmp    8010809b <alltraps>

80108a4e <vector102>:
.globl vector102
vector102:
  pushl $0
80108a4e:	6a 00                	push   $0x0
  pushl $102
80108a50:	6a 66                	push   $0x66
  jmp alltraps
80108a52:	e9 44 f6 ff ff       	jmp    8010809b <alltraps>

80108a57 <vector103>:
.globl vector103
vector103:
  pushl $0
80108a57:	6a 00                	push   $0x0
  pushl $103
80108a59:	6a 67                	push   $0x67
  jmp alltraps
80108a5b:	e9 3b f6 ff ff       	jmp    8010809b <alltraps>

80108a60 <vector104>:
.globl vector104
vector104:
  pushl $0
80108a60:	6a 00                	push   $0x0
  pushl $104
80108a62:	6a 68                	push   $0x68
  jmp alltraps
80108a64:	e9 32 f6 ff ff       	jmp    8010809b <alltraps>

80108a69 <vector105>:
.globl vector105
vector105:
  pushl $0
80108a69:	6a 00                	push   $0x0
  pushl $105
80108a6b:	6a 69                	push   $0x69
  jmp alltraps
80108a6d:	e9 29 f6 ff ff       	jmp    8010809b <alltraps>

80108a72 <vector106>:
.globl vector106
vector106:
  pushl $0
80108a72:	6a 00                	push   $0x0
  pushl $106
80108a74:	6a 6a                	push   $0x6a
  jmp alltraps
80108a76:	e9 20 f6 ff ff       	jmp    8010809b <alltraps>

80108a7b <vector107>:
.globl vector107
vector107:
  pushl $0
80108a7b:	6a 00                	push   $0x0
  pushl $107
80108a7d:	6a 6b                	push   $0x6b
  jmp alltraps
80108a7f:	e9 17 f6 ff ff       	jmp    8010809b <alltraps>

80108a84 <vector108>:
.globl vector108
vector108:
  pushl $0
80108a84:	6a 00                	push   $0x0
  pushl $108
80108a86:	6a 6c                	push   $0x6c
  jmp alltraps
80108a88:	e9 0e f6 ff ff       	jmp    8010809b <alltraps>

80108a8d <vector109>:
.globl vector109
vector109:
  pushl $0
80108a8d:	6a 00                	push   $0x0
  pushl $109
80108a8f:	6a 6d                	push   $0x6d
  jmp alltraps
80108a91:	e9 05 f6 ff ff       	jmp    8010809b <alltraps>

80108a96 <vector110>:
.globl vector110
vector110:
  pushl $0
80108a96:	6a 00                	push   $0x0
  pushl $110
80108a98:	6a 6e                	push   $0x6e
  jmp alltraps
80108a9a:	e9 fc f5 ff ff       	jmp    8010809b <alltraps>

80108a9f <vector111>:
.globl vector111
vector111:
  pushl $0
80108a9f:	6a 00                	push   $0x0
  pushl $111
80108aa1:	6a 6f                	push   $0x6f
  jmp alltraps
80108aa3:	e9 f3 f5 ff ff       	jmp    8010809b <alltraps>

80108aa8 <vector112>:
.globl vector112
vector112:
  pushl $0
80108aa8:	6a 00                	push   $0x0
  pushl $112
80108aaa:	6a 70                	push   $0x70
  jmp alltraps
80108aac:	e9 ea f5 ff ff       	jmp    8010809b <alltraps>

80108ab1 <vector113>:
.globl vector113
vector113:
  pushl $0
80108ab1:	6a 00                	push   $0x0
  pushl $113
80108ab3:	6a 71                	push   $0x71
  jmp alltraps
80108ab5:	e9 e1 f5 ff ff       	jmp    8010809b <alltraps>

80108aba <vector114>:
.globl vector114
vector114:
  pushl $0
80108aba:	6a 00                	push   $0x0
  pushl $114
80108abc:	6a 72                	push   $0x72
  jmp alltraps
80108abe:	e9 d8 f5 ff ff       	jmp    8010809b <alltraps>

80108ac3 <vector115>:
.globl vector115
vector115:
  pushl $0
80108ac3:	6a 00                	push   $0x0
  pushl $115
80108ac5:	6a 73                	push   $0x73
  jmp alltraps
80108ac7:	e9 cf f5 ff ff       	jmp    8010809b <alltraps>

80108acc <vector116>:
.globl vector116
vector116:
  pushl $0
80108acc:	6a 00                	push   $0x0
  pushl $116
80108ace:	6a 74                	push   $0x74
  jmp alltraps
80108ad0:	e9 c6 f5 ff ff       	jmp    8010809b <alltraps>

80108ad5 <vector117>:
.globl vector117
vector117:
  pushl $0
80108ad5:	6a 00                	push   $0x0
  pushl $117
80108ad7:	6a 75                	push   $0x75
  jmp alltraps
80108ad9:	e9 bd f5 ff ff       	jmp    8010809b <alltraps>

80108ade <vector118>:
.globl vector118
vector118:
  pushl $0
80108ade:	6a 00                	push   $0x0
  pushl $118
80108ae0:	6a 76                	push   $0x76
  jmp alltraps
80108ae2:	e9 b4 f5 ff ff       	jmp    8010809b <alltraps>

80108ae7 <vector119>:
.globl vector119
vector119:
  pushl $0
80108ae7:	6a 00                	push   $0x0
  pushl $119
80108ae9:	6a 77                	push   $0x77
  jmp alltraps
80108aeb:	e9 ab f5 ff ff       	jmp    8010809b <alltraps>

80108af0 <vector120>:
.globl vector120
vector120:
  pushl $0
80108af0:	6a 00                	push   $0x0
  pushl $120
80108af2:	6a 78                	push   $0x78
  jmp alltraps
80108af4:	e9 a2 f5 ff ff       	jmp    8010809b <alltraps>

80108af9 <vector121>:
.globl vector121
vector121:
  pushl $0
80108af9:	6a 00                	push   $0x0
  pushl $121
80108afb:	6a 79                	push   $0x79
  jmp alltraps
80108afd:	e9 99 f5 ff ff       	jmp    8010809b <alltraps>

80108b02 <vector122>:
.globl vector122
vector122:
  pushl $0
80108b02:	6a 00                	push   $0x0
  pushl $122
80108b04:	6a 7a                	push   $0x7a
  jmp alltraps
80108b06:	e9 90 f5 ff ff       	jmp    8010809b <alltraps>

80108b0b <vector123>:
.globl vector123
vector123:
  pushl $0
80108b0b:	6a 00                	push   $0x0
  pushl $123
80108b0d:	6a 7b                	push   $0x7b
  jmp alltraps
80108b0f:	e9 87 f5 ff ff       	jmp    8010809b <alltraps>

80108b14 <vector124>:
.globl vector124
vector124:
  pushl $0
80108b14:	6a 00                	push   $0x0
  pushl $124
80108b16:	6a 7c                	push   $0x7c
  jmp alltraps
80108b18:	e9 7e f5 ff ff       	jmp    8010809b <alltraps>

80108b1d <vector125>:
.globl vector125
vector125:
  pushl $0
80108b1d:	6a 00                	push   $0x0
  pushl $125
80108b1f:	6a 7d                	push   $0x7d
  jmp alltraps
80108b21:	e9 75 f5 ff ff       	jmp    8010809b <alltraps>

80108b26 <vector126>:
.globl vector126
vector126:
  pushl $0
80108b26:	6a 00                	push   $0x0
  pushl $126
80108b28:	6a 7e                	push   $0x7e
  jmp alltraps
80108b2a:	e9 6c f5 ff ff       	jmp    8010809b <alltraps>

80108b2f <vector127>:
.globl vector127
vector127:
  pushl $0
80108b2f:	6a 00                	push   $0x0
  pushl $127
80108b31:	6a 7f                	push   $0x7f
  jmp alltraps
80108b33:	e9 63 f5 ff ff       	jmp    8010809b <alltraps>

80108b38 <vector128>:
.globl vector128
vector128:
  pushl $0
80108b38:	6a 00                	push   $0x0
  pushl $128
80108b3a:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108b3f:	e9 57 f5 ff ff       	jmp    8010809b <alltraps>

80108b44 <vector129>:
.globl vector129
vector129:
  pushl $0
80108b44:	6a 00                	push   $0x0
  pushl $129
80108b46:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108b4b:	e9 4b f5 ff ff       	jmp    8010809b <alltraps>

80108b50 <vector130>:
.globl vector130
vector130:
  pushl $0
80108b50:	6a 00                	push   $0x0
  pushl $130
80108b52:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108b57:	e9 3f f5 ff ff       	jmp    8010809b <alltraps>

80108b5c <vector131>:
.globl vector131
vector131:
  pushl $0
80108b5c:	6a 00                	push   $0x0
  pushl $131
80108b5e:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108b63:	e9 33 f5 ff ff       	jmp    8010809b <alltraps>

80108b68 <vector132>:
.globl vector132
vector132:
  pushl $0
80108b68:	6a 00                	push   $0x0
  pushl $132
80108b6a:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108b6f:	e9 27 f5 ff ff       	jmp    8010809b <alltraps>

80108b74 <vector133>:
.globl vector133
vector133:
  pushl $0
80108b74:	6a 00                	push   $0x0
  pushl $133
80108b76:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108b7b:	e9 1b f5 ff ff       	jmp    8010809b <alltraps>

80108b80 <vector134>:
.globl vector134
vector134:
  pushl $0
80108b80:	6a 00                	push   $0x0
  pushl $134
80108b82:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108b87:	e9 0f f5 ff ff       	jmp    8010809b <alltraps>

80108b8c <vector135>:
.globl vector135
vector135:
  pushl $0
80108b8c:	6a 00                	push   $0x0
  pushl $135
80108b8e:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108b93:	e9 03 f5 ff ff       	jmp    8010809b <alltraps>

80108b98 <vector136>:
.globl vector136
vector136:
  pushl $0
80108b98:	6a 00                	push   $0x0
  pushl $136
80108b9a:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108b9f:	e9 f7 f4 ff ff       	jmp    8010809b <alltraps>

80108ba4 <vector137>:
.globl vector137
vector137:
  pushl $0
80108ba4:	6a 00                	push   $0x0
  pushl $137
80108ba6:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108bab:	e9 eb f4 ff ff       	jmp    8010809b <alltraps>

80108bb0 <vector138>:
.globl vector138
vector138:
  pushl $0
80108bb0:	6a 00                	push   $0x0
  pushl $138
80108bb2:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108bb7:	e9 df f4 ff ff       	jmp    8010809b <alltraps>

80108bbc <vector139>:
.globl vector139
vector139:
  pushl $0
80108bbc:	6a 00                	push   $0x0
  pushl $139
80108bbe:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108bc3:	e9 d3 f4 ff ff       	jmp    8010809b <alltraps>

80108bc8 <vector140>:
.globl vector140
vector140:
  pushl $0
80108bc8:	6a 00                	push   $0x0
  pushl $140
80108bca:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108bcf:	e9 c7 f4 ff ff       	jmp    8010809b <alltraps>

80108bd4 <vector141>:
.globl vector141
vector141:
  pushl $0
80108bd4:	6a 00                	push   $0x0
  pushl $141
80108bd6:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108bdb:	e9 bb f4 ff ff       	jmp    8010809b <alltraps>

80108be0 <vector142>:
.globl vector142
vector142:
  pushl $0
80108be0:	6a 00                	push   $0x0
  pushl $142
80108be2:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108be7:	e9 af f4 ff ff       	jmp    8010809b <alltraps>

80108bec <vector143>:
.globl vector143
vector143:
  pushl $0
80108bec:	6a 00                	push   $0x0
  pushl $143
80108bee:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108bf3:	e9 a3 f4 ff ff       	jmp    8010809b <alltraps>

80108bf8 <vector144>:
.globl vector144
vector144:
  pushl $0
80108bf8:	6a 00                	push   $0x0
  pushl $144
80108bfa:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108bff:	e9 97 f4 ff ff       	jmp    8010809b <alltraps>

80108c04 <vector145>:
.globl vector145
vector145:
  pushl $0
80108c04:	6a 00                	push   $0x0
  pushl $145
80108c06:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108c0b:	e9 8b f4 ff ff       	jmp    8010809b <alltraps>

80108c10 <vector146>:
.globl vector146
vector146:
  pushl $0
80108c10:	6a 00                	push   $0x0
  pushl $146
80108c12:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108c17:	e9 7f f4 ff ff       	jmp    8010809b <alltraps>

80108c1c <vector147>:
.globl vector147
vector147:
  pushl $0
80108c1c:	6a 00                	push   $0x0
  pushl $147
80108c1e:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108c23:	e9 73 f4 ff ff       	jmp    8010809b <alltraps>

80108c28 <vector148>:
.globl vector148
vector148:
  pushl $0
80108c28:	6a 00                	push   $0x0
  pushl $148
80108c2a:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108c2f:	e9 67 f4 ff ff       	jmp    8010809b <alltraps>

80108c34 <vector149>:
.globl vector149
vector149:
  pushl $0
80108c34:	6a 00                	push   $0x0
  pushl $149
80108c36:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108c3b:	e9 5b f4 ff ff       	jmp    8010809b <alltraps>

80108c40 <vector150>:
.globl vector150
vector150:
  pushl $0
80108c40:	6a 00                	push   $0x0
  pushl $150
80108c42:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108c47:	e9 4f f4 ff ff       	jmp    8010809b <alltraps>

80108c4c <vector151>:
.globl vector151
vector151:
  pushl $0
80108c4c:	6a 00                	push   $0x0
  pushl $151
80108c4e:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108c53:	e9 43 f4 ff ff       	jmp    8010809b <alltraps>

80108c58 <vector152>:
.globl vector152
vector152:
  pushl $0
80108c58:	6a 00                	push   $0x0
  pushl $152
80108c5a:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108c5f:	e9 37 f4 ff ff       	jmp    8010809b <alltraps>

80108c64 <vector153>:
.globl vector153
vector153:
  pushl $0
80108c64:	6a 00                	push   $0x0
  pushl $153
80108c66:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108c6b:	e9 2b f4 ff ff       	jmp    8010809b <alltraps>

80108c70 <vector154>:
.globl vector154
vector154:
  pushl $0
80108c70:	6a 00                	push   $0x0
  pushl $154
80108c72:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108c77:	e9 1f f4 ff ff       	jmp    8010809b <alltraps>

80108c7c <vector155>:
.globl vector155
vector155:
  pushl $0
80108c7c:	6a 00                	push   $0x0
  pushl $155
80108c7e:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108c83:	e9 13 f4 ff ff       	jmp    8010809b <alltraps>

80108c88 <vector156>:
.globl vector156
vector156:
  pushl $0
80108c88:	6a 00                	push   $0x0
  pushl $156
80108c8a:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108c8f:	e9 07 f4 ff ff       	jmp    8010809b <alltraps>

80108c94 <vector157>:
.globl vector157
vector157:
  pushl $0
80108c94:	6a 00                	push   $0x0
  pushl $157
80108c96:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108c9b:	e9 fb f3 ff ff       	jmp    8010809b <alltraps>

80108ca0 <vector158>:
.globl vector158
vector158:
  pushl $0
80108ca0:	6a 00                	push   $0x0
  pushl $158
80108ca2:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108ca7:	e9 ef f3 ff ff       	jmp    8010809b <alltraps>

80108cac <vector159>:
.globl vector159
vector159:
  pushl $0
80108cac:	6a 00                	push   $0x0
  pushl $159
80108cae:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108cb3:	e9 e3 f3 ff ff       	jmp    8010809b <alltraps>

80108cb8 <vector160>:
.globl vector160
vector160:
  pushl $0
80108cb8:	6a 00                	push   $0x0
  pushl $160
80108cba:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108cbf:	e9 d7 f3 ff ff       	jmp    8010809b <alltraps>

80108cc4 <vector161>:
.globl vector161
vector161:
  pushl $0
80108cc4:	6a 00                	push   $0x0
  pushl $161
80108cc6:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108ccb:	e9 cb f3 ff ff       	jmp    8010809b <alltraps>

80108cd0 <vector162>:
.globl vector162
vector162:
  pushl $0
80108cd0:	6a 00                	push   $0x0
  pushl $162
80108cd2:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108cd7:	e9 bf f3 ff ff       	jmp    8010809b <alltraps>

80108cdc <vector163>:
.globl vector163
vector163:
  pushl $0
80108cdc:	6a 00                	push   $0x0
  pushl $163
80108cde:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108ce3:	e9 b3 f3 ff ff       	jmp    8010809b <alltraps>

80108ce8 <vector164>:
.globl vector164
vector164:
  pushl $0
80108ce8:	6a 00                	push   $0x0
  pushl $164
80108cea:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108cef:	e9 a7 f3 ff ff       	jmp    8010809b <alltraps>

80108cf4 <vector165>:
.globl vector165
vector165:
  pushl $0
80108cf4:	6a 00                	push   $0x0
  pushl $165
80108cf6:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108cfb:	e9 9b f3 ff ff       	jmp    8010809b <alltraps>

80108d00 <vector166>:
.globl vector166
vector166:
  pushl $0
80108d00:	6a 00                	push   $0x0
  pushl $166
80108d02:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108d07:	e9 8f f3 ff ff       	jmp    8010809b <alltraps>

80108d0c <vector167>:
.globl vector167
vector167:
  pushl $0
80108d0c:	6a 00                	push   $0x0
  pushl $167
80108d0e:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108d13:	e9 83 f3 ff ff       	jmp    8010809b <alltraps>

80108d18 <vector168>:
.globl vector168
vector168:
  pushl $0
80108d18:	6a 00                	push   $0x0
  pushl $168
80108d1a:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108d1f:	e9 77 f3 ff ff       	jmp    8010809b <alltraps>

80108d24 <vector169>:
.globl vector169
vector169:
  pushl $0
80108d24:	6a 00                	push   $0x0
  pushl $169
80108d26:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108d2b:	e9 6b f3 ff ff       	jmp    8010809b <alltraps>

80108d30 <vector170>:
.globl vector170
vector170:
  pushl $0
80108d30:	6a 00                	push   $0x0
  pushl $170
80108d32:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108d37:	e9 5f f3 ff ff       	jmp    8010809b <alltraps>

80108d3c <vector171>:
.globl vector171
vector171:
  pushl $0
80108d3c:	6a 00                	push   $0x0
  pushl $171
80108d3e:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108d43:	e9 53 f3 ff ff       	jmp    8010809b <alltraps>

80108d48 <vector172>:
.globl vector172
vector172:
  pushl $0
80108d48:	6a 00                	push   $0x0
  pushl $172
80108d4a:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108d4f:	e9 47 f3 ff ff       	jmp    8010809b <alltraps>

80108d54 <vector173>:
.globl vector173
vector173:
  pushl $0
80108d54:	6a 00                	push   $0x0
  pushl $173
80108d56:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108d5b:	e9 3b f3 ff ff       	jmp    8010809b <alltraps>

80108d60 <vector174>:
.globl vector174
vector174:
  pushl $0
80108d60:	6a 00                	push   $0x0
  pushl $174
80108d62:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108d67:	e9 2f f3 ff ff       	jmp    8010809b <alltraps>

80108d6c <vector175>:
.globl vector175
vector175:
  pushl $0
80108d6c:	6a 00                	push   $0x0
  pushl $175
80108d6e:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108d73:	e9 23 f3 ff ff       	jmp    8010809b <alltraps>

80108d78 <vector176>:
.globl vector176
vector176:
  pushl $0
80108d78:	6a 00                	push   $0x0
  pushl $176
80108d7a:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108d7f:	e9 17 f3 ff ff       	jmp    8010809b <alltraps>

80108d84 <vector177>:
.globl vector177
vector177:
  pushl $0
80108d84:	6a 00                	push   $0x0
  pushl $177
80108d86:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108d8b:	e9 0b f3 ff ff       	jmp    8010809b <alltraps>

80108d90 <vector178>:
.globl vector178
vector178:
  pushl $0
80108d90:	6a 00                	push   $0x0
  pushl $178
80108d92:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108d97:	e9 ff f2 ff ff       	jmp    8010809b <alltraps>

80108d9c <vector179>:
.globl vector179
vector179:
  pushl $0
80108d9c:	6a 00                	push   $0x0
  pushl $179
80108d9e:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108da3:	e9 f3 f2 ff ff       	jmp    8010809b <alltraps>

80108da8 <vector180>:
.globl vector180
vector180:
  pushl $0
80108da8:	6a 00                	push   $0x0
  pushl $180
80108daa:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108daf:	e9 e7 f2 ff ff       	jmp    8010809b <alltraps>

80108db4 <vector181>:
.globl vector181
vector181:
  pushl $0
80108db4:	6a 00                	push   $0x0
  pushl $181
80108db6:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108dbb:	e9 db f2 ff ff       	jmp    8010809b <alltraps>

80108dc0 <vector182>:
.globl vector182
vector182:
  pushl $0
80108dc0:	6a 00                	push   $0x0
  pushl $182
80108dc2:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108dc7:	e9 cf f2 ff ff       	jmp    8010809b <alltraps>

80108dcc <vector183>:
.globl vector183
vector183:
  pushl $0
80108dcc:	6a 00                	push   $0x0
  pushl $183
80108dce:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108dd3:	e9 c3 f2 ff ff       	jmp    8010809b <alltraps>

80108dd8 <vector184>:
.globl vector184
vector184:
  pushl $0
80108dd8:	6a 00                	push   $0x0
  pushl $184
80108dda:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108ddf:	e9 b7 f2 ff ff       	jmp    8010809b <alltraps>

80108de4 <vector185>:
.globl vector185
vector185:
  pushl $0
80108de4:	6a 00                	push   $0x0
  pushl $185
80108de6:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108deb:	e9 ab f2 ff ff       	jmp    8010809b <alltraps>

80108df0 <vector186>:
.globl vector186
vector186:
  pushl $0
80108df0:	6a 00                	push   $0x0
  pushl $186
80108df2:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108df7:	e9 9f f2 ff ff       	jmp    8010809b <alltraps>

80108dfc <vector187>:
.globl vector187
vector187:
  pushl $0
80108dfc:	6a 00                	push   $0x0
  pushl $187
80108dfe:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108e03:	e9 93 f2 ff ff       	jmp    8010809b <alltraps>

80108e08 <vector188>:
.globl vector188
vector188:
  pushl $0
80108e08:	6a 00                	push   $0x0
  pushl $188
80108e0a:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108e0f:	e9 87 f2 ff ff       	jmp    8010809b <alltraps>

80108e14 <vector189>:
.globl vector189
vector189:
  pushl $0
80108e14:	6a 00                	push   $0x0
  pushl $189
80108e16:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108e1b:	e9 7b f2 ff ff       	jmp    8010809b <alltraps>

80108e20 <vector190>:
.globl vector190
vector190:
  pushl $0
80108e20:	6a 00                	push   $0x0
  pushl $190
80108e22:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108e27:	e9 6f f2 ff ff       	jmp    8010809b <alltraps>

80108e2c <vector191>:
.globl vector191
vector191:
  pushl $0
80108e2c:	6a 00                	push   $0x0
  pushl $191
80108e2e:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108e33:	e9 63 f2 ff ff       	jmp    8010809b <alltraps>

80108e38 <vector192>:
.globl vector192
vector192:
  pushl $0
80108e38:	6a 00                	push   $0x0
  pushl $192
80108e3a:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108e3f:	e9 57 f2 ff ff       	jmp    8010809b <alltraps>

80108e44 <vector193>:
.globl vector193
vector193:
  pushl $0
80108e44:	6a 00                	push   $0x0
  pushl $193
80108e46:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108e4b:	e9 4b f2 ff ff       	jmp    8010809b <alltraps>

80108e50 <vector194>:
.globl vector194
vector194:
  pushl $0
80108e50:	6a 00                	push   $0x0
  pushl $194
80108e52:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108e57:	e9 3f f2 ff ff       	jmp    8010809b <alltraps>

80108e5c <vector195>:
.globl vector195
vector195:
  pushl $0
80108e5c:	6a 00                	push   $0x0
  pushl $195
80108e5e:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108e63:	e9 33 f2 ff ff       	jmp    8010809b <alltraps>

80108e68 <vector196>:
.globl vector196
vector196:
  pushl $0
80108e68:	6a 00                	push   $0x0
  pushl $196
80108e6a:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108e6f:	e9 27 f2 ff ff       	jmp    8010809b <alltraps>

80108e74 <vector197>:
.globl vector197
vector197:
  pushl $0
80108e74:	6a 00                	push   $0x0
  pushl $197
80108e76:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108e7b:	e9 1b f2 ff ff       	jmp    8010809b <alltraps>

80108e80 <vector198>:
.globl vector198
vector198:
  pushl $0
80108e80:	6a 00                	push   $0x0
  pushl $198
80108e82:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108e87:	e9 0f f2 ff ff       	jmp    8010809b <alltraps>

80108e8c <vector199>:
.globl vector199
vector199:
  pushl $0
80108e8c:	6a 00                	push   $0x0
  pushl $199
80108e8e:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108e93:	e9 03 f2 ff ff       	jmp    8010809b <alltraps>

80108e98 <vector200>:
.globl vector200
vector200:
  pushl $0
80108e98:	6a 00                	push   $0x0
  pushl $200
80108e9a:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108e9f:	e9 f7 f1 ff ff       	jmp    8010809b <alltraps>

80108ea4 <vector201>:
.globl vector201
vector201:
  pushl $0
80108ea4:	6a 00                	push   $0x0
  pushl $201
80108ea6:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108eab:	e9 eb f1 ff ff       	jmp    8010809b <alltraps>

80108eb0 <vector202>:
.globl vector202
vector202:
  pushl $0
80108eb0:	6a 00                	push   $0x0
  pushl $202
80108eb2:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108eb7:	e9 df f1 ff ff       	jmp    8010809b <alltraps>

80108ebc <vector203>:
.globl vector203
vector203:
  pushl $0
80108ebc:	6a 00                	push   $0x0
  pushl $203
80108ebe:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108ec3:	e9 d3 f1 ff ff       	jmp    8010809b <alltraps>

80108ec8 <vector204>:
.globl vector204
vector204:
  pushl $0
80108ec8:	6a 00                	push   $0x0
  pushl $204
80108eca:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108ecf:	e9 c7 f1 ff ff       	jmp    8010809b <alltraps>

80108ed4 <vector205>:
.globl vector205
vector205:
  pushl $0
80108ed4:	6a 00                	push   $0x0
  pushl $205
80108ed6:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108edb:	e9 bb f1 ff ff       	jmp    8010809b <alltraps>

80108ee0 <vector206>:
.globl vector206
vector206:
  pushl $0
80108ee0:	6a 00                	push   $0x0
  pushl $206
80108ee2:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108ee7:	e9 af f1 ff ff       	jmp    8010809b <alltraps>

80108eec <vector207>:
.globl vector207
vector207:
  pushl $0
80108eec:	6a 00                	push   $0x0
  pushl $207
80108eee:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108ef3:	e9 a3 f1 ff ff       	jmp    8010809b <alltraps>

80108ef8 <vector208>:
.globl vector208
vector208:
  pushl $0
80108ef8:	6a 00                	push   $0x0
  pushl $208
80108efa:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108eff:	e9 97 f1 ff ff       	jmp    8010809b <alltraps>

80108f04 <vector209>:
.globl vector209
vector209:
  pushl $0
80108f04:	6a 00                	push   $0x0
  pushl $209
80108f06:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108f0b:	e9 8b f1 ff ff       	jmp    8010809b <alltraps>

80108f10 <vector210>:
.globl vector210
vector210:
  pushl $0
80108f10:	6a 00                	push   $0x0
  pushl $210
80108f12:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108f17:	e9 7f f1 ff ff       	jmp    8010809b <alltraps>

80108f1c <vector211>:
.globl vector211
vector211:
  pushl $0
80108f1c:	6a 00                	push   $0x0
  pushl $211
80108f1e:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108f23:	e9 73 f1 ff ff       	jmp    8010809b <alltraps>

80108f28 <vector212>:
.globl vector212
vector212:
  pushl $0
80108f28:	6a 00                	push   $0x0
  pushl $212
80108f2a:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108f2f:	e9 67 f1 ff ff       	jmp    8010809b <alltraps>

80108f34 <vector213>:
.globl vector213
vector213:
  pushl $0
80108f34:	6a 00                	push   $0x0
  pushl $213
80108f36:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108f3b:	e9 5b f1 ff ff       	jmp    8010809b <alltraps>

80108f40 <vector214>:
.globl vector214
vector214:
  pushl $0
80108f40:	6a 00                	push   $0x0
  pushl $214
80108f42:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108f47:	e9 4f f1 ff ff       	jmp    8010809b <alltraps>

80108f4c <vector215>:
.globl vector215
vector215:
  pushl $0
80108f4c:	6a 00                	push   $0x0
  pushl $215
80108f4e:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108f53:	e9 43 f1 ff ff       	jmp    8010809b <alltraps>

80108f58 <vector216>:
.globl vector216
vector216:
  pushl $0
80108f58:	6a 00                	push   $0x0
  pushl $216
80108f5a:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108f5f:	e9 37 f1 ff ff       	jmp    8010809b <alltraps>

80108f64 <vector217>:
.globl vector217
vector217:
  pushl $0
80108f64:	6a 00                	push   $0x0
  pushl $217
80108f66:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108f6b:	e9 2b f1 ff ff       	jmp    8010809b <alltraps>

80108f70 <vector218>:
.globl vector218
vector218:
  pushl $0
80108f70:	6a 00                	push   $0x0
  pushl $218
80108f72:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108f77:	e9 1f f1 ff ff       	jmp    8010809b <alltraps>

80108f7c <vector219>:
.globl vector219
vector219:
  pushl $0
80108f7c:	6a 00                	push   $0x0
  pushl $219
80108f7e:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108f83:	e9 13 f1 ff ff       	jmp    8010809b <alltraps>

80108f88 <vector220>:
.globl vector220
vector220:
  pushl $0
80108f88:	6a 00                	push   $0x0
  pushl $220
80108f8a:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108f8f:	e9 07 f1 ff ff       	jmp    8010809b <alltraps>

80108f94 <vector221>:
.globl vector221
vector221:
  pushl $0
80108f94:	6a 00                	push   $0x0
  pushl $221
80108f96:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108f9b:	e9 fb f0 ff ff       	jmp    8010809b <alltraps>

80108fa0 <vector222>:
.globl vector222
vector222:
  pushl $0
80108fa0:	6a 00                	push   $0x0
  pushl $222
80108fa2:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108fa7:	e9 ef f0 ff ff       	jmp    8010809b <alltraps>

80108fac <vector223>:
.globl vector223
vector223:
  pushl $0
80108fac:	6a 00                	push   $0x0
  pushl $223
80108fae:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108fb3:	e9 e3 f0 ff ff       	jmp    8010809b <alltraps>

80108fb8 <vector224>:
.globl vector224
vector224:
  pushl $0
80108fb8:	6a 00                	push   $0x0
  pushl $224
80108fba:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108fbf:	e9 d7 f0 ff ff       	jmp    8010809b <alltraps>

80108fc4 <vector225>:
.globl vector225
vector225:
  pushl $0
80108fc4:	6a 00                	push   $0x0
  pushl $225
80108fc6:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108fcb:	e9 cb f0 ff ff       	jmp    8010809b <alltraps>

80108fd0 <vector226>:
.globl vector226
vector226:
  pushl $0
80108fd0:	6a 00                	push   $0x0
  pushl $226
80108fd2:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108fd7:	e9 bf f0 ff ff       	jmp    8010809b <alltraps>

80108fdc <vector227>:
.globl vector227
vector227:
  pushl $0
80108fdc:	6a 00                	push   $0x0
  pushl $227
80108fde:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108fe3:	e9 b3 f0 ff ff       	jmp    8010809b <alltraps>

80108fe8 <vector228>:
.globl vector228
vector228:
  pushl $0
80108fe8:	6a 00                	push   $0x0
  pushl $228
80108fea:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108fef:	e9 a7 f0 ff ff       	jmp    8010809b <alltraps>

80108ff4 <vector229>:
.globl vector229
vector229:
  pushl $0
80108ff4:	6a 00                	push   $0x0
  pushl $229
80108ff6:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108ffb:	e9 9b f0 ff ff       	jmp    8010809b <alltraps>

80109000 <vector230>:
.globl vector230
vector230:
  pushl $0
80109000:	6a 00                	push   $0x0
  pushl $230
80109002:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80109007:	e9 8f f0 ff ff       	jmp    8010809b <alltraps>

8010900c <vector231>:
.globl vector231
vector231:
  pushl $0
8010900c:	6a 00                	push   $0x0
  pushl $231
8010900e:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80109013:	e9 83 f0 ff ff       	jmp    8010809b <alltraps>

80109018 <vector232>:
.globl vector232
vector232:
  pushl $0
80109018:	6a 00                	push   $0x0
  pushl $232
8010901a:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010901f:	e9 77 f0 ff ff       	jmp    8010809b <alltraps>

80109024 <vector233>:
.globl vector233
vector233:
  pushl $0
80109024:	6a 00                	push   $0x0
  pushl $233
80109026:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010902b:	e9 6b f0 ff ff       	jmp    8010809b <alltraps>

80109030 <vector234>:
.globl vector234
vector234:
  pushl $0
80109030:	6a 00                	push   $0x0
  pushl $234
80109032:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80109037:	e9 5f f0 ff ff       	jmp    8010809b <alltraps>

8010903c <vector235>:
.globl vector235
vector235:
  pushl $0
8010903c:	6a 00                	push   $0x0
  pushl $235
8010903e:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80109043:	e9 53 f0 ff ff       	jmp    8010809b <alltraps>

80109048 <vector236>:
.globl vector236
vector236:
  pushl $0
80109048:	6a 00                	push   $0x0
  pushl $236
8010904a:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010904f:	e9 47 f0 ff ff       	jmp    8010809b <alltraps>

80109054 <vector237>:
.globl vector237
vector237:
  pushl $0
80109054:	6a 00                	push   $0x0
  pushl $237
80109056:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010905b:	e9 3b f0 ff ff       	jmp    8010809b <alltraps>

80109060 <vector238>:
.globl vector238
vector238:
  pushl $0
80109060:	6a 00                	push   $0x0
  pushl $238
80109062:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80109067:	e9 2f f0 ff ff       	jmp    8010809b <alltraps>

8010906c <vector239>:
.globl vector239
vector239:
  pushl $0
8010906c:	6a 00                	push   $0x0
  pushl $239
8010906e:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80109073:	e9 23 f0 ff ff       	jmp    8010809b <alltraps>

80109078 <vector240>:
.globl vector240
vector240:
  pushl $0
80109078:	6a 00                	push   $0x0
  pushl $240
8010907a:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010907f:	e9 17 f0 ff ff       	jmp    8010809b <alltraps>

80109084 <vector241>:
.globl vector241
vector241:
  pushl $0
80109084:	6a 00                	push   $0x0
  pushl $241
80109086:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010908b:	e9 0b f0 ff ff       	jmp    8010809b <alltraps>

80109090 <vector242>:
.globl vector242
vector242:
  pushl $0
80109090:	6a 00                	push   $0x0
  pushl $242
80109092:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80109097:	e9 ff ef ff ff       	jmp    8010809b <alltraps>

8010909c <vector243>:
.globl vector243
vector243:
  pushl $0
8010909c:	6a 00                	push   $0x0
  pushl $243
8010909e:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801090a3:	e9 f3 ef ff ff       	jmp    8010809b <alltraps>

801090a8 <vector244>:
.globl vector244
vector244:
  pushl $0
801090a8:	6a 00                	push   $0x0
  pushl $244
801090aa:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801090af:	e9 e7 ef ff ff       	jmp    8010809b <alltraps>

801090b4 <vector245>:
.globl vector245
vector245:
  pushl $0
801090b4:	6a 00                	push   $0x0
  pushl $245
801090b6:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801090bb:	e9 db ef ff ff       	jmp    8010809b <alltraps>

801090c0 <vector246>:
.globl vector246
vector246:
  pushl $0
801090c0:	6a 00                	push   $0x0
  pushl $246
801090c2:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801090c7:	e9 cf ef ff ff       	jmp    8010809b <alltraps>

801090cc <vector247>:
.globl vector247
vector247:
  pushl $0
801090cc:	6a 00                	push   $0x0
  pushl $247
801090ce:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801090d3:	e9 c3 ef ff ff       	jmp    8010809b <alltraps>

801090d8 <vector248>:
.globl vector248
vector248:
  pushl $0
801090d8:	6a 00                	push   $0x0
  pushl $248
801090da:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801090df:	e9 b7 ef ff ff       	jmp    8010809b <alltraps>

801090e4 <vector249>:
.globl vector249
vector249:
  pushl $0
801090e4:	6a 00                	push   $0x0
  pushl $249
801090e6:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801090eb:	e9 ab ef ff ff       	jmp    8010809b <alltraps>

801090f0 <vector250>:
.globl vector250
vector250:
  pushl $0
801090f0:	6a 00                	push   $0x0
  pushl $250
801090f2:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801090f7:	e9 9f ef ff ff       	jmp    8010809b <alltraps>

801090fc <vector251>:
.globl vector251
vector251:
  pushl $0
801090fc:	6a 00                	push   $0x0
  pushl $251
801090fe:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80109103:	e9 93 ef ff ff       	jmp    8010809b <alltraps>

80109108 <vector252>:
.globl vector252
vector252:
  pushl $0
80109108:	6a 00                	push   $0x0
  pushl $252
8010910a:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010910f:	e9 87 ef ff ff       	jmp    8010809b <alltraps>

80109114 <vector253>:
.globl vector253
vector253:
  pushl $0
80109114:	6a 00                	push   $0x0
  pushl $253
80109116:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010911b:	e9 7b ef ff ff       	jmp    8010809b <alltraps>

80109120 <vector254>:
.globl vector254
vector254:
  pushl $0
80109120:	6a 00                	push   $0x0
  pushl $254
80109122:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80109127:	e9 6f ef ff ff       	jmp    8010809b <alltraps>

8010912c <vector255>:
.globl vector255
vector255:
  pushl $0
8010912c:	6a 00                	push   $0x0
  pushl $255
8010912e:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80109133:	e9 63 ef ff ff       	jmp    8010809b <alltraps>

80109138 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80109138:	55                   	push   %ebp
80109139:	89 e5                	mov    %esp,%ebp
8010913b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010913e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109141:	83 e8 01             	sub    $0x1,%eax
80109144:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80109148:	8b 45 08             	mov    0x8(%ebp),%eax
8010914b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010914f:	8b 45 08             	mov    0x8(%ebp),%eax
80109152:	c1 e8 10             	shr    $0x10,%eax
80109155:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80109159:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010915c:	0f 01 10             	lgdtl  (%eax)
}
8010915f:	90                   	nop
80109160:	c9                   	leave  
80109161:	c3                   	ret    

80109162 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80109162:	55                   	push   %ebp
80109163:	89 e5                	mov    %esp,%ebp
80109165:	83 ec 04             	sub    $0x4,%esp
80109168:	8b 45 08             	mov    0x8(%ebp),%eax
8010916b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010916f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109173:	0f 00 d8             	ltr    %ax
}
80109176:	90                   	nop
80109177:	c9                   	leave  
80109178:	c3                   	ret    

80109179 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80109179:	55                   	push   %ebp
8010917a:	89 e5                	mov    %esp,%ebp
8010917c:	83 ec 04             	sub    $0x4,%esp
8010917f:	8b 45 08             	mov    0x8(%ebp),%eax
80109182:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80109186:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010918a:	8e e8                	mov    %eax,%gs
}
8010918c:	90                   	nop
8010918d:	c9                   	leave  
8010918e:	c3                   	ret    

8010918f <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010918f:	55                   	push   %ebp
80109190:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80109192:	8b 45 08             	mov    0x8(%ebp),%eax
80109195:	0f 22 d8             	mov    %eax,%cr3
}
80109198:	90                   	nop
80109199:	5d                   	pop    %ebp
8010919a:	c3                   	ret    

8010919b <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010919b:	55                   	push   %ebp
8010919c:	89 e5                	mov    %esp,%ebp
8010919e:	8b 45 08             	mov    0x8(%ebp),%eax
801091a1:	05 00 00 00 80       	add    $0x80000000,%eax
801091a6:	5d                   	pop    %ebp
801091a7:	c3                   	ret    

801091a8 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801091a8:	55                   	push   %ebp
801091a9:	89 e5                	mov    %esp,%ebp
801091ab:	8b 45 08             	mov    0x8(%ebp),%eax
801091ae:	05 00 00 00 80       	add    $0x80000000,%eax
801091b3:	5d                   	pop    %ebp
801091b4:	c3                   	ret    

801091b5 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801091b5:	55                   	push   %ebp
801091b6:	89 e5                	mov    %esp,%ebp
801091b8:	53                   	push   %ebx
801091b9:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801091bc:	e8 12 a0 ff ff       	call   801031d3 <cpunum>
801091c1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801091c7:	05 a0 43 11 80       	add    $0x801143a0,%eax
801091cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801091cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091d2:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801091d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091db:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801091e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091e4:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801091e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091eb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091ef:	83 e2 f0             	and    $0xfffffff0,%edx
801091f2:	83 ca 0a             	or     $0xa,%edx
801091f5:	88 50 7d             	mov    %dl,0x7d(%eax)
801091f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091fb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091ff:	83 ca 10             	or     $0x10,%edx
80109202:	88 50 7d             	mov    %dl,0x7d(%eax)
80109205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109208:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010920c:	83 e2 9f             	and    $0xffffff9f,%edx
8010920f:	88 50 7d             	mov    %dl,0x7d(%eax)
80109212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109215:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109219:	83 ca 80             	or     $0xffffff80,%edx
8010921c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010921f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109222:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109226:	83 ca 0f             	or     $0xf,%edx
80109229:	88 50 7e             	mov    %dl,0x7e(%eax)
8010922c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010922f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109233:	83 e2 ef             	and    $0xffffffef,%edx
80109236:	88 50 7e             	mov    %dl,0x7e(%eax)
80109239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010923c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109240:	83 e2 df             	and    $0xffffffdf,%edx
80109243:	88 50 7e             	mov    %dl,0x7e(%eax)
80109246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109249:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010924d:	83 ca 40             	or     $0x40,%edx
80109250:	88 50 7e             	mov    %dl,0x7e(%eax)
80109253:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109256:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010925a:	83 ca 80             	or     $0xffffff80,%edx
8010925d:	88 50 7e             	mov    %dl,0x7e(%eax)
80109260:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109263:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80109267:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010926a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80109271:	ff ff 
80109273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109276:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010927d:	00 00 
8010927f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109282:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80109289:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010928c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109293:	83 e2 f0             	and    $0xfffffff0,%edx
80109296:	83 ca 02             	or     $0x2,%edx
80109299:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010929f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092a2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801092a9:	83 ca 10             	or     $0x10,%edx
801092ac:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092b5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801092bc:	83 e2 9f             	and    $0xffffff9f,%edx
801092bf:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092c8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801092cf:	83 ca 80             	or     $0xffffff80,%edx
801092d2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092db:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092e2:	83 ca 0f             	or     $0xf,%edx
801092e5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801092eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092ee:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092f5:	83 e2 ef             	and    $0xffffffef,%edx
801092f8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801092fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109301:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109308:	83 e2 df             	and    $0xffffffdf,%edx
8010930b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109314:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010931b:	83 ca 40             	or     $0x40,%edx
8010931e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109327:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010932e:	83 ca 80             	or     $0xffffff80,%edx
80109331:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109337:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010933a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80109341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109344:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010934b:	ff ff 
8010934d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109350:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80109357:	00 00 
80109359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010935c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80109363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109366:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010936d:	83 e2 f0             	and    $0xfffffff0,%edx
80109370:	83 ca 0a             	or     $0xa,%edx
80109373:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010937c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109383:	83 ca 10             	or     $0x10,%edx
80109386:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010938c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010938f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109396:	83 ca 60             	or     $0x60,%edx
80109399:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010939f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801093a9:	83 ca 80             	or     $0xffffff80,%edx
801093ac:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801093b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093b5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093bc:	83 ca 0f             	or     $0xf,%edx
801093bf:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093c8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093cf:	83 e2 ef             	and    $0xffffffef,%edx
801093d2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093db:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093e2:	83 e2 df             	and    $0xffffffdf,%edx
801093e5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093ee:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093f5:	83 ca 40             	or     $0x40,%edx
801093f8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109401:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109408:	83 ca 80             	or     $0xffffff80,%edx
8010940b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109411:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109414:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010941b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010941e:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80109425:	ff ff 
80109427:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010942a:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80109431:	00 00 
80109433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109436:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010943d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109440:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109447:	83 e2 f0             	and    $0xfffffff0,%edx
8010944a:	83 ca 02             	or     $0x2,%edx
8010944d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109456:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010945d:	83 ca 10             	or     $0x10,%edx
80109460:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109469:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109470:	83 ca 60             	or     $0x60,%edx
80109473:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109479:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010947c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109483:	83 ca 80             	or     $0xffffff80,%edx
80109486:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010948c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010948f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109496:	83 ca 0f             	or     $0xf,%edx
80109499:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010949f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094a2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094a9:	83 e2 ef             	and    $0xffffffef,%edx
801094ac:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094b5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094bc:	83 e2 df             	and    $0xffffffdf,%edx
801094bf:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094c8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094cf:	83 ca 40             	or     $0x40,%edx
801094d2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094db:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094e2:	83 ca 80             	or     $0xffffff80,%edx
801094e5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ee:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801094f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094f8:	05 b4 00 00 00       	add    $0xb4,%eax
801094fd:	89 c3                	mov    %eax,%ebx
801094ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109502:	05 b4 00 00 00       	add    $0xb4,%eax
80109507:	c1 e8 10             	shr    $0x10,%eax
8010950a:	89 c2                	mov    %eax,%edx
8010950c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010950f:	05 b4 00 00 00       	add    $0xb4,%eax
80109514:	c1 e8 18             	shr    $0x18,%eax
80109517:	89 c1                	mov    %eax,%ecx
80109519:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010951c:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80109523:	00 00 
80109525:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109528:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010952f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109532:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80109538:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010953b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109542:	83 e2 f0             	and    $0xfffffff0,%edx
80109545:	83 ca 02             	or     $0x2,%edx
80109548:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010954e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109551:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109558:	83 ca 10             	or     $0x10,%edx
8010955b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109561:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109564:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010956b:	83 e2 9f             	and    $0xffffff9f,%edx
8010956e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109577:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010957e:	83 ca 80             	or     $0xffffff80,%edx
80109581:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109587:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010958a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109591:	83 e2 f0             	and    $0xfffffff0,%edx
80109594:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010959a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010959d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095a4:	83 e2 ef             	and    $0xffffffef,%edx
801095a7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095b7:	83 e2 df             	and    $0xffffffdf,%edx
801095ba:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095ca:	83 ca 40             	or     $0x40,%edx
801095cd:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095dd:	83 ca 80             	or     $0xffffff80,%edx
801095e0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e9:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801095ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f2:	83 c0 70             	add    $0x70,%eax
801095f5:	83 ec 08             	sub    $0x8,%esp
801095f8:	6a 38                	push   $0x38
801095fa:	50                   	push   %eax
801095fb:	e8 38 fb ff ff       	call   80109138 <lgdt>
80109600:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80109603:	83 ec 0c             	sub    $0xc,%esp
80109606:	6a 18                	push   $0x18
80109608:	e8 6c fb ff ff       	call   80109179 <loadgs>
8010960d:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80109610:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109613:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109619:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109620:	00 00 00 00 
}
80109624:	90                   	nop
80109625:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109628:	c9                   	leave  
80109629:	c3                   	ret    

8010962a <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010962a:	55                   	push   %ebp
8010962b:	89 e5                	mov    %esp,%ebp
8010962d:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80109630:	8b 45 0c             	mov    0xc(%ebp),%eax
80109633:	c1 e8 16             	shr    $0x16,%eax
80109636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010963d:	8b 45 08             	mov    0x8(%ebp),%eax
80109640:	01 d0                	add    %edx,%eax
80109642:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80109645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109648:	8b 00                	mov    (%eax),%eax
8010964a:	83 e0 01             	and    $0x1,%eax
8010964d:	85 c0                	test   %eax,%eax
8010964f:	74 18                	je     80109669 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80109651:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109654:	8b 00                	mov    (%eax),%eax
80109656:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010965b:	50                   	push   %eax
8010965c:	e8 47 fb ff ff       	call   801091a8 <p2v>
80109661:	83 c4 04             	add    $0x4,%esp
80109664:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109667:	eb 48                	jmp    801096b1 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109669:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010966d:	74 0e                	je     8010967d <walkpgdir+0x53>
8010966f:	e8 f9 97 ff ff       	call   80102e6d <kalloc>
80109674:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010967b:	75 07                	jne    80109684 <walkpgdir+0x5a>
      return 0;
8010967d:	b8 00 00 00 00       	mov    $0x0,%eax
80109682:	eb 44                	jmp    801096c8 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80109684:	83 ec 04             	sub    $0x4,%esp
80109687:	68 00 10 00 00       	push   $0x1000
8010968c:	6a 00                	push   $0x0
8010968e:	ff 75 f4             	pushl  -0xc(%ebp)
80109691:	e8 56 d2 ff ff       	call   801068ec <memset>
80109696:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80109699:	83 ec 0c             	sub    $0xc,%esp
8010969c:	ff 75 f4             	pushl  -0xc(%ebp)
8010969f:	e8 f7 fa ff ff       	call   8010919b <v2p>
801096a4:	83 c4 10             	add    $0x10,%esp
801096a7:	83 c8 07             	or     $0x7,%eax
801096aa:	89 c2                	mov    %eax,%edx
801096ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096af:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801096b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801096b4:	c1 e8 0c             	shr    $0xc,%eax
801096b7:	25 ff 03 00 00       	and    $0x3ff,%eax
801096bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801096c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096c6:	01 d0                	add    %edx,%eax
}
801096c8:	c9                   	leave  
801096c9:	c3                   	ret    

801096ca <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801096ca:	55                   	push   %ebp
801096cb:	89 e5                	mov    %esp,%ebp
801096cd:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801096d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801096d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801096db:	8b 55 0c             	mov    0xc(%ebp),%edx
801096de:	8b 45 10             	mov    0x10(%ebp),%eax
801096e1:	01 d0                	add    %edx,%eax
801096e3:	83 e8 01             	sub    $0x1,%eax
801096e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801096ee:	83 ec 04             	sub    $0x4,%esp
801096f1:	6a 01                	push   $0x1
801096f3:	ff 75 f4             	pushl  -0xc(%ebp)
801096f6:	ff 75 08             	pushl  0x8(%ebp)
801096f9:	e8 2c ff ff ff       	call   8010962a <walkpgdir>
801096fe:	83 c4 10             	add    $0x10,%esp
80109701:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109704:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109708:	75 07                	jne    80109711 <mappages+0x47>
      return -1;
8010970a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010970f:	eb 47                	jmp    80109758 <mappages+0x8e>
    if(*pte & PTE_P)
80109711:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109714:	8b 00                	mov    (%eax),%eax
80109716:	83 e0 01             	and    $0x1,%eax
80109719:	85 c0                	test   %eax,%eax
8010971b:	74 0d                	je     8010972a <mappages+0x60>
      panic("remap");
8010971d:	83 ec 0c             	sub    $0xc,%esp
80109720:	68 ac a9 10 80       	push   $0x8010a9ac
80109725:	e8 3c 6e ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
8010972a:	8b 45 18             	mov    0x18(%ebp),%eax
8010972d:	0b 45 14             	or     0x14(%ebp),%eax
80109730:	83 c8 01             	or     $0x1,%eax
80109733:	89 c2                	mov    %eax,%edx
80109735:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109738:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010973a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010973d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109740:	74 10                	je     80109752 <mappages+0x88>
      break;
    a += PGSIZE;
80109742:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109749:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80109750:	eb 9c                	jmp    801096ee <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109752:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109753:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109758:	c9                   	leave  
80109759:	c3                   	ret    

8010975a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010975a:	55                   	push   %ebp
8010975b:	89 e5                	mov    %esp,%ebp
8010975d:	53                   	push   %ebx
8010975e:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80109761:	e8 07 97 ff ff       	call   80102e6d <kalloc>
80109766:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109769:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010976d:	75 0a                	jne    80109779 <setupkvm+0x1f>
    return 0;
8010976f:	b8 00 00 00 00       	mov    $0x0,%eax
80109774:	e9 8e 00 00 00       	jmp    80109807 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80109779:	83 ec 04             	sub    $0x4,%esp
8010977c:	68 00 10 00 00       	push   $0x1000
80109781:	6a 00                	push   $0x0
80109783:	ff 75 f0             	pushl  -0x10(%ebp)
80109786:	e8 61 d1 ff ff       	call   801068ec <memset>
8010978b:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010978e:	83 ec 0c             	sub    $0xc,%esp
80109791:	68 00 00 00 0e       	push   $0xe000000
80109796:	e8 0d fa ff ff       	call   801091a8 <p2v>
8010979b:	83 c4 10             	add    $0x10,%esp
8010979e:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801097a3:	76 0d                	jbe    801097b2 <setupkvm+0x58>
    panic("PHYSTOP too high");
801097a5:	83 ec 0c             	sub    $0xc,%esp
801097a8:	68 b2 a9 10 80       	push   $0x8010a9b2
801097ad:	e8 b4 6d ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801097b2:	c7 45 f4 e0 d4 10 80 	movl   $0x8010d4e0,-0xc(%ebp)
801097b9:	eb 40                	jmp    801097fb <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801097bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097be:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801097c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097c4:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801097c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ca:	8b 58 08             	mov    0x8(%eax),%ebx
801097cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d0:	8b 40 04             	mov    0x4(%eax),%eax
801097d3:	29 c3                	sub    %eax,%ebx
801097d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d8:	8b 00                	mov    (%eax),%eax
801097da:	83 ec 0c             	sub    $0xc,%esp
801097dd:	51                   	push   %ecx
801097de:	52                   	push   %edx
801097df:	53                   	push   %ebx
801097e0:	50                   	push   %eax
801097e1:	ff 75 f0             	pushl  -0x10(%ebp)
801097e4:	e8 e1 fe ff ff       	call   801096ca <mappages>
801097e9:	83 c4 20             	add    $0x20,%esp
801097ec:	85 c0                	test   %eax,%eax
801097ee:	79 07                	jns    801097f7 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801097f0:	b8 00 00 00 00       	mov    $0x0,%eax
801097f5:	eb 10                	jmp    80109807 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801097f7:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801097fb:	81 7d f4 20 d5 10 80 	cmpl   $0x8010d520,-0xc(%ebp)
80109802:	72 b7                	jb     801097bb <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109804:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010980a:	c9                   	leave  
8010980b:	c3                   	ret    

8010980c <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010980c:	55                   	push   %ebp
8010980d:	89 e5                	mov    %esp,%ebp
8010980f:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109812:	e8 43 ff ff ff       	call   8010975a <setupkvm>
80109817:	a3 78 79 11 80       	mov    %eax,0x80117978
  switchkvm();
8010981c:	e8 03 00 00 00       	call   80109824 <switchkvm>
}
80109821:	90                   	nop
80109822:	c9                   	leave  
80109823:	c3                   	ret    

80109824 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109824:	55                   	push   %ebp
80109825:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109827:	a1 78 79 11 80       	mov    0x80117978,%eax
8010982c:	50                   	push   %eax
8010982d:	e8 69 f9 ff ff       	call   8010919b <v2p>
80109832:	83 c4 04             	add    $0x4,%esp
80109835:	50                   	push   %eax
80109836:	e8 54 f9 ff ff       	call   8010918f <lcr3>
8010983b:	83 c4 04             	add    $0x4,%esp
}
8010983e:	90                   	nop
8010983f:	c9                   	leave  
80109840:	c3                   	ret    

80109841 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109841:	55                   	push   %ebp
80109842:	89 e5                	mov    %esp,%ebp
80109844:	56                   	push   %esi
80109845:	53                   	push   %ebx
  pushcli();
80109846:	e8 9b cf ff ff       	call   801067e6 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010984b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109851:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109858:	83 c2 08             	add    $0x8,%edx
8010985b:	89 d6                	mov    %edx,%esi
8010985d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109864:	83 c2 08             	add    $0x8,%edx
80109867:	c1 ea 10             	shr    $0x10,%edx
8010986a:	89 d3                	mov    %edx,%ebx
8010986c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109873:	83 c2 08             	add    $0x8,%edx
80109876:	c1 ea 18             	shr    $0x18,%edx
80109879:	89 d1                	mov    %edx,%ecx
8010987b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109882:	67 00 
80109884:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
8010988b:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80109891:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109898:	83 e2 f0             	and    $0xfffffff0,%edx
8010989b:	83 ca 09             	or     $0x9,%edx
8010989e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098a4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801098ab:	83 ca 10             	or     $0x10,%edx
801098ae:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098b4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801098bb:	83 e2 9f             	and    $0xffffff9f,%edx
801098be:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098c4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801098cb:	83 ca 80             	or     $0xffffff80,%edx
801098ce:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098d4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098db:	83 e2 f0             	and    $0xfffffff0,%edx
801098de:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098e4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098eb:	83 e2 ef             	and    $0xffffffef,%edx
801098ee:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098f4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098fb:	83 e2 df             	and    $0xffffffdf,%edx
801098fe:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109904:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010990b:	83 ca 40             	or     $0x40,%edx
8010990e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109914:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010991b:	83 e2 7f             	and    $0x7f,%edx
8010991e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109924:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010992a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109930:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109937:	83 e2 ef             	and    $0xffffffef,%edx
8010993a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109940:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109946:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010994c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109952:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109959:	8b 52 08             	mov    0x8(%edx),%edx
8010995c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109962:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109965:	83 ec 0c             	sub    $0xc,%esp
80109968:	6a 30                	push   $0x30
8010996a:	e8 f3 f7 ff ff       	call   80109162 <ltr>
8010996f:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109972:	8b 45 08             	mov    0x8(%ebp),%eax
80109975:	8b 40 04             	mov    0x4(%eax),%eax
80109978:	85 c0                	test   %eax,%eax
8010997a:	75 0d                	jne    80109989 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010997c:	83 ec 0c             	sub    $0xc,%esp
8010997f:	68 c3 a9 10 80       	push   $0x8010a9c3
80109984:	e8 dd 6b ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109989:	8b 45 08             	mov    0x8(%ebp),%eax
8010998c:	8b 40 04             	mov    0x4(%eax),%eax
8010998f:	83 ec 0c             	sub    $0xc,%esp
80109992:	50                   	push   %eax
80109993:	e8 03 f8 ff ff       	call   8010919b <v2p>
80109998:	83 c4 10             	add    $0x10,%esp
8010999b:	83 ec 0c             	sub    $0xc,%esp
8010999e:	50                   	push   %eax
8010999f:	e8 eb f7 ff ff       	call   8010918f <lcr3>
801099a4:	83 c4 10             	add    $0x10,%esp
  popcli();
801099a7:	e8 7f ce ff ff       	call   8010682b <popcli>
}
801099ac:	90                   	nop
801099ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801099b0:	5b                   	pop    %ebx
801099b1:	5e                   	pop    %esi
801099b2:	5d                   	pop    %ebp
801099b3:	c3                   	ret    

801099b4 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801099b4:	55                   	push   %ebp
801099b5:	89 e5                	mov    %esp,%ebp
801099b7:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801099ba:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801099c1:	76 0d                	jbe    801099d0 <inituvm+0x1c>
    panic("inituvm: more than a page");
801099c3:	83 ec 0c             	sub    $0xc,%esp
801099c6:	68 d7 a9 10 80       	push   $0x8010a9d7
801099cb:	e8 96 6b ff ff       	call   80100566 <panic>
  mem = kalloc();
801099d0:	e8 98 94 ff ff       	call   80102e6d <kalloc>
801099d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801099d8:	83 ec 04             	sub    $0x4,%esp
801099db:	68 00 10 00 00       	push   $0x1000
801099e0:	6a 00                	push   $0x0
801099e2:	ff 75 f4             	pushl  -0xc(%ebp)
801099e5:	e8 02 cf ff ff       	call   801068ec <memset>
801099ea:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801099ed:	83 ec 0c             	sub    $0xc,%esp
801099f0:	ff 75 f4             	pushl  -0xc(%ebp)
801099f3:	e8 a3 f7 ff ff       	call   8010919b <v2p>
801099f8:	83 c4 10             	add    $0x10,%esp
801099fb:	83 ec 0c             	sub    $0xc,%esp
801099fe:	6a 06                	push   $0x6
80109a00:	50                   	push   %eax
80109a01:	68 00 10 00 00       	push   $0x1000
80109a06:	6a 00                	push   $0x0
80109a08:	ff 75 08             	pushl  0x8(%ebp)
80109a0b:	e8 ba fc ff ff       	call   801096ca <mappages>
80109a10:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109a13:	83 ec 04             	sub    $0x4,%esp
80109a16:	ff 75 10             	pushl  0x10(%ebp)
80109a19:	ff 75 0c             	pushl  0xc(%ebp)
80109a1c:	ff 75 f4             	pushl  -0xc(%ebp)
80109a1f:	e8 87 cf ff ff       	call   801069ab <memmove>
80109a24:	83 c4 10             	add    $0x10,%esp
}
80109a27:	90                   	nop
80109a28:	c9                   	leave  
80109a29:	c3                   	ret    

80109a2a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109a2a:	55                   	push   %ebp
80109a2b:	89 e5                	mov    %esp,%ebp
80109a2d:	53                   	push   %ebx
80109a2e:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109a31:	8b 45 0c             	mov    0xc(%ebp),%eax
80109a34:	25 ff 0f 00 00       	and    $0xfff,%eax
80109a39:	85 c0                	test   %eax,%eax
80109a3b:	74 0d                	je     80109a4a <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109a3d:	83 ec 0c             	sub    $0xc,%esp
80109a40:	68 f4 a9 10 80       	push   $0x8010a9f4
80109a45:	e8 1c 6b ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109a4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109a51:	e9 95 00 00 00       	jmp    80109aeb <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109a56:	8b 55 0c             	mov    0xc(%ebp),%edx
80109a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a5c:	01 d0                	add    %edx,%eax
80109a5e:	83 ec 04             	sub    $0x4,%esp
80109a61:	6a 00                	push   $0x0
80109a63:	50                   	push   %eax
80109a64:	ff 75 08             	pushl  0x8(%ebp)
80109a67:	e8 be fb ff ff       	call   8010962a <walkpgdir>
80109a6c:	83 c4 10             	add    $0x10,%esp
80109a6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109a72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109a76:	75 0d                	jne    80109a85 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109a78:	83 ec 0c             	sub    $0xc,%esp
80109a7b:	68 17 aa 10 80       	push   $0x8010aa17
80109a80:	e8 e1 6a ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a88:	8b 00                	mov    (%eax),%eax
80109a8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109a92:	8b 45 18             	mov    0x18(%ebp),%eax
80109a95:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109a98:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109a9d:	77 0b                	ja     80109aaa <loaduvm+0x80>
      n = sz - i;
80109a9f:	8b 45 18             	mov    0x18(%ebp),%eax
80109aa2:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109aa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109aa8:	eb 07                	jmp    80109ab1 <loaduvm+0x87>
    else
      n = PGSIZE;
80109aaa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109ab1:	8b 55 14             	mov    0x14(%ebp),%edx
80109ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ab7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109aba:	83 ec 0c             	sub    $0xc,%esp
80109abd:	ff 75 e8             	pushl  -0x18(%ebp)
80109ac0:	e8 e3 f6 ff ff       	call   801091a8 <p2v>
80109ac5:	83 c4 10             	add    $0x10,%esp
80109ac8:	ff 75 f0             	pushl  -0x10(%ebp)
80109acb:	53                   	push   %ebx
80109acc:	50                   	push   %eax
80109acd:	ff 75 10             	pushl  0x10(%ebp)
80109ad0:	e8 0a 86 ff ff       	call   801020df <readi>
80109ad5:	83 c4 10             	add    $0x10,%esp
80109ad8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109adb:	74 07                	je     80109ae4 <loaduvm+0xba>
      return -1;
80109add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109ae2:	eb 18                	jmp    80109afc <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109ae4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109aee:	3b 45 18             	cmp    0x18(%ebp),%eax
80109af1:	0f 82 5f ff ff ff    	jb     80109a56 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109afc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109aff:	c9                   	leave  
80109b00:	c3                   	ret    

80109b01 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109b01:	55                   	push   %ebp
80109b02:	89 e5                	mov    %esp,%ebp
80109b04:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109b07:	8b 45 10             	mov    0x10(%ebp),%eax
80109b0a:	85 c0                	test   %eax,%eax
80109b0c:	79 0a                	jns    80109b18 <allocuvm+0x17>
    return 0;
80109b0e:	b8 00 00 00 00       	mov    $0x0,%eax
80109b13:	e9 b0 00 00 00       	jmp    80109bc8 <allocuvm+0xc7>
  if(newsz < oldsz)
80109b18:	8b 45 10             	mov    0x10(%ebp),%eax
80109b1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109b1e:	73 08                	jae    80109b28 <allocuvm+0x27>
    return oldsz;
80109b20:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b23:	e9 a0 00 00 00       	jmp    80109bc8 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109b28:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b2b:	05 ff 0f 00 00       	add    $0xfff,%eax
80109b30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109b38:	eb 7f                	jmp    80109bb9 <allocuvm+0xb8>
    mem = kalloc();
80109b3a:	e8 2e 93 ff ff       	call   80102e6d <kalloc>
80109b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109b42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109b46:	75 2b                	jne    80109b73 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109b48:	83 ec 0c             	sub    $0xc,%esp
80109b4b:	68 35 aa 10 80       	push   $0x8010aa35
80109b50:	e8 71 68 ff ff       	call   801003c6 <cprintf>
80109b55:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109b58:	83 ec 04             	sub    $0x4,%esp
80109b5b:	ff 75 0c             	pushl  0xc(%ebp)
80109b5e:	ff 75 10             	pushl  0x10(%ebp)
80109b61:	ff 75 08             	pushl  0x8(%ebp)
80109b64:	e8 61 00 00 00       	call   80109bca <deallocuvm>
80109b69:	83 c4 10             	add    $0x10,%esp
      return 0;
80109b6c:	b8 00 00 00 00       	mov    $0x0,%eax
80109b71:	eb 55                	jmp    80109bc8 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109b73:	83 ec 04             	sub    $0x4,%esp
80109b76:	68 00 10 00 00       	push   $0x1000
80109b7b:	6a 00                	push   $0x0
80109b7d:	ff 75 f0             	pushl  -0x10(%ebp)
80109b80:	e8 67 cd ff ff       	call   801068ec <memset>
80109b85:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109b88:	83 ec 0c             	sub    $0xc,%esp
80109b8b:	ff 75 f0             	pushl  -0x10(%ebp)
80109b8e:	e8 08 f6 ff ff       	call   8010919b <v2p>
80109b93:	83 c4 10             	add    $0x10,%esp
80109b96:	89 c2                	mov    %eax,%edx
80109b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b9b:	83 ec 0c             	sub    $0xc,%esp
80109b9e:	6a 06                	push   $0x6
80109ba0:	52                   	push   %edx
80109ba1:	68 00 10 00 00       	push   $0x1000
80109ba6:	50                   	push   %eax
80109ba7:	ff 75 08             	pushl  0x8(%ebp)
80109baa:	e8 1b fb ff ff       	call   801096ca <mappages>
80109baf:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109bb2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bbc:	3b 45 10             	cmp    0x10(%ebp),%eax
80109bbf:	0f 82 75 ff ff ff    	jb     80109b3a <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109bc5:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109bc8:	c9                   	leave  
80109bc9:	c3                   	ret    

80109bca <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109bca:	55                   	push   %ebp
80109bcb:	89 e5                	mov    %esp,%ebp
80109bcd:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109bd0:	8b 45 10             	mov    0x10(%ebp),%eax
80109bd3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109bd6:	72 08                	jb     80109be0 <deallocuvm+0x16>
    return oldsz;
80109bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80109bdb:	e9 a5 00 00 00       	jmp    80109c85 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109be0:	8b 45 10             	mov    0x10(%ebp),%eax
80109be3:	05 ff 0f 00 00       	add    $0xfff,%eax
80109be8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109bf0:	e9 81 00 00 00       	jmp    80109c76 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bf8:	83 ec 04             	sub    $0x4,%esp
80109bfb:	6a 00                	push   $0x0
80109bfd:	50                   	push   %eax
80109bfe:	ff 75 08             	pushl  0x8(%ebp)
80109c01:	e8 24 fa ff ff       	call   8010962a <walkpgdir>
80109c06:	83 c4 10             	add    $0x10,%esp
80109c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109c0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109c10:	75 09                	jne    80109c1b <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109c12:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109c19:	eb 54                	jmp    80109c6f <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c1e:	8b 00                	mov    (%eax),%eax
80109c20:	83 e0 01             	and    $0x1,%eax
80109c23:	85 c0                	test   %eax,%eax
80109c25:	74 48                	je     80109c6f <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c2a:	8b 00                	mov    (%eax),%eax
80109c2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c31:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109c34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109c38:	75 0d                	jne    80109c47 <deallocuvm+0x7d>
        panic("kfree");
80109c3a:	83 ec 0c             	sub    $0xc,%esp
80109c3d:	68 4d aa 10 80       	push   $0x8010aa4d
80109c42:	e8 1f 69 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109c47:	83 ec 0c             	sub    $0xc,%esp
80109c4a:	ff 75 ec             	pushl  -0x14(%ebp)
80109c4d:	e8 56 f5 ff ff       	call   801091a8 <p2v>
80109c52:	83 c4 10             	add    $0x10,%esp
80109c55:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109c58:	83 ec 0c             	sub    $0xc,%esp
80109c5b:	ff 75 e8             	pushl  -0x18(%ebp)
80109c5e:	e8 6d 91 ff ff       	call   80102dd0 <kfree>
80109c63:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109c6f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c79:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109c7c:	0f 82 73 ff ff ff    	jb     80109bf5 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109c82:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109c85:	c9                   	leave  
80109c86:	c3                   	ret    

80109c87 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109c87:	55                   	push   %ebp
80109c88:	89 e5                	mov    %esp,%ebp
80109c8a:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109c8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109c91:	75 0d                	jne    80109ca0 <freevm+0x19>
    panic("freevm: no pgdir");
80109c93:	83 ec 0c             	sub    $0xc,%esp
80109c96:	68 53 aa 10 80       	push   $0x8010aa53
80109c9b:	e8 c6 68 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109ca0:	83 ec 04             	sub    $0x4,%esp
80109ca3:	6a 00                	push   $0x0
80109ca5:	68 00 00 00 80       	push   $0x80000000
80109caa:	ff 75 08             	pushl  0x8(%ebp)
80109cad:	e8 18 ff ff ff       	call   80109bca <deallocuvm>
80109cb2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109cb5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109cbc:	eb 4f                	jmp    80109d0d <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80109ccb:	01 d0                	add    %edx,%eax
80109ccd:	8b 00                	mov    (%eax),%eax
80109ccf:	83 e0 01             	and    $0x1,%eax
80109cd2:	85 c0                	test   %eax,%eax
80109cd4:	74 33                	je     80109d09 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80109ce3:	01 d0                	add    %edx,%eax
80109ce5:	8b 00                	mov    (%eax),%eax
80109ce7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109cec:	83 ec 0c             	sub    $0xc,%esp
80109cef:	50                   	push   %eax
80109cf0:	e8 b3 f4 ff ff       	call   801091a8 <p2v>
80109cf5:	83 c4 10             	add    $0x10,%esp
80109cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109cfb:	83 ec 0c             	sub    $0xc,%esp
80109cfe:	ff 75 f0             	pushl  -0x10(%ebp)
80109d01:	e8 ca 90 ff ff       	call   80102dd0 <kfree>
80109d06:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109d09:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109d0d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109d14:	76 a8                	jbe    80109cbe <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109d16:	83 ec 0c             	sub    $0xc,%esp
80109d19:	ff 75 08             	pushl  0x8(%ebp)
80109d1c:	e8 af 90 ff ff       	call   80102dd0 <kfree>
80109d21:	83 c4 10             	add    $0x10,%esp
}
80109d24:	90                   	nop
80109d25:	c9                   	leave  
80109d26:	c3                   	ret    

80109d27 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109d27:	55                   	push   %ebp
80109d28:	89 e5                	mov    %esp,%ebp
80109d2a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109d2d:	83 ec 04             	sub    $0x4,%esp
80109d30:	6a 00                	push   $0x0
80109d32:	ff 75 0c             	pushl  0xc(%ebp)
80109d35:	ff 75 08             	pushl  0x8(%ebp)
80109d38:	e8 ed f8 ff ff       	call   8010962a <walkpgdir>
80109d3d:	83 c4 10             	add    $0x10,%esp
80109d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109d43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109d47:	75 0d                	jne    80109d56 <clearpteu+0x2f>
    panic("clearpteu");
80109d49:	83 ec 0c             	sub    $0xc,%esp
80109d4c:	68 64 aa 10 80       	push   $0x8010aa64
80109d51:	e8 10 68 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d59:	8b 00                	mov    (%eax),%eax
80109d5b:	83 e0 fb             	and    $0xfffffffb,%eax
80109d5e:	89 c2                	mov    %eax,%edx
80109d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d63:	89 10                	mov    %edx,(%eax)
}
80109d65:	90                   	nop
80109d66:	c9                   	leave  
80109d67:	c3                   	ret    

80109d68 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109d68:	55                   	push   %ebp
80109d69:	89 e5                	mov    %esp,%ebp
80109d6b:	53                   	push   %ebx
80109d6c:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109d6f:	e8 e6 f9 ff ff       	call   8010975a <setupkvm>
80109d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109d77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109d7b:	75 0a                	jne    80109d87 <copyuvm+0x1f>
    return 0;
80109d7d:	b8 00 00 00 00       	mov    $0x0,%eax
80109d82:	e9 f8 00 00 00       	jmp    80109e7f <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109d87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109d8e:	e9 c4 00 00 00       	jmp    80109e57 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d96:	83 ec 04             	sub    $0x4,%esp
80109d99:	6a 00                	push   $0x0
80109d9b:	50                   	push   %eax
80109d9c:	ff 75 08             	pushl  0x8(%ebp)
80109d9f:	e8 86 f8 ff ff       	call   8010962a <walkpgdir>
80109da4:	83 c4 10             	add    $0x10,%esp
80109da7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109daa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109dae:	75 0d                	jne    80109dbd <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109db0:	83 ec 0c             	sub    $0xc,%esp
80109db3:	68 6e aa 10 80       	push   $0x8010aa6e
80109db8:	e8 a9 67 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109dc0:	8b 00                	mov    (%eax),%eax
80109dc2:	83 e0 01             	and    $0x1,%eax
80109dc5:	85 c0                	test   %eax,%eax
80109dc7:	75 0d                	jne    80109dd6 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109dc9:	83 ec 0c             	sub    $0xc,%esp
80109dcc:	68 88 aa 10 80       	push   $0x8010aa88
80109dd1:	e8 90 67 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109dd9:	8b 00                	mov    (%eax),%eax
80109ddb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109de0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109de6:	8b 00                	mov    (%eax),%eax
80109de8:	25 ff 0f 00 00       	and    $0xfff,%eax
80109ded:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109df0:	e8 78 90 ff ff       	call   80102e6d <kalloc>
80109df5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109df8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109dfc:	74 6a                	je     80109e68 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109dfe:	83 ec 0c             	sub    $0xc,%esp
80109e01:	ff 75 e8             	pushl  -0x18(%ebp)
80109e04:	e8 9f f3 ff ff       	call   801091a8 <p2v>
80109e09:	83 c4 10             	add    $0x10,%esp
80109e0c:	83 ec 04             	sub    $0x4,%esp
80109e0f:	68 00 10 00 00       	push   $0x1000
80109e14:	50                   	push   %eax
80109e15:	ff 75 e0             	pushl  -0x20(%ebp)
80109e18:	e8 8e cb ff ff       	call   801069ab <memmove>
80109e1d:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109e20:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109e23:	83 ec 0c             	sub    $0xc,%esp
80109e26:	ff 75 e0             	pushl  -0x20(%ebp)
80109e29:	e8 6d f3 ff ff       	call   8010919b <v2p>
80109e2e:	83 c4 10             	add    $0x10,%esp
80109e31:	89 c2                	mov    %eax,%edx
80109e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e36:	83 ec 0c             	sub    $0xc,%esp
80109e39:	53                   	push   %ebx
80109e3a:	52                   	push   %edx
80109e3b:	68 00 10 00 00       	push   $0x1000
80109e40:	50                   	push   %eax
80109e41:	ff 75 f0             	pushl  -0x10(%ebp)
80109e44:	e8 81 f8 ff ff       	call   801096ca <mappages>
80109e49:	83 c4 20             	add    $0x20,%esp
80109e4c:	85 c0                	test   %eax,%eax
80109e4e:	78 1b                	js     80109e6b <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109e50:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109e5d:	0f 82 30 ff ff ff    	jb     80109d93 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e66:	eb 17                	jmp    80109e7f <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109e68:	90                   	nop
80109e69:	eb 01                	jmp    80109e6c <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109e6b:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109e6c:	83 ec 0c             	sub    $0xc,%esp
80109e6f:	ff 75 f0             	pushl  -0x10(%ebp)
80109e72:	e8 10 fe ff ff       	call   80109c87 <freevm>
80109e77:	83 c4 10             	add    $0x10,%esp
  return 0;
80109e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109e7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109e82:	c9                   	leave  
80109e83:	c3                   	ret    

80109e84 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109e84:	55                   	push   %ebp
80109e85:	89 e5                	mov    %esp,%ebp
80109e87:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109e8a:	83 ec 04             	sub    $0x4,%esp
80109e8d:	6a 00                	push   $0x0
80109e8f:	ff 75 0c             	pushl  0xc(%ebp)
80109e92:	ff 75 08             	pushl  0x8(%ebp)
80109e95:	e8 90 f7 ff ff       	call   8010962a <walkpgdir>
80109e9a:	83 c4 10             	add    $0x10,%esp
80109e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ea3:	8b 00                	mov    (%eax),%eax
80109ea5:	83 e0 01             	and    $0x1,%eax
80109ea8:	85 c0                	test   %eax,%eax
80109eaa:	75 07                	jne    80109eb3 <uva2ka+0x2f>
    return 0;
80109eac:	b8 00 00 00 00       	mov    $0x0,%eax
80109eb1:	eb 29                	jmp    80109edc <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109eb6:	8b 00                	mov    (%eax),%eax
80109eb8:	83 e0 04             	and    $0x4,%eax
80109ebb:	85 c0                	test   %eax,%eax
80109ebd:	75 07                	jne    80109ec6 <uva2ka+0x42>
    return 0;
80109ebf:	b8 00 00 00 00       	mov    $0x0,%eax
80109ec4:	eb 16                	jmp    80109edc <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ec9:	8b 00                	mov    (%eax),%eax
80109ecb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ed0:	83 ec 0c             	sub    $0xc,%esp
80109ed3:	50                   	push   %eax
80109ed4:	e8 cf f2 ff ff       	call   801091a8 <p2v>
80109ed9:	83 c4 10             	add    $0x10,%esp
}
80109edc:	c9                   	leave  
80109edd:	c3                   	ret    

80109ede <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109ede:	55                   	push   %ebp
80109edf:	89 e5                	mov    %esp,%ebp
80109ee1:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109ee4:	8b 45 10             	mov    0x10(%ebp),%eax
80109ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109eea:	eb 7f                	jmp    80109f6b <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109eec:	8b 45 0c             	mov    0xc(%ebp),%eax
80109eef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ef4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109efa:	83 ec 08             	sub    $0x8,%esp
80109efd:	50                   	push   %eax
80109efe:	ff 75 08             	pushl  0x8(%ebp)
80109f01:	e8 7e ff ff ff       	call   80109e84 <uva2ka>
80109f06:	83 c4 10             	add    $0x10,%esp
80109f09:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109f0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109f10:	75 07                	jne    80109f19 <copyout+0x3b>
      return -1;
80109f12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109f17:	eb 61                	jmp    80109f7a <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f1c:	2b 45 0c             	sub    0xc(%ebp),%eax
80109f1f:	05 00 10 00 00       	add    $0x1000,%eax
80109f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f2a:	3b 45 14             	cmp    0x14(%ebp),%eax
80109f2d:	76 06                	jbe    80109f35 <copyout+0x57>
      n = len;
80109f2f:	8b 45 14             	mov    0x14(%ebp),%eax
80109f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109f35:	8b 45 0c             	mov    0xc(%ebp),%eax
80109f38:	2b 45 ec             	sub    -0x14(%ebp),%eax
80109f3b:	89 c2                	mov    %eax,%edx
80109f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f40:	01 d0                	add    %edx,%eax
80109f42:	83 ec 04             	sub    $0x4,%esp
80109f45:	ff 75 f0             	pushl  -0x10(%ebp)
80109f48:	ff 75 f4             	pushl  -0xc(%ebp)
80109f4b:	50                   	push   %eax
80109f4c:	e8 5a ca ff ff       	call   801069ab <memmove>
80109f51:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f57:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f5d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f63:	05 00 10 00 00       	add    $0x1000,%eax
80109f68:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109f6b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109f6f:	0f 85 77 ff ff ff    	jne    80109eec <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109f75:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109f7a:	c9                   	leave  
80109f7b:	c3                   	ret    
