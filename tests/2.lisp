(defpackage aoc-2022/tests/2
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/2)

(deftest day-2
  (let ((day (make-instance 'aoc-2022.2:day-2)))
    (testing "sample-1"
             (ok (eq (aoc-2022.2:run-sample-1 day)
                     15)))
    (testing "sample-2"
             (ok (eq (aoc-2022.2:run-sample-2 day)
                     12)))))

