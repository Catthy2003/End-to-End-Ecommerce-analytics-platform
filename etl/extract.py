import os
import pandas as pd
from utils.logger import logger
import logging

logger = logging.getLogger(__name__)

def check_file_exists(file_path):
    if not os.path.exists(file_path):
        logger.error(f"File not found: {file_path}")
        raise FileNotFoundError(f"File not found: {file_path}")
    
def validate_extension(file_path):
    if not file_path.lower().endswith(".csv"):
        logger.error("Only CSV files are supported.")
        raise ValueError("Only CSV files are supported.")

def read_csv(file_path):
    logger.info(f"Reading file: {file_path}")
    df = pd.read_csv(file_path)
    return df

def get_file_info(df, file_path):
    logger.info(f"File: {os.path.basename(file_path)}")
    logger.info(f"Rows: {df.shape[0]}")
    logger.info(f"Columns: {df.shape[1]}")
    logger.info("Column Names:")
    for col in df.columns:
        logger.info(f"- {col}")
    logger.info("Missing Values:")
    for col in df.columns:
        logger.info(f"- {col}: {df[col].isnull().sum()}")

def extract(file_path):
    check_file_exists(file_path)
    validate_extension(file_path)
    df = read_csv(file_path)
    get_file_info(df, file_path)
    return df