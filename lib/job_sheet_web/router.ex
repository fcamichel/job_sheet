defmodule JobSheetWeb.Router do
  use JobSheetWeb, :router

  import JobSheetWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JobSheetWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JobSheetWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Authentication routes
  scope "/", JobSheetWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{JobSheetWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", JobSheetWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{JobSheetWeb.UserAuth, :ensure_authenticated}] do
      live "/dashboard", DashboardLive.Index, :index
      live "/dashboard/categories/new", DashboardLive.Index, :new_category
      live "/dashboard/categories/:id/edit", DashboardLive.Index, :edit_category
      
      live "/dashboard/institutions/new", DashboardLive.Index, :new_institution
      live "/dashboard/institutions/:id/edit", DashboardLive.Index, :edit_institution
      
      live "/categories/:category_id", CategoryLive.Show, :show
      live "/categories/:category_id/tasks/new", CategoryLive.Show, :new_task
      live "/categories/:category_id/tasks/:id/edit", CategoryLive.Show, :edit_task
      live "/categories/:category_id/tasks/:id/history", CategoryLive.Show, :task_history
      
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", JobSheetWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{JobSheetWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  # Admin routes
  scope "/admin", JobSheetWeb do
    pipe_through [:browser, :require_authenticated_user, :require_admin_user]

    live "/users", Admin.UserLive.Index, :index
    live "/users/new", Admin.UserLive.Index, :new
    live "/users/:id/edit", Admin.UserLive.Index, :edit
  end

  if Application.compile_env(:job_sheet, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JobSheetWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
