# BASH-isms are used in shell directives so set the shell to be bash
SHELL = bash

# Extremely crude stop-gap makefile
CXX := $(shell if [[ x${QUALIFIER} == *c7* || x${QUALIFIER} == *c14* ]]; then echo 'clang++'; else echo 'g++'; fi )


# Record what flags were used. Can dump with
# readelf -p .GCC.command.line libOscLib.so
CFLAGS := -std=c++17 -I.. -I${ROOT_INC} -I${EIGEN_INC} -I${BOOST_INC} -I${GSL_INC} -g -Wall -Wpedantic -Wextra -Werror -Wno-error=deprecated-declarations -grecord-gcc-switches
CFLAGS += $(shell if [[ x${QUALIFIER} == *debug* ]]; then echo ''; else echo '-O3'; fi )

GCC_CFLAGS := -Wno-error=maybe-uninitialized
CLANG_CFLAGS := -Wno-error=uninitialized -Wno-error=deprecated-copy-with-user-provided-copy

ifeq ($(CXX),g++)
  CFLAGS += $(GCC_CFLAGS)
else ifeq ($(CXX),clang++)
  CFLAGS += $(CLANG_CFLAGS)
else
  $(error "Unknown compiler")
endif

LDFLAGS := -L${ROOTSYS}/lib -lCore -L${GSL_LIB} -lgsl -lgslcblas

LDFLAGS_BINS := -lOscLib -L${ROOTSYS}/lib -lCore -lGraf -lGpad -lHist -lMathCore -lRIO -Llib

# Only try to use stan if the product is set up
ifdef STAN_MATH_INC
CFLAGS += -DOSCLIB_STAN -D_REENTRANT -I${SUNDIALS_INC} -I${STAN_MATH_INC} -I${TBB_INC} -Wno-unused-function

ifeq ($(STAN),stanthread)
CFLAGS += -DSTAN_THREADS
endif

# If we can't find "2019" in the version, ie it's newer than that
ifeq (,$(findstring v2019,${TBB_UPS_VERSION}))
CFLAGS += -DTBB_INTERFACE_NEW
endif

LDFLAGS_BINS += -L${TBB_LIB} -ltbb
endif

SRCS := $(wildcard *.cxx)
HDRS := $(wildcard *.h)
OBJS := $(patsubst %.cxx,tmp/%.o,$(SRCS))
BIN_SRCS := $(wildcard test/test*.cc)
BINS := $(patsubst test/test%.cc,bin/test%,$(BIN_SRCS))

all: prereqs ${OBJS} ${BINS} lib/libOscLib.so

tmp/%.o: %.cxx ${HDRS}
	${CXX} $< ${CFLAGS} -c -fpic -o $@

bin/test%: test/test%.cc ${HDRS} lib/libOscLib.so
	${CXX} $< ${CFLAGS} ${LDFLAGS_BINS} -o $@

lib/libOscLib.so: ${OBJS}
	${CXX} -shared -o $@ tmp/*.o ${LDFLAGS}

prereqs:
	@echo Checking all necessary env vars are set
	test ${ROOT_INC} # ROOT_INC
	test ${EIGEN_INC} # EIGEN_INC
	test ${BOOST_INC} # BOOST_INC
	test ${GSL_INC} # GSL_INC
	test ${ROOTSYS} # ROOTSYS
	test ${GSL_LIB} # GSL_LIB
	mkdir -p tmp
	mkdir -p lib
	mkdir -p bin

clean:
	rm tmp/*.o lib/*.so bin/*
