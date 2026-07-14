from utils.logger import logger


def check_required_columns(df, required_columns):

    missing_columns = set(required_columns) - set(df.columns)

    if missing_columns:
        raise ValueError(
            f"Missing columns: {missing_columns}"
        )

    logger.info("Required columns validation passed")

def check_missing_primary_key(df, primary_keys):

    missing_count = df[primary_keys].isnull().sum().sum()

    if missing_count > 0:
        raise ValueError(
            f"Found {missing_count} NULL values in primary key columns"
        )

    logger.info("Primary key NULL validation passed")
    
def check_duplicate_primary_key(df, primary_keys):

    duplicate_count = df.duplicated(
        subset=primary_keys
    ).sum()

    if duplicate_count > 0:
        raise ValueError(
            f"Found {duplicate_count} duplicate primary keys"
        )

    logger.info("Primary key duplicate validation passed")
    
def validate_dataframe(
    df,
    required_columns,
    primary_keys
):

    check_required_columns(
        df,
        required_columns
    )

    check_missing_primary_key(
        df,
        primary_keys
    )

    check_duplicate_primary_key(
        df,
        primary_keys
    )

    logger.info("Data validation completed")