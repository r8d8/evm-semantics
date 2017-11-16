# These must be passed to make; see `build-docs`
BASE_DIR      =
TMP_DIR       =
TARGET_DIR    =
CFG_DIR       =

htmldoc: ${TMP_DIR}/conf.py ${TMP_DIR}/index.rst \
    ${TMP_DIR}/data.rst  ${TMP_DIR}/evm.rst  ${TMP_DIR}/ethereum.rst  ${TMP_DIR}/verification.rst  ${TMP_DIR}/analysis.rst  ${TMP_DIR}/krypto.rst  ${TMP_DIR}/issues.rst 
	sphinx-build -b dirhtml "${TMP_DIR}" "${TARGET_DIR}"

${TMP_DIR}/%.rst: ${BASE_DIR}/%.md
	mkdir -p $(dir $@)
	pandoc -o $@ $<

${TMP_DIR}/index.rst: ${CFG_DIR}/index.rst
	mkdir -p $(dir $@)
	cp $< $@

${TMP_DIR}/conf.py: ${CFG_DIR}/conf.py
	mkdir -p $(dir $@)
	cp $< $@


