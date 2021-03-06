PROJECT = janga
DIALYZER = dialyzer
REBAR = rebar
REPOSRC = ../janga_repo
TARGET = ~/tmp
DATE = `date +%Y-%m-%d`
CRASH_DIR = ../../crasher
BACKUP_DIR = ../../jangah_backup



all: app

tar: app 
	cd ..; tar --exclude=$(PROJECT)/Mnesia* --exclude=$(PROJECT)/www/static/preview/* --exclude=$(PROJECT)/log/* --exclude=$(PROJECT)/data --exclude=$(PROJECT)/.git --exclude=$(PROJECT)/etc/* --exclude=$(PROJECT)/japps/* --exclude=$(PROJECT)/deps/*/.git --exclude=$(PROJECT)/deps/*/src/* --exclude=$(PROJECT)/deps/*/test/* -cvf $(REPOSRC)/$(PROJECT).$(VERSION).tar $(PROJECT)

cpall: tarall
	cd ..;scp $(REPOSRC)/$(PROJECT).src.$(VERSION).tar $(USR)@$(HOST):$(TARGET)
	ssh $(USR)@$(HOST) 'cd $(TARGET); tar xf $(TARGET)/$(PROJECT).src.$(VERSION).tar'

cp: tar
	 cd ..;scp $(REPOSRC)/$(PROJECT).$(VERSION).tar $(USR)@$(HOST):$(TARGET)/$(PROJECT).$(VERSION).tar

app: deps
	@$(REBAR) compile

deps: git
	@$(REBAR) get-deps

git:
	cd ..;git clone git@gitlab.com:jangah/config.git
	cd ..;git clone git@gitlab.com:jangah/www.git
	cd etc;ln -sf ../../config/etc/app.config app.config
	cd etc;ln -sf ../../config/etc/dev.config dev.config
	ln -s ../www www
	# workaround
	git clone git@github.com:benoitc/unicode_util_compat.git deps/unicode_util_compat

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

backup:
	mkdir -p $(BACKUP_DIR)/$(HOST)/$(DATE)
	ssh $(USR)@$(HOST) 'cd ~/projects/erlang/janga/japps; tar -cf /tmp/$(HOST)_backup.tar **/priv/config/*'
	scp $(USR)@$(HOST):/tmp/$(HOST)_backup.tar $(BACKUP_DIR)/$(HOST)/$(DATE)
	scp $(USR)@$(HOST):~/projects/erlang/janga/etc/app.config $(BACKUP_DIR)/$(HOST)/$(DATE)



