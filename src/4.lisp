(uiop:define-package aoc-2022.4
  (:use :cl
        :aoc-2022.day)
  (:import-from :cl-ppcre
                #:all-matches-as-strings)
  (:export #:day-4
           #:run
           #:run-sample-1
           #:run-sample-2))
(in-package :aoc-2022.4)

(defday 4)

(defmethod part-1 ((this day-4) input)
  (let ((sections (split-input input)))
    (loop for jobs in sections 
          count (apply #'subset-jobs-p jobs))))

(defmethod part-2 ((this day-4) input)
  (let ((sections (split-input input)))
    (loop for jobs in sections
          count (apply #'overlapping-jobs-p jobs))))

(defun split-input (input)
  (loop for line in (cl-ppcre:split "\\n" input)
        collect (mapcar #'parse-integer (all-matches-as-strings "\\d+" line))))

(defun subset-jobs-p (a-start a-end b-start b-end)
  (or (and (<= a-start b-start)
           (>= a-end b-end))
      (and (>= a-start b-start)
           (<= a-end b-end))))

(defun overlapping-jobs-p (a-start a-end b-start b-end)
  (or (and (>= a-end b-start)
           (<= a-start b-start))
      (and (>= b-end a-start)
           (<= b-start a-start))))


;; Used for debugging and fun visialization.
;; edit loop in part such that
;;
;; (loop for jobs in sections
;;       if (apply #'overlapping-jobs-p jobs)
;;         collect jobs
;;         and do (apply #'print-overlaps jobs))
(defun print-overlaps (a-start a-end b-start b-end)
  (flet ((within-bounds (x s e) (and (>= x s) (<= x e))))
   (let* ((total-length (max a-end b-end))
        (a-out (loop for x to total-length from 0
                     if (within-bounds x a-start a-end)
                     collect x
                     else
                     collect "."))
        (b-out (loop for x to total-length from 0
                     if (within-bounds x b-start b-end)
                     collect x
                     else
                     collect ".")))
     (format t "~d-~d,~d-~d~%" a-start a-end b-start b-end)
     (format t "~{~a~}~%" a-out)
     (format t "~{~a~}~%" b-out))))
