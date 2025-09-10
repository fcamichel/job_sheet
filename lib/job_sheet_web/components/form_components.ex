defmodule JobSheetWeb.FormComponents do
  @moduledoc """
  Provides form UI components and helpers for working with forms.
  """

  use Phoenix.Component
  import JobSheetWeb.CoreComponents

  @doc """
  Renders a form field with label and error handling.

  ## Examples

      <.field field={@form[:email]} type="email" />
      <.field name="my-field" label="My Field" />
  """
  attr :field, Phoenix.HTML.FormField, doc: "a form field struct"
  attr :name, :string, doc: "the name of the field"
  attr :label, :string, doc: "the label for the field"
  attr :type, :string, default: "text", doc: "the input type"
  attr :required, :boolean, default: false, doc: "whether the field is required"
  attr :placeholder, :string, doc: "placeholder text"
  attr :class, :string, doc: "additional CSS classes"
  attr :rest, :global, doc: "additional HTML attributes"

  def field(assigns) do
    ~H"""
    <div class="space-y-2">
      <.label :if={@label} for={@field && @field.id} class="text-sm font-medium text-gray-700">
        <%= @label %>
        <span :if={@required} class="text-red-500">*</span>
      </.label>
      
      <.input
        :if={@field}
        field={@field}
        type={@type}
        class={["w-full", @class]}
        placeholder={@placeholder}
        {@rest}
      />
      
      <input
        :if={!@field}
        type={@type}
        name={@name}
        id={@name}
        class={[
          "w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm",
          "focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500",
          @class
        ]}
        placeholder={@placeholder}
        required={@required}
        {@rest}
      />
    </div>
    """
  end

  @doc """
  Renders a submit button for forms.

  ## Examples

      <.submit_button>Save</.submit_button>
      <.submit_button class="w-full">Submit</.submit_button>
  """
  attr :class, :string, default: nil, doc: "additional CSS classes"
  attr :disabled, :boolean, default: false, doc: "whether the button is disabled"
  attr :rest, :global, doc: "additional HTML attributes"
  slot :inner_block, required: true

  def submit_button(assigns) do
    ~H"""
    <.button
      type="submit"
      class={[
        "w-full sm:w-auto",
        @disabled && "opacity-50 cursor-not-allowed",
        @class
      ]}
      disabled={@disabled}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.button>
    """
  end

  @doc """
  Renders a form group for organizing related fields.

  ## Examples

      <.form_group>
        <.field field={@form[:first_name]} label="First Name" />
        <.field field={@form[:last_name]} label="Last Name" />
      </.form_group>
  """
  attr :class, :string, default: nil, doc: "additional CSS classes"
  slot :inner_block, required: true

  def form_group(assigns) do
    ~H"""
    <div class={["space-y-4", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a form section with a title and optional description.

  ## Examples

      <.form_section title="Personal Information">
        <.field field={@form[:name]} label="Name" />
      </.form_section>
  """
  attr :title, :string, required: true, doc: "the section title"
  attr :description, :string, doc: "optional section description"
  attr :class, :string, default: nil, doc: "additional CSS classes"
  slot :inner_block, required: true

  def form_section(assigns) do
    ~H"""
    <div class={["space-y-4", @class]}>
      <div>
        <h3 class="text-lg font-medium text-gray-900"><%= @title %></h3>
        <p :if={@description} class="mt-1 text-sm text-gray-600"><%= @description %></p>
      </div>
      <div class="space-y-4">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a checkbox field.

  ## Examples

      <.checkbox field={@form[:terms]} label="I agree to the terms" />
  """
  attr :field, Phoenix.HTML.FormField, required: true, doc: "a form field struct"
  attr :label, :string, required: true, doc: "the label for the checkbox"
  attr :class, :string, default: nil, doc: "additional CSS classes"

  def checkbox(assigns) do
    ~H"""
    <div class={["flex items-center space-x-2", @class]}>
      <.input field={@field} type="checkbox" />
      <.label for={@field.id} class="text-sm text-gray-700">
        <%= @label %>
      </.label>
    </div>
    """
  end

  @doc """
  Renders a select field with options.

  ## Examples

      <.select field={@form[:category]} label="Category" options={@categories} />
  """
  attr :field, Phoenix.HTML.FormField, required: true, doc: "a form field struct"
  attr :label, :string, required: true, doc: "the label for the select"
  attr :options, :list, required: true, doc: "list of {label, value} tuples"
  attr :prompt, :string, default: "Select an option", doc: "prompt text"
  attr :class, :string, default: nil, doc: "additional CSS classes"

  def select(assigns) do
    ~H"""
    <div class={["space-y-2", @class]}>
      <.label for={@field.id} class="text-sm font-medium text-gray-700">
        <%= @label %>
      </.label>
      
      <.input
        field={@field}
        type="select"
        prompt={@prompt}
        options={@options}
        class="w-full"
      />
    </div>
    """
  end

  @doc """
  Renders a textarea field.

  ## Examples

      <.textarea field={@form[:description]} label="Description" />
  """
  attr :field, Phoenix.HTML.FormField, required: true, doc: "a form field struct"
  attr :label, :string, required: true, doc: "the label for the textarea"
  attr :rows, :integer, default: 4, doc: "number of rows"
  attr :placeholder, :string, doc: "placeholder text"
  attr :class, :string, default: nil, doc: "additional CSS classes"

  def textarea(assigns) do
    ~H"""
    <div class={["space-y-2", @class]}>
      <.label for={@field.id} class="text-sm font-medium text-gray-700">
        <%= @label %>
      </.label>
      
      <.input
        field={@field}
        type="textarea"
        rows={@rows}
        placeholder={@placeholder}
        class="w-full"
      />
    </div>
    """
  end
end
