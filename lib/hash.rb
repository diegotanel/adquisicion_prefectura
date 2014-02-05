class Hash
  # options:
  # :exclude => [keys] - keys need to be symbols
  def to_ostruct_recursive(options = {})
    convert_to_ostruct_recursive(self, options)
  end

  private

  def convert_to_ostruct_recursive(obj, options)
    result = obj
      if result.is_a? Hash
        result = result.dup
        result.each do |key, val|
          result[key] = convert_to_ostruct_recursive(val, options) unless options[:exclude].try(:include?, key)
        end
        result = OpenStruct.new result
      elsif result.is_a? Array
        result = result.map { |r| convert_to_ostruct_recursive(r, options) }
      end
    return result
  end

end