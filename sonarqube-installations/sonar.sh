#!/bin/bash

# SonarQube Installation Script for Linux with Java 17 Installation

# Variables
SONAR_VERSION="9.9.1.69595" # Replace with the desired SonarQube version
SONAR_DIR="/opt/sonarqube"
SONAR_USER="sonarqube"
SONAR_SERVICE="sonarqube"
JAVA_VERSION="17"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Update system and install dependencies
echo "Updating system and installing dependencies..."
apt-get update
apt-get install -y wget unzip

# Install Java 17
echo "Installing Java ${JAVA_VERSION}..."
apt-get install -y openjdk-${JAVA_VERSION}-jdk

# Verify Java installation
JAVA_PATH=$(update-alternatives --list java | grep "java-${JAVA_VERSION}-openjdk")
if [ -z "$JAVA_PATH" ]; then
  echo "Java ${JAVA_VERSION} installation failed. Please check your system."
  exit 1
else
  echo "Java ${JAVA_VERSION} installed successfully: $JAVA_PATH"
fi

# Create SonarQube user
if ! id "$SONAR_USER" &>/dev/null; then
  echo "Creating SonarQube user..."
  useradd -r -d "$SONAR_DIR" -s /bin/bash "$SONAR_USER"
  if [ $? -ne 0 ]; then
    echo "Failed to create SonarQube user. Exiting."
    exit 1
  fi
else
  echo "User '$SONAR_USER' already exists."
fi

# Download and extract SonarQube
echo "Downloading SonarQube..."
wget -q "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip" -O /tmp/sonarqube.zip

if [ ! -d "$SONAR_DIR" ]; then
  mkdir -p "$SONAR_DIR"
fi

echo "Extracting SonarQube..."
unzip -q /tmp/sonarqube.zip -d /tmp/
mv /tmp/sonarqube-${SONAR_VERSION}/* "$SONAR_DIR"
rm -rf /tmp/sonarqube.zip /tmp/sonarqube-${SONAR_VERSION}

# Set permissions
echo "Setting permissions..."
chown -R "$SONAR_USER:$SONAR_USER" "$SONAR_DIR"
chmod -R 775 "$SONAR_DIR"

# Configure SonarQube
echo "Configuring SonarQube..."
sed -i 's|#sonar.jdbc.username=|sonar.jdbc.username=sonarqube|g' "$SONAR_DIR/conf/sonar.properties"
sed -i 's|#sonar.jdbc.password=|sonar.jdbc.password=sonarqube|g' "$SONAR_DIR/conf/sonar.properties"
sed -i 's|#sonar.jdbc.url=jdbc:h2:tcp://localhost:9092/sonar|sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube|g' "$SONAR_DIR/conf/sonar.properties"

# Create systemd service
echo "Creating systemd service..."
cat <<EOF > /etc/systemd/system/${SONAR_SERVICE}.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=simple
User=${SONAR_USER}
Group=${SONAR_USER}
ExecStart=${SONAR_DIR}/bin/linux-x86-64/sonar.sh start
ExecStop=${SONAR_DIR}/bin/linux-x86-64/sonar.sh stop
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start SonarQube
echo "Starting SonarQube service..."
systemctl daemon-reload
systemctl enable "$SONAR_SERVICE"
systemctl start "$SONAR_SERVICE"

echo "SonarQube installation complete!"
echo "Access SonarQube at http://localhost:9000"