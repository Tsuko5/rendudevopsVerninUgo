# Rendu DevOps - MongoDB

Image Docker perso pour MongoDB avec base `blog_db` et collection `posts` pré-remplies.

## Setup

```bash
docker build -t rendu-devopsverninugo:1.0.0 .
docker run -d --name TsukoYnov25 -p 2505:27017 rendu-devopsverninugo:1.0.0
```

## Accès

```bash
docker exec -it TsukoYnov25 mongosh \
  --username ugovernin \
  --password Tsuko \
  --authenticationDatabase admin \
  blog_db
```

Puis dans mongosh:

```javascript
db.posts.find().pretty();
db.posts.countDocuments();
```

## Tester le validateur

Insert valide:
```javascript
db.posts.insertOne({
  titre: "Test article",
  auteur: "Ugo devops",
  vues: 100
});
```

Insert invalide (type wrong):
```javascript
db.posts.insertOne({
  titre: "Bad article",
  auteur: "Ugo devops",
  vues: "cent"
});
```

Résultat: `MongoServerError: Document failed validation`

## Vérification

```bash
chmod +x check-status.sh
./check-status.sh TsukoYnov25
```

## Données pré-chargées

| Titre | Auteur | Vues |
|-------|--------|------|
| le meilleur | John devops | 342 |
| polytech | Evan devops | 567 |
| neuille | Damien devops | 891 |
| skibidi | Ugo devops | 124 |
| Sécurité Cloud | Frederic Devops | 456 |

## Config

- User: `ugovernin`
- Pass: `Tsuko`
- DB: `blog_db`
- Collection: `posts`
- Port: `2505`
- Non-root: oui

## Note securite

Les identifiants sont en dur uniquement pour ce rendu de cours.
En environnement reel, utiliser des variables d'environnement (ex: `MONGO_INITDB_ROOT_USERNAME`, `MONGO_INITDB_ROOT_PASSWORD`, `MONGO_USER`, `MONGO_PASS`) et ne jamais committer de secrets.
