(uiop:define-package aoc-2022.1
  (:use :cl
   :aoc-2022.get-input)
  (:export #:run
   #:run-sample-1
   #:run-sample-2))
(in-package :aoc-2022.1)

(defun run ()
  (format t "Part one: ~d~%" (part-1 (get-day 1)))
  (format t "Part two: ~d~%" (part-2 (get-day 1))))

(defun run-sample-1 ()
  (part-1 (get-day-sample 1)))

(defun run-sample-2 ()
  (part-2 (get-day-sample 1)))

(defun part-1 (input)
  (apply #'max (get-elves-loads-total input)))

(defun part-2 (input)
  (let* ((elves (get-elves-loads-total input))
         (sorted-elves (stable-sort elves #'>)))
    (apply #'+ (subseq sorted-elves 0 3))))

(defun get-elves-loads-total (raw-input)
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
