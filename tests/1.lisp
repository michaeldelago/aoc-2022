(defpackage aoc-2022/tests/1
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/1)

(deftest day-1
  (let ((day (make-instance 'aoc-2022.1:day-1)))
    (testing "sample-1"
             (ok (eq (aoc-2022.1:run-sample-1 day)
                     24000)))
    (testing "sample-2"
             (ok (eq (aoc-2022.1:run-sample-2 day)
                     45000)))))
