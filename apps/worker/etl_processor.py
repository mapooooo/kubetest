#!/usr/bin/env python3
"""
Simple ETL Processor for Kubernetes Learning
This script demonstrates basic ETL operations that could run in a K8s job.
"""

import os
import time
import json
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class ETLProcessor:
    def __init__(self):
        self.job_name = os.getenv('JOB_NAME', 'unknown')
        self.processing_date = os.getenv('PROCESSING_DATE', datetime.now().strftime('%Y-%m-%d'))
        
    def extract(self):
        """Simulate data extraction from source systems"""
        logger.info(f"Starting data extraction for job: {self.job_name}")
        time.sleep(2)  # Simulate API calls or file reading
        
        # Simulate extracted data
        data = [
            {"id": 1, "name": "Product A", "value": 100, "timestamp": "2024-01-01T10:00:00Z"},
            {"id": 2, "name": "Product B", "value": 200, "timestamp": "2024-01-01T10:01:00Z"},
            {"id": 3, "name": "Product C", "value": 150, "timestamp": "2024-01-01T10:02:00Z"},
        ]
        
        logger.info(f"Extracted {len(data)} records")
        return data
    
    def transform(self, data):
        """Transform the extracted data"""
        logger.info("Starting data transformation")
        time.sleep(1)  # Simulate processing time
        
        transformed_data = []
        for record in data:
            # Add processing metadata
            transformed_record = {
                **record,
                "processed_at": datetime.now().isoformat(),
                "job_id": self.job_name,
                "processing_date": self.processing_date,
                "value_usd": record["value"] * 1.1  # Simulate currency conversion
            }
            transformed_data.append(transformed_record)
        
        logger.info(f"Transformed {len(transformed_data)} records")
        return transformed_data
    
    def load(self, data):
        """Simulate loading data to target system"""
        logger.info("Starting data loading")
        time.sleep(2)  # Simulate database writes or API calls
        
        # Simulate success/failure
        success_count = len(data)
        logger.info(f"Successfully loaded {success_count} records")
        
        return {
            "status": "success",
            "records_processed": success_count,
            "job_name": self.job_name,
            "processing_date": self.processing_date,
            "completed_at": datetime.now().isoformat()
        }
    
    def run(self):
        """Execute the complete ETL pipeline"""
        logger.info(f"Starting ETL job: {self.job_name}")
        start_time = time.time()
        
        try:
            # Extract
            raw_data = self.extract()
            
            # Transform
            processed_data = self.transform(raw_data)
            
            # Load
            result = self.load(processed_data)
            
            # Calculate execution time
            execution_time = time.time() - start_time
            result["execution_time_seconds"] = round(execution_time, 2)
            
            logger.info(f"ETL job completed successfully in {execution_time:.2f} seconds")
            logger.info(f"Result: {json.dumps(result, indent=2)}")
            
            return result
            
        except Exception as e:
            logger.error(f"ETL job failed: {str(e)}")
            raise

def main():
    """Main entry point"""
    processor = ETLProcessor()
    
    try:
        result = processor.run()
        # Exit with success code
        exit(0)
    except Exception as e:
        logger.error(f"ETL process failed: {str(e)}")
        # Exit with error code
        exit(1)

if __name__ == "__main__":
    main() 