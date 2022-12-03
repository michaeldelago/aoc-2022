LISP?=sbcl

build: clean
	$(LISP) \
		--non-interactive \
		--eval "(asdf:load-asd #P\"$(shell pwd)/aoc-2022.asd\")" \
		--eval '(ql:quickload :aoc-2022)' \
		--eval '(asdf:make :aoc-2022 :force t)' \

clean:
	rm -rf build
		
test:
	$(LISP) \
		--non-interactive \
		--eval "(asdf:load-asd #P\"$(shell pwd)/aoc-2022.asd\")" \
		--eval '(ql:quickload :aoc-2022)' \
		--eval '(asdf:test-system :aoc-2022)' \
