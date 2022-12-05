LISP?=ros run

build: clean
	$(LISP) \
		--eval "(asdf:load-asd #P\"$(shell pwd)/aoc-2022.asd\")" \
		--eval '(ql:quickload :aoc-2022)' \
		--eval '(asdf:make :aoc-2022 :force t)' \
		--quit

clean:
	rm -rf build
		
test:
	$(LISP) \
		--eval "(asdf:load-asd #P\"$(shell pwd)/aoc-2022.asd\")" \
		--eval '(ql:quickload :aoc-2022/tests)' \
		--eval '(asdf:test-system :aoc-2022)' \
		--quit
