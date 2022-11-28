(clear-all)

(define-model count-by-ten
    
(sgp :esc t :lf .05 :trace-detail medium)

;; Chunk-types 

(chunk-type increment-fact preinc postinc)
(chunk-type count-by-ten count-hun count-ten count-unit inc-hun inc-ten carry)

;; Chunks 

(add-dm
	(event0 isa increment-fact preinc 0 postinc 1)
	(event1 isa increment-fact preinc 1 postinc 2)
	(event2 isa increment-fact preinc 2 postinc 3)
	(event3 isa increment-fact preinc 3 postinc 4)
	(event4 isa increment-fact preinc 4 postinc 5)
	(event5 isa increment-fact preinc 5 postinc 6)
	(event6 isa increment-fact preinc 6 postinc 7)
	(event7 isa increment-fact preinc 7 postinc 8)
	(event8 isa increment-fact preinc 8 postinc 9)
        
 (goal isa count-by-ten count-hun 0 count-ten 0 count-unit 0))

;; Productions 

(p start-count
  =goal>
    ISA count-by-ten
    inc-hun nil
    inc-ten nil
    count-hun =huns
    count-ten =tens
    count-unit =units
==>
  =goal>
    inc-ten busy
  +retrieval>
    ISA increment-fact
    preinc =tens
    !output! ("# Start count: ~S~S~S" =huns =tens =units))

(p inc-ten
  =goal>
    ISA count-by-ten
    inc-ten busy
    count-hun =huns
    count-ten =tens
    count-unit =units
  =retrieval>
    ISA increment-fact
    preinc =tens
    postinc =postinc
==>
  =goal>
    count-ten =postinc
  +retrieval>
    ISA increment-fact
    preinc =postinc
    !output! ("# Count (after increment of the tens): ~S~S~S" =huns =postinc =units))

(p inc-hun
  =goal>
    ISA count-by-ten
    inc-hun busy
    count-hun =huns
    count-ten =tens
    count-unit =units
  =retrieval>
    ISA increment-fact
    preinc =huns
    postinc =postinc
==>
  =goal>
    inc-hun nil
    inc-ten busy
    count-hun =postinc
  +retrieval>
    ISA increment-fact
    preinc 0
    !output! ("# Current count (after carry of the increment to the hundreds): ~S~S~S" =postinc =tens =units))

(p process-carry
  =goal>
    ISA count-by-ten
    inc-ten busy
    count-hun =huns
    count-ten 9
==>
  =goal>
    inc-hun busy
    inc-ten nil
    count-ten 0
  +retrieval>
    ISA increment-fact
    preinc =huns)

(P stop
   =goal>
      ISA count-by-ten
      count-ten 9
      count-hun 9
      count-unit =units
 ==>
   -goal>
   !output! ("# Final count: ~S~S~S" 9 9 9))


(goal-focus goal)
)
