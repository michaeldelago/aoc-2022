(uiop:define-package aoc-2022.2
  (:use :cl
   :aoc-2022.day)
  (:export #:run
   #:run-sample-1
   #:run-sample-2))
(in-package :aoc-2022.2)

(defclass day-2 (day) ())
(defparameter *day* (make-instance 'day-2 :day 2))

(defparameter *match* '(("A" . ROCK)
                        ("B" . PAPER)
                        ("C" . SCISSORS)
                        ("X" . ROCK)
                        ("Y" . PAPER)
                        ("Z" . SCISSORS)))

(defparameter *match-2* '(("X" . LOSE)
                          ("Y" . DRAW)
                          ("Z" . WIN)))

(defparameter *point-value* '((PAPER . 2)
                              (ROCK . 1)
                              (SCISSORS . 3)))

(defun run ()
  (do-run *day*))

(defmethod part-1 ((this day-2) input)
  (let ((splits (split-input input)))
    (reduce #'+
            (mapcar #'run-game-1 splits))))

(defmethod part-2 ((this day-2) input)
  (let ((splits (split-input input)))
    (reduce #'+
            (mapcar #'run-game-2 splits))))


(defun split-input (input)
  (let* ((lines-input (cl-ppcre:split "\\n" input))
         (many-splits (loop repeat (length lines-input) collect "\\s")))
    (mapcar #'cl-ppcre:split many-splits lines-input)))

(defun run-game-1 (game)
  (let ((opponent (alexandria:assoc-value *match* (car game) :test #'equal))
        (me (alexandria:assoc-value *match* (cadr game) :test #'equal)))
    (+ (alexandria:assoc-value *point-value* me)  
       (cond
         ((eq opponent me) 3)
         ((or (and (eq opponent 'ROCK) (eq me 'SCISSORS))
              (and (eq opponent 'PAPER) (eq me 'ROCK))
              (and (eq opponent 'SCISSORS)(eq me 'PAPER)))
          0)
         (t 6)))))

(defun run-game-2 (game)
  (let ((opponent (alexandria:assoc-value *match* (car game) :test #'equal))
        (outcome (alexandria:assoc-value *match-2* (cadr game) :test #'equal)))
    (cond
      ((eq outcome 'DRAW) (run-game-1 (list (car game) (car game))))
      ((eq outcome 'LOSE)
       (cond 
         ((eq opponent 'ROCK) (run-game-1 (list (car game) "C")))
         ((eq opponent 'PAPER) (run-game-1 (list (car game) "A")))
         ((eq opponent 'SCISSORS) (run-game-1 (list (car game) "B")))))
      ((eq outcome 'WIN)
       (cond
         ((eq opponent 'ROCK) (run-game-1 (list (car game) "B")))
         ((eq opponent 'PAPER) (run-game-1 (list (car game) "C")))
         ((eq opponent 'SCISSORS) (run-game-1 (list (car game) "A"))))))))

