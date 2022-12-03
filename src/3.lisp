(uiop:define-package aoc-2022.3
  (:use :cl
   :aoc-2022.day
   :aoc-2022.helpers)
  (:export #:run
   #:run-sample-1
   #:run-sample-2))
(in-package :aoc-2022.3)

(defclass day-3 (day) ())
(defparameter *day* (make-instance 'day-3 :day 3))

(defun run ()
  (do-run *day*))

(defmethod part-1 ((this day-3) input)
  (let ((rucksacks (split-newlines input)))
    (reduce #'+ 
            (mapcar #'get-rucksack-priority rucksacks))))

(defmethod part-2 ((this day-3) input)
  (let ((rucksacks (split-newlines input)))
    (reduce #'+
            (loop for (a b c) on rucksacks by #'cdddr
                  collect (match-badge a b c)))))

(defun get-rucksack-priority (rucksack)
  (let* ((midpoint (/ (length rucksack) 2))
         (front (subseq rucksack 0 midpoint))
         (back (subseq rucksack midpoint (length rucksack)))
         (found-char (loop for c across front
                           when (find c back :test #'equal)
                           return c))
         (value (char-code found-char)))
    (item-value value)))

(defun match-badge (larry curly moe)
  (let* ((found-char 
          (loop for badge across larry
                when (and (find badge curly :test #'equal)
                          (find badge moe :test #'equal))
                return badge))
        (value (char-code found-char)))
    (item-value value)))

(defun item-value (item)
  (1+ 
   (if (>= item (char-code #\a)) ;; if lowercase
       (- item (char-code #\a)) ;; char - (value of a, 97) 
       (+ 26 (- item (char-code #\A)))))) ;; char - (value of A, 60)
