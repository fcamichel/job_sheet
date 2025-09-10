# Job Sheet - Task Management System

A professional task management system built with Elixir/Phoenix for managing recurring annual tasks with audit trail functionality.

## Features

- 🔐 User authentication with admin roles
- 📁 Category management (e.g., "Annual Report 2024")
- 🏢 Institution management  
- ✅ Task management with completion tracking
- 📝 Complete audit trail for all changes
- 📋 Task copying between categories
- 🎨 Modern UI with Tailwind CSS

## Prerequisites

- Elixir 1.14+
- PostgreSQL
- Node.js 18+

## Local Development Setup

1. **Clone the repository:**
```bash
git clone <your-repo-url>
cd job_sheet
```

2. **Install dependencies:**
```bash
mix deps.get
cd assets && npm install && cd ..
```

3. **Setup database:**
```bash
mix ecto.setup
```

4. **Create admin user (in IEx console):**
```bash
iex -S mix phx.server
> JobSheet.Accounts.create_admin_user("admin@example.com", "admin123")
```

5. **Start the server:**
```bash
mix phx.server
```

Visit [`localhost:4000`](http://localhost:4000)

## Deployment to Render

### 1. Prepare your repository

Add these files to your repository:

**build.sh:**
```bash
#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
mix deps.get --only prod

# Compile the project
MIX_ENV=prod mix compile

# Build assets
MIX_ENV=prod mix assets.deploy

# Build the release
MIX_ENV=prod mix release

# Run migrations
_build/prod/rel/job_sheet/bin/job_sheet eval "JobSheet.Release.migrate"
```

**render.yaml:**
```yaml
services:
  - type: web
    name: job-sheet
    env: elixir
    buildCommand: "./build.sh"
    startCommand: "_build/prod/rel/job_sheet/bin/job_sheet start"
    envVars:
      - key: SECRET_KEY_BASE
        generateValue: true
      - key: PHX_HOST
        value: job-sheet.onrender.com
      - key: PHX_SERVER
        value: true
      - key: DATABASE_URL
        fromDatabase:
          name: job-sheet-db
          property: connectionString

databases:
  - name: job-sheet-db
    plan: free
```

### 2. Create Release module

Create `lib/job_sheet/release.ex`:
```elixir
defmodule JobSheet.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :job_sheet

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
```

### 3. Deploy to Render

1. Push your code to GitHub
2. Create a new Web Service on Render
3. Connect your GitHub repository
4. Render will automatically detect the Elixir environment
5. Add environment variables:
   - `SECRET_KEY_BASE` (generate with `mix phx.gen.secret`)
   - `PHX_HOST` (your-app.onrender.com)
   - `DATABASE_URL` (will be set automatically if using Render PostgreSQL)

### 4. Post-deployment

After deployment, create an admin user via the Render Shell:

```bash
_build/prod/rel/job_sheet/bin/job_sheet remote
> JobSheet.Accounts.create_admin_user("admin@example.com", "secure_password")
```

## Environment Variables

For production deployment, set these environment variables:

- `SECRET_KEY_BASE` - Secret key for sessions (generate with `mix phx.gen.secret`)
- `DATABASE_URL` - PostgreSQL connection string
- `PHX_HOST` - Your domain name
- `PORT` - Port to bind to (default: 4000)
- `POOL_SIZE` - Database connection pool size (default: 10)

## Project Structure

```
job_sheet/
├── assets/          # Frontend assets (CSS, JS)
├── config/          # Configuration files
├── lib/
│   ├── job_sheet/   # Business logic
│   │   ├── accounts/     # User management
│   │   └── job_management/  # Tasks, categories, institutions
│   └── job_sheet_web/   # Web layer
│       ├── components/   # Reusable UI components
│       ├── controllers/  # HTTP controllers
│       └── live/        # LiveView modules
├── priv/
│   ├── repo/        # Database migrations
│   └── static/      # Static files
└── test/           # Test files
```

## Database Schema

The application uses the following main tables:

- **users** - User accounts with authentication
- **categories** - Task categories (e.g., annual reports)
- **institutions** - Organizations/institutions
- **tasks** - Individual tasks linked to categories and institutions
- **task_histories** - Audit trail for all task changes

## Usage

1. **Login** with your admin account
2. **Create Categories** from the dashboard (e.g., "Annual Report 2024")
3. **Add Institutions** (e.g., "University of Applied Sciences")
4. **Navigate to a category** to manage tasks
5. **Create tasks** for each institution
6. **Mark tasks as complete** when done
7. **View history** to see all changes
8. **Copy tasks** to new categories for recurring work

## Security Features

- Password hashing with Bcrypt
- Session-based authentication
- CSRF protection
- SQL injection prevention via Ecto
- Admin-only areas
- Audit trail for compliance

## License

MIT

## Support

For issues or questions, please open an issue on GitHub.
