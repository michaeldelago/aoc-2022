(defpackage aoc-2022/tests/main
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/main)

(deftest day-1
  (testing "sample-1"
           (ok (eq (aoc-2022.1:run-sample-1)
                   24000)))
  (testing "sample-2"
           (ok (eq (aoc-2022.1:run-sample-2)
                   45000))))

