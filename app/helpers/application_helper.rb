# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def length_of_time_in_words(seconds)
    if seconds 
      seconds = seconds.to_i

      %w[ year month week day hour minute second ].collect do |unit|


        unit_in_seconds = 1.send(unit).to_i
        n = seconds / unit_in_seconds
        seconds -= n * unit_in_seconds

        pluralize(n, unit) unless n.zero?
      end.compact.to_sentence
    end
  end
end
