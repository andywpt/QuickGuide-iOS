import XCTest

actor Downloader {
    
    private var count = 0
    
    func stateUnchangedWithoutSuspensionSync() -> Bool {
        count += 1
        let before = count
        timeConsumingWork()
        let after = count
        return before == after
    }
    
    func stateUnchangedWithoutSuspensionAsync() async -> Bool {
        count += 1
        let before = count
        timeConsumingWork()
        let after = count
        return before == after
    }
    
    func stateUnchangedAfterSuspension() async -> Bool {
        count += 1
        let before = count
        await timeConsumingWorkAsync()
        let after = count
        return before == after
    }
    
    func timeConsumingWork() { sleep(1) }
    func timeConsumingWorkAsync() async { try! await Task.sleep(seconds: 1) }
}

final class ActorReentrancyTests: XCTestCase {

    func test_whenCallingSynchromousMethod_sholdNotHaveReetrancyProblems() async {
        let actor = Downloader()
        let numberOfTasks = 3
        
        var results = [Bool]()
        await withTaskGroup(of: Bool.self) { group in
            (1...numberOfTasks).forEach { _ in
                group.addTask {
                    await actor.stateUnchangedWithoutSuspensionSync()
                }
            }
            for await result in group {
                print("✅")
                results.append(result)
            }
            return
        }
        XCTAssertEqual(results, Array(repeating: true, count: numberOfTasks))
    }
    
    func test_whenCallingSynchromousMethod_sholdNotHaveReetrancyProms() async {
        let actor = Downloader()
        let numberOfTasks = 3
        
        var results = [Bool]()
        await withTaskGroup(of: Bool.self) { group in
            (1...numberOfTasks).forEach { _ in
                group.addTask {
                    await actor.stateUnchangedWithoutSuspensionAsync()
                }
            }
            for await result in group {
                print("✅")
                results.append(result)
            }
            return
        }
        XCTAssertEqual(results, Array(repeating: true, count: numberOfTasks))
    }
    
    func test_whenCallingAsynchromousMethod_sholdHaveReetrancyProblems() async {
        let actor = Downloader()
        let numberOfTasks = 3
        var results = [Bool]()
        await withTaskGroup(of: Bool.self) { group in
            (1...numberOfTasks).forEach { _ in
                group.addTask {
                    await actor.stateUnchangedAfterSuspension()
                }
            }
            for await result in group {
                print("✅")
                results.append(result)
            }
            return
        }
        XCTAssertNotEqual(results, Array(repeating: true, count: numberOfTasks))
    }

}
