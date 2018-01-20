
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 2f 10 80       	mov    $0x80102f00,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
	...

80100040 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	56                   	push   %esi
80100044:	53                   	push   %ebx
80100045:	83 ec 10             	sub    $0x10,%esp
80100048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
8010004b:	8d 73 0c             	lea    0xc(%ebx),%esi
8010004e:	89 34 24             	mov    %esi,(%esp)
80100051:	e8 da 44 00 00       	call   80104530 <holdingsleep>
80100056:	85 c0                	test   %eax,%eax
80100058:	74 62                	je     801000bc <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
8010005a:	89 34 24             	mov    %esi,(%esp)
8010005d:	e8 fe 44 00 00       	call   80104560 <releasesleep>

  acquire(&bcache.lock);
80100062:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100069:	e8 62 47 00 00       	call   801047d0 <acquire>
  b->refcnt--;
8010006e:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100071:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100074:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100076:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100079:	75 2f                	jne    801000aa <brelse+0x6a>
    // no one is waiting for it.
    b->next->prev = b->prev;
8010007b:	8b 43 54             	mov    0x54(%ebx),%eax
8010007e:	8b 53 50             	mov    0x50(%ebx),%edx
80100081:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100084:	8b 43 50             	mov    0x50(%ebx),%eax
80100087:	8b 53 54             	mov    0x54(%ebx),%edx
8010008a:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010008d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100092:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100099:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
8010009c:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
801000a1:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000a4:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
801000aa:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
801000b1:	83 c4 10             	add    $0x10,%esp
801000b4:	5b                   	pop    %ebx
801000b5:	5e                   	pop    %esi
801000b6:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
801000b7:	e9 c4 46 00 00       	jmp    80104780 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
801000bc:	c7 04 24 00 73 10 80 	movl   $0x80107300,(%esp)
801000c3:	e8 08 03 00 00       	call   801003d0 <panic>
801000c8:	90                   	nop
801000c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801000d0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	53                   	push   %ebx
801000d4:	83 ec 14             	sub    $0x14,%esp
801000d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801000da:	8d 43 0c             	lea    0xc(%ebx),%eax
801000dd:	89 04 24             	mov    %eax,(%esp)
801000e0:	e8 4b 44 00 00       	call   80104530 <holdingsleep>
801000e5:	85 c0                	test   %eax,%eax
801000e7:	74 10                	je     801000f9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801000e9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801000ec:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801000ef:	83 c4 14             	add    $0x14,%esp
801000f2:	5b                   	pop    %ebx
801000f3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801000f4:	e9 57 1f 00 00       	jmp    80102050 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801000f9:	c7 04 24 07 73 10 80 	movl   $0x80107307,(%esp)
80100100:	e8 cb 02 00 00       	call   801003d0 <panic>
80100105:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100110 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100110:	55                   	push   %ebp
80100111:	89 e5                	mov    %esp,%ebp
80100113:	57                   	push   %edi
80100114:	56                   	push   %esi
80100115:	53                   	push   %ebx
80100116:	83 ec 1c             	sub    $0x1c,%esp
80100119:	8b 75 08             	mov    0x8(%ebp),%esi
8010011c:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
8010011f:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100126:	e8 a5 46 00 00       	call   801047d0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012b:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
80100131:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100137:	75 12                	jne    8010014b <bread+0x3b>
80100139:	eb 25                	jmp    80100160 <bread+0x50>
8010013b:	90                   	nop
8010013c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100140:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100143:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100149:	74 15                	je     80100160 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010014b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010014e:	75 f0                	jne    80100140 <bread+0x30>
80100150:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100153:	75 eb                	jne    80100140 <bread+0x30>
      b->refcnt++;
80100155:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100159:	eb 3f                	jmp    8010019a <bread+0x8a>
8010015b:	90                   	nop
8010015c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100160:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100166:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010016c:	75 0d                	jne    8010017b <bread+0x6b>
8010016e:	eb 58                	jmp    801001c8 <bread+0xb8>
80100170:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100173:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100179:	74 4d                	je     801001c8 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010017b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010017e:	85 c0                	test   %eax,%eax
80100180:	75 ee                	jne    80100170 <bread+0x60>
80100182:	f6 03 04             	testb  $0x4,(%ebx)
80100185:	75 e9                	jne    80100170 <bread+0x60>
      b->dev = dev;
80100187:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010018a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010018d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100193:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010019a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801001a1:	e8 da 45 00 00       	call   80104780 <release>
      acquiresleep(&b->lock);
801001a6:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a9:	89 04 24             	mov    %eax,(%esp)
801001ac:	e8 ef 43 00 00       	call   801045a0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
801001b1:	f6 03 02             	testb  $0x2,(%ebx)
801001b4:	75 08                	jne    801001be <bread+0xae>
    iderw(b);
801001b6:	89 1c 24             	mov    %ebx,(%esp)
801001b9:	e8 92 1e 00 00       	call   80102050 <iderw>
  }
  return b;
}
801001be:	83 c4 1c             	add    $0x1c,%esp
801001c1:	89 d8                	mov    %ebx,%eax
801001c3:	5b                   	pop    %ebx
801001c4:	5e                   	pop    %esi
801001c5:	5f                   	pop    %edi
801001c6:	5d                   	pop    %ebp
801001c7:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001c8:	c7 04 24 0e 73 10 80 	movl   $0x8010730e,(%esp)
801001cf:	e8 fc 01 00 00       	call   801003d0 <panic>
801001d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801001da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001e0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	53                   	push   %ebx
  // head.next is most recently used.
  struct buf head;
} bcache;

void
binit(void)
801001e4:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
801001e9:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
801001ec:	c7 44 24 04 1f 73 10 	movl   $0x8010731f,0x4(%esp)
801001f3:	80 
801001f4:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801001fb:	e8 40 44 00 00       	call   80104640 <initlock>
  // head.next is most recently used.
  struct buf head;
} bcache;

void
binit(void)
80100200:	b8 dc fc 10 80       	mov    $0x8010fcdc,%eax

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100205:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010020c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010020f:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100216:	fc 10 80 
80100219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100220:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100223:	8d 43 0c             	lea    0xc(%ebx),%eax
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
80100226:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010022d:	89 04 24             	mov    %eax,(%esp)
80100230:	c7 44 24 04 26 73 10 	movl   $0x80107326,0x4(%esp)
80100237:	80 
80100238:	e8 c3 43 00 00       	call   80104600 <initsleeplock>
    bcache.head.next->prev = b;
8010023d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100242:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100245:	89 d8                	mov    %ebx,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
80100247:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010024d:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
80100253:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100259:	75 c5                	jne    80100220 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
8010025b:	83 c4 14             	add    $0x14,%esp
8010025e:	5b                   	pop    %ebx
8010025f:	5d                   	pop    %ebp
80100260:	c3                   	ret    
	...

80100270 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100276:	c7 44 24 04 2d 73 10 	movl   $0x8010732d,0x4(%esp)
8010027d:	80 
8010027e:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100285:	e8 b6 43 00 00       	call   80104640 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010028a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100291:	c7 05 8c 09 11 80 d0 	movl   $0x801005d0,0x8011098c
80100298:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010029b:	c7 05 88 09 11 80 d0 	movl   $0x801002d0,0x80110988
801002a2:	02 10 80 
  cons.locking = 1;
801002a5:	c7 05 74 a5 10 80 01 	movl   $0x1,0x8010a574
801002ac:	00 00 00 

  picenable(IRQ_KBD);
801002af:	e8 0c 30 00 00       	call   801032c0 <picenable>
  ioapicenable(IRQ_KBD, 0);
801002b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801002bb:	00 
801002bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801002c3:	e8 88 1f 00 00       	call   80102250 <ioapicenable>
}
801002c8:	c9                   	leave  
801002c9:	c3                   	ret    
801002ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801002d0 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801002d0:	55                   	push   %ebp
801002d1:	89 e5                	mov    %esp,%ebp
801002d3:	57                   	push   %edi
801002d4:	56                   	push   %esi
801002d5:	53                   	push   %ebx
801002d6:	83 ec 3c             	sub    $0x3c,%esp
801002d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002dc:	8b 7d 08             	mov    0x8(%ebp),%edi
801002df:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801002e2:	89 3c 24             	mov    %edi,(%esp)
801002e5:	e8 06 19 00 00       	call   80101bf0 <iunlock>
  target = n;
801002ea:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
801002ed:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801002f4:	e8 d7 44 00 00       	call   801047d0 <acquire>
  while(n > 0){
801002f9:	85 db                	test   %ebx,%ebx
801002fb:	7f 2c                	jg     80100329 <consoleread+0x59>
801002fd:	e9 c0 00 00 00       	jmp    801003c2 <consoleread+0xf2>
80100302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(input.r == input.w){
      if(proc->killed){
80100308:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010030e:	8b 40 24             	mov    0x24(%eax),%eax
80100311:	85 c0                	test   %eax,%eax
80100313:	75 5b                	jne    80100370 <consoleread+0xa0>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100315:	c7 44 24 04 40 a5 10 	movl   $0x8010a540,0x4(%esp)
8010031c:	80 
8010031d:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100324:	e8 57 37 00 00       	call   80103a80 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100329:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
8010032e:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
80100334:	74 d2                	je     80100308 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100336:	89 c2                	mov    %eax,%edx
80100338:	83 e2 7f             	and    $0x7f,%edx
8010033b:	0f b6 8a 40 ff 10 80 	movzbl -0x7fef00c0(%edx),%ecx
80100342:	0f be d1             	movsbl %cl,%edx
80100345:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100348:	8d 50 01             	lea    0x1(%eax),%edx
    if(c == C('D')){  // EOF
8010034b:	83 7d d4 04          	cmpl   $0x4,-0x2c(%ebp)
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
8010034f:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
    if(c == C('D')){  // EOF
80100355:	74 3a                	je     80100391 <consoleread+0xc1>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100357:	88 0e                	mov    %cl,(%esi)
    --n;
80100359:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010035c:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
80100360:	74 39                	je     8010039b <consoleread+0xcb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100362:	85 db                	test   %ebx,%ebx
80100364:	7e 35                	jle    8010039b <consoleread+0xcb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100366:	83 c6 01             	add    $0x1,%esi
80100369:	eb be                	jmp    80100329 <consoleread+0x59>
8010036b:	90                   	nop
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
80100370:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100377:	e8 04 44 00 00       	call   80104780 <release>
        ilock(ip);
8010037c:	89 3c 24             	mov    %edi,(%esp)
8010037f:	e8 dc 18 00 00       	call   80101c60 <ilock>
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100384:	83 c4 3c             	add    $0x3c,%esp
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
80100387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010038c:	5b                   	pop    %ebx
8010038d:	5e                   	pop    %esi
8010038e:	5f                   	pop    %edi
8010038f:	5d                   	pop    %ebp
80100390:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100391:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100394:	76 05                	jbe    8010039b <consoleread+0xcb>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100396:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
8010039b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010039e:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
801003a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801003a3:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801003aa:	e8 d1 43 00 00       	call   80104780 <release>
  ilock(ip);
801003af:	89 3c 24             	mov    %edi,(%esp)
801003b2:	e8 a9 18 00 00       	call   80101c60 <ilock>
801003b7:	8b 45 e0             	mov    -0x20(%ebp),%eax

  return target - n;
}
801003ba:	83 c4 3c             	add    $0x3c,%esp
801003bd:	5b                   	pop    %ebx
801003be:	5e                   	pop    %esi
801003bf:	5f                   	pop    %edi
801003c0:	5d                   	pop    %ebp
801003c1:	c3                   	ret    
  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
801003c2:	31 c0                	xor    %eax,%eax
801003c4:	eb da                	jmp    801003a0 <consoleread+0xd0>
801003c6:	8d 76 00             	lea    0x0(%esi),%esi
801003c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003d0 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
801003d0:	55                   	push   %ebp
801003d1:	89 e5                	mov    %esp,%ebp
801003d3:	56                   	push   %esi
801003d4:	53                   	push   %ebx
801003d5:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801003d8:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
801003d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
801003df:	8d 75 d0             	lea    -0x30(%ebp),%esi
801003e2:	31 db                	xor    %ebx,%ebx
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
801003e4:	c7 05 74 a5 10 80 00 	movl   $0x0,0x8010a574
801003eb:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
801003ee:	0f b6 00             	movzbl (%eax),%eax
801003f1:	c7 04 24 35 73 10 80 	movl   $0x80107335,(%esp)
801003f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801003fc:	e8 6f 04 00 00       	call   80100870 <cprintf>
  cprintf(s);
80100401:	8b 45 08             	mov    0x8(%ebp),%eax
80100404:	89 04 24             	mov    %eax,(%esp)
80100407:	e8 64 04 00 00       	call   80100870 <cprintf>
  cprintf("\n");
8010040c:	c7 04 24 16 78 10 80 	movl   $0x80107816,(%esp)
80100413:	e8 58 04 00 00       	call   80100870 <cprintf>
  getcallerpcs(&s, pcs);
80100418:	8d 45 08             	lea    0x8(%ebp),%eax
8010041b:	89 74 24 04          	mov    %esi,0x4(%esp)
8010041f:	89 04 24             	mov    %eax,(%esp)
80100422:	e8 39 42 00 00       	call   80104660 <getcallerpcs>
80100427:	90                   	nop
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
80100428:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
8010042b:	83 c3 01             	add    $0x1,%ebx
    cprintf(" %p", pcs[i]);
8010042e:	c7 04 24 51 73 10 80 	movl   $0x80107351,(%esp)
80100435:	89 44 24 04          	mov    %eax,0x4(%esp)
80100439:	e8 32 04 00 00       	call   80100870 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
8010043e:	83 fb 0a             	cmp    $0xa,%ebx
80100441:	75 e5                	jne    80100428 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
80100443:	c7 05 20 a5 10 80 01 	movl   $0x1,0x8010a520
8010044a:	00 00 00 
8010044d:	eb fe                	jmp    8010044d <panic+0x7d>
8010044f:	90                   	nop

80100450 <consputc>:
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100450:	55                   	push   %ebp
80100451:	89 e5                	mov    %esp,%ebp
80100453:	57                   	push   %edi
80100454:	56                   	push   %esi
80100455:	89 c6                	mov    %eax,%esi
80100457:	53                   	push   %ebx
80100458:	83 ec 1c             	sub    $0x1c,%esp
  if(panicked){
8010045b:	83 3d 20 a5 10 80 00 	cmpl   $0x0,0x8010a520
80100462:	74 03                	je     80100467 <consputc+0x17>
80100464:	fa                   	cli    
80100465:	eb fe                	jmp    80100465 <consputc+0x15>
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
80100467:	3d 00 01 00 00       	cmp    $0x100,%eax
8010046c:	0f 84 ac 00 00 00    	je     8010051e <consputc+0xce>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100472:	89 04 24             	mov    %eax,(%esp)
80100475:	e8 c6 59 00 00       	call   80105e40 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010047a:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
8010047f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100484:	89 ca                	mov    %ecx,%edx
80100486:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100487:	bf d5 03 00 00       	mov    $0x3d5,%edi
8010048c:	89 fa                	mov    %edi,%edx
8010048e:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
8010048f:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100492:	89 ca                	mov    %ecx,%edx
80100494:	c1 e3 08             	shl    $0x8,%ebx
80100497:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010049d:	89 fa                	mov    %edi,%edx
8010049f:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
801004a0:	0f b6 c0             	movzbl %al,%eax
801004a3:	09 c3                	or     %eax,%ebx

  if(c == '\n')
801004a5:	83 fe 0a             	cmp    $0xa,%esi
801004a8:	0f 84 fb 00 00 00    	je     801005a9 <consputc+0x159>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
801004ae:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801004b4:	0f 84 e1 00 00 00    	je     8010059b <consputc+0x14b>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004ba:	66 81 e6 ff 00       	and    $0xff,%si
801004bf:	66 81 ce 00 07       	or     $0x700,%si
801004c4:	66 89 b4 1b 00 80 0b 	mov    %si,-0x7ff48000(%ebx,%ebx,1)
801004cb:	80 
801004cc:	83 c3 01             	add    $0x1,%ebx

  if(pos < 0 || pos > 25*80)
801004cf:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004d5:	0f 87 b4 00 00 00    	ja     8010058f <consputc+0x13f>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
801004db:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004e1:	8d bc 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edi
801004e8:	7f 5d                	jg     80100547 <consputc+0xf7>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ea:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801004ef:	b8 0e 00 00 00       	mov    $0xe,%eax
801004f4:	89 ca                	mov    %ecx,%edx
801004f6:	ee                   	out    %al,(%dx)
801004f7:	be d5 03 00 00       	mov    $0x3d5,%esi
801004fc:	89 d8                	mov    %ebx,%eax
801004fe:	c1 f8 08             	sar    $0x8,%eax
80100501:	89 f2                	mov    %esi,%edx
80100503:	ee                   	out    %al,(%dx)
80100504:	b8 0f 00 00 00       	mov    $0xf,%eax
80100509:	89 ca                	mov    %ecx,%edx
8010050b:	ee                   	out    %al,(%dx)
8010050c:	89 d8                	mov    %ebx,%eax
8010050e:	89 f2                	mov    %esi,%edx
80100510:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
80100511:	66 c7 07 20 07       	movw   $0x720,(%edi)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
80100516:	83 c4 1c             	add    $0x1c,%esp
80100519:	5b                   	pop    %ebx
8010051a:	5e                   	pop    %esi
8010051b:	5f                   	pop    %edi
8010051c:	5d                   	pop    %ebp
8010051d:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010051e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100525:	e8 16 59 00 00       	call   80105e40 <uartputc>
8010052a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100531:	e8 0a 59 00 00       	call   80105e40 <uartputc>
80100536:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010053d:	e8 fe 58 00 00       	call   80105e40 <uartputc>
80100542:	e9 33 ff ff ff       	jmp    8010047a <consputc+0x2a>
  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
80100547:	83 eb 50             	sub    $0x50,%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054a:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
80100551:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100552:	8d bc 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100559:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
80100560:	80 
80100561:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
80100568:	e8 d3 43 00 00       	call   80104940 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010056d:	b8 80 07 00 00       	mov    $0x780,%eax
80100572:	29 d8                	sub    %ebx,%eax
80100574:	01 c0                	add    %eax,%eax
80100576:	89 44 24 08          	mov    %eax,0x8(%esp)
8010057a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100581:	00 
80100582:	89 3c 24             	mov    %edi,(%esp)
80100585:	e8 e6 42 00 00       	call   80104870 <memset>
8010058a:	e9 5b ff ff ff       	jmp    801004ea <consputc+0x9a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010058f:	c7 04 24 55 73 10 80 	movl   $0x80107355,(%esp)
80100596:	e8 35 fe ff ff       	call   801003d0 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010059b:	31 c0                	xor    %eax,%eax
8010059d:	85 db                	test   %ebx,%ebx
8010059f:	0f 9f c0             	setg   %al
801005a2:	29 c3                	sub    %eax,%ebx
801005a4:	e9 26 ff ff ff       	jmp    801004cf <consputc+0x7f>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
801005a9:	89 da                	mov    %ebx,%edx
801005ab:	89 d8                	mov    %ebx,%eax
801005ad:	b9 50 00 00 00       	mov    $0x50,%ecx
801005b2:	83 c3 50             	add    $0x50,%ebx
801005b5:	c1 fa 1f             	sar    $0x1f,%edx
801005b8:	f7 f9                	idiv   %ecx
801005ba:	29 d3                	sub    %edx,%ebx
801005bc:	e9 0e ff ff ff       	jmp    801004cf <consputc+0x7f>
801005c1:	eb 0d                	jmp    801005d0 <consolewrite>
801005c3:	90                   	nop
801005c4:	90                   	nop
801005c5:	90                   	nop
801005c6:	90                   	nop
801005c7:	90                   	nop
801005c8:	90                   	nop
801005c9:	90                   	nop
801005ca:	90                   	nop
801005cb:	90                   	nop
801005cc:	90                   	nop
801005cd:	90                   	nop
801005ce:	90                   	nop
801005cf:	90                   	nop

801005d0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005dc:	8b 75 10             	mov    0x10(%ebp),%esi
801005df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
801005e2:	89 04 24             	mov    %eax,(%esp)
801005e5:	e8 06 16 00 00       	call   80101bf0 <iunlock>
  acquire(&cons.lock);
801005ea:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801005f1:	e8 da 41 00 00       	call   801047d0 <acquire>
  for(i = 0; i < n; i++)
801005f6:	85 f6                	test   %esi,%esi
801005f8:	7e 16                	jle    80100610 <consolewrite+0x40>
801005fa:	31 db                	xor    %ebx,%ebx
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i] & 0xff);
80100600:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100604:	83 c3 01             	add    $0x1,%ebx
    consputc(buf[i] & 0xff);
80100607:	e8 44 fe ff ff       	call   80100450 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010060c:	39 de                	cmp    %ebx,%esi
8010060e:	7f f0                	jg     80100600 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100610:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100617:	e8 64 41 00 00       	call   80104780 <release>
  ilock(ip);
8010061c:	8b 45 08             	mov    0x8(%ebp),%eax
8010061f:	89 04 24             	mov    %eax,(%esp)
80100622:	e8 39 16 00 00       	call   80101c60 <ilock>

  return n;
}
80100627:	83 c4 1c             	add    $0x1c,%esp
8010062a:	89 f0                	mov    %esi,%eax
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	eb 0d                	jmp    80100640 <consoleintr>
80100633:	90                   	nop
80100634:	90                   	nop
80100635:	90                   	nop
80100636:	90                   	nop
80100637:	90                   	nop
80100638:	90                   	nop
80100639:	90                   	nop
8010063a:	90                   	nop
8010063b:	90                   	nop
8010063c:	90                   	nop
8010063d:	90                   	nop
8010063e:	90                   	nop
8010063f:	90                   	nop

80100640 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
  int c, doprocdump = 0;

  acquire(&cons.lock);
80100644:	31 ff                	xor    %edi,%edi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100646:	56                   	push   %esi
80100647:	53                   	push   %ebx
80100648:	83 ec 1c             	sub    $0x1c,%esp
8010064b:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, doprocdump = 0;

  acquire(&cons.lock);
8010064e:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100655:	e8 76 41 00 00       	call   801047d0 <acquire>
8010065a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
80100660:	ff d6                	call   *%esi
80100662:	85 c0                	test   %eax,%eax
80100664:	89 c3                	mov    %eax,%ebx
80100666:	0f 88 98 00 00 00    	js     80100704 <consoleintr+0xc4>
    switch(c){
8010066c:	83 fb 10             	cmp    $0x10,%ebx
8010066f:	90                   	nop
80100670:	0f 84 32 01 00 00    	je     801007a8 <consoleintr+0x168>
80100676:	0f 8f a4 00 00 00    	jg     80100720 <consoleintr+0xe0>
8010067c:	83 fb 08             	cmp    $0x8,%ebx
8010067f:	90                   	nop
80100680:	0f 84 a8 00 00 00    	je     8010072e <consoleintr+0xee>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100686:	85 db                	test   %ebx,%ebx
80100688:	74 d6                	je     80100660 <consoleintr+0x20>
8010068a:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010068f:	89 c2                	mov    %eax,%edx
80100691:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100697:	83 fa 7f             	cmp    $0x7f,%edx
8010069a:	77 c4                	ja     80100660 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
8010069c:	83 fb 0d             	cmp    $0xd,%ebx
8010069f:	0f 84 0d 01 00 00    	je     801007b2 <consoleintr+0x172>
        input.buf[input.e++ % INPUT_BUF] = c;
801006a5:	89 c2                	mov    %eax,%edx
801006a7:	83 c0 01             	add    $0x1,%eax
801006aa:	83 e2 7f             	and    $0x7f,%edx
801006ad:	88 9a 40 ff 10 80    	mov    %bl,-0x7fef00c0(%edx)
801006b3:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(c);
801006b8:	89 d8                	mov    %ebx,%eax
801006ba:	e8 91 fd ff ff       	call   80100450 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801006bf:	83 fb 04             	cmp    $0x4,%ebx
801006c2:	0f 84 08 01 00 00    	je     801007d0 <consoleintr+0x190>
801006c8:	83 fb 0a             	cmp    $0xa,%ebx
801006cb:	0f 84 ff 00 00 00    	je     801007d0 <consoleintr+0x190>
801006d1:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801006d7:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801006dc:	83 ea 80             	sub    $0xffffff80,%edx
801006df:	39 d0                	cmp    %edx,%eax
801006e1:	0f 85 79 ff ff ff    	jne    80100660 <consoleintr+0x20>
          input.w = input.e;
801006e7:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801006ec:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
801006f3:	e8 28 32 00 00       	call   80103920 <wakeup>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801006f8:	ff d6                	call   *%esi
801006fa:	85 c0                	test   %eax,%eax
801006fc:	89 c3                	mov    %eax,%ebx
801006fe:	0f 89 68 ff ff ff    	jns    8010066c <consoleintr+0x2c>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100704:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
8010070b:	e8 70 40 00 00       	call   80104780 <release>
  if(doprocdump) {
80100710:	85 ff                	test   %edi,%edi
80100712:	0f 85 c2 00 00 00    	jne    801007da <consoleintr+0x19a>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100718:	83 c4 1c             	add    $0x1c,%esp
8010071b:	5b                   	pop    %ebx
8010071c:	5e                   	pop    %esi
8010071d:	5f                   	pop    %edi
8010071e:	5d                   	pop    %ebp
8010071f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100720:	83 fb 15             	cmp    $0x15,%ebx
80100723:	74 33                	je     80100758 <consoleintr+0x118>
80100725:	83 fb 7f             	cmp    $0x7f,%ebx
80100728:	0f 85 58 ff ff ff    	jne    80100686 <consoleintr+0x46>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010072e:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100733:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
80100739:	0f 84 21 ff ff ff    	je     80100660 <consoleintr+0x20>
        input.e--;
8010073f:	83 e8 01             	sub    $0x1,%eax
80100742:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100747:	b8 00 01 00 00       	mov    $0x100,%eax
8010074c:	e8 ff fc ff ff       	call   80100450 <consputc>
80100751:	e9 0a ff ff ff       	jmp    80100660 <consoleintr+0x20>
80100756:	66 90                	xchg   %ax,%ax
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100758:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010075d:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
80100763:	75 2b                	jne    80100790 <consoleintr+0x150>
80100765:	e9 f6 fe ff ff       	jmp    80100660 <consoleintr+0x20>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100770:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100775:	b8 00 01 00 00       	mov    $0x100,%eax
8010077a:	e8 d1 fc ff ff       	call   80100450 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010077f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100784:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010078a:	0f 84 d0 fe ff ff    	je     80100660 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100790:	83 e8 01             	sub    $0x1,%eax
80100793:	89 c2                	mov    %eax,%edx
80100795:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100798:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010079f:	75 cf                	jne    80100770 <consoleintr+0x130>
801007a1:	e9 ba fe ff ff       	jmp    80100660 <consoleintr+0x20>
801007a6:	66 90                	xchg   %ax,%ax
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
801007a8:	bf 01 00 00 00       	mov    $0x1,%edi
801007ad:	e9 ae fe ff ff       	jmp    80100660 <consoleintr+0x20>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
801007b2:	89 c2                	mov    %eax,%edx
801007b4:	83 c0 01             	add    $0x1,%eax
801007b7:	83 e2 7f             	and    $0x7f,%edx
801007ba:	c6 82 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%edx)
801007c1:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(c);
801007c6:	b8 0a 00 00 00       	mov    $0xa,%eax
801007cb:	e8 80 fc ff ff       	call   80100450 <consputc>
801007d0:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801007d5:	e9 0d ff ff ff       	jmp    801006e7 <consoleintr+0xa7>
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
801007da:	83 c4 1c             	add    $0x1c,%esp
801007dd:	5b                   	pop    %ebx
801007de:	5e                   	pop    %esi
801007df:	5f                   	pop    %edi
801007e0:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
801007e1:	e9 da 2f 00 00       	jmp    801037c0 <procdump>
801007e6:	8d 76 00             	lea    0x0(%esi),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	89 d6                	mov    %edx,%esi
801007f7:	53                   	push   %ebx
801007f8:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	74 04                	je     80100803 <printint+0x13>
801007ff:	85 c0                	test   %eax,%eax
80100801:	78 55                	js     80100858 <printint+0x68>
    x = -xx;
  else
    x = xx;
80100803:	31 ff                	xor    %edi,%edi
80100805:	31 c9                	xor    %ecx,%ecx
80100807:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  i = 0;
  do{
    buf[i++] = digits[x % base];
80100810:	31 d2                	xor    %edx,%edx
80100812:	f7 f6                	div    %esi
80100814:	0f b6 92 78 73 10 80 	movzbl -0x7fef8c88(%edx),%edx
8010081b:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
8010081e:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
80100821:	85 c0                	test   %eax,%eax
80100823:	75 eb                	jne    80100810 <printint+0x20>

  if(sign)
80100825:	85 ff                	test   %edi,%edi
80100827:	74 08                	je     80100831 <printint+0x41>
    buf[i++] = '-';
80100829:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
8010082e:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
80100831:	8d 71 ff             	lea    -0x1(%ecx),%esi
80100834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
80100838:	0f be 04 33          	movsbl (%ebx,%esi,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010083c:	83 ee 01             	sub    $0x1,%esi
    consputc(buf[i]);
8010083f:	e8 0c fc ff ff       	call   80100450 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100844:	83 fe ff             	cmp    $0xffffffff,%esi
80100847:	75 ef                	jne    80100838 <printint+0x48>
    consputc(buf[i]);
}
80100849:	83 c4 1c             	add    $0x1c,%esp
8010084c:	5b                   	pop    %ebx
8010084d:	5e                   	pop    %esi
8010084e:	5f                   	pop    %edi
8010084f:	5d                   	pop    %ebp
80100850:	c3                   	ret    
80100851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
80100858:	f7 d8                	neg    %eax
8010085a:	bf 01 00 00 00       	mov    $0x1,%edi
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010085f:	eb a4                	jmp    80100805 <printint+0x15>
80100861:	eb 0d                	jmp    80100870 <cprintf>
80100863:	90                   	nop
80100864:	90                   	nop
80100865:	90                   	nop
80100866:	90                   	nop
80100867:	90                   	nop
80100868:	90                   	nop
80100869:	90                   	nop
8010086a:	90                   	nop
8010086b:	90                   	nop
8010086c:	90                   	nop
8010086d:	90                   	nop
8010086e:	90                   	nop
8010086f:	90                   	nop

80100870 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100870:	55                   	push   %ebp
80100871:	89 e5                	mov    %esp,%ebp
80100873:	57                   	push   %edi
80100874:	56                   	push   %esi
80100875:	53                   	push   %ebx
80100876:	83 ec 2c             	sub    $0x2c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100879:	8b 3d 74 a5 10 80    	mov    0x8010a574,%edi
  if(locking)
8010087f:	85 ff                	test   %edi,%edi
80100881:	0f 85 31 01 00 00    	jne    801009b8 <cprintf+0x148>
    acquire(&cons.lock);

  if (fmt == 0)
80100887:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010088a:	85 c9                	test   %ecx,%ecx
8010088c:	0f 84 37 01 00 00    	je     801009c9 <cprintf+0x159>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100892:	0f b6 01             	movzbl (%ecx),%eax
80100895:	85 c0                	test   %eax,%eax
80100897:	0f 84 8b 00 00 00    	je     80100928 <cprintf+0xb8>
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
8010089d:	8d 75 0c             	lea    0xc(%ebp),%esi
801008a0:	31 db                	xor    %ebx,%ebx
801008a2:	eb 3f                	jmp    801008e3 <cprintf+0x73>
801008a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
801008a8:	83 fa 25             	cmp    $0x25,%edx
801008ab:	0f 84 af 00 00 00    	je     80100960 <cprintf+0xf0>
801008b1:	83 fa 64             	cmp    $0x64,%edx
801008b4:	0f 84 86 00 00 00    	je     80100940 <cprintf+0xd0>
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801008ba:	b8 25 00 00 00       	mov    $0x25,%eax
801008bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008c2:	e8 89 fb ff ff       	call   80100450 <consputc>
      consputc(c);
801008c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008ca:	89 d0                	mov    %edx,%eax
801008cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008d0:	e8 7b fb ff ff       	call   80100450 <consputc>
801008d5:	8b 4d 08             	mov    0x8(%ebp),%ecx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008d8:	83 c3 01             	add    $0x1,%ebx
801008db:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
801008df:	85 c0                	test   %eax,%eax
801008e1:	74 45                	je     80100928 <cprintf+0xb8>
    if(c != '%'){
801008e3:	83 f8 25             	cmp    $0x25,%eax
801008e6:	75 e8                	jne    801008d0 <cprintf+0x60>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801008e8:	83 c3 01             	add    $0x1,%ebx
801008eb:	0f b6 14 19          	movzbl (%ecx,%ebx,1),%edx
    if(c == 0)
801008ef:	85 d2                	test   %edx,%edx
801008f1:	74 35                	je     80100928 <cprintf+0xb8>
      break;
    switch(c){
801008f3:	83 fa 70             	cmp    $0x70,%edx
801008f6:	74 0f                	je     80100907 <cprintf+0x97>
801008f8:	7e ae                	jle    801008a8 <cprintf+0x38>
801008fa:	83 fa 73             	cmp    $0x73,%edx
801008fd:	8d 76 00             	lea    0x0(%esi),%esi
80100900:	74 76                	je     80100978 <cprintf+0x108>
80100902:	83 fa 78             	cmp    $0x78,%edx
80100905:	75 b3                	jne    801008ba <cprintf+0x4a>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100907:	8b 06                	mov    (%esi),%eax
80100909:	31 c9                	xor    %ecx,%ecx
8010090b:	ba 10 00 00 00       	mov    $0x10,%edx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100910:	83 c3 01             	add    $0x1,%ebx
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100913:	83 c6 04             	add    $0x4,%esi
80100916:	e8 d5 fe ff ff       	call   801007f0 <printint>
8010091b:	8b 4d 08             	mov    0x8(%ebp),%ecx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010091e:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
80100922:	85 c0                	test   %eax,%eax
80100924:	75 bd                	jne    801008e3 <cprintf+0x73>
80100926:	66 90                	xchg   %ax,%ax
      consputc(c);
      break;
    }
  }

  if(locking)
80100928:	85 ff                	test   %edi,%edi
8010092a:	74 0c                	je     80100938 <cprintf+0xc8>
    release(&cons.lock);
8010092c:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100933:	e8 48 3e 00 00       	call   80104780 <release>
}
80100938:	83 c4 2c             	add    $0x2c,%esp
8010093b:	5b                   	pop    %ebx
8010093c:	5e                   	pop    %esi
8010093d:	5f                   	pop    %edi
8010093e:	5d                   	pop    %ebp
8010093f:	c3                   	ret    
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
80100940:	8b 06                	mov    (%esi),%eax
80100942:	b9 01 00 00 00       	mov    $0x1,%ecx
80100947:	ba 0a 00 00 00       	mov    $0xa,%edx
8010094c:	83 c6 04             	add    $0x4,%esi
8010094f:	e8 9c fe ff ff       	call   801007f0 <printint>
80100954:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
80100957:	e9 7c ff ff ff       	jmp    801008d8 <cprintf+0x68>
8010095c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100960:	b8 25 00 00 00       	mov    $0x25,%eax
80100965:	e8 e6 fa ff ff       	call   80100450 <consputc>
8010096a:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
8010096d:	e9 66 ff ff ff       	jmp    801008d8 <cprintf+0x68>
80100972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100978:	8b 16                	mov    (%esi),%edx
8010097a:	b8 71 73 10 80       	mov    $0x80107371,%eax
8010097f:	83 c6 04             	add    $0x4,%esi
80100982:	85 d2                	test   %edx,%edx
80100984:	0f 44 d0             	cmove  %eax,%edx
        s = "(null)";
      for(; *s; s++)
80100987:	0f b6 02             	movzbl (%edx),%eax
8010098a:	84 c0                	test   %al,%al
8010098c:	0f 84 46 ff ff ff    	je     801008d8 <cprintf+0x68>
80100992:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100995:	89 d3                	mov    %edx,%ebx
80100997:	90                   	nop
        consputc(*s);
80100998:	0f be c0             	movsbl %al,%eax
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
8010099b:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
8010099e:	e8 ad fa ff ff       	call   80100450 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801009a3:	0f b6 03             	movzbl (%ebx),%eax
801009a6:	84 c0                	test   %al,%al
801009a8:	75 ee                	jne    80100998 <cprintf+0x128>
801009aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801009ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
801009b0:	e9 23 ff ff ff       	jmp    801008d8 <cprintf+0x68>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801009b8:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801009bf:	e8 0c 3e 00 00       	call   801047d0 <acquire>
801009c4:	e9 be fe ff ff       	jmp    80100887 <cprintf+0x17>

  if (fmt == 0)
    panic("null fmt");
801009c9:	c7 04 24 68 73 10 80 	movl   $0x80107368,(%esp)
801009d0:	e8 fb f9 ff ff       	call   801003d0 <panic>
	...

801009e0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009e0:	55                   	push   %ebp
801009e1:	89 e5                	mov    %esp,%ebp
801009e3:	57                   	push   %edi
801009e4:	56                   	push   %esi
801009e5:	53                   	push   %ebx
801009e6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009ec:	e8 bf 23 00 00       	call   80102db0 <begin_op>

  if((ip = namei(path)) == 0){
801009f1:	8b 45 08             	mov    0x8(%ebp),%eax
801009f4:	89 04 24             	mov    %eax,(%esp)
801009f7:	e8 c4 14 00 00       	call   80101ec0 <namei>
801009fc:	85 c0                	test   %eax,%eax
801009fe:	89 c7                	mov    %eax,%edi
80100a00:	0f 84 32 02 00 00    	je     80100c38 <exec+0x258>
    end_op();
    return -1;
  }
  ilock(ip);
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 52 12 00 00       	call   80101c60 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a0e:	8d 45 94             	lea    -0x6c(%ebp),%eax
80100a11:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100a18:	00 
80100a19:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100a20:	00 
80100a21:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a25:	89 3c 24             	mov    %edi,(%esp)
80100a28:	e8 43 0e 00 00       	call   80101870 <readi>
80100a2d:	83 f8 34             	cmp    $0x34,%eax
80100a30:	0f 85 fa 01 00 00    	jne    80100c30 <exec+0x250>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a36:	81 7d 94 7f 45 4c 46 	cmpl   $0x464c457f,-0x6c(%ebp)
80100a3d:	0f 85 ed 01 00 00    	jne    80100c30 <exec+0x250>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a43:	e8 68 61 00 00       	call   80106bb0 <setupkvm>
80100a48:	85 c0                	test   %eax,%eax
80100a4a:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a50:	0f 84 da 01 00 00    	je     80100c30 <exec+0x250>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a56:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
80100a5b:	8b 5d b0             	mov    -0x50(%ebp),%ebx
80100a5e:	0f 84 d1 02 00 00    	je     80100d35 <exec+0x355>
80100a64:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a6b:	00 00 00 
80100a6e:	31 f6                	xor    %esi,%esi
80100a70:	eb 18                	jmp    80100a8a <exec+0xaa>
80100a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a78:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80100a7c:	83 c6 01             	add    $0x1,%esi
80100a7f:	39 f0                	cmp    %esi,%eax
80100a81:	0f 8e c1 00 00 00    	jle    80100b48 <exec+0x168>
80100a87:	83 c3 20             	add    $0x20,%ebx
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a8a:	8d 55 c8             	lea    -0x38(%ebp),%edx
80100a8d:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a94:	00 
80100a95:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100a99:	89 54 24 04          	mov    %edx,0x4(%esp)
80100a9d:	89 3c 24             	mov    %edi,(%esp)
80100aa0:	e8 cb 0d 00 00       	call   80101870 <readi>
80100aa5:	83 f8 20             	cmp    $0x20,%eax
80100aa8:	75 76                	jne    80100b20 <exec+0x140>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100aaa:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
80100aae:	75 c8                	jne    80100a78 <exec+0x98>
      continue;
    if(ph.memsz < ph.filesz)
80100ab0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ab3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
80100ab6:	72 68                	jb     80100b20 <exec+0x140>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab8:	03 45 d0             	add    -0x30(%ebp),%eax
80100abb:	72 63                	jb     80100b20 <exec+0x140>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abd:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ac1:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100ac7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100acd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80100ad1:	89 04 24             	mov    %eax,(%esp)
80100ad4:	e8 27 64 00 00       	call   80106f00 <allocuvm>
80100ad9:	85 c0                	test   %eax,%eax
80100adb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ae1:	74 3d                	je     80100b20 <exec+0x140>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ae6:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aeb:	75 33                	jne    80100b20 <exec+0x140>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aed:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100af0:	89 7c 24 08          	mov    %edi,0x8(%esp)
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	89 54 24 10          	mov    %edx,0x10(%esp)
80100afc:	8b 55 cc             	mov    -0x34(%ebp),%edx
80100aff:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b03:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100b09:	89 14 24             	mov    %edx,(%esp)
80100b0c:	e8 0f 65 00 00       	call   80107020 <loaduvm>
80100b11:	85 c0                	test   %eax,%eax
80100b13:	0f 89 5f ff ff ff    	jns    80100a78 <exec+0x98>
80100b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 82 62 00 00       	call   80106db0 <freevm>
  if(ip){
80100b2e:	85 ff                	test   %edi,%edi
80100b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b35:	0f 85 f5 00 00 00    	jne    80100c30 <exec+0x250>
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100b3b:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100b41:	5b                   	pop    %ebx
80100b42:	5e                   	pop    %esi
80100b43:	5f                   	pop    %edi
80100b44:	5d                   	pop    %ebp
80100b45:	c3                   	ret    
80100b46:	66 90                	xchg   %ax,%ax
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b48:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100b4e:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
80100b54:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80100b5a:	8d b3 00 20 00 00    	lea    0x2000(%ebx),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b60:	89 3c 24             	mov    %edi,(%esp)
80100b63:	e8 d8 10 00 00       	call   80101c40 <iunlockput>
  end_op();
80100b68:	e8 13 21 00 00       	call   80102c80 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b6d:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100b73:	89 74 24 08          	mov    %esi,0x8(%esp)
80100b77:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100b7b:	89 0c 24             	mov    %ecx,(%esp)
80100b7e:	e8 7d 63 00 00       	call   80106f00 <allocuvm>
80100b83:	85 c0                	test   %eax,%eax
80100b85:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b8b:	0f 84 96 00 00 00    	je     80100c27 <exec+0x247>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b91:	2d 00 20 00 00       	sub    $0x2000,%eax
80100b96:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b9a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100ba0:	89 04 24             	mov    %eax,(%esp)
80100ba3:	e8 a8 60 00 00       	call   80106c50 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
80100bab:	8b 02                	mov    (%edx),%eax
80100bad:	85 c0                	test   %eax,%eax
80100baf:	0f 84 8c 01 00 00    	je     80100d41 <exec+0x361>
80100bb5:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100bb8:	31 f6                	xor    %esi,%esi
80100bba:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100bc0:	eb 28                	jmp    80100bea <exec+0x20a>
80100bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bc8:	89 9c b5 10 ff ff ff 	mov    %ebx,-0xf0(%ebp,%esi,4)
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bd2:	83 c6 01             	add    $0x1,%esi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bd5:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100bdb:	8d 3c b0             	lea    (%eax,%esi,4),%edi
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bde:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100be1:	85 c0                	test   %eax,%eax
80100be3:	74 62                	je     80100c47 <exec+0x267>
    if(argc >= MAXARG)
80100be5:	83 fe 20             	cmp    $0x20,%esi
80100be8:	74 3d                	je     80100c27 <exec+0x247>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bea:	89 04 24             	mov    %eax,(%esp)
80100bed:	e8 ae 3e 00 00       	call   80104aa0 <strlen>
80100bf2:	f7 d0                	not    %eax
80100bf4:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf7:	8b 07                	mov    (%edi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf9:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bfc:	89 04 24             	mov    %eax,(%esp)
80100bff:	e8 9c 3e 00 00       	call   80104aa0 <strlen>
80100c04:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c0a:	83 c0 01             	add    $0x1,%eax
80100c0d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c11:	8b 07                	mov    (%edi),%eax
80100c13:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c17:	89 0c 24             	mov    %ecx,(%esp)
80100c1a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c1e:	e8 6d 5e 00 00       	call   80106a90 <copyout>
80100c23:	85 c0                	test   %eax,%eax
80100c25:	79 a1                	jns    80100bc8 <exec+0x1e8>
 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
80100c27:	31 ff                	xor    %edi,%edi
80100c29:	e9 f2 fe ff ff       	jmp    80100b20 <exec+0x140>
80100c2e:	66 90                	xchg   %ax,%ax

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c30:	89 3c 24             	mov    %edi,(%esp)
80100c33:	e8 08 10 00 00       	call   80101c40 <iunlockput>
    end_op();
80100c38:	e8 43 20 00 00       	call   80102c80 <end_op>
80100c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c42:	e9 f4 fe ff ff       	jmp    80100b3b <exec+0x15b>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c47:	8d 4e 03             	lea    0x3(%esi),%ecx
80100c4a:	8d 3c b5 04 00 00 00 	lea    0x4(,%esi,4),%edi
80100c51:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c58:	c7 84 8d 04 ff ff ff 	movl   $0x0,-0xfc(%ebp,%ecx,4)
80100c5f:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c63:	89 d9                	mov    %ebx,%ecx

  sp -= (3+argc+1) * 4;
80100c65:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c67:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c6b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c71:	29 f9                	sub    %edi,%ecx
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c73:	c7 85 04 ff ff ff ff 	movl   $0xffffffff,-0xfc(%ebp)
80100c7a:	ff ff ff 
  ustack[1] = argc;
80100c7d:	89 b5 08 ff ff ff    	mov    %esi,-0xf8(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c83:	89 8d 0c ff ff ff    	mov    %ecx,-0xf4(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c89:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c91:	89 04 24             	mov    %eax,(%esp)
80100c94:	e8 f7 5d 00 00       	call   80106a90 <copyout>
80100c99:	85 c0                	test   %eax,%eax
80100c9b:	78 8a                	js     80100c27 <exec+0x247>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100ca0:	0f b6 11             	movzbl (%ecx),%edx
80100ca3:	84 d2                	test   %dl,%dl
80100ca5:	74 19                	je     80100cc0 <exec+0x2e0>
80100ca7:	89 c8                	mov    %ecx,%eax
80100ca9:	83 c0 01             	add    $0x1,%eax
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == '/')
80100cb0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
80100cb6:	0f 44 c8             	cmove  %eax,%ecx
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb9:	83 c0 01             	add    $0x1,%eax
80100cbc:	84 d2                	test   %dl,%dl
80100cbe:	75 f0                	jne    80100cb0 <exec+0x2d0>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cc0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80100cca:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cd1:	00 
80100cd2:	83 c0 6c             	add    $0x6c,%eax
80100cd5:	89 04 24             	mov    %eax,(%esp)
80100cd8:	e8 83 3d 00 00       	call   80104a60 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cdd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ce3:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ce9:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100cec:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100cef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100cfb:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100cfd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d03:	8b 55 ac             	mov    -0x54(%ebp),%edx
80100d06:	8b 40 18             	mov    0x18(%eax),%eax
80100d09:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100d0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d12:	8b 40 18             	mov    0x18(%eax),%eax
80100d15:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(proc);
80100d18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d1e:	89 04 24             	mov    %eax,(%esp)
80100d21:	e8 ba 63 00 00       	call   801070e0 <switchuvm>
  freevm(oldpgdir);
80100d26:	89 34 24             	mov    %esi,(%esp)
80100d29:	e8 82 60 00 00       	call   80106db0 <freevm>
80100d2e:	31 c0                	xor    %eax,%eax
  return 0;
80100d30:	e9 06 fe ff ff       	jmp    80100b3b <exec+0x15b>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d35:	be 00 20 00 00       	mov    $0x2000,%esi
80100d3a:	31 db                	xor    %ebx,%ebx
80100d3c:	e9 1f fe ff ff       	jmp    80100b60 <exec+0x180>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d41:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100d47:	b0 10                	mov    $0x10,%al
80100d49:	bf 04 00 00 00       	mov    $0x4,%edi
80100d4e:	b9 03 00 00 00       	mov    $0x3,%ecx
80100d53:	31 f6                	xor    %esi,%esi
80100d55:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
80100d5b:	e9 f8 fe ff ff       	jmp    80100c58 <exec+0x278>

80100d60 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	57                   	push   %edi
80100d64:	56                   	push   %esi
80100d65:	53                   	push   %ebx
80100d66:	83 ec 2c             	sub    $0x2c,%esp
80100d69:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d72:	8b 45 10             	mov    0x10(%ebp),%eax
80100d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100d78:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
80100d7c:	0f 84 ae 00 00 00    	je     80100e30 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100d82:	8b 03                	mov    (%ebx),%eax
80100d84:	83 f8 01             	cmp    $0x1,%eax
80100d87:	0f 84 c2 00 00 00    	je     80100e4f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100d8d:	83 f8 02             	cmp    $0x2,%eax
80100d90:	0f 85 d7 00 00 00    	jne    80100e6d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d99:	31 f6                	xor    %esi,%esi
80100d9b:	85 c0                	test   %eax,%eax
80100d9d:	7f 31                	jg     80100dd0 <filewrite+0x70>
80100d9f:	e9 9c 00 00 00       	jmp    80100e40 <filewrite+0xe0>
80100da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100da8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80100dab:	8b 53 10             	mov    0x10(%ebx),%edx
80100dae:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100db1:	89 14 24             	mov    %edx,(%esp)
80100db4:	e8 37 0e 00 00       	call   80101bf0 <iunlock>
      end_op();
80100db9:	e8 c2 1e 00 00       	call   80102c80 <end_op>
80100dbe:	8b 45 dc             	mov    -0x24(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80100dc1:	39 f8                	cmp    %edi,%eax
80100dc3:	0f 85 98 00 00 00    	jne    80100e61 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80100dc9:	01 c6                	add    %eax,%esi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100dcb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80100dce:	7e 70                	jle    80100e40 <filewrite+0xe0>
      int n1 = n - i;
80100dd0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80100dd3:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80100dd8:	29 f7                	sub    %esi,%edi
80100dda:	81 ff 00 1a 00 00    	cmp    $0x1a00,%edi
80100de0:	0f 4f f8             	cmovg  %eax,%edi
      if(n1 > max)
        n1 = max;

      begin_op();
80100de3:	e8 c8 1f 00 00       	call   80102db0 <begin_op>
      ilock(f->ip);
80100de8:	8b 43 10             	mov    0x10(%ebx),%eax
80100deb:	89 04 24             	mov    %eax,(%esp)
80100dee:	e8 6d 0e 00 00       	call   80101c60 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100df3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100df7:	8b 43 14             	mov    0x14(%ebx),%eax
80100dfa:	89 44 24 08          	mov    %eax,0x8(%esp)
80100dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e01:	01 f0                	add    %esi,%eax
80100e03:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e07:	8b 43 10             	mov    0x10(%ebx),%eax
80100e0a:	89 04 24             	mov    %eax,(%esp)
80100e0d:	e8 3e 09 00 00       	call   80101750 <writei>
80100e12:	85 c0                	test   %eax,%eax
80100e14:	7f 92                	jg     80100da8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80100e16:	8b 53 10             	mov    0x10(%ebx),%edx
80100e19:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100e1c:	89 14 24             	mov    %edx,(%esp)
80100e1f:	e8 cc 0d 00 00       	call   80101bf0 <iunlock>
      end_op();
80100e24:	e8 57 1e 00 00       	call   80102c80 <end_op>

      if(r < 0)
80100e29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e2c:	85 c0                	test   %eax,%eax
80100e2e:	74 91                	je     80100dc1 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100e30:	83 c4 2c             	add    $0x2c,%esp
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
80100e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e38:	5b                   	pop    %ebx
80100e39:	5e                   	pop    %esi
80100e3a:	5f                   	pop    %edi
80100e3b:	5d                   	pop    %ebp
80100e3c:	c3                   	ret    
80100e3d:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80100e40:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  }
  panic("filewrite");
80100e43:	89 f0                	mov    %esi,%eax
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80100e45:	75 e9                	jne    80100e30 <filewrite+0xd0>
  }
  panic("filewrite");
}
80100e47:	83 c4 2c             	add    $0x2c,%esp
80100e4a:	5b                   	pop    %ebx
80100e4b:	5e                   	pop    %esi
80100e4c:	5f                   	pop    %edi
80100e4d:	5d                   	pop    %ebp
80100e4e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
80100e4f:	8b 43 0c             	mov    0xc(%ebx),%eax
80100e52:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100e55:	83 c4 2c             	add    $0x2c,%esp
80100e58:	5b                   	pop    %ebx
80100e59:	5e                   	pop    %esi
80100e5a:	5f                   	pop    %edi
80100e5b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
80100e5c:	e9 2f 26 00 00       	jmp    80103490 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80100e61:	c7 04 24 89 73 10 80 	movl   $0x80107389,(%esp)
80100e68:	e8 63 f5 ff ff       	call   801003d0 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
80100e6d:	c7 04 24 8f 73 10 80 	movl   $0x8010738f,(%esp)
80100e74:	e8 57 f5 ff ff       	call   801003d0 <panic>
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <fileread>:
}

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	83 ec 38             	sub    $0x38,%esp
80100e86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100e8c:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100e8f:	8b 75 0c             	mov    0xc(%ebp),%esi
80100e92:	89 7d fc             	mov    %edi,-0x4(%ebp)
80100e95:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100e98:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e9c:	74 5a                	je     80100ef8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100e9e:	8b 03                	mov    (%ebx),%eax
80100ea0:	83 f8 01             	cmp    $0x1,%eax
80100ea3:	74 6b                	je     80100f10 <fileread+0x90>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ea5:	83 f8 02             	cmp    $0x2,%eax
80100ea8:	75 7d                	jne    80100f27 <fileread+0xa7>
    ilock(f->ip);
80100eaa:	8b 43 10             	mov    0x10(%ebx),%eax
80100ead:	89 04 24             	mov    %eax,(%esp)
80100eb0:	e8 ab 0d 00 00       	call   80101c60 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100eb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100eb9:	8b 43 14             	mov    0x14(%ebx),%eax
80100ebc:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ec0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ec4:	8b 43 10             	mov    0x10(%ebx),%eax
80100ec7:	89 04 24             	mov    %eax,(%esp)
80100eca:	e8 a1 09 00 00       	call   80101870 <readi>
80100ecf:	85 c0                	test   %eax,%eax
80100ed1:	7e 03                	jle    80100ed6 <fileread+0x56>
      f->off += r;
80100ed3:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100ed6:	8b 53 10             	mov    0x10(%ebx),%edx
80100ed9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100edc:	89 14 24             	mov    %edx,(%esp)
80100edf:	e8 0c 0d 00 00       	call   80101bf0 <iunlock>
    return r;
80100ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100ee7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100eea:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100eed:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100ef0:	89 ec                	mov    %ebp,%esp
80100ef2:	5d                   	pop    %ebp
80100ef3:	c3                   	ret    
80100ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ef8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f00:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100f03:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100f06:	89 ec                	mov    %ebp,%esp
80100f08:	5d                   	pop    %ebp
80100f09:	c3                   	ret    
80100f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f10:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f13:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100f16:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100f19:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f1c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f1f:	89 ec                	mov    %ebp,%esp
80100f21:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f22:	e9 69 24 00 00       	jmp    80103390 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100f27:	c7 04 24 99 73 10 80 	movl   $0x80107399,(%esp)
80100f2e:	e8 9d f4 ff ff       	call   801003d0 <panic>
80100f33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f40 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f40:	55                   	push   %ebp
  if(f->type == FD_INODE){
80100f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f46:	89 e5                	mov    %esp,%ebp
80100f48:	53                   	push   %ebx
80100f49:	83 ec 14             	sub    $0x14,%esp
80100f4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f4f:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f52:	74 0c                	je     80100f60 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
80100f54:	83 c4 14             	add    $0x14,%esp
80100f57:	5b                   	pop    %ebx
80100f58:	5d                   	pop    %ebp
80100f59:	c3                   	ret    
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
80100f60:	8b 43 10             	mov    0x10(%ebx),%eax
80100f63:	89 04 24             	mov    %eax,(%esp)
80100f66:	e8 f5 0c 00 00       	call   80101c60 <ilock>
    stati(f->ip, st);
80100f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f72:	8b 43 10             	mov    0x10(%ebx),%eax
80100f75:	89 04 24             	mov    %eax,(%esp)
80100f78:	e8 e3 01 00 00       	call   80101160 <stati>
    iunlock(f->ip);
80100f7d:	8b 43 10             	mov    0x10(%ebx),%eax
80100f80:	89 04 24             	mov    %eax,(%esp)
80100f83:	e8 68 0c 00 00       	call   80101bf0 <iunlock>
    return 0;
  }
  return -1;
}
80100f88:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
80100f8b:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
80100f8d:	5b                   	pop    %ebx
80100f8e:	5d                   	pop    %ebp
80100f8f:	c3                   	ret    

80100f90 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	53                   	push   %ebx
80100f94:	83 ec 14             	sub    $0x14,%esp
80100f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f9a:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100fa1:	e8 2a 38 00 00       	call   801047d0 <acquire>
  if(f->ref < 1)
80100fa6:	8b 43 04             	mov    0x4(%ebx),%eax
80100fa9:	85 c0                	test   %eax,%eax
80100fab:	7e 1a                	jle    80100fc7 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100fad:	83 c0 01             	add    $0x1,%eax
80100fb0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fb3:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100fba:	e8 c1 37 00 00       	call   80104780 <release>
  return f;
}
80100fbf:	89 d8                	mov    %ebx,%eax
80100fc1:	83 c4 14             	add    $0x14,%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5d                   	pop    %ebp
80100fc6:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100fc7:	c7 04 24 a2 73 10 80 	movl   $0x801073a2,(%esp)
80100fce:	e8 fd f3 ff ff       	call   801003d0 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
  initlock(&ftable.lock, "ftable");
}

// Allocate a file structure.
struct file*
filealloc(void)
80100fe4:	bb 2c 00 11 80       	mov    $0x8011002c,%ebx
{
80100fe9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fec:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100ff3:	e8 d8 37 00 00       	call   801047d0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100ff8:	8b 0d 18 00 11 80    	mov    0x80110018,%ecx
80100ffe:	85 c9                	test   %ecx,%ecx
80101000:	75 11                	jne    80101013 <filealloc+0x33>
80101002:	eb 4a                	jmp    8010104e <filealloc+0x6e>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101008:	83 c3 18             	add    $0x18,%ebx
8010100b:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80101011:	74 25                	je     80101038 <filealloc+0x58>
    if(f->ref == 0){
80101013:	8b 53 04             	mov    0x4(%ebx),%edx
80101016:	85 d2                	test   %edx,%edx
80101018:	75 ee                	jne    80101008 <filealloc+0x28>
      f->ref = 1;
8010101a:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80101021:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80101028:	e8 53 37 00 00       	call   80104780 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
8010102d:	89 d8                	mov    %ebx,%eax
8010102f:	83 c4 14             	add    $0x14,%esp
80101032:	5b                   	pop    %ebx
80101033:	5d                   	pop    %ebp
80101034:	c3                   	ret    
80101035:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101038:	31 db                	xor    %ebx,%ebx
8010103a:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80101041:	e8 3a 37 00 00       	call   80104780 <release>
  return 0;
}
80101046:	89 d8                	mov    %ebx,%eax
80101048:	83 c4 14             	add    $0x14,%esp
8010104b:	5b                   	pop    %ebx
8010104c:	5d                   	pop    %ebp
8010104d:	c3                   	ret    
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
8010104e:	bb 14 00 11 80       	mov    $0x80110014,%ebx
80101053:	eb c5                	jmp    8010101a <filealloc+0x3a>
80101055:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101060 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	83 ec 38             	sub    $0x38,%esp
80101066:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101069:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010106c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010106f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&ftable.lock);
80101072:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80101079:	e8 52 37 00 00       	call   801047d0 <acquire>
  if(f->ref < 1)
8010107e:	8b 43 04             	mov    0x4(%ebx),%eax
80101081:	85 c0                	test   %eax,%eax
80101083:	0f 8e a4 00 00 00    	jle    8010112d <fileclose+0xcd>
    panic("fileclose");
  if(--f->ref > 0){
80101089:	83 e8 01             	sub    $0x1,%eax
8010108c:	85 c0                	test   %eax,%eax
8010108e:	89 43 04             	mov    %eax,0x4(%ebx)
80101091:	74 1d                	je     801010b0 <fileclose+0x50>
    release(&ftable.lock);
80101093:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010109a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010109d:	8b 75 f8             	mov    -0x8(%ebp),%esi
801010a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
801010a3:	89 ec                	mov    %ebp,%esp
801010a5:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
801010a6:	e9 d5 36 00 00       	jmp    80104780 <release>
801010ab:	90                   	nop
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
801010b0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010b3:	8b 7b 10             	mov    0x10(%ebx),%edi
801010b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010b9:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801010bd:	88 45 e7             	mov    %al,-0x19(%ebp)
801010c0:	8b 33                	mov    (%ebx),%esi
  f->ref = 0;
801010c2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
801010c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
801010cf:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801010d6:	e8 a5 36 00 00       	call   80104780 <release>

  if(ff.type == FD_PIPE)
801010db:	83 fe 01             	cmp    $0x1,%esi
801010de:	74 38                	je     80101118 <fileclose+0xb8>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801010e0:	83 fe 02             	cmp    $0x2,%esi
801010e3:	74 13                	je     801010f8 <fileclose+0x98>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801010e5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801010e8:	8b 75 f8             	mov    -0x8(%ebp),%esi
801010eb:	8b 7d fc             	mov    -0x4(%ebp),%edi
801010ee:	89 ec                	mov    %ebp,%esp
801010f0:	5d                   	pop    %ebp
801010f1:	c3                   	ret    
801010f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
801010f8:	e8 b3 1c 00 00       	call   80102db0 <begin_op>
    iput(ff.ip);
801010fd:	89 3c 24             	mov    %edi,(%esp)
80101100:	e8 2b 03 00 00       	call   80101430 <iput>
    end_op();
  }
}
80101105:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101108:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010110b:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010110e:	89 ec                	mov    %ebp,%esp
80101110:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80101111:	e9 6a 1b 00 00       	jmp    80102c80 <end_op>
80101116:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80101118:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
8010111c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101120:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101123:	89 04 24             	mov    %eax,(%esp)
80101126:	e8 55 24 00 00       	call   80103580 <pipeclose>
8010112b:	eb b8                	jmp    801010e5 <fileclose+0x85>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
8010112d:	c7 04 24 aa 73 10 80 	movl   $0x801073aa,(%esp)
80101134:	e8 97 f2 ff ff       	call   801003d0 <panic>
80101139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101140 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80101146:	c7 44 24 04 b4 73 10 	movl   $0x801073b4,0x4(%esp)
8010114d:	80 
8010114e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80101155:	e8 e6 34 00 00       	call   80104640 <initlock>
}
8010115a:	c9                   	leave  
8010115b:	c3                   	ret    
8010115c:	00 00                	add    %al,(%eax)
	...

80101160 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	8b 55 08             	mov    0x8(%ebp),%edx
80101166:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101169:	8b 0a                	mov    (%edx),%ecx
8010116b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010116e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101171:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101174:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101178:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010117b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010117f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101183:	8b 52 58             	mov    0x58(%edx),%edx
80101186:	89 50 10             	mov    %edx,0x10(%eax)
}
80101189:	5d                   	pop    %ebp
8010118a:	c3                   	ret    
8010118b:	90                   	nop
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101190 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	53                   	push   %ebx
80101194:	83 ec 14             	sub    $0x14,%esp
80101197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010119a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801011a1:	e8 2a 36 00 00       	call   801047d0 <acquire>
  ip->ref++;
801011a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801011aa:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801011b1:	e8 ca 35 00 00       	call   80104780 <release>
  return ip;
}
801011b6:	89 d8                	mov    %ebx,%eax
801011b8:	83 c4 14             	add    $0x14,%esp
801011bb:	5b                   	pop    %ebx
801011bc:	5d                   	pop    %ebp
801011bd:	c3                   	ret    
801011be:	66 90                	xchg   %ax,%ax

801011c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	89 d7                	mov    %edx,%edi
801011c6:	56                   	push   %esi

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
801011c7:	31 f6                	xor    %esi,%esi
{
801011c9:	53                   	push   %ebx
801011ca:	89 c3                	mov    %eax,%ebx
801011cc:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011cf:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801011d6:	e8 f5 35 00 00       	call   801047d0 <acquire>

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
801011db:	b8 34 0a 11 80       	mov    $0x80110a34,%eax
801011e0:	eb 16                	jmp    801011f8 <iget+0x38>
801011e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011e8:	85 f6                	test   %esi,%esi
801011ea:	74 3c                	je     80101228 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011ec:	05 90 00 00 00       	add    $0x90,%eax
801011f1:	3d 54 26 11 80       	cmp    $0x80112654,%eax
801011f6:	74 48                	je     80101240 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011f8:	8b 48 08             	mov    0x8(%eax),%ecx
801011fb:	85 c9                	test   %ecx,%ecx
801011fd:	7e e9                	jle    801011e8 <iget+0x28>
801011ff:	39 18                	cmp    %ebx,(%eax)
80101201:	75 e5                	jne    801011e8 <iget+0x28>
80101203:	39 78 04             	cmp    %edi,0x4(%eax)
80101206:	75 e0                	jne    801011e8 <iget+0x28>
      ip->ref++;
80101208:	83 c1 01             	add    $0x1,%ecx
8010120b:	89 48 08             	mov    %ecx,0x8(%eax)
      release(&icache.lock);
8010120e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101211:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101218:	e8 63 35 00 00       	call   80104780 <release>
      return ip;
8010121d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
80101220:	83 c4 2c             	add    $0x2c,%esp
80101223:	5b                   	pop    %ebx
80101224:	5e                   	pop    %esi
80101225:	5f                   	pop    %edi
80101226:	5d                   	pop    %ebp
80101227:	c3                   	ret    
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101228:	85 c9                	test   %ecx,%ecx
8010122a:	0f 44 f0             	cmove  %eax,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122d:	05 90 00 00 00       	add    $0x90,%eax
80101232:	3d 54 26 11 80       	cmp    $0x80112654,%eax
80101237:	75 bf                	jne    801011f8 <iget+0x38>
80101239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101240:	85 f6                	test   %esi,%esi
80101242:	74 29                	je     8010126d <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101244:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
80101246:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
80101249:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
80101250:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101257:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010125e:	e8 1d 35 00 00       	call   80104780 <release>

  return ip;
}
80101263:	83 c4 2c             	add    $0x2c,%esp
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
80101266:	89 f0                	mov    %esi,%eax

  return ip;
}
80101268:	5b                   	pop    %ebx
80101269:	5e                   	pop    %esi
8010126a:	5f                   	pop    %edi
8010126b:	5d                   	pop    %ebp
8010126c:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
8010126d:	c7 04 24 bb 73 10 80 	movl   $0x801073bb,(%esp)
80101274:	e8 57 f1 ff ff       	call   801003d0 <panic>
80101279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101280 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101286:	8b 45 0c             	mov    0xc(%ebp),%eax
80101289:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101290:	00 
80101291:	89 44 24 04          	mov    %eax,0x4(%esp)
80101295:	8b 45 08             	mov    0x8(%ebp),%eax
80101298:	89 04 24             	mov    %eax,(%esp)
8010129b:	e8 10 37 00 00       	call   801049b0 <strncmp>
}
801012a0:	c9                   	leave  
801012a1:	c3                   	ret    
801012a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012b0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	56                   	push   %esi
801012b4:	53                   	push   %ebx
801012b5:	83 ec 10             	sub    $0x10,%esp
801012b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801012bb:	8b 43 04             	mov    0x4(%ebx),%eax
801012be:	c1 e8 03             	shr    $0x3,%eax
801012c1:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801012c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801012cb:	8b 03                	mov    (%ebx),%eax
801012cd:	89 04 24             	mov    %eax,(%esp)
801012d0:	e8 3b ee ff ff       	call   80100110 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
801012d5:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801012d9:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801012db:	8b 43 04             	mov    0x4(%ebx),%eax
801012de:	83 e0 07             	and    $0x7,%eax
801012e1:	c1 e0 06             	shl    $0x6,%eax
801012e4:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801012e8:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801012eb:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
801012ef:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801012f3:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
801012f7:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801012fb:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
801012ff:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101303:	8b 53 58             	mov    0x58(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101306:	83 c3 5c             	add    $0x5c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
80101309:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010130c:	83 c0 0c             	add    $0xc,%eax
8010130f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101313:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010131a:	00 
8010131b:	89 04 24             	mov    %eax,(%esp)
8010131e:	e8 1d 36 00 00       	call   80104940 <memmove>
  log_write(bp);
80101323:	89 34 24             	mov    %esi,(%esp)
80101326:	e8 95 17 00 00       	call   80102ac0 <log_write>
  brelse(bp);
8010132b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010132e:	83 c4 10             	add    $0x10,%esp
80101331:	5b                   	pop    %ebx
80101332:	5e                   	pop    %esi
80101333:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101334:	e9 07 ed ff ff       	jmp    80100040 <brelse>
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101340 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101346:	8b 45 08             	mov    0x8(%ebp),%eax
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101349:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010134c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010134f:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101352:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101359:	00 
8010135a:	89 04 24             	mov    %eax,(%esp)
8010135d:	e8 ae ed ff ff       	call   80100110 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101362:	89 34 24             	mov    %esi,(%esp)
80101365:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
8010136c:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
8010136d:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010136f:	8d 40 5c             	lea    0x5c(%eax),%eax
80101372:	89 44 24 04          	mov    %eax,0x4(%esp)
80101376:	e8 c5 35 00 00       	call   80104940 <memmove>
  brelse(bp);
}
8010137b:	8b 75 fc             	mov    -0x4(%ebp),%esi
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
8010137e:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101381:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80101384:	89 ec                	mov    %ebp,%esp
80101386:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101387:	e9 b4 ec ff ff       	jmp    80100040 <brelse>
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	83 ec 28             	sub    $0x28,%esp
80101396:	89 75 f8             	mov    %esi,-0x8(%ebp)
80101399:	89 d6                	mov    %edx,%esi
8010139b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010139e:	89 c3                	mov    %eax,%ebx
801013a0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013a3:	89 04 24             	mov    %eax,(%esp)
801013a6:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801013ad:	80 
801013ae:	e8 8d ff ff ff       	call   80101340 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013b3:	89 f0                	mov    %esi,%eax
801013b5:	c1 e8 0c             	shr    $0xc,%eax
801013b8:	03 05 f8 09 11 80    	add    0x801109f8,%eax
801013be:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
801013c1:	89 f3                	mov    %esi,%ebx
801013c3:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801013c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
801013cd:	c1 fb 03             	sar    $0x3,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801013d0:	e8 3b ed ff ff       	call   80100110 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013d5:	89 f1                	mov    %esi,%ecx
801013d7:	be 01 00 00 00       	mov    $0x1,%esi
801013dc:	83 e1 07             	and    $0x7,%ecx
801013df:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
801013e1:	0f b6 54 18 5c       	movzbl 0x5c(%eax,%ebx,1),%edx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801013e6:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
801013e8:	0f b6 c2             	movzbl %dl,%eax
801013eb:	85 f0                	test   %esi,%eax
801013ed:	74 27                	je     80101416 <bfree+0x86>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801013ef:	89 f0                	mov    %esi,%eax
801013f1:	f7 d0                	not    %eax
801013f3:	21 d0                	and    %edx,%eax
801013f5:	88 44 1f 5c          	mov    %al,0x5c(%edi,%ebx,1)
  log_write(bp);
801013f9:	89 3c 24             	mov    %edi,(%esp)
801013fc:	e8 bf 16 00 00       	call   80102ac0 <log_write>
  brelse(bp);
80101401:	89 3c 24             	mov    %edi,(%esp)
80101404:	e8 37 ec ff ff       	call   80100040 <brelse>
}
80101409:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010140c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010140f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101412:	89 ec                	mov    %ebp,%esp
80101414:	5d                   	pop    %ebp
80101415:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101416:	c7 04 24 cb 73 10 80 	movl   $0x801073cb,(%esp)
8010141d:	e8 ae ef ff ff       	call   801003d0 <panic>
80101422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101430 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	53                   	push   %ebx
80101436:	83 ec 2c             	sub    $0x2c,%esp
80101439:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010143c:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101443:	e8 88 33 00 00       	call   801047d0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101448:	8b 46 08             	mov    0x8(%esi),%eax
8010144b:	83 f8 01             	cmp    $0x1,%eax
8010144e:	74 20                	je     80101470 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
80101450:	83 e8 01             	sub    $0x1,%eax
80101453:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101456:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
8010145d:	83 c4 2c             	add    $0x2c,%esp
80101460:	5b                   	pop    %ebx
80101461:	5e                   	pop    %esi
80101462:	5f                   	pop    %edi
80101463:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
80101464:	e9 17 33 00 00       	jmp    80104780 <release>
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101470:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101474:	74 da                	je     80101450 <iput+0x20>
80101476:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010147b:	75 d3                	jne    80101450 <iput+0x20>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010147d:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101484:	89 f3                	mov    %esi,%ebx
80101486:	e8 f5 32 00 00       	call   80104780 <release>
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
8010148b:	8d 7e 30             	lea    0x30(%esi),%edi
8010148e:	eb 07                	jmp    80101497 <iput+0x67>
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
80101490:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101493:	39 fb                	cmp    %edi,%ebx
80101495:	74 19                	je     801014b0 <iput+0x80>
    if(ip->addrs[i]){
80101497:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010149a:	85 d2                	test   %edx,%edx
8010149c:	74 f2                	je     80101490 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
8010149e:	8b 06                	mov    (%esi),%eax
801014a0:	e8 eb fe ff ff       	call   80101390 <bfree>
      ip->addrs[i] = 0;
801014a5:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
801014ac:	eb e2                	jmp    80101490 <iput+0x60>
801014ae:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801014b0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801014b6:	85 c0                	test   %eax,%eax
801014b8:	75 3e                	jne    801014f8 <iput+0xc8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801014ba:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801014c1:	89 34 24             	mov    %esi,(%esp)
801014c4:	e8 e7 fd ff ff       	call   801012b0 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
801014c9:	66 c7 46 50 00 00    	movw   $0x0,0x50(%esi)
    iupdate(ip);
801014cf:	89 34 24             	mov    %esi,(%esp)
801014d2:	e8 d9 fd ff ff       	call   801012b0 <iupdate>
    acquire(&icache.lock);
801014d7:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801014de:	e8 ed 32 00 00       	call   801047d0 <acquire>
    ip->flags = 0;
801014e3:	8b 46 08             	mov    0x8(%esi),%eax
801014e6:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801014ed:	e9 5e ff ff ff       	jmp    80101450 <iput+0x20>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801014f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801014fc:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
801014fe:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101500:	89 04 24             	mov    %eax,(%esp)
80101503:	e8 08 ec ff ff       	call   80100110 <bread>
    a = (uint*)bp->data;
80101508:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010150a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010150d:	83 c7 5c             	add    $0x5c,%edi
80101510:	31 c0                	xor    %eax,%eax
80101512:	eb 11                	jmp    80101525 <iput+0xf5>
80101514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(j = 0; j < NINDIRECT; j++){
80101518:	83 c3 01             	add    $0x1,%ebx
8010151b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101521:	89 d8                	mov    %ebx,%eax
80101523:	74 10                	je     80101535 <iput+0x105>
      if(a[j])
80101525:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101528:	85 d2                	test   %edx,%edx
8010152a:	74 ec                	je     80101518 <iput+0xe8>
        bfree(ip->dev, a[j]);
8010152c:	8b 06                	mov    (%esi),%eax
8010152e:	e8 5d fe ff ff       	call   80101390 <bfree>
80101533:	eb e3                	jmp    80101518 <iput+0xe8>
    }
    brelse(bp);
80101535:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101538:	89 04 24             	mov    %eax,(%esp)
8010153b:	e8 00 eb ff ff       	call   80100040 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101540:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101546:	8b 06                	mov    (%esi),%eax
80101548:	e8 43 fe ff ff       	call   80101390 <bfree>
    ip->addrs[NDIRECT] = 0;
8010154d:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101554:	00 00 00 
80101557:	e9 5e ff ff ff       	jmp    801014ba <iput+0x8a>
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101560 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	57                   	push   %edi
80101564:	56                   	push   %esi
80101565:	53                   	push   %ebx
80101566:	83 ec 3c             	sub    $0x3c,%esp
80101569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010156c:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101571:	85 c0                	test   %eax,%eax
80101573:	0f 84 90 00 00 00    	je     80101609 <balloc+0xa9>
80101579:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101580:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101583:	c1 f8 0c             	sar    $0xc,%eax
80101586:	03 05 f8 09 11 80    	add    0x801109f8,%eax
8010158c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101590:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101593:	89 04 24             	mov    %eax,(%esp)
80101596:	e8 75 eb ff ff       	call   80100110 <bread>
8010159b:	8b 15 e0 09 11 80    	mov    0x801109e0,%edx
801015a1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801015a4:	89 55 e0             	mov    %edx,-0x20(%ebp)
801015a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801015aa:	31 c0                	xor    %eax,%eax
801015ac:	eb 35                	jmp    801015e3 <balloc+0x83>
801015ae:	66 90                	xchg   %ax,%ax
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801015b0:	89 c1                	mov    %eax,%ecx
801015b2:	bf 01 00 00 00       	mov    $0x1,%edi
801015b7:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015ba:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801015bc:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015be:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801015c1:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801015c4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015c7:	0f b6 74 11 5c       	movzbl 0x5c(%ecx,%edx,1),%esi
801015cc:	89 f1                	mov    %esi,%ecx
801015ce:	0f b6 f9             	movzbl %cl,%edi
801015d1:	85 7d d4             	test   %edi,-0x2c(%ebp)
801015d4:	74 42                	je     80101618 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015d6:	83 c0 01             	add    $0x1,%eax
801015d9:	83 c3 01             	add    $0x1,%ebx
801015dc:	3d 00 10 00 00       	cmp    $0x1000,%eax
801015e1:	74 05                	je     801015e8 <balloc+0x88>
801015e3:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
801015e6:	72 c8                	jb     801015b0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015eb:	89 14 24             	mov    %edx,(%esp)
801015ee:	e8 4d ea ff ff       	call   80100040 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015f3:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801015fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801015fd:	39 0d e0 09 11 80    	cmp    %ecx,0x801109e0
80101603:	0f 87 77 ff ff ff    	ja     80101580 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101609:	c7 04 24 de 73 10 80 	movl   $0x801073de,(%esp)
80101610:	e8 bb ed ff ff       	call   801003d0 <panic>
80101615:	8d 76 00             	lea    0x0(%esi),%esi
80101618:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
8010161b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010161e:	09 f1                	or     %esi,%ecx
80101620:	88 4c 17 5c          	mov    %cl,0x5c(%edi,%edx,1)
        log_write(bp);
80101624:	89 3c 24             	mov    %edi,(%esp)
80101627:	e8 94 14 00 00       	call   80102ac0 <log_write>
        brelse(bp);
8010162c:	89 3c 24             	mov    %edi,(%esp)
8010162f:	e8 0c ea ff ff       	call   80100040 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101634:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101637:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010163b:	89 04 24             	mov    %eax,(%esp)
8010163e:	e8 cd ea ff ff       	call   80100110 <bread>
  memset(bp->data, 0, BSIZE);
80101643:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010164a:	00 
8010164b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101652:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101653:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
80101655:	8d 40 5c             	lea    0x5c(%eax),%eax
80101658:	89 04 24             	mov    %eax,(%esp)
8010165b:	e8 10 32 00 00       	call   80104870 <memset>
  log_write(bp);
80101660:	89 34 24             	mov    %esi,(%esp)
80101663:	e8 58 14 00 00       	call   80102ac0 <log_write>
  brelse(bp);
80101668:	89 34 24             	mov    %esi,(%esp)
8010166b:	e8 d0 e9 ff ff       	call   80100040 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101670:	83 c4 3c             	add    $0x3c,%esp
80101673:	89 d8                	mov    %ebx,%eax
80101675:	5b                   	pop    %ebx
80101676:	5e                   	pop    %esi
80101677:	5f                   	pop    %edi
80101678:	5d                   	pop    %ebp
80101679:	c3                   	ret    
8010167a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101680 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	83 ec 38             	sub    $0x38,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101686:	83 fa 0b             	cmp    $0xb,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101689:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010168c:	89 c3                	mov    %eax,%ebx
8010168e:	89 75 f8             	mov    %esi,-0x8(%ebp)
80101691:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101694:	77 1a                	ja     801016b0 <bmap+0x30>
    if((addr = ip->addrs[bn]) == 0)
80101696:	8d 7a 14             	lea    0x14(%edx),%edi
80101699:	8b 44 b8 0c          	mov    0xc(%eax,%edi,4),%eax
8010169d:	85 c0                	test   %eax,%eax
8010169f:	74 6f                	je     80101710 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801016a1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801016a4:	8b 75 f8             	mov    -0x8(%ebp),%esi
801016a7:	8b 7d fc             	mov    -0x4(%ebp),%edi
801016aa:	89 ec                	mov    %ebp,%esp
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801016b0:	8d 7a f4             	lea    -0xc(%edx),%edi

  if(bn < NINDIRECT){
801016b3:	83 ff 7f             	cmp    $0x7f,%edi
801016b6:	77 7f                	ja     80101737 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801016b8:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801016be:	85 c0                	test   %eax,%eax
801016c0:	74 66                	je     80101728 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801016c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801016c6:	8b 03                	mov    (%ebx),%eax
801016c8:	89 04 24             	mov    %eax,(%esp)
801016cb:	e8 40 ea ff ff       	call   80100110 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801016d0:	8d 7c b8 5c          	lea    0x5c(%eax,%edi,4),%edi

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801016d4:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801016d6:	8b 07                	mov    (%edi),%eax
801016d8:	85 c0                	test   %eax,%eax
801016da:	75 17                	jne    801016f3 <bmap+0x73>
      a[bn] = addr = balloc(ip->dev);
801016dc:	8b 03                	mov    (%ebx),%eax
801016de:	e8 7d fe ff ff       	call   80101560 <balloc>
801016e3:	89 07                	mov    %eax,(%edi)
      log_write(bp);
801016e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801016e8:	89 34 24             	mov    %esi,(%esp)
801016eb:	e8 d0 13 00 00       	call   80102ac0 <log_write>
801016f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    }
    brelse(bp);
801016f3:	89 34 24             	mov    %esi,(%esp)
801016f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801016f9:	e8 42 e9 ff ff       	call   80100040 <brelse>
    return addr;
801016fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }

  panic("bmap: out of range");
}
80101701:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101704:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101707:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010170a:	89 ec                	mov    %ebp,%esp
8010170c:	5d                   	pop    %ebp
8010170d:	c3                   	ret    
8010170e:	66 90                	xchg   %ax,%ax
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101710:	8b 03                	mov    (%ebx),%eax
80101712:	e8 49 fe ff ff       	call   80101560 <balloc>
80101717:	89 44 bb 0c          	mov    %eax,0xc(%ebx,%edi,4)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010171b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010171e:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101721:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101724:	89 ec                	mov    %ebp,%esp
80101726:	5d                   	pop    %ebp
80101727:	c3                   	ret    
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101728:	8b 03                	mov    (%ebx),%eax
8010172a:	e8 31 fe ff ff       	call   80101560 <balloc>
8010172f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101735:	eb 8b                	jmp    801016c2 <bmap+0x42>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101737:	c7 04 24 f4 73 10 80 	movl   $0x801073f4,(%esp)
8010173e:	e8 8d ec ff ff       	call   801003d0 <panic>
80101743:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101750 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	83 ec 38             	sub    $0x38,%esp
80101756:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101759:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010175c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010175f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101762:	89 7d fc             	mov    %edi,-0x4(%ebp)
80101765:	8b 75 10             	mov    0x10(%ebp),%esi
80101768:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010176b:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101770:	74 1e                	je     80101790 <writei+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101772:	39 73 58             	cmp    %esi,0x58(%ebx)
80101775:	73 41                	jae    801017b8 <writei+0x68>

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010177c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010177f:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101782:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101785:	89 ec                	mov    %ebp,%esp
80101787:	5d                   	pop    %ebp
80101788:	c3                   	ret    
80101789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101790:	0f b7 43 52          	movzwl 0x52(%ebx),%eax
80101794:	66 83 f8 09          	cmp    $0x9,%ax
80101798:	77 dd                	ja     80101777 <writei+0x27>
8010179a:	98                   	cwtl   
8010179b:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
801017a2:	85 c0                	test   %eax,%eax
801017a4:	74 d1                	je     80101777 <writei+0x27>
      return -1;
    return devsw[ip->major].write(ip, src, n);
801017a6:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
801017a9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801017ac:	8b 75 f8             	mov    -0x8(%ebp),%esi
801017af:	8b 7d fc             	mov    -0x4(%ebp),%edi
801017b2:	89 ec                	mov    %ebp,%esp
801017b4:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
801017b5:	ff e0                	jmp    *%eax
801017b7:	90                   	nop
  }

  if(off > ip->size || off + n < off)
801017b8:	89 f8                	mov    %edi,%eax
801017ba:	01 f0                	add    %esi,%eax
801017bc:	72 b9                	jb     80101777 <writei+0x27>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801017be:	3d 00 18 01 00       	cmp    $0x11800,%eax
801017c3:	77 b2                	ja     80101777 <writei+0x27>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801017c5:	85 ff                	test   %edi,%edi
801017c7:	0f 84 8a 00 00 00    	je     80101857 <writei+0x107>
801017cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801017d4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017d7:	89 7d dc             	mov    %edi,-0x24(%ebp)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017da:	89 f2                	mov    %esi,%edx
801017dc:	89 d8                	mov    %ebx,%eax
801017de:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801017e1:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017e6:	e8 95 fe ff ff       	call   80101680 <bmap>
801017eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801017ef:	8b 03                	mov    (%ebx),%eax
801017f1:	89 04 24             	mov    %eax,(%esp)
801017f4:	e8 17 e9 ff ff       	call   80100110 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801017f9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801017fc:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017ff:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101801:	89 f0                	mov    %esi,%eax
80101803:	25 ff 01 00 00       	and    $0x1ff,%eax
80101808:	29 c7                	sub    %eax,%edi
8010180a:	39 cf                	cmp    %ecx,%edi
8010180c:	0f 47 f9             	cmova  %ecx,%edi
    memmove(bp->data + off%BSIZE, src, m);
8010180f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101812:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101816:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101818:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010181b:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010181f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80101823:	89 04 24             	mov    %eax,(%esp)
80101826:	e8 15 31 00 00       	call   80104940 <memmove>
    log_write(bp);
8010182b:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010182e:	89 14 24             	mov    %edx,(%esp)
80101831:	e8 8a 12 00 00       	call   80102ac0 <log_write>
    brelse(bp);
80101836:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101839:	89 14 24             	mov    %edx,(%esp)
8010183c:	e8 ff e7 ff ff       	call   80100040 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101841:	01 7d e4             	add    %edi,-0x1c(%ebp)
80101844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101847:	01 7d e0             	add    %edi,-0x20(%ebp)
8010184a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
8010184d:	77 8b                	ja     801017da <writei+0x8a>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010184f:	3b 73 58             	cmp    0x58(%ebx),%esi
80101852:	8b 7d dc             	mov    -0x24(%ebp),%edi
80101855:	77 07                	ja     8010185e <writei+0x10e>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101857:	89 f8                	mov    %edi,%eax
80101859:	e9 1e ff ff ff       	jmp    8010177c <writei+0x2c>
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
8010185e:	89 73 58             	mov    %esi,0x58(%ebx)
    iupdate(ip);
80101861:	89 1c 24             	mov    %ebx,(%esp)
80101864:	e8 47 fa ff ff       	call   801012b0 <iupdate>
  }
  return n;
80101869:	89 f8                	mov    %edi,%eax
8010186b:	e9 0c ff ff ff       	jmp    8010177c <writei+0x2c>

80101870 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	83 ec 38             	sub    $0x38,%esp
80101876:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101879:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010187c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010187f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101882:	89 7d fc             	mov    %edi,-0x4(%ebp)
80101885:	8b 75 10             	mov    0x10(%ebp),%esi
80101888:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010188b:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101890:	74 1e                	je     801018b0 <readi+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101892:	8b 43 58             	mov    0x58(%ebx),%eax
80101895:	39 f0                	cmp    %esi,%eax
80101897:	73 3f                	jae    801018d8 <readi+0x68>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101899:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010189e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801018a1:	8b 75 f8             	mov    -0x8(%ebp),%esi
801018a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801018a7:	89 ec                	mov    %ebp,%esp
801018a9:	5d                   	pop    %ebp
801018aa:	c3                   	ret    
801018ab:	90                   	nop
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801018b0:	0f b7 43 52          	movzwl 0x52(%ebx),%eax
801018b4:	66 83 f8 09          	cmp    $0x9,%ax
801018b8:	77 df                	ja     80101899 <readi+0x29>
801018ba:	98                   	cwtl   
801018bb:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
801018c2:	85 c0                	test   %eax,%eax
801018c4:	74 d3                	je     80101899 <readi+0x29>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801018c6:	89 4d 10             	mov    %ecx,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
801018c9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801018cc:	8b 75 f8             	mov    -0x8(%ebp),%esi
801018cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
801018d2:	89 ec                	mov    %ebp,%esp
801018d4:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801018d5:	ff e0                	jmp    *%eax
801018d7:	90                   	nop
  }

  if(off > ip->size || off + n < off)
801018d8:	89 ca                	mov    %ecx,%edx
801018da:	01 f2                	add    %esi,%edx
801018dc:	89 55 e0             	mov    %edx,-0x20(%ebp)
801018df:	72 b8                	jb     80101899 <readi+0x29>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801018e1:	89 c2                	mov    %eax,%edx
801018e3:	29 f2                	sub    %esi,%edx
801018e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
801018e8:	0f 42 ca             	cmovb  %edx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801018eb:	85 c9                	test   %ecx,%ecx
801018ed:	74 7e                	je     8010196d <readi+0xfd>
801018ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801018f6:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018f9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101900:	89 f2                	mov    %esi,%edx
80101902:	89 d8                	mov    %ebx,%eax
80101904:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101907:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010190c:	e8 6f fd ff ff       	call   80101680 <bmap>
80101911:	89 44 24 04          	mov    %eax,0x4(%esp)
80101915:	8b 03                	mov    (%ebx),%eax
80101917:	89 04 24             	mov    %eax,(%esp)
8010191a:	e8 f1 e7 ff ff       	call   80100110 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010191f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101922:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101925:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101927:	89 f0                	mov    %esi,%eax
80101929:	25 ff 01 00 00       	and    $0x1ff,%eax
8010192e:	29 c7                	sub    %eax,%edi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101930:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101934:	39 cf                	cmp    %ecx,%edi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101936:	89 44 24 04          	mov    %eax,0x4(%esp)
8010193a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
8010193d:	0f 47 f9             	cmova  %ecx,%edi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101940:	89 55 d8             	mov    %edx,-0x28(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101943:	01 fe                	add    %edi,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101945:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101949:	89 04 24             	mov    %eax,(%esp)
8010194c:	e8 ef 2f 00 00       	call   80104940 <memmove>
    brelse(bp);
80101951:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101954:	89 14 24             	mov    %edx,(%esp)
80101957:	e8 e4 e6 ff ff       	call   80100040 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010195c:	01 7d e4             	add    %edi,-0x1c(%ebp)
8010195f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101962:	01 7d e0             	add    %edi,-0x20(%ebp)
80101965:	39 55 dc             	cmp    %edx,-0x24(%ebp)
80101968:	77 96                	ja     80101900 <readi+0x90>
8010196a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010196d:	89 c8                	mov    %ecx,%eax
8010196f:	e9 2a ff ff ff       	jmp    8010189e <readi+0x2e>
80101974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010197a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101980 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 2c             	sub    $0x2c,%esp
80101989:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010198c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101991:	0f 85 8c 00 00 00    	jne    80101a23 <dirlookup+0xa3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101997:	8b 4b 58             	mov    0x58(%ebx),%ecx
8010199a:	85 c9                	test   %ecx,%ecx
8010199c:	74 4c                	je     801019ea <dirlookup+0x6a>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
8010199e:	8d 7d d8             	lea    -0x28(%ebp),%edi
801019a1:	31 f6                	xor    %esi,%esi
801019a3:	90                   	nop
801019a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019a8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801019af:	00 
801019b0:	89 74 24 08          	mov    %esi,0x8(%esp)
801019b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
801019b8:	89 1c 24             	mov    %ebx,(%esp)
801019bb:	e8 b0 fe ff ff       	call   80101870 <readi>
801019c0:	83 f8 10             	cmp    $0x10,%eax
801019c3:	75 52                	jne    80101a17 <dirlookup+0x97>
      panic("dirlink read");
    if(de.inum == 0)
801019c5:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801019ca:	74 16                	je     801019e2 <dirlookup+0x62>
      continue;
    if(namecmp(name, de.name) == 0){
801019cc:	8d 45 da             	lea    -0x26(%ebp),%eax
801019cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801019d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801019d6:	89 04 24             	mov    %eax,(%esp)
801019d9:	e8 a2 f8 ff ff       	call   80101280 <namecmp>
801019de:	85 c0                	test   %eax,%eax
801019e0:	74 16                	je     801019f8 <dirlookup+0x78>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801019e2:	83 c6 10             	add    $0x10,%esi
801019e5:	39 73 58             	cmp    %esi,0x58(%ebx)
801019e8:	77 be                	ja     801019a8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801019ea:	83 c4 2c             	add    $0x2c,%esp
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801019ed:	31 c0                	xor    %eax,%eax
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801019ef:	5b                   	pop    %ebx
801019f0:	5e                   	pop    %esi
801019f1:	5f                   	pop    %edi
801019f2:	5d                   	pop    %ebp
801019f3:	c3                   	ret    
801019f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
      // entry matches path element
      if(poff)
801019f8:	8b 55 10             	mov    0x10(%ebp),%edx
801019fb:	85 d2                	test   %edx,%edx
801019fd:	74 05                	je     80101a04 <dirlookup+0x84>
        *poff = off;
801019ff:	8b 45 10             	mov    0x10(%ebp),%eax
80101a02:	89 30                	mov    %esi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101a04:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101a08:	8b 03                	mov    (%ebx),%eax
80101a0a:	e8 b1 f7 ff ff       	call   801011c0 <iget>
    }
  }

  return 0;
}
80101a0f:	83 c4 2c             	add    $0x2c,%esp
80101a12:	5b                   	pop    %ebx
80101a13:	5e                   	pop    %esi
80101a14:	5f                   	pop    %edi
80101a15:	5d                   	pop    %ebp
80101a16:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101a17:	c7 04 24 19 74 10 80 	movl   $0x80107419,(%esp)
80101a1e:	e8 ad e9 ff ff       	call   801003d0 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101a23:	c7 04 24 07 74 10 80 	movl   $0x80107407,(%esp)
80101a2a:	e8 a1 e9 ff ff       	call   801003d0 <panic>
80101a2f:	90                   	nop

80101a30 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 2c             	sub    $0x2c,%esp
80101a39:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101a46:	00 
80101a47:	89 34 24             	mov    %esi,(%esp)
80101a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a4e:	e8 2d ff ff ff       	call   80101980 <dirlookup>
80101a53:	85 c0                	test   %eax,%eax
80101a55:	0f 85 89 00 00 00    	jne    80101ae4 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a5b:	8b 5e 58             	mov    0x58(%esi),%ebx
80101a5e:	85 db                	test   %ebx,%ebx
80101a60:	0f 84 8d 00 00 00    	je     80101af3 <dirlink+0xc3>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
80101a66:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101a69:	31 db                	xor    %ebx,%ebx
80101a6b:	eb 0b                	jmp    80101a78 <dirlink+0x48>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a70:	83 c3 10             	add    $0x10,%ebx
80101a73:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a76:	76 24                	jbe    80101a9c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a78:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101a7f:	00 
80101a80:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101a84:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101a88:	89 34 24             	mov    %esi,(%esp)
80101a8b:	e8 e0 fd ff ff       	call   80101870 <readi>
80101a90:	83 f8 10             	cmp    $0x10,%eax
80101a93:	75 65                	jne    80101afa <dirlink+0xca>
      panic("dirlink read");
    if(de.inum == 0)
80101a95:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a9a:	75 d4                	jne    80101a70 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a9f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101aa6:	00 
80101aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101aab:	8d 45 da             	lea    -0x26(%ebp),%eax
80101aae:	89 04 24             	mov    %eax,(%esp)
80101ab1:	e8 5a 2f 00 00       	call   80104a10 <strncpy>
  de.inum = inum;
80101ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ab9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ac0:	00 
80101ac1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101ac5:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101ac9:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101acd:	89 34 24             	mov    %esi,(%esp)
80101ad0:	e8 7b fc ff ff       	call   80101750 <writei>
80101ad5:	83 f8 10             	cmp    $0x10,%eax
80101ad8:	75 2c                	jne    80101b06 <dirlink+0xd6>
    panic("dirlink");
80101ada:	31 c0                	xor    %eax,%eax

  return 0;
}
80101adc:	83 c4 2c             	add    $0x2c,%esp
80101adf:	5b                   	pop    %ebx
80101ae0:	5e                   	pop    %esi
80101ae1:	5f                   	pop    %edi
80101ae2:	5d                   	pop    %ebp
80101ae3:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ae4:	89 04 24             	mov    %eax,(%esp)
80101ae7:	e8 44 f9 ff ff       	call   80101430 <iput>
80101aec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
80101af1:	eb e9                	jmp    80101adc <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101af3:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101af6:	31 db                	xor    %ebx,%ebx
80101af8:	eb a2                	jmp    80101a9c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101afa:	c7 04 24 19 74 10 80 	movl   $0x80107419,(%esp)
80101b01:	e8 ca e8 ff ff       	call   801003d0 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101b06:	c7 04 24 62 7a 10 80 	movl   $0x80107a62,(%esp)
80101b0d:	e8 be e8 ff ff       	call   801003d0 <panic>
80101b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b20 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 2c             	sub    $0x2c,%esp
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101b2c:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101b33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b36:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
80101b3a:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101b3e:	0f 86 95 00 00 00    	jbe    80101bd9 <ialloc+0xb9>
80101b44:	be 01 00 00 00       	mov    $0x1,%esi
80101b49:	bb 01 00 00 00       	mov    $0x1,%ebx
80101b4e:	eb 15                	jmp    80101b65 <ialloc+0x45>
80101b50:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101b53:	89 3c 24             	mov    %edi,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101b56:	89 de                	mov    %ebx,%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101b58:	e8 e3 e4 ff ff       	call   80100040 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101b5d:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101b63:	76 74                	jbe    80101bd9 <ialloc+0xb9>
    bp = bread(dev, IBLOCK(inum, sb));
80101b65:	89 f0                	mov    %esi,%eax
80101b67:	c1 e8 03             	shr    $0x3,%eax
80101b6a:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101b70:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b77:	89 04 24             	mov    %eax,(%esp)
80101b7a:	e8 91 e5 ff ff       	call   80100110 <bread>
80101b7f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101b81:	89 f0                	mov    %esi,%eax
80101b83:	83 e0 07             	and    $0x7,%eax
80101b86:	c1 e0 06             	shl    $0x6,%eax
80101b89:	8d 54 07 5c          	lea    0x5c(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
80101b8d:	66 83 3a 00          	cmpw   $0x0,(%edx)
80101b91:	75 bd                	jne    80101b50 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b93:	89 14 24             	mov    %edx,(%esp)
80101b96:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b99:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101ba0:	00 
80101ba1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101ba8:	00 
80101ba9:	e8 c2 2c 00 00       	call   80104870 <memset>
      dip->type = type;
80101bae:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bb1:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
80101bb5:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
80101bb8:	89 3c 24             	mov    %edi,(%esp)
80101bbb:	e8 00 0f 00 00       	call   80102ac0 <log_write>
      brelse(bp);
80101bc0:	89 3c 24             	mov    %edi,(%esp)
80101bc3:	e8 78 e4 ff ff       	call   80100040 <brelse>
      return iget(dev, inum);
80101bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bcb:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101bcd:	83 c4 2c             	add    $0x2c,%esp
80101bd0:	5b                   	pop    %ebx
80101bd1:	5e                   	pop    %esi
80101bd2:	5f                   	pop    %edi
80101bd3:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101bd4:	e9 e7 f5 ff ff       	jmp    801011c0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101bd9:	c7 04 24 26 74 10 80 	movl   $0x80107426,(%esp)
80101be0:	e8 eb e7 ff ff       	call   801003d0 <panic>
80101be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	83 ec 18             	sub    $0x18,%esp
80101bf6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101bfc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bff:	85 db                	test   %ebx,%ebx
80101c01:	74 27                	je     80101c2a <iunlock+0x3a>
80101c03:	8d 73 0c             	lea    0xc(%ebx),%esi
80101c06:	89 34 24             	mov    %esi,(%esp)
80101c09:	e8 22 29 00 00       	call   80104530 <holdingsleep>
80101c0e:	85 c0                	test   %eax,%eax
80101c10:	74 18                	je     80101c2a <iunlock+0x3a>
80101c12:	8b 43 08             	mov    0x8(%ebx),%eax
80101c15:	85 c0                	test   %eax,%eax
80101c17:	7e 11                	jle    80101c2a <iunlock+0x3a>
    panic("iunlock");

  releasesleep(&ip->lock);
80101c19:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101c1c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80101c1f:	8b 75 fc             	mov    -0x4(%ebp),%esi
80101c22:	89 ec                	mov    %ebp,%esp
80101c24:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
80101c25:	e9 36 29 00 00       	jmp    80104560 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101c2a:	c7 04 24 38 74 10 80 	movl   $0x80107438,(%esp)
80101c31:	e8 9a e7 ff ff       	call   801003d0 <panic>
80101c36:	8d 76 00             	lea    0x0(%esi),%esi
80101c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c40 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	53                   	push   %ebx
80101c44:	83 ec 14             	sub    $0x14,%esp
80101c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101c4a:	89 1c 24             	mov    %ebx,(%esp)
80101c4d:	e8 9e ff ff ff       	call   80101bf0 <iunlock>
  iput(ip);
80101c52:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101c55:	83 c4 14             	add    $0x14,%esp
80101c58:	5b                   	pop    %ebx
80101c59:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101c5a:	e9 d1 f7 ff ff       	jmp    80101430 <iput>
80101c5f:	90                   	nop

80101c60 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	56                   	push   %esi
80101c64:	53                   	push   %ebx
80101c65:	83 ec 10             	sub    $0x10,%esp
80101c68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101c6b:	85 db                	test   %ebx,%ebx
80101c6d:	0f 84 b0 00 00 00    	je     80101d23 <ilock+0xc3>
80101c73:	8b 53 08             	mov    0x8(%ebx),%edx
80101c76:	85 d2                	test   %edx,%edx
80101c78:	0f 8e a5 00 00 00    	jle    80101d23 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
80101c7e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101c81:	89 04 24             	mov    %eax,(%esp)
80101c84:	e8 17 29 00 00       	call   801045a0 <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101c89:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
80101c8d:	74 09                	je     80101c98 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101c8f:	83 c4 10             	add    $0x10,%esp
80101c92:	5b                   	pop    %ebx
80101c93:	5e                   	pop    %esi
80101c94:	5d                   	pop    %ebp
80101c95:	c3                   	ret    
80101c96:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c98:	8b 43 04             	mov    0x4(%ebx),%eax
80101c9b:	c1 e8 03             	shr    $0x3,%eax
80101c9e:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ca8:	8b 03                	mov    (%ebx),%eax
80101caa:	89 04 24             	mov    %eax,(%esp)
80101cad:	e8 5e e4 ff ff       	call   80100110 <bread>
80101cb2:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101cb4:	8b 43 04             	mov    0x4(%ebx),%eax
80101cb7:	83 e0 07             	and    $0x7,%eax
80101cba:	c1 e0 06             	shl    $0x6,%eax
80101cbd:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101cc1:	0f b7 10             	movzwl (%eax),%edx
80101cc4:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101cc8:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ccc:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101cd0:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101cd4:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101cd8:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101cdc:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101ce0:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ce3:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
80101ce6:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ced:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101cf0:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101cf7:	00 
80101cf8:	89 04 24             	mov    %eax,(%esp)
80101cfb:	e8 40 2c 00 00       	call   80104940 <memmove>
    brelse(bp);
80101d00:	89 34 24             	mov    %esi,(%esp)
80101d03:	e8 38 e3 ff ff       	call   80100040 <brelse>
    ip->flags |= I_VALID;
80101d08:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
80101d0c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101d11:	0f 85 78 ff ff ff    	jne    80101c8f <ilock+0x2f>
      panic("ilock: no type");
80101d17:	c7 04 24 46 74 10 80 	movl   $0x80107446,(%esp)
80101d1e:	e8 ad e6 ff ff       	call   801003d0 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101d23:	c7 04 24 40 74 10 80 	movl   $0x80107440,(%esp)
80101d2a:	e8 a1 e6 ff ff       	call   801003d0 <panic>
80101d2f:	90                   	nop

80101d30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	89 c3                	mov    %eax,%ebx
80101d38:	83 ec 2c             	sub    $0x2c,%esp
80101d3b:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d3e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d41:	80 38 2f             	cmpb   $0x2f,(%eax)
80101d44:	0f 84 14 01 00 00    	je     80101e5e <namex+0x12e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101d4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101d50:	8b 40 68             	mov    0x68(%eax),%eax
80101d53:	89 04 24             	mov    %eax,(%esp)
80101d56:	e8 35 f4 ff ff       	call   80101190 <idup>
80101d5b:	89 c7                	mov    %eax,%edi
80101d5d:	eb 04                	jmp    80101d63 <namex+0x33>
80101d5f:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d60:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d63:	0f b6 03             	movzbl (%ebx),%eax
80101d66:	3c 2f                	cmp    $0x2f,%al
80101d68:	74 f6                	je     80101d60 <namex+0x30>
    path++;
  if(*path == 0)
80101d6a:	84 c0                	test   %al,%al
80101d6c:	75 1a                	jne    80101d88 <namex+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d6e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101d71:	85 c9                	test   %ecx,%ecx
80101d73:	0f 85 0d 01 00 00    	jne    80101e86 <namex+0x156>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d79:	83 c4 2c             	add    $0x2c,%esp
80101d7c:	89 f8                	mov    %edi,%eax
80101d7e:	5b                   	pop    %ebx
80101d7f:	5e                   	pop    %esi
80101d80:	5f                   	pop    %edi
80101d81:	5d                   	pop    %ebp
80101d82:	c3                   	ret    
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d88:	3c 2f                	cmp    $0x2f,%al
80101d8a:	0f 84 91 00 00 00    	je     80101e21 <namex+0xf1>
80101d90:	89 de                	mov    %ebx,%esi
80101d92:	eb 08                	jmp    80101d9c <namex+0x6c>
80101d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d98:	3c 2f                	cmp    $0x2f,%al
80101d9a:	74 0a                	je     80101da6 <namex+0x76>
    path++;
80101d9c:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d9f:	0f b6 06             	movzbl (%esi),%eax
80101da2:	84 c0                	test   %al,%al
80101da4:	75 f2                	jne    80101d98 <namex+0x68>
80101da6:	89 f2                	mov    %esi,%edx
80101da8:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101daa:	83 fa 0d             	cmp    $0xd,%edx
80101dad:	7e 79                	jle    80101e28 <namex+0xf8>
    memmove(name, s, DIRSIZ);
80101daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101db2:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101db9:	00 
80101dba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dbe:	89 04 24             	mov    %eax,(%esp)
80101dc1:	e8 7a 2b 00 00       	call   80104940 <memmove>
80101dc6:	eb 03                	jmp    80101dcb <namex+0x9b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
80101dc8:	83 c6 01             	add    $0x1,%esi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101dcb:	80 3e 2f             	cmpb   $0x2f,(%esi)
80101dce:	74 f8                	je     80101dc8 <namex+0x98>
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80101dd0:	85 f6                	test   %esi,%esi
80101dd2:	74 9a                	je     80101d6e <namex+0x3e>
    ilock(ip);
80101dd4:	89 3c 24             	mov    %edi,(%esp)
80101dd7:	e8 84 fe ff ff       	call   80101c60 <ilock>
    if(ip->type != T_DIR){
80101ddc:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101de1:	75 67                	jne    80101e4a <namex+0x11a>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101de3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101de6:	85 db                	test   %ebx,%ebx
80101de8:	74 09                	je     80101df3 <namex+0xc3>
80101dea:	80 3e 00             	cmpb   $0x0,(%esi)
80101ded:	0f 84 81 00 00 00    	je     80101e74 <namex+0x144>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101df6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101dfd:	00 
80101dfe:	89 3c 24             	mov    %edi,(%esp)
80101e01:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e05:	e8 76 fb ff ff       	call   80101980 <dirlookup>
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	89 c3                	mov    %eax,%ebx
80101e0e:	74 3a                	je     80101e4a <namex+0x11a>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
80101e10:	89 3c 24             	mov    %edi,(%esp)
80101e13:	89 df                	mov    %ebx,%edi
80101e15:	89 f3                	mov    %esi,%ebx
80101e17:	e8 24 fe ff ff       	call   80101c40 <iunlockput>
80101e1c:	e9 42 ff ff ff       	jmp    80101d63 <namex+0x33>
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101e21:	89 de                	mov    %ebx,%esi
80101e23:	31 d2                	xor    %edx,%edx
80101e25:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e2b:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e36:	89 04 24             	mov    %eax,(%esp)
80101e39:	e8 02 2b 00 00       	call   80104940 <memmove>
    name[len] = 0;
80101e3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e44:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
80101e48:	eb 81                	jmp    80101dcb <namex+0x9b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
80101e4a:	89 3c 24             	mov    %edi,(%esp)
80101e4d:	31 ff                	xor    %edi,%edi
80101e4f:	e8 ec fd ff ff       	call   80101c40 <iunlockput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e54:	83 c4 2c             	add    $0x2c,%esp
80101e57:	89 f8                	mov    %edi,%eax
80101e59:	5b                   	pop    %ebx
80101e5a:	5e                   	pop    %esi
80101e5b:	5f                   	pop    %edi
80101e5c:	5d                   	pop    %ebp
80101e5d:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e5e:	ba 01 00 00 00       	mov    $0x1,%edx
80101e63:	b8 01 00 00 00       	mov    $0x1,%eax
80101e68:	e8 53 f3 ff ff       	call   801011c0 <iget>
80101e6d:	89 c7                	mov    %eax,%edi
80101e6f:	e9 ef fe ff ff       	jmp    80101d63 <namex+0x33>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e74:	89 3c 24             	mov    %edi,(%esp)
80101e77:	e8 74 fd ff ff       	call   80101bf0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e7c:	83 c4 2c             	add    $0x2c,%esp
80101e7f:	89 f8                	mov    %edi,%eax
80101e81:	5b                   	pop    %ebx
80101e82:	5e                   	pop    %esi
80101e83:	5f                   	pop    %edi
80101e84:	5d                   	pop    %ebp
80101e85:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e86:	89 3c 24             	mov    %edi,(%esp)
80101e89:	31 ff                	xor    %edi,%edi
80101e8b:	e8 a0 f5 ff ff       	call   80101430 <iput>
    return 0;
80101e90:	e9 e4 fe ff ff       	jmp    80101d79 <namex+0x49>
80101e95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ea0 <nameiparent>:
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ea0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ea1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ea6:	89 e5                	mov    %esp,%ebp
80101ea8:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eae:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eb1:	c9                   	leave  
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eb2:	e9 79 fe ff ff       	jmp    80101d30 <namex>
80101eb7:	89 f6                	mov    %esi,%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ec0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 5d fe ff ff       	call   80101d30 <namex>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	53                   	push   %ebx
  int i = 0;
  
  initlock(&icache.lock, "icache");
80101ee4:	31 db                	xor    %ebx,%ebx
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101ee6:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
80101ee9:	c7 44 24 04 55 74 10 	movl   $0x80107455,0x4(%esp)
80101ef0:	80 
80101ef1:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101ef8:	e8 43 27 00 00       	call   80104640 <initlock>
80101efd:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101f00:	8d 04 db             	lea    (%ebx,%ebx,8),%eax
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101f03:	83 c3 01             	add    $0x1,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101f06:	c1 e0 04             	shl    $0x4,%eax
80101f09:	05 40 0a 11 80       	add    $0x80110a40,%eax
80101f0e:	c7 44 24 04 5c 74 10 	movl   $0x8010745c,0x4(%esp)
80101f15:	80 
80101f16:	89 04 24             	mov    %eax,(%esp)
80101f19:	e8 e2 26 00 00       	call   80104600 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101f1e:	83 fb 32             	cmp    $0x32,%ebx
80101f21:	75 dd                	jne    80101f00 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
80101f23:	8b 45 08             	mov    0x8(%ebp),%eax
80101f26:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
80101f2d:	80 
80101f2e:	89 04 24             	mov    %eax,(%esp)
80101f31:	e8 0a f4 ff ff       	call   80101340 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101f36:	a1 f8 09 11 80       	mov    0x801109f8,%eax
80101f3b:	c7 04 24 64 74 10 80 	movl   $0x80107464,(%esp)
80101f42:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101f46:	a1 f4 09 11 80       	mov    0x801109f4,%eax
80101f4b:	89 44 24 18          	mov    %eax,0x18(%esp)
80101f4f:	a1 f0 09 11 80       	mov    0x801109f0,%eax
80101f54:	89 44 24 14          	mov    %eax,0x14(%esp)
80101f58:	a1 ec 09 11 80       	mov    0x801109ec,%eax
80101f5d:	89 44 24 10          	mov    %eax,0x10(%esp)
80101f61:	a1 e8 09 11 80       	mov    0x801109e8,%eax
80101f66:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101f6a:	a1 e4 09 11 80       	mov    0x801109e4,%eax
80101f6f:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f73:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101f78:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f7c:	e8 ef e8 ff ff       	call   80100870 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101f81:	83 c4 24             	add    $0x24,%esp
80101f84:	5b                   	pop    %ebx
80101f85:	5d                   	pop    %ebp
80101f86:	c3                   	ret    
	...

80101f90 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f90:	55                   	push   %ebp
80101f91:	89 c1                	mov    %eax,%ecx
80101f93:	89 e5                	mov    %esp,%ebp
80101f95:	56                   	push   %esi
80101f96:	53                   	push   %ebx
80101f97:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f9a:	85 c0                	test   %eax,%eax
80101f9c:	0f 84 99 00 00 00    	je     8010203b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fa2:	8b 58 08             	mov    0x8(%eax),%ebx
80101fa5:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101fab:	0f 87 7e 00 00 00    	ja     8010202f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fb1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb6:	66 90                	xchg   %ax,%ax
80101fb8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fb9:	25 c0 00 00 00       	and    $0xc0,%eax
80101fbe:	83 f8 40             	cmp    $0x40,%eax
80101fc1:	75 f5                	jne    80101fb8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fc3:	31 f6                	xor    %esi,%esi
80101fc5:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fca:	89 f0                	mov    %esi,%eax
80101fcc:	ee                   	out    %al,(%dx)
80101fcd:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fd2:	b8 01 00 00 00       	mov    $0x1,%eax
80101fd7:	ee                   	out    %al,(%dx)
80101fd8:	b2 f3                	mov    $0xf3,%dl
80101fda:	89 d8                	mov    %ebx,%eax
80101fdc:	ee                   	out    %al,(%dx)
80101fdd:	89 d8                	mov    %ebx,%eax
80101fdf:	b2 f4                	mov    $0xf4,%dl
80101fe1:	c1 f8 08             	sar    $0x8,%eax
80101fe4:	ee                   	out    %al,(%dx)
80101fe5:	b2 f5                	mov    $0xf5,%dl
80101fe7:	89 f0                	mov    %esi,%eax
80101fe9:	ee                   	out    %al,(%dx)
80101fea:	8b 41 04             	mov    0x4(%ecx),%eax
80101fed:	b2 f6                	mov    $0xf6,%dl
80101fef:	83 e0 01             	and    $0x1,%eax
80101ff2:	c1 e0 04             	shl    $0x4,%eax
80101ff5:	83 c8 e0             	or     $0xffffffe0,%eax
80101ff8:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101ff9:	f6 01 04             	testb  $0x4,(%ecx)
80101ffc:	75 12                	jne    80102010 <idestart+0x80>
80101ffe:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102003:	b8 20 00 00 00       	mov    $0x20,%eax
80102008:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102009:	83 c4 10             	add    $0x10,%esp
8010200c:	5b                   	pop    %ebx
8010200d:	5e                   	pop    %esi
8010200e:	5d                   	pop    %ebp
8010200f:	c3                   	ret    
80102010:	b2 f7                	mov    $0xf7,%dl
80102012:	b8 30 00 00 00       	mov    $0x30,%eax
80102017:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102018:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010201d:	8d 71 5c             	lea    0x5c(%ecx),%esi
80102020:	b9 80 00 00 00       	mov    $0x80,%ecx
80102025:	fc                   	cld    
80102026:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102028:	83 c4 10             	add    $0x10,%esp
8010202b:	5b                   	pop    %ebx
8010202c:	5e                   	pop    %esi
8010202d:	5d                   	pop    %ebp
8010202e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010202f:	c7 04 24 c0 74 10 80 	movl   $0x801074c0,(%esp)
80102036:	e8 95 e3 ff ff       	call   801003d0 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010203b:	c7 04 24 b7 74 10 80 	movl   $0x801074b7,(%esp)
80102042:	e8 89 e3 ff ff       	call   801003d0 <panic>
80102047:	89 f6                	mov    %esi,%esi
80102049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102050 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	53                   	push   %ebx
80102054:	83 ec 14             	sub    $0x14,%esp
80102057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010205a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010205d:	89 04 24             	mov    %eax,(%esp)
80102060:	e8 cb 24 00 00       	call   80104530 <holdingsleep>
80102065:	85 c0                	test   %eax,%eax
80102067:	0f 84 8f 00 00 00    	je     801020fc <iderw+0xac>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010206d:	8b 03                	mov    (%ebx),%eax
8010206f:	83 e0 06             	and    $0x6,%eax
80102072:	83 f8 02             	cmp    $0x2,%eax
80102075:	0f 84 99 00 00 00    	je     80102114 <iderw+0xc4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010207b:	8b 53 04             	mov    0x4(%ebx),%edx
8010207e:	85 d2                	test   %edx,%edx
80102080:	74 09                	je     8010208b <iderw+0x3b>
80102082:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102087:	85 c0                	test   %eax,%eax
80102089:	74 7d                	je     80102108 <iderw+0xb8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010208b:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102092:	e8 39 27 00 00       	call   801047d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102097:	ba b4 a5 10 80       	mov    $0x8010a5b4,%edx
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
8010209c:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
801020a3:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020a8:	85 c0                	test   %eax,%eax
801020aa:	74 0e                	je     801020ba <iderw+0x6a>
801020ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020b0:	8d 50 58             	lea    0x58(%eax),%edx
801020b3:	8b 40 58             	mov    0x58(%eax),%eax
801020b6:	85 c0                	test   %eax,%eax
801020b8:	75 f6                	jne    801020b0 <iderw+0x60>
    ;
  *pp = b;
801020ba:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801020bc:	39 1d b4 a5 10 80    	cmp    %ebx,0x8010a5b4
801020c2:	75 14                	jne    801020d8 <iderw+0x88>
801020c4:	eb 2d                	jmp    801020f3 <iderw+0xa3>
801020c6:	66 90                	xchg   %ax,%ax
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
801020c8:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801020cf:	80 
801020d0:	89 1c 24             	mov    %ebx,(%esp)
801020d3:	e8 a8 19 00 00       	call   80103a80 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801020d8:	8b 03                	mov    (%ebx),%eax
801020da:	83 e0 06             	and    $0x6,%eax
801020dd:	83 f8 02             	cmp    $0x2,%eax
801020e0:	75 e6                	jne    801020c8 <iderw+0x78>
    sleep(b, &idelock);
  }

  release(&idelock);
801020e2:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801020e9:	83 c4 14             	add    $0x14,%esp
801020ec:	5b                   	pop    %ebx
801020ed:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801020ee:	e9 8d 26 00 00       	jmp    80104780 <release>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801020f3:	89 d8                	mov    %ebx,%eax
801020f5:	e8 96 fe ff ff       	call   80101f90 <idestart>
801020fa:	eb dc                	jmp    801020d8 <iderw+0x88>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801020fc:	c7 04 24 d2 74 10 80 	movl   $0x801074d2,(%esp)
80102103:	e8 c8 e2 ff ff       	call   801003d0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102108:	c7 04 24 fd 74 10 80 	movl   $0x801074fd,(%esp)
8010210f:	e8 bc e2 ff ff       	call   801003d0 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102114:	c7 04 24 e8 74 10 80 	movl   $0x801074e8,(%esp)
8010211b:	e8 b0 e2 ff ff       	call   801003d0 <panic>

80102120 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	57                   	push   %edi
80102124:	53                   	push   %ebx
80102125:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102128:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
8010212f:	e8 9c 26 00 00       	call   801047d0 <acquire>
  if((b = idequeue) == 0){
80102134:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
8010213a:	85 db                	test   %ebx,%ebx
8010213c:	74 2d                	je     8010216b <ideintr+0x4b>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
8010213e:	8b 43 58             	mov    0x58(%ebx),%eax
80102141:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102146:	8b 0b                	mov    (%ebx),%ecx
80102148:	f6 c1 04             	test   $0x4,%cl
8010214b:	74 33                	je     80102180 <ideintr+0x60>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
8010214d:	83 c9 02             	or     $0x2,%ecx
80102150:	83 e1 fb             	and    $0xfffffffb,%ecx
80102153:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102155:	89 1c 24             	mov    %ebx,(%esp)
80102158:	e8 c3 17 00 00       	call   80103920 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010215d:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
80102162:	85 c0                	test   %eax,%eax
80102164:	74 05                	je     8010216b <ideintr+0x4b>
    idestart(idequeue);
80102166:	e8 25 fe ff ff       	call   80101f90 <idestart>

  release(&idelock);
8010216b:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102172:	e8 09 26 00 00       	call   80104780 <release>
}
80102177:	83 c4 10             	add    $0x10,%esp
8010217a:	5b                   	pop    %ebx
8010217b:	5f                   	pop    %edi
8010217c:	5d                   	pop    %ebp
8010217d:	c3                   	ret    
8010217e:	66 90                	xchg   %ax,%ax
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102180:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102185:	8d 76 00             	lea    0x0(%esi),%esi
80102188:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102189:	0f b6 c0             	movzbl %al,%eax
8010218c:	89 c7                	mov    %eax,%edi
8010218e:	81 e7 c0 00 00 00    	and    $0xc0,%edi
80102194:	83 ff 40             	cmp    $0x40,%edi
80102197:	75 ef                	jne    80102188 <ideintr+0x68>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102199:	a8 21                	test   $0x21,%al
8010219b:	75 b0                	jne    8010214d <ideintr+0x2d>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010219d:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801021a0:	b9 80 00 00 00       	mov    $0x80,%ecx
801021a5:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021aa:	fc                   	cld    
801021ab:	f3 6d                	rep insl (%dx),%es:(%edi)
801021ad:	8b 0b                	mov    (%ebx),%ecx
801021af:	eb 9c                	jmp    8010214d <ideintr+0x2d>
801021b1:	eb 0d                	jmp    801021c0 <ideinit>
801021b3:	90                   	nop
801021b4:	90                   	nop
801021b5:	90                   	nop
801021b6:	90                   	nop
801021b7:	90                   	nop
801021b8:	90                   	nop
801021b9:	90                   	nop
801021ba:	90                   	nop
801021bb:	90                   	nop
801021bc:	90                   	nop
801021bd:	90                   	nop
801021be:	90                   	nop
801021bf:	90                   	nop

801021c0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801021c6:	c7 44 24 04 1b 75 10 	movl   $0x8010751b,0x4(%esp)
801021cd:	80 
801021ce:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021d5:	e8 66 24 00 00       	call   80104640 <initlock>
  picenable(IRQ_IDE);
801021da:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801021e1:	e8 da 10 00 00       	call   801032c0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e6:	a1 80 2d 11 80       	mov    0x80112d80,%eax
801021eb:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801021f2:	83 e8 01             	sub    $0x1,%eax
801021f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801021f9:	e8 52 00 00 00       	call   80102250 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fe:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102203:	90                   	nop
80102204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102208:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102209:	25 c0 00 00 00       	and    $0xc0,%eax
8010220e:	83 f8 40             	cmp    $0x40,%eax
80102211:	75 f5                	jne    80102208 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102213:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102218:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010221d:	ee                   	out    %al,(%dx)
8010221e:	31 c9                	xor    %ecx,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102220:	b2 f7                	mov    $0xf7,%dl
80102222:	eb 0f                	jmp    80102233 <ideinit+0x73>
80102224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102228:	83 c1 01             	add    $0x1,%ecx
8010222b:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
80102231:	74 0f                	je     80102242 <ideinit+0x82>
80102233:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102234:	84 c0                	test   %al,%al
80102236:	74 f0                	je     80102228 <ideinit+0x68>
      havedisk1 = 1;
80102238:	c7 05 b8 a5 10 80 01 	movl   $0x1,0x8010a5b8
8010223f:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102242:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102247:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010224c:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010224d:	c9                   	leave  
8010224e:	c3                   	ret    
	...

80102250 <ioapicenable>:
}

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102250:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102256:	55                   	push   %ebp
80102257:	89 e5                	mov    %esp,%ebp
80102259:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010225c:	85 d2                	test   %edx,%edx
8010225e:	74 31                	je     80102291 <ioapicenable+0x41>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102260:	8b 15 54 26 11 80    	mov    0x80112654,%edx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102266:	8d 48 20             	lea    0x20(%eax),%ecx
80102269:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226d:	89 02                	mov    %eax,(%edx)
  ioapic->data = data;
8010226f:	8b 15 54 26 11 80    	mov    0x80112654,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102275:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102278:	89 4a 10             	mov    %ecx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227b:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102281:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102284:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102286:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010228b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010228e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102291:	5d                   	pop    %ebp
80102292:	c3                   	ret    
80102293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	56                   	push   %esi
801022a4:	53                   	push   %ebx
801022a5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
801022a8:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
801022ae:	85 c9                	test   %ecx,%ecx
801022b0:	0f 84 9e 00 00 00    	je     80102354 <ioapicinit+0xb4>
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022b6:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022bd:	00 00 00 
  return ioapic->data;
801022c0:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022c6:	bb 00 00 c0 fe       	mov    $0xfec00000,%ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022cb:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
801022d2:	00 00 00 
  return ioapic->data;
801022d5:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022da:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022e1:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801022e8:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022eb:	c1 ee 10             	shr    $0x10,%esi
  id = ioapicread(REG_ID) >> 24;
801022ee:	c1 e8 18             	shr    $0x18,%eax

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022f1:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022f7:	39 c2                	cmp    %eax,%edx
801022f9:	74 12                	je     8010230d <ioapicinit+0x6d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022fb:	c7 04 24 20 75 10 80 	movl   $0x80107520,(%esp)
80102302:	e8 69 e5 ff ff       	call   80100870 <cprintf>
80102307:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
8010230d:	ba 10 00 00 00       	mov    $0x10,%edx
80102312:	31 c0                	xor    %eax,%eax
80102314:	eb 08                	jmp    8010231e <ioapicinit+0x7e>
80102316:	66 90                	xchg   %ax,%ax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102318:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010231e:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102320:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102326:	8d 48 20             	lea    0x20(%eax),%ecx
80102329:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010232f:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102332:	89 4b 10             	mov    %ecx,0x10(%ebx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102335:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010233b:	8d 5a 01             	lea    0x1(%edx),%ebx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010233e:	83 c2 02             	add    $0x2,%edx
80102341:	39 c6                	cmp    %eax,%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102343:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102345:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010234b:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102352:	7d c4                	jge    80102318 <ioapicinit+0x78>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102354:	83 c4 10             	add    $0x10,%esp
80102357:	5b                   	pop    %ebx
80102358:	5e                   	pop    %esi
80102359:	5d                   	pop    %ebp
8010235a:	c3                   	ret    
8010235b:	00 00                	add    %al,(%eax)
8010235d:	00 00                	add    %al,(%eax)
	...

80102360 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102367:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010236d:	85 d2                	test   %edx,%edx
8010236f:	75 2f                	jne    801023a0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102371:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
80102377:	85 db                	test   %ebx,%ebx
80102379:	74 07                	je     80102382 <kalloc+0x22>
    kmem.freelist = r->next;
8010237b:	8b 03                	mov    (%ebx),%eax
8010237d:	a3 98 26 11 80       	mov    %eax,0x80112698
  if(kmem.use_lock)
80102382:	a1 94 26 11 80       	mov    0x80112694,%eax
80102387:	85 c0                	test   %eax,%eax
80102389:	74 0c                	je     80102397 <kalloc+0x37>
    release(&kmem.lock);
8010238b:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102392:	e8 e9 23 00 00       	call   80104780 <release>
  return (char*)r;
}
80102397:	89 d8                	mov    %ebx,%eax
80102399:	83 c4 14             	add    $0x14,%esp
8010239c:	5b                   	pop    %ebx
8010239d:	5d                   	pop    %ebp
8010239e:	c3                   	ret    
8010239f:	90                   	nop
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023a0:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801023a7:	e8 24 24 00 00       	call   801047d0 <acquire>
801023ac:	eb c3                	jmp    80102371 <kalloc+0x11>
801023ae:	66 90                	xchg   %ax,%ax

801023b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	53                   	push   %ebx
801023b4:	83 ec 14             	sub    $0x14,%esp
801023b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023c0:	75 7c                	jne    8010243e <kfree+0x8e>
801023c2:	81 fb 28 58 11 80    	cmp    $0x80115828,%ebx
801023c8:	72 74                	jb     8010243e <kfree+0x8e>
801023ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023d5:	77 67                	ja     8010243e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023d7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801023de:	00 
801023df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801023e6:	00 
801023e7:	89 1c 24             	mov    %ebx,(%esp)
801023ea:	e8 81 24 00 00       	call   80104870 <memset>

  if(kmem.use_lock)
801023ef:	a1 94 26 11 80       	mov    0x80112694,%eax
801023f4:	85 c0                	test   %eax,%eax
801023f6:	75 38                	jne    80102430 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023f8:	a1 98 26 11 80       	mov    0x80112698,%eax
801023fd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023ff:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102405:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
8010240b:	85 c9                	test   %ecx,%ecx
8010240d:	75 09                	jne    80102418 <kfree+0x68>
    release(&kmem.lock);
}
8010240f:	83 c4 14             	add    $0x14,%esp
80102412:	5b                   	pop    %ebx
80102413:	5d                   	pop    %ebp
80102414:	c3                   	ret    
80102415:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102418:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010241f:	83 c4 14             	add    $0x14,%esp
80102422:	5b                   	pop    %ebx
80102423:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102424:	e9 57 23 00 00       	jmp    80104780 <release>
80102429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102430:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102437:	e8 94 23 00 00       	call   801047d0 <acquire>
8010243c:	eb ba                	jmp    801023f8 <kfree+0x48>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010243e:	c7 04 24 52 75 10 80 	movl   $0x80107552,(%esp)
80102445:	e8 86 df ff ff       	call   801003d0 <panic>
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102450 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102458:	8b 55 08             	mov    0x8(%ebp),%edx
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010245b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010245e:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
80102464:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102470:	39 f3                	cmp    %esi,%ebx
80102472:	76 08                	jbe    8010247c <freerange+0x2c>
80102474:	eb 18                	jmp    8010248e <freerange+0x3e>
80102476:	66 90                	xchg   %ax,%ax
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 2c ff ff ff       	call   801023b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 f0                	cmp    %esi,%eax
8010248c:	76 ea                	jbe    80102478 <freerange+0x28>
    kfree(p);
}
8010248e:	83 c4 10             	add    $0x10,%esp
80102491:	5b                   	pop    %ebx
80102492:	5e                   	pop    %esi
80102493:	5d                   	pop    %ebp
80102494:	c3                   	ret    
80102495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit2>:
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
801024a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801024a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801024ad:	8b 45 08             	mov    0x8(%ebp),%eax
801024b0:	89 04 24             	mov    %eax,(%esp)
801024b3:	e8 98 ff ff ff       	call   80102450 <freerange>
  kmem.use_lock = 1;
801024b8:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024bf:	00 00 00 
}
801024c2:	c9                   	leave  
801024c3:	c3                   	ret    
801024c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801024d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	83 ec 18             	sub    $0x18,%esp
801024d6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801024d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801024dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
801024df:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024e2:	c7 44 24 04 58 75 10 	movl   $0x80107558,0x4(%esp)
801024e9:	80 
801024ea:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024f1:	e8 4a 21 00 00       	call   80104640 <initlock>
  kmem.use_lock = 0;
  freerange(vstart, vend);
801024f6:	89 75 0c             	mov    %esi,0xc(%ebp)
}
801024f9:	8b 75 fc             	mov    -0x4(%ebp),%esi
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
801024fc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801024ff:	8b 5d f8             	mov    -0x8(%ebp),%ebx
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102502:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102509:	00 00 00 
  freerange(vstart, vend);
}
8010250c:	89 ec                	mov    %ebp,%esp
8010250e:	5d                   	pop    %ebp
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
8010250f:	e9 3c ff ff ff       	jmp    80102450 <freerange>
	...

80102520 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102520:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102521:	ba 64 00 00 00       	mov    $0x64,%edx
80102526:	89 e5                	mov    %esp,%ebp
80102528:	ec                   	in     (%dx),%al
80102529:	89 c2                	mov    %eax,%edx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010252b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102530:	83 e2 01             	and    $0x1,%edx
80102533:	74 41                	je     80102576 <kbdgetc+0x56>
80102535:	ba 60 00 00 00       	mov    $0x60,%edx
8010253a:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010253b:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
8010253e:	3d e0 00 00 00       	cmp    $0xe0,%eax
80102543:	0f 84 7f 00 00 00    	je     801025c8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102549:	84 c0                	test   %al,%al
8010254b:	79 2b                	jns    80102578 <kbdgetc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010254d:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80102553:	89 c1                	mov    %eax,%ecx
80102555:	83 e1 7f             	and    $0x7f,%ecx
80102558:	f6 c2 40             	test   $0x40,%dl
8010255b:	0f 44 c1             	cmove  %ecx,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010255e:	0f b6 80 60 75 10 80 	movzbl -0x7fef8aa0(%eax),%eax
80102565:	83 c8 40             	or     $0x40,%eax
80102568:	0f b6 c0             	movzbl %al,%eax
8010256b:	f7 d0                	not    %eax
8010256d:	21 d0                	and    %edx,%eax
8010256f:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
80102574:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102576:	5d                   	pop    %ebp
80102577:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102578:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
8010257e:	f6 c1 40             	test   $0x40,%cl
80102581:	74 05                	je     80102588 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102583:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
80102585:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102588:	0f b6 90 60 75 10 80 	movzbl -0x7fef8aa0(%eax),%edx
8010258f:	09 ca                	or     %ecx,%edx
80102591:	0f b6 88 60 76 10 80 	movzbl -0x7fef89a0(%eax),%ecx
80102598:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010259a:	89 d1                	mov    %edx,%ecx
8010259c:	83 e1 03             	and    $0x3,%ecx
8010259f:	8b 0c 8d 60 77 10 80 	mov    -0x7fef88a0(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025a6:	89 15 bc a5 10 80    	mov    %edx,0x8010a5bc
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801025ac:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025af:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  if(shift & CAPSLOCK){
801025b3:	74 c1                	je     80102576 <kbdgetc+0x56>
    if('a' <= c && c <= 'z')
801025b5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b8:	83 fa 19             	cmp    $0x19,%edx
801025bb:	77 1b                	ja     801025d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025bd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025c0:	5d                   	pop    %ebp
801025c1:	c3                   	ret    
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025c8:	30 c0                	xor    %al,%al
801025ca:	83 0d bc a5 10 80 40 	orl    $0x40,0x8010a5bc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025d1:	5d                   	pop    %ebp
801025d2:	c3                   	ret    
801025d3:	90                   	nop
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025db:	8d 50 20             	lea    0x20(%eax),%edx
801025de:	83 f9 19             	cmp    $0x19,%ecx
801025e1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025e4:	5d                   	pop    %ebp
801025e5:	c3                   	ret    
801025e6:	8d 76 00             	lea    0x0(%esi),%esi
801025e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025f0 <kbdintr>:

void
kbdintr(void)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025f6:	c7 04 24 20 25 10 80 	movl   $0x80102520,(%esp)
801025fd:	e8 3e e0 ff ff       	call   80100640 <consoleintr>
}
80102602:	c9                   	leave  
80102603:	c3                   	ret    
	...

80102610 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102610:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102615:	55                   	push   %ebp
80102616:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102618:	85 c0                	test   %eax,%eax
8010261a:	0f 84 09 01 00 00    	je     80102729 <lapicinit+0x119>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102620:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102627:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010262a:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010262f:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102632:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102639:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010263c:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102641:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102644:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010264b:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
8010264e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102653:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102656:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010265d:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102660:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102665:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102668:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010266f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102672:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102677:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267a:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102681:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102689:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268c:	8b 50 30             	mov    0x30(%eax),%edx
8010268f:	c1 ea 10             	shr    $0x10,%edx
80102692:	80 fa 03             	cmp    $0x3,%dl
80102695:	0f 87 95 00 00 00    	ja     80102730 <lapicinit+0x120>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269b:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a5:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026aa:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ad:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b7:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026bc:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026bf:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026c6:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c9:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026ce:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d1:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026d8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e3:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026f2:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f5:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026fc:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026ff:	8b 0d 9c 26 11 80    	mov    0x8011269c,%ecx
80102705:	8b 41 20             	mov    0x20(%ecx),%eax
80102708:	8d 91 00 03 00 00    	lea    0x300(%ecx),%edx
8010270e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102710:	8b 02                	mov    (%edx),%eax
80102712:	f6 c4 10             	test   $0x10,%ah
80102715:	75 f9                	jne    80102710 <lapicinit+0x100>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102717:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
8010271e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102721:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102726:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102729:	5d                   	pop    %ebp
8010272a:	c3                   	ret    
8010272b:	90                   	nop
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102730:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102737:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010273f:	8b 50 20             	mov    0x20(%eax),%edx
80102742:	e9 54 ff ff ff       	jmp    8010269b <lapicinit+0x8b>
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 12                	je     8010276e <lapiceoi+0x1e>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010276b:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
8010276e:	5d                   	pop    %ebp
8010276f:	c3                   	ret    

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	ba 70 00 00 00       	mov    $0x70,%edx
80102786:	89 e5                	mov    %esp,%ebp
80102788:	b8 0f 00 00 00       	mov    $0xf,%eax
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
80102795:	ee                   	out    %al,(%dx)
80102796:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279b:	b2 71                	mov    $0x71,%dl
8010279d:	ee                   	out    %al,(%dx)
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
8010279e:	89 c8                	mov    %ecx,%eax
801027a0:	c1 e8 04             	shr    $0x4,%eax
801027a3:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a9:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027ae:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027b1:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801027b8:	00 00 

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
801027ba:	c1 e9 0c             	shr    $0xc,%ecx
801027bd:	80 cd 06             	or     $0x6,%ch
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c0:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c6:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ce:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d5:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027dd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e0:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e7:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ea:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027ef:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f2:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f8:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027fd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102800:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102806:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010280b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280e:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102814:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102819:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281c:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102822:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102827:	5b                   	pop    %ebx
80102828:	5d                   	pop    %ebp

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
80102829:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010282c:	c3                   	ret    
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	89 e5                	mov    %esp,%ebp
80102838:	b8 0b 00 00 00       	mov    $0xb,%eax
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 6c             	sub    $0x6c,%esp
80102843:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	b2 71                	mov    $0x71,%dl
80102846:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102847:	bb 70 00 00 00       	mov    $0x70,%ebx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284c:	88 45 a7             	mov    %al,-0x59(%ebp)
8010284f:	90                   	nop
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102850:	31 c0                	xor    %eax,%eax
80102852:	89 da                	mov    %ebx,%edx
80102854:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102855:	b9 71 00 00 00       	mov    $0x71,%ecx
8010285a:	89 ca                	mov    %ecx,%edx
8010285c:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
8010285d:	0f b6 f0             	movzbl %al,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102860:	89 da                	mov    %ebx,%edx
80102862:	b8 02 00 00 00       	mov    $0x2,%eax
80102867:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102868:	89 ca                	mov    %ecx,%edx
8010286a:	ec                   	in     (%dx),%al
8010286b:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010286e:	89 da                	mov    %ebx,%edx
80102870:	89 45 a8             	mov    %eax,-0x58(%ebp)
80102873:	b8 04 00 00 00       	mov    $0x4,%eax
80102878:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102879:	89 ca                	mov    %ecx,%edx
8010287b:	ec                   	in     (%dx),%al
8010287c:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	89 45 ac             	mov    %eax,-0x54(%ebp)
80102884:	b8 07 00 00 00       	mov    $0x7,%eax
80102889:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288a:	89 ca                	mov    %ecx,%edx
8010288c:	ec                   	in     (%dx),%al
8010288d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102890:	89 da                	mov    %ebx,%edx
80102892:	89 45 b0             	mov    %eax,-0x50(%ebp)
80102895:	b8 08 00 00 00       	mov    $0x8,%eax
8010289a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289b:	89 ca                	mov    %ecx,%edx
8010289d:	ec                   	in     (%dx),%al
8010289e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a1:	89 da                	mov    %ebx,%edx
801028a3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801028a6:	b8 09 00 00 00       	mov    $0x9,%eax
801028ab:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	89 ca                	mov    %ecx,%edx
801028ae:	ec                   	in     (%dx),%al
801028af:	0f b6 f8             	movzbl %al,%edi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b2:	89 da                	mov    %ebx,%edx
801028b4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028b9:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ba:	89 ca                	mov    %ecx,%edx
801028bc:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028bd:	84 c0                	test   %al,%al
801028bf:	78 8f                	js     80102850 <cmostime+0x20>
801028c1:	8b 45 a8             	mov    -0x58(%ebp),%eax
801028c4:	8b 55 ac             	mov    -0x54(%ebp),%edx
801028c7:	89 75 d0             	mov    %esi,-0x30(%ebp)
801028ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801028cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
801028d3:	89 55 d8             	mov    %edx,-0x28(%ebp)
801028d6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801028d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028dc:	31 c0                	xor    %eax,%eax
801028de:	89 55 e0             	mov    %edx,-0x20(%ebp)
801028e1:	89 da                	mov    %ebx,%edx
801028e3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e4:	89 ca                	mov    %ecx,%edx
801028e6:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801028e7:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ea:	89 da                	mov    %ebx,%edx
801028ec:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028ef:	b8 02 00 00 00       	mov    $0x2,%eax
801028f4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f5:	89 ca                	mov    %ecx,%edx
801028f7:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801028f8:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028fb:	89 da                	mov    %ebx,%edx
801028fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102900:	b8 04 00 00 00       	mov    $0x4,%eax
80102905:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102906:	89 ca                	mov    %ecx,%edx
80102908:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102909:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010290c:	89 da                	mov    %ebx,%edx
8010290e:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102911:	b8 07 00 00 00       	mov    $0x7,%eax
80102916:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102917:	89 ca                	mov    %ecx,%edx
80102919:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
8010291a:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010291d:	89 da                	mov    %ebx,%edx
8010291f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102922:	b8 08 00 00 00       	mov    $0x8,%eax
80102927:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102928:	89 ca                	mov    %ecx,%edx
8010292a:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
8010292b:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292e:	89 da                	mov    %ebx,%edx
80102930:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102933:	b8 09 00 00 00       	mov    $0x9,%eax
80102938:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102939:	89 ca                	mov    %ecx,%edx
8010293b:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
8010293c:	0f b6 c8             	movzbl %al,%ecx
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293f:	8d 55 d0             	lea    -0x30(%ebp),%edx
80102942:	8d 45 b8             	lea    -0x48(%ebp),%eax
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102945:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102948:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010294f:	00 
80102950:	89 44 24 04          	mov    %eax,0x4(%esp)
80102954:	89 14 24             	mov    %edx,(%esp)
80102957:	e8 84 1f 00 00       	call   801048e0 <memcmp>
8010295c:	85 c0                	test   %eax,%eax
8010295e:	0f 85 ec fe ff ff    	jne    80102850 <cmostime+0x20>
      break;
  }

  // convert
  if(bcd) {
80102964:	f6 45 a7 04          	testb  $0x4,-0x59(%ebp)
80102968:	75 78                	jne    801029e2 <cmostime+0x1b2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010296a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010296d:	89 c2                	mov    %eax,%edx
8010296f:	83 e0 0f             	and    $0xf,%eax
80102972:	c1 ea 04             	shr    $0x4,%edx
80102975:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102978:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297b:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010297e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102981:	89 c2                	mov    %eax,%edx
80102983:	83 e0 0f             	and    $0xf,%eax
80102986:	c1 ea 04             	shr    $0x4,%edx
80102989:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
80102992:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102995:	89 c2                	mov    %eax,%edx
80102997:	83 e0 0f             	and    $0xf,%eax
8010299a:	c1 ea 04             	shr    $0x4,%edx
8010299d:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801029a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801029a9:	89 c2                	mov    %eax,%edx
801029ab:	83 e0 0f             	and    $0xf,%eax
801029ae:	c1 ea 04             	shr    $0x4,%edx
801029b1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801029ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801029bd:	89 c2                	mov    %eax,%edx
801029bf:	83 e0 0f             	and    $0xf,%eax
801029c2:	c1 ea 04             	shr    $0x4,%edx
801029c5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801029ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801029d1:	89 c2                	mov    %eax,%edx
801029d3:	83 e0 0f             	and    $0xf,%eax
801029d6:	c1 ea 04             	shr    $0x4,%edx
801029d9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029dc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801029e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
801029e5:	8b 55 08             	mov    0x8(%ebp),%edx
801029e8:	89 02                	mov    %eax,(%edx)
801029ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801029ed:	89 42 04             	mov    %eax,0x4(%edx)
801029f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801029f3:	89 42 08             	mov    %eax,0x8(%edx)
801029f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801029f9:	89 42 0c             	mov    %eax,0xc(%edx)
801029fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801029ff:	89 42 10             	mov    %eax,0x10(%edx)
80102a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102a05:	89 42 14             	mov    %eax,0x14(%edx)
  r->year += 2000;
80102a08:	81 42 14 d0 07 00 00 	addl   $0x7d0,0x14(%edx)
}
80102a0f:	83 c4 6c             	add    $0x6c,%esp
80102a12:	5b                   	pop    %ebx
80102a13:	5e                   	pop    %esi
80102a14:	5f                   	pop    %edi
80102a15:	5d                   	pop    %ebp
80102a16:	c3                   	ret    
80102a17:	89 f6                	mov    %esi,%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a20 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	56                   	push   %esi
80102a24:	53                   	push   %ebx
80102a25:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102a28:	9c                   	pushf  
80102a29:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102a2a:	f6 c4 02             	test   $0x2,%ah
80102a2d:	74 12                	je     80102a41 <cpunum+0x21>
    static int n;
    if(n++ == 0)
80102a2f:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80102a34:	8d 50 01             	lea    0x1(%eax),%edx
80102a37:	85 c0                	test   %eax,%eax
80102a39:	89 15 c0 a5 10 80    	mov    %edx,0x8010a5c0
80102a3f:	74 4a                	je     80102a8b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102a41:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102a46:	85 c0                	test   %eax,%eax
80102a48:	74 5d                	je     80102aa7 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
80102a4a:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102a50:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
80102a53:	85 f6                	test   %esi,%esi
80102a55:	7e 59                	jle    80102ab0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102a57:	0f b6 0d a0 27 11 80 	movzbl 0x801127a0,%ecx
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102a5e:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
80102a61:	31 c0                	xor    %eax,%eax
80102a63:	ba 5c 28 11 80       	mov    $0x8011285c,%edx
80102a68:	39 d9                	cmp    %ebx,%ecx
80102a6a:	74 3b                	je     80102aa7 <cpunum+0x87>
80102a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
80102a70:	83 c0 01             	add    $0x1,%eax
80102a73:	39 f0                	cmp    %esi,%eax
80102a75:	7d 39                	jge    80102ab0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102a77:	0f b6 0a             	movzbl (%edx),%ecx
80102a7a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102a80:	39 d9                	cmp    %ebx,%ecx
80102a82:	75 ec                	jne    80102a70 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102a84:	83 c4 10             	add    $0x10,%esp
80102a87:	5b                   	pop    %ebx
80102a88:	5e                   	pop    %esi
80102a89:	5d                   	pop    %ebp
80102a8a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102a8b:	8b 45 04             	mov    0x4(%ebp),%eax
80102a8e:	c7 04 24 70 77 10 80 	movl   $0x80107770,(%esp)
80102a95:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a99:	e8 d2 dd ff ff       	call   80100870 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
80102a9e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102aa3:	85 c0                	test   %eax,%eax
80102aa5:	75 a3                	jne    80102a4a <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102aa7:	83 c4 10             	add    $0x10,%esp
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102aaa:	31 c0                	xor    %eax,%eax
}
80102aac:	5b                   	pop    %ebx
80102aad:	5e                   	pop    %esi
80102aae:	5d                   	pop    %ebp
80102aaf:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102ab0:	c7 04 24 9c 77 10 80 	movl   $0x8010779c,(%esp)
80102ab7:	e8 14 d9 ff ff       	call   801003d0 <panic>
80102abc:	00 00                	add    %al,(%eax)
	...

80102ac0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	53                   	push   %ebx
80102ac4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ac7:	a1 e8 26 11 80       	mov    0x801126e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102acc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102acf:	83 f8 1d             	cmp    $0x1d,%eax
80102ad2:	7f 7e                	jg     80102b52 <log_write+0x92>
80102ad4:	8b 15 d8 26 11 80    	mov    0x801126d8,%edx
80102ada:	83 ea 01             	sub    $0x1,%edx
80102add:	39 d0                	cmp    %edx,%eax
80102adf:	7d 71                	jge    80102b52 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ae1:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102ae6:	85 c0                	test   %eax,%eax
80102ae8:	7e 74                	jle    80102b5e <log_write+0x9e>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102aea:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102af1:	e8 da 1c 00 00       	call   801047d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102af6:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102afc:	85 c9                	test   %ecx,%ecx
80102afe:	7e 4b                	jle    80102b4b <log_write+0x8b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102b00:	8b 53 08             	mov    0x8(%ebx),%edx
80102b03:	31 c0                	xor    %eax,%eax
80102b05:	39 15 ec 26 11 80    	cmp    %edx,0x801126ec
80102b0b:	75 0c                	jne    80102b19 <log_write+0x59>
80102b0d:	eb 11                	jmp    80102b20 <log_write+0x60>
80102b0f:	90                   	nop
80102b10:	3b 14 85 ec 26 11 80 	cmp    -0x7feed914(,%eax,4),%edx
80102b17:	74 07                	je     80102b20 <log_write+0x60>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102b19:	83 c0 01             	add    $0x1,%eax
80102b1c:	39 c8                	cmp    %ecx,%eax
80102b1e:	7c f0                	jl     80102b10 <log_write+0x50>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102b20:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80102b27:	39 05 e8 26 11 80    	cmp    %eax,0x801126e8
80102b2d:	75 08                	jne    80102b37 <log_write+0x77>
    log.lh.n++;
80102b2f:	83 c0 01             	add    $0x1,%eax
80102b32:	a3 e8 26 11 80       	mov    %eax,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102b37:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102b3a:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102b41:	83 c4 14             	add    $0x14,%esp
80102b44:	5b                   	pop    %ebx
80102b45:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102b46:	e9 35 1c 00 00       	jmp    80104780 <release>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102b4b:	8b 53 08             	mov    0x8(%ebx),%edx
80102b4e:	31 c0                	xor    %eax,%eax
80102b50:	eb ce                	jmp    80102b20 <log_write+0x60>
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102b52:	c7 04 24 ac 77 10 80 	movl   $0x801077ac,(%esp)
80102b59:	e8 72 d8 ff ff       	call   801003d0 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102b5e:	c7 04 24 c2 77 10 80 	movl   $0x801077c2,(%esp)
80102b65:	e8 66 d8 ff ff       	call   801003d0 <panic>
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b70 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	57                   	push   %edi
80102b74:	56                   	push   %esi
80102b75:	53                   	push   %ebx
80102b76:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b79:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102b7f:	85 d2                	test   %edx,%edx
80102b81:	7e 78                	jle    80102bfb <install_trans+0x8b>
80102b83:	31 db                	xor    %ebx,%ebx
80102b85:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b88:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102b8d:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
80102b91:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b95:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102b9a:	89 04 24             	mov    %eax,(%esp)
80102b9d:	e8 6e d5 ff ff       	call   80100110 <bread>
80102ba2:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ba4:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bab:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bae:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bb2:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102bb7:	89 04 24             	mov    %eax,(%esp)
80102bba:	e8 51 d5 ff ff       	call   80100110 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bbf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102bc6:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bc7:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bc9:	8d 47 5c             	lea    0x5c(%edi),%eax
80102bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bd0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bd3:	89 04 24             	mov    %eax,(%esp)
80102bd6:	e8 65 1d 00 00       	call   80104940 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bdb:	89 34 24             	mov    %esi,(%esp)
80102bde:	e8 ed d4 ff ff       	call   801000d0 <bwrite>
    brelse(lbuf);
80102be3:	89 3c 24             	mov    %edi,(%esp)
80102be6:	e8 55 d4 ff ff       	call   80100040 <brelse>
    brelse(dbuf);
80102beb:	89 34 24             	mov    %esi,(%esp)
80102bee:	e8 4d d4 ff ff       	call   80100040 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf3:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102bf9:	7f 8d                	jg     80102b88 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102bfb:	83 c4 1c             	add    $0x1c,%esp
80102bfe:	5b                   	pop    %ebx
80102bff:	5e                   	pop    %esi
80102c00:	5f                   	pop    %edi
80102c01:	5d                   	pop    %ebp
80102c02:	c3                   	ret    
80102c03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	56                   	push   %esi
80102c14:	53                   	push   %ebx
80102c15:	83 ec 10             	sub    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c18:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c21:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c26:	89 04 24             	mov    %eax,(%esp)
80102c29:	e8 e2 d4 ff ff       	call   80100110 <bread>
80102c2e:	89 c6                	mov    %eax,%esi
  struct logheader *hb = (struct logheader *) (buf->data);
80102c30:	8d 58 5c             	lea    0x5c(%eax),%ebx
  int i;
  hb->n = log.lh.n;
80102c33:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c38:	89 46 5c             	mov    %eax,0x5c(%esi)
  for (i = 0; i < log.lh.n; i++) {
80102c3b:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c41:	85 c9                	test   %ecx,%ecx
80102c43:	7e 19                	jle    80102c5e <write_head+0x4e>
80102c45:	31 d2                	xor    %edx,%edx
80102c47:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c48:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c4f:	89 4c 93 04          	mov    %ecx,0x4(%ebx,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c53:	83 c2 01             	add    $0x1,%edx
80102c56:	39 15 e8 26 11 80    	cmp    %edx,0x801126e8
80102c5c:	7f ea                	jg     80102c48 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102c5e:	89 34 24             	mov    %esi,(%esp)
80102c61:	e8 6a d4 ff ff       	call   801000d0 <bwrite>
  brelse(buf);
80102c66:	89 34 24             	mov    %esi,(%esp)
80102c69:	e8 d2 d3 ff ff       	call   80100040 <brelse>
}
80102c6e:	83 c4 10             	add    $0x10,%esp
80102c71:	5b                   	pop    %ebx
80102c72:	5e                   	pop    %esi
80102c73:	5d                   	pop    %ebp
80102c74:	c3                   	ret    
80102c75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	57                   	push   %edi
80102c84:	56                   	push   %esi
80102c85:	53                   	push   %ebx
80102c86:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c89:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c90:	e8 3b 1b 00 00       	call   801047d0 <acquire>
  log.outstanding -= 1;
80102c95:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c9a:	8b 3d e0 26 11 80    	mov    0x801126e0,%edi
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ca0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102ca3:	85 ff                	test   %edi,%edi
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ca5:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102caa:	0f 85 f2 00 00 00    	jne    80102da2 <end_op+0x122>
    panic("log.committing");
  if(log.outstanding == 0){
80102cb0:	85 c0                	test   %eax,%eax
80102cb2:	0f 85 ca 00 00 00    	jne    80102d82 <end_op+0x102>
    do_commit = 1;
    log.committing = 1;
80102cb8:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102cbf:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102cc2:	31 db                	xor    %ebx,%ebx
80102cc4:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ccb:	e8 b0 1a 00 00       	call   80104780 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102cd0:	8b 35 e8 26 11 80    	mov    0x801126e8,%esi
80102cd6:	85 f6                	test   %esi,%esi
80102cd8:	0f 8e 8e 00 00 00    	jle    80102d6c <end_op+0xec>
80102cde:	66 90                	xchg   %ax,%ax
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ce0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102ce5:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
80102ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ced:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102cf2:	89 04 24             	mov    %eax,(%esp)
80102cf5:	e8 16 d4 ff ff       	call   80100110 <bread>
80102cfa:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cfc:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d03:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d06:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d0a:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102d0f:	89 04 24             	mov    %eax,(%esp)
80102d12:	e8 f9 d3 ff ff       	call   80100110 <bread>
    memmove(to->data, from->data, BSIZE);
80102d17:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102d1e:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d1f:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d21:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d24:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d28:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d2b:	89 04 24             	mov    %eax,(%esp)
80102d2e:	e8 0d 1c 00 00       	call   80104940 <memmove>
    bwrite(to);  // write the log
80102d33:	89 34 24             	mov    %esi,(%esp)
80102d36:	e8 95 d3 ff ff       	call   801000d0 <bwrite>
    brelse(from);
80102d3b:	89 3c 24             	mov    %edi,(%esp)
80102d3e:	e8 fd d2 ff ff       	call   80100040 <brelse>
    brelse(to);
80102d43:	89 34 24             	mov    %esi,(%esp)
80102d46:	e8 f5 d2 ff ff       	call   80100040 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d4b:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102d51:	7c 8d                	jl     80102ce0 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d53:	e8 b8 fe ff ff       	call   80102c10 <write_head>
    install_trans(); // Now install writes to home locations
80102d58:	e8 13 fe ff ff       	call   80102b70 <install_trans>
    log.lh.n = 0;
80102d5d:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d64:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d67:	e8 a4 fe ff ff       	call   80102c10 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d6c:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d73:	e8 58 1a 00 00       	call   801047d0 <acquire>
    log.committing = 0;
80102d78:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d7f:	00 00 00 
    wakeup(&log);
80102d82:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d89:	e8 92 0b 00 00       	call   80103920 <wakeup>
    release(&log.lock);
80102d8e:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d95:	e8 e6 19 00 00       	call   80104780 <release>
  }
}
80102d9a:	83 c4 1c             	add    $0x1c,%esp
80102d9d:	5b                   	pop    %ebx
80102d9e:	5e                   	pop    %esi
80102d9f:	5f                   	pop    %edi
80102da0:	5d                   	pop    %ebp
80102da1:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102da2:	c7 04 24 dd 77 10 80 	movl   $0x801077dd,(%esp)
80102da9:	e8 22 d6 ff ff       	call   801003d0 <panic>
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102db6:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102dbd:	e8 0e 1a 00 00       	call   801047d0 <acquire>
80102dc2:	eb 18                	jmp    80102ddc <begin_op+0x2c>
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80102dc8:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102dcf:	80 
80102dd0:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102dd7:	e8 a4 0c 00 00       	call   80103a80 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102ddc:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102de1:	85 c0                	test   %eax,%eax
80102de3:	75 e3                	jne    80102dc8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102de5:	8b 15 dc 26 11 80    	mov    0x801126dc,%edx
80102deb:	83 c2 01             	add    $0x1,%edx
80102dee:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102df1:	01 c0                	add    %eax,%eax
80102df3:	03 05 e8 26 11 80    	add    0x801126e8,%eax
80102df9:	83 f8 1e             	cmp    $0x1e,%eax
80102dfc:	7f ca                	jg     80102dc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dfe:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102e05:	89 15 dc 26 11 80    	mov    %edx,0x801126dc
      release(&log.lock);
80102e0b:	e8 70 19 00 00       	call   80104780 <release>
      break;
    }
  }
}
80102e10:	c9                   	leave  
80102e11:	c3                   	ret    
80102e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e20 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	56                   	push   %esi
80102e24:	53                   	push   %ebx
80102e25:	83 ec 30             	sub    $0x30,%esp
80102e28:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e2b:	c7 44 24 04 ec 77 10 	movl   $0x801077ec,0x4(%esp)
80102e32:	80 
80102e33:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e3a:	e8 01 18 00 00       	call   80104640 <initlock>
  readsb(dev, &sb);
80102e3f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e42:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e46:	89 1c 24             	mov    %ebx,(%esp)
80102e49:	e8 f2 e4 ff ff       	call   80101340 <readsb>
  log.start = sb.logstart;
80102e4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102e51:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.dev = dev;
80102e54:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e5a:	89 1c 24             	mov    %ebx,(%esp)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102e5d:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102e62:	89 15 d8 26 11 80    	mov    %edx,0x801126d8

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e6c:	e8 9f d2 ff ff       	call   80100110 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102e71:	8b 58 5c             	mov    0x5c(%eax),%ebx
// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
80102e74:	8d 70 5c             	lea    0x5c(%eax),%esi
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102e77:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102e79:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102e7f:	7e 19                	jle    80102e9a <initlog+0x7a>
80102e81:	31 d2                	xor    %edx,%edx
80102e83:	90                   	nop
80102e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102e88:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102e8c:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102e93:	83 c2 01             	add    $0x1,%edx
80102e96:	39 da                	cmp    %ebx,%edx
80102e98:	75 ee                	jne    80102e88 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102e9a:	89 04 24             	mov    %eax,(%esp)
80102e9d:	e8 9e d1 ff ff       	call   80100040 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ea2:	e8 c9 fc ff ff       	call   80102b70 <install_trans>
  log.lh.n = 0;
80102ea7:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102eae:	00 00 00 
  write_head(); // clear the log
80102eb1:	e8 5a fd ff ff       	call   80102c10 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102eb6:	83 c4 30             	add    $0x30,%esp
80102eb9:	5b                   	pop    %ebx
80102eba:	5e                   	pop    %esi
80102ebb:	5d                   	pop    %ebp
80102ebc:	c3                   	ret    
80102ebd:	00 00                	add    %al,(%eax)
	...

80102ec0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102ec6:	e8 55 fb ff ff       	call   80102a20 <cpunum>
80102ecb:	c7 04 24 f0 77 10 80 	movl   $0x801077f0,(%esp)
80102ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ed6:	e8 95 d9 ff ff       	call   80100870 <cprintf>
  idtinit();       // load idt register
80102edb:	e8 f0 2b 00 00       	call   80105ad0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102ee0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ee7:	b8 01 00 00 00       	mov    $0x1,%eax
80102eec:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102ef3:	e8 08 0f 00 00       	call   80103e00 <scheduler>
80102ef8:	90                   	nop
80102ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f00 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	83 e4 f0             	and    $0xfffffff0,%esp
80102f06:	53                   	push   %ebx
80102f07:	83 ec 1c             	sub    $0x1c,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f0a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102f11:	80 
80102f12:	c7 04 24 28 58 11 80 	movl   $0x80115828,(%esp)
80102f19:	e8 b2 f5 ff ff       	call   801024d0 <kinit1>
  kvmalloc();      // kernel page table
80102f1e:	e8 0d 3d 00 00       	call   80106c30 <kvmalloc>
  mpinit();        // detect other processors
80102f23:	e8 c8 01 00 00       	call   801030f0 <mpinit>
  lapicinit();     // interrupt controller
80102f28:	e8 e3 f6 ff ff       	call   80102610 <lapicinit>
80102f2d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102f30:	e8 8b 42 00 00       	call   801071c0 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102f35:	e8 e6 fa ff ff       	call   80102a20 <cpunum>
80102f3a:	c7 04 24 01 78 10 80 	movl   $0x80107801,(%esp)
80102f41:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f45:	e8 26 d9 ff ff       	call   80100870 <cprintf>
  picinit();       // another interrupt controller
80102f4a:	e8 a1 03 00 00       	call   801032f0 <picinit>
  ioapicinit();    // another interrupt controller
80102f4f:	e8 4c f3 ff ff       	call   801022a0 <ioapicinit>
  consoleinit();   // console hardware
80102f54:	e8 17 d3 ff ff       	call   80100270 <consoleinit>
  uartinit();      // serial port
80102f59:	e8 32 2f 00 00       	call   80105e90 <uartinit>
80102f5e:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102f60:	e8 ab 15 00 00       	call   80104510 <pinit>
  tvinit();        // trap vectors
80102f65:	e8 f6 2d 00 00       	call   80105d60 <tvinit>
  binit();         // buffer cache
80102f6a:	e8 71 d2 ff ff       	call   801001e0 <binit>
80102f6f:	90                   	nop
  fileinit();      // file table
80102f70:	e8 cb e1 ff ff       	call   80101140 <fileinit>
  ideinit();       // disk
80102f75:	e8 46 f2 ff ff       	call   801021c0 <ideinit>
  if(!ismp)
80102f7a:	a1 84 27 11 80       	mov    0x80112784,%eax
80102f7f:	85 c0                	test   %eax,%eax
80102f81:	0f 84 ca 00 00 00    	je     80103051 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f87:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102f8e:	00 
80102f8f:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102f96:	80 
80102f97:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102f9e:	e8 9d 19 00 00       	call   80104940 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102fa3:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102faa:	00 00 00 
80102fad:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fb2:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80102fb7:	76 7a                	jbe    80103033 <main+0x133>
80102fb9:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80102fbe:	66 90                	xchg   %ax,%ax
    if(c == cpus+cpunum())  // We've started already.
80102fc0:	e8 5b fa ff ff       	call   80102a20 <cpunum>
80102fc5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102fcb:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fd0:	39 c3                	cmp    %eax,%ebx
80102fd2:	74 46                	je     8010301a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fd4:	e8 87 f3 ff ff       	call   80102360 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102fd9:	c7 05 f8 6f 00 80 60 	movl   $0x80103060,0x80006ff8
80102fe0:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fe3:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fea:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fed:	05 00 10 00 00       	add    $0x1000,%eax
80102ff2:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102ff7:	0f b6 03             	movzbl (%ebx),%eax
80102ffa:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80103001:	00 
80103002:	89 04 24             	mov    %eax,(%esp)
80103005:	e8 76 f7 ff ff       	call   80102780 <lapicstartap>
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103010:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80103016:	85 c0                	test   %eax,%eax
80103018:	74 f6                	je     80103010 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010301a:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80103021:	00 00 00 
80103024:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
8010302a:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010302f:	39 c3                	cmp    %eax,%ebx
80103031:	72 8d                	jb     80102fc0 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103033:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010303a:	8e 
8010303b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103042:	e8 59 f4 ff ff       	call   801024a0 <kinit2>
  userinit();      // first user process
80103047:	e8 c4 13 00 00       	call   80104410 <userinit>
  mpmain();        // finish this processor's setup
8010304c:	e8 6f fe ff ff       	call   80102ec0 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80103051:	e8 1a 2a 00 00       	call   80105a70 <timerinit>
80103056:	e9 2c ff ff ff       	jmp    80102f87 <main+0x87>
8010305b:	90                   	nop
8010305c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103060 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103066:	e8 55 39 00 00       	call   801069c0 <switchkvm>
  seginit();
8010306b:	e8 50 41 00 00       	call   801071c0 <seginit>
  lapicinit();
80103070:	e8 9b f5 ff ff       	call   80102610 <lapicinit>
  mpmain();
80103075:	e8 46 fe ff ff       	call   80102ec0 <mpmain>
8010307a:	00 00                	add    %al,(%eax)
8010307c:	00 00                	add    %al,(%eax)
	...

80103080 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	56                   	push   %esi
80103084:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80103085:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010308b:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010308e:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80103091:	39 f3                	cmp    %esi,%ebx
80103093:	73 3c                	jae    801030d1 <mpsearch1+0x51>
80103095:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103098:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010309f:	00 
801030a0:	c7 44 24 04 18 78 10 	movl   $0x80107818,0x4(%esp)
801030a7:	80 
801030a8:	89 1c 24             	mov    %ebx,(%esp)
801030ab:	e8 30 18 00 00       	call   801048e0 <memcmp>
801030b0:	85 c0                	test   %eax,%eax
801030b2:	75 16                	jne    801030ca <mpsearch1+0x4a>
801030b4:	31 d2                	xor    %edx,%edx
801030b6:	66 90                	xchg   %ax,%ax
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
801030b8:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030bc:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030bf:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030c1:	83 f8 10             	cmp    $0x10,%eax
801030c4:	75 f2                	jne    801030b8 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030c6:	84 d2                	test   %dl,%dl
801030c8:	74 10                	je     801030da <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801030ca:	83 c3 10             	add    $0x10,%ebx
801030cd:	39 de                	cmp    %ebx,%esi
801030cf:	77 c7                	ja     80103098 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
801030d1:	83 c4 10             	add    $0x10,%esp
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801030d4:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
801030d6:	5b                   	pop    %ebx
801030d7:	5e                   	pop    %esi
801030d8:	5d                   	pop    %ebp
801030d9:	c3                   	ret    
801030da:	83 c4 10             	add    $0x10,%esp

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
801030dd:	89 d8                	mov    %ebx,%eax
  return 0;
}
801030df:	5b                   	pop    %ebx
801030e0:	5e                   	pop    %esi
801030e1:	5d                   	pop    %ebp
801030e2:	c3                   	ret    
801030e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	57                   	push   %edi
801030f4:	56                   	push   %esi
801030f5:	53                   	push   %ebx
801030f6:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103100:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103107:	c1 e0 08             	shl    $0x8,%eax
8010310a:	09 d0                	or     %edx,%eax
8010310c:	c1 e0 04             	shl    $0x4,%eax
8010310f:	85 c0                	test   %eax,%eax
80103111:	75 1b                	jne    8010312e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103113:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010311a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103121:	c1 e0 08             	shl    $0x8,%eax
80103124:	09 d0                	or     %edx,%eax
80103126:	c1 e0 0a             	shl    $0xa,%eax
80103129:	2d 00 04 00 00       	sub    $0x400,%eax
8010312e:	ba 00 04 00 00       	mov    $0x400,%edx
80103133:	e8 48 ff ff ff       	call   80103080 <mpsearch1>
80103138:	85 c0                	test   %eax,%eax
8010313a:	89 c6                	mov    %eax,%esi
8010313c:	0f 84 a6 00 00 00    	je     801031e8 <mpinit+0xf8>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103142:	8b 7e 04             	mov    0x4(%esi),%edi
80103145:	85 ff                	test   %edi,%edi
80103147:	75 08                	jne    80103151 <mpinit+0x61>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103149:	83 c4 2c             	add    $0x2c,%esp
8010314c:	5b                   	pop    %ebx
8010314d:	5e                   	pop    %esi
8010314e:	5f                   	pop    %edi
8010314f:	5d                   	pop    %ebp
80103150:	c3                   	ret    
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103151:	8d 9f 00 00 00 80    	lea    -0x80000000(%edi),%ebx
  if(memcmp(conf, "PCMP", 4) != 0)
80103157:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010315e:	00 
8010315f:	c7 44 24 04 1d 78 10 	movl   $0x8010781d,0x4(%esp)
80103166:	80 
80103167:	89 1c 24             	mov    %ebx,(%esp)
8010316a:	e8 71 17 00 00       	call   801048e0 <memcmp>
8010316f:	85 c0                	test   %eax,%eax
80103171:	75 d6                	jne    80103149 <mpinit+0x59>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103173:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
80103177:	3c 04                	cmp    $0x4,%al
80103179:	74 04                	je     8010317f <mpinit+0x8f>
8010317b:	3c 01                	cmp    $0x1,%al
8010317d:	75 ca                	jne    80103149 <mpinit+0x59>
  *pmp = mp;
  return conf;
}

void
mpinit(void)
8010317f:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103183:	89 d8                	mov    %ebx,%eax
  *pmp = mp;
  return conf;
}

void
mpinit(void)
80103185:	8d 8c 17 00 00 00 80 	lea    -0x80000000(%edi,%edx,1),%ecx
8010318c:	31 d2                	xor    %edx,%edx
8010318e:	eb 08                	jmp    80103198 <mpinit+0xa8>
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103190:	0f b6 38             	movzbl (%eax),%edi
80103193:	83 c0 01             	add    $0x1,%eax
80103196:	01 fa                	add    %edi,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103198:	39 c8                	cmp    %ecx,%eax
8010319a:	75 f4                	jne    80103190 <mpinit+0xa0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
8010319c:	84 d2                	test   %dl,%dl
8010319e:	75 a9                	jne    80103149 <mpinit+0x59>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
801031a0:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
801031a7:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801031aa:	8b 43 24             	mov    0x24(%ebx),%eax
801031ad:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031b2:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
801031b6:	8d 43 2c             	lea    0x2c(%ebx),%eax
801031b9:	01 d3                	add    %edx,%ebx
801031bb:	39 d8                	cmp    %ebx,%eax
801031bd:	72 17                	jb     801031d6 <mpinit+0xe6>
801031bf:	eb 5f                	jmp    80103220 <mpinit+0x130>
801031c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031c8:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
801031cf:	00 00 00 

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031d2:	39 c3                	cmp    %eax,%ebx
801031d4:	76 41                	jbe    80103217 <mpinit+0x127>
    switch(*p){
801031d6:	80 38 04             	cmpb   $0x4,(%eax)
801031d9:	77 ed                	ja     801031c8 <mpinit+0xd8>
801031db:	0f b6 10             	movzbl (%eax),%edx
801031de:	ff 24 95 24 78 10 80 	jmp    *-0x7fef87dc(,%edx,4)
801031e5:	8d 76 00             	lea    0x0(%esi),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031e8:	ba 00 00 01 00       	mov    $0x10000,%edx
801031ed:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031f2:	e8 89 fe ff ff       	call   80103080 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f7:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031f9:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031fb:	0f 85 41 ff ff ff    	jne    80103142 <mpinit+0x52>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103201:	83 c4 2c             	add    $0x2c,%esp
80103204:	5b                   	pop    %ebx
80103205:	5e                   	pop    %esi
80103206:	5f                   	pop    %edi
80103207:	5d                   	pop    %ebp
80103208:	c3                   	ret    
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103210:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103213:	39 c3                	cmp    %eax,%ebx
80103215:	77 bf                	ja     801031d6 <mpinit+0xe6>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103217:	a1 84 27 11 80       	mov    0x80112784,%eax
8010321c:	85 c0                	test   %eax,%eax
8010321e:	74 70                	je     80103290 <mpinit+0x1a0>
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80103220:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103224:	0f 84 1f ff ff ff    	je     80103149 <mpinit+0x59>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010322a:	ba 22 00 00 00       	mov    $0x22,%edx
8010322f:	b8 70 00 00 00       	mov    $0x70,%eax
80103234:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103235:	b2 23                	mov    $0x23,%dl
80103237:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103238:	83 c8 01             	or     $0x1,%eax
8010323b:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010323c:	83 c4 2c             	add    $0x2c,%esp
8010323f:	5b                   	pop    %ebx
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret    
80103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103248:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
8010324e:	83 fa 07             	cmp    $0x7,%edx
80103251:	7f 1b                	jg     8010326e <mpinit+0x17e>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103253:	69 ca bc 00 00 00    	imul   $0xbc,%edx,%ecx
        ncpu++;
80103259:	83 c2 01             	add    $0x1,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010325c:	89 cf                	mov    %ecx,%edi
8010325e:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
        ncpu++;
80103262:	89 15 80 2d 11 80    	mov    %edx,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103268:	88 8f a0 27 11 80    	mov    %cl,-0x7feed860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010326e:	83 c0 14             	add    $0x14,%eax
      continue;
80103271:	e9 5c ff ff ff       	jmp    801031d2 <mpinit+0xe2>
80103276:	66 90                	xchg   %ax,%ax
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103278:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010327c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010327f:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
80103285:	e9 48 ff ff ff       	jmp    801031d2 <mpinit+0xe2>
8010328a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      break;
    }
  }
  if(!ismp){
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103290:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
80103297:	00 00 00 
    lapic = 0;
8010329a:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
801032a1:	00 00 00 
    ioapicid = 0;
801032a4:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801032ab:	83 c4 2c             	add    $0x2c,%esp
801032ae:	5b                   	pop    %ebx
801032af:	5e                   	pop    %esi
801032b0:	5f                   	pop    %edi
801032b1:	5d                   	pop    %ebp
801032b2:	c3                   	ret    
	...

801032c0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801032c0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
801032c1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801032c6:	89 e5                	mov    %esp,%ebp
801032c8:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
801032cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
801032d0:	d3 c0                	rol    %cl,%eax
801032d2:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
801032d9:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
801032df:	ee                   	out    %al,(%dx)
801032e0:	66 c1 e8 08          	shr    $0x8,%ax
801032e4:	b2 a1                	mov    $0xa1,%dl
801032e6:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
801032e7:	5d                   	pop    %ebp
801032e8:	c3                   	ret    
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801032f0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801032f0:	55                   	push   %ebp
801032f1:	b9 21 00 00 00       	mov    $0x21,%ecx
801032f6:	89 e5                	mov    %esp,%ebp
801032f8:	83 ec 0c             	sub    $0xc,%esp
801032fb:	89 1c 24             	mov    %ebx,(%esp)
801032fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103303:	89 ca                	mov    %ecx,%edx
80103305:	89 74 24 04          	mov    %esi,0x4(%esp)
80103309:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010330d:	ee                   	out    %al,(%dx)
8010330e:	bb a1 00 00 00       	mov    $0xa1,%ebx
80103313:	89 da                	mov    %ebx,%edx
80103315:	ee                   	out    %al,(%dx)
80103316:	be 11 00 00 00       	mov    $0x11,%esi
8010331b:	b2 20                	mov    $0x20,%dl
8010331d:	89 f0                	mov    %esi,%eax
8010331f:	ee                   	out    %al,(%dx)
80103320:	b8 20 00 00 00       	mov    $0x20,%eax
80103325:	89 ca                	mov    %ecx,%edx
80103327:	ee                   	out    %al,(%dx)
80103328:	b8 04 00 00 00       	mov    $0x4,%eax
8010332d:	ee                   	out    %al,(%dx)
8010332e:	bf 03 00 00 00       	mov    $0x3,%edi
80103333:	89 f8                	mov    %edi,%eax
80103335:	ee                   	out    %al,(%dx)
80103336:	b1 a0                	mov    $0xa0,%cl
80103338:	89 f0                	mov    %esi,%eax
8010333a:	89 ca                	mov    %ecx,%edx
8010333c:	ee                   	out    %al,(%dx)
8010333d:	b8 28 00 00 00       	mov    $0x28,%eax
80103342:	89 da                	mov    %ebx,%edx
80103344:	ee                   	out    %al,(%dx)
80103345:	b8 02 00 00 00       	mov    $0x2,%eax
8010334a:	ee                   	out    %al,(%dx)
8010334b:	89 f8                	mov    %edi,%eax
8010334d:	ee                   	out    %al,(%dx)
8010334e:	be 68 00 00 00       	mov    $0x68,%esi
80103353:	b2 20                	mov    $0x20,%dl
80103355:	89 f0                	mov    %esi,%eax
80103357:	ee                   	out    %al,(%dx)
80103358:	bb 0a 00 00 00       	mov    $0xa,%ebx
8010335d:	89 d8                	mov    %ebx,%eax
8010335f:	ee                   	out    %al,(%dx)
80103360:	89 f0                	mov    %esi,%eax
80103362:	89 ca                	mov    %ecx,%edx
80103364:	ee                   	out    %al,(%dx)
80103365:	89 d8                	mov    %ebx,%eax
80103367:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103368:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010336f:	66 83 f8 ff          	cmp    $0xffffffff,%ax
80103373:	74 0a                	je     8010337f <picinit+0x8f>
80103375:	b2 21                	mov    $0x21,%dl
80103377:	ee                   	out    %al,(%dx)
80103378:	66 c1 e8 08          	shr    $0x8,%ax
8010337c:	b2 a1                	mov    $0xa1,%dl
8010337e:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
8010337f:	8b 1c 24             	mov    (%esp),%ebx
80103382:	8b 74 24 04          	mov    0x4(%esp),%esi
80103386:	8b 7c 24 08          	mov    0x8(%esp),%edi
8010338a:	89 ec                	mov    %ebp,%esp
8010338c:	5d                   	pop    %ebp
8010338d:	c3                   	ret    
	...

80103390 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 1c             	sub    $0x1c,%esp
80103399:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010339c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010339f:	89 1c 24             	mov    %ebx,(%esp)
801033a2:	e8 29 14 00 00       	call   801047d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033a7:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801033ad:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
801033b3:	75 58                	jne    8010340d <piperead+0x7d>
801033b5:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801033bb:	85 f6                	test   %esi,%esi
801033bd:	74 4e                	je     8010340d <piperead+0x7d>
    if(proc->killed){
801033bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033c5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
801033cb:	8b 48 24             	mov    0x24(%eax),%ecx
801033ce:	85 c9                	test   %ecx,%ecx
801033d0:	74 21                	je     801033f3 <piperead+0x63>
801033d2:	e9 99 00 00 00       	jmp    80103470 <piperead+0xe0>
801033d7:	90                   	nop
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033d8:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033de:	85 c0                	test   %eax,%eax
801033e0:	74 2b                	je     8010340d <piperead+0x7d>
    if(proc->killed){
801033e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801033e8:	8b 50 24             	mov    0x24(%eax),%edx
801033eb:	85 d2                	test   %edx,%edx
801033ed:	0f 85 7d 00 00 00    	jne    80103470 <piperead+0xe0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801033f7:	89 34 24             	mov    %esi,(%esp)
801033fa:	e8 81 06 00 00       	call   80103a80 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033ff:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
80103405:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
8010340b:	74 cb                	je     801033d8 <piperead+0x48>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010340d:	85 ff                	test   %edi,%edi
8010340f:	7e 76                	jle    80103487 <piperead+0xf7>
    if(p->nread == p->nwrite)
80103411:	31 f6                	xor    %esi,%esi
80103413:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
80103419:	75 0d                	jne    80103428 <piperead+0x98>
8010341b:	eb 6a                	jmp    80103487 <piperead+0xf7>
8010341d:	8d 76 00             	lea    0x0(%esi),%esi
80103420:	39 93 38 02 00 00    	cmp    %edx,0x238(%ebx)
80103426:	74 22                	je     8010344a <piperead+0xba>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103428:	89 d0                	mov    %edx,%eax
8010342a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010342d:	83 c2 01             	add    $0x1,%edx
80103430:	25 ff 01 00 00       	and    $0x1ff,%eax
80103435:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
8010343a:	88 04 31             	mov    %al,(%ecx,%esi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010343d:	83 c6 01             	add    $0x1,%esi
80103440:	39 f7                	cmp    %esi,%edi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103442:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103448:	7f d6                	jg     80103420 <piperead+0x90>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010344a:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103450:	89 04 24             	mov    %eax,(%esp)
80103453:	e8 c8 04 00 00       	call   80103920 <wakeup>
  release(&p->lock);
80103458:	89 1c 24             	mov    %ebx,(%esp)
8010345b:	e8 20 13 00 00       	call   80104780 <release>
  return i;
}
80103460:	83 c4 1c             	add    $0x1c,%esp
80103463:	89 f0                	mov    %esi,%eax
80103465:	5b                   	pop    %ebx
80103466:	5e                   	pop    %esi
80103467:	5f                   	pop    %edi
80103468:	5d                   	pop    %ebp
80103469:	c3                   	ret    
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
80103470:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103475:	89 1c 24             	mov    %ebx,(%esp)
80103478:	e8 03 13 00 00       	call   80104780 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
8010347d:	83 c4 1c             	add    $0x1c,%esp
80103480:	89 f0                	mov    %esi,%eax
80103482:	5b                   	pop    %ebx
80103483:	5e                   	pop    %esi
80103484:	5f                   	pop    %edi
80103485:	5d                   	pop    %ebp
80103486:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103487:	31 f6                	xor    %esi,%esi
80103489:	eb bf                	jmp    8010344a <piperead+0xba>
8010348b:	90                   	nop
8010348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103490 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 3c             	sub    $0x3c,%esp
80103499:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010349c:	89 1c 24             	mov    %ebx,(%esp)
8010349f:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034a5:	e8 26 13 00 00       	call   801047d0 <acquire>
  for(i = 0; i < n; i++){
801034aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
801034ad:	85 c9                	test   %ecx,%ecx
801034af:	0f 8e 8d 00 00 00    	jle    80103542 <pipewrite+0xb2>
801034b5:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034bb:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
801034c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801034c8:	eb 37                	jmp    80103501 <pipewrite+0x71>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801034d0:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034d6:	85 c0                	test   %eax,%eax
801034d8:	74 7e                	je     80103558 <pipewrite+0xc8>
801034da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801034e0:	8b 50 24             	mov    0x24(%eax),%edx
801034e3:	85 d2                	test   %edx,%edx
801034e5:	75 71                	jne    80103558 <pipewrite+0xc8>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034e7:	89 34 24             	mov    %esi,(%esp)
801034ea:	e8 31 04 00 00       	call   80103920 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801034f3:	89 3c 24             	mov    %edi,(%esp)
801034f6:	e8 85 05 00 00       	call   80103a80 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034fb:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103501:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
80103507:	81 c2 00 02 00 00    	add    $0x200,%edx
8010350d:	39 d0                	cmp    %edx,%eax
8010350f:	74 bf                	je     801034d0 <pipewrite+0x40>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103511:	89 c2                	mov    %eax,%edx
80103513:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103516:	83 c0 01             	add    $0x1,%eax
80103519:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010351f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80103522:	8b 55 0c             	mov    0xc(%ebp),%edx
80103525:	0f b6 0c 0a          	movzbl (%edx,%ecx,1),%ecx
80103529:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010352c:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
80103530:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103536:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010353a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010353d:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103540:	7f bf                	jg     80103501 <pipewrite+0x71>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103542:	89 34 24             	mov    %esi,(%esp)
80103545:	e8 d6 03 00 00       	call   80103920 <wakeup>
  release(&p->lock);
8010354a:	89 1c 24             	mov    %ebx,(%esp)
8010354d:	e8 2e 12 00 00       	call   80104780 <release>
  return n;
80103552:	eb 13                	jmp    80103567 <pipewrite+0xd7>
80103554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103558:	89 1c 24             	mov    %ebx,(%esp)
8010355b:	e8 20 12 00 00       	call   80104780 <release>
80103560:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103567:	8b 45 10             	mov    0x10(%ebp),%eax
8010356a:	83 c4 3c             	add    $0x3c,%esp
8010356d:	5b                   	pop    %ebx
8010356e:	5e                   	pop    %esi
8010356f:	5f                   	pop    %edi
80103570:	5d                   	pop    %ebp
80103571:	c3                   	ret    
80103572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103580 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	83 ec 18             	sub    $0x18,%esp
80103586:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80103589:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010358c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010358f:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103592:	89 1c 24             	mov    %ebx,(%esp)
80103595:	e8 36 12 00 00       	call   801047d0 <acquire>
  if(writable){
8010359a:	85 f6                	test   %esi,%esi
8010359c:	74 42                	je     801035e0 <pipeclose+0x60>
    p->writeopen = 0;
8010359e:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035a5:	00 00 00 
    wakeup(&p->nread);
801035a8:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035ae:	89 04 24             	mov    %eax,(%esp)
801035b1:	e8 6a 03 00 00       	call   80103920 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035b6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035bc:	85 c0                	test   %eax,%eax
801035be:	75 0a                	jne    801035ca <pipeclose+0x4a>
801035c0:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801035c6:	85 f6                	test   %esi,%esi
801035c8:	74 36                	je     80103600 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035ca:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035cd:	8b 75 fc             	mov    -0x4(%ebp),%esi
801035d0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801035d3:	89 ec                	mov    %ebp,%esp
801035d5:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035d6:	e9 a5 11 00 00       	jmp    80104780 <release>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801035e0:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035e7:	00 00 00 
    wakeup(&p->nwrite);
801035ea:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035f0:	89 04 24             	mov    %eax,(%esp)
801035f3:	e8 28 03 00 00       	call   80103920 <wakeup>
801035f8:	eb bc                	jmp    801035b6 <pipeclose+0x36>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103600:	89 1c 24             	mov    %ebx,(%esp)
80103603:	e8 78 11 00 00       	call   80104780 <release>
    kfree((char*)p);
  } else
    release(&p->lock);
}
80103608:	8b 75 fc             	mov    -0x4(%ebp),%esi
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
8010360b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
8010360e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103611:	89 ec                	mov    %ebp,%esp
80103613:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103614:	e9 97 ed ff ff       	jmp    801023b0 <kfree>
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103620 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	57                   	push   %edi
80103624:	56                   	push   %esi
80103625:	53                   	push   %ebx
80103626:	83 ec 1c             	sub    $0x1c,%esp
80103629:	8b 75 08             	mov    0x8(%ebp),%esi
8010362c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010362f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103635:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010363b:	e8 a0 d9 ff ff       	call   80100fe0 <filealloc>
80103640:	85 c0                	test   %eax,%eax
80103642:	89 06                	mov    %eax,(%esi)
80103644:	0f 84 9c 00 00 00    	je     801036e6 <pipealloc+0xc6>
8010364a:	e8 91 d9 ff ff       	call   80100fe0 <filealloc>
8010364f:	85 c0                	test   %eax,%eax
80103651:	89 03                	mov    %eax,(%ebx)
80103653:	0f 84 7f 00 00 00    	je     801036d8 <pipealloc+0xb8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103659:	e8 02 ed ff ff       	call   80102360 <kalloc>
8010365e:	85 c0                	test   %eax,%eax
80103660:	89 c7                	mov    %eax,%edi
80103662:	74 74                	je     801036d8 <pipealloc+0xb8>
    goto bad;
  p->readopen = 1;
80103664:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010366b:	00 00 00 
  p->writeopen = 1;
8010366e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103675:	00 00 00 
  p->nwrite = 0;
80103678:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010367f:	00 00 00 
  p->nread = 0;
80103682:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103689:	00 00 00 
  initlock(&p->lock, "pipe");
8010368c:	89 04 24             	mov    %eax,(%esp)
8010368f:	c7 44 24 04 38 78 10 	movl   $0x80107838,0x4(%esp)
80103696:	80 
80103697:	e8 a4 0f 00 00       	call   80104640 <initlock>
  (*f0)->type = FD_PIPE;
8010369c:	8b 06                	mov    (%esi),%eax
8010369e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036a4:	8b 06                	mov    (%esi),%eax
801036a6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036aa:	8b 06                	mov    (%esi),%eax
801036ac:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036b0:	8b 06                	mov    (%esi),%eax
801036b2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036b5:	8b 03                	mov    (%ebx),%eax
801036b7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036bd:	8b 03                	mov    (%ebx),%eax
801036bf:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036c3:	8b 03                	mov    (%ebx),%eax
801036c5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036c9:	8b 03                	mov    (%ebx),%eax
801036cb:	89 78 0c             	mov    %edi,0xc(%eax)
801036ce:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036d0:	83 c4 1c             	add    $0x1c,%esp
801036d3:	5b                   	pop    %ebx
801036d4:	5e                   	pop    %esi
801036d5:	5f                   	pop    %edi
801036d6:	5d                   	pop    %ebp
801036d7:	c3                   	ret    

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036d8:	8b 06                	mov    (%esi),%eax
801036da:	85 c0                	test   %eax,%eax
801036dc:	74 08                	je     801036e6 <pipealloc+0xc6>
    fileclose(*f0);
801036de:	89 04 24             	mov    %eax,(%esp)
801036e1:	e8 7a d9 ff ff       	call   80101060 <fileclose>
  if(*f1)
801036e6:	8b 13                	mov    (%ebx),%edx
801036e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036ed:	85 d2                	test   %edx,%edx
801036ef:	74 df                	je     801036d0 <pipealloc+0xb0>
    fileclose(*f1);
801036f1:	89 14 24             	mov    %edx,(%esp)
801036f4:	e8 67 d9 ff ff       	call   80101060 <fileclose>
801036f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036fe:	eb d0                	jmp    801036d0 <pipealloc+0xb0>

80103700 <rndm_gen>:
}

//code for a random number generator
unsigned long
rndm_gen(int sd)
{
80103700:	55                   	push   %ebp
80103701:	31 c0                	xor    %eax,%eax
80103703:	89 e5                	mov    %esp,%ebp
80103705:	69 55 08 c1 60 a8 10 	imul   $0x10a860c1,0x8(%ebp),%edx
	return (sd*279470273UL)%4294967291UL;
}
8010370c:	5d                   	pop    %ebp
}

//code for a random number generator
unsigned long
rndm_gen(int sd)
{
8010370d:	83 fa fb             	cmp    $0xfffffffb,%edx
80103710:	0f 93 c0             	setae  %al
80103713:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
8010371a:	8d 04 01             	lea    (%ecx,%eax,1),%eax
8010371d:	8d 04 02             	lea    (%edx,%eax,1),%eax
	return (sd*279470273UL)%4294967291UL;
}
80103720:	c3                   	ret    
80103721:	eb 0d                	jmp    80103730 <set_tickets>
80103723:	90                   	nop
80103724:	90                   	nop
80103725:	90                   	nop
80103726:	90                   	nop
80103727:	90                   	nop
80103728:	90                   	nop
80103729:	90                   	nop
8010372a:	90                   	nop
8010372b:	90                   	nop
8010372c:	90                   	nop
8010372d:	90                   	nop
8010372e:	90                   	nop
8010372f:	90                   	nop

80103730 <set_tickets>:
}

//our code for set_tickets
int
set_tickets(int tickets)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	53                   	push   %ebx
	total_tickets += tickets;	
	proc->tickets = tickets;
	proc->pass = 10000/proc->tickets;
80103734:	bb 10 27 00 00       	mov    $0x2710,%ebx
}

//our code for set_tickets
int
set_tickets(int tickets)
{
80103739:	83 ec 14             	sub    $0x14,%esp
8010373c:	8b 45 08             	mov    0x8(%ebp),%eax
	total_tickets += tickets;	
	proc->tickets = tickets;
8010373f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

//our code for set_tickets
int
set_tickets(int tickets)
{
	total_tickets += tickets;	
80103746:	01 05 c4 a5 10 80    	add    %eax,0x8010a5c4
	proc->tickets = tickets;
8010374c:	89 42 7c             	mov    %eax,0x7c(%edx)
	proc->pass = 10000/proc->tickets;
8010374f:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80103756:	89 da                	mov    %ebx,%edx
80103758:	89 d8                	mov    %ebx,%eax
8010375a:	c1 fa 1f             	sar    $0x1f,%edx
8010375d:	f7 79 7c             	idivl  0x7c(%ecx)
80103760:	89 81 84 00 00 00    	mov    %eax,0x84(%ecx)
	cprintf("ticket value for %s set to :%d\n",proc->name,proc->tickets);
80103766:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010376c:	8b 50 7c             	mov    0x7c(%eax),%edx
8010376f:	83 c0 6c             	add    $0x6c,%eax
80103772:	89 44 24 04          	mov    %eax,0x4(%esp)
80103776:	c7 04 24 40 78 10 80 	movl   $0x80107840,(%esp)
8010377d:	89 54 24 08          	mov    %edx,0x8(%esp)
80103781:	e8 ea d0 ff ff       	call   80100870 <cprintf>
	cprintf("Stride value for %s is : %d\n",proc->name,(10000/proc->tickets));
80103786:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
8010378d:	89 da                	mov    %ebx,%edx
8010378f:	89 d8                	mov    %ebx,%eax
80103791:	c1 fa 1f             	sar    $0x1f,%edx
80103794:	f7 79 7c             	idivl  0x7c(%ecx)
80103797:	83 c1 6c             	add    $0x6c,%ecx
8010379a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010379e:	c7 04 24 60 78 10 80 	movl   $0x80107860,(%esp)
801037a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801037a9:	e8 c2 d0 ff ff       	call   80100870 <cprintf>
	return 0;
}
801037ae:	83 c4 14             	add    $0x14,%esp
801037b1:	31 c0                	xor    %eax,%eax
801037b3:	5b                   	pop    %ebx
801037b4:	5d                   	pop    %ebp
801037b5:	c3                   	ret    
801037b6:	8d 76 00             	lea    0x0(%esi),%esi
801037b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	57                   	push   %edi
801037c4:	56                   	push   %esi
801037c5:	53                   	push   %ebx
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
801037c6:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
{
801037cb:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
801037ce:	8d 7d c0             	lea    -0x40(%ebp),%edi
801037d1:	eb 4e                	jmp    80103821 <procdump+0x61>
801037d3:	90                   	nop
801037d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801037d8:	8b 04 85 6c 79 10 80 	mov    -0x7fef8694(,%eax,4),%eax
801037df:	85 c0                	test   %eax,%eax
801037e1:	74 4a                	je     8010382d <procdump+0x6d>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
801037e3:	89 44 24 08          	mov    %eax,0x8(%esp)
801037e7:	8b 43 10             	mov    0x10(%ebx),%eax
801037ea:	8d 53 6c             	lea    0x6c(%ebx),%edx
801037ed:	89 54 24 0c          	mov    %edx,0xc(%esp)
801037f1:	c7 04 24 81 78 10 80 	movl   $0x80107881,(%esp)
801037f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801037fc:	e8 6f d0 ff ff       	call   80100870 <cprintf>
    if(p->state == SLEEPING){
80103801:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103805:	74 31                	je     80103838 <procdump+0x78>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103807:	c7 04 24 16 78 10 80 	movl   $0x80107816,(%esp)
8010380e:	e8 5d d0 ff ff       	call   80100870 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103813:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103819:	81 fb d4 4f 11 80    	cmp    $0x80114fd4,%ebx
8010381f:	74 57                	je     80103878 <procdump+0xb8>
    if(p->state == UNUSED)
80103821:	8b 43 0c             	mov    0xc(%ebx),%eax
80103824:	85 c0                	test   %eax,%eax
80103826:	74 eb                	je     80103813 <procdump+0x53>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103828:	83 f8 05             	cmp    $0x5,%eax
8010382b:	76 ab                	jbe    801037d8 <procdump+0x18>
8010382d:	b8 7d 78 10 80       	mov    $0x8010787d,%eax
80103832:	eb af                	jmp    801037e3 <procdump+0x23>
80103834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103838:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010383b:	31 f6                	xor    %esi,%esi
8010383d:	89 7c 24 04          	mov    %edi,0x4(%esp)
80103841:	8b 40 0c             	mov    0xc(%eax),%eax
80103844:	83 c0 08             	add    $0x8,%eax
80103847:	89 04 24             	mov    %eax,(%esp)
8010384a:	e8 11 0e 00 00       	call   80104660 <getcallerpcs>
8010384f:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
80103850:	8b 04 b7             	mov    (%edi,%esi,4),%eax
80103853:	85 c0                	test   %eax,%eax
80103855:	74 b0                	je     80103807 <procdump+0x47>
80103857:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[i]);
8010385a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010385e:	c7 04 24 51 73 10 80 	movl   $0x80107351,(%esp)
80103865:	e8 06 d0 ff ff       	call   80100870 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010386a:	83 fe 0a             	cmp    $0xa,%esi
8010386d:	75 e1                	jne    80103850 <procdump+0x90>
8010386f:	eb 96                	jmp    80103807 <procdump+0x47>
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103878:	83 c4 4c             	add    $0x4c,%esp
8010387b:	5b                   	pop    %ebx
8010387c:	5e                   	pop    %esi
8010387d:	5f                   	pop    %edi
8010387e:	5d                   	pop    %ebp
8010387f:	90                   	nop
80103880:	c3                   	ret    
80103881:	eb 0d                	jmp    80103890 <kill>
80103883:	90                   	nop
80103884:	90                   	nop
80103885:	90                   	nop
80103886:	90                   	nop
80103887:	90                   	nop
80103888:	90                   	nop
80103889:	90                   	nop
8010388a:	90                   	nop
8010388b:	90                   	nop
8010388c:	90                   	nop
8010388d:	90                   	nop
8010388e:	90                   	nop
8010388f:	90                   	nop

80103890 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 14             	sub    $0x14,%esp
80103897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010389a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801038a1:	e8 2a 0f 00 00       	call   801047d0 <acquire>

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
801038a6:	b8 5c 2e 11 80       	mov    $0x80112e5c,%eax
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
801038ab:	39 1d e4 2d 11 80    	cmp    %ebx,0x80112de4
801038b1:	75 11                	jne    801038c4 <kill+0x34>
801038b3:	eb 62                	jmp    80103917 <kill+0x87>
801038b5:	8d 76 00             	lea    0x0(%esi),%esi
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038b8:	05 88 00 00 00       	add    $0x88,%eax
801038bd:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
801038c2:	74 3c                	je     80103900 <kill+0x70>
    if(p->pid == pid){
801038c4:	39 58 10             	cmp    %ebx,0x10(%eax)
801038c7:	75 ef                	jne    801038b8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801038c9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801038cd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801038d4:	74 1a                	je     801038f0 <kill+0x60>
        p->state = RUNNABLE;
      release(&ptable.lock);
801038d6:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801038dd:	e8 9e 0e 00 00       	call   80104780 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801038e2:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
801038e5:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801038e7:	5b                   	pop    %ebx
801038e8:	5d                   	pop    %ebp
801038e9:	c3                   	ret    
801038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801038f0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801038f7:	eb dd                	jmp    801038d6 <kill+0x46>
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103900:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103907:	e8 74 0e 00 00       	call   80104780 <release>
  return -1;
}
8010390c:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
8010390f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
80103914:	5b                   	pop    %ebx
80103915:	5d                   	pop    %ebp
80103916:	c3                   	ret    
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
80103917:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010391c:	eb ab                	jmp    801038c9 <kill+0x39>
8010391e:	66 90                	xchg   %ax,%ax

80103920 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	53                   	push   %ebx
80103924:	83 ec 14             	sub    $0x14,%esp
80103927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010392a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103931:	e8 9a 0e 00 00       	call   801047d0 <acquire>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
80103936:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010393b:	eb 0f                	jmp    8010394c <wakeup+0x2c>
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103940:	05 88 00 00 00       	add    $0x88,%eax
80103945:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
8010394a:	74 24                	je     80103970 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
8010394c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103950:	75 ee                	jne    80103940 <wakeup+0x20>
80103952:	3b 58 20             	cmp    0x20(%eax),%ebx
80103955:	75 e9                	jne    80103940 <wakeup+0x20>
      p->state = RUNNABLE;
80103957:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010395e:	05 88 00 00 00       	add    $0x88,%eax
80103963:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80103968:	75 e2                	jne    8010394c <wakeup+0x2c>
8010396a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103970:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80103977:	83 c4 14             	add    $0x14,%esp
8010397a:	5b                   	pop    %ebx
8010397b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010397c:	e9 ff 0d 00 00       	jmp    80104780 <release>
80103981:	eb 0d                	jmp    80103990 <forkret>
80103983:	90                   	nop
80103984:	90                   	nop
80103985:	90                   	nop
80103986:	90                   	nop
80103987:	90                   	nop
80103988:	90                   	nop
80103989:	90                   	nop
8010398a:	90                   	nop
8010398b:	90                   	nop
8010398c:	90                   	nop
8010398d:	90                   	nop
8010398e:	90                   	nop
8010398f:	90                   	nop

80103990 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103996:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010399d:	e8 de 0d 00 00       	call   80104780 <release>

  if (first) {
801039a2:	a1 08 a0 10 80       	mov    0x8010a008,%eax
801039a7:	85 c0                	test   %eax,%eax
801039a9:	75 05                	jne    801039b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039ab:	c9                   	leave  
801039ac:	c3                   	ret    
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801039b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801039b7:	c7 05 08 a0 10 80 00 	movl   $0x0,0x8010a008
801039be:	00 00 00 
    iinit(ROOTDEV);
801039c1:	e8 1a e5 ff ff       	call   80101ee0 <iinit>
    initlog(ROOTDEV);
801039c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039cd:	e8 4e f4 ff ff       	call   80102e20 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039d2:	c9                   	leave  
801039d3:	c3                   	ret    
801039d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039e0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
801039e4:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
801039e7:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801039ee:	e8 cd 0c 00 00       	call   801046c0 <holding>
801039f3:	85 c0                	test   %eax,%eax
801039f5:	74 4d                	je     80103a44 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
801039f7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039fd:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103a04:	75 62                	jne    80103a68 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
80103a06:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a0d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103a11:	74 49                	je     80103a5c <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a13:	9c                   	pushf  
80103a14:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103a15:	80 e5 02             	and    $0x2,%ch
80103a18:	75 36                	jne    80103a50 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
80103a1a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
80103a20:	83 c2 1c             	add    $0x1c,%edx
80103a23:	8b 40 04             	mov    0x4(%eax),%eax
80103a26:	89 14 24             	mov    %edx,(%esp)
80103a29:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a2d:	e8 8a 10 00 00       	call   80104abc <swtch>
  cpu->intena = intena;
80103a32:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a38:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103a3e:	83 c4 14             	add    $0x14,%esp
80103a41:	5b                   	pop    %ebx
80103a42:	5d                   	pop    %ebp
80103a43:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103a44:	c7 04 24 8a 78 10 80 	movl   $0x8010788a,(%esp)
80103a4b:	e8 80 c9 ff ff       	call   801003d0 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103a50:	c7 04 24 b6 78 10 80 	movl   $0x801078b6,(%esp)
80103a57:	e8 74 c9 ff ff       	call   801003d0 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103a5c:	c7 04 24 a8 78 10 80 	movl   $0x801078a8,(%esp)
80103a63:	e8 68 c9 ff ff       	call   801003d0 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103a68:	c7 04 24 9c 78 10 80 	movl   $0x8010789c,(%esp)
80103a6f:	e8 5c c9 ff ff       	call   801003d0 <panic>
80103a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a80 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	56                   	push   %esi
80103a84:	53                   	push   %ebx
80103a85:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80103a88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103a8e:	8b 75 08             	mov    0x8(%ebp),%esi
80103a91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103a94:	85 c0                	test   %eax,%eax
80103a96:	0f 84 a1 00 00 00    	je     80103b3d <sleep+0xbd>
    panic("sleep");

  if(lk == 0)
80103a9c:	85 db                	test   %ebx,%ebx
80103a9e:	0f 84 8d 00 00 00    	je     80103b31 <sleep+0xb1>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103aa4:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103aaa:	74 5c                	je     80103b08 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103aac:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ab3:	e8 18 0d 00 00       	call   801047d0 <acquire>
    release(lk);
80103ab8:	89 1c 24             	mov    %ebx,(%esp)
80103abb:	e8 c0 0c 00 00       	call   80104780 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103ac0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ac6:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103ac9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103acf:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103ad6:	e8 05 ff ff ff       	call   801039e0 <sched>

  // Tidy up.
  proc->chan = 0;
80103adb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ae1:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103ae8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103aef:	e8 8c 0c 00 00       	call   80104780 <release>
    acquire(lk);
80103af4:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103af7:	83 c4 10             	add    $0x10,%esp
80103afa:	5b                   	pop    %ebx
80103afb:	5e                   	pop    %esi
80103afc:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103afd:	e9 ce 0c 00 00       	jmp    801047d0 <acquire>
80103b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103b08:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103b0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b11:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103b18:	e8 c3 fe ff ff       	call   801039e0 <sched>

  // Tidy up.
  proc->chan = 0;
80103b1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b23:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103b2a:	83 c4 10             	add    $0x10,%esp
80103b2d:	5b                   	pop    %ebx
80103b2e:	5e                   	pop    %esi
80103b2f:	5d                   	pop    %ebp
80103b30:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103b31:	c7 04 24 d0 78 10 80 	movl   $0x801078d0,(%esp)
80103b38:	e8 93 c8 ff ff       	call   801003d0 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103b3d:	c7 04 24 ca 78 10 80 	movl   $0x801078ca,(%esp)
80103b44:	e8 87 c8 ff ff       	call   801003d0 <panic>
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b50 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103b56:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103b5d:	e8 6e 0c 00 00       	call   801047d0 <acquire>
  proc->state = RUNNABLE;
80103b62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b68:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103b6f:	e8 6c fe ff ff       	call   801039e0 <sched>
  release(&ptable.lock);
80103b74:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103b7b:	e8 00 0c 00 00       	call   80104780 <release>
}
80103b80:	c9                   	leave  
80103b81:	c3                   	ret    
80103b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b90 <scheduler2>:


//original scheduler
void
scheduler2(void)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	53                   	push   %ebx
80103b94:	83 ec 14             	sub    $0x14,%esp
80103b97:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b98:	fb                   	sti    
}


//original scheduler
void
scheduler2(void)
80103b99:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
  

  for(;;){
    // Enable interrupts on this processor.
    sti();
    acquire(&ptable.lock);
80103b9e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ba5:	e8 26 0c 00 00       	call   801047d0 <acquire>
80103baa:	eb 12                	jmp    80103bbe <scheduler2+0x2e>
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bb0:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103bb6:	81 fb d4 4f 11 80    	cmp    $0x80114fd4,%ebx
80103bbc:	74 52                	je     80103c10 <scheduler2+0x80>
      if(p->state != RUNNABLE)
80103bbe:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103bc2:	75 ec                	jne    80103bb0 <scheduler2+0x20>
        continue;
	
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103bc4:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103bcb:	89 1c 24             	mov    %ebx,(%esp)
80103bce:	e8 0d 35 00 00       	call   801070e0 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103bd3:	8b 43 1c             	mov    0x1c(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103bd6:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)

  for(;;){
    // Enable interrupts on this processor.
    sti();
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bdd:	81 c3 88 00 00 00    	add    $0x88,%ebx
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103be3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103be7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103bed:	83 c0 04             	add    $0x4,%eax
80103bf0:	89 04 24             	mov    %eax,(%esp)
80103bf3:	e8 c4 0e 00 00       	call   80104abc <swtch>
      switchkvm();
80103bf8:	e8 c3 2d 00 00       	call   801069c0 <switchkvm>

  for(;;){
    // Enable interrupts on this processor.
    sti();
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bfd:	81 fb d4 4f 11 80    	cmp    $0x80114fd4,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103c03:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103c0a:	00 00 00 00 

  for(;;){
    // Enable interrupts on this processor.
    sti();
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c0e:	75 ae                	jne    80103bbe <scheduler2+0x2e>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103c10:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103c17:	e8 64 0b 00 00       	call   80104780 <release>

  }
80103c1c:	e9 77 ff ff ff       	jmp    80103b98 <scheduler2+0x8>
80103c21:	eb 0d                	jmp    80103c30 <scheduler1>
80103c23:	90                   	nop
80103c24:	90                   	nop
80103c25:	90                   	nop
80103c26:	90                   	nop
80103c27:	90                   	nop
80103c28:	90                   	nop
80103c29:	90                   	nop
80103c2a:	90                   	nop
80103c2b:	90                   	nop
80103c2c:	90                   	nop
80103c2d:	90                   	nop
80103c2e:	90                   	nop
80103c2f:	90                   	nop

80103c30 <scheduler1>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler1(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	bb c1 60 a8 10       	mov    $0x10a860c1,%ebx
80103c3b:	83 ec 2c             	sub    $0x2c,%esp
80103c3e:	66 90                	xchg   %ax,%ax
80103c40:	fb                   	sti    
    sd++;
    //CS 202
    //Random number generator
    //Having lottery
   
    winner=rndm_gen(sd)%(total_tickets+1);
80103c41:	31 c0                	xor    %eax,%eax
80103c43:	83 fb fb             	cmp    $0xfffffffb,%ebx
80103c46:	0f 93 c0             	setae  %al
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler1(void)
80103c49:	bf d4 2d 11 80       	mov    $0x80112dd4,%edi
    sd++;
    //CS 202
    //Random number generator
    //Having lottery
   
    winner=rndm_gen(sd)%(total_tickets+1);
80103c4e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103c55:	8d 04 02             	lea    (%edx,%eax,1),%eax
80103c58:	8b 15 c4 a5 10 80    	mov    0x8010a5c4,%edx
80103c5e:	8d 04 03             	lea    (%ebx,%eax,1),%eax
    
    //cprintf("Winner is : %d\n",winner);
    counter = 0; 
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103c61:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
    sd++;
    //CS 202
    //Random number generator
    //Having lottery
   
    winner=rndm_gen(sd)%(total_tickets+1);
80103c68:	8d 4a 01             	lea    0x1(%edx),%ecx
80103c6b:	31 d2                	xor    %edx,%edx
80103c6d:	f7 f1                	div    %ecx
80103c6f:	89 d6                	mov    %edx,%esi
    
    //cprintf("Winner is : %d\n",winner);
    counter = 0; 
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103c71:	e8 5a 0b 00 00       	call   801047d0 <acquire>
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler1(void)
80103c76:	31 c0                	xor    %eax,%eax
80103c78:	eb 14                	jmp    80103c8e <scheduler1+0x5e>
80103c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    
    //cprintf("Winner is : %d\n",winner);
    counter = 0; 
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c80:	81 c7 88 00 00 00    	add    $0x88,%edi
80103c86:	81 ff d4 4f 11 80    	cmp    $0x80114fd4,%edi
80103c8c:	74 6a                	je     80103cf8 <scheduler1+0xc8>
       //cprintf("Inside: %d", p->state);
      if(p->state != RUNNABLE)
80103c8e:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103c92:	75 ec                	jne    80103c80 <scheduler1+0x50>
        continue;
      //cprintf("Counter: %d, Tickets: %d", counter, p->tickets);
      counter =counter + p->tickets;
80103c94:	03 47 7c             	add    0x7c(%edi),%eax
      if(counter <  winner)
80103c97:	39 c6                	cmp    %eax,%esi
80103c99:	77 e5                	ja     80103c80 <scheduler1+0x50>
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("pid : ",p->pid);
      p->count +=1;
      proc = p;
      switchuvm(p);
80103c9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("pid : ",p->pid);
      p->count +=1;
80103c9e:	83 87 80 00 00 00 01 	addl   $0x1,0x80(%edi)
      proc = p;
80103ca5:	65 89 3d 04 00 00 00 	mov    %edi,%gs:0x4
      switchuvm(p);
80103cac:	89 3c 24             	mov    %edi,(%esp)
80103caf:	e8 2c 34 00 00       	call   801070e0 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103cb4:	8b 57 1c             	mov    0x1c(%edi),%edx
      // before jumping back to us.
      //cprintf("pid : ",p->pid);
      p->count +=1;
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103cb7:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
    
    //cprintf("Winner is : %d\n",winner);
    counter = 0; 
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cbe:	81 c7 88 00 00 00    	add    $0x88,%edi
      //cprintf("pid : ",p->pid);
      p->count +=1;
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103cc4:	89 54 24 04          	mov    %edx,0x4(%esp)
80103cc8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103ccf:	83 c2 04             	add    $0x4,%edx
80103cd2:	89 14 24             	mov    %edx,(%esp)
80103cd5:	e8 e2 0d 00 00       	call   80104abc <swtch>
      switchkvm();
80103cda:	e8 e1 2c 00 00       	call   801069c0 <switchkvm>
    
    //cprintf("Winner is : %d\n",winner);
    counter = 0; 
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cdf:	81 ff d4 4f 11 80    	cmp    $0x80114fd4,%edi
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103ce5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ce8:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103cef:	00 00 00 00 
    
    //cprintf("Winner is : %d\n",winner);
    counter = 0; 
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf3:	75 99                	jne    80103c8e <scheduler1+0x5e>
80103cf5:	8d 76 00             	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103cf8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103cff:	81 c3 c1 60 a8 10    	add    $0x10a860c1,%ebx
80103d05:	e8 76 0a 00 00       	call   80104780 <release>

  }
80103d0a:	e9 31 ff ff ff       	jmp    80103c40 <scheduler1+0x10>
80103d0f:	90                   	nop

80103d10 <scheduler_b>:
  }
}

void 
scheduler_b(void)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	53                   	push   %ebx
80103d14:	83 ec 14             	sub    $0x14,%esp
 // int min_pass;
 //int stride=1;
 struct proc *p;
 struct proc *current;
 current = proc;
80103d17:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
80103d1e:	66 90                	xchg   %ax,%ax
80103d20:	fb                   	sti    
 for(;;)
     {
	sti();
	//struct proc *current;
        int min_pass=-1;
	acquire(&ptable.lock);
80103d21:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d28:	e8 a3 0a 00 00       	call   801047d0 <acquire>

  }
}

void 
scheduler_b(void)
80103d2d:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103d32:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	acquire(&ptable.lock);
	//min_pass = 10000;
    	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	{
          //cprintf("p ticktes: %d", p->tickets);
	  if(p->state != RUNNABLE)
80103d37:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103d3b:	74 19                	je     80103d56 <scheduler_b+0x46>
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
	sti();
	//struct proc *current;
        int min_pass=-1;
	acquire(&ptable.lock);
	//min_pass = 10000;
    	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d40:	05 88 00 00 00       	add    $0x88,%eax
          //cprintf("p ticktes: %d", p->tickets);
	  if(p->state != RUNNABLE)
        	continue;
          //if(pid == 0)
		//pid = p->pid;
	  if(min_pass<0 || p->pass<min_pass)
80103d45:	89 d1                	mov    %edx,%ecx
	sti();
	//struct proc *current;
        int min_pass=-1;
	acquire(&ptable.lock);
	//min_pass = 10000;
    	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d47:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80103d4c:	74 2a                	je     80103d78 <scheduler_b+0x68>
	{
          //cprintf("p ticktes: %d", p->tickets);
	  if(p->state != RUNNABLE)
80103d4e:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
	sti();
	//struct proc *current;
        int min_pass=-1;
	acquire(&ptable.lock);
	//min_pass = 10000;
    	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d52:	89 ca                	mov    %ecx,%edx
	{
          //cprintf("p ticktes: %d", p->tickets);
	  if(p->state != RUNNABLE)
80103d54:	75 ea                	jne    80103d40 <scheduler_b+0x30>
        	continue;
          //if(pid == 0)
		//pid = p->pid;
	  if(min_pass<0 || p->pass<min_pass)
80103d56:	85 d2                	test   %edx,%edx
80103d58:	0f 88 8a 00 00 00    	js     80103de8 <scheduler_b+0xd8>
80103d5e:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103d64:	39 d1                	cmp    %edx,%ecx
80103d66:	7d d8                	jge    80103d40 <scheduler_b+0x30>
80103d68:	89 c3                	mov    %eax,%ebx
	sti();
	//struct proc *current;
        int min_pass=-1;
	acquire(&ptable.lock);
	//min_pass = 10000;
    	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d6a:	05 88 00 00 00       	add    $0x88,%eax
80103d6f:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80103d74:	75 d8                	jne    80103d4e <scheduler_b+0x3e>
80103d76:	66 90                	xchg   %ax,%ax
	  }
  	  //i++;
	 } 
         //cprintf("pid found:%d\n ",p->pid);
         current->count +=1;
       	 current->pass+= 10000/current->tickets;
80103d78:	ba 10 27 00 00       	mov    $0x2710,%edx
80103d7d:	89 d0                	mov    %edx,%eax
80103d7f:	c1 fa 1f             	sar    $0x1f,%edx
80103d82:	f7 7b 7c             	idivl  0x7c(%ebx)
                // stride = 10;
	  }
  	  //i++;
	 } 
         //cprintf("pid found:%d\n ",p->pid);
         current->count +=1;
80103d85:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
       	 current->pass+= 10000/current->tickets;
80103d8c:	01 83 84 00 00 00    	add    %eax,0x84(%ebx)
	 proc = current;
80103d92:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
         switchuvm(current);
80103d99:	89 1c 24             	mov    %ebx,(%esp)
80103d9c:	e8 3f 33 00 00       	call   801070e0 <switchuvm>
         current->state = RUNNING;
         swtch(&cpu->scheduler, current->context);
80103da1:	8b 43 1c             	mov    0x1c(%ebx),%eax
         //cprintf("pid found:%d\n ",p->pid);
         current->count +=1;
       	 current->pass+= 10000/current->tickets;
	 proc = current;
         switchuvm(current);
         current->state = RUNNING;
80103da4:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
         swtch(&cpu->scheduler, current->context);
80103dab:	89 44 24 04          	mov    %eax,0x4(%esp)
80103daf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103db5:	83 c0 04             	add    $0x4,%eax
80103db8:	89 04 24             	mov    %eax,(%esp)
80103dbb:	e8 fc 0c 00 00       	call   80104abc <swtch>
         switchkvm();
80103dc0:	e8 fb 2b 00 00       	call   801069c0 <switchkvm>
        
         proc = 0; 
	
        release(&ptable.lock);
80103dc5:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
         switchuvm(current);
         current->state = RUNNING;
         swtch(&cpu->scheduler, current->context);
         switchkvm();
        
         proc = 0; 
80103dcc:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103dd3:	00 00 00 00 
	
        release(&ptable.lock);
80103dd7:	e8 a4 09 00 00       	call   80104780 <release>
     }
80103ddc:	e9 3f ff ff ff       	jmp    80103d20 <scheduler_b+0x10>
80103de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          //cprintf("p ticktes: %d", p->tickets);
	  if(p->state != RUNNABLE)
        	continue;
          //if(pid == 0)
		//pid = p->pid;
	  if(min_pass<0 || p->pass<min_pass)
80103de8:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103dee:	89 c3                	mov    %eax,%ebx
80103df0:	e9 75 ff ff ff       	jmp    80103d6a <scheduler_b+0x5a>
80103df5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <scheduler>:
}


void
scheduler(void)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	31 ff                	xor    %edi,%edi
80103e06:	56                   	push   %esi
80103e07:	53                   	push   %ebx
80103e08:	83 ec 1c             	sub    $0x1c,%esp
80103e0b:	90                   	nop
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e10:	fb                   	sti    
    min_pass =-1;
    // Enable interrupts on this processor.
    sti();
    //CS 202
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103e11:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
	return (sd*279470273UL)%4294967291UL;
}


void
scheduler(void)
80103e18:	be d4 4f 11 80       	mov    $0x80114fd4,%esi
    min_pass =-1;
    // Enable interrupts on this processor.
    sti();
    //CS 202
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103e1d:	e8 ae 09 00 00       	call   801047d0 <acquire>
	return (sd*279470273UL)%4294967291UL;
}


void
scheduler(void)
80103e22:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103e27:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
       //cprintf("Inside: %d", p->state);
      if(p->state != RUNNABLE)
80103e2c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e30:	74 1c                	je     80103e4e <scheduler+0x4e>
80103e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sti();
    //CS 202
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e38:	05 88 00 00 00       	add    $0x88,%eax
       //cprintf("Inside: %d", p->state);
      if(p->state != RUNNABLE)
        continue;
      if(p->pass < min_pass || min_pass < 0){
	min_pass = p->pass;
	w_pid = p->pid;
80103e3d:	89 d1                	mov    %edx,%ecx
    sti();
    //CS 202
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3f:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80103e44:	74 2a                	je     80103e70 <scheduler+0x70>
       //cprintf("Inside: %d", p->state);
      if(p->state != RUNNABLE)
80103e46:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
    sti();
    //CS 202
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e4a:	89 ca                	mov    %ecx,%edx
       //cprintf("Inside: %d", p->state);
      if(p->state != RUNNABLE)
80103e4c:	75 ea                	jne    80103e38 <scheduler+0x38>
        continue;
      if(p->pass < min_pass || min_pass < 0){
80103e4e:	85 d2                	test   %edx,%edx
80103e50:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103e56:	78 04                	js     80103e5c <scheduler+0x5c>
80103e58:	39 d1                	cmp    %edx,%ecx
80103e5a:	7d dc                	jge    80103e38 <scheduler+0x38>
	min_pass = p->pass;
	w_pid = p->pid;
80103e5c:	8b 78 10             	mov    0x10(%eax),%edi
    sti();
    //CS 202
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e5f:	05 88 00 00 00       	add    $0x88,%eax
80103e64:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80103e69:	75 db                	jne    80103e46 <scheduler+0x46>
80103e6b:	90                   	nop
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e70:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103e75:	eb 0b                	jmp    80103e82 <scheduler+0x82>
80103e77:	90                   	nop
      if(p->pass < min_pass || min_pass < 0){
	min_pass = p->pass;
	w_pid = p->pid;
      }
    }
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e78:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103e7e:	39 de                	cmp    %ebx,%esi
80103e80:	74 6e                	je     80103ef0 <scheduler+0xf0>
       //cprintf("Inside: %d", p->state);
      if(p->state != RUNNABLE)
80103e82:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e86:	75 f0                	jne    80103e78 <scheduler+0x78>
        continue;
      if(p->pid != w_pid)
80103e88:	39 7b 10             	cmp    %edi,0x10(%ebx)
80103e8b:	75 eb                	jne    80103e78 <scheduler+0x78>
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("pid : ",p->pid);
      p->count +=1;
      p->pass += (10000/p->tickets);
80103e8d:	ba 10 27 00 00       	mov    $0x2710,%edx
80103e92:	89 d0                	mov    %edx,%eax
80103e94:	c1 fa 1f             	sar    $0x1f,%edx
80103e97:	f7 7b 7c             	idivl  0x7c(%ebx)
	
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("pid : ",p->pid);
      p->count +=1;
80103e9a:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
      p->pass += (10000/p->tickets);
      proc = p;
80103ea1:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103ea8:	89 1c 24             	mov    %ebx,(%esp)
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("pid : ",p->pid);
      p->count +=1;
      p->pass += (10000/p->tickets);
80103eab:	01 83 84 00 00 00    	add    %eax,0x84(%ebx)
      proc = p;
      switchuvm(p);
80103eb1:	e8 2a 32 00 00       	call   801070e0 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103eb6:	8b 43 1c             	mov    0x1c(%ebx),%eax
      //cprintf("pid : ",p->pid);
      p->count +=1;
      p->pass += (10000/p->tickets);
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103eb9:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      if(p->pass < min_pass || min_pass < 0){
	min_pass = p->pass;
	w_pid = p->pid;
      }
    }
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec0:	81 c3 88 00 00 00    	add    $0x88,%ebx
      p->count +=1;
      p->pass += (10000/p->tickets);
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
80103eca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ed0:	83 c0 04             	add    $0x4,%eax
80103ed3:	89 04 24             	mov    %eax,(%esp)
80103ed6:	e8 e1 0b 00 00       	call   80104abc <swtch>
      switchkvm();
80103edb:	e8 e0 2a 00 00       	call   801069c0 <switchkvm>
      if(p->pass < min_pass || min_pass < 0){
	min_pass = p->pass;
	w_pid = p->pid;
      }
    }
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee0:	39 de                	cmp    %ebx,%esi
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103ee2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103ee9:	00 00 00 00 
      if(p->pass < min_pass || min_pass < 0){
	min_pass = p->pass;
	w_pid = p->pid;
      }
    }
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eed:	75 93                	jne    80103e82 <scheduler+0x82>
80103eef:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103ef0:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ef7:	e8 84 08 00 00       	call   80104780 <release>

  }
80103efc:	e9 0f ff ff ff       	jmp    80103e10 <scheduler+0x10>
80103f01:	eb 0d                	jmp    80103f10 <wait>
80103f03:	90                   	nop
80103f04:	90                   	nop
80103f05:	90                   	nop
80103f06:	90                   	nop
80103f07:	90                   	nop
80103f08:	90                   	nop
80103f09:	90                   	nop
80103f0a:	90                   	nop
80103f0b:	90                   	nop
80103f0c:	90                   	nop
80103f0d:	90                   	nop
80103f0e:	90                   	nop
80103f0f:	90                   	nop

80103f10 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103f14:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103f19:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103f1c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f23:	e8 a8 08 00 00       	call   801047d0 <acquire>
80103f28:	31 c0                	xor    %eax,%eax
80103f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f30:	81 fb d4 4f 11 80    	cmp    $0x80114fd4,%ebx
80103f36:	72 30                	jb     80103f68 <wait+0x58>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103f38:	85 c0                	test   %eax,%eax
80103f3a:	74 54                	je     80103f90 <wait+0x80>
80103f3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f42:	8b 50 24             	mov    0x24(%eax),%edx
80103f45:	85 d2                	test   %edx,%edx
80103f47:	75 47                	jne    80103f90 <wait+0x80>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103f49:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103f4e:	89 04 24             	mov    %eax,(%esp)
80103f51:	c7 44 24 04 a0 2d 11 	movl   $0x80112da0,0x4(%esp)
80103f58:	80 
80103f59:	e8 22 fb ff ff       	call   80103a80 <sleep>
80103f5e:	31 c0                	xor    %eax,%eax

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f60:	81 fb d4 4f 11 80    	cmp    $0x80114fd4,%ebx
80103f66:	73 d0                	jae    80103f38 <wait+0x28>
      if(p->parent != proc)
80103f68:	8b 53 14             	mov    0x14(%ebx),%edx
80103f6b:	65 3b 15 04 00 00 00 	cmp    %gs:0x4,%edx
80103f72:	74 0c                	je     80103f80 <wait+0x70>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f74:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103f7a:	eb b4                	jmp    80103f30 <wait+0x20>
80103f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103f80:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f84:	74 21                	je     80103fa7 <wait+0x97>
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f86:	b8 01 00 00 00       	mov    $0x1,%eax
80103f8b:	eb e7                	jmp    80103f74 <wait+0x64>
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103f90:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f97:	e8 e4 07 00 00       	call   80104780 <release>
80103f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fa1:	83 c4 24             	add    $0x24,%esp
80103fa4:	5b                   	pop    %ebx
80103fa5:	5d                   	pop    %ebp
80103fa6:	c3                   	ret    
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103fa7:	8b 43 10             	mov    0x10(%ebx),%eax
        kfree(p->kstack);
80103faa:	8b 53 08             	mov    0x8(%ebx),%edx
80103fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fb0:	89 14 24             	mov    %edx,(%esp)
80103fb3:	e8 f8 e3 ff ff       	call   801023b0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103fb8:	8b 53 04             	mov    0x4(%ebx),%edx
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103fbb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fc2:	89 14 24             	mov    %edx,(%esp)
80103fc5:	e8 e6 2d 00 00       	call   80106db0 <freevm>
        p->pid = 0;
80103fca:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fd1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fd8:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fdc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fe3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fea:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ff1:	e8 8a 07 00 00       	call   80104780 <release>
        return pid;
80103ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff9:	eb a6                	jmp    80103fa1 <wait+0x91>
80103ffb:	90                   	nop
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104000 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
  struct proc *p;
  int fd;
  cprintf("number of runs of %s is  %d\n",proc->name, proc->count);
  if(proc == initproc)
    panic("init exiting");
80104005:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104007:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;
  cprintf("number of runs of %s is  %d\n",proc->name, proc->count);
8010400a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104010:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104016:	83 c0 6c             	add    $0x6c,%eax
80104019:	89 44 24 04          	mov    %eax,0x4(%esp)
8010401d:	c7 04 24 e1 78 10 80 	movl   $0x801078e1,(%esp)
80104024:	89 54 24 08          	mov    %edx,0x8(%esp)
80104028:	e8 43 c8 ff ff       	call   80100870 <cprintf>
  if(proc == initproc)
8010402d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104033:	3b 05 c8 a5 10 80    	cmp    0x8010a5c8,%eax
80104039:	75 0b                	jne    80104046 <exit+0x46>
8010403b:	e9 10 01 00 00       	jmp    80104150 <exit+0x150>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104040:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd]){
80104046:	8d 73 08             	lea    0x8(%ebx),%esi
80104049:	8b 44 b0 08          	mov    0x8(%eax,%esi,4),%eax
8010404d:	85 c0                	test   %eax,%eax
8010404f:	74 16                	je     80104067 <exit+0x67>
      fileclose(proc->ofile[fd]);
80104051:	89 04 24             	mov    %eax,(%esp)
80104054:	e8 07 d0 ff ff       	call   80101060 <fileclose>
      proc->ofile[fd] = 0;
80104059:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010405f:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80104066:	00 
  cprintf("number of runs of %s is  %d\n",proc->name, proc->count);
  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104067:	83 c3 01             	add    $0x1,%ebx
8010406a:	83 fb 10             	cmp    $0x10,%ebx
8010406d:	75 d1                	jne    80104040 <exit+0x40>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
8010406f:	e8 3c ed ff ff       	call   80102db0 <begin_op>
  iput(proc->cwd);
80104074:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010407a:	8b 40 68             	mov    0x68(%eax),%eax
8010407d:	89 04 24             	mov    %eax,(%esp)
80104080:	e8 ab d3 ff ff       	call   80101430 <iput>
  end_op();
80104085:	e8 f6 eb ff ff       	call   80102c80 <end_op>
  proc->cwd = 0;
8010408a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104090:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104097:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010409e:	e8 2d 07 00 00       	call   801047d0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801040a3:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
801040aa:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801040af:	8b 51 14             	mov    0x14(%ecx),%edx
801040b2:	eb 10                	jmp    801040c4 <exit+0xc4>
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b8:	05 88 00 00 00       	add    $0x88,%eax
801040bd:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
801040c2:	74 1e                	je     801040e2 <exit+0xe2>
    if(p->state == SLEEPING && p->chan == chan)
801040c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040c8:	75 ee                	jne    801040b8 <exit+0xb8>
801040ca:	3b 50 20             	cmp    0x20(%eax),%edx
801040cd:	75 e9                	jne    801040b8 <exit+0xb8>
      p->state = RUNNABLE;
801040cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040d6:	05 88 00 00 00       	add    $0x88,%eax
801040db:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
801040e0:	75 e2                	jne    801040c4 <exit+0xc4>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
801040e2:	8b 1d c8 a5 10 80    	mov    0x8010a5c8,%ebx
801040e8:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
801040ed:	eb 0f                	jmp    801040fe <exit+0xfe>
801040ef:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f0:	81 c2 88 00 00 00    	add    $0x88,%edx
801040f6:	81 fa d4 4f 11 80    	cmp    $0x80114fd4,%edx
801040fc:	74 3a                	je     80104138 <exit+0x138>
    if(p->parent == proc){
801040fe:	3b 4a 14             	cmp    0x14(%edx),%ecx
80104101:	75 ed                	jne    801040f0 <exit+0xf0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104103:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80104107:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
8010410a:	75 e4                	jne    801040f0 <exit+0xf0>
8010410c:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80104111:	eb 11                	jmp    80104124 <exit+0x124>
80104113:	90                   	nop
80104114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104118:	05 88 00 00 00       	add    $0x88,%eax
8010411d:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80104122:	74 cc                	je     801040f0 <exit+0xf0>
    if(p->state == SLEEPING && p->chan == chan)
80104124:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104128:	75 ee                	jne    80104118 <exit+0x118>
8010412a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010412d:	75 e9                	jne    80104118 <exit+0x118>
      p->state = RUNNABLE;
8010412f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104136:	eb e0                	jmp    80104118 <exit+0x118>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104138:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
8010413f:	e8 9c f8 ff ff       	call   801039e0 <sched>
  panic("zombie exit");
80104144:	c7 04 24 0b 79 10 80 	movl   $0x8010790b,(%esp)
8010414b:	e8 80 c2 ff ff       	call   801003d0 <panic>
{
  struct proc *p;
  int fd;
  cprintf("number of runs of %s is  %d\n",proc->name, proc->count);
  if(proc == initproc)
    panic("init exiting");
80104150:	c7 04 24 fe 78 10 80 	movl   $0x801078fe,(%esp)
80104157:	e8 74 c2 ff ff       	call   801003d0 <panic>
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104160 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104167:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010416e:	e8 5d 06 00 00       	call   801047d0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
80104173:	8b 1d e0 2d 11 80    	mov    0x80112de0,%ebx
80104179:	85 db                	test   %ebx,%ebx
8010417b:	0f 84 cd 00 00 00    	je     8010424e <allocproc+0xee>
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
80104181:	bb 5c 2e 11 80       	mov    $0x80112e5c,%ebx
80104186:	eb 12                	jmp    8010419a <allocproc+0x3a>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104188:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010418e:	81 fb d4 4f 11 80    	cmp    $0x80114fd4,%ebx
80104194:	0f 84 9e 00 00 00    	je     80104238 <allocproc+0xd8>
    if(p->state == UNUSED)
8010419a:	8b 4b 0c             	mov    0xc(%ebx),%ecx
8010419d:	85 c9                	test   %ecx,%ecx
8010419f:	75 e7                	jne    80104188 <allocproc+0x28>
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801041a1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801041a8:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801041ad:	89 43 10             	mov    %eax,0x10(%ebx)
801041b0:	83 c0 01             	add    $0x1,%eax
801041b3:	a3 04 a0 10 80       	mov    %eax,0x8010a004
  release(&ptable.lock);
801041b8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801041bf:	e8 bc 05 00 00       	call   80104780 <release>
 
  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801041c4:	e8 97 e1 ff ff       	call   80102360 <kalloc>
801041c9:	85 c0                	test   %eax,%eax
801041cb:	89 43 08             	mov    %eax,0x8(%ebx)
801041ce:	0f 84 84 00 00 00    	je     80104258 <allocproc+0xf8>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801041d4:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
801041da:	89 53 18             	mov    %edx,0x18(%ebx)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801041dd:	c7 80 b0 0f 00 00 c0 	movl   $0x80105ac0,0xfb0(%eax)
801041e4:	5a 10 80 

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801041e7:	05 9c 0f 00 00       	add    $0xf9c,%eax
801041ec:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801041ef:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801041f6:	00 
801041f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801041fe:	00 
801041ff:	89 04 24             	mov    %eax,(%esp)
80104202:	e8 69 06 00 00       	call   80104870 <memset>
  p->context->eip = (uint)forkret; 
80104207:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010420a:	c7 40 10 90 39 10 80 	movl   $0x80103990,0x10(%eax)
  p->tickets = 1;
80104211:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->count = 0;
80104218:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010421f:	00 00 00 
  p->pass = 1;
80104222:	c7 83 84 00 00 00 01 	movl   $0x1,0x84(%ebx)
80104229:	00 00 00 
  //total_tickets += 1;
  return p;
}
8010422c:	89 d8                	mov    %ebx,%eax
8010422e:	83 c4 14             	add    $0x14,%esp
80104231:	5b                   	pop    %ebx
80104232:	5d                   	pop    %ebp
80104233:	c3                   	ret    
80104234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104238:	31 db                	xor    %ebx,%ebx
8010423a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104241:	e8 3a 05 00 00       	call   80104780 <release>
  p->tickets = 1;
  p->count = 0;
  p->pass = 1;
  //total_tickets += 1;
  return p;
}
80104246:	89 d8                	mov    %ebx,%eax
80104248:	83 c4 14             	add    $0x14,%esp
8010424b:	5b                   	pop    %ebx
8010424c:	5d                   	pop    %ebp
8010424d:	c3                   	ret    
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;
8010424e:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80104253:	e9 49 ff ff ff       	jmp    801041a1 <allocproc+0x41>
  p->pid = nextpid++;
  release(&ptable.lock);
 
  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104258:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
8010425f:	31 db                	xor    %ebx,%ebx
    return 0;
80104261:	eb c9                	jmp    8010422c <allocproc+0xcc>
80104263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104270 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80104275:	be ff ff ff ff       	mov    $0xffffffff,%esi
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010427a:	53                   	push   %ebx
8010427b:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
8010427e:	e8 dd fe ff ff       	call   80104160 <allocproc>
80104283:	85 c0                	test   %eax,%eax
80104285:	89 c3                	mov    %eax,%ebx
80104287:	0f 84 d6 00 00 00    	je     80104363 <fork+0xf3>
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010428d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104293:	8b 10                	mov    (%eax),%edx
80104295:	89 54 24 04          	mov    %edx,0x4(%esp)
80104299:	8b 40 04             	mov    0x4(%eax),%eax
8010429c:	89 04 24             	mov    %eax,(%esp)
8010429f:	e8 8c 2b 00 00       	call   80106e30 <copyuvm>
801042a4:	85 c0                	test   %eax,%eax
801042a6:	89 43 04             	mov    %eax,0x4(%ebx)
801042a9:	0f 84 be 00 00 00    	je     8010436d <fork+0xfd>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
801042af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
801042b5:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
801042ba:	8b 00                	mov    (%eax),%eax
801042bc:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
801042be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042c4:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
801042c7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801042ce:	8b 43 18             	mov    0x18(%ebx),%eax
801042d1:	8b 72 18             	mov    0x18(%edx),%esi
801042d4:	89 c7                	mov    %eax,%edi
801042d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801042d8:	31 f6                	xor    %esi,%esi
801042da:	8b 43 18             	mov    0x18(%ebx),%eax
801042dd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801042e4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801042eb:	90                   	nop
801042ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
801042f0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
801042f4:	85 c0                	test   %eax,%eax
801042f6:	74 13                	je     8010430b <fork+0x9b>
      np->ofile[i] = filedup(proc->ofile[i]);
801042f8:	89 04 24             	mov    %eax,(%esp)
801042fb:	e8 90 cc ff ff       	call   80100f90 <filedup>
80104300:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80104304:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010430b:	83 c6 01             	add    $0x1,%esi
8010430e:	83 fe 10             	cmp    $0x10,%esi
80104311:	75 dd                	jne    801042f0 <fork+0x80>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104313:	8b 42 68             	mov    0x68(%edx),%eax
80104316:	89 04 24             	mov    %eax,(%esp)
80104319:	e8 72 ce ff ff       	call   80101190 <idup>
8010431e:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104321:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104327:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010432e:	00 
8010432f:	83 c0 6c             	add    $0x6c,%eax
80104332:	89 44 24 04          	mov    %eax,0x4(%esp)
80104336:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104339:	89 04 24             	mov    %eax,(%esp)
8010433c:	e8 1f 07 00 00       	call   80104a60 <safestrcpy>

  pid = np->pid;
80104341:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80104344:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010434b:	e8 80 04 00 00       	call   801047d0 <acquire>

  np->state = RUNNABLE;
80104350:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80104357:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010435e:	e8 1d 04 00 00       	call   80104780 <release>

  return pid;
}
80104363:	83 c4 1c             	add    $0x1c,%esp
80104366:	89 f0                	mov    %esi,%eax
80104368:	5b                   	pop    %ebx
80104369:	5e                   	pop    %esi
8010436a:	5f                   	pop    %edi
8010436b:	5d                   	pop    %ebp
8010436c:	c3                   	ret    
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
8010436d:	8b 43 08             	mov    0x8(%ebx),%eax
80104370:	89 04 24             	mov    %eax,(%esp)
80104373:	e8 38 e0 ff ff       	call   801023b0 <kfree>
    np->kstack = 0;
80104378:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010437f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104386:	eb db                	jmp    80104363 <fork+0xf3>
80104388:	90                   	nop
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104390 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
80104396:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010439d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
801043a0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
801043a2:	83 f9 00             	cmp    $0x0,%ecx
801043a5:	7f 19                	jg     801043c0 <growproc+0x30>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801043a7:	75 39                	jne    801043e2 <growproc+0x52>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
801043a9:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
801043ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043b1:	89 04 24             	mov    %eax,(%esp)
801043b4:	e8 27 2d 00 00       	call   801070e0 <switchuvm>
801043b9:	31 c0                	xor    %eax,%eax
  return 0;
}
801043bb:	c9                   	leave  
801043bc:	c3                   	ret    
801043bd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801043c0:	01 c1                	add    %eax,%ecx
801043c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801043c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801043ca:	8b 42 04             	mov    0x4(%edx),%eax
801043cd:	89 04 24             	mov    %eax,(%esp)
801043d0:	e8 2b 2b 00 00       	call   80106f00 <allocuvm>
801043d5:	85 c0                	test   %eax,%eax
801043d7:	74 27                	je     80104400 <growproc+0x70>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801043d9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801043e0:	eb c7                	jmp    801043a9 <growproc+0x19>
801043e2:	01 c1                	add    %eax,%ecx
801043e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801043e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801043ec:	8b 42 04             	mov    0x4(%edx),%eax
801043ef:	89 04 24             	mov    %eax,(%esp)
801043f2:	e8 19 29 00 00       	call   80106d10 <deallocuvm>
801043f7:	85 c0                	test   %eax,%eax
801043f9:	75 de                	jne    801043d9 <growproc+0x49>
801043fb:	90                   	nop
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
80104400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104405:	c9                   	leave  
80104406:	c3                   	ret    
80104407:	89 f6                	mov    %esi,%esi
80104409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104410 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104417:	e8 44 fd ff ff       	call   80104160 <allocproc>
8010441c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010441e:	a3 c8 a5 10 80       	mov    %eax,0x8010a5c8
  if((p->pgdir = setupkvm()) == 0)
80104423:	e8 88 27 00 00       	call   80106bb0 <setupkvm>
80104428:	85 c0                	test   %eax,%eax
8010442a:	89 43 04             	mov    %eax,0x4(%ebx)
8010442d:	0f 84 ce 00 00 00    	je     80104501 <userinit+0xf1>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104433:	89 04 24             	mov    %eax,(%esp)
80104436:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010443d:	00 
8010443e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80104445:	80 
80104446:	e8 35 28 00 00       	call   80106c80 <inituvm>
  p->sz = PGSIZE;
8010444b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104451:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104458:	00 
80104459:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104460:	00 
80104461:	8b 43 18             	mov    0x18(%ebx),%eax
80104464:	89 04 24             	mov    %eax,(%esp)
80104467:	e8 04 04 00 00       	call   80104870 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010446c:	8b 43 18             	mov    0x18(%ebx),%eax
8010446f:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104475:	8b 43 18             	mov    0x18(%ebx),%eax
80104478:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010447e:	8b 43 18             	mov    0x18(%ebx),%eax
80104481:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104485:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104489:	8b 43 18             	mov    0x18(%ebx),%eax
8010448c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104490:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104494:	8b 43 18             	mov    0x18(%ebx),%eax
80104497:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010449e:	8b 43 18             	mov    0x18(%ebx),%eax
801044a1:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801044a8:	8b 43 18             	mov    0x18(%ebx),%eax
801044ab:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801044b2:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044b5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801044bc:	00 
801044bd:	c7 44 24 04 30 79 10 	movl   $0x80107930,0x4(%esp)
801044c4:	80 
801044c5:	89 04 24             	mov    %eax,(%esp)
801044c8:	e8 93 05 00 00       	call   80104a60 <safestrcpy>
  p->cwd = namei("/");
801044cd:	c7 04 24 39 79 10 80 	movl   $0x80107939,(%esp)
801044d4:	e8 e7 d9 ff ff       	call   80101ec0 <namei>
801044d9:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801044dc:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801044e3:	e8 e8 02 00 00       	call   801047d0 <acquire>

  p->state = RUNNABLE;
801044e8:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  //asign tickets here again ... 

  release(&ptable.lock);
801044ef:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801044f6:	e8 85 02 00 00       	call   80104780 <release>
}
801044fb:	83 c4 14             	add    $0x14,%esp
801044fe:	5b                   	pop    %ebx
801044ff:	5d                   	pop    %ebp
80104500:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80104501:	c7 04 24 17 79 10 80 	movl   $0x80107917,(%esp)
80104508:	e8 c3 be ff ff       	call   801003d0 <panic>
8010450d:	8d 76 00             	lea    0x0(%esi),%esi

80104510 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104516:	c7 44 24 04 3b 79 10 	movl   $0x8010793b,0x4(%esp)
8010451d:	80 
8010451e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104525:	e8 16 01 00 00       	call   80104640 <initlock>
}
8010452a:	c9                   	leave  
8010452b:	c3                   	ret    
8010452c:	00 00                	add    %al,(%eax)
	...

80104530 <holdingsleep>:
  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	83 ec 18             	sub    $0x18,%esp
80104536:	89 75 fc             	mov    %esi,-0x4(%ebp)
80104539:	8b 75 08             	mov    0x8(%ebp),%esi
8010453c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  int r;
  
  acquire(&lk->lk);
8010453f:	8d 5e 04             	lea    0x4(%esi),%ebx
80104542:	89 1c 24             	mov    %ebx,(%esp)
80104545:	e8 86 02 00 00       	call   801047d0 <acquire>
  r = lk->locked;
8010454a:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
8010454c:	89 1c 24             	mov    %ebx,(%esp)
8010454f:	e8 2c 02 00 00       	call   80104780 <release>
  return r;
}
80104554:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104557:	89 f0                	mov    %esi,%eax
80104559:	8b 75 fc             	mov    -0x4(%ebp),%esi
8010455c:	89 ec                	mov    %ebp,%esp
8010455e:	5d                   	pop    %ebp
8010455f:	c3                   	ret    

80104560 <releasesleep>:
  release(&lk->lk);
}

void
releasesleep(struct sleeplock *lk)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	83 ec 18             	sub    $0x18,%esp
80104566:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104569:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010456c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  acquire(&lk->lk);
8010456f:	8d 73 04             	lea    0x4(%ebx),%esi
80104572:	89 34 24             	mov    %esi,(%esp)
80104575:	e8 56 02 00 00       	call   801047d0 <acquire>
  lk->locked = 0;
8010457a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104580:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104587:	89 1c 24             	mov    %ebx,(%esp)
8010458a:	e8 91 f3 ff ff       	call   80103920 <wakeup>
  release(&lk->lk);
}
8010458f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104592:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104595:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104598:	89 ec                	mov    %ebp,%esp
8010459a:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
8010459b:	e9 e0 01 00 00       	jmp    80104780 <release>

801045a0 <acquiresleep>:
  lk->pid = 0;
}

void
acquiresleep(struct sleeplock *lk)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	83 ec 10             	sub    $0x10,%esp
801045a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045ab:	8d 73 04             	lea    0x4(%ebx),%esi
801045ae:	89 34 24             	mov    %esi,(%esp)
801045b1:	e8 1a 02 00 00       	call   801047d0 <acquire>
  while (lk->locked) {
801045b6:	8b 13                	mov    (%ebx),%edx
801045b8:	85 d2                	test   %edx,%edx
801045ba:	74 16                	je     801045d2 <acquiresleep+0x32>
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801045c0:	89 74 24 04          	mov    %esi,0x4(%esp)
801045c4:	89 1c 24             	mov    %ebx,(%esp)
801045c7:	e8 b4 f4 ff ff       	call   80103a80 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801045cc:	8b 03                	mov    (%ebx),%eax
801045ce:	85 c0                	test   %eax,%eax
801045d0:	75 ee                	jne    801045c0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801045d2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
801045d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045de:	8b 40 10             	mov    0x10(%eax),%eax
801045e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045e7:	83 c4 10             	add    $0x10,%esp
801045ea:	5b                   	pop    %ebx
801045eb:	5e                   	pop    %esi
801045ec:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
801045ed:	e9 8e 01 00 00       	jmp    80104780 <release>
801045f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	53                   	push   %ebx
80104604:	83 ec 14             	sub    $0x14,%esp
80104607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010460a:	c7 44 24 04 84 79 10 	movl   $0x80107984,0x4(%esp)
80104611:	80 
80104612:	8d 43 04             	lea    0x4(%ebx),%eax
80104615:	89 04 24             	mov    %eax,(%esp)
80104618:	e8 23 00 00 00       	call   80104640 <initlock>
  lk->name = name;
8010461d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104620:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104626:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010462d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104630:	83 c4 14             	add    $0x14,%esp
80104633:	5b                   	pop    %ebx
80104634:	5d                   	pop    %ebp
80104635:	c3                   	ret    
	...

80104640 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104646:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010464f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104652:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104659:	5d                   	pop    %ebp
8010465a:	c3                   	ret    
8010465b:	90                   	nop
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104660 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104660:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104661:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104663:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104665:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104668:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010466b:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010466c:	83 ea 08             	sub    $0x8,%edx
8010466f:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104670:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104676:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010467c:	77 1a                	ja     80104698 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010467e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104681:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104684:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104687:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104689:	83 f8 0a             	cmp    $0xa,%eax
8010468c:	75 e2                	jne    80104670 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010468e:	5b                   	pop    %ebx
8010468f:	5d                   	pop    %ebp
80104690:	c3                   	ret    
80104691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104698:	83 f8 09             	cmp    $0x9,%eax
8010469b:	7f f1                	jg     8010468e <getcallerpcs+0x2e>
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801046a0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801046a7:	83 c0 01             	add    $0x1,%eax
801046aa:	83 f8 0a             	cmp    $0xa,%eax
801046ad:	75 f1                	jne    801046a0 <getcallerpcs+0x40>
    pcs[i] = 0;
}
801046af:	5b                   	pop    %ebx
801046b0:	5d                   	pop    %ebp
801046b1:	c3                   	ret    
801046b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046c0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801046c0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
801046c1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801046c3:	89 e5                	mov    %esp,%ebp
801046c5:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
801046c8:	8b 0a                	mov    (%edx),%ecx
801046ca:	85 c9                	test   %ecx,%ecx
801046cc:	74 10                	je     801046de <holding+0x1e>
801046ce:	8b 42 08             	mov    0x8(%edx),%eax
801046d1:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
801046d8:	0f 94 c0             	sete   %al
801046db:	0f b6 c0             	movzbl %al,%eax
}
801046de:	5d                   	pop    %ebp
801046df:	c3                   	ret    

801046e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046e3:	9c                   	pushf  
801046e4:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801046e5:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801046e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801046ec:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801046f2:	85 d2                	test   %edx,%edx
801046f4:	75 18                	jne    8010470e <pushcli+0x2e>
    cpu->intena = eflags & FL_IF;
801046f6:	81 e1 00 02 00 00    	and    $0x200,%ecx
801046fc:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
80104702:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104708:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
  cpu->ncli += 1;
8010470e:	83 c2 01             	add    $0x1,%edx
80104711:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
80104717:	5d                   	pop    %ebp
80104718:	c3                   	ret    
80104719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104720 <popcli>:

void
popcli(void)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104726:	9c                   	pushf  
80104727:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104728:	f6 c4 02             	test   $0x2,%ah
8010472b:	75 43                	jne    80104770 <popcli+0x50>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010472d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104734:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010473a:	83 e8 01             	sub    $0x1,%eax
8010473d:	85 c0                	test   %eax,%eax
8010473f:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
80104745:	78 1d                	js     80104764 <popcli+0x44>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
80104747:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010474d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104753:	85 d2                	test   %edx,%edx
80104755:	75 0b                	jne    80104762 <popcli+0x42>
80104757:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010475d:	85 c0                	test   %eax,%eax
8010475f:	74 01                	je     80104762 <popcli+0x42>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104761:	fb                   	sti    
    sti();
}
80104762:	c9                   	leave  
80104763:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
80104764:	c7 04 24 a6 79 10 80 	movl   $0x801079a6,(%esp)
8010476b:	e8 60 bc ff ff       	call   801003d0 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104770:	c7 04 24 8f 79 10 80 	movl   $0x8010798f,(%esp)
80104777:	e8 54 bc ff ff       	call   801003d0 <panic>
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104780 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	83 ec 18             	sub    $0x18,%esp
80104786:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104789:	8b 08                	mov    (%eax),%ecx
8010478b:	85 c9                	test   %ecx,%ecx
8010478d:	74 0c                	je     8010479b <release+0x1b>
8010478f:	8b 50 08             	mov    0x8(%eax),%edx
80104792:	65 3b 15 00 00 00 00 	cmp    %gs:0x0,%edx
80104799:	74 0d                	je     801047a8 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010479b:	c7 04 24 ad 79 10 80 	movl   $0x801079ad,(%esp)
801047a2:	e8 29 bc ff ff       	call   801003d0 <panic>
801047a7:	90                   	nop

  lk->pcs[0] = 0;
801047a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801047af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801047b6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
801047c1:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801047c2:	e9 59 ff ff ff       	jmp    80104720 <popcli>
801047c7:	89 f6                	mov    %esi,%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047d0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047d6:	9c                   	pushf  
801047d7:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801047d8:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801047d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047df:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801047e5:	85 d2                	test   %edx,%edx
801047e7:	75 18                	jne    80104801 <acquire+0x31>
    cpu->intena = eflags & FL_IF;
801047e9:	81 e1 00 02 00 00    	and    $0x200,%ecx
801047ef:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
801047f5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047fb:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
  cpu->ncli += 1;
80104801:	83 c2 01             	add    $0x1,%edx
80104804:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
8010480a:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
8010480d:	8b 02                	mov    (%edx),%eax
8010480f:	85 c0                	test   %eax,%eax
80104811:	74 0c                	je     8010481f <acquire+0x4f>
80104813:	8b 42 08             	mov    0x8(%edx),%eax
80104816:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
8010481d:	74 41                	je     80104860 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010481f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104824:	eb 05                	jmp    8010482b <acquire+0x5b>
80104826:	66 90                	xchg   %ax,%ax
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104828:	8b 55 08             	mov    0x8(%ebp),%edx
8010482b:	89 c8                	mov    %ecx,%eax
8010482d:	f0 87 02             	lock xchg %eax,(%edx)
80104830:	85 c0                	test   %eax,%eax
80104832:	75 f4                	jne    80104828 <acquire+0x58>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104834:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104839:	8b 45 08             	mov    0x8(%ebp),%eax
8010483c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104843:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104846:	8b 45 08             	mov    0x8(%ebp),%eax
80104849:	83 c0 0c             	add    $0xc,%eax
8010484c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104850:	8d 45 08             	lea    0x8(%ebp),%eax
80104853:	89 04 24             	mov    %eax,(%esp)
80104856:	e8 05 fe ff ff       	call   80104660 <getcallerpcs>
}
8010485b:	c9                   	leave  
8010485c:	c3                   	ret    
8010485d:	8d 76 00             	lea    0x0(%esi),%esi
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104860:	c7 04 24 b5 79 10 80 	movl   $0x801079b5,(%esp)
80104867:	e8 64 bb ff ff       	call   801003d0 <panic>
8010486c:	00 00                	add    %al,(%eax)
	...

80104870 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	83 ec 08             	sub    $0x8,%esp
80104876:	8b 55 08             	mov    0x8(%ebp),%edx
80104879:	89 1c 24             	mov    %ebx,(%esp)
8010487c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010487f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104883:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104886:	f6 c2 03             	test   $0x3,%dl
80104889:	75 05                	jne    80104890 <memset+0x20>
8010488b:	f6 c1 03             	test   $0x3,%cl
8010488e:	74 18                	je     801048a8 <memset+0x38>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104890:	89 d7                	mov    %edx,%edi
80104892:	fc                   	cld    
80104893:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104895:	89 d0                	mov    %edx,%eax
80104897:	8b 1c 24             	mov    (%esp),%ebx
8010489a:	8b 7c 24 04          	mov    0x4(%esp),%edi
8010489e:	89 ec                	mov    %ebp,%esp
801048a0:	5d                   	pop    %ebp
801048a1:	c3                   	ret    
801048a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801048a8:	0f b6 f8             	movzbl %al,%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801048ab:	89 f8                	mov    %edi,%eax
801048ad:	89 fb                	mov    %edi,%ebx
801048af:	c1 e0 18             	shl    $0x18,%eax
801048b2:	c1 e3 10             	shl    $0x10,%ebx
801048b5:	09 d8                	or     %ebx,%eax
801048b7:	09 f8                	or     %edi,%eax
801048b9:	c1 e7 08             	shl    $0x8,%edi
801048bc:	09 f8                	or     %edi,%eax
801048be:	89 d7                	mov    %edx,%edi
801048c0:	c1 e9 02             	shr    $0x2,%ecx
801048c3:	fc                   	cld    
801048c4:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801048c6:	89 d0                	mov    %edx,%eax
801048c8:	8b 1c 24             	mov    (%esp),%ebx
801048cb:	8b 7c 24 04          	mov    0x4(%esp),%edi
801048cf:	89 ec                	mov    %ebp,%esp
801048d1:	5d                   	pop    %ebp
801048d2:	c3                   	ret    
801048d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	8b 55 10             	mov    0x10(%ebp),%edx
801048e6:	57                   	push   %edi
801048e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801048ea:	56                   	push   %esi
801048eb:	8b 75 08             	mov    0x8(%ebp),%esi
801048ee:	53                   	push   %ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048ef:	85 d2                	test   %edx,%edx
801048f1:	74 2d                	je     80104920 <memcmp+0x40>
    if(*s1 != *s2)
801048f3:	0f b6 1e             	movzbl (%esi),%ebx
801048f6:	0f b6 0f             	movzbl (%edi),%ecx
801048f9:	38 cb                	cmp    %cl,%bl
801048fb:	75 2b                	jne    80104928 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048fd:	83 ea 01             	sub    $0x1,%edx
80104900:	31 c0                	xor    %eax,%eax
80104902:	eb 18                	jmp    8010491c <memcmp+0x3c>
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s1 != *s2)
80104908:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
8010490d:	83 ea 01             	sub    $0x1,%edx
80104910:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
80104915:	83 c0 01             	add    $0x1,%eax
80104918:	38 cb                	cmp    %cl,%bl
8010491a:	75 0c                	jne    80104928 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010491c:	85 d2                	test   %edx,%edx
8010491e:	75 e8                	jne    80104908 <memcmp+0x28>
80104920:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104922:	5b                   	pop    %ebx
80104923:	5e                   	pop    %esi
80104924:	5f                   	pop    %edi
80104925:	5d                   	pop    %ebp
80104926:	c3                   	ret    
80104927:	90                   	nop

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104928:	0f b6 c3             	movzbl %bl,%eax
8010492b:	0f b6 c9             	movzbl %cl,%ecx
8010492e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104930:	5b                   	pop    %ebx
80104931:	5e                   	pop    %esi
80104932:	5f                   	pop    %edi
80104933:	5d                   	pop    %ebp
80104934:	c3                   	ret    
80104935:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	8b 45 08             	mov    0x8(%ebp),%eax
80104947:	56                   	push   %esi
80104948:	8b 75 0c             	mov    0xc(%ebp),%esi
8010494b:	53                   	push   %ebx
8010494c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010494f:	39 c6                	cmp    %eax,%esi
80104951:	73 2d                	jae    80104980 <memmove+0x40>
80104953:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
80104956:	39 f8                	cmp    %edi,%eax
80104958:	73 26                	jae    80104980 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
8010495a:	85 db                	test   %ebx,%ebx
8010495c:	74 1d                	je     8010497b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010495e:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80104961:	31 d2                	xor    %edx,%edx
80104963:	90                   	nop
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
80104968:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
8010496d:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
80104971:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104974:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80104977:	85 c9                	test   %ecx,%ecx
80104979:	75 ed                	jne    80104968 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010497b:	5b                   	pop    %ebx
8010497c:	5e                   	pop    %esi
8010497d:	5f                   	pop    %edi
8010497e:	5d                   	pop    %ebp
8010497f:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104980:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
80104982:	85 db                	test   %ebx,%ebx
80104984:	74 f5                	je     8010497b <memmove+0x3b>
80104986:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104988:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
8010498c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010498f:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104992:	39 d3                	cmp    %edx,%ebx
80104994:	75 f2                	jne    80104988 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
80104996:	5b                   	pop    %ebx
80104997:	5e                   	pop    %esi
80104998:	5f                   	pop    %edi
80104999:	5d                   	pop    %ebp
8010499a:	c3                   	ret    
8010499b:	90                   	nop
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801049a3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801049a4:	e9 97 ff ff ff       	jmp    80104940 <memmove>
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	8b 7d 10             	mov    0x10(%ebp),%edi
801049b7:	56                   	push   %esi
801049b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049bb:	53                   	push   %ebx
801049bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801049bf:	85 ff                	test   %edi,%edi
801049c1:	74 3d                	je     80104a00 <strncmp+0x50>
801049c3:	0f b6 01             	movzbl (%ecx),%eax
801049c6:	84 c0                	test   %al,%al
801049c8:	75 18                	jne    801049e2 <strncmp+0x32>
801049ca:	eb 3c                	jmp    80104a08 <strncmp+0x58>
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049d0:	83 ef 01             	sub    $0x1,%edi
801049d3:	74 2b                	je     80104a00 <strncmp+0x50>
    n--, p++, q++;
801049d5:	83 c1 01             	add    $0x1,%ecx
801049d8:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801049db:	0f b6 01             	movzbl (%ecx),%eax
801049de:	84 c0                	test   %al,%al
801049e0:	74 26                	je     80104a08 <strncmp+0x58>
801049e2:	0f b6 33             	movzbl (%ebx),%esi
801049e5:	89 f2                	mov    %esi,%edx
801049e7:	38 d0                	cmp    %dl,%al
801049e9:	74 e5                	je     801049d0 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049eb:	81 e6 ff 00 00 00    	and    $0xff,%esi
801049f1:	0f b6 c0             	movzbl %al,%eax
801049f4:	29 f0                	sub    %esi,%eax
}
801049f6:	5b                   	pop    %ebx
801049f7:	5e                   	pop    %esi
801049f8:	5f                   	pop    %edi
801049f9:	5d                   	pop    %ebp
801049fa:	c3                   	ret    
801049fb:	90                   	nop
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104a00:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104a02:	5b                   	pop    %ebx
80104a03:	5e                   	pop    %esi
80104a04:	5f                   	pop    %edi
80104a05:	5d                   	pop    %ebp
80104a06:	c3                   	ret    
80104a07:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104a08:	0f b6 33             	movzbl (%ebx),%esi
80104a0b:	eb de                	jmp    801049eb <strncmp+0x3b>
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi

80104a10 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	8b 45 08             	mov    0x8(%ebp),%eax
80104a16:	56                   	push   %esi
80104a17:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a1a:	53                   	push   %ebx
80104a1b:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a1e:	89 c3                	mov    %eax,%ebx
80104a20:	eb 09                	jmp    80104a2b <strncpy+0x1b>
80104a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a28:	83 c6 01             	add    $0x1,%esi
80104a2b:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
80104a2e:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a31:	85 d2                	test   %edx,%edx
80104a33:	7e 0c                	jle    80104a41 <strncpy+0x31>
80104a35:	0f b6 16             	movzbl (%esi),%edx
80104a38:	88 13                	mov    %dl,(%ebx)
80104a3a:	83 c3 01             	add    $0x1,%ebx
80104a3d:	84 d2                	test   %dl,%dl
80104a3f:	75 e7                	jne    80104a28 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
80104a41:	31 d2                	xor    %edx,%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104a43:	85 c9                	test   %ecx,%ecx
80104a45:	7e 0c                	jle    80104a53 <strncpy+0x43>
80104a47:	90                   	nop
    *s++ = 0;
80104a48:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
80104a4c:	83 c2 01             	add    $0x1,%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104a4f:	39 ca                	cmp    %ecx,%edx
80104a51:	75 f5                	jne    80104a48 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104a53:	5b                   	pop    %ebx
80104a54:	5e                   	pop    %esi
80104a55:	5d                   	pop    %ebp
80104a56:	c3                   	ret    
80104a57:	89 f6                	mov    %esi,%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	8b 55 10             	mov    0x10(%ebp),%edx
80104a66:	56                   	push   %esi
80104a67:	8b 45 08             	mov    0x8(%ebp),%eax
80104a6a:	53                   	push   %ebx
80104a6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;

  os = s;
  if(n <= 0)
80104a6e:	85 d2                	test   %edx,%edx
80104a70:	7e 1f                	jle    80104a91 <safestrcpy+0x31>
80104a72:	89 c1                	mov    %eax,%ecx
80104a74:	eb 05                	jmp    80104a7b <safestrcpy+0x1b>
80104a76:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a78:	83 c6 01             	add    $0x1,%esi
80104a7b:	83 ea 01             	sub    $0x1,%edx
80104a7e:	85 d2                	test   %edx,%edx
80104a80:	7e 0c                	jle    80104a8e <safestrcpy+0x2e>
80104a82:	0f b6 1e             	movzbl (%esi),%ebx
80104a85:	88 19                	mov    %bl,(%ecx)
80104a87:	83 c1 01             	add    $0x1,%ecx
80104a8a:	84 db                	test   %bl,%bl
80104a8c:	75 ea                	jne    80104a78 <safestrcpy+0x18>
    ;
  *s = 0;
80104a8e:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104a91:	5b                   	pop    %ebx
80104a92:	5e                   	pop    %esi
80104a93:	5d                   	pop    %ebp
80104a94:	c3                   	ret    
80104a95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <strlen>:

int
strlen(const char *s)
{
80104aa0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104aa1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104aa8:	80 3a 00             	cmpb   $0x0,(%edx)
80104aab:	74 0c                	je     80104ab9 <strlen+0x19>
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
80104ab0:	83 c0 01             	add    $0x1,%eax
80104ab3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ab7:	75 f7                	jne    80104ab0 <strlen+0x10>
    ;
  return n;
}
80104ab9:	5d                   	pop    %ebp
80104aba:	c3                   	ret    
	...

80104abc <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104abc:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104ac0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104ac4:	55                   	push   %ebp
  pushl %ebx
80104ac5:	53                   	push   %ebx
  pushl %esi
80104ac6:	56                   	push   %esi
  pushl %edi
80104ac7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ac8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104aca:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104acc:	5f                   	pop    %edi
  popl %esi
80104acd:	5e                   	pop    %esi
  popl %ebx
80104ace:	5b                   	pop    %ebx
  popl %ebp
80104acf:	5d                   	pop    %ebp
  ret
80104ad0:	c3                   	ret    
	...

80104ae0 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104ae0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ae7:	55                   	push   %ebp
80104ae8:	89 e5                	mov    %esp,%ebp
80104aea:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
80104aed:	8b 12                	mov    (%edx),%edx
80104aef:	39 c2                	cmp    %eax,%edx
80104af1:	77 0d                	ja     80104b00 <fetchint+0x20>
    return -1;
  *ip = *(int*)(addr);
  return 0;
80104af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104af8:	5d                   	pop    %ebp
80104af9:	c3                   	ret    
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104b00:	8d 48 04             	lea    0x4(%eax),%ecx
80104b03:	39 ca                	cmp    %ecx,%edx
80104b05:	72 ec                	jb     80104af3 <fetchint+0x13>
    return -1;
  *ip = *(int*)(addr);
80104b07:	8b 10                	mov    (%eax),%edx
80104b09:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b0c:	89 10                	mov    %edx,(%eax)
80104b0e:	31 c0                	xor    %eax,%eax
  return 0;
}
80104b10:	5d                   	pop    %ebp
80104b11:	c3                   	ret    
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104b20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b26:	55                   	push   %ebp
80104b27:	89 e5                	mov    %esp,%ebp
80104b29:	8b 55 08             	mov    0x8(%ebp),%edx
80104b2c:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= proc->sz)
80104b2d:	39 10                	cmp    %edx,(%eax)
80104b2f:	77 0f                	ja     80104b40 <fetchstr+0x20>
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104b31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104b36:	5b                   	pop    %ebx
80104b37:	5d                   	pop    %ebp
80104b38:	c3                   	ret    
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
80104b40:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b43:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80104b45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b4b:	8b 18                	mov    (%eax),%ebx
  for(s = *pp; s < ep; s++)
80104b4d:	39 da                	cmp    %ebx,%edx
80104b4f:	73 e0                	jae    80104b31 <fetchstr+0x11>
    if(*s == 0)
80104b51:	31 c0                	xor    %eax,%eax
80104b53:	89 d1                	mov    %edx,%ecx
80104b55:	80 3a 00             	cmpb   $0x0,(%edx)
80104b58:	74 dc                	je     80104b36 <fetchstr+0x16>
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104b60:	83 c1 01             	add    $0x1,%ecx
80104b63:	39 cb                	cmp    %ecx,%ebx
80104b65:	76 ca                	jbe    80104b31 <fetchstr+0x11>
    if(*s == 0)
80104b67:	80 39 00             	cmpb   $0x0,(%ecx)
80104b6a:	75 f4                	jne    80104b60 <fetchstr+0x40>
80104b6c:	89 c8                	mov    %ecx,%eax
80104b6e:	29 d0                	sub    %edx,%eax
80104b70:	eb c4                	jmp    80104b36 <fetchstr+0x16>
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104b80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b86:	55                   	push   %ebp
80104b87:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104b89:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b8c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104b8f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104b91:	8b 52 44             	mov    0x44(%edx),%edx
80104b94:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104b98:	39 c2                	cmp    %eax,%edx
80104b9a:	72 0c                	jb     80104ba8 <argint+0x28>
    return -1;
  *ip = *(int*)(addr);
80104b9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104ba1:	5d                   	pop    %ebp
80104ba2:	c3                   	ret    
80104ba3:	90                   	nop
80104ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104ba8:	8d 4a 04             	lea    0x4(%edx),%ecx
80104bab:	39 c8                	cmp    %ecx,%eax
80104bad:	72 ed                	jb     80104b9c <argint+0x1c>
    return -1;
  *ip = *(int*)(addr);
80104baf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bb2:	8b 12                	mov    (%edx),%edx
80104bb4:	89 10                	mov    %edx,(%eax)
80104bb6:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104bb8:	5d                   	pop    %ebp
80104bb9:	c3                   	ret    
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104bc0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bc6:	55                   	push   %ebp
80104bc7:	89 e5                	mov    %esp,%ebp
80104bc9:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104bca:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bcd:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104bd0:	8b 00                	mov    (%eax),%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bd2:	8b 5d 10             	mov    0x10(%ebp),%ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104bd5:	8b 52 44             	mov    0x44(%edx),%edx
80104bd8:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104bdc:	39 c2                	cmp    %eax,%edx
80104bde:	73 07                	jae    80104be7 <argptr+0x27>
80104be0:	8d 4a 04             	lea    0x4(%edx),%ecx
80104be3:	39 c8                	cmp    %ecx,%eax
80104be5:	73 09                	jae    80104bf0 <argptr+0x30>
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
80104be7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bec:	5b                   	pop    %ebx
80104bed:	5d                   	pop    %ebp
80104bee:	c3                   	ret    
80104bef:	90                   	nop
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104bf0:	85 db                	test   %ebx,%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104bf2:	8b 12                	mov    (%edx),%edx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104bf4:	78 f1                	js     80104be7 <argptr+0x27>
80104bf6:	39 c2                	cmp    %eax,%edx
80104bf8:	73 ed                	jae    80104be7 <argptr+0x27>
80104bfa:	8d 1c 1a             	lea    (%edx,%ebx,1),%ebx
80104bfd:	39 c3                	cmp    %eax,%ebx
80104bff:	77 e6                	ja     80104be7 <argptr+0x27>
    return -1;
  *pp = (char*)i;
80104c01:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c04:	89 10                	mov    %edx,(%eax)
80104c06:	31 c0                	xor    %eax,%eax
  return 0;
80104c08:	eb e2                	jmp    80104bec <argptr+0x2c>
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c10 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104c10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c16:	55                   	push   %ebp
80104c17:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104c19:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c1c:	8b 50 18             	mov    0x18(%eax),%edx
80104c1f:	8b 52 44             	mov    0x44(%edx),%edx
80104c22:	8d 4c 8a 04          	lea    0x4(%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104c26:	8b 10                	mov    (%eax),%edx
80104c28:	39 d1                	cmp    %edx,%ecx
80104c2a:	73 07                	jae    80104c33 <argstr+0x23>
80104c2c:	8d 41 04             	lea    0x4(%ecx),%eax
80104c2f:	39 c2                	cmp    %eax,%edx
80104c31:	73 0d                	jae    80104c40 <argstr+0x30>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104c33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c38:	5d                   	pop    %ebp
80104c39:	c3                   	ret    
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104c40:	8b 09                	mov    (%ecx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104c42:	39 d1                	cmp    %edx,%ecx
80104c44:	73 ed                	jae    80104c33 <argstr+0x23>
    return -1;
  *pp = (char*)addr;
80104c46:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c49:	89 c8                	mov    %ecx,%eax
80104c4b:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104c4d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c54:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104c56:	39 d1                	cmp    %edx,%ecx
80104c58:	73 d9                	jae    80104c33 <argstr+0x23>
    if(*s == 0)
80104c5a:	80 39 00             	cmpb   $0x0,(%ecx)
80104c5d:	75 13                	jne    80104c72 <argstr+0x62>
80104c5f:	eb 1f                	jmp    80104c80 <argstr+0x70>
80104c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c68:	80 38 00             	cmpb   $0x0,(%eax)
80104c6b:	90                   	nop
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c70:	74 0e                	je     80104c80 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104c72:	83 c0 01             	add    $0x1,%eax
80104c75:	39 c2                	cmp    %eax,%edx
80104c77:	77 ef                	ja     80104c68 <argstr+0x58>
80104c79:	eb b8                	jmp    80104c33 <argstr+0x23>
80104c7b:	90                   	nop
80104c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
80104c80:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c82:	5d                   	pop    %ebp
80104c83:	c3                   	ret    
80104c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c90 <syscall>:
[SYS_set_tickets]   sys_set_tickets,//CS 202
};

void
syscall(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80104c97:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c9e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104ca1:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ca4:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104ca7:	83 f9 15             	cmp    $0x15,%ecx
80104caa:	77 1c                	ja     80104cc8 <syscall+0x38>
80104cac:	8b 0c 85 e0 79 10 80 	mov    -0x7fef8620(,%eax,4),%ecx
80104cb3:	85 c9                	test   %ecx,%ecx
80104cb5:	74 11                	je     80104cc8 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104cb7:	ff d1                	call   *%ecx
80104cb9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80104cbc:	83 c4 14             	add    $0x14,%esp
80104cbf:	5b                   	pop    %ebx
80104cc0:	5d                   	pop    %ebp
80104cc1:	c3                   	ret    
80104cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104cc8:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104ccc:	8d 42 6c             	lea    0x6c(%edx),%eax
80104ccf:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cd3:	8b 42 10             	mov    0x10(%edx),%eax
80104cd6:	c7 04 24 bd 79 10 80 	movl   $0x801079bd,(%esp)
80104cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ce1:	e8 8a bb ff ff       	call   80100870 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104ce6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cec:	8b 40 18             	mov    0x18(%eax),%eax
80104cef:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104cf6:	83 c4 14             	add    $0x14,%esp
80104cf9:	5b                   	pop    %ebx
80104cfa:	5d                   	pop    %ebp
80104cfb:	c3                   	ret    
80104cfc:	00 00                	add    %al,(%eax)
	...

80104d00 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104d06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80104d09:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104d0c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104d0f:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80104d16:	00 
80104d17:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d22:	e8 99 fe ff ff       	call   80104bc0 <argptr>
80104d27:	85 c0                	test   %eax,%eax
80104d29:	79 15                	jns    80104d40 <sys_pipe+0x40>
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80104d2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80104d30:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104d33:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104d36:	89 ec                	mov    %ebp,%esp
80104d38:	5d                   	pop    %ebp
80104d39:	c3                   	ret    
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104d40:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104d43:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d47:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d4a:	89 04 24             	mov    %eax,(%esp)
80104d4d:	e8 ce e8 ff ff       	call   80103620 <pipealloc>
80104d52:	85 c0                	test   %eax,%eax
80104d54:	78 d5                	js     80104d2b <sys_pipe+0x2b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104d56:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80104d59:	31 c0                	xor    %eax,%eax
80104d5b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80104d68:	8b 5c 82 28          	mov    0x28(%edx,%eax,4),%ebx
80104d6c:	85 db                	test   %ebx,%ebx
80104d6e:	74 28                	je     80104d98 <sys_pipe+0x98>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104d70:	83 c0 01             	add    $0x1,%eax
80104d73:	83 f8 10             	cmp    $0x10,%eax
80104d76:	75 f0                	jne    80104d68 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
80104d78:	89 0c 24             	mov    %ecx,(%esp)
80104d7b:	e8 e0 c2 ff ff       	call   80101060 <fileclose>
    fileclose(wf);
80104d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d83:	89 04 24             	mov    %eax,(%esp)
80104d86:	e8 d5 c2 ff ff       	call   80101060 <fileclose>
80104d8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
80104d90:	eb 9e                	jmp    80104d30 <sys_pipe+0x30>
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104d98:	8d 58 08             	lea    0x8(%eax),%ebx
80104d9b:	89 4c 9a 08          	mov    %ecx,0x8(%edx,%ebx,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104d9f:	8b 75 ec             	mov    -0x14(%ebp),%esi
80104da2:	31 d2                	xor    %edx,%edx
80104da4:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80104dab:	90                   	nop
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80104db0:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
80104db5:	74 19                	je     80104dd0 <sys_pipe+0xd0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104db7:	83 c2 01             	add    $0x1,%edx
80104dba:	83 fa 10             	cmp    $0x10,%edx
80104dbd:	75 f1                	jne    80104db0 <sys_pipe+0xb0>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
80104dbf:	c7 44 99 08 00 00 00 	movl   $0x0,0x8(%ecx,%ebx,4)
80104dc6:	00 
80104dc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80104dca:	eb ac                	jmp    80104d78 <sys_pipe+0x78>
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104dd0:	89 74 91 28          	mov    %esi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104dd4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104dd7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80104dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ddc:	89 50 04             	mov    %edx,0x4(%eax)
80104ddf:	31 c0                	xor    %eax,%eax
  return 0;
80104de1:	e9 4a ff ff ff       	jmp    80104d30 <sys_pipe+0x30>
80104de6:	8d 76 00             	lea    0x0(%esi),%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	81 ec b8 00 00 00    	sub    $0xb8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104df9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80104dfc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80104dff:	89 75 f8             	mov    %esi,-0x8(%ebp)
80104e02:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104e05:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e10:	e8 fb fd ff ff       	call   80104c10 <argstr>
80104e15:	85 c0                	test   %eax,%eax
80104e17:	79 17                	jns    80104e30 <sys_exec+0x40>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
80104e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80104e1e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104e21:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104e24:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104e27:	89 ec                	mov    %ebp,%esp
80104e29:	5d                   	pop    %ebp
80104e2a:	c3                   	ret    
80104e2b:	90                   	nop
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104e30:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104e33:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e3e:	e8 3d fd ff ff       	call   80104b80 <argint>
80104e43:	85 c0                	test   %eax,%eax
80104e45:	78 d2                	js     80104e19 <sys_exec+0x29>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104e47:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
80104e4d:	31 f6                	xor    %esi,%esi
80104e4f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80104e56:	00 
80104e57:	31 db                	xor    %ebx,%ebx
80104e59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104e60:	00 
80104e61:	89 3c 24             	mov    %edi,(%esp)
80104e64:	e8 07 fa ff ff       	call   80104870 <memset>
80104e69:	eb 22                	jmp    80104e8d <sys_exec+0x9d>
80104e6b:	90                   	nop
80104e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104e70:	8d 14 b7             	lea    (%edi,%esi,4),%edx
80104e73:	89 54 24 04          	mov    %edx,0x4(%esp)
80104e77:	89 04 24             	mov    %eax,(%esp)
80104e7a:	e8 a1 fc ff ff       	call   80104b20 <fetchstr>
80104e7f:	85 c0                	test   %eax,%eax
80104e81:	78 96                	js     80104e19 <sys_exec+0x29>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80104e83:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80104e86:	83 fb 20             	cmp    $0x20,%ebx

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80104e89:	89 de                	mov    %ebx,%esi
    if(i >= NELEM(argv))
80104e8b:	74 8c                	je     80104e19 <sys_exec+0x29>
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104e8d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80104e90:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e94:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
80104e9b:	03 45 e0             	add    -0x20(%ebp),%eax
80104e9e:	89 04 24             	mov    %eax,(%esp)
80104ea1:	e8 3a fc ff ff       	call   80104ae0 <fetchint>
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	0f 88 6b ff ff ff    	js     80104e19 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
80104eae:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104eb1:	85 c0                	test   %eax,%eax
80104eb3:	75 bb                	jne    80104e70 <sys_exec+0x80>
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104eb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104eb8:	c7 84 9d 5c ff ff ff 	movl   $0x0,-0xa4(%ebp,%ebx,4)
80104ebf:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104ec3:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104ec7:	89 04 24             	mov    %eax,(%esp)
80104eca:	e8 11 bb ff ff       	call   801009e0 <exec>
80104ecf:	e9 4a ff ff ff       	jmp    80104e1e <sys_exec+0x2e>
80104ed4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104eda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ee0 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	53                   	push   %ebx
80104ee4:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104ee7:	e8 c4 de ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104eec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eef:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ef3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104efa:	e8 11 fd ff ff       	call   80104c10 <argstr>
80104eff:	85 c0                	test   %eax,%eax
80104f01:	78 5d                	js     80104f60 <sys_chdir+0x80>
80104f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f06:	89 04 24             	mov    %eax,(%esp)
80104f09:	e8 b2 cf ff ff       	call   80101ec0 <namei>
80104f0e:	85 c0                	test   %eax,%eax
80104f10:	89 c3                	mov    %eax,%ebx
80104f12:	74 4c                	je     80104f60 <sys_chdir+0x80>
    end_op();
    return -1;
  }
  ilock(ip);
80104f14:	89 04 24             	mov    %eax,(%esp)
80104f17:	e8 44 cd ff ff       	call   80101c60 <ilock>
  if(ip->type != T_DIR){
80104f1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f21:	75 35                	jne    80104f58 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f23:	89 1c 24             	mov    %ebx,(%esp)
80104f26:	e8 c5 cc ff ff       	call   80101bf0 <iunlock>
  iput(proc->cwd);
80104f2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f31:	8b 40 68             	mov    0x68(%eax),%eax
80104f34:	89 04 24             	mov    %eax,(%esp)
80104f37:	e8 f4 c4 ff ff       	call   80101430 <iput>
  end_op();
80104f3c:	e8 3f dd ff ff       	call   80102c80 <end_op>
  proc->cwd = ip;
80104f41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f47:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
80104f4a:	83 c4 24             	add    $0x24,%esp
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
80104f4d:	31 c0                	xor    %eax,%eax
  return 0;
}
80104f4f:	5b                   	pop    %ebx
80104f50:	5d                   	pop    %ebp
80104f51:	c3                   	ret    
80104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80104f58:	89 1c 24             	mov    %ebx,(%esp)
80104f5b:	e8 e0 cc ff ff       	call   80101c40 <iunlockput>
    end_op();
80104f60:	e8 1b dd ff ff       	call   80102c80 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80104f65:	83 c4 24             	add    $0x24,%esp
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80104f6d:	5b                   	pop    %ebx
80104f6e:	5d                   	pop    %ebp
80104f6f:	c3                   	ret    

80104f70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	83 ec 58             	sub    $0x58,%esp
80104f76:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80104f79:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f7f:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f85:	31 db                	xor    %ebx,%ebx
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f87:	89 7d fc             	mov    %edi,-0x4(%ebp)
80104f8a:	89 d7                	mov    %edx,%edi
80104f8c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f8f:	89 74 24 04          	mov    %esi,0x4(%esp)
80104f93:	89 04 24             	mov    %eax,(%esp)
80104f96:	e8 05 cf ff ff       	call   80101ea0 <nameiparent>
80104f9b:	85 c0                	test   %eax,%eax
80104f9d:	74 47                	je     80104fe6 <create+0x76>
    return 0;
  ilock(dp);
80104f9f:	89 04 24             	mov    %eax,(%esp)
80104fa2:	89 45 bc             	mov    %eax,-0x44(%ebp)
80104fa5:	e8 b6 cc ff ff       	call   80101c60 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104faa:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104fad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104fb0:	89 44 24 08          	mov    %eax,0x8(%esp)
80104fb4:	89 74 24 04          	mov    %esi,0x4(%esp)
80104fb8:	89 14 24             	mov    %edx,(%esp)
80104fbb:	e8 c0 c9 ff ff       	call   80101980 <dirlookup>
80104fc0:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104fc3:	85 c0                	test   %eax,%eax
80104fc5:	89 c3                	mov    %eax,%ebx
80104fc7:	74 4f                	je     80105018 <create+0xa8>
    iunlockput(dp);
80104fc9:	89 14 24             	mov    %edx,(%esp)
80104fcc:	e8 6f cc ff ff       	call   80101c40 <iunlockput>
    ilock(ip);
80104fd1:	89 1c 24             	mov    %ebx,(%esp)
80104fd4:	e8 87 cc ff ff       	call   80101c60 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104fd9:	66 83 ff 02          	cmp    $0x2,%di
80104fdd:	75 19                	jne    80104ff8 <create+0x88>
80104fdf:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104fe4:	75 12                	jne    80104ff8 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104fe6:	89 d8                	mov    %ebx,%eax
80104fe8:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104feb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104fee:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104ff1:	89 ec                	mov    %ebp,%esp
80104ff3:	5d                   	pop    %ebp
80104ff4:	c3                   	ret    
80104ff5:	8d 76 00             	lea    0x0(%esi),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104ff8:	89 1c 24             	mov    %ebx,(%esp)
80104ffb:	31 db                	xor    %ebx,%ebx
80104ffd:	e8 3e cc ff ff       	call   80101c40 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105002:	89 d8                	mov    %ebx,%eax
80105004:	8b 75 f8             	mov    -0x8(%ebp),%esi
80105007:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010500a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010500d:	89 ec                	mov    %ebp,%esp
8010500f:	5d                   	pop    %ebp
80105010:	c3                   	ret    
80105011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105018:	0f bf c7             	movswl %di,%eax
8010501b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010501f:	8b 02                	mov    (%edx),%eax
80105021:	89 55 bc             	mov    %edx,-0x44(%ebp)
80105024:	89 04 24             	mov    %eax,(%esp)
80105027:	e8 f4 ca ff ff       	call   80101b20 <ialloc>
8010502c:	8b 55 bc             	mov    -0x44(%ebp),%edx
8010502f:	85 c0                	test   %eax,%eax
80105031:	89 c3                	mov    %eax,%ebx
80105033:	0f 84 cb 00 00 00    	je     80105104 <create+0x194>
    panic("create: ialloc");

  ilock(ip);
80105039:	89 55 bc             	mov    %edx,-0x44(%ebp)
8010503c:	89 04 24             	mov    %eax,(%esp)
8010503f:	e8 1c cc ff ff       	call   80101c60 <ilock>
  ip->major = major;
80105044:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
80105048:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010504c:	0f b7 4d c0          	movzwl -0x40(%ebp),%ecx
  ip->nlink = 1;
80105050:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
80105056:	66 89 4b 54          	mov    %cx,0x54(%ebx)
  ip->nlink = 1;
  iupdate(ip);
8010505a:	89 1c 24             	mov    %ebx,(%esp)
8010505d:	e8 4e c2 ff ff       	call   801012b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105062:	66 83 ff 01          	cmp    $0x1,%di
80105066:	8b 55 bc             	mov    -0x44(%ebp),%edx
80105069:	74 3d                	je     801050a8 <create+0x138>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010506b:	8b 43 04             	mov    0x4(%ebx),%eax
8010506e:	89 14 24             	mov    %edx,(%esp)
80105071:	89 55 bc             	mov    %edx,-0x44(%ebp)
80105074:	89 74 24 04          	mov    %esi,0x4(%esp)
80105078:	89 44 24 08          	mov    %eax,0x8(%esp)
8010507c:	e8 af c9 ff ff       	call   80101a30 <dirlink>
80105081:	8b 55 bc             	mov    -0x44(%ebp),%edx
80105084:	85 c0                	test   %eax,%eax
80105086:	0f 88 84 00 00 00    	js     80105110 <create+0x1a0>
    panic("create: dirlink");

  iunlockput(dp);
8010508c:	89 14 24             	mov    %edx,(%esp)
8010508f:	e8 ac cb ff ff       	call   80101c40 <iunlockput>

  return ip;
}
80105094:	89 d8                	mov    %ebx,%eax
80105096:	8b 75 f8             	mov    -0x8(%ebp),%esi
80105099:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010509c:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010509f:	89 ec                	mov    %ebp,%esp
801050a1:	5d                   	pop    %ebp
801050a2:	c3                   	ret    
801050a3:	90                   	nop
801050a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801050a8:	66 83 42 56 01       	addw   $0x1,0x56(%edx)
    iupdate(dp);
801050ad:	89 14 24             	mov    %edx,(%esp)
801050b0:	89 55 bc             	mov    %edx,-0x44(%ebp)
801050b3:	e8 f8 c1 ff ff       	call   801012b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050b8:	8b 43 04             	mov    0x4(%ebx),%eax
801050bb:	c7 44 24 04 4c 7a 10 	movl   $0x80107a4c,0x4(%esp)
801050c2:	80 
801050c3:	89 1c 24             	mov    %ebx,(%esp)
801050c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801050ca:	e8 61 c9 ff ff       	call   80101a30 <dirlink>
801050cf:	8b 55 bc             	mov    -0x44(%ebp),%edx
801050d2:	85 c0                	test   %eax,%eax
801050d4:	78 22                	js     801050f8 <create+0x188>
801050d6:	8b 42 04             	mov    0x4(%edx),%eax
801050d9:	c7 44 24 04 4b 7a 10 	movl   $0x80107a4b,0x4(%esp)
801050e0:	80 
801050e1:	89 1c 24             	mov    %ebx,(%esp)
801050e4:	89 44 24 08          	mov    %eax,0x8(%esp)
801050e8:	e8 43 c9 ff ff       	call   80101a30 <dirlink>
801050ed:	8b 55 bc             	mov    -0x44(%ebp),%edx
801050f0:	85 c0                	test   %eax,%eax
801050f2:	0f 89 73 ff ff ff    	jns    8010506b <create+0xfb>
      panic("create dots");
801050f8:	c7 04 24 4e 7a 10 80 	movl   $0x80107a4e,(%esp)
801050ff:	e8 cc b2 ff ff       	call   801003d0 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105104:	c7 04 24 3c 7a 10 80 	movl   $0x80107a3c,(%esp)
8010510b:	e8 c0 b2 ff ff       	call   801003d0 <panic>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80105110:	c7 04 24 5a 7a 10 80 	movl   $0x80107a5a,(%esp)
80105117:	e8 b4 b2 ff ff       	call   801003d0 <panic>
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <sys_mknod>:
  return 0;
}

int
sys_mknod(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105126:	e8 85 dc ff ff       	call   80102db0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010512b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010512e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105132:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105139:	e8 d2 fa ff ff       	call   80104c10 <argstr>
8010513e:	85 c0                	test   %eax,%eax
80105140:	78 5e                	js     801051a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105142:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105145:	89 44 24 04          	mov    %eax,0x4(%esp)
80105149:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105150:	e8 2b fa ff ff       	call   80104b80 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105155:	85 c0                	test   %eax,%eax
80105157:	78 47                	js     801051a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105159:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010515c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105160:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105167:	e8 14 fa ff ff       	call   80104b80 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010516c:	85 c0                	test   %eax,%eax
8010516e:	78 30                	js     801051a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105170:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80105174:	ba 03 00 00 00       	mov    $0x3,%edx
80105179:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010517d:	89 04 24             	mov    %eax,(%esp)
80105180:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105183:	e8 e8 fd ff ff       	call   80104f70 <create>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105188:	85 c0                	test   %eax,%eax
8010518a:	74 14                	je     801051a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010518c:	89 04 24             	mov    %eax,(%esp)
8010518f:	e8 ac ca ff ff       	call   80101c40 <iunlockput>
  end_op();
80105194:	e8 e7 da ff ff       	call   80102c80 <end_op>
80105199:	31 c0                	xor    %eax,%eax
  return 0;
}
8010519b:	c9                   	leave  
8010519c:	c3                   	ret    
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801051a0:	e8 db da ff ff       	call   80102c80 <end_op>
801051a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801051aa:	c9                   	leave  
801051ab:	c3                   	ret    
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051b0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051b6:	e8 f5 db ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051be:	89 44 24 04          	mov    %eax,0x4(%esp)
801051c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051c9:	e8 42 fa ff ff       	call   80104c10 <argstr>
801051ce:	85 c0                	test   %eax,%eax
801051d0:	78 2e                	js     80105200 <sys_mkdir+0x50>
801051d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d5:	31 c9                	xor    %ecx,%ecx
801051d7:	ba 01 00 00 00       	mov    $0x1,%edx
801051dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051e3:	e8 88 fd ff ff       	call   80104f70 <create>
801051e8:	85 c0                	test   %eax,%eax
801051ea:	74 14                	je     80105200 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051ec:	89 04 24             	mov    %eax,(%esp)
801051ef:	e8 4c ca ff ff       	call   80101c40 <iunlockput>
  end_op();
801051f4:	e8 87 da ff ff       	call   80102c80 <end_op>
801051f9:	31 c0                	xor    %eax,%eax
  return 0;
}
801051fb:	c9                   	leave  
801051fc:	c3                   	ret    
801051fd:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105200:	e8 7b da ff ff       	call   80102c80 <end_op>
80105205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010520a:	c9                   	leave  
8010520b:	c3                   	ret    
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105210 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105216:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105219:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010521c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010521f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105222:	89 44 24 04          	mov    %eax,0x4(%esp)
80105226:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010522d:	e8 de f9 ff ff       	call   80104c10 <argstr>
80105232:	85 c0                	test   %eax,%eax
80105234:	79 12                	jns    80105248 <sys_link+0x38>
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80105236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010523b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010523e:	8b 75 f8             	mov    -0x8(%ebp),%esi
80105241:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105244:	89 ec                	mov    %ebp,%esp
80105246:	5d                   	pop    %ebp
80105247:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105248:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010524b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010524f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105256:	e8 b5 f9 ff ff       	call   80104c10 <argstr>
8010525b:	85 c0                	test   %eax,%eax
8010525d:	78 d7                	js     80105236 <sys_link+0x26>
    return -1;

  begin_op();
8010525f:	e8 4c db ff ff       	call   80102db0 <begin_op>
  if((ip = namei(old)) == 0){
80105264:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105267:	89 04 24             	mov    %eax,(%esp)
8010526a:	e8 51 cc ff ff       	call   80101ec0 <namei>
8010526f:	85 c0                	test   %eax,%eax
80105271:	89 c3                	mov    %eax,%ebx
80105273:	0f 84 a6 00 00 00    	je     8010531f <sys_link+0x10f>
    end_op();
    return -1;
  }

  ilock(ip);
80105279:	89 04 24             	mov    %eax,(%esp)
8010527c:	e8 df c9 ff ff       	call   80101c60 <ilock>
  if(ip->type == T_DIR){
80105281:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105286:	0f 84 8b 00 00 00    	je     80105317 <sys_link+0x107>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010528c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105291:	8d 7d d2             	lea    -0x2e(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105294:	89 1c 24             	mov    %ebx,(%esp)
80105297:	e8 14 c0 ff ff       	call   801012b0 <iupdate>
  iunlock(ip);
8010529c:	89 1c 24             	mov    %ebx,(%esp)
8010529f:	e8 4c c9 ff ff       	call   80101bf0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801052a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801052a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
801052ab:	89 04 24             	mov    %eax,(%esp)
801052ae:	e8 ed cb ff ff       	call   80101ea0 <nameiparent>
801052b3:	85 c0                	test   %eax,%eax
801052b5:	89 c6                	mov    %eax,%esi
801052b7:	74 49                	je     80105302 <sys_link+0xf2>
    goto bad;
  ilock(dp);
801052b9:	89 04 24             	mov    %eax,(%esp)
801052bc:	e8 9f c9 ff ff       	call   80101c60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052c1:	8b 06                	mov    (%esi),%eax
801052c3:	3b 03                	cmp    (%ebx),%eax
801052c5:	75 33                	jne    801052fa <sys_link+0xea>
801052c7:	8b 43 04             	mov    0x4(%ebx),%eax
801052ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
801052ce:	89 34 24             	mov    %esi,(%esp)
801052d1:	89 44 24 08          	mov    %eax,0x8(%esp)
801052d5:	e8 56 c7 ff ff       	call   80101a30 <dirlink>
801052da:	85 c0                	test   %eax,%eax
801052dc:	78 1c                	js     801052fa <sys_link+0xea>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801052de:	89 34 24             	mov    %esi,(%esp)
801052e1:	e8 5a c9 ff ff       	call   80101c40 <iunlockput>
  iput(ip);
801052e6:	89 1c 24             	mov    %ebx,(%esp)
801052e9:	e8 42 c1 ff ff       	call   80101430 <iput>

  end_op();
801052ee:	e8 8d d9 ff ff       	call   80102c80 <end_op>
801052f3:	31 c0                	xor    %eax,%eax

  return 0;
801052f5:	e9 41 ff ff ff       	jmp    8010523b <sys_link+0x2b>

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
801052fa:	89 34 24             	mov    %esi,(%esp)
801052fd:	e8 3e c9 ff ff       	call   80101c40 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80105302:	89 1c 24             	mov    %ebx,(%esp)
80105305:	e8 56 c9 ff ff       	call   80101c60 <ilock>
  ip->nlink--;
8010530a:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010530f:	89 1c 24             	mov    %ebx,(%esp)
80105312:	e8 99 bf ff ff       	call   801012b0 <iupdate>
  iunlockput(ip);
80105317:	89 1c 24             	mov    %ebx,(%esp)
8010531a:	e8 21 c9 ff ff       	call   80101c40 <iunlockput>
  end_op();
8010531f:	e8 5c d9 ff ff       	call   80102c80 <end_op>
80105324:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
80105329:	e9 0d ff ff ff       	jmp    8010523b <sys_link+0x2b>
8010532e:	66 90                	xchg   %ax,%ax

80105330 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105336:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105339:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010533c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010533f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105343:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010534a:	e8 c1 f8 ff ff       	call   80104c10 <argstr>
8010534f:	85 c0                	test   %eax,%eax
80105351:	79 15                	jns    80105368 <sys_open+0x38>
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105353:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105358:	8b 5d f8             	mov    -0x8(%ebp),%ebx
8010535b:	8b 75 fc             	mov    -0x4(%ebp),%esi
8010535e:	89 ec                	mov    %ebp,%esp
80105360:	5d                   	pop    %ebp
80105361:	c3                   	ret    
80105362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105368:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010536b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010536f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105376:	e8 05 f8 ff ff       	call   80104b80 <argint>
8010537b:	85 c0                	test   %eax,%eax
8010537d:	78 d4                	js     80105353 <sys_open+0x23>
    return -1;

  begin_op();
8010537f:	e8 2c da ff ff       	call   80102db0 <begin_op>

  if(omode & O_CREATE){
80105384:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
80105388:	74 66                	je     801053f0 <sys_open+0xc0>
    ip = create(path, T_FILE, 0, 0);
8010538a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010538d:	31 c9                	xor    %ecx,%ecx
8010538f:	ba 02 00 00 00       	mov    $0x2,%edx
80105394:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010539b:	e8 d0 fb ff ff       	call   80104f70 <create>
    if(ip == 0){
801053a0:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801053a2:	89 c3                	mov    %eax,%ebx
    if(ip == 0){
801053a4:	74 3a                	je     801053e0 <sys_open+0xb0>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801053a6:	e8 35 bc ff ff       	call   80100fe0 <filealloc>
801053ab:	85 c0                	test   %eax,%eax
801053ad:	89 c6                	mov    %eax,%esi
801053af:	74 27                	je     801053d8 <sys_open+0xa8>
801053b1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053b8:	31 c0                	xor    %eax,%eax
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801053c0:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
801053c4:	85 c9                	test   %ecx,%ecx
801053c6:	74 58                	je     80105420 <sys_open+0xf0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801053c8:	83 c0 01             	add    $0x1,%eax
801053cb:	83 f8 10             	cmp    $0x10,%eax
801053ce:	75 f0                	jne    801053c0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801053d0:	89 34 24             	mov    %esi,(%esp)
801053d3:	e8 88 bc ff ff       	call   80101060 <fileclose>
    iunlockput(ip);
801053d8:	89 1c 24             	mov    %ebx,(%esp)
801053db:	e8 60 c8 ff ff       	call   80101c40 <iunlockput>
    end_op();
801053e0:	e8 9b d8 ff ff       	call   80102c80 <end_op>
801053e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
801053ea:	e9 69 ff ff ff       	jmp    80105358 <sys_open+0x28>
801053ef:	90                   	nop
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f3:	89 04 24             	mov    %eax,(%esp)
801053f6:	e8 c5 ca ff ff       	call   80101ec0 <namei>
801053fb:	85 c0                	test   %eax,%eax
801053fd:	89 c3                	mov    %eax,%ebx
801053ff:	74 df                	je     801053e0 <sys_open+0xb0>
      end_op();
      return -1;
    }
    ilock(ip);
80105401:	89 04 24             	mov    %eax,(%esp)
80105404:	e8 57 c8 ff ff       	call   80101c60 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105409:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010540e:	75 96                	jne    801053a6 <sys_open+0x76>
80105410:	8b 75 f0             	mov    -0x10(%ebp),%esi
80105413:	85 f6                	test   %esi,%esi
80105415:	74 8f                	je     801053a6 <sys_open+0x76>
80105417:	eb bf                	jmp    801053d8 <sys_open+0xa8>
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105420:	89 74 82 28          	mov    %esi,0x28(%edx,%eax,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105427:	89 1c 24             	mov    %ebx,(%esp)
8010542a:	e8 c1 c7 ff ff       	call   80101bf0 <iunlock>
  end_op();
8010542f:	e8 4c d8 ff ff       	call   80102c80 <end_op>

  f->type = FD_INODE;
80105434:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
8010543a:	89 5e 10             	mov    %ebx,0x10(%esi)
  f->off = 0;
8010543d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80105444:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105447:	83 f2 01             	xor    $0x1,%edx
8010544a:	83 e2 01             	and    $0x1,%edx
8010544d:	88 56 08             	mov    %dl,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105450:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
80105454:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
80105458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010545b:	e9 f8 fe ff ff       	jmp    80105358 <sys_open+0x28>

80105460 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
80105464:	56                   	push   %esi
80105465:	53                   	push   %ebx
80105466:	83 ec 6c             	sub    $0x6c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105469:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010546c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105470:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105477:	e8 94 f7 ff ff       	call   80104c10 <argstr>
8010547c:	89 c2                	mov    %eax,%edx
8010547e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105483:	85 d2                	test   %edx,%edx
80105485:	0f 88 0b 01 00 00    	js     80105596 <sys_unlink+0x136>
    return -1;

  begin_op();
8010548b:	e8 20 d9 ff ff       	call   80102db0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105493:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
80105496:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010549a:	89 04 24             	mov    %eax,(%esp)
8010549d:	e8 fe c9 ff ff       	call   80101ea0 <nameiparent>
801054a2:	85 c0                	test   %eax,%eax
801054a4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
801054a7:	0f 84 4e 01 00 00    	je     801055fb <sys_unlink+0x19b>
    end_op();
    return -1;
  }

  ilock(dp);
801054ad:	8b 45 a4             	mov    -0x5c(%ebp),%eax
801054b0:	89 04 24             	mov    %eax,(%esp)
801054b3:	e8 a8 c7 ff ff       	call   80101c60 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054b8:	c7 44 24 04 4c 7a 10 	movl   $0x80107a4c,0x4(%esp)
801054bf:	80 
801054c0:	89 1c 24             	mov    %ebx,(%esp)
801054c3:	e8 b8 bd ff ff       	call   80101280 <namecmp>
801054c8:	85 c0                	test   %eax,%eax
801054ca:	0f 84 20 01 00 00    	je     801055f0 <sys_unlink+0x190>
801054d0:	c7 44 24 04 4b 7a 10 	movl   $0x80107a4b,0x4(%esp)
801054d7:	80 
801054d8:	89 1c 24             	mov    %ebx,(%esp)
801054db:	e8 a0 bd ff ff       	call   80101280 <namecmp>
801054e0:	85 c0                	test   %eax,%eax
801054e2:	0f 84 08 01 00 00    	je     801055f0 <sys_unlink+0x190>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801054e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054eb:	89 44 24 08          	mov    %eax,0x8(%esp)
801054ef:	8b 45 a4             	mov    -0x5c(%ebp),%eax
801054f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801054f6:	89 04 24             	mov    %eax,(%esp)
801054f9:	e8 82 c4 ff ff       	call   80101980 <dirlookup>
801054fe:	85 c0                	test   %eax,%eax
80105500:	89 c6                	mov    %eax,%esi
80105502:	0f 84 e8 00 00 00    	je     801055f0 <sys_unlink+0x190>
    goto bad;
  ilock(ip);
80105508:	89 04 24             	mov    %eax,(%esp)
8010550b:	e8 50 c7 ff ff       	call   80101c60 <ilock>

  if(ip->nlink < 1)
80105510:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80105515:	0f 8e 22 01 00 00    	jle    8010563d <sys_unlink+0x1dd>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010551b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105520:	74 7e                	je     801055a0 <sys_unlink+0x140>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105522:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
80105525:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010552c:	00 
8010552d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105534:	00 
80105535:	89 1c 24             	mov    %ebx,(%esp)
80105538:	e8 33 f3 ff ff       	call   80104870 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010553d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105540:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105547:	00 
80105548:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010554c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105550:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80105553:	89 04 24             	mov    %eax,(%esp)
80105556:	e8 f5 c1 ff ff       	call   80101750 <writei>
8010555b:	83 f8 10             	cmp    $0x10,%eax
8010555e:	0f 85 cd 00 00 00    	jne    80105631 <sys_unlink+0x1d1>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105564:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105569:	0f 84 a1 00 00 00    	je     80105610 <sys_unlink+0x1b0>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010556f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80105572:	89 04 24             	mov    %eax,(%esp)
80105575:	e8 c6 c6 ff ff       	call   80101c40 <iunlockput>

  ip->nlink--;
8010557a:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
  iupdate(ip);
8010557f:	89 34 24             	mov    %esi,(%esp)
80105582:	e8 29 bd ff ff       	call   801012b0 <iupdate>
  iunlockput(ip);
80105587:	89 34 24             	mov    %esi,(%esp)
8010558a:	e8 b1 c6 ff ff       	call   80101c40 <iunlockput>

  end_op();
8010558f:	e8 ec d6 ff ff       	call   80102c80 <end_op>
80105594:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105596:	83 c4 6c             	add    $0x6c,%esp
80105599:	5b                   	pop    %ebx
8010559a:	5e                   	pop    %esi
8010559b:	5f                   	pop    %edi
8010559c:	5d                   	pop    %ebp
8010559d:	c3                   	ret    
8010559e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055a0:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801055a4:	0f 86 78 ff ff ff    	jbe    80105522 <sys_unlink+0xc2>
801055aa:	8d 7d b2             	lea    -0x4e(%ebp),%edi
801055ad:	bb 20 00 00 00       	mov    $0x20,%ebx
801055b2:	eb 10                	jmp    801055c4 <sys_unlink+0x164>
801055b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055b8:	83 c3 10             	add    $0x10,%ebx
801055bb:	3b 5e 58             	cmp    0x58(%esi),%ebx
801055be:	0f 83 5e ff ff ff    	jae    80105522 <sys_unlink+0xc2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055c4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801055cb:	00 
801055cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801055d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
801055d4:	89 34 24             	mov    %esi,(%esp)
801055d7:	e8 94 c2 ff ff       	call   80101870 <readi>
801055dc:	83 f8 10             	cmp    $0x10,%eax
801055df:	75 44                	jne    80105625 <sys_unlink+0x1c5>
      panic("isdirempty: readi");
    if(de.inum != 0)
801055e1:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
801055e6:	74 d0                	je     801055b8 <sys_unlink+0x158>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801055e8:	89 34 24             	mov    %esi,(%esp)
801055eb:	e8 50 c6 ff ff       	call   80101c40 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
801055f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
801055f3:	89 04 24             	mov    %eax,(%esp)
801055f6:	e8 45 c6 ff ff       	call   80101c40 <iunlockput>
  end_op();
801055fb:	e8 80 d6 ff ff       	call   80102c80 <end_op>
  return -1;
}
80105600:	83 c4 6c             	add    $0x6c,%esp

  return 0;

bad:
  iunlockput(dp);
  end_op();
80105603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
80105608:	5b                   	pop    %ebx
80105609:	5e                   	pop    %esi
8010560a:	5f                   	pop    %edi
8010560b:	5d                   	pop    %ebp
8010560c:	c3                   	ret    
8010560d:	8d 76 00             	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105610:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80105613:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105618:	89 04 24             	mov    %eax,(%esp)
8010561b:	e8 90 bc ff ff       	call   801012b0 <iupdate>
80105620:	e9 4a ff ff ff       	jmp    8010556f <sys_unlink+0x10f>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80105625:	c7 04 24 7c 7a 10 80 	movl   $0x80107a7c,(%esp)
8010562c:	e8 9f ad ff ff       	call   801003d0 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105631:	c7 04 24 8e 7a 10 80 	movl   $0x80107a8e,(%esp)
80105638:	e8 93 ad ff ff       	call   801003d0 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
8010563d:	c7 04 24 6a 7a 10 80 	movl   $0x80107a6a,(%esp)
80105644:	e8 87 ad ff ff       	call   801003d0 <panic>
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105650 <argfd.clone.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	83 ec 28             	sub    $0x28,%esp
80105656:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80105659:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010565b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010565e:	89 75 fc             	mov    %esi,-0x4(%ebp)
80105661:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105663:	89 44 24 04          	mov    %eax,0x4(%esp)
80105667:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010566e:	e8 0d f5 ff ff       	call   80104b80 <argint>
80105673:	85 c0                	test   %eax,%eax
80105675:	79 11                	jns    80105688 <argfd.clone.0+0x38>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
80105677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
8010567c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
8010567f:	8b 75 fc             	mov    -0x4(%ebp),%esi
80105682:	89 ec                	mov    %ebp,%esp
80105684:	5d                   	pop    %ebp
80105685:	c3                   	ret    
80105686:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010568b:	83 f8 0f             	cmp    $0xf,%eax
8010568e:	77 e7                	ja     80105677 <argfd.clone.0+0x27>
80105690:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105697:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
8010569b:	85 d2                	test   %edx,%edx
8010569d:	74 d8                	je     80105677 <argfd.clone.0+0x27>
    return -1;
  if(pfd)
8010569f:	85 db                	test   %ebx,%ebx
801056a1:	74 02                	je     801056a5 <argfd.clone.0+0x55>
    *pfd = fd;
801056a3:	89 03                	mov    %eax,(%ebx)
  if(pf)
801056a5:	31 c0                	xor    %eax,%eax
801056a7:	85 f6                	test   %esi,%esi
801056a9:	74 d1                	je     8010567c <argfd.clone.0+0x2c>
    *pf = f;
801056ab:	89 16                	mov    %edx,(%esi)
801056ad:	eb cd                	jmp    8010567c <argfd.clone.0+0x2c>
801056af:	90                   	nop

801056b0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801056b0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801056b1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801056b3:	89 e5                	mov    %esp,%ebp
801056b5:	53                   	push   %ebx
801056b6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801056b9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056bc:	e8 8f ff ff ff       	call   80105650 <argfd.clone.0>
801056c1:	85 c0                	test   %eax,%eax
801056c3:	79 13                	jns    801056d8 <sys_dup+0x28>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056c5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801056ca:	89 d8                	mov    %ebx,%eax
801056cc:	83 c4 24             	add    $0x24,%esp
801056cf:	5b                   	pop    %ebx
801056d0:	5d                   	pop    %ebp
801056d1:	c3                   	ret    
801056d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801056d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056db:	31 db                	xor    %ebx,%ebx
801056dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056e3:	eb 0b                	jmp    801056f0 <sys_dup+0x40>
801056e5:	8d 76 00             	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056e8:	83 c3 01             	add    $0x1,%ebx
801056eb:	83 fb 10             	cmp    $0x10,%ebx
801056ee:	74 d5                	je     801056c5 <sys_dup+0x15>
    if(proc->ofile[fd] == 0){
801056f0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
801056f4:	85 c9                	test   %ecx,%ecx
801056f6:	75 f0                	jne    801056e8 <sys_dup+0x38>
      proc->ofile[fd] = f;
801056f8:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801056fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ff:	89 04 24             	mov    %eax,(%esp)
80105702:	e8 89 b8 ff ff       	call   80100f90 <filedup>
  return fd;
80105707:	eb c1                	jmp    801056ca <sys_dup+0x1a>
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_read>:
}

int
sys_read(void)
{
80105710:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105711:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105713:	89 e5                	mov    %esp,%ebp
80105715:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105718:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010571b:	e8 30 ff ff ff       	call   80105650 <argfd.clone.0>
80105720:	85 c0                	test   %eax,%eax
80105722:	79 0c                	jns    80105730 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
80105724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105729:	c9                   	leave  
8010572a:	c3                   	ret    
8010572b:	90                   	nop
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105730:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105733:	89 44 24 04          	mov    %eax,0x4(%esp)
80105737:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010573e:	e8 3d f4 ff ff       	call   80104b80 <argint>
80105743:	85 c0                	test   %eax,%eax
80105745:	78 dd                	js     80105724 <sys_read+0x14>
80105747:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010574a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105751:	89 44 24 08          	mov    %eax,0x8(%esp)
80105755:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105758:	89 44 24 04          	mov    %eax,0x4(%esp)
8010575c:	e8 5f f4 ff ff       	call   80104bc0 <argptr>
80105761:	85 c0                	test   %eax,%eax
80105763:	78 bf                	js     80105724 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
80105765:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105768:	89 44 24 08          	mov    %eax,0x8(%esp)
8010576c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010576f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105776:	89 04 24             	mov    %eax,(%esp)
80105779:	e8 02 b7 ff ff       	call   80100e80 <fileread>
}
8010577e:	c9                   	leave  
8010577f:	c3                   	ret    

80105780 <sys_write>:

int
sys_write(void)
{
80105780:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105781:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105783:	89 e5                	mov    %esp,%ebp
80105785:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105788:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010578b:	e8 c0 fe ff ff       	call   80105650 <argfd.clone.0>
80105790:	85 c0                	test   %eax,%eax
80105792:	79 0c                	jns    801057a0 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
80105794:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105799:	c9                   	leave  
8010579a:	c3                   	ret    
8010579b:	90                   	nop
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801057ae:	e8 cd f3 ff ff       	call   80104b80 <argint>
801057b3:	85 c0                	test   %eax,%eax
801057b5:	78 dd                	js     80105794 <sys_write+0x14>
801057b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057c1:	89 44 24 08          	mov    %eax,0x8(%esp)
801057c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801057cc:	e8 ef f3 ff ff       	call   80104bc0 <argptr>
801057d1:	85 c0                	test   %eax,%eax
801057d3:	78 bf                	js     80105794 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
801057d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d8:	89 44 24 08          	mov    %eax,0x8(%esp)
801057dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057df:	89 44 24 04          	mov    %eax,0x4(%esp)
801057e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e6:	89 04 24             	mov    %eax,(%esp)
801057e9:	e8 72 b5 ff ff       	call   80100d60 <filewrite>
}
801057ee:	c9                   	leave  
801057ef:	c3                   	ret    

801057f0 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
801057f0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801057f1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801057f3:	89 e5                	mov    %esp,%ebp
801057f5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801057f8:	8d 55 f4             	lea    -0xc(%ebp),%edx
801057fb:	e8 50 fe ff ff       	call   80105650 <argfd.clone.0>
80105800:	85 c0                	test   %eax,%eax
80105802:	79 0c                	jns    80105810 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
80105804:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105809:	c9                   	leave  
8010580a:	c3                   	ret    
8010580b:	90                   	nop
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105810:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105813:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010581a:	00 
8010581b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010581f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105826:	e8 95 f3 ff ff       	call   80104bc0 <argptr>
8010582b:	85 c0                	test   %eax,%eax
8010582d:	78 d5                	js     80105804 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
8010582f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105832:	89 44 24 04          	mov    %eax,0x4(%esp)
80105836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105839:	89 04 24             	mov    %eax,(%esp)
8010583c:	e8 ff b6 ff ff       	call   80100f40 <filestat>
}
80105841:	c9                   	leave  
80105842:	c3                   	ret    
80105843:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105850 <sys_close>:
  return filewrite(f, p, n);
}

int
sys_close(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105856:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105859:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010585c:	e8 ef fd ff ff       	call   80105650 <argfd.clone.0>
80105861:	89 c2                	mov    %eax,%edx
80105863:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105868:	85 d2                	test   %edx,%edx
8010586a:	78 1e                	js     8010588a <sys_close+0x3a>
    return -1;
  proc->ofile[fd] = 0;
8010586c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105872:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105875:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010587c:	00 
  fileclose(f);
8010587d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105880:	89 04 24             	mov    %eax,(%esp)
80105883:	e8 d8 b7 ff ff       	call   80101060 <fileclose>
80105888:	31 c0                	xor    %eax,%eax
  return 0;
}
8010588a:	c9                   	leave  
8010588b:	c3                   	ret    
8010588c:	00 00                	add    %al,(%eax)
	...

80105890 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
80105890:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105896:	55                   	push   %ebp
80105897:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
80105899:	5d                   	pop    %ebp
  return kill(pid);
}

int
sys_getpid(void)
{
8010589a:	8b 40 10             	mov    0x10(%eax),%eax
  return proc->pid;
}
8010589d:	c3                   	ret    
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_set_tickets>:
}

//Our system call 
int 
sys_set_tickets(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 28             	sub    $0x28,%esp
	int n;
	if(argint(0,&n)<0)
801058a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058b4:	e8 c7 f2 ff ff       	call   80104b80 <argint>
801058b9:	89 c2                	mov    %eax,%edx
801058bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c0:	85 d2                	test   %edx,%edx
801058c2:	78 0b                	js     801058cf <sys_set_tickets+0x2f>
	   return -1;
	//if(argint(1, &pid)<0)
	//   return -1;

        return set_tickets(n);	
801058c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c7:	89 04 24             	mov    %eax,(%esp)
801058ca:	e8 61 de ff ff       	call   80103730 <set_tickets>
}
801058cf:	c9                   	leave  
801058d0:	c3                   	ret    
801058d1:	eb 0d                	jmp    801058e0 <sys_uptime>
801058d3:	90                   	nop
801058d4:	90                   	nop
801058d5:	90                   	nop
801058d6:	90                   	nop
801058d7:	90                   	nop
801058d8:	90                   	nop
801058d9:	90                   	nop
801058da:	90                   	nop
801058db:	90                   	nop
801058dc:	90                   	nop
801058dd:	90                   	nop
801058de:	90                   	nop
801058df:	90                   	nop

801058e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	53                   	push   %ebx
801058e4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801058e7:	c7 04 24 e0 4f 11 80 	movl   $0x80114fe0,(%esp)
801058ee:	e8 dd ee ff ff       	call   801047d0 <acquire>
  xticks = ticks;
801058f3:	8b 1d 20 58 11 80    	mov    0x80115820,%ebx
  release(&tickslock);
801058f9:	c7 04 24 e0 4f 11 80 	movl   $0x80114fe0,(%esp)
80105900:	e8 7b ee ff ff       	call   80104780 <release>
  return xticks;
}
80105905:	83 c4 14             	add    $0x14,%esp
80105908:	89 d8                	mov    %ebx,%eax
8010590a:	5b                   	pop    %ebx
8010590b:	5d                   	pop    %ebp
8010590c:	c3                   	ret    
8010590d:	8d 76 00             	lea    0x0(%esi),%esi

80105910 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	53                   	push   %ebx
80105914:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105917:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010591a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010591e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105925:	e8 56 f2 ff ff       	call   80104b80 <argint>
8010592a:	89 c2                	mov    %eax,%edx
8010592c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105931:	85 d2                	test   %edx,%edx
80105933:	78 59                	js     8010598e <sys_sleep+0x7e>
    return -1;
  acquire(&tickslock);
80105935:	c7 04 24 e0 4f 11 80 	movl   $0x80114fe0,(%esp)
8010593c:	e8 8f ee ff ff       	call   801047d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105941:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105944:	8b 1d 20 58 11 80    	mov    0x80115820,%ebx
  while(ticks - ticks0 < n){
8010594a:	85 d2                	test   %edx,%edx
8010594c:	75 22                	jne    80105970 <sys_sleep+0x60>
8010594e:	eb 48                	jmp    80105998 <sys_sleep+0x88>
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105950:	c7 44 24 04 e0 4f 11 	movl   $0x80114fe0,0x4(%esp)
80105957:	80 
80105958:	c7 04 24 20 58 11 80 	movl   $0x80115820,(%esp)
8010595f:	e8 1c e1 ff ff       	call   80103a80 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105964:	a1 20 58 11 80       	mov    0x80115820,%eax
80105969:	29 d8                	sub    %ebx,%eax
8010596b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010596e:	73 28                	jae    80105998 <sys_sleep+0x88>
    if(proc->killed){
80105970:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105976:	8b 40 24             	mov    0x24(%eax),%eax
80105979:	85 c0                	test   %eax,%eax
8010597b:	74 d3                	je     80105950 <sys_sleep+0x40>
      release(&tickslock);
8010597d:	c7 04 24 e0 4f 11 80 	movl   $0x80114fe0,(%esp)
80105984:	e8 f7 ed ff ff       	call   80104780 <release>
80105989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010598e:	83 c4 24             	add    $0x24,%esp
80105991:	5b                   	pop    %ebx
80105992:	5d                   	pop    %ebp
80105993:	c3                   	ret    
80105994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105998:	c7 04 24 e0 4f 11 80 	movl   $0x80114fe0,(%esp)
8010599f:	e8 dc ed ff ff       	call   80104780 <release>
  return 0;
}
801059a4:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801059a7:	31 c0                	xor    %eax,%eax
  return 0;
}
801059a9:	5b                   	pop    %ebx
801059aa:	5d                   	pop    %ebp
801059ab:	c3                   	ret    
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_sbrk>:
  return proc->pid;
}

int
sys_sbrk(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
801059b4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801059be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059c5:	e8 b6 f1 ff ff       	call   80104b80 <argint>
801059ca:	85 c0                	test   %eax,%eax
801059cc:	79 12                	jns    801059e0 <sys_sbrk+0x30>
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
801059ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d3:	83 c4 24             	add    $0x24,%esp
801059d6:	5b                   	pop    %ebx
801059d7:	5d                   	pop    %ebp
801059d8:	c3                   	ret    
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801059e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059e6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059eb:	89 04 24             	mov    %eax,(%esp)
801059ee:	e8 9d e9 ff ff       	call   80104390 <growproc>
801059f3:	89 c2                	mov    %eax,%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801059f5:	89 d8                	mov    %ebx,%eax
  if(growproc(n) < 0)
801059f7:	85 d2                	test   %edx,%edx
801059f9:	79 d8                	jns    801059d3 <sys_sbrk+0x23>
801059fb:	eb d1                	jmp    801059ce <sys_sbrk+0x1e>
801059fd:	8d 76 00             	lea    0x0(%esi),%esi

80105a00 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a09:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a14:	e8 67 f1 ff ff       	call   80104b80 <argint>
80105a19:	89 c2                	mov    %eax,%edx
80105a1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a20:	85 d2                	test   %edx,%edx
80105a22:	78 0b                	js     80105a2f <sys_kill+0x2f>
    return -1;
  return kill(pid);
80105a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a27:	89 04 24             	mov    %eax,(%esp)
80105a2a:	e8 61 de ff ff       	call   80103890 <kill>
}
80105a2f:	c9                   	leave  
80105a30:	c3                   	ret    
80105a31:	eb 0d                	jmp    80105a40 <sys_wait>
80105a33:	90                   	nop
80105a34:	90                   	nop
80105a35:	90                   	nop
80105a36:	90                   	nop
80105a37:	90                   	nop
80105a38:	90                   	nop
80105a39:	90                   	nop
80105a3a:	90                   	nop
80105a3b:	90                   	nop
80105a3c:	90                   	nop
80105a3d:	90                   	nop
80105a3e:	90                   	nop
80105a3f:	90                   	nop

80105a40 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
80105a46:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
80105a47:	e9 c4 e4 ff ff       	jmp    80103f10 <wait>
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_exit>:
  return fork();
}

int
sys_exit(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a56:	e8 a5 e5 ff ff       	call   80104000 <exit>
  return 0;  // not reached
}
80105a5b:	31 c0                	xor    %eax,%eax
80105a5d:	c9                   	leave  
80105a5e:	c3                   	ret    
80105a5f:	90                   	nop

80105a60 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 08             	sub    $0x8,%esp
  return fork();
}
80105a66:	c9                   	leave  
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105a67:	e9 04 e8 ff ff       	jmp    80104270 <fork>
80105a6c:	00 00                	add    %al,(%eax)
	...

80105a70 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105a70:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a71:	ba 43 00 00 00       	mov    $0x43,%edx
80105a76:	89 e5                	mov    %esp,%ebp
80105a78:	83 ec 18             	sub    $0x18,%esp
80105a7b:	b8 34 00 00 00       	mov    $0x34,%eax
80105a80:	ee                   	out    %al,(%dx)
80105a81:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105a86:	b2 40                	mov    $0x40,%dl
80105a88:	ee                   	out    %al,(%dx)
80105a89:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105a8e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105a8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a96:	e8 25 d8 ff ff       	call   801032c0 <picenable>
}
80105a9b:	c9                   	leave  
80105a9c:	c3                   	ret    
80105a9d:	00 00                	add    %al,(%eax)
	...

80105aa0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105aa0:	1e                   	push   %ds
  pushl %es
80105aa1:	06                   	push   %es
  pushl %fs
80105aa2:	0f a0                	push   %fs
  pushl %gs
80105aa4:	0f a8                	push   %gs
  pushal
80105aa6:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105aa7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105aab:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105aad:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80105aaf:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105ab3:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105ab5:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ab7:	54                   	push   %esp
  call trap
80105ab8:	e8 43 00 00 00       	call   80105b00 <trap>
  addl $4, %esp
80105abd:	83 c4 04             	add    $0x4,%esp

80105ac0 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ac0:	61                   	popa   
  popl %gs
80105ac1:	0f a9                	pop    %gs
  popl %fs
80105ac3:	0f a1                	pop    %fs
  popl %es
80105ac5:	07                   	pop    %es
  popl %ds
80105ac6:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ac7:	83 c4 08             	add    $0x8,%esp
  iret
80105aca:	cf                   	iret   
80105acb:	00 00                	add    %al,(%eax)
80105acd:	00 00                	add    %al,(%eax)
	...

80105ad0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
80105ad0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
80105ad1:	b8 20 50 11 80       	mov    $0x80115020,%eax
80105ad6:	89 e5                	mov    %esp,%ebp
80105ad8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105adb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105ae1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ae5:	c1 e8 10             	shr    $0x10,%eax
80105ae8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105aec:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105aef:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105af2:	c9                   	leave  
80105af3:	c3                   	ret    
80105af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105b00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 38             	sub    $0x38,%esp
80105b06:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80105b09:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105b0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
80105b0f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
80105b12:	8b 43 30             	mov    0x30(%ebx),%eax
80105b15:	83 f8 40             	cmp    $0x40,%eax
80105b18:	0f 84 d2 00 00 00    	je     80105bf0 <trap+0xf0>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b1e:	83 e8 20             	sub    $0x20,%eax
80105b21:	83 f8 1f             	cmp    $0x1f,%eax
80105b24:	0f 86 be 00 00 00    	jbe    80105be8 <trap+0xe8>
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105b2a:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80105b31:	85 c9                	test   %ecx,%ecx
80105b33:	0f 84 e7 01 00 00    	je     80105d20 <trap+0x220>
80105b39:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b3d:	0f 84 dd 01 00 00    	je     80105d20 <trap+0x220>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b43:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b46:	8b 73 38             	mov    0x38(%ebx),%esi
80105b49:	e8 d2 ce ff ff       	call   80102a20 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105b4e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b55:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
80105b59:	89 74 24 18          	mov    %esi,0x18(%esp)
80105b5d:	89 44 24 14          	mov    %eax,0x14(%esp)
80105b61:	8b 43 34             	mov    0x34(%ebx),%eax
80105b64:	89 44 24 10          	mov    %eax,0x10(%esp)
80105b68:	8b 43 30             	mov    0x30(%ebx),%eax
80105b6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
80105b6f:	8d 42 6c             	lea    0x6c(%edx),%eax
80105b72:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b76:	8b 42 10             	mov    0x10(%edx),%eax
80105b79:	c7 04 24 f8 7a 10 80 	movl   $0x80107af8,(%esp)
80105b80:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b84:	e8 e7 ac ff ff       	call   80100870 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80105b89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b8f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105b96:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105b98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b9e:	85 c0                	test   %eax,%eax
80105ba0:	74 34                	je     80105bd6 <trap+0xd6>
80105ba2:	8b 50 24             	mov    0x24(%eax),%edx
80105ba5:	85 d2                	test   %edx,%edx
80105ba7:	74 10                	je     80105bb9 <trap+0xb9>
80105ba9:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105bad:	83 e2 03             	and    $0x3,%edx
80105bb0:	83 fa 03             	cmp    $0x3,%edx
80105bb3:	0f 84 4f 01 00 00    	je     80105d08 <trap+0x208>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105bb9:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105bbd:	0f 84 1d 01 00 00    	je     80105ce0 <trap+0x1e0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105bc3:	8b 40 24             	mov    0x24(%eax),%eax
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	74 0c                	je     80105bd6 <trap+0xd6>
80105bca:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bce:	83 e0 03             	and    $0x3,%eax
80105bd1:	83 f8 03             	cmp    $0x3,%eax
80105bd4:	74 3c                	je     80105c12 <trap+0x112>
    exit();
}
80105bd6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105bd9:	8b 75 f8             	mov    -0x8(%ebp),%esi
80105bdc:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105bdf:	89 ec                	mov    %ebp,%esp
80105be1:	5d                   	pop    %ebp
80105be2:	c3                   	ret    
80105be3:	90                   	nop
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105be8:	ff 24 85 48 7b 10 80 	jmp    *-0x7fef84b8(,%eax,4)
80105bef:	90                   	nop
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105bf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bf6:	8b 70 24             	mov    0x24(%eax),%esi
80105bf9:	85 f6                	test   %esi,%esi
80105bfb:	75 2b                	jne    80105c28 <trap+0x128>
      exit();
    proc->tf = tf;
80105bfd:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c00:	e8 8b f0 ff ff       	call   80104c90 <syscall>
    if(proc->killed)
80105c05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c0b:	8b 58 24             	mov    0x24(%eax),%ebx
80105c0e:	85 db                	test   %ebx,%ebx
80105c10:	74 c4                	je     80105bd6 <trap+0xd6>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105c12:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105c15:	8b 75 f8             	mov    -0x8(%ebp),%esi
80105c18:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105c1b:	89 ec                	mov    %ebp,%esp
80105c1d:	5d                   	pop    %ebp
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
80105c1e:	e9 dd e3 ff ff       	jmp    80104000 <exit>
80105c23:	90                   	nop
80105c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105c28:	e8 d3 e3 ff ff       	call   80104000 <exit>
80105c2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c33:	eb c8                	jmp    80105bfd <trap+0xfd>
80105c35:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c38:	e8 e3 c4 ff ff       	call   80102120 <ideintr>
    lapiceoi();
80105c3d:	e8 0e cb ff ff       	call   80102750 <lapiceoi>
    break;
80105c42:	e9 51 ff ff ff       	jmp    80105b98 <trap+0x98>
80105c47:	90                   	nop
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c48:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c4b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105c4f:	e8 cc cd ff ff       	call   80102a20 <cpunum>
80105c54:	c7 04 24 a0 7a 10 80 	movl   $0x80107aa0,(%esp)
80105c5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105c5f:	89 74 24 08          	mov    %esi,0x8(%esp)
80105c63:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c67:	e8 04 ac ff ff       	call   80100870 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105c6c:	e8 df ca ff ff       	call   80102750 <lapiceoi>
    break;
80105c71:	e9 22 ff ff ff       	jmp    80105b98 <trap+0x98>
80105c76:	66 90                	xchg   %ax,%ax
80105c78:	90                   	nop
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105c80:	e8 9b 01 00 00       	call   80105e20 <uartintr>
    lapiceoi();
80105c85:	e8 c6 ca ff ff       	call   80102750 <lapiceoi>
    break;
80105c8a:	e9 09 ff ff ff       	jmp    80105b98 <trap+0x98>
80105c8f:	90                   	nop
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105c90:	e8 5b c9 ff ff       	call   801025f0 <kbdintr>
    lapiceoi();
80105c95:	e8 b6 ca ff ff       	call   80102750 <lapiceoi>
    break;
80105c9a:	e9 f9 fe ff ff       	jmp    80105b98 <trap+0x98>
80105c9f:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105ca0:	e8 7b cd ff ff       	call   80102a20 <cpunum>
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	75 94                	jne    80105c3d <trap+0x13d>
      acquire(&tickslock);
80105ca9:	c7 04 24 e0 4f 11 80 	movl   $0x80114fe0,(%esp)
80105cb0:	e8 1b eb ff ff       	call   801047d0 <acquire>
      ticks++;
80105cb5:	83 05 20 58 11 80 01 	addl   $0x1,0x80115820
      wakeup(&ticks);
80105cbc:	c7 04 24 20 58 11 80 	movl   $0x80115820,(%esp)
80105cc3:	e8 58 dc ff ff       	call   80103920 <wakeup>
      release(&tickslock);
80105cc8:	c7 04 24 e0 4f 11 80 	movl   $0x80114fe0,(%esp)
80105ccf:	e8 ac ea ff ff       	call   80104780 <release>
80105cd4:	e9 64 ff ff ff       	jmp    80105c3d <trap+0x13d>
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105ce0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ce4:	0f 85 d9 fe ff ff    	jne    80105bc3 <trap+0xc3>
80105cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    yield();
80105cf0:	e8 5b de ff ff       	call   80103b50 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105cf5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cfb:	85 c0                	test   %eax,%eax
80105cfd:	0f 85 c0 fe ff ff    	jne    80105bc3 <trap+0xc3>
80105d03:	e9 ce fe ff ff       	jmp    80105bd6 <trap+0xd6>

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
80105d08:	e8 f3 e2 ff ff       	call   80104000 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105d0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d13:	85 c0                	test   %eax,%eax
80105d15:	0f 85 9e fe ff ff    	jne    80105bb9 <trap+0xb9>
80105d1b:	e9 b6 fe ff ff       	jmp    80105bd6 <trap+0xd6>
80105d20:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d23:	8b 73 38             	mov    0x38(%ebx),%esi
80105d26:	e8 f5 cc ff ff       	call   80102a20 <cpunum>
80105d2b:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105d2f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105d33:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d37:	8b 43 30             	mov    0x30(%ebx),%eax
80105d3a:	c7 04 24 c4 7a 10 80 	movl   $0x80107ac4,(%esp)
80105d41:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d45:	e8 26 ab ff ff       	call   80100870 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105d4a:	c7 04 24 3b 7b 10 80 	movl   $0x80107b3b,(%esp)
80105d51:	e8 7a a6 ff ff       	call   801003d0 <panic>
80105d56:	8d 76 00             	lea    0x0(%esi),%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d60 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d60:	55                   	push   %ebp
80105d61:	31 c0                	xor    %eax,%eax
80105d63:	89 e5                	mov    %esp,%ebp
80105d65:	ba 20 50 11 80       	mov    $0x80115020,%edx
80105d6a:	83 ec 18             	sub    $0x18,%esp
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d70:	8b 0c 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%ecx
80105d77:	66 89 0c c5 20 50 11 	mov    %cx,-0x7feeafe0(,%eax,8)
80105d7e:	80 
80105d7f:	c1 e9 10             	shr    $0x10,%ecx
80105d82:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
80105d89:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
80105d8e:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
80105d93:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105d98:	83 c0 01             	add    $0x1,%eax
80105d9b:	3d 00 01 00 00       	cmp    $0x100,%eax
80105da0:	75 ce                	jne    80105d70 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105da2:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105da7:	c7 44 24 04 40 7b 10 	movl   $0x80107b40,0x4(%esp)
80105dae:	80 
80105daf:	c7 04 24 e0 4f 11 80 	movl   $0x80114fe0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105db6:	66 c7 05 22 52 11 80 	movw   $0x8,0x80115222
80105dbd:	08 00 
80105dbf:	66 a3 20 52 11 80    	mov    %ax,0x80115220
80105dc5:	c1 e8 10             	shr    $0x10,%eax
80105dc8:	c6 05 24 52 11 80 00 	movb   $0x0,0x80115224
80105dcf:	c6 05 25 52 11 80 ef 	movb   $0xef,0x80115225
80105dd6:	66 a3 26 52 11 80    	mov    %ax,0x80115226

  initlock(&tickslock, "time");
80105ddc:	e8 5f e8 ff ff       	call   80104640 <initlock>
}
80105de1:	c9                   	leave  
80105de2:	c3                   	ret    
	...

80105df0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105df0:	a1 cc a5 10 80       	mov    0x8010a5cc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105df5:	55                   	push   %ebp
80105df6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105df8:	85 c0                	test   %eax,%eax
80105dfa:	75 0c                	jne    80105e08 <uartgetc+0x18>
    return -1;
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
80105dfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e01:	5d                   	pop    %ebp
80105e02:	c3                   	ret    
80105e03:	90                   	nop
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e08:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e0d:	ec                   	in     (%dx),%al
static int
uartgetc(void)
{
  if(!uart)
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e0e:	a8 01                	test   $0x1,%al
80105e10:	74 ea                	je     80105dfc <uartgetc+0xc>
80105e12:	b2 f8                	mov    $0xf8,%dl
80105e14:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e15:	0f b6 c0             	movzbl %al,%eax
}
80105e18:	5d                   	pop    %ebp
80105e19:	c3                   	ret    
80105e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e20 <uartintr>:

void
uartintr(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105e26:	c7 04 24 f0 5d 10 80 	movl   $0x80105df0,(%esp)
80105e2d:	e8 0e a8 ff ff       	call   80100640 <consoleintr>
}
80105e32:	c9                   	leave  
80105e33:	c3                   	ret    
80105e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105e40 <uartputc>:
    uartputc(*p);
}

void
uartputc(int c)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	56                   	push   %esi
80105e44:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e49:	53                   	push   %ebx
  int i;

  if(!uart)
80105e4a:	31 db                	xor    %ebx,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105e4c:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
80105e4f:	8b 15 cc a5 10 80    	mov    0x8010a5cc,%edx
80105e55:	85 d2                	test   %edx,%edx
80105e57:	75 1e                	jne    80105e77 <uartputc+0x37>
80105e59:	eb 2c                	jmp    80105e87 <uartputc+0x47>
80105e5b:	90                   	nop
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e60:	83 c3 01             	add    $0x1,%ebx
    microdelay(10);
80105e63:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105e6a:	e8 01 c9 ff ff       	call   80102770 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e6f:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80105e75:	74 07                	je     80105e7e <uartputc+0x3e>
80105e77:	89 f2                	mov    %esi,%edx
80105e79:	ec                   	in     (%dx),%al
80105e7a:	a8 20                	test   $0x20,%al
80105e7c:	74 e2                	je     80105e60 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e7e:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e83:	8b 45 08             	mov    0x8(%ebp),%eax
80105e86:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105e87:	83 c4 10             	add    $0x10,%esp
80105e8a:	5b                   	pop    %ebx
80105e8b:	5e                   	pop    %esi
80105e8c:	5d                   	pop    %ebp
80105e8d:	c3                   	ret    
80105e8e:	66 90                	xchg   %ax,%ax

80105e90 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105e90:	55                   	push   %ebp
80105e91:	31 c9                	xor    %ecx,%ecx
80105e93:	89 e5                	mov    %esp,%ebp
80105e95:	89 c8                	mov    %ecx,%eax
80105e97:	57                   	push   %edi
80105e98:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e9d:	56                   	push   %esi
80105e9e:	89 fa                	mov    %edi,%edx
80105ea0:	53                   	push   %ebx
80105ea1:	83 ec 1c             	sub    $0x1c,%esp
80105ea4:	ee                   	out    %al,(%dx)
80105ea5:	bb fb 03 00 00       	mov    $0x3fb,%ebx
80105eaa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105eaf:	89 da                	mov    %ebx,%edx
80105eb1:	ee                   	out    %al,(%dx)
80105eb2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105eb7:	b2 f8                	mov    $0xf8,%dl
80105eb9:	ee                   	out    %al,(%dx)
80105eba:	be f9 03 00 00       	mov    $0x3f9,%esi
80105ebf:	89 c8                	mov    %ecx,%eax
80105ec1:	89 f2                	mov    %esi,%edx
80105ec3:	ee                   	out    %al,(%dx)
80105ec4:	b8 03 00 00 00       	mov    $0x3,%eax
80105ec9:	89 da                	mov    %ebx,%edx
80105ecb:	ee                   	out    %al,(%dx)
80105ecc:	b2 fc                	mov    $0xfc,%dl
80105ece:	89 c8                	mov    %ecx,%eax
80105ed0:	ee                   	out    %al,(%dx)
80105ed1:	b8 01 00 00 00       	mov    $0x1,%eax
80105ed6:	89 f2                	mov    %esi,%edx
80105ed8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ed9:	b2 fd                	mov    $0xfd,%dl
80105edb:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105edc:	3c ff                	cmp    $0xff,%al
80105ede:	74 55                	je     80105f35 <uartinit+0xa5>
    return;
  uart = 1;
80105ee0:	c7 05 cc a5 10 80 01 	movl   $0x1,0x8010a5cc
80105ee7:	00 00 00 
80105eea:	89 fa                	mov    %edi,%edx
80105eec:	ec                   	in     (%dx),%al
80105eed:	b2 f8                	mov    $0xf8,%dl
80105eef:	ec                   	in     (%dx),%al
  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
80105ef0:	bb c8 7b 10 80       	mov    $0x80107bc8,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105ef5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105efc:	e8 bf d3 ff ff       	call   801032c0 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105f01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f08:	00 
80105f09:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105f10:	e8 3b c3 ff ff       	call   80102250 <ioapicenable>
80105f15:	b8 78 00 00 00       	mov    $0x78,%eax
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
80105f20:	0f be c0             	movsbl %al,%eax
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105f23:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105f26:	89 04 24             	mov    %eax,(%esp)
80105f29:	e8 12 ff ff ff       	call   80105e40 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105f2e:	0f b6 03             	movzbl (%ebx),%eax
80105f31:	84 c0                	test   %al,%al
80105f33:	75 eb                	jne    80105f20 <uartinit+0x90>
    uartputc(*p);
}
80105f35:	83 c4 1c             	add    $0x1c,%esp
80105f38:	5b                   	pop    %ebx
80105f39:	5e                   	pop    %esi
80105f3a:	5f                   	pop    %edi
80105f3b:	5d                   	pop    %ebp
80105f3c:	c3                   	ret    
80105f3d:	00 00                	add    %al,(%eax)
	...

80105f40 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $0
80105f42:	6a 00                	push   $0x0
  jmp alltraps
80105f44:	e9 57 fb ff ff       	jmp    80105aa0 <alltraps>

80105f49 <vector1>:
.globl vector1
vector1:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $1
80105f4b:	6a 01                	push   $0x1
  jmp alltraps
80105f4d:	e9 4e fb ff ff       	jmp    80105aa0 <alltraps>

80105f52 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $2
80105f54:	6a 02                	push   $0x2
  jmp alltraps
80105f56:	e9 45 fb ff ff       	jmp    80105aa0 <alltraps>

80105f5b <vector3>:
.globl vector3
vector3:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $3
80105f5d:	6a 03                	push   $0x3
  jmp alltraps
80105f5f:	e9 3c fb ff ff       	jmp    80105aa0 <alltraps>

80105f64 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $4
80105f66:	6a 04                	push   $0x4
  jmp alltraps
80105f68:	e9 33 fb ff ff       	jmp    80105aa0 <alltraps>

80105f6d <vector5>:
.globl vector5
vector5:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $5
80105f6f:	6a 05                	push   $0x5
  jmp alltraps
80105f71:	e9 2a fb ff ff       	jmp    80105aa0 <alltraps>

80105f76 <vector6>:
.globl vector6
vector6:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $6
80105f78:	6a 06                	push   $0x6
  jmp alltraps
80105f7a:	e9 21 fb ff ff       	jmp    80105aa0 <alltraps>

80105f7f <vector7>:
.globl vector7
vector7:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $7
80105f81:	6a 07                	push   $0x7
  jmp alltraps
80105f83:	e9 18 fb ff ff       	jmp    80105aa0 <alltraps>

80105f88 <vector8>:
.globl vector8
vector8:
  pushl $8
80105f88:	6a 08                	push   $0x8
  jmp alltraps
80105f8a:	e9 11 fb ff ff       	jmp    80105aa0 <alltraps>

80105f8f <vector9>:
.globl vector9
vector9:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $9
80105f91:	6a 09                	push   $0x9
  jmp alltraps
80105f93:	e9 08 fb ff ff       	jmp    80105aa0 <alltraps>

80105f98 <vector10>:
.globl vector10
vector10:
  pushl $10
80105f98:	6a 0a                	push   $0xa
  jmp alltraps
80105f9a:	e9 01 fb ff ff       	jmp    80105aa0 <alltraps>

80105f9f <vector11>:
.globl vector11
vector11:
  pushl $11
80105f9f:	6a 0b                	push   $0xb
  jmp alltraps
80105fa1:	e9 fa fa ff ff       	jmp    80105aa0 <alltraps>

80105fa6 <vector12>:
.globl vector12
vector12:
  pushl $12
80105fa6:	6a 0c                	push   $0xc
  jmp alltraps
80105fa8:	e9 f3 fa ff ff       	jmp    80105aa0 <alltraps>

80105fad <vector13>:
.globl vector13
vector13:
  pushl $13
80105fad:	6a 0d                	push   $0xd
  jmp alltraps
80105faf:	e9 ec fa ff ff       	jmp    80105aa0 <alltraps>

80105fb4 <vector14>:
.globl vector14
vector14:
  pushl $14
80105fb4:	6a 0e                	push   $0xe
  jmp alltraps
80105fb6:	e9 e5 fa ff ff       	jmp    80105aa0 <alltraps>

80105fbb <vector15>:
.globl vector15
vector15:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $15
80105fbd:	6a 0f                	push   $0xf
  jmp alltraps
80105fbf:	e9 dc fa ff ff       	jmp    80105aa0 <alltraps>

80105fc4 <vector16>:
.globl vector16
vector16:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $16
80105fc6:	6a 10                	push   $0x10
  jmp alltraps
80105fc8:	e9 d3 fa ff ff       	jmp    80105aa0 <alltraps>

80105fcd <vector17>:
.globl vector17
vector17:
  pushl $17
80105fcd:	6a 11                	push   $0x11
  jmp alltraps
80105fcf:	e9 cc fa ff ff       	jmp    80105aa0 <alltraps>

80105fd4 <vector18>:
.globl vector18
vector18:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $18
80105fd6:	6a 12                	push   $0x12
  jmp alltraps
80105fd8:	e9 c3 fa ff ff       	jmp    80105aa0 <alltraps>

80105fdd <vector19>:
.globl vector19
vector19:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $19
80105fdf:	6a 13                	push   $0x13
  jmp alltraps
80105fe1:	e9 ba fa ff ff       	jmp    80105aa0 <alltraps>

80105fe6 <vector20>:
.globl vector20
vector20:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $20
80105fe8:	6a 14                	push   $0x14
  jmp alltraps
80105fea:	e9 b1 fa ff ff       	jmp    80105aa0 <alltraps>

80105fef <vector21>:
.globl vector21
vector21:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $21
80105ff1:	6a 15                	push   $0x15
  jmp alltraps
80105ff3:	e9 a8 fa ff ff       	jmp    80105aa0 <alltraps>

80105ff8 <vector22>:
.globl vector22
vector22:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $22
80105ffa:	6a 16                	push   $0x16
  jmp alltraps
80105ffc:	e9 9f fa ff ff       	jmp    80105aa0 <alltraps>

80106001 <vector23>:
.globl vector23
vector23:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $23
80106003:	6a 17                	push   $0x17
  jmp alltraps
80106005:	e9 96 fa ff ff       	jmp    80105aa0 <alltraps>

8010600a <vector24>:
.globl vector24
vector24:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $24
8010600c:	6a 18                	push   $0x18
  jmp alltraps
8010600e:	e9 8d fa ff ff       	jmp    80105aa0 <alltraps>

80106013 <vector25>:
.globl vector25
vector25:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $25
80106015:	6a 19                	push   $0x19
  jmp alltraps
80106017:	e9 84 fa ff ff       	jmp    80105aa0 <alltraps>

8010601c <vector26>:
.globl vector26
vector26:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $26
8010601e:	6a 1a                	push   $0x1a
  jmp alltraps
80106020:	e9 7b fa ff ff       	jmp    80105aa0 <alltraps>

80106025 <vector27>:
.globl vector27
vector27:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $27
80106027:	6a 1b                	push   $0x1b
  jmp alltraps
80106029:	e9 72 fa ff ff       	jmp    80105aa0 <alltraps>

8010602e <vector28>:
.globl vector28
vector28:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $28
80106030:	6a 1c                	push   $0x1c
  jmp alltraps
80106032:	e9 69 fa ff ff       	jmp    80105aa0 <alltraps>

80106037 <vector29>:
.globl vector29
vector29:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $29
80106039:	6a 1d                	push   $0x1d
  jmp alltraps
8010603b:	e9 60 fa ff ff       	jmp    80105aa0 <alltraps>

80106040 <vector30>:
.globl vector30
vector30:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $30
80106042:	6a 1e                	push   $0x1e
  jmp alltraps
80106044:	e9 57 fa ff ff       	jmp    80105aa0 <alltraps>

80106049 <vector31>:
.globl vector31
vector31:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $31
8010604b:	6a 1f                	push   $0x1f
  jmp alltraps
8010604d:	e9 4e fa ff ff       	jmp    80105aa0 <alltraps>

80106052 <vector32>:
.globl vector32
vector32:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $32
80106054:	6a 20                	push   $0x20
  jmp alltraps
80106056:	e9 45 fa ff ff       	jmp    80105aa0 <alltraps>

8010605b <vector33>:
.globl vector33
vector33:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $33
8010605d:	6a 21                	push   $0x21
  jmp alltraps
8010605f:	e9 3c fa ff ff       	jmp    80105aa0 <alltraps>

80106064 <vector34>:
.globl vector34
vector34:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $34
80106066:	6a 22                	push   $0x22
  jmp alltraps
80106068:	e9 33 fa ff ff       	jmp    80105aa0 <alltraps>

8010606d <vector35>:
.globl vector35
vector35:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $35
8010606f:	6a 23                	push   $0x23
  jmp alltraps
80106071:	e9 2a fa ff ff       	jmp    80105aa0 <alltraps>

80106076 <vector36>:
.globl vector36
vector36:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $36
80106078:	6a 24                	push   $0x24
  jmp alltraps
8010607a:	e9 21 fa ff ff       	jmp    80105aa0 <alltraps>

8010607f <vector37>:
.globl vector37
vector37:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $37
80106081:	6a 25                	push   $0x25
  jmp alltraps
80106083:	e9 18 fa ff ff       	jmp    80105aa0 <alltraps>

80106088 <vector38>:
.globl vector38
vector38:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $38
8010608a:	6a 26                	push   $0x26
  jmp alltraps
8010608c:	e9 0f fa ff ff       	jmp    80105aa0 <alltraps>

80106091 <vector39>:
.globl vector39
vector39:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $39
80106093:	6a 27                	push   $0x27
  jmp alltraps
80106095:	e9 06 fa ff ff       	jmp    80105aa0 <alltraps>

8010609a <vector40>:
.globl vector40
vector40:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $40
8010609c:	6a 28                	push   $0x28
  jmp alltraps
8010609e:	e9 fd f9 ff ff       	jmp    80105aa0 <alltraps>

801060a3 <vector41>:
.globl vector41
vector41:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $41
801060a5:	6a 29                	push   $0x29
  jmp alltraps
801060a7:	e9 f4 f9 ff ff       	jmp    80105aa0 <alltraps>

801060ac <vector42>:
.globl vector42
vector42:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $42
801060ae:	6a 2a                	push   $0x2a
  jmp alltraps
801060b0:	e9 eb f9 ff ff       	jmp    80105aa0 <alltraps>

801060b5 <vector43>:
.globl vector43
vector43:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $43
801060b7:	6a 2b                	push   $0x2b
  jmp alltraps
801060b9:	e9 e2 f9 ff ff       	jmp    80105aa0 <alltraps>

801060be <vector44>:
.globl vector44
vector44:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $44
801060c0:	6a 2c                	push   $0x2c
  jmp alltraps
801060c2:	e9 d9 f9 ff ff       	jmp    80105aa0 <alltraps>

801060c7 <vector45>:
.globl vector45
vector45:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $45
801060c9:	6a 2d                	push   $0x2d
  jmp alltraps
801060cb:	e9 d0 f9 ff ff       	jmp    80105aa0 <alltraps>

801060d0 <vector46>:
.globl vector46
vector46:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $46
801060d2:	6a 2e                	push   $0x2e
  jmp alltraps
801060d4:	e9 c7 f9 ff ff       	jmp    80105aa0 <alltraps>

801060d9 <vector47>:
.globl vector47
vector47:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $47
801060db:	6a 2f                	push   $0x2f
  jmp alltraps
801060dd:	e9 be f9 ff ff       	jmp    80105aa0 <alltraps>

801060e2 <vector48>:
.globl vector48
vector48:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $48
801060e4:	6a 30                	push   $0x30
  jmp alltraps
801060e6:	e9 b5 f9 ff ff       	jmp    80105aa0 <alltraps>

801060eb <vector49>:
.globl vector49
vector49:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $49
801060ed:	6a 31                	push   $0x31
  jmp alltraps
801060ef:	e9 ac f9 ff ff       	jmp    80105aa0 <alltraps>

801060f4 <vector50>:
.globl vector50
vector50:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $50
801060f6:	6a 32                	push   $0x32
  jmp alltraps
801060f8:	e9 a3 f9 ff ff       	jmp    80105aa0 <alltraps>

801060fd <vector51>:
.globl vector51
vector51:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $51
801060ff:	6a 33                	push   $0x33
  jmp alltraps
80106101:	e9 9a f9 ff ff       	jmp    80105aa0 <alltraps>

80106106 <vector52>:
.globl vector52
vector52:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $52
80106108:	6a 34                	push   $0x34
  jmp alltraps
8010610a:	e9 91 f9 ff ff       	jmp    80105aa0 <alltraps>

8010610f <vector53>:
.globl vector53
vector53:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $53
80106111:	6a 35                	push   $0x35
  jmp alltraps
80106113:	e9 88 f9 ff ff       	jmp    80105aa0 <alltraps>

80106118 <vector54>:
.globl vector54
vector54:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $54
8010611a:	6a 36                	push   $0x36
  jmp alltraps
8010611c:	e9 7f f9 ff ff       	jmp    80105aa0 <alltraps>

80106121 <vector55>:
.globl vector55
vector55:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $55
80106123:	6a 37                	push   $0x37
  jmp alltraps
80106125:	e9 76 f9 ff ff       	jmp    80105aa0 <alltraps>

8010612a <vector56>:
.globl vector56
vector56:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $56
8010612c:	6a 38                	push   $0x38
  jmp alltraps
8010612e:	e9 6d f9 ff ff       	jmp    80105aa0 <alltraps>

80106133 <vector57>:
.globl vector57
vector57:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $57
80106135:	6a 39                	push   $0x39
  jmp alltraps
80106137:	e9 64 f9 ff ff       	jmp    80105aa0 <alltraps>

8010613c <vector58>:
.globl vector58
vector58:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $58
8010613e:	6a 3a                	push   $0x3a
  jmp alltraps
80106140:	e9 5b f9 ff ff       	jmp    80105aa0 <alltraps>

80106145 <vector59>:
.globl vector59
vector59:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $59
80106147:	6a 3b                	push   $0x3b
  jmp alltraps
80106149:	e9 52 f9 ff ff       	jmp    80105aa0 <alltraps>

8010614e <vector60>:
.globl vector60
vector60:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $60
80106150:	6a 3c                	push   $0x3c
  jmp alltraps
80106152:	e9 49 f9 ff ff       	jmp    80105aa0 <alltraps>

80106157 <vector61>:
.globl vector61
vector61:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $61
80106159:	6a 3d                	push   $0x3d
  jmp alltraps
8010615b:	e9 40 f9 ff ff       	jmp    80105aa0 <alltraps>

80106160 <vector62>:
.globl vector62
vector62:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $62
80106162:	6a 3e                	push   $0x3e
  jmp alltraps
80106164:	e9 37 f9 ff ff       	jmp    80105aa0 <alltraps>

80106169 <vector63>:
.globl vector63
vector63:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $63
8010616b:	6a 3f                	push   $0x3f
  jmp alltraps
8010616d:	e9 2e f9 ff ff       	jmp    80105aa0 <alltraps>

80106172 <vector64>:
.globl vector64
vector64:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $64
80106174:	6a 40                	push   $0x40
  jmp alltraps
80106176:	e9 25 f9 ff ff       	jmp    80105aa0 <alltraps>

8010617b <vector65>:
.globl vector65
vector65:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $65
8010617d:	6a 41                	push   $0x41
  jmp alltraps
8010617f:	e9 1c f9 ff ff       	jmp    80105aa0 <alltraps>

80106184 <vector66>:
.globl vector66
vector66:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $66
80106186:	6a 42                	push   $0x42
  jmp alltraps
80106188:	e9 13 f9 ff ff       	jmp    80105aa0 <alltraps>

8010618d <vector67>:
.globl vector67
vector67:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $67
8010618f:	6a 43                	push   $0x43
  jmp alltraps
80106191:	e9 0a f9 ff ff       	jmp    80105aa0 <alltraps>

80106196 <vector68>:
.globl vector68
vector68:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $68
80106198:	6a 44                	push   $0x44
  jmp alltraps
8010619a:	e9 01 f9 ff ff       	jmp    80105aa0 <alltraps>

8010619f <vector69>:
.globl vector69
vector69:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $69
801061a1:	6a 45                	push   $0x45
  jmp alltraps
801061a3:	e9 f8 f8 ff ff       	jmp    80105aa0 <alltraps>

801061a8 <vector70>:
.globl vector70
vector70:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $70
801061aa:	6a 46                	push   $0x46
  jmp alltraps
801061ac:	e9 ef f8 ff ff       	jmp    80105aa0 <alltraps>

801061b1 <vector71>:
.globl vector71
vector71:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $71
801061b3:	6a 47                	push   $0x47
  jmp alltraps
801061b5:	e9 e6 f8 ff ff       	jmp    80105aa0 <alltraps>

801061ba <vector72>:
.globl vector72
vector72:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $72
801061bc:	6a 48                	push   $0x48
  jmp alltraps
801061be:	e9 dd f8 ff ff       	jmp    80105aa0 <alltraps>

801061c3 <vector73>:
.globl vector73
vector73:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $73
801061c5:	6a 49                	push   $0x49
  jmp alltraps
801061c7:	e9 d4 f8 ff ff       	jmp    80105aa0 <alltraps>

801061cc <vector74>:
.globl vector74
vector74:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $74
801061ce:	6a 4a                	push   $0x4a
  jmp alltraps
801061d0:	e9 cb f8 ff ff       	jmp    80105aa0 <alltraps>

801061d5 <vector75>:
.globl vector75
vector75:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $75
801061d7:	6a 4b                	push   $0x4b
  jmp alltraps
801061d9:	e9 c2 f8 ff ff       	jmp    80105aa0 <alltraps>

801061de <vector76>:
.globl vector76
vector76:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $76
801061e0:	6a 4c                	push   $0x4c
  jmp alltraps
801061e2:	e9 b9 f8 ff ff       	jmp    80105aa0 <alltraps>

801061e7 <vector77>:
.globl vector77
vector77:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $77
801061e9:	6a 4d                	push   $0x4d
  jmp alltraps
801061eb:	e9 b0 f8 ff ff       	jmp    80105aa0 <alltraps>

801061f0 <vector78>:
.globl vector78
vector78:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $78
801061f2:	6a 4e                	push   $0x4e
  jmp alltraps
801061f4:	e9 a7 f8 ff ff       	jmp    80105aa0 <alltraps>

801061f9 <vector79>:
.globl vector79
vector79:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $79
801061fb:	6a 4f                	push   $0x4f
  jmp alltraps
801061fd:	e9 9e f8 ff ff       	jmp    80105aa0 <alltraps>

80106202 <vector80>:
.globl vector80
vector80:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $80
80106204:	6a 50                	push   $0x50
  jmp alltraps
80106206:	e9 95 f8 ff ff       	jmp    80105aa0 <alltraps>

8010620b <vector81>:
.globl vector81
vector81:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $81
8010620d:	6a 51                	push   $0x51
  jmp alltraps
8010620f:	e9 8c f8 ff ff       	jmp    80105aa0 <alltraps>

80106214 <vector82>:
.globl vector82
vector82:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $82
80106216:	6a 52                	push   $0x52
  jmp alltraps
80106218:	e9 83 f8 ff ff       	jmp    80105aa0 <alltraps>

8010621d <vector83>:
.globl vector83
vector83:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $83
8010621f:	6a 53                	push   $0x53
  jmp alltraps
80106221:	e9 7a f8 ff ff       	jmp    80105aa0 <alltraps>

80106226 <vector84>:
.globl vector84
vector84:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $84
80106228:	6a 54                	push   $0x54
  jmp alltraps
8010622a:	e9 71 f8 ff ff       	jmp    80105aa0 <alltraps>

8010622f <vector85>:
.globl vector85
vector85:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $85
80106231:	6a 55                	push   $0x55
  jmp alltraps
80106233:	e9 68 f8 ff ff       	jmp    80105aa0 <alltraps>

80106238 <vector86>:
.globl vector86
vector86:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $86
8010623a:	6a 56                	push   $0x56
  jmp alltraps
8010623c:	e9 5f f8 ff ff       	jmp    80105aa0 <alltraps>

80106241 <vector87>:
.globl vector87
vector87:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $87
80106243:	6a 57                	push   $0x57
  jmp alltraps
80106245:	e9 56 f8 ff ff       	jmp    80105aa0 <alltraps>

8010624a <vector88>:
.globl vector88
vector88:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $88
8010624c:	6a 58                	push   $0x58
  jmp alltraps
8010624e:	e9 4d f8 ff ff       	jmp    80105aa0 <alltraps>

80106253 <vector89>:
.globl vector89
vector89:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $89
80106255:	6a 59                	push   $0x59
  jmp alltraps
80106257:	e9 44 f8 ff ff       	jmp    80105aa0 <alltraps>

8010625c <vector90>:
.globl vector90
vector90:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $90
8010625e:	6a 5a                	push   $0x5a
  jmp alltraps
80106260:	e9 3b f8 ff ff       	jmp    80105aa0 <alltraps>

80106265 <vector91>:
.globl vector91
vector91:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $91
80106267:	6a 5b                	push   $0x5b
  jmp alltraps
80106269:	e9 32 f8 ff ff       	jmp    80105aa0 <alltraps>

8010626e <vector92>:
.globl vector92
vector92:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $92
80106270:	6a 5c                	push   $0x5c
  jmp alltraps
80106272:	e9 29 f8 ff ff       	jmp    80105aa0 <alltraps>

80106277 <vector93>:
.globl vector93
vector93:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $93
80106279:	6a 5d                	push   $0x5d
  jmp alltraps
8010627b:	e9 20 f8 ff ff       	jmp    80105aa0 <alltraps>

80106280 <vector94>:
.globl vector94
vector94:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $94
80106282:	6a 5e                	push   $0x5e
  jmp alltraps
80106284:	e9 17 f8 ff ff       	jmp    80105aa0 <alltraps>

80106289 <vector95>:
.globl vector95
vector95:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $95
8010628b:	6a 5f                	push   $0x5f
  jmp alltraps
8010628d:	e9 0e f8 ff ff       	jmp    80105aa0 <alltraps>

80106292 <vector96>:
.globl vector96
vector96:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $96
80106294:	6a 60                	push   $0x60
  jmp alltraps
80106296:	e9 05 f8 ff ff       	jmp    80105aa0 <alltraps>

8010629b <vector97>:
.globl vector97
vector97:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $97
8010629d:	6a 61                	push   $0x61
  jmp alltraps
8010629f:	e9 fc f7 ff ff       	jmp    80105aa0 <alltraps>

801062a4 <vector98>:
.globl vector98
vector98:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $98
801062a6:	6a 62                	push   $0x62
  jmp alltraps
801062a8:	e9 f3 f7 ff ff       	jmp    80105aa0 <alltraps>

801062ad <vector99>:
.globl vector99
vector99:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $99
801062af:	6a 63                	push   $0x63
  jmp alltraps
801062b1:	e9 ea f7 ff ff       	jmp    80105aa0 <alltraps>

801062b6 <vector100>:
.globl vector100
vector100:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $100
801062b8:	6a 64                	push   $0x64
  jmp alltraps
801062ba:	e9 e1 f7 ff ff       	jmp    80105aa0 <alltraps>

801062bf <vector101>:
.globl vector101
vector101:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $101
801062c1:	6a 65                	push   $0x65
  jmp alltraps
801062c3:	e9 d8 f7 ff ff       	jmp    80105aa0 <alltraps>

801062c8 <vector102>:
.globl vector102
vector102:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $102
801062ca:	6a 66                	push   $0x66
  jmp alltraps
801062cc:	e9 cf f7 ff ff       	jmp    80105aa0 <alltraps>

801062d1 <vector103>:
.globl vector103
vector103:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $103
801062d3:	6a 67                	push   $0x67
  jmp alltraps
801062d5:	e9 c6 f7 ff ff       	jmp    80105aa0 <alltraps>

801062da <vector104>:
.globl vector104
vector104:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $104
801062dc:	6a 68                	push   $0x68
  jmp alltraps
801062de:	e9 bd f7 ff ff       	jmp    80105aa0 <alltraps>

801062e3 <vector105>:
.globl vector105
vector105:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $105
801062e5:	6a 69                	push   $0x69
  jmp alltraps
801062e7:	e9 b4 f7 ff ff       	jmp    80105aa0 <alltraps>

801062ec <vector106>:
.globl vector106
vector106:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $106
801062ee:	6a 6a                	push   $0x6a
  jmp alltraps
801062f0:	e9 ab f7 ff ff       	jmp    80105aa0 <alltraps>

801062f5 <vector107>:
.globl vector107
vector107:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $107
801062f7:	6a 6b                	push   $0x6b
  jmp alltraps
801062f9:	e9 a2 f7 ff ff       	jmp    80105aa0 <alltraps>

801062fe <vector108>:
.globl vector108
vector108:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $108
80106300:	6a 6c                	push   $0x6c
  jmp alltraps
80106302:	e9 99 f7 ff ff       	jmp    80105aa0 <alltraps>

80106307 <vector109>:
.globl vector109
vector109:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $109
80106309:	6a 6d                	push   $0x6d
  jmp alltraps
8010630b:	e9 90 f7 ff ff       	jmp    80105aa0 <alltraps>

80106310 <vector110>:
.globl vector110
vector110:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $110
80106312:	6a 6e                	push   $0x6e
  jmp alltraps
80106314:	e9 87 f7 ff ff       	jmp    80105aa0 <alltraps>

80106319 <vector111>:
.globl vector111
vector111:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $111
8010631b:	6a 6f                	push   $0x6f
  jmp alltraps
8010631d:	e9 7e f7 ff ff       	jmp    80105aa0 <alltraps>

80106322 <vector112>:
.globl vector112
vector112:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $112
80106324:	6a 70                	push   $0x70
  jmp alltraps
80106326:	e9 75 f7 ff ff       	jmp    80105aa0 <alltraps>

8010632b <vector113>:
.globl vector113
vector113:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $113
8010632d:	6a 71                	push   $0x71
  jmp alltraps
8010632f:	e9 6c f7 ff ff       	jmp    80105aa0 <alltraps>

80106334 <vector114>:
.globl vector114
vector114:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $114
80106336:	6a 72                	push   $0x72
  jmp alltraps
80106338:	e9 63 f7 ff ff       	jmp    80105aa0 <alltraps>

8010633d <vector115>:
.globl vector115
vector115:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $115
8010633f:	6a 73                	push   $0x73
  jmp alltraps
80106341:	e9 5a f7 ff ff       	jmp    80105aa0 <alltraps>

80106346 <vector116>:
.globl vector116
vector116:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $116
80106348:	6a 74                	push   $0x74
  jmp alltraps
8010634a:	e9 51 f7 ff ff       	jmp    80105aa0 <alltraps>

8010634f <vector117>:
.globl vector117
vector117:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $117
80106351:	6a 75                	push   $0x75
  jmp alltraps
80106353:	e9 48 f7 ff ff       	jmp    80105aa0 <alltraps>

80106358 <vector118>:
.globl vector118
vector118:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $118
8010635a:	6a 76                	push   $0x76
  jmp alltraps
8010635c:	e9 3f f7 ff ff       	jmp    80105aa0 <alltraps>

80106361 <vector119>:
.globl vector119
vector119:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $119
80106363:	6a 77                	push   $0x77
  jmp alltraps
80106365:	e9 36 f7 ff ff       	jmp    80105aa0 <alltraps>

8010636a <vector120>:
.globl vector120
vector120:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $120
8010636c:	6a 78                	push   $0x78
  jmp alltraps
8010636e:	e9 2d f7 ff ff       	jmp    80105aa0 <alltraps>

80106373 <vector121>:
.globl vector121
vector121:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $121
80106375:	6a 79                	push   $0x79
  jmp alltraps
80106377:	e9 24 f7 ff ff       	jmp    80105aa0 <alltraps>

8010637c <vector122>:
.globl vector122
vector122:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $122
8010637e:	6a 7a                	push   $0x7a
  jmp alltraps
80106380:	e9 1b f7 ff ff       	jmp    80105aa0 <alltraps>

80106385 <vector123>:
.globl vector123
vector123:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $123
80106387:	6a 7b                	push   $0x7b
  jmp alltraps
80106389:	e9 12 f7 ff ff       	jmp    80105aa0 <alltraps>

8010638e <vector124>:
.globl vector124
vector124:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $124
80106390:	6a 7c                	push   $0x7c
  jmp alltraps
80106392:	e9 09 f7 ff ff       	jmp    80105aa0 <alltraps>

80106397 <vector125>:
.globl vector125
vector125:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $125
80106399:	6a 7d                	push   $0x7d
  jmp alltraps
8010639b:	e9 00 f7 ff ff       	jmp    80105aa0 <alltraps>

801063a0 <vector126>:
.globl vector126
vector126:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $126
801063a2:	6a 7e                	push   $0x7e
  jmp alltraps
801063a4:	e9 f7 f6 ff ff       	jmp    80105aa0 <alltraps>

801063a9 <vector127>:
.globl vector127
vector127:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $127
801063ab:	6a 7f                	push   $0x7f
  jmp alltraps
801063ad:	e9 ee f6 ff ff       	jmp    80105aa0 <alltraps>

801063b2 <vector128>:
.globl vector128
vector128:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $128
801063b4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801063b9:	e9 e2 f6 ff ff       	jmp    80105aa0 <alltraps>

801063be <vector129>:
.globl vector129
vector129:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $129
801063c0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801063c5:	e9 d6 f6 ff ff       	jmp    80105aa0 <alltraps>

801063ca <vector130>:
.globl vector130
vector130:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $130
801063cc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801063d1:	e9 ca f6 ff ff       	jmp    80105aa0 <alltraps>

801063d6 <vector131>:
.globl vector131
vector131:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $131
801063d8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063dd:	e9 be f6 ff ff       	jmp    80105aa0 <alltraps>

801063e2 <vector132>:
.globl vector132
vector132:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $132
801063e4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063e9:	e9 b2 f6 ff ff       	jmp    80105aa0 <alltraps>

801063ee <vector133>:
.globl vector133
vector133:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $133
801063f0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063f5:	e9 a6 f6 ff ff       	jmp    80105aa0 <alltraps>

801063fa <vector134>:
.globl vector134
vector134:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $134
801063fc:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106401:	e9 9a f6 ff ff       	jmp    80105aa0 <alltraps>

80106406 <vector135>:
.globl vector135
vector135:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $135
80106408:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010640d:	e9 8e f6 ff ff       	jmp    80105aa0 <alltraps>

80106412 <vector136>:
.globl vector136
vector136:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $136
80106414:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106419:	e9 82 f6 ff ff       	jmp    80105aa0 <alltraps>

8010641e <vector137>:
.globl vector137
vector137:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $137
80106420:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106425:	e9 76 f6 ff ff       	jmp    80105aa0 <alltraps>

8010642a <vector138>:
.globl vector138
vector138:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $138
8010642c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106431:	e9 6a f6 ff ff       	jmp    80105aa0 <alltraps>

80106436 <vector139>:
.globl vector139
vector139:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $139
80106438:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010643d:	e9 5e f6 ff ff       	jmp    80105aa0 <alltraps>

80106442 <vector140>:
.globl vector140
vector140:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $140
80106444:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106449:	e9 52 f6 ff ff       	jmp    80105aa0 <alltraps>

8010644e <vector141>:
.globl vector141
vector141:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $141
80106450:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106455:	e9 46 f6 ff ff       	jmp    80105aa0 <alltraps>

8010645a <vector142>:
.globl vector142
vector142:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $142
8010645c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106461:	e9 3a f6 ff ff       	jmp    80105aa0 <alltraps>

80106466 <vector143>:
.globl vector143
vector143:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $143
80106468:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010646d:	e9 2e f6 ff ff       	jmp    80105aa0 <alltraps>

80106472 <vector144>:
.globl vector144
vector144:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $144
80106474:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106479:	e9 22 f6 ff ff       	jmp    80105aa0 <alltraps>

8010647e <vector145>:
.globl vector145
vector145:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $145
80106480:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106485:	e9 16 f6 ff ff       	jmp    80105aa0 <alltraps>

8010648a <vector146>:
.globl vector146
vector146:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $146
8010648c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106491:	e9 0a f6 ff ff       	jmp    80105aa0 <alltraps>

80106496 <vector147>:
.globl vector147
vector147:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $147
80106498:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010649d:	e9 fe f5 ff ff       	jmp    80105aa0 <alltraps>

801064a2 <vector148>:
.globl vector148
vector148:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $148
801064a4:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064a9:	e9 f2 f5 ff ff       	jmp    80105aa0 <alltraps>

801064ae <vector149>:
.globl vector149
vector149:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $149
801064b0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801064b5:	e9 e6 f5 ff ff       	jmp    80105aa0 <alltraps>

801064ba <vector150>:
.globl vector150
vector150:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $150
801064bc:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801064c1:	e9 da f5 ff ff       	jmp    80105aa0 <alltraps>

801064c6 <vector151>:
.globl vector151
vector151:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $151
801064c8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801064cd:	e9 ce f5 ff ff       	jmp    80105aa0 <alltraps>

801064d2 <vector152>:
.globl vector152
vector152:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $152
801064d4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801064d9:	e9 c2 f5 ff ff       	jmp    80105aa0 <alltraps>

801064de <vector153>:
.globl vector153
vector153:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $153
801064e0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064e5:	e9 b6 f5 ff ff       	jmp    80105aa0 <alltraps>

801064ea <vector154>:
.globl vector154
vector154:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $154
801064ec:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064f1:	e9 aa f5 ff ff       	jmp    80105aa0 <alltraps>

801064f6 <vector155>:
.globl vector155
vector155:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $155
801064f8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801064fd:	e9 9e f5 ff ff       	jmp    80105aa0 <alltraps>

80106502 <vector156>:
.globl vector156
vector156:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $156
80106504:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106509:	e9 92 f5 ff ff       	jmp    80105aa0 <alltraps>

8010650e <vector157>:
.globl vector157
vector157:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $157
80106510:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106515:	e9 86 f5 ff ff       	jmp    80105aa0 <alltraps>

8010651a <vector158>:
.globl vector158
vector158:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $158
8010651c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106521:	e9 7a f5 ff ff       	jmp    80105aa0 <alltraps>

80106526 <vector159>:
.globl vector159
vector159:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $159
80106528:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010652d:	e9 6e f5 ff ff       	jmp    80105aa0 <alltraps>

80106532 <vector160>:
.globl vector160
vector160:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $160
80106534:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106539:	e9 62 f5 ff ff       	jmp    80105aa0 <alltraps>

8010653e <vector161>:
.globl vector161
vector161:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $161
80106540:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106545:	e9 56 f5 ff ff       	jmp    80105aa0 <alltraps>

8010654a <vector162>:
.globl vector162
vector162:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $162
8010654c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106551:	e9 4a f5 ff ff       	jmp    80105aa0 <alltraps>

80106556 <vector163>:
.globl vector163
vector163:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $163
80106558:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010655d:	e9 3e f5 ff ff       	jmp    80105aa0 <alltraps>

80106562 <vector164>:
.globl vector164
vector164:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $164
80106564:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106569:	e9 32 f5 ff ff       	jmp    80105aa0 <alltraps>

8010656e <vector165>:
.globl vector165
vector165:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $165
80106570:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106575:	e9 26 f5 ff ff       	jmp    80105aa0 <alltraps>

8010657a <vector166>:
.globl vector166
vector166:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $166
8010657c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106581:	e9 1a f5 ff ff       	jmp    80105aa0 <alltraps>

80106586 <vector167>:
.globl vector167
vector167:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $167
80106588:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010658d:	e9 0e f5 ff ff       	jmp    80105aa0 <alltraps>

80106592 <vector168>:
.globl vector168
vector168:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $168
80106594:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106599:	e9 02 f5 ff ff       	jmp    80105aa0 <alltraps>

8010659e <vector169>:
.globl vector169
vector169:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $169
801065a0:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065a5:	e9 f6 f4 ff ff       	jmp    80105aa0 <alltraps>

801065aa <vector170>:
.globl vector170
vector170:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $170
801065ac:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801065b1:	e9 ea f4 ff ff       	jmp    80105aa0 <alltraps>

801065b6 <vector171>:
.globl vector171
vector171:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $171
801065b8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801065bd:	e9 de f4 ff ff       	jmp    80105aa0 <alltraps>

801065c2 <vector172>:
.globl vector172
vector172:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $172
801065c4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801065c9:	e9 d2 f4 ff ff       	jmp    80105aa0 <alltraps>

801065ce <vector173>:
.globl vector173
vector173:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $173
801065d0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801065d5:	e9 c6 f4 ff ff       	jmp    80105aa0 <alltraps>

801065da <vector174>:
.globl vector174
vector174:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $174
801065dc:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065e1:	e9 ba f4 ff ff       	jmp    80105aa0 <alltraps>

801065e6 <vector175>:
.globl vector175
vector175:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $175
801065e8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065ed:	e9 ae f4 ff ff       	jmp    80105aa0 <alltraps>

801065f2 <vector176>:
.globl vector176
vector176:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $176
801065f4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065f9:	e9 a2 f4 ff ff       	jmp    80105aa0 <alltraps>

801065fe <vector177>:
.globl vector177
vector177:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $177
80106600:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106605:	e9 96 f4 ff ff       	jmp    80105aa0 <alltraps>

8010660a <vector178>:
.globl vector178
vector178:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $178
8010660c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106611:	e9 8a f4 ff ff       	jmp    80105aa0 <alltraps>

80106616 <vector179>:
.globl vector179
vector179:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $179
80106618:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010661d:	e9 7e f4 ff ff       	jmp    80105aa0 <alltraps>

80106622 <vector180>:
.globl vector180
vector180:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $180
80106624:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106629:	e9 72 f4 ff ff       	jmp    80105aa0 <alltraps>

8010662e <vector181>:
.globl vector181
vector181:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $181
80106630:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106635:	e9 66 f4 ff ff       	jmp    80105aa0 <alltraps>

8010663a <vector182>:
.globl vector182
vector182:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $182
8010663c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106641:	e9 5a f4 ff ff       	jmp    80105aa0 <alltraps>

80106646 <vector183>:
.globl vector183
vector183:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $183
80106648:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010664d:	e9 4e f4 ff ff       	jmp    80105aa0 <alltraps>

80106652 <vector184>:
.globl vector184
vector184:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $184
80106654:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106659:	e9 42 f4 ff ff       	jmp    80105aa0 <alltraps>

8010665e <vector185>:
.globl vector185
vector185:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $185
80106660:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106665:	e9 36 f4 ff ff       	jmp    80105aa0 <alltraps>

8010666a <vector186>:
.globl vector186
vector186:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $186
8010666c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106671:	e9 2a f4 ff ff       	jmp    80105aa0 <alltraps>

80106676 <vector187>:
.globl vector187
vector187:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $187
80106678:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010667d:	e9 1e f4 ff ff       	jmp    80105aa0 <alltraps>

80106682 <vector188>:
.globl vector188
vector188:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $188
80106684:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106689:	e9 12 f4 ff ff       	jmp    80105aa0 <alltraps>

8010668e <vector189>:
.globl vector189
vector189:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $189
80106690:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106695:	e9 06 f4 ff ff       	jmp    80105aa0 <alltraps>

8010669a <vector190>:
.globl vector190
vector190:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $190
8010669c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066a1:	e9 fa f3 ff ff       	jmp    80105aa0 <alltraps>

801066a6 <vector191>:
.globl vector191
vector191:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $191
801066a8:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801066ad:	e9 ee f3 ff ff       	jmp    80105aa0 <alltraps>

801066b2 <vector192>:
.globl vector192
vector192:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $192
801066b4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801066b9:	e9 e2 f3 ff ff       	jmp    80105aa0 <alltraps>

801066be <vector193>:
.globl vector193
vector193:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $193
801066c0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801066c5:	e9 d6 f3 ff ff       	jmp    80105aa0 <alltraps>

801066ca <vector194>:
.globl vector194
vector194:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $194
801066cc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801066d1:	e9 ca f3 ff ff       	jmp    80105aa0 <alltraps>

801066d6 <vector195>:
.globl vector195
vector195:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $195
801066d8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066dd:	e9 be f3 ff ff       	jmp    80105aa0 <alltraps>

801066e2 <vector196>:
.globl vector196
vector196:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $196
801066e4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066e9:	e9 b2 f3 ff ff       	jmp    80105aa0 <alltraps>

801066ee <vector197>:
.globl vector197
vector197:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $197
801066f0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066f5:	e9 a6 f3 ff ff       	jmp    80105aa0 <alltraps>

801066fa <vector198>:
.globl vector198
vector198:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $198
801066fc:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106701:	e9 9a f3 ff ff       	jmp    80105aa0 <alltraps>

80106706 <vector199>:
.globl vector199
vector199:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $199
80106708:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010670d:	e9 8e f3 ff ff       	jmp    80105aa0 <alltraps>

80106712 <vector200>:
.globl vector200
vector200:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $200
80106714:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106719:	e9 82 f3 ff ff       	jmp    80105aa0 <alltraps>

8010671e <vector201>:
.globl vector201
vector201:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $201
80106720:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106725:	e9 76 f3 ff ff       	jmp    80105aa0 <alltraps>

8010672a <vector202>:
.globl vector202
vector202:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $202
8010672c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106731:	e9 6a f3 ff ff       	jmp    80105aa0 <alltraps>

80106736 <vector203>:
.globl vector203
vector203:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $203
80106738:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010673d:	e9 5e f3 ff ff       	jmp    80105aa0 <alltraps>

80106742 <vector204>:
.globl vector204
vector204:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $204
80106744:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106749:	e9 52 f3 ff ff       	jmp    80105aa0 <alltraps>

8010674e <vector205>:
.globl vector205
vector205:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $205
80106750:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106755:	e9 46 f3 ff ff       	jmp    80105aa0 <alltraps>

8010675a <vector206>:
.globl vector206
vector206:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $206
8010675c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106761:	e9 3a f3 ff ff       	jmp    80105aa0 <alltraps>

80106766 <vector207>:
.globl vector207
vector207:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $207
80106768:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010676d:	e9 2e f3 ff ff       	jmp    80105aa0 <alltraps>

80106772 <vector208>:
.globl vector208
vector208:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $208
80106774:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106779:	e9 22 f3 ff ff       	jmp    80105aa0 <alltraps>

8010677e <vector209>:
.globl vector209
vector209:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $209
80106780:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106785:	e9 16 f3 ff ff       	jmp    80105aa0 <alltraps>

8010678a <vector210>:
.globl vector210
vector210:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $210
8010678c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106791:	e9 0a f3 ff ff       	jmp    80105aa0 <alltraps>

80106796 <vector211>:
.globl vector211
vector211:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $211
80106798:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010679d:	e9 fe f2 ff ff       	jmp    80105aa0 <alltraps>

801067a2 <vector212>:
.globl vector212
vector212:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $212
801067a4:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067a9:	e9 f2 f2 ff ff       	jmp    80105aa0 <alltraps>

801067ae <vector213>:
.globl vector213
vector213:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $213
801067b0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801067b5:	e9 e6 f2 ff ff       	jmp    80105aa0 <alltraps>

801067ba <vector214>:
.globl vector214
vector214:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $214
801067bc:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801067c1:	e9 da f2 ff ff       	jmp    80105aa0 <alltraps>

801067c6 <vector215>:
.globl vector215
vector215:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $215
801067c8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801067cd:	e9 ce f2 ff ff       	jmp    80105aa0 <alltraps>

801067d2 <vector216>:
.globl vector216
vector216:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $216
801067d4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801067d9:	e9 c2 f2 ff ff       	jmp    80105aa0 <alltraps>

801067de <vector217>:
.globl vector217
vector217:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $217
801067e0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067e5:	e9 b6 f2 ff ff       	jmp    80105aa0 <alltraps>

801067ea <vector218>:
.globl vector218
vector218:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $218
801067ec:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067f1:	e9 aa f2 ff ff       	jmp    80105aa0 <alltraps>

801067f6 <vector219>:
.globl vector219
vector219:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $219
801067f8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801067fd:	e9 9e f2 ff ff       	jmp    80105aa0 <alltraps>

80106802 <vector220>:
.globl vector220
vector220:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $220
80106804:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106809:	e9 92 f2 ff ff       	jmp    80105aa0 <alltraps>

8010680e <vector221>:
.globl vector221
vector221:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $221
80106810:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106815:	e9 86 f2 ff ff       	jmp    80105aa0 <alltraps>

8010681a <vector222>:
.globl vector222
vector222:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $222
8010681c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106821:	e9 7a f2 ff ff       	jmp    80105aa0 <alltraps>

80106826 <vector223>:
.globl vector223
vector223:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $223
80106828:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010682d:	e9 6e f2 ff ff       	jmp    80105aa0 <alltraps>

80106832 <vector224>:
.globl vector224
vector224:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $224
80106834:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106839:	e9 62 f2 ff ff       	jmp    80105aa0 <alltraps>

8010683e <vector225>:
.globl vector225
vector225:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $225
80106840:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106845:	e9 56 f2 ff ff       	jmp    80105aa0 <alltraps>

8010684a <vector226>:
.globl vector226
vector226:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $226
8010684c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106851:	e9 4a f2 ff ff       	jmp    80105aa0 <alltraps>

80106856 <vector227>:
.globl vector227
vector227:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $227
80106858:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010685d:	e9 3e f2 ff ff       	jmp    80105aa0 <alltraps>

80106862 <vector228>:
.globl vector228
vector228:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $228
80106864:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106869:	e9 32 f2 ff ff       	jmp    80105aa0 <alltraps>

8010686e <vector229>:
.globl vector229
vector229:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $229
80106870:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106875:	e9 26 f2 ff ff       	jmp    80105aa0 <alltraps>

8010687a <vector230>:
.globl vector230
vector230:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $230
8010687c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106881:	e9 1a f2 ff ff       	jmp    80105aa0 <alltraps>

80106886 <vector231>:
.globl vector231
vector231:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $231
80106888:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010688d:	e9 0e f2 ff ff       	jmp    80105aa0 <alltraps>

80106892 <vector232>:
.globl vector232
vector232:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $232
80106894:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106899:	e9 02 f2 ff ff       	jmp    80105aa0 <alltraps>

8010689e <vector233>:
.globl vector233
vector233:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $233
801068a0:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068a5:	e9 f6 f1 ff ff       	jmp    80105aa0 <alltraps>

801068aa <vector234>:
.globl vector234
vector234:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $234
801068ac:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801068b1:	e9 ea f1 ff ff       	jmp    80105aa0 <alltraps>

801068b6 <vector235>:
.globl vector235
vector235:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $235
801068b8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801068bd:	e9 de f1 ff ff       	jmp    80105aa0 <alltraps>

801068c2 <vector236>:
.globl vector236
vector236:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $236
801068c4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801068c9:	e9 d2 f1 ff ff       	jmp    80105aa0 <alltraps>

801068ce <vector237>:
.globl vector237
vector237:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $237
801068d0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801068d5:	e9 c6 f1 ff ff       	jmp    80105aa0 <alltraps>

801068da <vector238>:
.globl vector238
vector238:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $238
801068dc:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068e1:	e9 ba f1 ff ff       	jmp    80105aa0 <alltraps>

801068e6 <vector239>:
.globl vector239
vector239:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $239
801068e8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068ed:	e9 ae f1 ff ff       	jmp    80105aa0 <alltraps>

801068f2 <vector240>:
.globl vector240
vector240:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $240
801068f4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068f9:	e9 a2 f1 ff ff       	jmp    80105aa0 <alltraps>

801068fe <vector241>:
.globl vector241
vector241:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $241
80106900:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106905:	e9 96 f1 ff ff       	jmp    80105aa0 <alltraps>

8010690a <vector242>:
.globl vector242
vector242:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $242
8010690c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106911:	e9 8a f1 ff ff       	jmp    80105aa0 <alltraps>

80106916 <vector243>:
.globl vector243
vector243:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $243
80106918:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010691d:	e9 7e f1 ff ff       	jmp    80105aa0 <alltraps>

80106922 <vector244>:
.globl vector244
vector244:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $244
80106924:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106929:	e9 72 f1 ff ff       	jmp    80105aa0 <alltraps>

8010692e <vector245>:
.globl vector245
vector245:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $245
80106930:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106935:	e9 66 f1 ff ff       	jmp    80105aa0 <alltraps>

8010693a <vector246>:
.globl vector246
vector246:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $246
8010693c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106941:	e9 5a f1 ff ff       	jmp    80105aa0 <alltraps>

80106946 <vector247>:
.globl vector247
vector247:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $247
80106948:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010694d:	e9 4e f1 ff ff       	jmp    80105aa0 <alltraps>

80106952 <vector248>:
.globl vector248
vector248:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $248
80106954:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106959:	e9 42 f1 ff ff       	jmp    80105aa0 <alltraps>

8010695e <vector249>:
.globl vector249
vector249:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $249
80106960:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106965:	e9 36 f1 ff ff       	jmp    80105aa0 <alltraps>

8010696a <vector250>:
.globl vector250
vector250:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $250
8010696c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106971:	e9 2a f1 ff ff       	jmp    80105aa0 <alltraps>

80106976 <vector251>:
.globl vector251
vector251:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $251
80106978:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010697d:	e9 1e f1 ff ff       	jmp    80105aa0 <alltraps>

80106982 <vector252>:
.globl vector252
vector252:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $252
80106984:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106989:	e9 12 f1 ff ff       	jmp    80105aa0 <alltraps>

8010698e <vector253>:
.globl vector253
vector253:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $253
80106990:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106995:	e9 06 f1 ff ff       	jmp    80105aa0 <alltraps>

8010699a <vector254>:
.globl vector254
vector254:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $254
8010699c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069a1:	e9 fa f0 ff ff       	jmp    80105aa0 <alltraps>

801069a6 <vector255>:
.globl vector255
vector255:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $255
801069a8:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801069ad:	e9 ee f0 ff ff       	jmp    80105aa0 <alltraps>
	...

801069c0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069c0:	a1 24 58 11 80       	mov    0x80115824,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801069c5:	55                   	push   %ebp
801069c6:	89 e5                	mov    %esp,%ebp
801069c8:	2d 00 00 00 80       	sub    $0x80000000,%eax
801069cd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801069d0:	5d                   	pop    %ebp
801069d1:	c3                   	ret    
801069d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	83 ec 28             	sub    $0x28,%esp
801069e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801069e9:	89 d3                	mov    %edx,%ebx
801069eb:	c1 eb 16             	shr    $0x16,%ebx
801069ee:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801069f1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801069f4:	8b 33                	mov    (%ebx),%esi
801069f6:	f7 c6 01 00 00 00    	test   $0x1,%esi
801069fc:	74 22                	je     80106a20 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106a04:	81 ee 00 00 00 80    	sub    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a0a:	c1 ea 0a             	shr    $0xa,%edx
80106a0d:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106a13:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
80106a16:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80106a19:	8b 75 fc             	mov    -0x4(%ebp),%esi
80106a1c:	89 ec                	mov    %ebp,%esp
80106a1e:	5d                   	pop    %ebp
80106a1f:	c3                   	ret    

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a20:	85 c9                	test   %ecx,%ecx
80106a22:	75 04                	jne    80106a28 <walkpgdir+0x48>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a24:	31 c0                	xor    %eax,%eax
80106a26:	eb ee                	jmp    80106a16 <walkpgdir+0x36>

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a28:	89 55 f4             	mov    %edx,-0xc(%ebp)
80106a2b:	e8 30 b9 ff ff       	call   80102360 <kalloc>
80106a30:	85 c0                	test   %eax,%eax
80106a32:	89 c6                	mov    %eax,%esi
80106a34:	74 ee                	je     80106a24 <walkpgdir+0x44>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106a36:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a3d:	00 
80106a3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a45:	00 
80106a46:	89 04 24             	mov    %eax,(%esp)
80106a49:	e8 22 de ff ff       	call   80104870 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a4e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a54:	83 c8 07             	or     $0x7,%eax
80106a57:	89 03                	mov    %eax,(%ebx)
80106a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a5c:	eb ac                	jmp    80106a0a <walkpgdir+0x2a>
80106a5e:	66 90                	xchg   %ax,%ax

80106a60 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106a60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a61:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106a63:	89 e5                	mov    %esp,%ebp
80106a65:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a6e:	e8 6d ff ff ff       	call   801069e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106a73:	8b 00                	mov    (%eax),%eax
80106a75:	a8 01                	test   $0x1,%al
80106a77:	75 07                	jne    80106a80 <uva2ka+0x20>
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106a79:	31 c0                	xor    %eax,%eax
}
80106a7b:	c9                   	leave  
80106a7c:	c3                   	ret    
80106a7d:	8d 76 00             	lea    0x0(%esi),%esi
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
80106a80:	a8 04                	test   $0x4,%al
80106a82:	74 f5                	je     80106a79 <uva2ka+0x19>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106a84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a89:	2d 00 00 00 80       	sub    $0x80000000,%eax
}
80106a8e:	c9                   	leave  
80106a8f:	c3                   	ret    

80106a90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
80106a96:	83 ec 2c             	sub    $0x2c,%esp
80106a99:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106a9f:	85 db                	test   %ebx,%ebx
80106aa1:	74 75                	je     80106b18 <copyout+0x88>
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80106aa3:	8b 45 10             	mov    0x10(%ebp),%eax
80106aa6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106aa9:	eb 39                	jmp    80106ae4 <copyout+0x54>
80106aab:	90                   	nop
80106aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ab0:	89 f7                	mov    %esi,%edi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ab2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ab5:	29 d7                	sub    %edx,%edi
80106ab7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106abd:	39 df                	cmp    %ebx,%edi
80106abf:	0f 47 fb             	cmova  %ebx,%edi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ac2:	29 f2                	sub    %esi,%edx
80106ac4:	8d 14 10             	lea    (%eax,%edx,1),%edx
80106ac7:	89 7c 24 08          	mov    %edi,0x8(%esp)
80106acb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106acf:	89 14 24             	mov    %edx,(%esp)
80106ad2:	e8 69 de ff ff       	call   80104940 <memmove>
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ad7:	29 fb                	sub    %edi,%ebx
80106ad9:	74 3d                	je     80106b18 <copyout+0x88>
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106adb:	01 7d e4             	add    %edi,-0x1c(%ebp)
    va = va0 + PGSIZE;
80106ade:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106ae4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106ae7:	89 d6                	mov    %edx,%esi
80106ae9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106aef:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106af2:	89 74 24 04          	mov    %esi,0x4(%esp)
80106af6:	89 0c 24             	mov    %ecx,(%esp)
80106af9:	e8 62 ff ff ff       	call   80106a60 <uva2ka>
    if(pa0 == 0)
80106afe:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106b01:	85 c0                	test   %eax,%eax
80106b03:	75 ab                	jne    80106ab0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106b05:	83 c4 2c             	add    $0x2c,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106b0d:	5b                   	pop    %ebx
80106b0e:	5e                   	pop    %esi
80106b0f:	5f                   	pop    %edi
80106b10:	5d                   	pop    %ebp
80106b11:	c3                   	ret    
80106b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b18:	83 c4 2c             	add    $0x2c,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106b1b:	31 c0                	xor    %eax,%eax
  }
  return 0;
}
80106b1d:	5b                   	pop    %ebx
80106b1e:	5e                   	pop    %esi
80106b1f:	5f                   	pop    %edi
80106b20:	5d                   	pop    %ebp
80106b21:	c3                   	ret    
80106b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b30 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b36:	89 d3                	mov    %edx,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b38:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b3c:	83 ec 2c             	sub    $0x2c,%esp
80106b3f:	8b 75 08             	mov    0x8(%ebp),%esi
80106b42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b45:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b4b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b51:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
80106b55:	eb 1d                	jmp    80106b74 <mappages+0x44>
80106b57:	90                   	nop
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106b58:	f6 00 01             	testb  $0x1,(%eax)
80106b5b:	75 45                	jne    80106ba2 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b60:	09 f2                	or     %esi,%edx
    if(a == last)
80106b62:	39 fb                	cmp    %edi,%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b64:	89 10                	mov    %edx,(%eax)
    if(a == last)
80106b66:	74 30                	je     80106b98 <mappages+0x68>
      break;
    a += PGSIZE;
80106b68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80106b6e:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b77:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b7c:	89 da                	mov    %ebx,%edx
80106b7e:	e8 5d fe ff ff       	call   801069e0 <walkpgdir>
80106b83:	85 c0                	test   %eax,%eax
80106b85:	75 d1                	jne    80106b58 <mappages+0x28>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106b87:	83 c4 2c             	add    $0x2c,%esp
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
80106b8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
80106b8f:	5b                   	pop    %ebx
80106b90:	5e                   	pop    %esi
80106b91:	5f                   	pop    %edi
80106b92:	5d                   	pop    %ebp
80106b93:	c3                   	ret    
80106b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b98:	83 c4 2c             	add    $0x2c,%esp
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
80106b9b:	31 c0                	xor    %eax,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106b9d:	5b                   	pop    %ebx
80106b9e:	5e                   	pop    %esi
80106b9f:	5f                   	pop    %edi
80106ba0:	5d                   	pop    %ebp
80106ba1:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106ba2:	c7 04 24 d0 7b 10 80 	movl   $0x80107bd0,(%esp)
80106ba9:	e8 22 98 ff ff       	call   801003d0 <panic>
80106bae:	66 90                	xchg   %ax,%ax

80106bb0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	56                   	push   %esi
80106bb4:	53                   	push   %ebx
80106bb5:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106bb8:	e8 a3 b7 ff ff       	call   80102360 <kalloc>
80106bbd:	85 c0                	test   %eax,%eax
80106bbf:	89 c6                	mov    %eax,%esi
80106bc1:	74 53                	je     80106c16 <setupkvm+0x66>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106bc3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bca:	00 
80106bcb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bd2:	00 
80106bd3:	89 04 24             	mov    %eax,(%esp)
80106bd6:	e8 95 dc ff ff       	call   80104870 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106bdb:	b8 60 a4 10 80       	mov    $0x8010a460,%eax
80106be0:	3d 20 a4 10 80       	cmp    $0x8010a420,%eax
80106be5:	76 2f                	jbe    80106c16 <setupkvm+0x66>
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
80106be7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106bec:	8b 53 0c             	mov    0xc(%ebx),%edx
80106bef:	8b 43 04             	mov    0x4(%ebx),%eax
80106bf2:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106bf5:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bf9:	8b 13                	mov    (%ebx),%edx
80106bfb:	89 04 24             	mov    %eax,(%esp)
80106bfe:	29 c1                	sub    %eax,%ecx
80106c00:	89 f0                	mov    %esi,%eax
80106c02:	e8 29 ff ff ff       	call   80106b30 <mappages>
80106c07:	85 c0                	test   %eax,%eax
80106c09:	78 15                	js     80106c20 <setupkvm+0x70>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c0b:	83 c3 10             	add    $0x10,%ebx
80106c0e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106c14:	75 d6                	jne    80106bec <setupkvm+0x3c>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106c16:	83 c4 10             	add    $0x10,%esp
80106c19:	89 f0                	mov    %esi,%eax
80106c1b:	5b                   	pop    %ebx
80106c1c:	5e                   	pop    %esi
80106c1d:	5d                   	pop    %ebp
80106c1e:	c3                   	ret    
80106c1f:	90                   	nop
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106c20:	31 f6                	xor    %esi,%esi
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106c22:	83 c4 10             	add    $0x10,%esp
80106c25:	89 f0                	mov    %esi,%eax
80106c27:	5b                   	pop    %ebx
80106c28:	5e                   	pop    %esi
80106c29:	5d                   	pop    %ebp
80106c2a:	c3                   	ret    
80106c2b:	90                   	nop
80106c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c30 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106c36:	e8 75 ff ff ff       	call   80106bb0 <setupkvm>
80106c3b:	a3 24 58 11 80       	mov    %eax,0x80115824
80106c40:	2d 00 00 00 80       	sub    $0x80000000,%eax
80106c45:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106c48:	c9                   	leave  
80106c49:	c3                   	ret    
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c51:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c53:	89 e5                	mov    %esp,%ebp
80106c55:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5e:	e8 7d fd ff ff       	call   801069e0 <walkpgdir>
  if(pte == 0)
80106c63:	85 c0                	test   %eax,%eax
80106c65:	74 05                	je     80106c6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106c67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106c6a:	c9                   	leave  
80106c6b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106c6c:	c7 04 24 d6 7b 10 80 	movl   $0x80107bd6,(%esp)
80106c73:	e8 58 97 ff ff       	call   801003d0 <panic>
80106c78:	90                   	nop
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c80 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	83 ec 38             	sub    $0x38,%esp
80106c86:	89 75 f8             	mov    %esi,-0x8(%ebp)
80106c89:	8b 75 10             	mov    0x10(%ebp),%esi
80106c8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c8f:	89 7d fc             	mov    %edi,-0x4(%ebp)
80106c92:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106c95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106c98:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106c9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106ca1:	77 59                	ja     80106cfc <inituvm+0x7c>
    panic("inituvm: more than a page");
  mem = kalloc();
80106ca3:	e8 b8 b6 ff ff       	call   80102360 <kalloc>
  memset(mem, 0, PGSIZE);
80106ca8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106caf:	00 
80106cb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106cb7:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106cb8:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106cba:	89 04 24             	mov    %eax,(%esp)
80106cbd:	e8 ae db ff ff       	call   80104870 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106cc2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cc8:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ccd:	89 04 24             	mov    %eax,(%esp)
80106cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cd3:	31 d2                	xor    %edx,%edx
80106cd5:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106cdc:	00 
80106cdd:	e8 4e fe ff ff       	call   80106b30 <mappages>
  memmove(mem, init, sz);
80106ce2:	89 75 10             	mov    %esi,0x10(%ebp)
}
80106ce5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106ce8:	89 7d 0c             	mov    %edi,0xc(%ebp)
}
80106ceb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106cee:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106cf1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80106cf4:	89 ec                	mov    %ebp,%esp
80106cf6:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106cf7:	e9 44 dc ff ff       	jmp    80104940 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106cfc:	c7 04 24 e0 7b 10 80 	movl   $0x80107be0,(%esp)
80106d03:	e8 c8 96 ff ff       	call   801003d0 <panic>
80106d08:	90                   	nop
80106d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d10 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 2c             	sub    $0x2c,%esp
80106d19:	8b 75 0c             	mov    0xc(%ebp),%esi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d1c:	39 75 10             	cmp    %esi,0x10(%ebp)
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d1f:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
80106d22:	89 f0                	mov    %esi,%eax
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d24:	73 75                	jae    80106d9b <deallocuvm+0x8b>
    return oldsz;

  a = PGROUNDUP(newsz);
80106d26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106d29:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
80106d2f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d35:	39 de                	cmp    %ebx,%esi
80106d37:	77 3a                	ja     80106d73 <deallocuvm+0x63>
80106d39:	eb 5d                	jmp    80106d98 <deallocuvm+0x88>
80106d3b:	90                   	nop
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106d40:	8b 10                	mov    (%eax),%edx
80106d42:	f6 c2 01             	test   $0x1,%dl
80106d45:	74 22                	je     80106d69 <deallocuvm+0x59>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106d47:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d4d:	74 54                	je     80106da3 <deallocuvm+0x93>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106d4f:	81 ea 00 00 00 80    	sub    $0x80000000,%edx
80106d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d58:	89 14 24             	mov    %edx,(%esp)
80106d5b:	e8 50 b6 ff ff       	call   801023b0 <kfree>
      *pte = 0;
80106d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106d69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d6f:	39 de                	cmp    %ebx,%esi
80106d71:	76 25                	jbe    80106d98 <deallocuvm+0x88>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106d73:	31 c9                	xor    %ecx,%ecx
80106d75:	89 da                	mov    %ebx,%edx
80106d77:	89 f8                	mov    %edi,%eax
80106d79:	e8 62 fc ff ff       	call   801069e0 <walkpgdir>
    if(!pte)
80106d7e:	85 c0                	test   %eax,%eax
80106d80:	75 be                	jne    80106d40 <deallocuvm+0x30>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d82:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d88:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106d8e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d94:	39 de                	cmp    %ebx,%esi
80106d96:	77 db                	ja     80106d73 <deallocuvm+0x63>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80106d98:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106d9b:	83 c4 2c             	add    $0x2c,%esp
80106d9e:	5b                   	pop    %ebx
80106d9f:	5e                   	pop    %esi
80106da0:	5f                   	pop    %edi
80106da1:	5d                   	pop    %ebp
80106da2:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106da3:	c7 04 24 52 75 10 80 	movl   $0x80107552,(%esp)
80106daa:	e8 21 96 ff ff       	call   801003d0 <panic>
80106daf:	90                   	nop

80106db0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	56                   	push   %esi
80106db4:	53                   	push   %ebx
80106db5:	83 ec 10             	sub    $0x10,%esp
80106db8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint i;

  if(pgdir == 0)
80106dbb:	85 db                	test   %ebx,%ebx
80106dbd:	74 5e                	je     80106e1d <freevm+0x6d>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80106dbf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106dc6:	00 
80106dc7:	31 f6                	xor    %esi,%esi
80106dc9:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80106dd0:	80 
80106dd1:	89 1c 24             	mov    %ebx,(%esp)
80106dd4:	e8 37 ff ff ff       	call   80106d10 <deallocuvm>
80106dd9:	eb 10                	jmp    80106deb <freevm+0x3b>
80106ddb:	90                   	nop
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NPDENTRIES; i++){
80106de0:	83 c6 01             	add    $0x1,%esi
80106de3:	81 fe 00 04 00 00    	cmp    $0x400,%esi
80106de9:	74 24                	je     80106e0f <freevm+0x5f>
    if(pgdir[i] & PTE_P){
80106deb:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
80106dee:	a8 01                	test   $0x1,%al
80106df0:	74 ee                	je     80106de0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106df2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106df7:	83 c6 01             	add    $0x1,%esi
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106dfa:	2d 00 00 00 80       	sub    $0x80000000,%eax
80106dff:	89 04 24             	mov    %eax,(%esp)
80106e02:	e8 a9 b5 ff ff       	call   801023b0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e07:	81 fe 00 04 00 00    	cmp    $0x400,%esi
80106e0d:	75 dc                	jne    80106deb <freevm+0x3b>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106e0f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e12:	83 c4 10             	add    $0x10,%esp
80106e15:	5b                   	pop    %ebx
80106e16:	5e                   	pop    %esi
80106e17:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106e18:	e9 93 b5 ff ff       	jmp    801023b0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106e1d:	c7 04 24 fa 7b 10 80 	movl   $0x80107bfa,(%esp)
80106e24:	e8 a7 95 ff ff       	call   801003d0 <panic>
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e30 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
80106e36:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e39:	e8 72 fd ff ff       	call   80106bb0 <setupkvm>
80106e3e:	85 c0                	test   %eax,%eax
80106e40:	89 c6                	mov    %eax,%esi
80106e42:	0f 84 91 00 00 00    	je     80106ed9 <copyuvm+0xa9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e48:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e4b:	85 c0                	test   %eax,%eax
80106e4d:	0f 84 86 00 00 00    	je     80106ed9 <copyuvm+0xa9>
80106e53:	31 db                	xor    %ebx,%ebx
80106e55:	eb 54                	jmp    80106eab <copyuvm+0x7b>
80106e57:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e5b:	89 3c 24             	mov    %edi,(%esp)
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e5e:	81 ef 00 00 00 80    	sub    $0x80000000,%edi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e64:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106e6b:	00 
80106e6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e71:	2d 00 00 00 80       	sub    $0x80000000,%eax
80106e76:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e7a:	e8 c1 da ff ff       	call   80104940 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e82:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e87:	89 da                	mov    %ebx,%edx
80106e89:	89 3c 24             	mov    %edi,(%esp)
80106e8c:	25 ff 0f 00 00       	and    $0xfff,%eax
80106e91:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e95:	89 f0                	mov    %esi,%eax
80106e97:	e8 94 fc ff ff       	call   80106b30 <mappages>
80106e9c:	85 c0                	test   %eax,%eax
80106e9e:	78 2f                	js     80106ecf <copyuvm+0x9f>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ea0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ea6:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106ea9:	76 2e                	jbe    80106ed9 <copyuvm+0xa9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106eab:	8b 45 08             	mov    0x8(%ebp),%eax
80106eae:	31 c9                	xor    %ecx,%ecx
80106eb0:	89 da                	mov    %ebx,%edx
80106eb2:	e8 29 fb ff ff       	call   801069e0 <walkpgdir>
80106eb7:	85 c0                	test   %eax,%eax
80106eb9:	74 28                	je     80106ee3 <copyuvm+0xb3>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106ebb:	8b 00                	mov    (%eax),%eax
80106ebd:	a8 01                	test   $0x1,%al
80106ebf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ec2:	74 2b                	je     80106eef <copyuvm+0xbf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106ec4:	e8 97 b4 ff ff       	call   80102360 <kalloc>
80106ec9:	85 c0                	test   %eax,%eax
80106ecb:	89 c7                	mov    %eax,%edi
80106ecd:	75 89                	jne    80106e58 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106ecf:	89 34 24             	mov    %esi,(%esp)
80106ed2:	31 f6                	xor    %esi,%esi
80106ed4:	e8 d7 fe ff ff       	call   80106db0 <freevm>
  return 0;
}
80106ed9:	83 c4 2c             	add    $0x2c,%esp
80106edc:	89 f0                	mov    %esi,%eax
80106ede:	5b                   	pop    %ebx
80106edf:	5e                   	pop    %esi
80106ee0:	5f                   	pop    %edi
80106ee1:	5d                   	pop    %ebp
80106ee2:	c3                   	ret    

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106ee3:	c7 04 24 0b 7c 10 80 	movl   $0x80107c0b,(%esp)
80106eea:	e8 e1 94 ff ff       	call   801003d0 <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106eef:	c7 04 24 25 7c 10 80 	movl   $0x80107c25,(%esp)
80106ef6:	e8 d5 94 ff ff       	call   801003d0 <panic>
80106efb:	90                   	nop
80106efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f00 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 2c             	sub    $0x2c,%esp
80106f09:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106f0c:	85 ff                	test   %edi,%edi
80106f0e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f11:	0f 88 9c 00 00 00    	js     80106fb3 <allocuvm+0xb3>
    return 0;
  if(newsz < oldsz)
80106f17:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f1a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
80106f1d:	0f 82 a5 00 00 00    	jb     80106fc8 <allocuvm+0xc8>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106f23:	8b 75 0c             	mov    0xc(%ebp),%esi
80106f26:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80106f2c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106f32:	39 f7                	cmp    %esi,%edi
80106f34:	77 50                	ja     80106f86 <allocuvm+0x86>
80106f36:	e9 90 00 00 00       	jmp    80106fcb <allocuvm+0xcb>
80106f3b:	90                   	nop
80106f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106f40:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106f47:	00 
80106f48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f4f:	00 
80106f50:	89 04 24             	mov    %eax,(%esp)
80106f53:	e8 18 d9 ff ff       	call   80104870 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f58:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f63:	89 04 24             	mov    %eax,(%esp)
80106f66:	8b 45 08             	mov    0x8(%ebp),%eax
80106f69:	89 f2                	mov    %esi,%edx
80106f6b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106f72:	00 
80106f73:	e8 b8 fb ff ff       	call   80106b30 <mappages>
80106f78:	85 c0                	test   %eax,%eax
80106f7a:	78 5c                	js     80106fd8 <allocuvm+0xd8>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106f7c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f82:	39 f7                	cmp    %esi,%edi
80106f84:	76 45                	jbe    80106fcb <allocuvm+0xcb>
    mem = kalloc();
80106f86:	e8 d5 b3 ff ff       	call   80102360 <kalloc>
    if(mem == 0){
80106f8b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106f8d:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f8f:	75 af                	jne    80106f40 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f91:	c7 04 24 3f 7c 10 80 	movl   $0x80107c3f,(%esp)
80106f98:	e8 d3 98 ff ff       	call   80100870 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fa0:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106fa4:	89 44 24 08          	mov    %eax,0x8(%esp)
80106fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80106fab:	89 04 24             	mov    %eax,(%esp)
80106fae:	e8 5d fd ff ff       	call   80106d10 <deallocuvm>
80106fb3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106fba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fbd:	83 c4 2c             	add    $0x2c,%esp
80106fc0:	5b                   	pop    %ebx
80106fc1:	5e                   	pop    %esi
80106fc2:	5f                   	pop    %edi
80106fc3:	5d                   	pop    %ebp
80106fc4:	c3                   	ret    
80106fc5:	8d 76 00             	lea    0x0(%esi),%esi
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;
80106fc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fce:	83 c4 2c             	add    $0x2c,%esp
80106fd1:	5b                   	pop    %ebx
80106fd2:	5e                   	pop    %esi
80106fd3:	5f                   	pop    %edi
80106fd4:	5d                   	pop    %ebp
80106fd5:	c3                   	ret    
80106fd6:	66 90                	xchg   %ax,%ax
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106fd8:	c7 04 24 57 7c 10 80 	movl   $0x80107c57,(%esp)
80106fdf:	e8 8c 98 ff ff       	call   80100870 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fe7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106feb:	89 44 24 08          	mov    %eax,0x8(%esp)
80106fef:	8b 45 08             	mov    0x8(%ebp),%eax
80106ff2:	89 04 24             	mov    %eax,(%esp)
80106ff5:	e8 16 fd ff ff       	call   80106d10 <deallocuvm>
      kfree(mem);
80106ffa:	89 1c 24             	mov    %ebx,(%esp)
80106ffd:	e8 ae b3 ff ff       	call   801023b0 <kfree>
80107002:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      return 0;
    }
  }
  return newsz;
}
80107009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010700c:	83 c4 2c             	add    $0x2c,%esp
8010700f:	5b                   	pop    %ebx
80107010:	5e                   	pop    %esi
80107011:	5f                   	pop    %edi
80107012:	5d                   	pop    %ebp
80107013:	c3                   	ret    
80107014:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010701a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107020 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	53                   	push   %ebx
80107026:	83 ec 2c             	sub    $0x2c,%esp
80107029:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010702c:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
80107032:	0f 85 96 00 00 00    	jne    801070ce <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
80107038:	8b 75 18             	mov    0x18(%ebp),%esi
8010703b:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < sz; i += PGSIZE){
8010703d:	85 f6                	test   %esi,%esi
8010703f:	75 18                	jne    80107059 <loaduvm+0x39>
80107041:	eb 75                	jmp    801070b8 <loaduvm+0x98>
80107043:	90                   	nop
80107044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107048:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010704e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107054:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107057:	76 5f                	jbe    801070b8 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107059:	8b 45 08             	mov    0x8(%ebp),%eax
8010705c:	31 c9                	xor    %ecx,%ecx
8010705e:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80107061:	e8 7a f9 ff ff       	call   801069e0 <walkpgdir>
80107066:	85 c0                	test   %eax,%eax
80107068:	74 58                	je     801070c2 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010706a:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
8010706c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80107072:	ba 00 10 00 00       	mov    $0x1000,%edx
80107077:	0f 42 d6             	cmovb  %esi,%edx
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010707a:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010707d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107081:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107089:	2d 00 00 00 80       	sub    $0x80000000,%eax
8010708e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107092:	8b 45 10             	mov    0x10(%ebp),%eax
80107095:	8d 0c 0b             	lea    (%ebx,%ecx,1),%ecx
80107098:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010709c:	89 04 24             	mov    %eax,(%esp)
8010709f:	e8 cc a7 ff ff       	call   80101870 <readi>
801070a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070a7:	39 d0                	cmp    %edx,%eax
801070a9:	74 9d                	je     80107048 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801070ab:	83 c4 2c             	add    $0x2c,%esp
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return 0;
}
801070b3:	5b                   	pop    %ebx
801070b4:	5e                   	pop    %esi
801070b5:	5f                   	pop    %edi
801070b6:	5d                   	pop    %ebp
801070b7:	c3                   	ret    
801070b8:	83 c4 2c             	add    $0x2c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801070bb:	31 c0                	xor    %eax,%eax
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}
801070bd:	5b                   	pop    %ebx
801070be:	5e                   	pop    %esi
801070bf:	5f                   	pop    %edi
801070c0:	5d                   	pop    %ebp
801070c1:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801070c2:	c7 04 24 73 7c 10 80 	movl   $0x80107c73,(%esp)
801070c9:	e8 02 93 ff ff       	call   801003d0 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801070ce:	c7 04 24 d0 7c 10 80 	movl   $0x80107cd0,(%esp)
801070d5:	e8 f6 92 ff ff       	call   801003d0 <panic>
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <switchuvm>:
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	53                   	push   %ebx
801070e4:	83 ec 14             	sub    $0x14,%esp
801070e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801070ea:	85 db                	test   %ebx,%ebx
801070ec:	0f 84 aa 00 00 00    	je     8010719c <switchuvm+0xbc>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801070f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070f5:	85 c9                	test   %ecx,%ecx
801070f7:	0f 84 b7 00 00 00    	je     801071b4 <switchuvm+0xd4>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801070fd:	8b 53 04             	mov    0x4(%ebx),%edx
80107100:	85 d2                	test   %edx,%edx
80107102:	0f 84 a0 00 00 00    	je     801071a8 <switchuvm+0xc8>
    panic("switchuvm: no pgdir");

  pushcli();
80107108:	e8 d3 d5 ff ff       	call   801046e0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010710d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107113:	8d 50 08             	lea    0x8(%eax),%edx
80107116:	89 d1                	mov    %edx,%ecx
80107118:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
8010711f:	c1 e9 10             	shr    $0x10,%ecx
80107122:	c1 ea 18             	shr    $0x18,%edx
80107125:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
8010712b:	c6 80 a5 00 00 00 99 	movb   $0x99,0xa5(%eax)
80107132:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107139:	67 00 
8010713b:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
80107142:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107148:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010714e:	80 a0 a5 00 00 00 ef 	andb   $0xef,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107155:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010715b:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107161:	8b 53 08             	mov    0x8(%ebx),%edx
80107164:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010716a:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107170:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80107173:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107179:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
8010717f:	b8 30 00 00 00       	mov    $0x30,%eax
80107184:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107187:	8b 43 04             	mov    0x4(%ebx),%eax
8010718a:	2d 00 00 00 80       	sub    $0x80000000,%eax
8010718f:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107192:	83 c4 14             	add    $0x14,%esp
80107195:	5b                   	pop    %ebx
80107196:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80107197:	e9 84 d5 ff ff       	jmp    80104720 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
8010719c:	c7 04 24 91 7c 10 80 	movl   $0x80107c91,(%esp)
801071a3:	e8 28 92 ff ff       	call   801003d0 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801071a8:	c7 04 24 bc 7c 10 80 	movl   $0x80107cbc,(%esp)
801071af:	e8 1c 92 ff ff       	call   801003d0 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801071b4:	c7 04 24 a7 7c 10 80 	movl   $0x80107ca7,(%esp)
801071bb:	e8 10 92 ff ff       	call   801003d0 <panic>

801071c0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801071c6:	e8 55 b8 ff ff       	call   80102a20 <cpunum>
801071cb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801071d1:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801071d6:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
801071dc:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
801071e3:	89 d1                	mov    %edx,%ecx
801071e5:	c1 ea 18             	shr    $0x18,%edx
801071e8:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)
801071ee:	c1 e9 10             	shr    $0x10,%ecx

  lgdt(c->gdt, sizeof(c->gdt));
801071f1:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071f4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801071fa:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107200:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107204:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
80107208:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
8010720c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107210:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107217:	ff ff 
80107219:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107220:	00 00 
80107222:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107229:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80107230:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
80107237:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010723e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107245:	ff ff 
80107247:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010724e:	00 00 
80107250:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107257:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
8010725e:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
80107265:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010726c:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107273:	ff ff 
80107275:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010727c:	00 00 
8010727e:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107285:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
8010728c:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)
80107293:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010729a:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801072a1:	00 00 
801072a3:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801072a9:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
801072b0:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801072b7:	66 c7 45 f2 37 00    	movw   $0x37,-0xe(%ebp)
  pd[1] = (uint)p;
801072bd:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072c1:	c1 ea 10             	shr    $0x10,%edx
801072c4:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801072c8:	8d 55 f2             	lea    -0xe(%ebp),%edx
801072cb:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
801072ce:	ba 18 00 00 00       	mov    $0x18,%edx
801072d3:	8e ea                	mov    %edx,%gs

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
801072d5:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801072db:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801072e2:	00 00 00 00 
}
801072e6:	c9                   	leave  
801072e7:	c3                   	ret    
