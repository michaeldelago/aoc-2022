(uiop:define-package aoc-2022.9
  (:use :cl
   :aoc-2022.day)
  (:import-from :cl-ppcre
   #:all-matches-as-strings
   #:split)
  (:export #:day-9
   #:run
   #:run-sample-1
   #:run-sample-2))
(in-package :aoc-2022.9)

(defstruct rope
  (head (vector 0 0))
  (tail (vector 0 0))
  (path (list (vector 0 0))))

(defday 9)

;; simple reduce on the rope
(defmethod part-1 ((this day-9) input)
  (let* ((instructions (parse-input input))
        (rope (reduce #'rope-move-head instructions 
                      :initial-value (make-rope))))
    (length (remove-duplicates (rope-path rope) :test #'equalp))))

;; Pretty much the same as part-1 but make it so the rope is a list of little ropes
(defmethod part-2 ((this day-9) input)
  (let* ((instructions (parse-input input))
         (long-rope (loop repeat 9
                           for head = (make-rope) then tail
                           for tail = (make-rope :head (rope-tail head)) 
                           then (make-rope :head (rope-tail tail))
                           collect tail))
         (rope (reduce #'rope-move-head-many instructions 
                      :initial-value long-rope)))
    (length (remove-duplicates (rope-path (car (reverse rope))) :test #'equalp))))

;; (do-move tail right)
;; (do-move head left) 
(defmacro do-move (head-or-tail direction &optional (rope 'rope))
  `(,(ecase direction 
       ((up right) 'incf)
       ((down left) 'decf))
     (aref (,(intern (format nil "ROPE-~a" head-or-tail)) ,rope) 
           ,(if (or (eq direction 'left) (eq direction 'right)) 0 1))))

(defun parse-input (raw-input)
  (let* ((lines (split "\\n" raw-input))
         (instructions (mapcar (lambda (l) (cl-ppcre:split "\\s" l)) lines)))
    (mapcar (lambda (instr) 
              (list (coerce (car instr) 'character) 
                    (parse-integer (cadr instr))))
            instructions)))

;; Move the rope head. If the tail isn't adjacent, move it accordingly
(defun rope-move-head (rope instruction)
  (unless (and instruction (> (cadr instruction) 0))
    (return-from rope-move-head rope))
  (destructuring-bind (direction distance)
      instruction
    (progn 
      (cond
        ((eql direction #\U) (do-move head up))
        ((eql direction #\D) (do-move head down))
        ((eql direction #\L) (do-move head left))
        ((eql direction #\R) (do-move head right)))
      (unless (rope-tail-adjacent rope)
        (rope-follow-head rope))
      (rope-move-head rope (list direction (1- distance))))))

;; Move the a long rope (a rope of many links)
;; moves the head of the first link, and then runs "rope-follow-head" as needed
(defun rope-move-head-many (long-rope instruction)
  (unless (and instruction (> (cadr instruction) 0))
    (return-from rope-move-head-many long-rope))
  (destructuring-bind (direction distance)
      instruction
    (progn
      (let ((rope (car long-rope)))
        (cond
          ((eql direction #\U) (do-move head up))
          ((eql direction #\D) (do-move head down))
          ((eql direction #\L) (do-move head left))
          ((eql direction #\R) (do-move head right)))) 
      (dolist (rope-segment long-rope)
        (unless (rope-tail-adjacent rope-segment)
          (rope-follow-head rope-segment))) 
      (rope-move-head-many long-rope (list direction (1- distance))))))

;; true if rope tail is adjacent to the head
(defun rope-tail-adjacent (rope)
  (let* ((head-x (aref (rope-head rope) 0))
         (head-y (aref (rope-head rope) 1))
         (tail-x (aref (rope-tail rope) 0))
         (tail-y (aref (rope-tail rope) 1))
         (diff-x (abs (- head-x tail-x)))
         (diff-y (abs (- head-y tail-y))))
    (and (<= diff-x 1)
         (<= diff-y 1))))

;; Assumes rope-tail-adjacent was false
;; move the tail closer to the head
;; push the new position to the "path" list
(defun rope-follow-head (rope)
  (let* ((head-x (aref (rope-head rope) 0))
         (head-y (aref (rope-head rope) 1))
         (tail-x (aref (rope-tail rope) 0))
         (tail-y (aref (rope-tail rope) 1)))
    (progn
      (when (> (- head-x tail-x) 0)
        (do-move tail right))
      (when (< (- head-x tail-x) 0)
        (do-move tail left))
      (when (> (- head-y tail-y) 0)
        (do-move tail up))
      (when (< (- head-y tail-y) 0)
        (do-move tail down))
      (push (alexandria:copy-array (rope-tail rope))  (rope-path rope))
      rope)))


