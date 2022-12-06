(uiop:define-package aoc-2022.6
  (:use :cl
   :aoc-2022.day
   :aoc-2022.helpers)
  (:import-from :cl-ppcre
   #:all-matches-as-strings)
  (:export #:day-6
   #:run
   #:run-sample-1
   #:run-sample-2))
(in-package :aoc-2022.6)
(setq *print-pretty* t)


(defclass day-6 (day)
  ((day
     :initform 6)))

(defun run (&optional sample)
  (let ((day (make-instance 'day-6)))
    (if sample
        (do-run-sample day)
        (do-run day))))

(defmethod part-1 ((this day-6) input)
  (let ((parsed-input (coerce input 'list)))
    (find-start-of-packet-marker parsed-input 4)))


(defmethod part-2 ((this day-6) input)
  (let ((parsed-input (coerce input 'list)))
    (find-start-of-packet-marker parsed-input 14)))

;;;  packet marker is index + 1 of the last char in `start-length` uniq characters
;; (find-start-of-packet-marker "mjqJPQMgbljsphdztnvjfqwrcgsmlb" 4)
;;                                     ^
;;   => 7
;;
(defun find-start-of-packet-marker (bytestream start-length)
  "Find the index after the packet marker for a stream of bytes"
  (loop for index from start-length
        if (= (length (remove-duplicates 
                        (subseq bytestream (- index start-length) index))) 
              start-length)  
        return index))


