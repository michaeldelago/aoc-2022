(uiop:define-package aoc-2022.day
  (:use :cl :aoc-2022.get-input)
  (:export #:day
           #:part-1
           #:part-2
           #:do-run
           #:run-sample-1
           #:run-sample-2))
(in-package :aoc-2022.day)

(defclass day ()
  ((day
     :initarg :day
     :accessor day)))

(defgeneric part-1 (obj input)
  (:documentation "Implement part 1"))

(defgeneric part-2 (obj input)
  (:documentation "Implement part 2"))

(defmethod do-run ((this day))
  (let ((input (get-day 
                 (day this))))
    (format t "Part one: ~d~%" (part-1 this input))
    (format t "Part two: ~d~%" (part-2 this input))))

(defmethod run-sample-1 ((this day))
  (part-1 this (get-day-sample (day this))))

(defmethod run-sample-2 ((this day))
  (part-2 this (get-day-sample (day this))))
