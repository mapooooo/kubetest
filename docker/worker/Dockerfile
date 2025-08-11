FROM python:3.11-slim
WORKDIR /app
RUN pip install --no-cache-dir --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Copy worker and ETL script for reuse (both exist in apps/worker context)
COPY worker.py .
COPY etl_processor.py ./etl_processor.py
ENV PYTHONUNBUFFERED=1
CMD ["python", "worker.py"]