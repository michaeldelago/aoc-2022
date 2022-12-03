(uiop:define-package aoc-2022.get-input
  (:use :cl)
  (:import-from :alexandria
                #:read-file-into-string
                #:write-string-into-file)
  (:export #:get-day
           #:get-day-sample))
(in-package :aoc-2022.get-input)

(defparameter *year* 2022)
(defparameter *inputs-dir* (format nil "~a/inputs/" (uiop:getcwd)))
(defparameter *session* (uiop:getenv "AOC_SESSION"))
(defparameter *cookies* (cookie:make-cookie-jar 
                          :cookies (list 
                                     (cookie:make-cookie 
                                       :name "session" 
                                       :value *session*
                                       :origin-host "adventofcode.com" 
                                       :path "/" 
                                       :domain "adventofcode.com"))))
(defparameter *base-url* "https://adventofcode.com")
(defparameter *sample-css-path* "html body main article.day-desc pre code")

(declaim (ftype (function (fixnum) (values string &optional)) get-day))
(defun get-day (day)
  (unless (and (>= day 1) (< day 26))
    (error 'day-out-of-range :day day))
  (uiop:with-current-directory (*inputs-dir*)
    (let* ((str-day (write-to-string day))
           (filename (probe-file str-day)))
      (if filename 
          (read-file-into-string filename)
          (get-aoc-input str-day)))))

(declaim (ftype (function (integer) (values string &optional)) get-day-sample))
(defun get-day-sample (day)
  (unless (and (>= day 1) (< day 26))
    (error 'day-out-of-range :day day))
  (uiop:with-current-directory (*inputs-dir*)
    (let* ((str-day (Write-to-string day))
           (filename (format nil "~d.test" str-day)))
      (if (probe-file filename)
          (read-file-into-string filename)
          (get-aoc-sample str-day filename)))))

(declaim (ftype (function (string) (values string &optional)) get-aoc-input))
(defun get-aoc-input (day)
  (let* ((url (format nil "~a/~d/day/~d/input" *base-url* *year* day))
         (puzzle-input (dex:get url :cookie-jar *cookies*)))
    (progn (write-string-into-file puzzle-input
                                 (make-pathname :name day :directory *inputs-dir*))
         puzzle-input)))

(declaim (ftype (function (string string) (values string &optional)) get-aoc-sample))
(defun get-aoc-sample (day filename)
  (let* ((url (format nil "~a/~d/day/~d" *base-url* *year* day))
         (raw-html (dex:get url :cookie-jar *cookies*))
         (parsed (lquery:$ (initialize raw-html)))
         (sample (aref (lquery:$ parsed *sample-css-path* (text)) 0)))
    (progn (write-string-into-file sample
                                 (make-pathname :name filename :directory *inputs-dir*))
         sample)))

(define-condition day-out-of-range (error)
  ((day :initarg :day
        :initform 0
        :reader day))
  (:documentation "Error if day is out of range")
  (:report (lambda (condition stream)
             (format stream "The day you gave (~a) was out of Advent of Code's range. ~&" (day condition)))))
