(uiop:define-package aoc-2022.get-input
  (:use :cl)
  (:export #:get-day
           #:get-day-sample))
(in-package :aoc-2022.get-input)

(defparameter *year* 2022)
(defparameter *inputs-dir* (format nil "~a/inputs/" (uiop:getcwd)))

(declaim (ftype (function (integer) integer) get-day))
(defun get-day (day)
  (unless (and (>= day 1) (< day 26))
    (error 'day-out-of-range :day day))
  (uiop:with-current-directory (*inputs-dir*)
    (let* ((str-day (write-to-string day))
           (filename (probe-file str-day)))
      (if filename 
          (alexandria:read-file-into-string filename)
          (get-aoc-input str-day)))))

(defun get-day-sample (day)
  (unless (and (>= day 1) (< day 26))
    (error 'day-out-of-range :day day))
  (uiop:with-current-directory (*inputs-dir*)
    (let* ((str-day (Write-to-string day))
         (filename (format nil "~d.test" str-day)))
      (alexandria:read-file-into-string filename))))


(defun get-aoc-input (day)
  (let* ((session-id (uiop:getenv "AOC_SESSION"))
         (cookies (cookie:make-cookie-jar 
                             :cookies (list (cookie:make-cookie 
                                              :name "session" 
                                              :value session-id 
                                              :origin-host "adventofcode.com" 
                                              :path "/" 
                                              :domain "adventofcode.com"))))
         (url (format nil "https://adventofcode.com/~d/day/~d/input" *year* day))
         (puzzle-input (dex:get url :cookie-jar cookies)))
    (and (alexandria:write-string-into-file puzzle-input 
                                            (make-pathname 
                                              :name day 
                                              :directory *inputs-dir*))
         puzzle-input)))

(define-condition day-out-of-range (error)
  ((day :initarg :day
        :initform 0
        :reader day))
  (:documentation "Error if day is out of range")
  (:report (lambda (condition stream)
             (format stream "The day you gave (~a) was out of Advent of Code's range. ~&" (day condition)))))
