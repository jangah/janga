PROJECT = janga
DIALYZER = dialyzer
REBAR = rebar
REPOSRC = ../janga_repo
TARGET = ~/projects/erlang
DATE = `date +%Y-%m-%d`
CRASH_DIR = ../../crasher



all: app

tar: app 
	cd ..; tar --exclude=$(PROJECT)/log/* --exclude=$(PROJECT)/data --exclude=$(PROJECT)/.git --exclude=$(PROJECT)/etc/* --exclude=$(PROJECT)/deps/*/.git -cvf $(REPOSRC)/$(PROJECT).src.$(VERSION).tar $(PROJECT)

cpall: tarall
	cd ..;scp $(REPOSRC)/$(PROJECT).src.$(VERSION).tar $(USR)@$(HOST):$(TARGET)
	ssh $(USR)@$(HOST) 'cd $(TARGET); tar xf $(TARGET)/$(PROJECT).src.$(VERSION).tar'

cp: tar
	 cd ..;scp $(REPOSRC)/$(PROJECT).$(VERSION).tar $(USR)@$(HOST):$(TARGET)

app: deps
	@$(REBAR) compile

deps:
	@$(REBAR) get-deps

clean:
	@$(REBAR) clean
	rm -f test/*.beam
	rm -f erl_crash.dump
	rm -f log/*

tests: clean app eunit ct

eunit:
	@$(REBAR) eunit skip_deps=true


docs:
	@$(REBAR) doc skip_deps=true

cp_crash: 
	mkdir -p $(CRASH_DIR)/$(HOST)/$(DATE)
	scp $(USR)@$(HOST):$(TARGET)/$(PROJECT)/erl_crash.dump $(CRASH_DIR)/$(HOST)/$(DATE)
