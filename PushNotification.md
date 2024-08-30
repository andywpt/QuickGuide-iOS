## Post a local notification
```
let request = UNNotificationRequest(
    identifier: "id",
    content: UNMutableNotificationContent().with {
        $0.title = ""
        $0.body = ""
        $0.sound = .init(named: .init("beep.mp3"))
        $0.attachments = [
            .init(identifier: "id", url: // local file only , options: nil)
        ]
    },
    trigger: UNTimeIntervalNotificationTrigger(
        timeInterval: .leastNonzeroMagnitude,
        repeats: false
    )
)

UNUserNotificationCenter.current().add(request)
```
