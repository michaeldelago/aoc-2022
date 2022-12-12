(uiop:define-package aoc-2022.11
    (:use :cl
        :aoc-2022.day)
    (:import-from :cl-ppcre
        #:all-matches-as-strings
        #:split)
    (:export #:day-11
        #:run
        #:run-sample-1
        #:run-sample-2))
(in-package :aoc-2022.11)

(defparameter *monkey-regex* "Monkey \\d:\\n\\s+Starting items: ([\\d, ]+)\\n\\s+Operation: new = old ([\\+\\*]) ([\\d\\w]+)\\n\\s+Test: divisible by (\\d+)\\n\\s+If true: throw to monkey (\\d+)\\n\\s+If false: throw to monkey (\\d+)\\n*")

(defday 11)

(defstruct monkey
  (items (list))
  inspect-op
  (toss-decision 1)
  (friends (cons nil nil))
  (tosscount 0))

(defmethod part-1 ((this day-11) input)
  (let* ((barrel (parse-input input))
         (monkeys-after (reduce (lambda (b n)
                                  (declare (ignore n))
                                  (reduce (lambda (b m) 
                                            (monkey-toss-all m b)) b :initial-value b))
                                (loop repeat 20 collect nil) :initial-value barrel)))
    (reduce #'* (subseq 
                  (sort (mapcar #'monkey-tosscount monkeys-after) #'>=) 
                  0 2))))

(defmethod part-2 ((this day-11) input)
  (let* ((barrel (parse-input input))
         (modulus (reduce #'* (mapcar #'monkey-toss-decision barrel)))
         (monkeys-after (reduce (lambda (b n)
                                  (declare (ignore n))
                                  (reduce (lambda (b m) 
                                            (monkey-toss-all m b 1 modulus)) b :initial-value b))
                                (loop repeat 10000 collect nil) :initial-value barrel)))
    (reduce #'* (subseq 
                  (sort (mapcar #'monkey-tosscount monkeys-after) #'>=) 
                  0 2))))



(defun parse-input (raw-input)
  (let ((out (list)) 
        (scanner (cl-ppcre:create-scanner *monkey-regex*)))
    (cl-ppcre:do-register-groups
        (starting-items operation op-arg divisor friend-1 friend-2)
        (scanner raw-input)
      (let ((f1 (when (typep friend-1 'string) (parse-integer friend-1)))
            (f2 (when (typep friend-2 'string) (parse-integer friend-2)))
            (inspect-arg (if (parse-integer op-arg :junk-allowed t) (parse-integer op-arg) op-arg)))
        (push (make-monkey 
                :items (mapcar #'parse-integer (split ",\\s" starting-items))
                :inspect-op (lambda (x) (funcall (find-symbol operation "CL") 
                                                 (if (equal "old" inspect-arg) 
                                                     x 
                                                     inspect-arg) 
                                                 x)) 
                :toss-decision (when (typep divisor 'string) (parse-integer divisor)) 
                :friends (cons f1 f2)) out)))
    (reverse out)))

;; A group of monkeys is sometimes called a barrel
(defun monkey-toss-all (monkey barrel &optional (worry-level 3) modulus)
  (let ((throws-made 
          (loop for item in (monkey-items monkey)
                with throws = (make-array (list (length barrel))
                                          :initial-element (list))
                with inspect-op = (monkey-inspect-op monkey)
                for after-inspect = (funcall inspect-op item)
                for final-worry = (if (> worry-level 1) 
                                      (floor after-inspect worry-level) 
                                      (if modulus (mod after-inspect modulus) after-inspect))
                with friends = (monkey-friends monkey)
                do (progn
                     (if (zerop (mod final-worry (monkey-toss-decision monkey)))
                         (push final-worry (aref throws (car friends)))
                         (push final-worry (aref throws (cdr friends))))
                     (incf (monkey-tosscount monkey))) 
                finally (return throws))))
    (progn (setf (monkey-items monkey) (list))
           (loop for other-monkey in barrel
                 for i from 0
                 do (setf (monkey-items other-monkey) (nconc (monkey-items other-monkey) (aref throws-made i))))
           barrel)))

