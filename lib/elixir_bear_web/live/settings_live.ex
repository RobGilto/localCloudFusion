defmodule ElixirBearWeb.SettingsLive do
  use ElixirBearWeb, :live_view

  alias ElixirBear.Chat

  @impl true
  def mount(_params, _session, socket) do
    api_key = Chat.get_setting_value("openai_api_key") || ""
    system_prompt = Chat.get_setting_value("system_prompt") || ""

    socket =
      socket
      |> assign(:api_key, api_key)
      |> assign(:system_prompt, system_prompt)
      |> assign(:saved, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"api_key" => api_key, "system_prompt" => system_prompt}, socket) do
    Chat.update_setting("openai_api_key", api_key)
    Chat.update_setting("system_prompt", system_prompt)

    socket =
      socket
      |> assign(:api_key, api_key)
      |> assign(:system_prompt, system_prompt)
      |> assign(:saved, true)
      |> put_flash(:info, "Settings saved successfully!")

    # Clear the saved flag after 2 seconds
    Process.send_after(self(), :clear_saved, 2000)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:clear_saved, socket) do
    {:noreply, assign(socket, :saved, false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto p-6">
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Settings</h1>
        <p class="mt-2 text-gray-600">Configure your ChatGPT clone settings</p>
      </div>

      <.form for={%{}} phx-submit="save" class="space-y-6">
        <div>
          <label for="api_key" class="block text-sm font-medium text-gray-700 mb-2">
            OpenAI API Key
          </label>
          <input
            type="password"
            name="api_key"
            id="api_key"
            value={@api_key}
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            placeholder="sk-..."
          />
          <p class="mt-1 text-sm text-gray-500">
            Your OpenAI API key. Get one at
            <a
              href="https://platform.openai.com/api-keys"
              target="_blank"
              class="text-blue-600 hover:text-blue-700"
            >
              platform.openai.com
            </a>
          </p>
        </div>

        <div>
          <label for="system_prompt" class="block text-sm font-medium text-gray-700 mb-2">
            System Prompt
          </label>
          <textarea
            name="system_prompt"
            id="system_prompt"
            rows="6"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            placeholder="You are a helpful assistant..."
          ><%= @system_prompt %></textarea>
          <p class="mt-1 text-sm text-gray-500">
            Optional system prompt that will be used for all conversations (unless overridden per conversation)
          </p>
        </div>

        <div class="flex items-center gap-4">
          <button
            type="submit"
            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors"
          >
            Save Settings
          </button>

          <%= if @saved do %>
            <span class="text-green-600 text-sm flex items-center gap-1">
              <svg
                class="w-5 h-5"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M5 13l4 4L19 7"
                >
                </path>
              </svg>
              Saved!
            </span>
          <% end %>
        </div>
      </.form>

      <div class="mt-8 pt-8 border-t border-gray-200">
        <.link
          navigate={~p"/"}
          class="text-blue-600 hover:text-blue-700 flex items-center gap-2"
        >
          <svg
            class="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M10 19l-7-7m0 0l7-7m-7 7h18"
            >
            </path>
          </svg>
          Back to Chat
        </.link>
      </div>
    </div>
    """
  end
end
