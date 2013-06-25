# Flags passed to the compile module.
COMP_FLAGS = +debug_info +warn_shadow_vars
# Flags passed directly to erlc.
ERLC_FLAGS = -I include -o ebin -Werror -pa src $(COMP_FLAGS)

# The list of all erlang source files.
ERL_FILES = $(wildcard src/*.erl)
# And the corresponding beam filenames.
OBJ_FILES = $(addprefix ebin/,$(notdir $(ERL_FILES:.erl=.beam)))


all: c plt d


# Remove all object files, read: .beam files in ebin.
clean:
	-rm -fv ebin/*

# Remove all object files and the dependencies.
cleanall: clean
	rm -f script/gen_plt

# The compile task.
c: $(OBJ_FILES)

# Fetch and stage any dependencies.
deps:
	cd script; file gen_plt >/dev/null || \
	curl https://raw.github.com/johannesh/edo/basics/build/gen_plt -o gen_plt \
	&& chmod +x gen_plt

# Generate or update the dialyzer PLTs for the basic apps and this project.
plt: deps $(OBJ_FILES)
	script/gen_plt

# Run dialyzer for a single or for all modules in ebin.
MOD?=`find ebin -name '*.beam'`
d: c
	dialyzer -r ebin --build_plt --output_plt ~/.dialyzer/plts/ec_test.plt
	dialyzer $(MOD) -q -nn --plts `find ~/.dialyzer/plts -name '*.plt'` \
	-Wno_return -Wunmatched_returns -Werror_handling

# Compile the corresponding .beam file for each erlang source file.
ebin/%.beam: src/%.erl
	erlc $(ERLC_FLAGS) $<
