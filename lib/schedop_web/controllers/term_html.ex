defmodule SchedopWeb.TermHTML do
  use SchedopWeb, :html

  embed_templates "term_html/*"

  @doc """
  Renders a term form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def term_form(assigns)
end
