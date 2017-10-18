#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#ifdef CS333_P2
#include "uproc.h"
#endif

struct StateLists {
    struct proc* ready[MAX+1];
    struct proc* free;
    struct proc* sleep;
    struct proc* zombie;
    struct proc* running;
    struct proc* embryo;
};

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct StateLists pLists;
  uint PromoteAtTime;
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);
static int removeFromStateList(struct proc**, struct proc*, int);
static void addProcToLast(struct proc**, struct proc*);
static void addProcToBegin(struct proc**, struct proc*);
static struct proc* findByPID(struct proc*, int);
static void promote();

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  /*for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      if(p->state == UNUSED)
          goto found;*/
  p = ptable.pLists.free;
  if (p)
      goto found;
  release(&ptable.lock);
  return 0;

found:
  // from free to embryo
  if (removeFromStateList(&ptable.pLists.free, p, UNUSED) < 0)
      panic("The process is not in the free list - allocproc() routine");
  p->state = EMBRYO;
  addProcToBegin(&ptable.pLists.embryo, p);
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    // from embryo to free
    if (removeFromStateList(&ptable.pLists.embryo, p, EMBRYO) < 0)
      panic("The process is not in the embryo list - allocproc() routine");
    p->state = UNUSED;
    addProcToBegin(&ptable.pLists.free, p);
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  p->start_ticks = ticks;
  p->cpu_ticks_total = 0;
  p->cpu_ticks_in = 0;
  p->priority = 0;
  p->budget = BUDGET;

  return p;
}

// Set up first user process.
void
userinit(void)
{
  struct proc* tmp;
  ptable.pLists.free = 0;
  for(tmp = ptable.proc; tmp < &ptable.proc[NPROC]; tmp++)
    addProcToBegin(&ptable.pLists.free, tmp);
  ptable.pLists.embryo = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.running = 0;
  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
  for (int i = 0; i <= MAX; i++) {
    ptable.pLists.ready[i] = 0;
  }

  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->uid = UID;
  p->gid = GID;
  // from embryo to ready
  if (removeFromStateList(&ptable.pLists.embryo, p, EMBRYO) < 0)
      panic("The process is not in the embryo list - userinit() routine");
  p->state = RUNNABLE;
  addProcToLast(&ptable.pLists.ready[p->priority], p);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    // from embryo to free
    if (removeFromStateList(&ptable.pLists.embryo, np, EMBRYO) < 0)
      panic("The process is not in the embryo list - fork() routine");
    np->state = UNUSED;
    addProcToBegin(&ptable.pLists.free, np);
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;
  
  // Copy uid and gid
  np->uid = proc->uid;
  np->gid = proc->gid;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  if (removeFromStateList(&ptable.pLists.embryo, np, EMBRYO) < 0)
    panic("The process is not in the embryo list - fork() routine");
  np->state = RUNNABLE;
  addProcToLast(&ptable.pLists.ready[np->priority], np);
  release(&ptable.lock);
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#else
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  for (p = ptable.pLists.running; p; p = p->next) {
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (int i = 0; i <= MAX; i++) {
    for (p = ptable.pLists.ready[i]; p; p = p->next) {
      if (p->parent == proc) {
        p->parent = initproc;
      }
    }
  }
  for (p = ptable.pLists.embryo; p; p = p->next) {
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (p = ptable.pLists.sleep; p; p = p->next) {
      if (p->parent == proc) {
          p->parent = initproc;
      }
  }
  for (p = ptable.pLists.zombie; p; p = p->next) {
      if (p->parent == proc) {
          p->parent = initproc;
          wakeup1(initproc);
      }
  }

  // Jump into the scheduler, never to return.
  if (removeFromStateList(&ptable.pLists.running, proc, RUNNING) < 0)
    panic("The proc is not in the running list - exit() routine");
  proc->state = ZOMBIE;  
  addProcToBegin(&ptable.pLists.zombie, proc);
  sched();
  panic("zombie exit");
}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.pLists.zombie; p; p = p->next){
      if(p->parent != proc)
        continue;
      havekids = 1;
      pid = p->pid;
      kfree(p->kstack);
      p->kstack = 0;
      freevm(p->pgdir);
      if (removeFromStateList(&ptable.pLists.zombie, p, ZOMBIE) < 0)
        panic("Cannot remove the proc from the zombie list - wait() routine");
      p->state = UNUSED;
      addProcToBegin(&ptable.pLists.free, p);
      p->pid = 0;
      p->parent = 0;
      p->name[0] = 0;
      p->killed = 0;
      release(&ptable.lock);
      return pid;
    }
    for(int i = 0; i <= MAX; i++) {
      for(p = ptable.pLists.ready[i]; p; p = p->next) {
        if(p->parent != proc)
          continue;
        havekids = 1;
        goto out;
      }
    }
    for(p = ptable.pLists.running; p; p = p->next) {
      if(p->parent != proc)
        continue;
      havekids = 1;
      goto out;
    }
    for(p = ptable.pLists.sleep; p; p = p->next) {
      if(p->parent != proc)
        continue;
      havekids = 1;
      goto out;
    }
    for(p = ptable.pLists.embryo; p; p = p->next) {
      if(p->parent != proc)
        continue;
      havekids = 1;
      goto out;
    }
out:
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#endif

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
      switchkvm();
      p->cpu_ticks_total = ticks - p->cpu_ticks_in;

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    acquire(&ptable.lock);
    //for (int j = 0; j < 99999; j++){}
    if (ticks >= ptable.PromoteAtTime) {
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
      promote();
    }

    for (int i = 0; i <= MAX; i++) {
      p = ptable.pLists.ready[i];
      if (p) {
        idle = 0;  // not idle this timeslice
        proc = p;

        switchuvm(p);
        if (removeFromStateList(&ptable.pLists.ready[p->priority], p, RUNNABLE) < 0)
          panic("Cannot remove the proc from the ready list - scheduler() routine");
        p->state = RUNNING;
        addProcToBegin(&ptable.pLists.running, p);
        p->cpu_ticks_in = ticks;
        swtch(&cpu->scheduler, proc->context);
        switchkvm();

        p->cpu_ticks_total += (ticks - p->cpu_ticks_in);
        proc = 0;
        break;
      }
    }
      // Process is done running for now.
      // It should have changed its p->state before coming back.

    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  proc->cpu_ticks_in = ticks;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#else
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  proc->cpu_ticks_in = ticks;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  if (removeFromStateList(&ptable.pLists.running, proc, RUNNING) < 0)
    panic("The proc is not in the running list - yield() routine");
  proc->state = RUNNABLE;
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
  if (proc->budget <= 0) {
    if (proc->priority < MAX)
      proc->priority++;
    proc->budget = BUDGET;
  }
  addProcToLast(&ptable.pLists.ready[proc->priority], proc);
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  if (removeFromStateList(&ptable.pLists.running, proc, RUNNING) < 0)
    panic("The proc is not in the running list - sleep() routine");
  proc->state = SLEEPING;
  addProcToBegin(&ptable.pLists.sleep, proc);
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  struct proc *p = ptable.pLists.sleep;

  while (p) {
    if (p->chan == chan) {
      if (removeFromStateList(&ptable.pLists.sleep, p, SLEEPING) < 0)
        panic("Cannot remove the proc from the sleep list - wakeup1() routine");
      p->state = RUNNABLE;
      addProcToLast(&ptable.pLists.ready[p->priority], p);
    }
    p = p->next;
  }
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.pLists.sleep; p; p = p->next){
    if(p->pid == pid){
      p->killed = 1;
      if (removeFromStateList(&ptable.pLists.sleep, p, SLEEPING) < 0)
        panic("Cannot remove the proc from the sleep list - kill() routine");
      p->state = RUNNABLE;
      addProcToLast(&ptable.pLists.ready[p->priority], p);
      release(&ptable.lock);
      return 0;
    }
  }
  for(p = ptable.pLists.running; p; p = p->next) {
    if(p->pid == pid) {
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
  }
  for(int i = 0; i <= MAX; i++) {
    for(p = ptable.pLists.ready[i]; p; p = p->next) {
      if(p->pid == pid) {
        p->killed = 1;
        release(&ptable.lock);
        return 0;
      }
    }
  }
  for(p = ptable.pLists.embryo; p; p = p->next) {
    if(p->pid == pid) {
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
  }
  for(p = ptable.pLists.zombie; p; p = p->next) {
    if(p->pid == pid) {
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
  }

  release(&ptable.lock);
  return -1;
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  uint seconds, partial_seconds;
  uint cpu_seconds, cpu_partial_seconds;
  uint ppid;

  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\tPCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    seconds = (ticks - p->start_ticks)/100;
    partial_seconds = (ticks - p->start_ticks)%100;
    cpu_seconds = p->cpu_ticks_total/100;
    cpu_partial_seconds = p->cpu_ticks_total%100;
    if(!p->parent)
      ppid = p->pid;
    else
      ppid = p->parent->pid;
    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d.", p->pid, p->name, p->uid, p->gid, ppid, p->priority, seconds);
    if(partial_seconds < 10)
      cprintf("0");
    cprintf("%d\t%d.", partial_seconds, cpu_seconds);
    if(cpu_partial_seconds < 10)
      cprintf("0");
    cprintf("%d\t%s\t%d\t", cpu_partial_seconds, state, p->sz);
    if(p->state == SLEEPING) {
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i = 0; i < 10 && pc[i] != 0; i++)
        cprintf("%p", pc[i]);
    }
    cprintf("\n");
  }
}

int
getprocs(uint max, struct uproc* table)
{
    int i;
    struct proc* p;
    acquire(&ptable.lock);
    for(i = 0, p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
        if (p->state != UNUSED) {
            table[i].pid = p->pid;
            table[i].uid = p->uid;
            table[i].gid = p->gid;
            if (!p->parent)
                table[i].ppid = p->pid;
            else table[i].ppid = p->parent->pid;
            table[i].priority = p->priority;
            table[i].elapsed_ticks = ticks - p->start_ticks;
            table[i].CPU_total_ticks = p->cpu_ticks_total;
            table[i].size = p->sz;
            safestrcpy(table[i].name, p->name, sizeof(p->name));
            switch (p->state) {
                case UNUSED:
                    break;
                case EMBRYO:
                    break;
                case SLEEPING:
                    safestrcpy(table[i].state, "sleep", STRMAX);
                    break;
                case RUNNABLE:
                    safestrcpy(table[i].state, "runble", STRMAX);
                    break;
                case RUNNING:
                    safestrcpy(table[i].state, "run", STRMAX);
                    break;
                case ZOMBIE:
                    safestrcpy(table[i].state, "zombie", STRMAX);
                    break;
            }
            i++;
        }
    }
    release(&ptable.lock);
    return i;
}

// print the ctrl-f content
void
printCtrlF(void)
{
    struct proc* cur = ptable.pLists.free;
    int count = 0;
    while (cur) {
        count++;
        cur = cur->next;
    }
    cprintf("%s%d%s\n", "Free List Size: ", count, " processes");
}

// print the ctrl-r content
void
printCtrlR(void)
{
    cprintf("%s\n", "Ready List Processes:");
    for (int i = 0; i <= MAX; i++) {
        struct proc* cur = ptable.pLists.ready[i];
        cprintf("%d%s", i, ": ");
        if (cur) {
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->budget, ")");
            cur = cur->next;
        }
        else cprintf("%s", "Empty");
        while (cur) {
            cprintf("%s", " -> ");
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->budget, ")");
            cur = cur->next;
        }
        cprintf("\n");
    }
    cprintf("\n");
}

void
printCtrlS(void)
{
    struct proc* cur = ptable.pLists.sleep;
    if (!cur) {
        cprintf("%s", "Sleep List is empty");
    }
    else {
        cprintf("%s\n%d", "Sleep List Processes:", cur->pid);
        cur = cur->next;
    }
    while (cur) {
        cprintf("%s%d", " -> ", cur->pid);
        cur = cur->next;
    }
    cprintf("\n");
}

void
printCtrlZ(void)
{
    struct proc* cur = ptable.pLists.zombie;
    if (!cur) {
        cprintf("%s", "Zombie List is empty");
    }
    else {
        cprintf("%s\n", "Zombie List Processes:");
        if (!cur->parent)
            cprintf("%s%d%s%d%s", "(", cur->pid, ", ", 0, ")");
        else cprintf("%s%d%s%d%s", "(", cur->pid, ", ", cur->parent->pid, ")");
        cur = cur->next;
    }
    while (cur) {
        if (!cur->parent)
            cprintf("%s%d%s%d%s", " -> (", cur->pid, ", ", 0, ")");
        else cprintf("%s%d%s%d%s", " -> (", cur->pid, ", ", cur->parent->pid, ")");
        cur = cur->next;
    }
    cprintf("\n");
}

static int
removeFromStateList(struct proc** sList, struct proc* p, int state)
{
    if (p->state != state)
        return -1;
    if (!*sList)
        return -1;
    if (p == *sList) {
        *sList = (*sList)->next;
        p->next = 0;
        return 0;
    }
    struct proc *cur = *sList;
    while (cur->next) {
        if (p == cur->next) {
            struct proc* tmp = cur->next;
            cur->next = tmp->next;
            tmp->next = 0;
            return 0;
        }
        cur = cur->next;
    }
    return -1;
}

static void
addProcToLast(struct proc** sList, struct proc* p)
{
    if (!(*sList)) {
        *sList = p;
        (*sList)->next = 0;
        return;
    }
    struct proc* cur = *sList;
    while (cur->next) {
        if (cur->pid == p->pid)
            return;
        cur = cur->next;
    }
    cur->next = p;
    cur->next->next = 0;
}

static void
addProcToBegin(struct proc** sList, struct proc* p)
{
    p->next = *sList;
    *sList = p;
}

static struct proc*
findByPID(struct proc* sList, int pid)
{
    if (!sList)
        return 0;
    else {
        struct proc* p;
        for (p = sList; p; p = p->next) {
            if (p->pid == pid)
                return p;
        }
        return 0;
    }
}

int
setpriority(int pid, int value)
{
    if (pid < 0 || value < 0 || value > MAX)
        return -1;
    acquire(&ptable.lock);
    struct proc* p;
    for (int i = 0; i <= MAX; i++) {
        p = findByPID(ptable.pLists.ready[i], pid);
        if (p) {
            if (p->priority != value) {
                p->priority = value;
                p->budget = BUDGET;
                if (removeFromStateList(&ptable.pLists.ready[i], p, p->state) < 0)
                    panic("Cannot remove from ready list - setpriority");
                addProcToLast(&ptable.pLists.ready[p->priority], p);
            }
            release(&ptable.lock);
            return 0;
        }
    }
    p = findByPID(ptable.pLists.sleep, pid);
    if (p) {
        if (p->priority != value)
            p->priority = value;
        release(&ptable.lock);
        return 0;
    }
    p = findByPID(ptable.pLists.running, pid);
    if (p) {
        if (p->priority != value)
            p->priority = value;
        release(&ptable.lock);
        return 0;
    }
    release(&ptable.lock);
    return -1;
}

static void
promote()
{
    struct proc* cur;

    // ready list
    for (int i = 1; i <= MAX; i++) {
        for (cur = ptable.pLists.ready[i]; cur;) {
            struct proc* tmp = cur->next;
            /*if (cur->priority > 0){
                cur->priority -= 1;
            }*/
            cur->priority -= 1;
            if (removeFromStateList(&ptable.pLists.ready[i], cur, cur->state) < 0)
                panic("Cannot remove proc from ready list - promote");
            addProcToLast(&ptable.pLists.ready[cur->priority], cur);
            cur = tmp;
        }
    }

    // sleep list
    for (cur = ptable.pLists.sleep; cur; cur = cur->next) {
        if (cur->priority > 0)
            cur->priority -= 1;
    }

    // running list
    for (cur = ptable.pLists.running; cur; cur = cur->next) {
        if (cur->priority > 0)
            cur->priority -= 1;
    }
}

