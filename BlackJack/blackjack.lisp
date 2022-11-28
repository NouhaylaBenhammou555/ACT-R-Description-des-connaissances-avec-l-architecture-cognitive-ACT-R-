;*****************************
;Benhammou Nouhayla (22 149 177) 
;Derfoufi Asmae (22 148 150) 
;L'Hassnaoui Kaoutar (22 148 702)
;*****************************

(clear-all)

(define-model 1-hit-model 
    
  ;; do not change these parameters
  (sgp :esc t :bll .5 :ol t :sim-hook "1hit-bj-number-sims" :cache-sim-hook-results t :er t :lf 0)
  
 
  (sgp :v nil :ans 0.2 :mp 10 :rt  -60)
  
  ;; This type holds all the game info 
  
  (chunk-type game-state mc1 mc2 mc3 mstart mtot mresult oc1 oc2 oc3 ostart otot oresult state)
  
  ;; This chunk-type should be modified to contain the information needed
  ;; for your model's learning strategy
  
  (chunk-type learned-info mstart action)
  
  ;; Declare the slots used for the goal buffer since it is
  ;; not set in the model defintion or by the productions.
  ;; See the experiment code text for more details.
  
  (declare-buffer-usage goal game-state :all)
  
  ;; Create chunks for the items used in the slots for the game
  ;; information and state
  
  (define-chunks win lose bust retrieving start results)
    
  ;; Provide a keyboard for the model's motor module to use
  (install-device '("motor" "keyboard"))
  
  (p start               ;the game starts
     =goal>
       isa game-state
       state start
       mstart =num1
    ==>
     =goal>
       state retrieving
     +retrieval>
       isa learned-info
       mstart =num1
     - action nil)     

  (p cant-remember-game       ;player hasnt been through such a situation
     =goal>
       isa game-state
       state retrieving
     ?retrieval>
       buffer  failure
     ?manual>
       state free
    ==>
     =goal>
       state nil
     +manual>
       cmd press-key
       key "s")
  
  (p remember-game          ;player remembers such a situation
     =goal>
       isa game-state
       state retrieving
     =retrieval>
       isa learned-info
       action =act
     ?manual>
       state free
    ==>
     =goal>
       state nil
     +manual>
       cmd press-key
       key =act
     
     @retrieval>)
  
  
  (p results-should-stay-1  ;player stays and wins
     =goal>
       isa game-state
       state results
       mresult =outcome
       mresult win
       mc3 nil
       mstart =num1
     ?imaginal>
       state free
    ==>
      !output! (I =outcome)
     =goal>
       state nil
     +imaginal>
       mstart =num1
       action "s")

  (p results-should-hit-1  ;player stays and loses so he should hit
     =goal>
       isa game-state
       state results
       mresult =outcome
       mresult lose
       mc3 nil
       mstart =num1
     ?imaginal>
       state free
    ==>
      !output! (I =outcome)
     =goal>
       state nil
     +imaginal>
       mstart =num1
       action "h")

   (p results-should-stay-2 ;player hit and bust so he should stay
     =goal>
       isa game-state
       state results
       mresult =outcome
       mresult bust
      - mc3 nil
       mstart =num1
     ?imaginal>
       state free
    ==>
      !output! (I =outcome)
     =goal>
       state nil
     +imaginal>
       mstart =num1
       action "s")

    (p results-should-hit-2  ;player hits and wins
     =goal>
       isa game-state
       state results
       mresult =outcome
       mresult win
      - mc3 nil
       mstart =num1
     ?imaginal>
       state free
    ==>
      !output! (I =outcome)
     =goal>
       state nil
     +imaginal>
       mstart =num1
       action "h")

  (p results-opponent-stay  ;stay and win
     =goal>
       isa game-state
       state results
       oresult =outcome
       oresult win
       oc3 nil
       ostart =num1
     ?imaginal>
       state free
    ==>
      !output! (he =outcome)
     =goal>
       state nil
     +imaginal>
       mstart =num1
       action "s")

    (p results-opponent-hit  ;hit and win
     =goal>
       isa game-state
       state results
       oresult =outcome
       oresult win
      - oc3 nil
       ostart =num1
     ?imaginal>
       state free
    ==>
      !output! (he =outcome)
     =goal>
       state nil
     +imaginal>
       mstart =num1
       action "h")

    (p results-should-hit-3  ;hit and lose should still hit because it's not a bust
     =goal>
       isa game-state
       state results
       mresult =outcome
       mresult lose
      - mc3 nil
       mstart =num1
     ?imaginal>
       state free
    ==>
      !output! (I =outcome)
     =goal>
       state nil
     +imaginal>
       mstart =num1
       action "h")


  
  (p clear-new-imaginal-chunk
     ?imaginal>
       state free
       buffer full
     ==>
     -imaginal>)
  )
