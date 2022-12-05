(uiop:define-package aoc-2022.5
  (:use :cl
   :aoc-2022.day
   :aoc-2022.helpers)
  (:import-from :cl-ppcre
   #:all-matches-as-strings)
  (:export #:day-5
   #:run
   #:run-sample-1
   #:run-sample-2))
(in-package :aoc-2022.5)
(setq *print-pretty* t)


(defclass day-5 (day)
  ((day
     :initform 5)))

(defun run (&optional sample)
  (let ((day (make-instance 'day-5)))
    (if sample
        (do-run-sample day)
        (do-run day))))

(defmethod part-1 ((this day-5) input)
  (multiple-value-bind (init instructions)
      (parse-input input)
    (let* ((final-result (reduce #'do-instruction instructions :initial-value init))
           (heads (mapcar #'car final-result)))
     (format nil "~{~A~}" heads))))

(defmethod part-2 ((this day-5) input)
  (multiple-value-bind (init instructions)
      (parse-input input)
    (let* ((final-result (reduce #'do-instruction-9001 instructions :initial-value init))
           (heads (mapcar #'car final-result)))
     (format nil "~{~A~}" heads))))

(defun parse-input (input)
  (let* ((as-lines (split-newlines input))
         (relevant-lines (reverse (loop for l in as-lines
                       until (equal l "")
                       collect l)))
         (parsed-rows (loop for row in (cdr relevant-lines)
                            collect (get-col row)))
         (serialized-stacks (reduce #'acc-rows parsed-rows 
                                    :initial-value (make-list 
                                                     (length (car parsed-rows)))))
         (raw-instr (loop for l on as-lines by #'cdr
                             if (equal (car l) "")
                               return (cdr l)))
         (parsed-instr (loop for instr in raw-instr
                             collect (mapcar #'parse-integer 
                                             (cl-ppcre:all-matches-as-strings "\\d+" instr)))))
    (values serialized-stacks parsed-instr)))


(defun get-col (row)
  (mapcar (lambda (s) (car (cl-ppcre:all-matches-as-strings "\\w+" s))) 
          (cl-ppcre:all-matches-as-strings "(\\s{3}|\\[\\w\\])\\s?" row)))

;; U
(defun acc-rows (rows line)
  (progn (loop for crate in line
               for pos from 0
               if (stringp crate)
                 do (push crate (nth pos rows)))
         rows))


;; (do-instruction '(("N" "Z) ("D" "C" "M") ("P")) 
;;                 (2 2 1))
;; => '(("C" "D" "N" "Z") 
;;       ("M") 
;;       ("P")) 
(defun do-instruction (crates instruction)
  "Recieve the crates and an instruction, and execute the instruction on the crates. Does not operate in place. Moves one crate at a time"
  (destructuring-bind (num-crates from to)
      (list (first instruction) (1- (second instruction)) (1- (third instruction)))
    (let ((from-stk (nth from crates))
          (to-stk (nth to crates))
          (new-crates (copy-tree crates))) ;; RIP the garbage collector 
      (progn (loop repeat num-crates
                          collect (progn (push (car from-stk) to-stk)
                                         (pop from-stk)))
                    (setf (nth from new-crates) from-stk)
                    (setf (nth to new-crates) to-stk)) 
      new-crates)))

;; (do-instruction '(("N" "Z) ("D" "C" "M") ("P")) 
;;                 (2 2 1))
;; => '(("D" "C" "N" "Z") 
;;      ("M") 
;;      ("P")) 
(defun do-instruction-9001 (crates instruction)
    "Recieve the crates and an instruction, and execute the instruction on the crates. Does not operate in place. Moves stacks of crates"
  (destructuring-bind (num-crates from to)
      (list (first instruction) (1- (second instruction)) (1- (third instruction)))
    (let* ((from-stk (nth from crates))
          (to-stk (nth to crates))
          (new-crates (copy-tree crates)) ;; RIP the garbage collector 
          (substack (subseq from-stk 0 num-crates))) 
      (progn 
        (setf (nth from new-crates) (subseq from-stk num-crates))
        (setf (nth to new-crates) (append substack to-stk))) 
      new-crates)))
