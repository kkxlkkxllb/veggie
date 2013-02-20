module Wali
	E_1 = %w{have has had to a an by on and in of from for were as be with was at been no also}
	E_2 = %w{his her i we he she my it the s}
	E_3 = %w{how where when who that but let what}
	E_4 = %w{before behind after}
	E_5 = %w{much more very}
	PERSON = %w{ms mr}
	NUMBER = %w{one two three four five six seven eight nine ten}
	
	class Base
		def filter(text)
			c = E_1 + E_2 + E_3 + E_4 + E_5 + PERSON + NUMBER
			reg = c.join("|")
			words = text.gsub(/(#{reg})\s/i,'')
			words = words.scan(/[a-zA-Z0-9_-]+/)
			words = words.uniq.map{ |x| [x,words.grep(x).length] }

			words.sort!{|a,b| b[1] <=> a[1]}.each{|s| p s}
		end
	end

	
end