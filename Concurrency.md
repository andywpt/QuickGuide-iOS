## Contents
- Async Function
- Task
- [Actor](#Actor)

## Task 
### What's a Task?
- Think of a task as a train, and a thread as a railway
- Because a task cannot run on two threads at the same time, there is no concurrency inside a task.
- Each thread can only run one task at any given time, and tasks on different threads can run concurrently.
- When a running task reaches its suspension point (i.e. `await`), the task will be cached, and the thread running the task is now free to run another task. So `await` inside a Task doesn't block the thread, it allows other tasks to make progress.
-  
Swift Concurrency uses a thread pool, with the only shipping exception being MainActor which uses a custom executor to run tasks on the main thread. All other actors, including global actors, use the thread pool

## Actor
- Actor is a reference type that blocks concurrent access. Because an actor can only be on one thread at any time.
- **can only be on one thread at any time** doesn't imply it sticks to a thread. Only MainActor sticks to a thread (which is the main thread), other actors can run on background threads. An actor can only be on a thread at a time (so there is no concurrent access). But an actor can run on different threads.

(Main Actor )
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
