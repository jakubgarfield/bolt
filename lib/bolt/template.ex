defmodule Bolt.Template do
  def layout do
"""
<html>
<head>
  <title><%= @item.title %></title>
</head>
<body>
  <%= @content %>
</body>
</html>
"""
  end

  def index do
"""
---
title: Welcome to bolt!
---
# Welcome to bolt

The fastest and most awesome static site generator in Elixir.

All the awesome features like

* eex support
* markdown support
* layouts
"""
  end
end
