from etl.load import load_dataframe
from utils.logger import logger
from etl.extract import extract


def run_pipeline():
    logger.info("Pipeline started")
    
    df = extract(r"C:\Cathy\End-to-End-Ecommerce-analytics-platform\data\raw\product_category_name_translation.csv")
    load_dataframe(
        df=df,
        schema="raw",
        table_name="product_category_name_translation",
        if_exists="append"
        )

    logger.info("Pipeline completed successfully")

if __name__ == "__main__": 
    run_pipeline()

