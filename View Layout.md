⭐️ The code for Autoresizing and AutoLayout should be placed in the view controller's viewDidLoad( ) method, Autoresizing and AutoLayout are not manual layout , they are instructions as to how this view should be resized and positioned by the runtime when layout does happen in the future
⭐️ When viewDidLoad is called, the view controller's view has been loaded, but it has not yet been inserted into the interface, the initial layout has 
      not yet taken place , so you can't do anything layout here that depends on frame, bounds ..., that sort of code should be placed in the view   
      controller's viewWillLayoutSubviews(  ) method

View layout is performed in three ways→ manual layout, autoresizing, and autolayout
Manual layout 
• The superview is sent the layoutSubviews message whenever it is resized, so you can override this method to lay out subviews manually
   (But that's a lot of code. Therefore, manual layout is rarely used)

Autoresizing
• in code, a combination of spring and struts is set through a view's autoresizingMask, the options represent springs; whatever isn't specified is a 
  strut ( default is [ .flexibleRightMargin, .flexibleBottomMargin ] , meaning the view is pinned by struts  to the top left)
• in debugging, the view's autoresizeMask is reported using the word autoresize → the external springs are LM, RM, TM, and BM
                                                                                                                                                                         → the internal springs are W and H

• in the interface builder, the view uses autoresizing by default, it will continue to do unless it is involved in a autolayout 
• to set a view's autoresizingMask, go to its Size inspector → the external solid line represents the strut 
								                                                                       → the internal arrow represents the spring                

• the Layout menu has two choices → Inferred (default) : If the view isn't involved in autolayout, its translatesAutoresizingMaskIntoConstraints is 
                                                                                                                       true, otherwise it is set to false 
                                                                          → Autoresizing Mask : the view's translatesAutoresizingMaskIntoConstraints is always true 

Autolayout (most useful) 
• Autolayout depends on the constraints (NSLayoutConstraint instance) of the view, constraints allow you to write sophisticated layoutSubviews 
  functionality without code, and is more powerful than autoresizing . Hence autolayout is the recommended way to do view layout
• Autolayout is implemented through the superview chain, if a view uses autolayout (is involved in a constraint), then automatically so do all its superviews

⭐️ a view created in code uses autoresizing by default, and has its translatesAutoresizingMaskIntoConstraints property set to true by default, meaning when the view is involved in autolayout, the autolayout engine reads the view's frame and autoresizingMask and translates them into implicit constraint, and will often conflict between your explicit constraints. The solution is to set the view's translatesAutoresizingMaskIntoConstraints to false before adding constraints, so that the implicit constraints are not generated, and the view's only constraints are your explicit constraints

Create constraints in code
There are three ways to create constraints in code → NSLayoutConstraint initializer,  Anchor notation, and Visual format notation  
 
• Instead of adding a constraint to a particular view explicitly ( addConstraint(_ :) ), you can call the activate( _ :)  method ,which takes an array of constraints, and activate them all (An activated constraint is added to the correct view automatically)    

• Instead of removing a constraint from a particular view explicitly ( removeConstraint( _: ) ), you can call the deactivate( _ : ) method ,which takes 
   an array of constraints, and deactivate them all (An deactivated constraint is removed from its view and will go out of existence)  
  
• It's sometimes useful to keep the constraints (assign it to a variable) for future use (such as switching views) .To swap constraints , deactivate the old constraints first before activating the new ones

1. NSLayoutConstraint's init(item: ...) initializer  ( too verbose, not recommended) 
  
2. Anchor notation (recommended way)
     • a view has anchor properties (widthAnchor, heightAnchor, topAnchor, bottomAnchor, leadingAnchor, trailingAnchor, centerXAnchor, 
       centerYAnchor...) these anchor values (NSLayoutAnchor subclass) has the following methods:
    
         Methods for an absolute width or height constraint → constraint(equalToConstant : )
								                                                                → constraint(greaterThanOrEqualToConstant : )
								                                                                → constraint(lessThanOrEqualToConstant : )

        Methods for constraints related to another anchor → constraint(equalTo: multiplier : constant:)
								                                                              → constraint(greaterThanOrEqualTo: multiplier : constant:)
								                                                              → constraint(lessThanOrEqualTo : multiplier : constant:)
                                                                                                                    Note: multiplier (default = 1) and constant (default = 0) can be omitted

             ex:  
                         NSLayoutConstraint.activate( [
                                   v2.leadingAnchor.constraint(equalTo: v1.leadingAnchor),
                                   v2.trailingAnchor.constraint(equalTo: v1.trailingAnchor),
                                   v2.topAnchor.constraint(equalTo: v1.topAnchor),
                                   v2.heightAnchor.constraint(equalToConstant: 10)
                           ])
        
3. Visual format notation ( useful when arranging a series of views horizontally or vertically, but can't express the safe area)

      To create a constraint using visual format notation, call NSLayoutConstraint's constraints(withVisualFormat: metrics: views: ) class method

Create constraints in the interface builder
