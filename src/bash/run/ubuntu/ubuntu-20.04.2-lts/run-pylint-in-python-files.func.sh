#!/bin/bash
do_run_pylint_in_python_files(){
    cd "$PRODUCT_DIR/src/python/tulli-currency-converter"
    poetry run python3 -m pylint $PRODUCT_DIR/src/python/tulli-currency-converter/src
    cd "$PRODUCT_DIR"
}
