(defpackage aoc-2022/tests/main
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/main)

(deftest day-1
  (testing "sample-1"
           (ok (eq (aoc-2022.1:run-sample-1 aoc-2022.1::*day*)
                   24000)))
  (testing "sample-2"
           (ok (eq (aoc-2022.1:run-sample-2 aoc-2022.1::*day*)
                   45000))))

(deftest day-2
  (testing "sample-1"
           (ok (eq (aoc-2022.2:run-sample-1 aoc-2022.2::*day*)
                   15)))
  (testing "sample-2"
           (ok (eq (aoc-2022.2:run-sample-2 aoc-2022.2::*day*)
                   12))))

