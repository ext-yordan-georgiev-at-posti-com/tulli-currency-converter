#!/bin/bash
do_run_python_tests(){
    cd "$PRODUCT_DIR/src/python/tulli-currency-converter"
    poetry run python3 -m pytest
    cd "$PRODUCT_DIR"
}
