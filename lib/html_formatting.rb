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
      highlighted = code_highlighted_text(raw)
      linked = auto_link(highlighted) { |text| truncate(text, :length => 50) }
      textilized = ::RedCloth.new(linked, [:hard_breaks])
      textilized.hard_breaks = true if textilized.respond_to?("hard_breaks=")
      write_attribute "#{attr}_html", white_list_sanitizer.sanitize(textilized.to_html)
    end
  end

private
    
  def code_highlighted_text(text)
    text.gsub(/\<code name=\"(.*?)\"\>\s*(.*?)\<\/code\>/m) do
      begin
        result_text = CGI.unescapeHTML($2)
        colored = CodeRay.scan(result_text, $1)
        "\n<notextile>" + colored.html(:line_numbers => :inline, :wrap => :span) + "</notextile>"
      rescue
      end
    end unless text.nil?
  end

end
