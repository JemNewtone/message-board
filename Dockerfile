# Используем базовый образ Python
#FROM python:3.11
FROM nginx
RUN apt-get update && apt-get install -y python3 python3-pip supervisor procps
# Устанавливаем переменную окружения для отключения режима буферизации вывода
ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY . /app/

RUN pip3 install -r requirements.txt --break-system-packages


RUN python3 manage.py migrate
RUN python3 manage.py collectstatic --noinput

# Копируем конфигурационный файл supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Запускаем supervisord, который будет запускать и Gunicorn, и Nginx
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Устанавливаем Nginx
#RUN apt-get update && apt-get install -y nginx nano

#№ Копируем конфигурационный файл Nginx в контейнер
##COPY nginx.conf /etc/nginx/conf.d/default.conf

# Создаем и переходим в рабочую директорию /app
#WORKDIR /app

# Копируем зависимости проекта и устанавливаем их
#COPY requirements.txt /app/
#RUN pip install -r requirements.txt 

# Копируем файлы проекта в рабочую директорию
#COPY . /app/

# Запускаем миграции и собираем статические файлы
#RUN python manage.py migrate
#RUN python manage.py collectstatic --noinput

# Устанавливаем и настраиваем Gunicorn
#COPY gunicorn_config.py /app/
#CMD ["gunicorn", "-c", "gunicorn_config.py", "django_project.wsgi:application"]

# Открываем порты для Nginx и Gunicorn
EXPOSE 80
EXPOSE 8000
