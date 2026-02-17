# Startup & Deployment Manual

## 1. Prerequisites
- **Node.js**: v18.0.0 or higher.
- **NPM/PNPM**: Package manager.

## 2. Installation
1.  **Clone the repository**:
    ```bash
    git clone <repository_url>
    cd <project_directory>
    ```

2.  **Install dependencies**:
    ```bash
    npm install
    # or
    pnpm install
    ```

## 3. Configuration
1.  **Initialize Config**:
    Copy `configs/config.example.json` to `configs/config.json` (if not already present).
    ```bash
    cp configs/config.example.json configs/config.json
    ```

2.  **Edit Config**:
    Modify `configs/config.json` to set your API Keys, Ports, and other settings.
    - `SERVER_PORT`: Default `3000`.
    - `REQUIRED_API_KEY`: Key for accessing the API.

## 4. Running the Server

### Mode A: Production (Cluster/Worker Mode)
Recommended for production. Uses Node.js Cluster module to manage worker processes.
```bash
npm start
```

### Mode B: Standalone (Single Process)
Useful for development or simple deployments.
```bash
npm run start:standalone
```

### Mode C: Development
Runs with verbose logging and development settings.
```bash
npm run start:dev
```

## 5. Docker Deployment

1.  **Build Image**:
    ```bash
    docker build -t aiclient2api .
    ```

2.  **Run Container**:
    ```bash
    docker run -d \
      -p 3000:3000 \
      -v $(pwd)/configs:/app/configs \
      -v $(pwd)/logs:/app/logs \
      --name aiclient2api \
      aiclient2api
    ```

## 6. Verification
- **Access UI**: Open `http://localhost:3000` in your browser.
- **Login**: Use the API Key configured in `configs/config.json` (or default if not changed).
- **Health Check**: `GET http://localhost:3000/health` should return `{"status": "healthy"}`.

## 7. Troubleshooting
- **Logs**: Check `logs/` directory for detailed logs.
- **Port Conflict**: Ensure port 3000 is free or change `SERVER_PORT` in `configs/config.json`.
- **Permission Denied**: Ensure the process has write permissions to `configs/` and `logs/`.
