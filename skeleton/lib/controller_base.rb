require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require 'byebug'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url, status_code = 302)
    raise 'Cannot render twice' if already_built_response?
    @res.status = status_code
    @res['location'] = url
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise 'Cannot render twice' if already_built_response?
    @already_built_response = false
    @res['Content-Type'] = content_type
    @res.write(content)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = File.dirname(File.dirname(__FILE__))
    controller_name = self.class.to_s.underscore
    new_path = File.join("#{path}/views/#{controller_name}/", "/#{template_name}.html.erb")
    file_content = File.read(new_path)
    erb_code = ERB.new(file_content).result(binding)
    render_content(erb_code, 'text/html')
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
