### Asynchronous Functions (functions that are marked with `async`)
#### **Where an async function runs is decided by its declaration context (not the calling context).**
- If the async function is annotated with the **@MainActor** annotation (explicitly or implicitly), it runs on the main thread.
- If the async function is isolated to an actor, it runs on that actor's isolation domain, which runs on some background thread.
- Otherwise, it runs on the default executor, which runs on some background thread.
