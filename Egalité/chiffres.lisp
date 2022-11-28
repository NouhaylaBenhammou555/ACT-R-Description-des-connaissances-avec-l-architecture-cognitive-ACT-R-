(defvar *response* nil)
(defvar *model* nil)

(defmethod rpm-window-key-event-handler ((win rpm-window) key)
  (setf *response* (string key))
  (clear-exp-window)
  (when *model* 
    (proc-display)))

(defun do-demo2 (&optional who)
  
  (reset)
  
  (if (eq who 'human)
      (setf *model* nil)
    (setf *model* t))
  
  (let* ((lis (permute-list '("1" "2" "3" "4" "5")))
         (text1 (first lis))
         (window (open-exp-window "Number recognition")))
    
    (add-text-to-exp-window :text text1 :x 125 :y 150)
    
    (setf *response* nil) 
         
    (if *model*
        (progn
          (install-device window)
          (proc-display)
          (run 10 :real-time t))
      
      (while (null *response*)
        (allow-event-manager window)))
    
    *response*))



(clear-all)

(define-model demo2

(sgp :v t :needs-mouse nil :show-focus t :trace-detail high)
  
(chunk-type read-letters state)
(chunk-type array letter)

(add-dm 
 (start isa chunk) (attend isa chunk)
 (respond isa chunk) (done isa chunk)
 (goal isa read-letters state start))

(P find-unattended-letter
   =goal>
      ISA         read-letters
      state       start
 ==>
   +visual-location>
      :attended    nil
   =goal>
      state       find-location
)

(P attend-letter
   =goal>
      ISA         read-letters
      state       find-location
   =visual-location>
   ?visual>
      state       free
==>
   +visual>
      cmd         move-attention
      screen-pos  =visual-location
   =goal>
      state       attend
)

(P encode-letter
   =goal>
      ISA         read-letters
      state       attend
   =visual>
      value       =letter
   ?imaginal>
      state       free
==>
   =goal>
      state       respond
   +imaginal>
      isa         array
      letter      =letter
)

(P respond
   =goal>
      ISA         read-letters
      state       respond
   =imaginal>
      isa         array
      letter      =letter
   ?manual>   
      state       free
==>
   =goal>
      state       done
   +manual>
      cmd         press-key
      key         =letter
)

(goal-focus goal)

)

