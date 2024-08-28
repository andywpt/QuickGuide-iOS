## Contents
- Async Function
- Task
- [Actor](#Actor)

## Relation Between Tasks and Threads
理髮師(Thread) & 客人(Task)

- 理髮師會依客人指示一步步剪頭髮
- 理髮師一次只能幫一位客人剪頭髮，也不能多位理髮師同時幫一位客人剪頭髮，因為有店內有多位理髮師，所以可以同時幫多位客人剪頭髮
- 客人進來的的順序不一定是剪頭髮的順序
- 除非客人自己說要出去講電話，不然該理髮師會負責從頭剪到尾，剪完才會換下一個人
- 如果客人剪到一半要暫停出去講電話，那該理髮師會換幫其他客人剪頭髮，該客人回來後，要等其中一位理髮師有空才能繼續剪，而且幫忙剪髮的理髮師不ㄧ定是之前那位，除非客人一開始就有指定給老闆娘剪

### What's a Task?
- When a running task reaches its suspension point (i.e. `await`), the task releases the current thread ,the task will be cached, and the thread running the task is now free to run another task. So `await` inside a Task doesn't block (prevent any other code from running on that thread) the thread, it allows other tasks to make progress.
-  
Swift Concurrency uses a thread pool, with the only shipping exception being MainActor which uses a custom executor to run tasks on the main thread. All other actors, including global actors, use the thread pool
## Quick Reminder 
- **Thread Safe** is a concept that ensures that data is accessed or modified by only one thread at a time.
- 
## Actor
- Actor is a reference type that blocks concurrent access. Because an actor can only be on one thread at any time.
- **can only be on one thread at any time** doesn't imply it sticks to a thread. Only MainActor sticks to a thread (which is the main thread), other actors can run on background threads. An actor can only be on a thread at a time (so there is no concurrent access). But an actor can run on different threads.

### Actors Reentrancy Problem 😈
When an actor's function suspends (i.e. it runs to some line that contains `await`), the actor can process other calls from outside before the function awakes from suspension. So we say actors are **reentrant**.

```
actor Downloader {
    private var count = 0

    func download() async {
        count += 1
        let beforeAwait = count
        await someTask()   // When it suspends, download() can be called many times before it awakes from 
                                 suspension, which causes count to be incremented many times.
        let afterAwait = count
        XCAsertEqual(beforeAwait,afterAwait) ❌ // Assuming unchanged is incorrect 😈 
    }
}
```
#### Why are actors designed to be reentrant?
If actors were not reentrant, all calls to the actor will have to wait for the suspended function, even though the actor is free to do other stuff.

Yes, The actor's internal shared state can change accross the suspension point.
**Solutions**
1. Read and modify before saying any await in the function body
2. Wrap the job into a Task, and store it somewhere, so other code can refer to the task
```
actor TextDownloader {
    private var downloadingTask: Task<String,Never>?
    private var cachedText: String?

    func downloadText() async -> String {
        if let text = cachedText { return text }
        if let task = downloadingTask { return await task.value }
        let newTask = Task {
            let data = await fetchTextFromInternet()
            downloadingTask = nil
            cachedText = data
            return data
        }
        downloadingTask = newTask    // Creates a lock before suspending
        return await newTask.value   // When other code calls downloadData() during this suspension point,
                                     // the downloadingTask is already not nil
    }

    private func fetchTextFromInternet() async -> String {
        print("Fetching from internet...")
        let seconds = 1
        try! await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        return "Data"
    }
}
```
