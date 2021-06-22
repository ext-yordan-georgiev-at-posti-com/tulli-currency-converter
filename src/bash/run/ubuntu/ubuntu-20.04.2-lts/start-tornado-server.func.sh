#!/bin/bash
do_start_tornado_server(){

    export TORNADO_PORT=8888

    test -d "$HOME/.tulli-currency-converter/logs" || mkdir -p "$HOME/.tulli-currency-converter/logs"
    log_file="$HOME/.tulli-currency-converter/logs/log.out"

    ts=$(date "+%Y%m%d_%H%M%S")
    test -f "$log_file" && mv -v "$log_file" "$log_file-$ts"

    echo -e "\nStarting server at port ${TORNADO_PORT}..."
    echo -e "Logging stdoud and stderr to the file: $log_file\n"

    cd "$PRODUCT_DIR/src/python/tulli-currency-converter"
    # note:
    # The line below is necessary if the "/opt/tulli-currency-converter" folder is
    # replaced with a volume, for example using:
    # make do_create_container
    poetry install
    poetry run python -m src.tulli_currency_converter.app &> "$log_file" 2>&1 &
    cd "$PRODUCT_DIR"
    sleep 3

}
