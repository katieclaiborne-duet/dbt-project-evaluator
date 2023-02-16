#!/bin/bash

pip install --upgrade pip setuptools

if [[ $1 == "duckdb" ]]
then
    pip install "dbt-$1"
else
    pip install --pre "dbt-$1"
fi

cd integration_tests

dbt deps --target $1 || exit 1
dbt build -x --target $1 --full-refresh || exit 1

# test with the second project
cd ../integration_tests_2
dbt deps --target $1 || exit 1
dbt seed --full-refresh --target $1 || exit 1
dbt run -x --target $1 --full-refresh || exit 1