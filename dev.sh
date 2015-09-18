#!/bin/sh
mkdir -p log
erl -sname jangah -setcookie nocookie -pa $PWD/apps/*/ebin $PWD/deps/*/ebin  -pz $PWD/japps/*/deps/*/ebin $PWD/japps/*/ebin -boot start_sasl -s janga_core -s observer -s reloader -mnesia dir data -config etc/app.config

