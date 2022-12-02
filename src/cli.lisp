(uiop:define-package aoc-2022.cli
  (:use :cl)
  (:export #:main))
(in-package :aoc-2022.cli)

(opts:define-opts
  (:name :help
   :description "display this help text"
   :short #\h
   :long "help")
  (:name :day
   :description "day to execute"
   :arg-parser #'parse-integer
   :short #\d
   :required t
   :long "day"
   :meta-var "DAY")
  (:name :sample
   :description "run sample inputs"
   :short #\s
   :long "sample"))


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
  (invoke-restart 'opts:use-value '(EMPTY)))

(defun main (&rest argv)
  (multiple-value-bind (options free-args)
      (handler-case
          (handler-bind ((opts:unknown-option #'unknown-option)
                         (opts:missing-required-option #'missing-option))
            (opts:get-opts argv))
        (opts:missing-arg (condition)
          (format t "fatal: option ~s needs an argument~%" (opts:option condition)))
        (opts:arg-parser-failed (condition)
          (format t "fatal: cannot parse ~s as argument of ~s~%"
                  (opts:raw-arg condition)
                  (opts:option condition))))
    (when-option (options :help)
                 (opts:describe
                   :prefix "Advent of Code 2022"
                   :usage-of "ros aoc-2022.ros")
                 (opts:exit 0))
    (when-option (options :day)
                 (when (eq it 'EMPTY)
                   (format t "fatal: required option \"--day\" is missing")
                   (opts:exit 1))
                 (unless (not (and (>= it 1) (< it 26)))
                   (funcall (read-from-string (format nil "aoc-2022.~d::run" it)))
                   (opts:exit 0))
                 (format t "fatal: day is out of range: [1,26)~%")))) 
