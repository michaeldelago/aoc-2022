(uiop:define-package aoc-2022.get-input
  (:use :cl)
  (:import-from :alexandria
                #:read-file-into-string
                #:write-string-into-file)
  (:export #:get-day
           #:get-day-sample))
(in-package :aoc-2022.get-input)

(defparameter *year* 2022)
(defparameter *base-url* "adventofcode.com")
(defparameter *sample-css-path* "html body main article.day-desc pre code")

(declaim (ftype (function (fixnum) (values string &optional)) get-day))
(defun get-day (day)
  "Get advent-of-code input for a given day"
  (unless (and (>= day 1) (< day 26))
    (error 'day-out-of-range :day day))
  (uiop:with-current-directory ((get-input-dir))
    (let* ((str-day (write-to-string day))
           (filename (probe-file str-day)))
      (if filename 
          (read-file-into-string filename)
          (get-aoc-input str-day)))))

(declaim (ftype (function (fixnum) (values string &optional)) get-day-sample))
(defun get-day-sample (day)
  "Get advent-of-code example input for a given day"
  (unless (and (>= day 1) (< day 26))
    (error 'day-out-of-range :day day))
  (uiop:with-current-directory ((get-input-dir))
    (let* ((str-day (Write-to-string day))
           (filename (format nil "~d.test" str-day)))
      (if (probe-file filename)
          (read-file-into-string filename)
          (get-aoc-sample str-day filename)))))

(declaim (ftype (function (string) (values string &optional)) get-aoc-input))
(defun get-aoc-input (day)
  (let* ((url (format nil "https://~a/~d/day/~d/input" *base-url* *year* day))
         (puzzle-input (dex:get url :cookie-jar (get-cookies))))
    (progn 
      (write-string-into-file puzzle-input (make-pathname :name day))
      puzzle-input)))

(declaim (ftype (function (string string) (values string &optional)) get-aoc-sample))
(defun get-aoc-sample (day filename)
  (let* ((url (format nil "https://~a/~d/day/~d" *base-url* *year* day))
         (raw-html (dex:get url :cookie-jar (get-cookies)))
         (parsed (lquery:$ (initialize raw-html)))
         (sample (aref (lquery:$ parsed *sample-css-path* (text)) 0)))
    (progn 
      (write-string-into-file sample (make-pathname :name filename))
      sample)))

(defun get-cookies ()
  (if (uiop:getenvp "AOC_SESSION")
      (let ((cookie (cookie:make-cookie 
                      :name "session" :value (uiop:getenv "AOC_SESSION") 
                      :origin-host *base-url* :path "/" :domain *base-url*)))
        (cookie:make-cookie-jar 
          :cookies (list cookie)))
      (error 'missing-env :var "AOC_SESSION")))

(defun get-input-dir ()
  (ensure-directories-exist
   (format nil "~aaoc-inputs/" (uiop:getcwd))
   :verbose t))

(define-condition day-out-of-range (error)
  ((day :initarg :day
        :initform 0
        :reader day))
  (:documentation "Error if day is out of range")
  (:report (lambda (condition stream)
             (format stream "The day you gave (~a) was out of Advent of Code's range. ~&" (day condition)))))

(define-condition missing-env (error)
  ((var :initarg :var
        :reader var-name))
 (:documentation "Error if an environment variable is missing")
 (:report (lambda (condition stream)
              (format stream "The environment variable ~a is undefined. ~%" (var-name condition)))))
