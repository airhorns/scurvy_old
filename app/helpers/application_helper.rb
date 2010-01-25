# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def length_of_time_in_words(seconds, short = true)
    if seconds 
      shortforms = %w[ yr mnth wk day hr min sec ]
      seconds = seconds.to_i
      %w[ year month week day hour minute second ].enum_for(:each_with_index).collect do |unit, i|
        unit_in_seconds = 1.send(unit).to_i
        n = seconds / unit_in_seconds
        seconds -= n * unit_in_seconds
        if short
          pluralize(n, shortforms[i]) unless n.zero?
        else
          pluralize(n, unit) unless n.zero?
        end
      end.compact.join(' ')
    end
  end
  
  def clock_from_ms(ms) 
    s = ms/1000
    puts s
    m = (s/60).floor
    puts m
    s = s - m * 60
    puts s
    "#{m}:#{s}"
  end
  
  def autocomplete_for_model(model, field='name')
    text_field_tag "auto_"+model+"_"+field, model.capitalize + ' Quick Search', {
      :class => 'autocomplete quicksearch span-3', 
      'basepath' => model.pluralize, 
      'autocomplete_url' => send( "autocomplete_for_"+model+"_"+field+"_"+model.pluralize+"_path")
    }
  end
  
  def link_to_if_both(text, path)
    return text if path.nil?
    link_to text, path
  end
  
  def peg(model)
    s = model.class.to_s.downcase!
    p = s.pluralize
    render :partial => "#{p}/#{s}_peg", :locals => { s.intern => model}
  end
end