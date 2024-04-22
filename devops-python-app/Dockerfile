FROM python:3.8

WORKDIR /usr/src/pythonapp

COPY requirements.txt /usr/src/pythonapp/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/pythonapp

CMD ["python", "app.py"]
