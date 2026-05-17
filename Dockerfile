# Použijeme oficiální Python runtime jako základ
FROM python:3.9-slim

# Nastavíme pracovní adresář v kontejneru
WORKDIR /app

# Zkopírujeme aplikační a testovací složku do kontejneru
COPY demoapp/ ./demoapp/
COPY tests/ ./tests/

# Spustíme testy při buildu
# Parametr "discover -s tests" řekne unittestu, ať najde a spustí všechny testy ve složce tests
RUN python -m unittest discover -s tests -v

# Nastavíme příkaz, který se spustí při startu kontejneru
CMD ["python", "demoapp/app.py"]
