
• 從第一根手指觸碰螢幕到全部手指離開螢幕，中間一連串的手指變化，稱為multitouch sequence

•  每當出現手指變化時，系統就會傳送一個UIEvent object (代表該手指變化)給App，通知App發生了該手指變化

•  在一個multitouch sequence中，不同手指變化而產生的UIEvent物件其實都是同一個UIEvent物件，不斷傳送給App

•  一個UIEvent物件包含了一個或多個UITouch物件（ ㄧ個UITouch物件代表一根手指頭，而該手指頭的動作(touch phase)

     對應了UITouch物件中名為phase的property) 

• 一根手指可以產生5種動作(5 touch phases)，分別為:   .began (手指第一次觸碰螢幕，而產生該UITouch物件)
								                                                                     .moved (手指在螢幕上移動); 
								                                                                     .stationary (手指停在螢幕上不動) 
                                                                                                                       .ended  (手指離開螢幕，該UITouch物件被摧毀)
                                                                                                                       .cancelled (multitouch sequence因某些原因中途被打斷）

• 每個UITouch都有一個名為view的property，當手指第一次觸碰螢幕，而產生該UITouch物件時，App會透過hit-testing來知道這個UITouch物件跟哪一個UIView有關，該UIView成為該UITouch物件中view這個property （該UIView又被稱為hit-test view)，之後在該手指離開螢幕前，該UITouch物件都會跟這個UIView物件綁在一起

因為一個UIEvent物件可能有多個UITouch，而每個UITouch所綁定的UIView物件不一定相同，因此該UIEvent會同時傳送給這些UIView物件
(若一UIEvent中該UIView所綁定的所有UITouch物件的phase都是.stationary，則那些UITouch隸屬的並不會傳送給該UIView)

• UIView object屬於UIResponder，因此有４種touch method來對應UITouch物件的4種touch phase :
     touchesBegan( _:with:) 對應 .begin
     touchesMoved( _:with:) 對應 .moved
     touchesEnded( _:with:) 對應 .ended
     touchesCancelled( _:with:) 對應 .cancelled
    第一個參數 a Set of UITouch instance whose phases corresponds to the name of the method and (normally)whose view is this UIView
    第二個參數 第一個參數中這些UITouch隸屬的UIEvent
How does a view receives a touch ?
through the view's  four  touch method

Do not retain a reference to a UITouch or UIEvent object over time; it is mutable and doesn’t belong to you. If you want to save touch information, extract and save the information, not the touch itself. 
