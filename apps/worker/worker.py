import os
import json
import time
import logging
from supabase import create_client, Client
from faststream import FastStream
from faststream.rabbit import RabbitBroker

# Optionally import local ETL
from pathlib import Path
etl_path = Path(__file__).resolve().parent.parent / "etl" / "etl_processor.py"
if etl_path.exists():
    import importlib.util
    spec = importlib.util.spec_from_file_location("etl_processor", str(etl_path))
    etl_module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(etl_module)  # type: ignore
else:
    etl_module = None

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger("worker")

RABBITMQ_URL = os.getenv("RABBITMQ_URL", "amqp://guest:guest@localhost:5672/")
QUEUE_NAME = os.getenv("QUEUE_NAME", "jobs")
SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_SERVICE_ROLE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "")

supabase: Client | None = None
if SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY:
    supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)


def run_etl(payload: dict) -> dict:
    if etl_module and hasattr(etl_module, "ETLProcessor"):
        os.environ.setdefault("JOB_NAME", payload.get("job_name", "worker-job"))
        processor = etl_module.ETLProcessor()
        result = processor.run()
        return result
    # Fallback
    time.sleep(2)
    return {"status": "ok", "note": "no etl module found"}


broker = RabbitBroker(RABBITMQ_URL)
app = FastStream(broker)


@broker.subscriber(QUEUE_NAME)
async def handle_job(payload: dict):
    logger.info(f"Received message: {payload}")
    result = run_etl(payload)
    if supabase:
        try:
            supabase.table("etl_runs").insert({
                "job_name": payload.get("job_name", "worker-job"),
                "payload": payload,
                "result": result,
                "created_at": int(time.time())
            }).execute()
        except Exception as e:
            logger.warning(f"Failed to insert into Supabase: {e}")


def main():
    import asyncio
    asyncio.run(app.run())


if __name__ == "__main__":
    main()