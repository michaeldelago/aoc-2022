(uiop:define-package aoc-2022.day
  (:use :cl :aoc-2022.get-input)
  (:export #:day
           #:defday
           #:do-run
           #:do-run-sample
           #:part-1
           #:part-2
           #:run-sample-1
           #:run-sample-2))
(in-package :aoc-2022.day)

(defclass day ()
  ((day
     :initarg :day
     :accessor day)))

(defmacro defday (day-num)
  (let ((classname (intern (format nil "DAY-~d" day-num))))
    `(progn
       (defclass ,classname (day) ((day :initform ,day-num)))
       (defun ,(intern "RUN") (&optional sample)
         (let ((day (make-instance ',classname)))
           (if sample
               (do-run-sample day)
               (do-run day)))))))

(defgeneric part-1 (obj input)
  (:documentation "Implement part 1"))

(defgeneric part-2 (obj input)
  (:documentation "Implement part 2"))

(defmethod do-run ((this day) &optional sample)
  (let* ((input (if sample 
                    (get-day-sample (day this)) 
                    (get-day (day this))))
         (p1 (part-1 this input))
         (p2 (part-2 this input)))
    (format t "====== Day ~2d =======~%" (day this))
    (format t "Part one~a: ~d~%" (if sample " sample" "") p1)
    (format t "Part two~a: ~d~%" (if sample " sample" "") p2)
    (list p1 p2)))

(defmethod do-run-sample ((this day))
  (do-run this t))

(defmethod run-sample-1 ((this day) &optional (alt "test"))
  (part-1 this (get-day-sample (day this) alt)))

(defmethod run-sample-2 ((this day) &optional (alt "test"))
  (part-2 this (get-day-sample (day this) alt)))
