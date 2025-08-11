import os
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from faststream.rabbit import RabbitBroker
from supabase import create_client, Client

app = FastAPI()

SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_ANON_KEY", "")
supabase: Client | None = None
if SUPABASE_URL and SUPABASE_ANON_KEY:
    supabase = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)

RABBITMQ_URL = os.getenv("RABBITMQ_URL", "")
QUEUE_NAME = os.getenv("QUEUE_NAME", "jobs")
broker: RabbitBroker | None = RabbitBroker(RABBITMQ_URL) if RABBITMQ_URL else None

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/items")
def list_items():
    if not supabase:
        return JSONResponse({"items": [], "note": "Supabase not configured"}, status_code=200)
    data = supabase.table("items").select("*").limit(10).execute()
    return {"items": data.data}

@app.on_event("startup")
async def startup_broker():
    if broker is not None:
        await broker.connect()

@app.on_event("shutdown")
async def shutdown_broker():
    if broker is not None:
        await broker.close()

@app.post("/jobs")
async def create_job(payload: dict):
    if broker is None:
        return JSONResponse({"status": "error", "message": "RabbitMQ not configured"}, status_code=400)
    try:
        await broker.publish(payload, queue=QUEUE_NAME)
        return {"status": "queued", "queue": QUEUE_NAME}
    except Exception as e:
        return JSONResponse({"status": "error", "message": str(e)}, status_code=500)