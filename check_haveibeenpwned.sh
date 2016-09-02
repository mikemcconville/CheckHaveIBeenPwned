#Set the date format
DATE=$(date +"%Y%m%d%H%M")
mv ./output.txt ./output.txt.$DATE

#Output file
output_file=./output.txt

#Array of email addresses. Set one array per person being checked
first_emails=( "<EMAIL_ADDRESS>" "<EMAIL_ADDRESS>")
second_emails=( "<EMAIL_ADDRESS>" )

#Function to loop over an array and query each email address against haveibeenpwned.com
#Output to ./output.txt
function check_accounts {
	echo "Starting $1 account checks" >> $output_file

	incoming_array=$1[@]

	to_check=("${!incoming_array}")

	for i in "${to_check[@]}"
	do
		echo $i >> $output_file
		echo "Accounts:" >> $output_file
		curl -G https://haveibeenpwned.com/api/v2/breachedaccount/$i >> $output_file
		echo "
Pastes:" >> $output_file
		curl -G https://haveibeenpwned.com/api/v2/pasteaccount/$i >> $output_file
		echo "
" >> $output_file
	done
}

#List the email arrays here
all_emails=( first_emails second_emails )

echo "Starting account checks!" >> $output_file

#Loop through the arrays and check each account in each array
for n in "${all_emails[@]}"
do
	check_accounts $n
done

echo "All checks completed!" >> $output_file