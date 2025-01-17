MACRO_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOP_DIR := $(realpath $(MACRO_DIR)/..)
include $(TOP_DIR)/openram.mk

.DEFAULT_GOAL := all

SKY130_PDK ?= $(PDK_ROOT)/sky130A

OPENRAM_OPTS := $(OPENRAM_OPTS)
# Define `OPENRAM_FULL` in your environment to run a full characterize
ifeq ($(OPENRAM_FULL),)
# Do not characterize (default)
else
# Characterize
OPTS += -c
endif
# Verbosity
OPENRAM_OPTS += -v --keeptemp

CONFIG_DIR = configs
SRCS=$(filter-out disabled-% %_common.py,$(sort $(notdir $(wildcard $(CONFIG_DIR)/*.py))))
DIRS=$(basename $(SRCS))
STAMPS=$(addsuffix .ok,$(DIRS))

configs:
	@echo
	@echo "Using OpenRAM at $(OPENRAM_HOME)"
	@echo " (which is version $$(cd $(OPENRAM_HOME); git describe --tags))"
	@echo
	@echo "Configurations:"
	@for D in $(DIRS); do echo " - $$D"; done
	@echo

.PHONY: configs

BROKEN := 

WORKING_STAMPS=$(filter-out $(addsuffix .ok, $(BROKEN)), $(STAMPS))
EXAMPLE_STAMPS=$(filter example%, $(WORKING_STAMPS))
SKY130_STAMPS=$(filter sky130%, $(WORKING_STAMPS))
FREEPDK45_STAMPS=$(filter freepdk45%, $(WORKING_STAMPS))
SCN4M_SUBM_STAMPS=$(filter scn4m_subm%, $(WORKING_STAMPS))

all: | configs 
	@echo
	@echo "Building following working configs"
	@for S in $(WORKING_STAMPS); do echo " - $$S"; done
	@sleep 5
	$(MAKE) $(WORKING_STAMPS)
	@echo "Built all macros."

example: $(EXAMPLE_STAMPS)
.PHONY: example

sky130: $(SKY130_STAMPS)
.PHONY: sky130

freepdk45: $(FREEPDK45_STAMPS)
.PHONY: freepdk45

scn4m_subm: $(SCN4M_SUBM_STAMPS)
.PHONY: scn4m_subm
	
OPENRAM_TMP=$(MACRO_DIR)/$*/tmp
%.ok: configs/%.py
	@echo "Building $*"
	@mkdir -p $*
	@python3 -u $(OPENRAM_COMPILER) $(OPENRAM_OPTS) -o $* -p $(MACRO_DIR)/$* $(MACRO_DIR)/$< && touch $@

.DELETE_ON_ERROR: $(STAMPS)

$(DIRS):
	@$(MAKE) --no-print-directory $@.ok

.PHONY: $(DIRS)

clean:
	rm -rf $(STAMPS)
	rm -rf $(DIRS)
.PHONY: clean
