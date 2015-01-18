defmodule Entice.Skill do
  import Inflex

  defmacro __using__(_) do
    quote do
      import Entice.Skill

      @skills %{}
      @before_compile Entice.Skill
    end
  end


  defmacro defskill(skillname, opts, do_block \\ []) do
    skillid = Keyword.get(opts, :id)
    name = skillname |> elem(2) |> hd |> to_string
    uname = underscore(name)

    quote do
      # add the module
      defmodule unquote(skillname) do
        @behaviour Entice.Skill.Behaviour
        def id, do: unquote(skillid)
        def name, do: unquote(name)
        def underscore_name, do: unquote(uname)
        unquote(do_block)
      end
      # then update the stats
      @skills Map.put(@skills, unquote(skillid), unquote(skillname))
    end
  end


  defmacro __before_compile__(_) do
    quote do

      @doc """
      Simplistic skill getter.
      Either uses skill ID or tries to convert a skill name to the module atom.
      The skill should be a GW skill name in PascalCase.
      """
      def get_skill(id) when is_integer(id), do: Map.fetch(@skills, id)
      def get_skill(name) do
        try do
          {:ok, ((__MODULE__ |> Atom.to_string) <> "." <> name) |> String.to_existing_atom}
        rescue
          ArgumentError -> {:error, :skill_not_found}
        end
      end

      @doc "Get all skills that are known"
      def get_skills do
        @skills
        |> Map.to_list
        |> Enum.map(&(%{id: elem(&1, 0), skill: elem(&1, 1)}))
      end
    end
  end
end


defmodule Entice.Skill.Behaviour do
  use Behaviour

  @doc "Unique skill identitfier, resembles roughly GW"
  defcallback id() :: integer

  @doc "Unique skill name"
  defcallback name() :: String.t

  @doc "Unique skill name (snake case)"
  defcallback underscore_name() :: String.t

  @doc "General skill description"
  defcallback description() :: String.t

  @doc "Cast time of the skill in MS"
  defcallback cast_time() :: integer

  @doc "Recharge time of the skill in MS"
  defcallback recharge_time() :: integer
end