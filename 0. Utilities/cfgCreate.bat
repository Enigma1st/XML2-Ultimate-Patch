@ECHO OFF

copy >nul "1. Base Assets\cyclops_0101.fb.cfg" .
copy >nul "1. Base Assets\cyclops_0101_nc.fb.cfg" .

copy >nul "..\..\0. Utilities\cfgCreate.py" .\

python cfgCreate.py

move >nul *.cfg "1. Base Assets"
del cfgCreate.py