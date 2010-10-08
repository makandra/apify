module ApifyHelper

  def api_docs_artifact(action, artifact, nature)
    show_id = "#{nature}_#{artifact}_for_#{action.uid}"
    show_link = link_to_function('show', "document.getElementById('#{show_id}').style.display = 'block';")
    download_url = url_for(:action => action.name, artifact.to_sym => nature.to_s)
    download_tooltip = "#{action.method.to_s.upcase} #{download_url} to download"
    download_link = link_to('download', download_url, :method => action.method, :title => download_tooltip)
    json = JSON.pretty_generate(action.send(artifact, nature))
    embedded = "<pre id='#{show_id}' style='display: none'><code>#{json}</code></pre>"
    "#{artifact.to_s.humanize} (#{show_link}, #{download_link})#{embedded}".html_safe
  end

end
