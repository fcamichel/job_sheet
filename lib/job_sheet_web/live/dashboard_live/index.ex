defmodule JobSheetWeb.DashboardLive.Index do
  use JobSheetWeb, :live_view

  alias JobSheet.JobManagement
  alias JobSheet.JobManagement.{Category, Institution}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:categories, list_categories())
     |> assign(:institutions, list_institutions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Dashboard")
    |> assign(:category, nil)
    |> assign(:institution, nil)
  end

  defp apply_action(socket, :new_category, _params) do
    socket
    |> assign(:page_title, "New Category")
    |> assign(:category, %Category{})
    |> assign(:institution, nil)
  end

  defp apply_action(socket, :edit_category, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Category")
    |> assign(:category, JobManagement.get_category!(id))
    |> assign(:institution, nil)
  end

  defp apply_action(socket, :new_institution, _params) do
    socket
    |> assign(:page_title, "New Institution")
    |> assign(:institution, %Institution{})
    |> assign(:category, nil)
  end

  defp apply_action(socket, :edit_institution, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Institution")
    |> assign(:institution, JobManagement.get_institution!(id))
    |> assign(:category, nil)
  end

  @impl true
  def handle_event("delete_category", %{"id" => id}, socket) do
    category = JobManagement.get_category!(id)
    {:ok, _} = JobManagement.delete_category(category)

    {:noreply,
     socket
     |> put_flash(:info, "Category deleted successfully")
     |> assign(:categories, list_categories())}
  end

  @impl true
  def handle_event("delete_institution", %{"id" => id}, socket) do
    institution = JobManagement.get_institution!(id)
    {:ok, _} = JobManagement.delete_institution(institution)

    {:noreply,
     socket
     |> put_flash(:info, "Institution deleted successfully")
     |> assign(:institutions, list_institutions())}
  end

  @impl true
  def handle_info({JobSheetWeb.DashboardLive.FormComponent, {:saved, :category}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Category saved successfully")
     |> assign(:categories, list_categories())}
  end

  @impl true
  def handle_info({JobSheetWeb.DashboardLive.FormComponent, {:saved, :institution}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Institution saved successfully")
     |> assign(:institutions, list_institutions())}
  end

  defp list_categories do
    JobManagement.list_categories()
  end

  defp list_institutions do
    JobManagement.list_institutions()
  end
end
