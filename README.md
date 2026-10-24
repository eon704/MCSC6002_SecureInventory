# Secure Microservices Inventory System

MCSC 6002 project (Option 2: Secure System Architecture + Prototype). Arman Akhmetov, Mario Silveira.

An inventory system of three .NET 10 services behind an Ocelot API gateway, with RabbitMQ events between them. Security controls: RS256 access tokens, permission checks at the gateway and in every service, mutual TLS from the gateway to the services, HMAC-signed events over AMQP with TLS, input validation and rate limiting. A STRIDE threat model and 37 automated attack cases go with it.

## Get the code

```bash
git clone --recursive https://github.com/eon704/MCSC6002_SecureInventory.git
```

Already cloned without `--recursive`? Run `git submodule update --init`.

| Folder | Contents |
|---|---|
| `MCSC6002_System` | Report, threat model, testing, diagrams, Docker Compose, scripts, attack suite |
| `MCSC6002_ApiGateway` | Ocelot gateway |
| `MCSC6002_IdentityService` | Login, tokens, users and roles |
| `MCSC6002_ProductService` | Brands and products; publishes product events |
| `MCSC6002_InventoryService` | Stock items; consumes product events |
| `MCSC6002_AuthLibrary`, `MCSC6002_ResponseLibrary` | Shared libraries (bundled into each service as packages) |

## Run it

Needs Docker Desktop and Git Bash; the .NET 10 SDK only for the attack suite. From `MCSC6002_System`:

```bash
bash scripts/setup.sh    # once: keys, certificates, .env with random passwords
bash scripts/run.sh      # builds and starts everything in Docker
bash scripts/demo.sh     # step-by-step demo
dotnet run tests/AttackTests.cs   # 37 attack cases
```

Keys are created in `keys/` next to the repositories and are never committed.

## Documents

- Report: `MCSC6002_System/docs/report/MCSC6002_Final_Report.pdf`
- Threat model: `MCSC6002_System/docs/threat-model.md`
- Testing: `MCSC6002_System/docs/testing.md`
- Diagrams: `MCSC6002_System/docs/diagrams/`
