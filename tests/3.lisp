(defpackage aoc-2022/tests/3
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/3)

(deftest day-3
  (let ((day (make-instance 'aoc-2022.3:day-3)))
    (testing "sample-1"
             (ok (eq (aoc-2022.3:run-sample-1 day)
                     157)))
    (testing "sample-2"
             (ok (eq (aoc-2022.3:run-sample-2 day)
                     70)))))

