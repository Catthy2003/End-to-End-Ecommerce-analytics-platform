from etl.load import load_dataframe
from utils.logger import logger
from etl.extract import extract


from config.schema_config import TABLE_CONFIG

def run_pipeline():
    logger.info("Pipeline started")
    
    for table_name in TABLE_CONFIG.keys():
        config = TABLE_CONFIG[table_name]["path"]
        
        df = extract(config)
    
        load_dataframe(
            df=df,
            schema="raw",
            table_name=table_name,
            if_exists="append"
        )

    logger.info("Pipeline completed successfully")

if __name__ == "__main__": 
    run_pipeline()

