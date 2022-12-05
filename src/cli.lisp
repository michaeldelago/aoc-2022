(uiop:define-package aoc-2022.cli
  (:use :cl)
  (:export #:main))
(in-package :aoc-2022.cli)

(defparameter *system-name-base* "AOC-2022.")

(opts:define-opts
  (:name :help
   :description "display this help text"
   :short #\h
   :long "help")
  (:name :day
   :description "day to execute"
   :arg-parser #'parse-integer
   :short #\d
   :long "day"
   :meta-var "DAY")
  (:name :all
   :description "run all days"
   :short #\a
   :long "all")
  (:name :sample
   :description "use sample inputs"
   :short #\s
   :long "sample")
  (:name :tz
   :description "your timezone, if your machine doesn't use the local timezone. example `--tz -5` for US/Eastern"
   :arg-parser (lambda (zone) (- (parse-integer zone)))
   :long "tz")
  (:name :latest
   :description "execute the most recently completed day"
   :short #\l
   :long "latest"))

;;; When option is set, do something
;;
;; (when-option (options op)
;;     ...)
(defmacro when-option ((options opt) &body body)
  `(let ((it (getf ,options ,opt)))
     (when it
       ,@body)))

(defun unknown-option (condition)
  (format t "warning: ~s option is unknown~%" (opts:option condition))
  (invoke-restart 'opts:skip-option))

(defun missing-option (condition)
  (declare (ignore condition))
  (invoke-restart 'opts:use-value '(EMPTY)))

(defun main ()
  (multiple-value-bind (options )
      (handler-case
          (handler-bind ((opts:unknown-option #'unknown-option)
                         (opts:missing-required-option #'missing-option))
            (opts:get-opts (uiop:command-line-arguments)))
        (opts:missing-arg (condition)
          (format t "fatal: option ~s needs an argument~%" (opts:option condition)))
        (opts:arg-parser-failed (condition)
          (format t "fatal: cannot parse ~s as argument of ~s~%"
                  (opts:raw-arg condition)
                  (opts:option condition))))
    (let ((completed-days (days-complete (latest-day-possible (getf options :tz))))
          (do-sample (getf options :sample)))
      (when-option (options :help)
        (opts:describe
          :prefix "Advent of Code 2022"
          :usage-of "aoc-2022")
        (opts:exit 0))  
      (when-option (options :latest)
        (funcall (car (last completed-days)) do-sample)
        (opts:exit 0))
      (when-option (options :all)
       (dolist (d completed-days)
         (funcall d do-sample))
        (opts:exit 0))
      (when-option (options :day)
        (when (eq it 'EMPTY)
          (format t "fatal: required option \"--day\" is missing~%")
          (opts:exit 1))
        (unless (not (and (>= it 1) (< it 26))) ;; Ensure day is within [1,25)
          (funcall (nth (1- it) completed-days) do-sample)
          (opts:exit 0))
        (format t "fatal: day is out of range: [1,26)~%")
        (opts:exit 1))
			(format t "No options specified. Check `--help` for usage information.~%")
			(opts:exit 1))))

(defun latest-day-possible (&optional my-tz)
  "Get the latest day possible for your timezone. I have no idea if this works but it feels right"
  (let* ((hour-in-seconds 3600)
         (aoc-time 5)         
         (user-unix (get-universal-time))
         (decoded-user (multiple-value-list 
                         (decode-universal-time user-unix)))
         (tz (nth 8 decoded-user))
         (formatted-time (+ 
                           (* 
                             (- (or my-tz tz) aoc-time) 
                             hour-in-seconds) 
                           user-unix)))
    (multiple-value-bind 
        (second minute hour day month year dow dst-p tz)
        (decode-universal-time formatted-time)
      (declare (ignore second minute hour month dow dst-p tz))
      (when (> year 2022)
        (return-from latest-day-possible 25))
      (if (> day 25)
          25
          day))))

(defun days-complete (max-day)
  "Get list of \"run\" functions for days that are complete"
  (let (completed) 
    (dotimes (day max-day)
      (let ((pack (find-package (format nil "~a~d" *system-name-base* (1+ day)))))
        (when pack
          (push pack completed))))
    (mapcar (lambda (x) (find-symbol "RUN" x))
            (nreverse
              completed))))

