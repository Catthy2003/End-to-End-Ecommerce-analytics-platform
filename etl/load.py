import logging
from utils.logger import logger
from config.database import get_engine

logger = logging.getLogger(__name__)

def load_dataframe(df, schema, table_name, if_exists="append"):
    logger.info(f"Loading into {schema}.{table_name}")
    
    engine = get_engine()
    
    df.to_sql(
        name=table_name,
        con=engine,
        schema=schema,
        if_exists=if_exists,
        index=False
    )

    logger.info("Load completed")
    
    df.to_sql(
        name=table_name,
        con=engine,
        schema=schema,
        if_exists=if_exists,
        index=False
    )

    print(f"Loaded {len(df)} rows into {schema}.{table_name}")
    
