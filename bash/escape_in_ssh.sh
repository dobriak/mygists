#I was trying to execute a sed command (insert some text near double quotes in a config file) over ssh 
# and ran into escaping problems, due to the way ssh handles special characters. 
#Here is the working solution (ruby):

output = ` ssh yourhosthere.com "sed -i '\''s/StringWithQuotes=\\\"/StringWithQuotes=\\\"additionalString,/g'\'' /path/to/your/file.conf"`  
