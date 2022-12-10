(uiop:define-package aoc-2022.7
  (:use :cl
   :aoc-2022.day)
  (:import-from :cl-ppcre
   #:all-matches-as-strings)
  (:export #:day-7
   #:run
   #:run-sample-1
   #:run-sample-2))
(in-package :aoc-2022.7)

;; simple struct to describe the tree
(defstruct dir	
  cwd
  files
  children
  size)

(defclass day-7 (day)
  ((day
     :initform 7)))

(defun run (&optional sample)
  (let ((day (make-instance 'day-7)))
    (if sample
        (do-run-sample day)
        (do-run day))))

(defmethod part-1 ((this day-7) input)
  (let* ((lines (cl-ppcre:split "\\n" input))
         (tree (do-filesystem lines))
         (size (alexandria:flatten (get-size tree))) 
         (small-dirs (remove-if-not (lambda (d)
                                      (< d 100000 )) size)))
    (reduce #'+ small-dirs)))

(defmethod part-2 ((this day-7) input)
  (let* ((lines (cl-ppcre:split "\\n"  input))
         (tree (do-filesystem lines))
         (size (alexandria:flatten (get-size tree)))
         (sorted (sort size #'>))
         (root (car sorted))
         (smallest-big-dir (car 
                             (nreverse 
                               (loop for val in sorted
                                     if (>= val (- root 40000000))
                                     collect val)))))
    smallest-big-dir))

;; Get a filesystem from the input
(defun do-filesystem (input)
  (let ((root (make-dir :cwd (list))))
    (reduce #'do-tree input :initial-value root)))

;; The actual meat of it. Recursively build the tree off of the lines
(defun do-tree (tree line)
  (let ((this-node (reduce (lambda (node d) 
                             (alexandria:assoc-value (dir-children node) d :test #'equal)) 
                           (reverse (dir-cwd tree)) :initial-value tree))
        (line-t (classify-line line))
        (line-ls (uiop:split-string line)))
    (cond
      ((eq line-t 'cd) ;; if CD command
       (let ((path (caddr line-ls)))
         (cond
           ((equal "/" path) (progn ()) tree)
           ((equal ".." path) (progn (pop (dir-cwd tree))
                                     tree))
           (t (progn
                (push path (dir-cwd tree))
                tree)))))
      ((eq line-t 'ls) tree) ;; ls is technically a no-op
      ((eq line-t 'dir) ;; add dir to tree
       (let ((dirname (cadr line-ls)))
         (progn (push (cons dirname (make-dir)) (dir-children this-node))
                tree)))
      ((eq line-t 'file) 
       (let ((size (parse-integer 
                     (car line-ls))) ;; add file to tree
                               (name (cadr line-ls)))
                           (progn 
                             (push (cons name size) (dir-files this-node))
                             tree))))))

;; Small helper function to classify a line
(defun classify-line (line)
  (cond
    ((uiop:string-prefix-p "$ cd" line)
     'cd)
    ((uiop:string-prefix-p "$ ls" line)
     'ls)
    ((uiop:string-prefix-p "dir" line)
     'dir)
    (t 'file)))

;; postorder traversal of the tree to get the sizes of all the leaves
(defun get-size (tree)
  (when tree
    (let* ((files-total (loop for file in (dir-files tree)
                              sum (cdr file)))
           (child-actions (loop for dir in (dir-children tree)
                                collect (get-size (cdr dir))))
           (child-sum (reduce #'+ (mapcar (lambda (d)
                                            (dir-size (cdr d))) 
                                          (dir-children tree)) :initial-value 0))
           (recur-size (+ files-total child-sum)))
      (setf (dir-size tree) recur-size)
      (cons recur-size child-actions))))
