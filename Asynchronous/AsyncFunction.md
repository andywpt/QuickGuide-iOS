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
### Although `Task.detached` cuts off any relationship between the resulting Task object and the surrounding context,it does not guarantee that the task must schedule off the main thread.

[Reference](https://developer.apple.com/videos/play/wwdc2021/10254/?time=1398)

```
class ViewController: UIViewController {

    override func viewDidLoad(){
        super.viewDidLoad()
        Task {
            XCAssert(Thread.isMainThread) ✅
            await loadData()
            XCAssert(Thread.isMainThread) ✅
        }
        Task.detatched {
            XCAssert(Thread.isMainThread) 😈 Unknown
            await loadData()
            XCAssert(Thread.isMainThread) 😈 Unknown
        }
    }

    func loadData() async {
        XCAssert(Thread.isMainThread) ✅ Since UIViewController is marked with @MainActor, loadData() is implicitly 
                                            marked with @MainActor
    }
}
```
### 🤔 How to make **loadData** run on the background thread?
```
nonisolated func loadData() async {}
```
> [!IMPORTANT]
> The nonisolated keyword is used to indicate to the compiler that the code inside the method is not accessing (either reading or writing) any of the mutable state inside the actor. You can’t declare an method nonisolated if it reads or writes any of the mutable state inside the actor.

### 🤔 How to switch back to main thread when running on the background thread? (i.e. Something like DispatchQueue.main)
```
nonisolated func loadData() async {
    XCAssert(Thread.isMainThread) ❌
    await MainActor.run {
        XCAssert(Thread.isMainThread) ✅
    }
    XCAssert(Thread.isMainThread) ❌
}
```
> [!CAUTION]
> Deliberate context switching to the main thread can be expensive. If you have multiple operations to perform on the main thread and you need to call MainActor.run, try to clump those operations into a single call to MainActor.run, so as not to switch contexts unnecessarily.

Synchronous actor initializers cannot hop on the actor's executor, so it runs in a non-isolated context.

An asynchronous initializer can use the executor after all properties have been initialized. Make your init async and it should work:
