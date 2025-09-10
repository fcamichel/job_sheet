defmodule JobSheetWeb.Layouts do
  @moduledoc """
  This module contains different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "app" layout is the default application layout. Others
  are tailored for specific use cases.
  """
  use JobSheetWeb, :html

  embed_templates "layouts/*"
end
