### **Where an asynchronous function (function that is marked with `async`) runs is decided by its declaration context (not the calling context).**
- Async functions always hop to the appropriate executor before execution.
- If the async function is annotated with the **@MainActor** annotation (explicitly or implicitly), it runs on the main thread.
- If the async function is isolated to an actor, it runs on that actor's isolation domain, which runs on some background thread.
- Otherwise, it runs on the default executor, which runs on some background thread.
> [!NOTE]
> It is the `async` declaration that makes a function asynchronous, not the `await` in the function body.
> 
> The following function is still an async function even though it never says await in its body (never suspends).
> ```
> func fetchData() async -> Data {
>    return Data()
> }
> ```

> [!IMPORTANT]
> Synchronous functions (functions that are not marked with `async`) always run on the thread they were called from.
> Where an synchronous function runs is decided by the calling context.

### Every time a @MainActor function awakes from suspension, it will resume on the main actor. There's no need to manually switch back.

Synchronous actor initializers cannot hop on the actor's executor, so it runs in a non-isolated context.

An asynchronous initializer can use the executor after all properties have been initialized. Make your init async and it should work:
## Actor Reentrancy Problem
When an actor's function suspends (i.e. the function body code runs to some line that contains `await`), it can process other calls. Hence, shared state can change during this period.
```
actor Downloader {
    private var count = 0

    func downloadData() async {
        print(count)          // ex: 0
        doSomeTask()          // Calls some synchronous function
        print(count)          // Assuming 0 is correct 
        await doOtherTask()   // When it suspends, downloadData() can be called many times before it awakes from suspension
        count += 1
        print(count)          // Assuming 1 is incorrect 😈 
    }
}
```
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

## Although Task.detached cuts off any relationship between the resulting Task object and the surrounding context,it does not guarantee that the task must schedule off the main thread.


