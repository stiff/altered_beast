require 'redcloth'
module HtmlFormatting

  protected
  
  def clear_dot_dot(text)
    # Workaround RedCloth bug corrupting text like "anyword.. any sentence"
    text.split("\n").map do |line| 
      if line =~ /([a-z]+)+(\.\.\s)/i
        line.gsub(/([a-z]+)+(\.\.\s)/i, $1 + "... ")
      else
        line
      end
    end.join("\n") unless text.nil?
  end

  
  def format_attributes
    self.class.formatted_attributes.each do |attr|
      raw    = clear_dot_dot(read_attribute attr)
      linked = auto_link(raw) { |text| truncate(text, :length => 50) }
      textilized = ::RedCloth.new(linked, [:hard_breaks])
      textilized.hard_breaks = true if textilized.respond_to?("hard_breaks=")
      write_attribute "#{attr}_html", white_list_sanitizer.sanitize(textilized.to_html)
    end
  end
end
