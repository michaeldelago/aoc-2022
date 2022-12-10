(defsystem "aoc-2022"
  :version "0.1.0"
  :author "Mike Delago"
  :license "0BSD"
  :depends-on ("alexandria"
               "asdf"
               "cl-cookie"
               "cl-ppcre"
               "dexador"
               "lquery"
               "uiop"
               "unix-opts")
  :components ((:module "src"
                :components
                ((:file "get-input")
                 (:file "day")
                 (:file "1")
                 (:file "2")
                 (:file "3")
                 (:file "4")
                 (:file "5")
                 (:file "6")
                 (:file "7")
                 (:file "8")
                 (:file "9")
                 (:file "cli"))))
  :description "Advent of Code 2022"
  :in-order-to ((test-op (test-op "aoc-2022/tests")))
  :build-operation "program-op"
  :build-pathname "build/aoc-2022"
  :entry-point "aoc-2022.cli:main")

(defsystem "aoc-2022/tests"
  :author "Mike Delago"
  :license "0BSD"
  :depends-on ("aoc-2022"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "1")
                 (:file "2")
                 (:file "3")
                 (:file "4")
                 (:file "5")
                 (:file "6")
                 (:file "7")
                 (:file "8")
                 (:file "9"))))
  :description "Test system for aoc-2022"
  :perform (test-op (op c) (symbol-call :rove :run c)))
