(ns solution
  (:gen-class))

(def powers-of-2
  (map #(bit-shift-left 1 %)(range 32)))

(def max-int
  (bit-shift-left 1 32))

(defn power-divide [number power]
  (quot number
    (bit-shift-left 1 power)))

(defn contained-power-multiple [number index]
  (* (bit-shift-left 1 (+ index 1)) (power-divide number (+ index 1))))

(defn sum-of-contained-ones [vals]
  (reduce +
    (map #(/ % 2) vals)))

(defn sum-of-remainders-ones [number vals]
  (let [contained-values (map-indexed vector vals)]
    (reduce +
      (filter #(> % 0)
        (map #(- (- number (second %)) (bit-shift-left 1 (first %))) contained-values)))))
      
(defn determine-ones-from-0 [number]
  (let [contained-values (map #(contained-power-multiple number %) (range 32))]
    (+ 
      (sum-of-contained-ones contained-values)
      (sum-of-remainders-ones number contained-values))))

(defn determine-ones-with-difference [range]    
  (- (determine-ones-from-0 (last range)) (determine-ones-from-0 (first range))))

(defn convert-ranges-to-unsigned [range]
  (if (< (first range) 0)
    (if (< (last range) 0)
      [[(+ max-int (first range)) (+ max-int (+ 1 (last range)))]]
      [[(+ max-int (first range)) max-int] [0 (+ 1 (last range))]])
    [[(first range) (+ 1 (last range))]]))

(defn determine-ones-in-range [range]      
  (reduce +
    (map determine-ones-with-difference
      (convert-ranges-to-unsigned range))))

(defn parse-line-to-array []
  (load-string (str \[ (read-line) \])))

(defn -main []
  (dotimes [n (first (parse-line-to-array))]
    (println
      (determine-ones-in-range (parse-line-to-array)))))
