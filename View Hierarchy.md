```
viewControllerA.present(viewControllerB)
```
viewControllerB 目前在最上層
- **source**: 呼叫`present`的 ViewController (viewControllerA)
- **presentingViewController**: 呼叫`present`之前，位於最上方的 ViewController, 不一定是source
- **presentedViewController**: 傳入`present`參數的 ViewController，即被 present 的 ViewController (viewControllerB)

- 被 present 的 ViewController 會被放在:
  1. **source** 的 presentedViewController
  2. **presentingViewController** 的 presentedViewController
#### 如果ViewController 的 presentedViewController 不等於nil (即該ViewController的上方已經有被Present的ViewController)，則該ViewController不能再呼叫present
- **presentingViewController** 會被放在:
  1. presentedViewController 的 presentingViewController
#### ViewController是否正在被present, 看它的`presentingViewController`是否等於nil
要dismiss被present的ViewController, 呼叫source, presentedViewController, presentingViewController 的dismiss都可以，但用呼叫presentingViewController的dismiss比較正確 (因為若presentedViewController的上方還有被Present的ViewController，則dismiss只會dismiss齊上方的ViewController，而不是本身)

• There is always only one root view controller, other view controllers are subordinate to the root view controller



• There are two kinds of subordination relationship between view controllers → parent-child relationship 
                                                                                                                                                                → presenting-presented relationship
Parent-Child relationship 
 • A view controller (parent) can contain another view controller (child), the child view controller's view, if it is in the interface at all, is a subview (at 
   some depth) of the parent view controller's view
• UINavigationController, UITabBarController, UIPageViewController are all built-in parent view controllers, you can also create your own custom 
   parent view controller (container view controller)
                                                      
Presenting-Presented relationship
                                                                                           present 
          View Controller A                  →            View Controller B
 (presenting view controller)                    (presented view controller)

Present & Dismiss a view controller (in code)

• To make a presenting view controller present a presented view controller :
   → Send presenting view controller the present( _ : animated : completion :) method with the presented view controller as its first argument 
        ( animated : takes a Bool value , completion: takes a function , which is called after the transition (including the animation) has finished ,the parameter can be omitted)
   → The presenting view controller's presentedViewController property (an Optional) =  presented view controller
   → The presented view controller's presentingViewController property (an Optional) = presenting view controller
• To dismiss the presented view controller :
   → send presenting view controller the dismiss(animated : completion :) method 
   → The presented controller's view is then removed from the interface and go out of existence while the original interface is restored 

• The transition(present & dismiss) animation can be set through presented view controller's modalTransitionStyle property

• The presentation style of the presented vc's view can be set through presented view controller's modalPresentationStyle  property
   (If modalPresentationStyle is .pageSheet or .formSheet, the user can dismiss the view controller by dragging down the view, 
     to prevent it, set presented view controller's  isModalInPresentation to true )
  
Example: 

To create a view controller class: File -> New -> File -> iOS -> Cocoa Touch class -> make it a subclass of UIViewController ->  check XIB checkbox

 class  presentingViewController : UIViewController {                                          class  presentedViewController : UIViewController {
        override func viewDidLoad( ) {                                                                                            override func viewDidLoad{
                    // ...                                                                                                                                                 //...
                presentButton.addTarget(self,                                                                                           dismissButton.addTarget(self,   
                 action: #selector(doPresent(_ :)), for: .touchUpInside)                                       action: #selector(doDismiss(_ :)), for: .touchUpInside)    
          }                                                                                                                                                           }

         @objc func doPresent( ){                                                                                                       @objc func doDismiss( ){
                  let vc = presentedViewController( )                                                                                self.presentingViewController?.dismiss(animated: true)
                   vc.modalTransitionStyle = .crossDissolve                                                          }
                   vc.modalPresentationStyle = .fullScreen                                                   }
                   self.present( vc , animated: true)
          }
  }

⭐️ The view controller to which present( _ : animated : completion :) was sent is called the source view controller 
⭐️ The view controller whose view will be replaced or covered by the presented view controller's view might not be the source view controller !
⭐️ Presented view controller's presentingViewController = The view controller whose view is replaced or covered (which might not be the source view controller) 
                                                                                                                                                                                                              
       Whose view will be replaced or covered depends on the presented view controller's modalPresentationStyle :
      • .automatic (default), .pageSheet,  .fullScreen, .overfullScreen  → The top-level view controller's view (rootViewController's view)
                                                                                                                                                       will be replaced or covered
       • .currentContext, .overCurrentContext 
           → The view controller whose view will be replaced or covered depends on definesPresentationContext (a Bool)
           → Starting from the source view controller, the runtimes walk up the chain of parent view controllers, looking for one whose  definesPresentationContext is true
           → If we do find one, that view controller's view will be replaced or covered
           → If we don't find one, .currentContext, .overCurrentContext is treated as .automatic

Communication 

• Pass data from source view controller to presented view controller 
    → easy, since source view controller typically has a reference to the presented view controller ( you can also give the presented view controller a 
          designated initializer)

• Pass data from the presented view controller back to source view controller 
   → Use delegation 
                                      
               protocol PresentedViewControllerDelegate : AnyObject {                                              class  SourceViewController : UIViewController, PresentedViewControllerDelegate {
                         func passData(data: Any)                                                                                                                                   //...
               }                                                                                                                                                                                      @objc func doPresent( ){   
              class PresentedViewController : UIViewController{                                                                                   let vc = presentedViewController( )       
                       weak var delegate : PresentedViewControllerDelegate ?                                                              vc.delegate = self      //*
                       @objc  func  doDismiss( ){                                                                                                                                 self.present( vc , animated: true)
                                 self.delegate?.passData(data: "Important Data")                                                           }
                                self.presentingViewController?.dismiss(animated: true)                                           func passData(data :Any){
                       }                                                                                                                                                                                           // ...
              }                                                                                                                                                                                       }           
								                                                                                                                                       }
								
• User can dismiss the view controller by dragging down the view, which won't call doDismiss
   Solution → override UIViewController's viewDidDisappear method 
     class PresentedViewController : UIViewController{  
            // ....
                override viewDidDisappear( _ animated: Bool) {
                   super.viewDidDisappear( animated) 
                   if  self.isBeingDismissed {
                             self.delegate?.passData(data: "Important Data")       
                  }         
          }
    }      


          
