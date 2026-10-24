# Secure Microservices Inventory System

MCSC 6002 project (Option 2: Secure System Architecture + Prototype). Arman Akhmetov, Mario Silveira.

An inventory system of three .NET 10 services behind an Ocelot API gateway, with RabbitMQ events between them. Security controls: RS256 access tokens, permission checks at the gateway and in every service, mutual TLS from the gateway to the services, HMAC-signed events over AMQP with TLS, input validation and rate limiting. 37 automated attack cases test the controls; the STRIDE threat model is in the project report.

| Folder | Contents |
|---|---|
| `MCSC6002_System` | Docker Compose, setup and run scripts, attack suite, Postman collection |
| `MCSC6002_ApiGateway` | Ocelot gateway |
| `MCSC6002_IdentityService` | Login, tokens, users and roles |
| `MCSC6002_ProductService` | Brands and products; publishes product events |
| `MCSC6002_InventoryService` | Stock items; consumes product events |
| `MCSC6002_AuthLibrary`, `MCSC6002_ResponseLibrary` | Shared libraries (bundled into each service as packages) |

## Quick start

Needs Docker Desktop (running) and Git Bash. The .NET 10 SDK is needed only for the attack suite. Run every command in Git Bash.

**1. Get the code**, either way:

```bash
git clone --recursive https://github.com/eon704/MCSC6002_SecureInventory.git && cd MCSC6002_SecureInventory/MCSC6002_System
```

Or extract the zip to a short path such as `C:\MCSC6002` (long paths hit the Windows 260-character limit), then:

```bash
cd /c/MCSC6002/MCSC6002_SecureInventory/MCSC6002_System
```

**2. Set up and start** (first build takes a few minutes):

```bash
bash scripts/setup.sh && bash scripts/run.sh
```

Ready when it prints `identity up`, `product up`, `inventory up` and `gateway up`. `setup.sh` creates keys and certificates in `keys/` next to the repositories and a `.env` with random passwords; neither is ever committed.

**3. See it work:**

```bash
bash scripts/demo.sh
```

Press Enter for each of the 7 steps: each prints the request, the response, the service log line and why it happened. Step 7 runs the attack suite (needs the .NET SDK); to run it alone: `dotnet run tests/AttackTests.cs` (expect `37/37 passed.`).

Optional: import `tests/postman/MCSC6002 Attack Demo.postman_collection.json` into Postman; its description explains the setup.

## Good to know

- Gateway: https://localhost:7000. The certificate comes from the project's own CA, so browsers and curl warn unless you trust `keys/tls/ca.crt`.
- Users: `admin@cloudbase.com` and `basic@cloudbase.com`; passwords are `SEED_ADMIN_PASSWORD` and `SEED_BASIC_PASSWORD` in `MCSC6002_System/.env`.
- Login is limited to 5 calls per minute: wait a minute between runs of the demo or the attack suite. Five wrong passwords lock an account for 15 minutes.
- Logs: `docker compose logs gateway` (or `identity`, `product`, `inventory`). RabbitMQ UI: http://127.0.0.1:15672 (`RABBITMQ_USER` / `RABBITMQ_PASSWORD` in `.env`).
- Stop: `bash scripts/run.sh stop`. Start from scratch (deletes all data): `docker compose down -v`.
