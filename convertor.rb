# https://github.com/caseyhoward/nokogiri-plist
require 'nokogiri-plist'

# /apps/gnome-terminal/profiles/Default
#  -> background_color
#  -> bold_color
#  -> foreground_color
#  -> palette

# Retrieve entries gconftool-2 --all-entries /apps/gnome-terminal/profiles/Default
# gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Consolas 10"
# gconftool-2 --set /apps/gnome-terminal/profiles/Default/foreground_color --type string "#AAAAAAAAAAAA"
# gconftool-2 --set /apps/gnome-terminal/profiles/Default/background_color --type string "#000000000000"
# gconftool-2 --set /apps/gnome-terminal/profiles/Default/palette --type string "#000000000000:#CDCD00000000:#0000CDCD0000:#CDCDCDCD0000:#00000000CDCD:#CDCD0000CDCD:#0000CDCDCDCD:#FAFAEBEBD7D7:#B18CB18CB18C:#E5E522222222:#A6A6E3E32D2D:#FCFC95951E1E:#C4C48D8DFFFF:#FAFA25257373:#6767D9D9F0F0:#F2F2F2F2F2F2"

def convert_to_key(real_color)
	return "%02X" % (real_color * 255)
end

def gconf2_command(gconf_key, gconf_type, gconf_value)
	return "gconftool-2 --set /apps/gnome-terminal/profiles/Default/#{gconf_key} --type #{gconf_type} \"#{gconf_value}\""
end

def get_rgb(doc_hash)
	red   = convert_to_key(doc_hash["Red Component"])
	green = convert_to_key(doc_hash["Green Component"])
	blue  = convert_to_key(doc_hash["Blue Component"])

	return "##{red}#{green}#{blue}"
end

ARGV.each do |iterm_theme|
	f              = open(iterm_theme)
	doc            = Nokogiri::PList(f)
	keys_to_export = Hash.new
	keys_to_export["palette"] = Array.new(16)

	doc.keys.each do |doc_key|
		if doc_key =~ /Ansi \d+ Color/
			slot  = doc_key.scan(/Ansi (\d+) Color/)[0][0].to_i
			hex   = get_rgb(doc[doc_key])
			keys_to_export["palette"][slot] = hex
		end

		if doc_key =~ /Background Color/
			# This goes directly to background_color
			hex   = get_rgb(doc[doc_key])
			keys_to_export["background_color"] = hex
		end

		if doc_key =~ /Foreground Color/
			# This goes directly to foreground_color
			hex   = get_rgb(doc[doc_key])
			keys_to_export["foreground_color"] = hex
		end

		if doc_key =~ /Bold Color/
			# This goes directly to bold color
			hex   = get_rgb(doc[doc_key])
			keys_to_export["bold_color"] = hex
		end
	end

	puts "# " + iterm_theme
	puts gconf2_command("foreground_color", "string", keys_to_export["foreground_color"])
	puts gconf2_command("background_color", "string", keys_to_export["background_color"])
	puts gconf2_command("bold_color", "string", keys_to_export["bold_color"])
	puts gconf2_command("palette", "string", keys_to_export["palette"].join(':'))
end
