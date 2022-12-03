(uiop:define-package aoc-2022.1
  (:use :cl
        :aoc-2022.get-input
        :aoc-2022.day)
  (:export #:run
           #:run-sample-1
           #:run-sample-2))
(in-package :aoc-2022.1)

(defclass day-1 (day) 
  ((day
     :initform 1)))

(defun run (&optional sample)
  (let ((day (make-instance 'day-1)))
   (if sample
      (do-run-sample day)
      (do-run day))))

(defmethod part-1 ((this day-1) input)
  (apply #'max (get-elves-loads-total input)))

(defmethod part-2 ((this day-1) input)
  (let* ((elves (get-elves-loads-total input))
         (sorted-elves (stable-sort elves #'>)))
    (apply #'+ (subseq sorted-elves 0 3))))

(defmethod get-elves-loads-total (raw-input)
  (let* ((grouped (cl-ppcre:split "\\n" raw-input))
         (elves (reduce (lambda (accum x)
                          (if (equal x "")
                              (push (list) accum)
                              (push x (car accum)))
                          accum)
                        grouped
                        :initial-value (list (list))))
         (total-loads (mapcar (lambda (inv)
                                (reduce #'+ (mapcar #'parse-integer inv))) elves)))
    total-loads))
