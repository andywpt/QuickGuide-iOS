## Contents
- Async Function
- Task
- [Actor](#Actor)

## Actor
### 🤔 What is Actors Reentrancy?
When an actor's function suspends (i.e. it runs to some line that contains `await`), the actor can process other calls from outside before the function awakes from suspension. 
### 🤔 Why are actors designed to be reentrant?
If actors were not reentrant, all calls to the actor will have to wait for the suspended function, even though the actor is free to do other stuff.


### Gotchas with Actor 😈

**Actors Reentrancy Problem**

When an actor's function suspends (i.e. it runs to some line that contains `await`), the actor can process other     calls from outside before the function awakes from suspension. 

```
actor Downloader {
    private var count = 0

    func downloadData() async {
        count += 1
        print(count)          // ex: 1
        await doOtherTask()   // When it suspends, downloadData() can be called many times before it awakes from 
                                 suspension, which causes count to be incremented many times.
        print(count)          // Assuming 1 is incorrect 😈 
    }
}
```
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
