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
end
