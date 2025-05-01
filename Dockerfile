FROM fyb3roptik/threadfin:latest

COPY . /guide-scrape

RUN apt-get update && apt-get install -y cron && \
    chmod +x /guide-scrape/zap2it-GuideScrape.py

RUN echo "0 4 * * * /usr/bin/python3 /guide-scrape/zap2it-GuideScrape.py -c /guide-scrape/config/zap2itconfig.ini -o /guide/guide.xml >> /guide/scrape.log 2>&1" > /etc/cron.d/guide-cron \
    && chmod 0644 /etc/cron.d/guide-cron \
    && crontab /etc/cron.d/guide-cron

ENTRYPOINT ["sh", "-c", "(/usr/bin/python3 /guide-scrape/zap2it-GuideScrape.py -c /guide-scrape/config/zap2itconfig.ini -o /guide/guide.xml | tee -a /guide/scrape.log & cron) & ${THREADFIN_BIN}/threadfin -port=${THREADFIN_PORT} -bind=${THREADFIN_BIND_IP_ADDRESS} -config=${THREADFIN_CONF} -debug=${THREADFIN_DEBUG}"]