(clear-all)

(defvar *response* nil)

(defmethod rpm-window-key-event-handler ((win rpm-window) key)
  (setf *response* (string key)))

(defun do-unit2 (&optional who)
  
  (reset)
  
  (let* ((letters (permute-list '("B" "C" "D" "F" "G" "H" "J" "K"  
                                  "L" "M" "N" "P" "Q" "R" "S" "T"  
                                  "V" "W" "X" "Y" "Z")))
         (letter1 (first letters))
         (letter2 (second letters))
         (window (open-exp-window "Letter equality"))
         (text1 letter1)
         (text2 letter1))
    
    
    (case (act-r-random 2)
      (0 (setf text1 letter2)))
    
    (add-text-to-exp-window :text text1 :x 125 :y 75)
    (add-text-to-exp-window :text text2 :x 75 :y 175)
    
    (setf *response* nil)
    
    (if (not (eq who 'human)) 
        (progn
          (install-device window)
          (proc-display)
          (run 10 :real-time t))
      (while (null *response*)
        (allow-event-manager window)))

    *response*))



(define-model unit2
    
(sgp :v t :show-focus t :needs-mouse nil)


(chunk-type read-letters state)
(chunk-type array letter1 letter2)

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

(P encode-letter1
   =goal>
      ISA         read-letters
      state       attend
   =visual>
      value       =letter
   ?imaginal>
      state       free
==>
   =goal>
      state       start
   +imaginal>
      isa         array
      letter1     =letter
)

(P encode-letter2
   =goal>
      ISA         read-letters
      state       attend
   =visual>
      value       =letter2
   =imaginal>
      isa         array
      letter1     =letter1
   ?imaginal>
      state       free
==>
   =goal>
      state       respond
   +imaginal>
      isa         array
      letter1     =letter1
      letter2     =letter2
)

(P respond-equal
   =goal>
      ISA         read-letters
      state       respond
   =imaginal>
      isa         array
      letter1     =letter
      letter2     =letter
   ?manual>   
      state       free
==>
   =goal>
      state       done
   +manual>
      cmd         press-key
      key         =letter
)

(P respond-different
   =goal>
      ISA         read-letters
      state       respond
   =imaginal>
      isa         array
      letter1     =letter
    - letter2     =letter
==>
   =goal>
      state       done
      !output!    ("Lettres affichees non egales")
)
 
(goal-focus goal)
)
