(uiop:define-package aoc-2022.3
  (:use :cl
        :aoc-2022.day)
  (:export #:day-3
           #:run
           #:run-sample-1
           #:run-sample-2))
(in-package :aoc-2022.3)

(defday 3)

(defmethod part-1 ((this day-3) input)
  (let ((rucksacks (cl-ppcre:split "\\n" input)))
    (reduce #'+ 
            (mapcar #'get-rucksack-priority rucksacks))))

(defmethod part-2 ((this day-3) input)
  (let ((rucksacks (cl-ppcre:split "\\n" input)))
    (reduce #'+
            (loop for (a b c) on rucksacks by #'cdddr
                  collect (string-intersection a b c)))))

(defun get-rucksack-priority (rucksack)
  "Take a single rucksack and match the common item within both halves/pockets of it"
  (let* ((midpoint (/ (length rucksack) 2))
         (front (subseq rucksack 0 midpoint))
         (back (subseq rucksack midpoint (length rucksack))))
    (string-intersection front back)))

;; - Slightly slower 
;; - Minimal garbage generated
;; - messy code
;; - no nil protection (easy fix though) 
;(defun match-badge (larry curly moe)
;  "Take 3 elves' rucksacks and match them for a single common letter"
;  (let* ((found-char 
;           (loop for badge across larry
;                 when (and (find badge curly :test #'equal)
;                           (find badge moe :test #'equal))
;                 return badge))
;         (value (char-code found-char)))
;    (item-value value)))

;; + Slightly faster
;; + cleaner
;; - Generates a shit-ton of garbage
(defun string-intersection (&rest strings)
  (item-value (char-code (car (reduce #'nintersection 
          (mapcar (lambda (str) (coerce str 'list)) strings))))))

(defun item-value (item)
  "Match char to item priority"
  (1+ 
   (if (>= item (char-code #\a)) ;; if lowercase
       (- item (char-code #\a)) ;; char - (value of a, 97) 
       (+ 26 (- item (char-code #\A)))))) ;; char - (value of A, 60)
