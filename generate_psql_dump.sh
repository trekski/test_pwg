export $(grep -v '^#' .env | xargs)
pg_dump -F c -b -v -f "./_psql_dump/baza.dump" -h $PSQL_HOST -U $PSQL_USERNAME $PSQL_DATABASE