SHELL := /bin/sh
freetype_cflags := $(shell freetype-config --cflags)
freetype_ldflags := $(shell freetype-config --libs)

all: ltparams

ltparams: main.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) $(freetype_cflags) $(freetype_ldflags) -o $@ $<

.PHONY: all
.SUFFIXES:
