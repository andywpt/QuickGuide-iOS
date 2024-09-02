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
