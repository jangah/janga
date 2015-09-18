PROJECT = janga
DIALYZER = dialyzer
REBAR = rebar
REPO = ../../../../repository
REPOSRC = ../../repository
TARGET = ~/projects/erlang
DATE = `date +%Y-%m-%d`
CRASH_DIR = ../../crasher



all: app

tar: app 
	cd rel; tar cvf $(REPO)/$(PROJECT).$(VERSION).tar $(PROJECT)

tarall: app 
	cd ..; tar cf $(REPOSRC)/$(PROJECT).src.$(VERSION).tar $(PROJECT) --exclude log/* --exclude apps/horst/priv/config --exclude deps/gpio/priv/gpio_drv.so --exclude deps/syslog/priv/syslog_drv.so --exclude apps/roni/priv/config/accounts.conf --exclude data --exclude .git

cpall: tarall
	cd ..;scp $(REPOSRC)/$(PROJECT).src.$(VERSION).tar $(USR)@$(HOST):$(TARGET)
	ssh $(USR)@$(HOST) 'cd $(TARGET); tar xf $(TARGET)/$(PROJECT).src.$(VERSION).tar'

cp: tar
	 cd ..;scp $(REPOSRC)/$(PROJECT).$(VERSION).tar $(USR)@$(HOST):$(TARGET)

release: clean-release all
	relx -o $(REPO)/$(PROJECT)
 
clean-release: clean-projects
	rm -rf $(REPO)/$(PROJECT)

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

rcswitch:
	$(MAKE) -C apps/horst/priv/driver/remote send

cp_crash: 
	mkdir -p $(CRASH_DIR)/$(HOST)/$(DATE)
	scp $(USR)@$(HOST):$(TARGET)/$(PROJECT)/erl_crash.dump $(CRASH_DIR)/$(HOST)/$(DATE)
