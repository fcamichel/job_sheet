# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     JobSheet.Repo.insert!(%JobSheet.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias JobSheet.Accounts

# Create admin user if it doesn't exist
case Accounts.get_user_by_email("admin@example.com") do
  nil ->
    {:ok, admin} = Accounts.create_admin_user("admin@example.com", "admin123456")
    IO.puts("Admin user created with email: admin@example.com and password: admin123456")
    IO.puts("⚠️  Please change the password after first login!")
  
  _user ->
    IO.puts("Admin user already exists")
end

# Create sample data for development
if Mix.env() == :dev do
  alias JobSheet.JobManagement
  alias JobSheet.Accounts.User
  
  # Get the admin user
  admin = Accounts.get_user_by_email("admin@example.com")
  
  # Create sample categories
  {:ok, category1} = JobManagement.create_category(%{
    name: "Jahresrechnung 2024",
    description: "Alle Aufgaben für die Jahresrechnung 2024",
    user_id: admin.id
  })
  
  {:ok, category2} = JobManagement.create_category(%{
    name: "Quartalsabschluss Q1 2024",
    description: "Aufgaben für den Quartalsabschluss Q1",
    user_id: admin.id
  })
  
  # Create sample institutions
  {:ok, inst1} = JobManagement.create_institution(%{
    name: "Fachhochschule Graubünden",
    description: "FHGR - Hauptstandort Chur",
    contact_info: "Tel: 081 286 24 24",
    user_id: admin.id
  })
  
  {:ok, inst2} = JobManagement.create_institution(%{
    name: "Universität Zürich",
    description: "UZH - Hauptstandort",
    contact_info: "Tel: 044 634 11 11",
    user_id: admin.id
  })
  
  {:ok, inst3} = JobManagement.create_institution(%{
    name: "ETH Zürich",
    description: "Eidgenössische Technische Hochschule",
    contact_info: "Tel: 044 632 11 11",
    user_id: admin.id
  })
  
  # Create sample tasks
  JobManagement.create_task(%{
    title: "Bilanz erstellen",
    description: "Erstellung der Jahresbilanz mit allen Aktiven und Passiven",
    category_id: category1.id,
    institution_id: inst1.id
  }, admin.id)
  
  JobManagement.create_task(%{
    title: "Erfolgsrechnung prüfen",
    description: "Überprüfung aller Erträge und Aufwände",
    category_id: category1.id,
    institution_id: inst1.id
  }, admin.id)
  
  JobManagement.create_task(%{
    title: "Anhang verfassen",
    description: "Erstellung des Anhangs zur Jahresrechnung",
    category_id: category1.id,
    institution_id: inst2.id
  }, admin.id)
  
  JobManagement.create_task(%{
    title: "Revisorenbericht einholen",
    description: "Kontaktaufnahme mit Revisionsstelle und Terminvereinbarung",
    category_id: category1.id,
    institution_id: inst3.id
  }, admin.id)
  
  IO.puts("Sample data created successfully!")
end
