(defpackage aoc-2022/tests/5
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/5)

(deftest day-5
  (let ((day (make-instance 'aoc-2022.5:day-5)))
    (testing "sample-1"
             (ok (equal (aoc-2022.5:run-sample-1 day)
                        "CMZ")))
    (testing "sample-2"
             (ok (equal (aoc-2022.5:run-sample-2 day)
                     "MCD")))))
