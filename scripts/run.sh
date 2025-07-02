#!/bin/bash
envPath='env' # Path to the folder where all our .env files live
env=$1
# flagFile="./tmp/env_replaced_$env"

# # Check if the environment has already been replaced
# if [ -f "$flagFile" ]; then
#   echo "Environment '$env' already replaced. Skipping..."
#   exit 0
# fi

# Detect if the system is Windows or not
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  COPY_CMD="copy"
else
  COPY_CMD="cp"
fi

# Validate if the environment input is provided
if [ -z "$1" ]; then
  echo "No environment supplied, allowed: [development, production]"
  exit 1
fi

PORT=10000
# Set the input file based on the argument
case "$1" in
  "development") INPUT=".env.development"
  PORT=10000
  ;;
  "production") INPUT=".env.production"
  PORT=10001
  ;;
  *)
    echo "Missing arguments [development|production]"
    exit 1
  ;;
esac

# Execute the appropriate copy command based on the OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  powershell.exe -Command "Copy-Item -Path '$INPUT' -Destination '.env' -Force"
else
  $COPY_CMD "$INPUT" ".env"
fi

echo "Copied '$INPUT' to '.env'"

#!/bin/bash

# Baca file .env dan export sebagai variabel lingkungan
# Ini adalah cara sederhana untuk parsing, sesuaikan jika .env lebih kompleks
export $(grep -v '^#' .env | xargs)

# Jalankan flutter run dengan --dart-define
flutter run -d chrome \
    --web-port "$PORT" \
    --dart-define=API_URL="$API_URL" \
    --dart-define=SOCKET_URL="$SOCKET_URL"