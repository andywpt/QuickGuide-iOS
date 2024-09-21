### Setup Project without storyboards
1. Delete Main.storyboard file from the project navigator
2. Delete Storyboard Name from target's Info plist
  <img width="1008" alt="Screenshot 2024-09-02 at 9 25 22 AM" src="https://github.com/user-attachments/assets/8ca2f841-d92b-493a-a60c-3827970155a1">
3. Clear the Storyboard Name field from the target's build settings
  <img width="1079" alt="Screenshot 2024-09-02 at 9 29 15 AM" src="https://github.com/user-attachments/assets/dd7c80c2-a6f0-44b4-9850-6f8fc910737f">
4. Set Scene Delegate's window property in its scene(_:willConnectTo:options:) method

```
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = ViewController()
            window.makeKeyAndVisible()
            return window
        }()
        
    }
}
```

Project Configuration: Debug vs. Release
By default, a new Xcode project will have two configurations: Debug and Release. As the names suggest, Debug configuration is for developers to debug app during development; Release is for releasing your app to TestFlight or App Store. The main difference between these two is:

In a debug build the complete symbolic debug information is emitted to help while debugging applications and also the code optimization is not taken into account. While in release build the symbolic debug info is not emitted and the code execution is optimized. Also, because the symbolic info is not emitted in a release build, the size of the final executable is lesser than a debug executable.

To summarize,

code execution in Release builds is optimized, so they are smaller and run faster, but if you place a break point in your code, it may never get hit
Debug builds will execute your code intactly, so if you place a break point in a function and call it, the break point will get hit
in the code, you can detect if the current configuration is Debug or Release by using Swift preprocessor flags #if DEBUG
