# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
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
    case model
    when 'track'
      path = "autocomplete_for_track_name_tracks_path"
    else
      path = "autocomplete_for_"+model+"_"+field+"_"+model.pluralize+"_path"
    end
    text_field_tag "auto_"+model+"_"+field, model.capitalize + ' Quick Search', {
      :class => 'autocomplete quicksearch span-3', 
      'basepath' => model.pluralize, 
      'autocomplete_url' => send(path)
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
  
  def link_to_download(resource, update = '')
    case resource.download.releases.length
    when 0
      return ""
    when 1
		  return link_to '', download_release_path(resource.download.releases.first), :class => "ss_sprite ss_arrow_down"
		else
		  return link_to "", {:action => "show", :id => resource.id},  
							:update => update, 
							:remote => true, 
							:success => "$('.filelink').effect('highlight', {}, 2000)});",
							:method => :get, 
							:class => "ss_sprite ss_arrow_down"
		end
	end
end