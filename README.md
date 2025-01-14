# Open WebUI + Ollama + Postgres + Redis

This repository provides a local development environment for [Open WebUI](https://github.com/open-webui/open-webui) using Docker Compose, which includes the following services:

• PostgreSQL (with pgvector extension)  
• Redis (with custom configuration)  
• Ollama (for language model inference)  
• Node (for Svelte frontend development via Vite)  
• Open WebUI Python backend (FastAPI / Uvicorn)

Below is an overview of how to set up, run, and use this environment.

---

## Prerequisites

1. [Docker](https://docs.docker.com/get-docker/)
2. [Docker Compose](https://docs.docker.com/compose/install/)  
   • Often included in modern Docker Desktop installations.  
3. [Make](https://www.gnu.org/software/make/) (optional, but recommended)

---

## Cloning and Building

There are two main files of interest:

1. **docker-compose.yaml**  
   Describes how to build and run the services.  
2. **Makefile**  
   • Provides convenient targets to set up and run the docker-compose environment.  

### Step 1: Clone or Use Make to Prepare

If you do not already have the [open-webui](https://github.com/open-webui/open-webui) repository downloaded, the `Makefile` will handle that for you:

```bash
make open-webui
```

This targets clones the Open WebUI repository into the `./open-webui` folder if it is not already present.

### Step 2: Bring Up the Containers

Once you have everything in place, simply run:

```bash
make up
```

This command will:

1. Clone the Open WebUI repository if necessary.  
2. Start all containers in detached mode (`-d`).  

Docker Compose will build and run the needed services: `postgres`, `redis`, `ollama`, `npm` (for the frontend), and `open-webui` (the Python backend).

---

## Accessing the Services

1. **Node-based Vite Dev Server (Frontend)**  
   Accessible at [http://127.0.0.1:5173](http://127.0.0.1:5173).  
   It provides hot reloading for Svelte changes.

2. **Python Backend (FastAPI)**  
   Accessible at [http://127.0.0.1:8080](http://127.0.0.1:8080).  

3. **Postgres**  
   • By default, listens on `127.0.0.1:5432`.  
   • Database credentials come from environment variables (see docker-compose.yaml).  

4. **Redis**  
   • Exposed internally to containers at `redis://redis:6379`.  
   • Not exposed to the host by default.  
   • Uses a password of `open-webui`.  

5. **Ollama**  
   • By default, the Ollama service runs on port `11434` inside the container.  
   • Not exposed to host by default.

---

## Pulling Models with Ollama

To test locally with Ollama, you’ll need to pull at least one language model into the `ollama` container. For example, you might pull the “llama2” model.

### Step-by-Step for Pulling a Model

1. Ensure the containers are up and running:  
   ```bash
   make up
   ```
2. Exec into the `ollama` container:  
   ```bash
   docker compose exec ollama /bin/sh
   ```
3. Inside the container, run:
   ```bash
   ollama pull llama2
   ```
   (Or replace `llama2` with the model you want.)

The pulled model files will be stored in the volume mounted at `./open-webui/backend/data/ollama`.

---

## Troubleshooting & Common Tasks

• **View Logs**  
  You can view the logs of a specific service (e.g., `open-webui`) with:  
  ```bash
  docker compose logs -f open-webui
  ```
  Replace `open-webui` with any service name to view its logs.

• **Bring Everything Down**  
  To stop all containers and remove them:  
  ```bash
  make down
  ```
  or  
  ```bash
  docker compose -f docker-compose.devcontainer.yaml down
  ```

• **Cleaning Up**  
  If you need to remove volumes or clean up data:  
  ```bash
  docker compose down -v
  ```
  This will remove all containers and associated volumes. Use with caution.

---

## Environment Variables

Below are some useful environment variables (defaults shown in parentheses):

• `POSTGRES_DB` (openwebui)  
• `POSTGRES_USER` (openwebui)  
• `POSTGRES_PASSWORD` (openwebui)  
• `POSTGRES_PORT` (5432)  
• `OPEN_WEBUI_PORT` (8080)  
• `OLLAMA_NUM_THREADS` (2)  
• `WEBUI_SECRET_KEY` (tQD5RHiU42ubYJ1SeRn1)  

They can be overridden by setting them in a `.env` file or exporting them in your shell before running `docker compose`.

---

## Development Notes

• The **npm** container runs the Svelte frontend in development mode using Vite on port 5173.  
• The **open-webui** container runs the Python backend via Uvicorn on port 8080 and has a debug port open at 5678.  
• By default, [CORS is set to "*"](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) to allow local cross-origin requests from the frontend.  

---

## Contributing

If you have additions or improvements, feel free to open pull requests or issues in the respective repositories:

• [Open WebUI](https://github.com/open-webui/open-webui)  
• [This Repository (Docker Configuration)](#)

