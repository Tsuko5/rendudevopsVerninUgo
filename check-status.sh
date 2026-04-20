#!/bin/bash

CONTAINER_NAME="${1:-TsukoYnov25}"

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

USER="${MONGO_USER:-${MONGO_INITDB_ROOT_USERNAME:-ugovernin}}"
PASS="${MONGO_PASS:-${MONGO_INITDB_ROOT_PASSWORD:-Tsuko}}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Vérification TsukoYnov25 ===${NC}"
echo ""

echo -e "${YELLOW}[1/4] Container up?${NC}"
if ! docker ps | grep -q "$CONTAINER_NAME"; then
  echo -e "${RED}Erreur: $CONTAINER_NAME pas démarré${NC}"
  exit 1
fi
echo -e "${GREEN}OK - Container actif${NC}"
echo ""

echo -e "${YELLOW}[2/4] DB blog_db accessible?${NC}"
docker exec "$CONTAINER_NAME" mongosh --username "$USER" --password "$PASS" --authenticationDatabase admin blog_db --eval "db.adminCommand('ping')" --quiet
if [ $? -ne 0 ]; then
  echo -e "${RED}Erreur: connexion blog_db impossible${NC}"
  exit 1
fi
echo -e "${GREEN}OK - blog_db répond${NC}"
echo ""

echo -e "${YELLOW}[3/4] Collection posts avec 5 articles?${NC}"
COUNT=$(docker exec "$CONTAINER_NAME" mongosh --username "$USER" --password "$PASS" --authenticationDatabase admin blog_db --eval "db.posts.countDocuments()" --quiet)
echo "Articles trouvés: $COUNT"
if [ "$COUNT" -lt 5 ]; then
  echo -e "${RED}Erreur: seulement $COUNT articles, besoin de 5${NC}"
  exit 1
fi
echo -e "${GREEN}OK - 5 articles présents${NC}"
echo ""

echo "Exemples:"
docker exec "$CONTAINER_NAME" mongosh --username "$USER" --password "$PASS" --authenticationDatabase admin blog_db --eval "db.posts.find({}, {titre: 1, auteur: 1, vues: 1}).limit(2).pretty()" --quiet
echo ""

echo -e "${YELLOW}[4/4] Utilisateur non-root?${NC}"
WHOAMI=$(docker exec "$CONTAINER_NAME" whoami)
echo "Utilisateur: $WHOAMI"
if [ "$WHOAMI" = "root" ]; then
  echo -e "${RED}Erreur: MongoDB run en root!${NC}"
  exit 1
fi
echo -e "${GREEN}OK - User non-root${NC}"
echo ""

echo -e "${GREEN}=== Tout fonctionne ===${NC}"
echo "✓ blog_db init"
echo "✓ 5 articles OK"
echo "✓ Non-root"
echo ""
