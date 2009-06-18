# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def is_selectioned_item(options)
    if(options[:action] != nil )
      return ((options[:controller] == @current_controller) and (options[:action] == @current_action));
    else
      return (options[:controller] == @current_controller);
    end
  end
end
