#!/bin/bash

# Default values (can be overridden via .env)
JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
JENKINS_SECRET="${JENKINS_SECRET}"
JENKINS_AGENT_NAME="${JENKINS_AGENT_NAME:-jenkins-inbound-agent}"
AGENT_WORKDIR="/var/jenkins_home"

# Validate required variables
if [[ -z "$JENKINS_SECRET" ]]; then
    echo "Error: JENKINS_SECRET is not set"
    exit 1
fi

cd "$AGENT_WORKDIR"

echo "Downloading agent.jar from $JENKINS_URL..."
curl -sO "$JENKINS_URL/jnlpJars/agent.jar"

echo "Starting Jenkins inbound agent..."
exec java -jar agent.jar \
    -url "$JENKINS_URL" \
    -secret "$JENKINS_SECRET" \
    -name "$JENKINS_AGENT_NAME" \
    -webSocket \
    -workDir "$AGENT_WORKDIR"
