import os
from fastapi import FastAPI
from fastapi.responses import JSONResponse
import json
import pika
from supabase import create_client, Client

app = FastAPI()

SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_ANON_KEY", "")
supabase: Client | None = None
if SUPABASE_URL and SUPABASE_ANON_KEY:
    supabase = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)

RABBITMQ_URL = os.getenv("RABBITMQ_URL", "")
QUEUE_NAME = os.getenv("QUEUE_NAME", "jobs")

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/items")
def list_items():
    if not supabase:
        return JSONResponse({"items": [], "note": "Supabase not configured"}, status_code=200)
    data = supabase.table("items").select("*").limit(10).execute()
    return {"items": data.data}

@app.post("/jobs")
def create_job(payload: dict):
    if not RABBITMQ_URL:
        return JSONResponse({"status": "error", "message": "RabbitMQ not configured"}, status_code=400)
    try:
        params = pika.URLParameters(RABBITMQ_URL)
        connection = pika.BlockingConnection(params)
        channel = connection.channel()
        channel.queue_declare(queue=QUEUE_NAME, durable=True)
        body = json.dumps(payload).encode("utf-8")
        channel.basic_publish(
            exchange="",
            routing_key=QUEUE_NAME,
            body=body,
            properties=pika.BasicProperties(delivery_mode=2)
        )
        connection.close()
        return {"status": "queued", "queue": QUEUE_NAME}
    except Exception as e:
        return JSONResponse({"status": "error", "message": str(e)}, status_code=500)