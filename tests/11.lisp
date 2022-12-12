(defpackage aoc-2022/tests/11
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/11)

(deftest day-11
  (let ((day (make-instance 'aoc-2022.11:day-11)))
    (testing "sample-1"
             (ok (equal (aoc-2022.11:run-sample-1 day)
                        10605)))
    (testing "sample-2"
             (ok (equalp (aoc-2022.11:run-sample-2 day)
                         2713310158)))))
                        
