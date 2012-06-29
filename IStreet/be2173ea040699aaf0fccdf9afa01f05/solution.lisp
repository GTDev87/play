(defun num-sq-factorial-factors(prime factorial)
  (* 2 (num-factorial-factors-step prime factorial 0 prime)))

(defun num-factorial-factors-step(primepow factorial Sum prime)
  (let ((num (floor factorial primepow)))
    (if (= num 0)
      Sum
      (num-factorial-factors-step (* primepow prime) factorial (+ Sum num) prime))))
  
(defun sieve (n)
	(let ((bit-vector (make-array (+ 1 n) :initial-element 1 :element-type 'bit)))
	(loop for i from 2 upto (isqrt (+ 1 n)) do
		(loop for j from i
			for index = (* i j)
			until (>= index (+ 1 n)) do
			(setf (sbit bit-vector index) 0)))
	(loop for i from 2 below (length bit-vector)
		unless (zerop (sbit bit-vector i)) collect i)))
    
(setq strN (read-line))

(setq N (parse-integer strN))
    
(print (mod (reduce #'* (loop for prime in (sieve N)
  collect (+ 1 (num-sq-factorial-factors prime N)))) 1000007))