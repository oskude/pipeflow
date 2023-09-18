.PHONY: hot qmldir

default:
	# targets:
	#   hot    : run pipeflow and restart when source files change
	#   qmldir : generate PipeFlow/qmldir file

hot:
	ls pipeflow theme.ini libpipeflow/*.py PipeFlow/*.qml | entr -c -r -s 'clear && ./pipeflow'

qmldir:
	echo "module PipeFlow" > PipeFlow/qmldir
	@for f in $(shell find PipeFlow/ -name '[[:upper:]]**.qml' -printf "%f\n"); do \
		echo "$$(basename $$f .qml) 1.0 $${f}" >> PipeFlow/qmldir; \
	done
