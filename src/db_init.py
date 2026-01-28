import sqlite3
import pandas as pd
import os

# Chemins relatifs
DB_PATH = os.path.join('db', 'ecommerce.db')
DATA_DIR = os.path.join('data', 'raw')

def init_db():
    # Création du dossier db s'il n'existe pas
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)

    # Connexion à la base SQLite
    conn = sqlite3.connect(DB_PATH)
    print(f"🔌 Base de données connectée : {DB_PATH}")

    # Mapping : Nom du fichier CSV -> Nom de la table SQL (plus simple)
    files_mapping = {
        'olist_customers_dataset.csv': 'customers',
        'olist_geolocation_dataset.csv': 'geolocation',
        'olist_order_items_dataset.csv': 'order_items',
        'olist_order_payments_dataset.csv': 'order_payments',
        'olist_order_reviews_dataset.csv': 'order_reviews',
        'olist_orders_dataset.csv': 'orders',
        'olist_products_dataset.csv': 'products',
        'olist_sellers_dataset.csv': 'sellers',
        'product_category_name_translation.csv': 'category_translation'
    }

    count_success = 0
    
    # Boucle sur chaque fichier pour l'injecter dans la DB
    for csv_file, table_name in files_mapping.items():
        file_path = os.path.join(DATA_DIR, csv_file)
        
        if os.path.exists(file_path):
            print(f"   Traitement de {table_name}...")
            try:
                # Lecture du CSV
                df = pd.read_csv(file_path)
                # Écriture dans la DB
                df.to_sql(table_name, conn, if_exists='replace', index=False)
                print(f"   Table '{table_name}' créée ({len(df)} lignes).")
                count_success += 1
            except Exception as e:
                print(f"   Erreur sur {table_name}: {e}")
        else:
            print(f"   Fichier MANQUANT : {csv_file}")
            print(f"      (Vérifie qu'il est bien dans {file_path})")

    conn.close()
    
    if count_success > 0:
        print(f"\n SUCCÈS : {count_success} tables ont été importées dans 'db/ecommerce.db' !")
    else:
        print("\n ÉCHEC : Aucune table n'a été importée. Vérifie tes fichiers.")

if __name__ == "__main__":
    init_db()