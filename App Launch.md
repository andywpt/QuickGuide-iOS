• The @main attribute in AppDelegate.swift creates an entry point that implicitly calls the UIApplicationMain function to get the app started
 ( in the function call, UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self) , the fourth argument specifies, as a string, what the class of the app delegate instance should be )
→ UIApplicationMain creates a UIApplication instance ( UIApplication.shared ) 
→ UIApplicationMain creates a AppDelegate instance and assigns it to UIApplication instance's delegate property
     (It knows which class to instantiate because it is marked @main, the @main means "This is the app delegate class" )
     (If the app support scenes, UIApplicationMain calls AppDelegate instance's application(_:didFinishLaunchingWithOptions:) method , this is where you can run some of your code for the first time)
→ UIApplicationMain creates : a UISceneSession instance
                                                                 a UIWindowScene instance
                                                                 a SceneDelegate instance (declared in SceneDelegate.swift) which will serve as the window scene's delegate by default
                                                                ( Info.plist -> Application Scene Manifest -> Delegate Class Name -> $(PRODUCT_MODULE_NAME).SceneDelegate )

•  The top of the view hierarchy is a window (a UIWindow instance, which is a UIView subclass)
   (Starting in iOS 13, an app's window is a scene delegate's window property)

• You can refer to the window from  → a view's window property (if it is nil, the view is not embedded in the window)
                                                                         → the scene delegate's window property
                                                  

    
•  window has a rootViewController property 
    → Create an view controller instance (which has a main view ( its view property) )  and assign it to the window's rootViewController property 
    → The view property then becomes the window's sole subview
    → Other views must be a subview of the view to become visible to the user :

          2 ways to get your views to become subviews of the view → interface builder : drag a view from the Library into the main view as a subview
                                                                                                                                 → add code in the view controller's viewDidLoad method
                                                                                                                                       ex:    override func viewDidLoad(  ){
                                                                                                                                                         super.viewDidLoad( )
                                                                                                                                                         let myView = // create a UIView instance
                                                                                                                                                         myView.backgroundColor = .white    // (default is transparent)
                                                                                                                                                          self.view.addSubview(myView)   // add it to main view
                                                                                                                                                 }
 If the scene has a main storyboard :
→ UIApplicationMain creates a UIWindow instance and assigns it to the scene delegate's window property
→ UIApplicationMain creates the initial view controller instance (declared in ViewController.swift)and assigns it to the window's rootViewController property (The view controller now becomes the app's root view controller)
→ UIApplicationMain calls SceneDelegate instance's scene(_:willConnectTo:options:) method , this is where more of your code can run
→ UIApplicationMain calls the window's makeKeyAndVisible method to cause the app interface to appear
→ The rootViewController obtain its main view 
→ The rootViewController's viewDidLoad method is called ,this is where more of your code can run
→ The rootViewController's main view is placed into the window, where it and its subview are visible to the user, the app is now basically up and running

 If the scene doesn't have a main storyboard 
 then everything that UIApplicationMain does automatically if the app has a main storyboard must be done in code :
To create a scene delegate with no storyboard :
1. go to targets -> General -> Deployment Info -> Main Interface, and delete Main in the Main Interface field
2. go to Info.plist -> Application Scene Manifest, and delete the StoryBoard entry 
3. delete Main.storyboard in the Project navigator
4. in SceneDelegate.swift, place the following code in the scene delegates's scene(_:willConnectTo:options:) method
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                    if  let windowScene = scene as? UIWindowScene {
                            self.window = UIWindow(windowScene : windowScene)
                            self.window!.rootViewController =  MyRootViewController( ) // create a view controller instance
                            self.window!.makeKeyAndVisible( )
                    }
          }
