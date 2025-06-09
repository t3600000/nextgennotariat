
#!/bin/bash

# This script resets and reinstalls a clean Frappe Builder setup for batoucloud.com

echo "🧨 Suppression de l'ancien environnement..."
sudo rm -rf /opt/batoucloud

echo "📁 Création du dossier et attribution des droits..."
sudo mkdir /opt/batoucloud
sudo chown -R frappe:frappe /opt/batoucloud

echo "🔁 Changement d'utilisateur..."
sudo -u frappe bash << 'EOF'
cd /opt
echo "🚀 Initialisation de Bench (Frappe v15)..."
bench init batoucloud --frappe-branch version-15

cd batoucloud

echo "🌐 Création du site batoucloud.com..."
bench new-site batoucloud.com

echo "📦 Installation de Frappe Builder..."
bench get-app builder https://github.com/frappe/builder --branch develop
bench --site batoucloud.com install-app builder

echo "🌐 Configuration de NGINX..."
bench setup nginx
EOF

echo "🔁 Redémarrage de NGINX..."
sudo service nginx restart

echo "🔧 Mise en production de Bench..."
cd /opt/batoucloud
sudo bench setup production frappe

echo "✅ Terminé. Accédez à http://batoucloud.com"
