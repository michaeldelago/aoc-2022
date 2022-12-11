(uiop:define-package aoc-2022.10
  (:use :cl
   :aoc-2022.day)
  (:import-from :cl-ppcre
   #:all-matches-as-strings
   #:split)
  (:export #:day-10
   #:run
   #:run-sample-1
   #:run-sample-2))
(in-package :aoc-2022.10)

(defday 10)

(defstruct cpu
  (counter 1)
  (cycle 0)
  (sig-strengths (list))
  (pixels (list)))

(defmethod part-1 ((this day-10) input)
  (let ((instructions (parse-input input)))
    (reduce #'+ 
            (cpu-sig-strengths (reduce #'execute-cpu-instruction instructions 
                    :initial-value (make-cpu))))))

(defmethod part-2 ((this day-10) input)
  (let* ((instructions (parse-input input))
         (output (reduce (lambda (states instruction)
                           (cons (execute-cpu-instruction 
                                   (copy-structure (or (car states) (make-cpu))) instruction) 
                                 states))
                         instructions :initial-value (list))))
    (print-sprites output)))

(defun parse-input (raw-input)
  (let* ((lines (split "\\n" raw-input))
         (split-lines (mapcar (lambda (l) (split "\\s" l)) lines)))
    (mapcar (lambda (line)
              (cond
                ((uiop:string-prefix-p "noop" (car line)) 
                 (cons 'noop nil))
                ((uiop:string-prefix-p "addx" (car line)) 
                 (cons 'addx 
                       (parse-integer (cadr line)))))) 
            split-lines)))

(defun execute-cpu-instruction (cpu instruction &optional (cycle-wait 0))
  (destructuring-bind (op . arg)
      instruction
    (progn
      (if (member (mod (cpu-cycle cpu) 40)  (num-neighbors (cpu-counter cpu)))
          (push "⬜" (cpu-pixels cpu))
          (push "⬛" (cpu-pixels cpu)))
      (incf (cpu-cycle cpu))
      (when (or (eq 20 (cpu-cycle cpu)) 
                (eq 20 (mod (cpu-cycle cpu) 40)))
        (push (* (cpu-cycle cpu) (cpu-counter cpu)) 
              (cpu-sig-strengths cpu)))
      
      (ecase op
        (noop cpu)
        (addx 
          (if (eq cycle-wait 1)
              (progn (setf (cpu-counter cpu) 
                           (+ (cpu-counter cpu) arg))
                     (values cpu "."))
              (execute-cpu-instruction cpu instruction 1)))))))

(defun num-neighbors (num)
  (list (1- num) num (1+ num)))

(defun print-sprites (cpu-states)
  (let* ((pixels (alexandria:flatten (mapcar #'cpu-pixels cpu-states)))
         (lines (loop for i from 40 to 240 by 40
                      collect (subseq pixels (- i 40) i)))
         (lines-as-strings (mapcar (lambda (l)
                                     (format nil "~{~a~}" (reverse l)))
                                   (reverse lines ))))
    (format nil "~%~{~a~^~%~}" lines-as-strings )))
