(uiop:define-package aoc-2022.$DAY
 (:use :cl
  :aoc-2022.day)
 (:import-from :cl-ppcre
#:all-matches-as-strings
#:split)
 (:export #:day-$DAY
#:run
#:run-sample-1
#:run-sample-2))
(in-package :aoc-2022.$DAY)

(defclass day-$DAY (day)
 ((day
   :initform $DAY)))

(defun run (&optional sample)
 (let ((day (make-instance 'day-$DAY)))
  (if sample
   (do-run-sample day)
   (do-run day))))

(defmethod part-1 ((this day-$DAY) input)
 0)

(defmethod part-2 ((this day-$DAY) input)
 0)
