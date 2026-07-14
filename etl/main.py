from etl.validate import validate_dataframe
from etl.extract import extract

from config.schema_config import TABLE_CONFIG

for table_name in TABLE_CONFIG.keys():
    config = TABLE_CONFIG[table_name]

    validate_dataframe(
        df=extract(f"data/raw/{table_name}.csv"),
        required_columns=config["required_columns"],
        primary_keys=config["primary_keys"]
    )