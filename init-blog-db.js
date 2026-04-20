db = db.getSiblingDB('blog_db');

if (!db.getCollectionNames().includes('posts')) {
  db.createCollection('posts');
}

db.runCommand({
  collMod: 'posts',
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['titre', 'auteur', 'vues'],
      properties: {
        _id: { bsonType: 'objectId' },
        titre: {
          bsonType: 'string',
          minLength: 3
        },
        auteur: {
          bsonType: 'string',
          minLength: 1
        },
        vues: {
          bsonType: 'int',
          minimum: 0
        },
        contenu: {
          bsonType: 'string'
        },
        dateCreation: {
          bsonType: 'date'
        }
      },
      additionalProperties: false
    }
  }
});

const articles = [
  {
    titre: 'le meilleur',
    auteur: 'John devops',
    vues: 342,
    contenu: 'le plus fort devops',
    dateCreation: new Date('2024-01-15')
  },
  {
    titre: 'polytech',
    auteur: 'Evan devops',
    vues: 567,
    contenu: 'bien jouer pour polytech',
    dateCreation: new Date('2024-01-20')
  },
  {
    titre: 'neuille',
    auteur: 'Damien devops',
    vues: 891,
    contenu: 'brawl stars',
    dateCreation: new Date('2024-02-01')
  },
  {
    titre: 'skibidi',
    auteur: 'Ugo devops',
    vues: 124,
    contenu: 'League of legends',
    dateCreation: new Date('2024-02-10')
  },
  {
    titre: 'Sécurité Cloud',
    auteur: 'Frederic Devops',
    vues: 456,
    contenu: 'Rocket league.',
    dateCreation: new Date('2024-02-20')
  }
];

db.posts.insertMany(articles);

print('✓ blog_db initialisée');
print('✓ Collection posts créée');
print('✓ 5 articles insérés');
